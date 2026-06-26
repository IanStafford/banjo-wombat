#!/usr/bin/env tclsh
# sensitivitySweep.tcl — sensitivity analysis for 2D Gaussian trap location.
#
# Sweeps the trap center across a specified range, spawning a separate FLOOXS
# instance per location.  Results (I-V CSVs + index) go to figures/sensitivity/.
#
# Usage — run from allNit/ with tclsh:
#   tclsh sensitivitySweep.tcl
#
# Override any parameter before running:
#   set trapDensity 5e18; set nTests 7; set sweepAxis xy
#   source sensitivitySweep.tcl

# ── Trap distribution parameters ──────────────────────────────────────────────
if {![info exists trapDensity]} { set trapDensity  3e18     }  ;# peak [cm^-3]
if {![info exists trapSigma]}   { set trapSigma    0.015    }  ;# Gaussian sigma [um]
if {![info exists trapType]}    { set trapType     Acceptor }  ;# Acceptor or Donor
if {![info exists trapEnergy]}  { set trapEnergy   3.1      }  ;# eV above VBM
if {![info exists trapWidth]}   { set trapWidth    0.025    }  ;# energy half-width [eV]

# ── Location sweep parameters ─────────────────────────────────────────────────
# sweepAxis  "y"  → N points along depth at fixed xCenter
#            "x"  → N points laterally at fixed yCenter
#            "xy" → ceil(sqrt(N)) × ceil(sqrt(N)) grid
if {![info exists sweepAxis]}   { set sweepAxis    y        }
if {![info exists nTests]}      { set nTests       5        }
if {![info exists xCenter]}     { set xCenter      0.0      }  ;# fixed x for y-sweep [um]
if {![info exists xMin]}        { set xMin        -0.05     }  ;# x range [um]
if {![info exists xMax]}        { set xMax         0.05     }
if {![info exists yCenter]}     { set yCenter      0.14     }  ;# fixed y for x-sweep [um]
if {![info exists yMin]}        { set yMin         0.05     }  ;# y range [um]
if {![info exists yMax]}        { set yMax         0.30     }

# ── trapPlot simulation parameters ───────────────────────────────────────────
if {![info exists vdsMax]}      { set vdsMax       5.0      }  ;# drain sweep endpoint [V]
if {![info exists vgBias]}      { set vgBias      -2.0      }  ;# gate hold bias [V]
if {![info exists eOffset]}     { set eOffset      2.6      }  ;# trap energy above VBM [eV]
if {![info exists cutX]}        { set cutX         0.018    }  ;# depth cutline x [um]

# ── Execution control ─────────────────────────────────────────────────────────
if {![info exists parallel]}    { set parallel     1        }  ;# 1=parallel batches, 0=serial
if {![info exists maxParallel]} { set maxParallel  4        }  ;# max simultaneous FLOOXS jobs
if {![info exists flooxsBin]}   { set flooxsBin    flooxs   }  ;# FLOOXS executable name/path
if {![info exists runPlotter]}  { set runPlotter   1        }  ;# run Python plotter when done

# ─────────────────────────────────────────────────────────────────────────────
# Paths
# ─────────────────────────────────────────────────────────────────────────────
set baseDir [pwd]
set outDir  [file join $baseDir figures sensitivity]
set runDir  [file join $outDir runs]
file mkdir $outDir
file mkdir $runDir

# ─────────────────────────────────────────────────────────────────────────────
# Helper: evenly-spaced list of n values in [lo, hi]
# ─────────────────────────────────────────────────────────────────────────────
proc linspace {lo hi n} {
    if {$n <= 1} { return [list [expr {($lo + $hi) / 2.0}]] }
    set pts {}
    for {set i 0} {$i < $n} {incr i} {
        lappend pts [expr {$lo + ($hi - $lo) * $i / double($n - 1)}]
    }
    return $pts
}

# ─────────────────────────────────────────────────────────────────────────────
# Helper: filesystem-safe tag string for a (x, y) coordinate pair
# ─────────────────────────────────────────────────────────────────────────────
proc makeTag {mx my} {
    set xtag [string map {. d - n} [format "%.4f" $mx]]
    set ytag [string map {. d - n} [format "%.4f" $my]]
    return "x${xtag}_y${ytag}"
}

# ─────────────────────────────────────────────────────────────────────────────
# Build test-point list
# ─────────────────────────────────────────────────────────────────────────────
set testPoints {}
switch $sweepAxis {
    y {
        foreach y [linspace $yMin $yMax $nTests] {
            lappend testPoints [list $xCenter $y]
        }
    }
    x {
        foreach x [linspace $xMin $xMax $nTests] {
            lappend testPoints [list $x $yCenter]
        }
    }
    xy {
        set nAx [expr {int(ceil(sqrt($nTests)))}]
        foreach x [linspace $xMin $xMax $nAx] {
            foreach y [linspace $yMin $yMax $nAx] {
                lappend testPoints [list $x $y]
            }
        }
    }
    default { error "sweepAxis must be y, x, or xy (got: $sweepAxis)" }
}
set nRuns [llength $testPoints]

puts "sensitivitySweep: $nRuns runs | axis=$sweepAxis | type=$trapType"
puts "  density=$trapDensity  sigma=$trapSigma um  energy=$trapEnergy eV"
puts "  vdsMax=$vdsMax V  vgBias=$vgBias V  eOffset=$eOffset eV  cutX=$cutX um"
puts "  parallel=$parallel  maxParallel=$maxParallel  flooxsBin=$flooxsBin"
puts "  Output: $outDir\n"

# ─────────────────────────────────────────────────────────────────────────────
# Write sensitivity_index.csv header (rows appended below)
# ─────────────────────────────────────────────────────────────────────────────
set idxPath [file join $outDir sensitivity_index.csv]
set fIdx [open $idxPath w]
puts $fIdx "run,mean_x_um,mean_y_um,trapDensity,trapSigma,trapType,trapEnergy,trapWidth,ivCSV"

# ─────────────────────────────────────────────────────────────────────────────
# Generate individual run scripts
# ─────────────────────────────────────────────────────────────────────────────
set runScripts {}

for {set i 0} {$i < $nRuns} {incr i} {
    set pt      [lindex $testPoints $i]
    set mx      [lindex $pt 0]
    set my      [lindex $pt 1]
    set tag     [makeTag $mx $my]
    set ivCSV   [file join $outDir "iv_${tag}.csv"]
    set runFile [file join $runDir "run_${i}.tcl"]

    set f [open $runFile w]
    puts $f "# Auto-generated by sensitivitySweep.tcl — run $i / [expr {$nRuns-1}]"
    puts $f "# Trap center: x=$mx um  y=$my um | type=$trapType density=$trapDensity sigma=$trapSigma"
    puts $f ""
    puts $f "window row=2 col=3"
    puts $f ""
    puts $f "# ── Trap parameters for this run ────────────────────────────────"
    puts $f "set sens_mean_x  $mx"
    puts $f "set sens_mean_y  $my"
    puts $f "set sens_density $trapDensity"
    puts $f "set sens_sigma   $trapSigma"
    puts $f "set sens_type    $trapType"
    puts $f "set sens_energy  $trapEnergy"
    puts $f "set sens_width   $trapWidth"
    puts $f ""
    puts $f "# ── Load parameterized model and device geometry ─────────────────"
    puts $f "source [file join $baseDir sensitivityModelfile.tcl]"
    puts $f "source [file join $baseDir fieldplate.tcl]"
    puts $f ""
    puts $f "# ── Load trapPlot proc ───────────────────────────────────────────"
    puts $f "source [file join $baseDir trapPlotProcs.tcl]"
    puts $f ""
    puts $f "# ── Run simulation ───────────────────────────────────────────────"
    puts $f "trapPlot {$ivCSV} $vdsMax $vgBias $eOffset $cutX"
    close $f

    puts $fIdx "$i,$mx,$my,$trapDensity,$trapSigma,$trapType,$trapEnergy,$trapWidth,$ivCSV"
    lappend runScripts $runFile
    puts "  Generated run_${i}.tcl : x=$mx  y=$my  →  [file tail $ivCSV]"
}

close $fIdx
puts "\nIndex: $idxPath"

# ─────────────────────────────────────────────────────────────────────────────
# Launch simulations
# ─────────────────────────────────────────────────────────────────────────────
puts "\n[string repeat - 60]"
puts "Launching FLOOXS simulations..."
puts "[string repeat - 60]\n"

if {$parallel} {
    # Batch parallel: up to maxParallel jobs at once using a shell "wait" group
    set total  [llength $runScripts]
    set bStart 0
    set bNum   0
    while {$bStart < $total} {
        set bEnd   [expr {min($bStart + $maxParallel, $total) - 1}]
        set batch  [lrange $runScripts $bStart $bEnd]
        set nBatch [llength $batch]

        # Write a small shell script so quoting is unambiguous
        set shFile [file join $runDir "batch_${bNum}.sh"]
        set fsh [open $shFile w]
        puts $fsh "#!/bin/sh"
        foreach s $batch {
            puts $fsh "$flooxsBin '$s' &"
        }
        puts $fsh "wait"
        close $fsh

        puts "  Batch $bNum (runs $bStart–$bEnd): $nBatch jobs in parallel..."
        if {[catch {exec sh $shFile} err] && $err ne ""} {
            puts "  Note: $err"
        }
        puts "  Batch $bNum complete."

        set bStart [expr {$bEnd + 1}]
        incr bNum
    }
} else {
    set i 0
    foreach s $runScripts {
        incr i
        puts "  \[$i/$nRuns\] [file tail $s]"
        if {[catch {exec $flooxsBin $s} err] && $err ne ""} {
            puts "  Note: $err"
        }
    }
}

puts "\nAll simulations complete.\n"

# ─────────────────────────────────────────────────────────────────────────────
# Post-process: invoke Python plotter
# ─────────────────────────────────────────────────────────────────────────────
if {$runPlotter} {
    set plotScript [file join $outDir plot_sensitivity.py]
    if {[file exists $plotScript]} {
        puts "Running Python plotter..."
        if {[catch {exec python3 $plotScript} out]} {
            puts "  Plotter: $out"
        } else {
            puts "  $out"
        }
    } else {
        puts "Plotter not found at $plotScript — skipping."
    }
}

puts "Done.  Results in: $outDir"
