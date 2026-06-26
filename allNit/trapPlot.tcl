# ─────────────────────────────────────────────────────────────────────────────
# trapPlot.tcl  —  Drain I-V sweep with acceptor-trap diagnostics
#
#   Ramps gate to vgBias, then sweeps drain 0 → vdsMax, logging I-V data
#   and 1-D depth profiles at every 0.5-V Vds increment.
#
# Key changes vs. original:
#   • Gate bias, trap energy offset, and cutline x are now proc parameters.
#   • Diagnostic sel expressions use Qfn (not Qfp) — correct reference for
#     acceptor/electron traps.
#   • Added "OccForce" plot: (Eval + eOffset − Qfn).
#       > 0 → trap above Fermi level → mostly empty / neutral
#       < 0 → trap below Fermi level → mostly occupied / ionized
#     If OccForce is always << 0 everywhere in the buffer, that confirms the
#     "always ionized" symptom; cross-check with your eOffset value.
#   • Removed dead f2 file handle.
#   • CSV now includes a header row.
# ─────────────────────────────────────────────────────────────────────────────

# Returns 1 if V is within tol of a half-volt multiple (0, 0.5, 1.0, …)
proc nearHalfVolt {V {tol 0.001}} {
    set scaled [expr {$V / 0.5}]
    set frac   [expr {abs($scaled - round($scaled))}]
    return     [expr {$frac < ($tol / 0.5)}]
}

# ─────────────────────────────────────────────────────────────────────────────
# trapPlot  ivCSV  vdsMax  ?vgBias?  ?eOffset?  ?cutX?
#
#   ivCSV    Path for drain I-V output CSV  (Vds_V, Id_uA_per_um)
#   vdsMax   Drain sweep endpoint [V]
#   vgBias   Gate hold voltage during the sweep        (default  -2.0 V)
#   eOffset  Trap energy above VBM used in diagnostics (default   2.6 eV)
#            For GaN (Eg ≈ 3.4 eV), a trap 0.78 eV below CBM sits
#            3.4 − 0.78 = 2.62 eV above VBM.  Tune to your Eval reference.
#   cutX     x-coordinate of the vertical 1-D cutline  (default 0.018 µm)
# ─────────────────────────────────────────────────────────────────────────────
proc trapPlot {ivCSV vdsMax {vgBias -2.0} {eOffset 2.6} {cutX 0.05}} {

    Initialize
    device init

    # ── Gate ramp ────────────────────────────────────────────────────────────
    # Step from 0 V down to vgBias in 0.1-V decrements.
    # The [expr {$vgBias - 0.05}] guard prevents floating-point overshoot.
    for {set g 0.0} {$g > [expr {$vgBias - 0.05}]} {set g [expr {$g - 0.1}]} {
        contact name=G supply=$g
        device
    }

    # ── Create I-V CSV with header ────────────────────────────────────────────
    set fIV [open $ivCSV w]
    puts $fIV "Vds_V,Id_uA_per_um"
    close $fIV

    # ── Drain sweep ───────────────────────────────────────────────────────────
    set step  0.05
    set limit [expr {$vdsMax + $step * 0.01}]   ;# small pad against float underrun

    for {set d 0.0} {$d < $limit} {set d [expr {$d + $step}]} {

        contact name=D supply=$d
        device

        # Current in µA/µm; FLOOXS contact flux is A/µm
        set cur [expr {abs([contact name=D sol=Qfn flux]) * 1.0e6}]
        set fIV [open $ivCSV a]
        puts $fIV "$d,$cur"
        close $fIV
        chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left

        # ── Diagnostic depth profiles at every 0.5-V Vds increment ──────────
        if {[nearHalfVolt $d 0.001]} {

            # 1 ── Acceptor trap occupation vs depth (log scale)
            sel z=log10(abs(Acceptor)+1.0)
            plot1d graph=Acceptor xv=$cutX xmin=0.0 xmax=0.5 \
                   ylab="AcceptorOccupation" \
                   title="Acceptor(Vg=${vgBias}V)" \
                   name="Vds=$d" log

            # 2 ── Electron quasi-Fermi level vs depth
            #      Correct reference for acceptor/electron traps.
            sel z=Qfn
            plot1d graph=Elec xv=$cutX xmin=0.0 xmax=0.5 \
                   ylab="Qfn(eV)" \
                   title="ElectronQuasi-FermiLevel" \
                   name="Vds=$d"

            # 3 ── Absolute trap energy vs depth
            #      Eval + eOffset places the trap at eOffset above the local VBM.
            #      Comparing this curve with Qfn on the same scale (see OccForce)
            #      shows where/whether the trap crosses the Fermi level.
            sel z=Eval+$eOffset
            plot1d graph=EtrapAbs xv=$cutX xmin=0.0 xmax=0.5 \
                   ylab="Eval+${eOffset}eV" \
                   title="TrapEnergy(abs)" \
                   name="Vds=$d"

            # 4 ── Occupancy driving force: E_trap − Qfn
            #      Positive  → trap above Fermi level → trap mostly empty
            #      Negative  → trap below Fermi level → trap mostly ionized
            #      A curve pinned negative everywhere in the GaN buffer confirms
            #      the "always ionized" condition and narrows the root cause
            #      to eOffset being too small or a residual Qfp/Qfn mismatch.
            sel z=Eval+$eOffset-Qfn
            plot1d graph=OccForce xv=$cutX xmin=0.0 xmax=0.5 \
                   ylab="E_trap-Qfn(eV)" \
                   title="OccupancyDrivingForce" \
                   name="Vds=$d"

            # 5 ── Net trap occupation (uncomment when donor traps are active)
            # sel z=Acceptor-Donor
            # plot1d graph=NetTrap xv=$cutX xmin=0.0 xmax=0.5 \
            #        ylab="Net Trap Occupation" title="Net Trap" name="Vds=$d"
        }
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# Top-level
# ─────────────────────────────────────────────────────────────────────────────
# Window layout (3 rows × 2 cols):
#   [IV]        [Acceptor]
#   [Elec/Qfn]  [EtrapAbs]
#   [OccForce]  [ spare   ]
window row=2 col=3

set trapEn 1
source GaN_modelfile_masterD
source fieldplate.tcl

trapPlot "figures/acceptor_GaN_AlGaN_6.csv" 5 -2.0 2.6 0.018









































if {0} {
proc nearHalfVolt {V {tol 0.001}} {
    set scaled [expr {$V / 0.5}]
    set frac [expr {abs($scaled - round($scaled))}]
    return [expr {$frac < ($tol / 0.5)}]
}

proc trapPlot {ivCSV bias} {
    Initialize
    device init

    for {set g 0.0} {$g > -2.05} {set g [expr $g-0.1]} {
        contact name=G supply=$g
        device
    }   

    set f [open $ivCSV w]
    close $f
    set f2 [open "figures/acceptor_GaN_AlGaN_6_AcceptorTrapOccupation_Vgm2.csv" w]

    for {set d 0.0} {$d < [expr 10.45 + 0.001]} {set d [expr $d+0.1]} {
        set f [open $ivCSV a]
        contact name=D supply=$d
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}] 
        #FLOOXS GIVES A/um
        puts $f "$d, $cur"
        close $f
        chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left
        if { [nearHalfVolt $d 0.001]} {
            sel z=log10(abs(Acceptor)+1.0)
            #sel z=Acceptor
            plot1d graph=Acceptor xv=0.018 xmax=0.5 xmin=0.0 ylab="AcceptorOccupation" title="Acceptor" name="Vds=$d" log
            #sel z=log10(abs(Donor)+1.0)
            #sel z=Donor
            #plot1d graph=Donor xv=0.018 xmax=0.5 xmin=0.0 ylab="DonorOccupation" title="Donor" name="Vds=$d" log

            #sel z=Acceptor-Donor name=NetTrap
            #plot1d graph=NetTrap xv=0.018 ylab="NetTrapOccupation" title="NetTrapOccupationLevel" name="Vds=$d"

            
            sel z=[expr {"Qfn"}]
            plot1d graph=Elec xv=0.018 ylab="Qfn(eV)" title="GaN" name="Vds=$d" 

            sel z=[expr {"Eval+2.6"}]
            plot1d graph=OccPlot xv=0.018 ylab="Eval(eV)+2.6(eV)" title="GaN" name= "Vds=$d"
            #plot1d graph=Hole xv=0.018 xmax=0.5 xmin=0.0 ylab="Econd(eV)-Qfn-Etrap" title="GaN" name= "Vds=$d"
            #plot1d graph=Lateral yv=0.01 ylab="AcceptorTrapOccupation" title="TrapOccupationLevel" name="Vds=$d" penstyle=solid ymin=-0.5 ymax=0.5
        } 
         
    }
    close $f2
    pdbSetDouble GaN Qfn DampValue 0.10
    pdbSetDouble GaN Qfp DampValue 0.10
    pdbSetDouble GaN DevPsi DampValue 0.10
    pdbSetDouble AlGaN Qfn DampValue 0.10
    pdbSetDouble AlGaN Qfp DampValue 0.10
    pdbSetDouble AlGaN DevPsi DampValue 0.10
    pdbSetDouble Nitride Qfn DampValue 0.10
    pdbSetDouble Nitride Qfp DampValue 0.10
    pdbSetDouble Nitride DevPsi DampValue 0.10


    for {set d 3.45} {$d < [expr $bias + 0.001]} {set d [expr $d+0.0005]} {
        set f [open $ivCSV a]
        contact name=D supply=$d
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}] 
        #FLOOXS GIVES A/um
        puts $f "$d, $cur"
        close $f
        chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left
        if { 1.0 } {
            sel z=log10(abs(Acceptor)+1.0)
            sel z=Acceptor
            plot1d graph=Acceptor xv=0.018 ylab="AcceptorOccupation" title="Acceptor" name="Vds=$d"
            #sel z=log10(abs(Donor)+1.0)
            #sel z=Donor
            #plot1d graph=Donor xv=0.018 xmax=0.5 xmin=0.0 ylab="DonorOccupation" title="Donor" name="Vds=$d" log

            #sel z=Acceptor-Donor name=NetTrap
            #plot1d graph=NetTrap xv=0.018 ylab="NetTrapOccupation" title="NetTrapOccupationLevel" name="Vds=$d"

            
            sel z=[expr {"Qfn"}]
            plot1d graph=Elec xv=0.018 ylab="Qfn(eV)" title="GaN" name="Vds=$d" 

            #sel z=[expr {"Econd-Qfn-0.59"}]
            #plot1d graph=Hole xv=0.018 xmax=0.5 xmin=0.0 ylab="Econd(eV)-Qfn-Etrap" title="GaN" name= "Vds=$d"
            #plot1d graph=Lateral yv=0.01 ylab="AcceptorTrapOccupation" title="TrapOccupationLevel" name="Vds=$d" penstyle=solid ymin=-0.5 ymax=0.5
        }        
    }

    if {0} {
        device time=10.0e-6 t.ini=1.0e-20 userstep=1.0e-12 movie= {

            set d [expr 2.1 + (0.1 * $Time) / 1.0e-6]
            contact name=D supply=$d


            set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}] 
            chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left
            if { [nearHalfVolt $d 0.001] and [d >  2.0   ]} {
                sel z=log10(abs(Acceptor)+1.0)
                plot1d graph=Vertical xv=0.01 ylab="AcceptorTrapOccupation" title="TrapOccupationLevel" name="Vds=$d" log
                #plot1d graph=Lateral yv=0.01 ylab="AcceptorTrapOccupation" title="TrapOccupationLevel" name="Vds=$d" penstyle=solid ymin=-0.5 ymax=0.5
            }
        }
    }

}
window row=2 col=2
set trapEn 1

source GaN_modelfile_masterD
source fieldplate.tcl
trapPlot "figures/acceptor_GaN_AlGaN_6.csv" 10

}