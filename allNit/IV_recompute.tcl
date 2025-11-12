# IV sweep script that explicitly recomputes the Gaussian radial cloud before each solve
set radTest 0
set trapEn 0
set trapLevel 5

source GaN_modelfile_masterD
source fieldplate.tcl


window row=1 col=3

proc nearHalfVolt {V {tol 0.001}} {
    set scaled [expr {$V / 0.5}]
    set frac [expr {abs($scaled - round($scaled))}]
    return [expr {$frac < ($tol / 0.5)}]
}

proc doSweepForGate {g outFile label} {
    set ::Vds 0.0
    Initialize
    device init

    # set gate
    contact name=G supply=$g
    device

    set f [open $outFile w]
    for {set d 0.0} {$d < 3.95} {set d [expr $d+0.1]} {
        # update global Vds and explicitly recompute Rad_Doping
        set ::Vds $d
        RecomputeRad
        

        contact name=D supply=$d
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
        puts $f "$d, $cur"
        chart graph=IV curve=$label xval=$d yval=$cur leg.left
        if {1} {
            if {[expr {[nearHalfVolt $d 0.001] && $d > 2.6}]} {
                sel z=[expr {"Eval+Qfp"}]
                plot1d graph=Elec xv=0.018 ylab="Eval+Qfp(eV)" title="Valence" name="Vds=$d"

                sel z=[expr {"Econd-Qfn"}]
                plot1d graph=Hole xv=0.018 ylab= "Econd-Qfn(eV)" title= "Conduction" name= "Vds=$d"
            }
        }

    }
    # smaller steps near knee
    for {set d 3.9} {$d < 4.051} {set d [expr $d+0.001]} {
        # update global Vds and explicitly recompute Rad_Doping
        set ::Vds $d
        RecomputeRad
        

        contact name=D supply=$d
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
        puts $f "$d, $cur"
        chart graph=IV curve=$label xval=$d yval=$cur leg.left
        if {1} {
            if {[expr {[nearHalfVolt $d 0.0001] && $d > 2.6}]} {
                sel z=[expr {"Eval+Qfp"}]
                plot1d graph=Elec xv=0.018 ylab="Eval+Qfp(eV)" title="Valence" name="Vds=$d"

                sel z=[expr {"Econd-Qfn"}]
                plot1d graph=Hole xv=0.018 ylab= "Econd-Qfn(eV)" title= "Conduction" name= "Vds=$d" 
            }
        }
    }    

    for {set d 4.05} {$d < 6.05} {set d [expr $d+0.01]} {
        # update global Vds and explicitly recompute Rad_Doping
        set ::Vds $d
        RecomputeRad
        

        contact name=D supply=$d
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
        puts $f "$d, $cur"
        chart graph=IV curve=$label xval=$d yval=$cur leg.left
        if {1} {
            if {[expr {[nearHalfVolt $d 0.0001] && $d > 2.6}]} {
                sel z=[expr {"Eval+Qfp"}]
                plot1d graph=Elec xv=0.018 ylab="Eval+Qfp(eV)" title="Valence" name="Vds=$d"

                sel z=[expr {"Econd-Qfn"}]
                plot1d graph=Hole xv=0.018 ylab= "Econd-Qfn(eV)" title= "Conduction" name= "Vds=$d" 
            }
        }
    }        

    close $f
}

# Run sweeps at several gate voltages (0, -1, -2, -3, -4)
doSweepForGate 0.0 "figures/fpIV0_recompute.csv" "Vg=0"
doSweepForGate -1.0 "figures/fpIV1_recompute.csv" "Vg=-1"
doSweepForGate -2.0 "figures/fpIV2_recompute.csv" "Vg=-2"
doSweepForGate -3.0 "figures/fpIV3_recompute.csv" "Vg=-3"
doSweepForGate -4.0 "figures/fpIV4_recompute.csv" "Vg=-4"
