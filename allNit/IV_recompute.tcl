#!/usr/bin/env flooxs
# IV sweep script that explicitly recomputes the Gaussian radial cloud before each solve
set radTest 0
set trapEn 0
set trapLevel 5

source fieldplate.tcl
source GaN_modelfile_masterD

window row=1 col=1

proc doSweepForGate {g outFile label} {
    Initialize
    device init

    # set gate
    contact name=G supply=$g
    device

    set f [open $outFile w]
    for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
        # update global Vds and explicitly recompute Rad_Doping
        set ::Vds $d
        if {[info proc RecomputeRad] != ""} {
            RecomputeRad
        }

        contact name=D supply=$d
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
        puts $f "$d, $cur"
        chart graph=IV curve=$label xval=$d yval=$cur leg.left
    }
    close $f
}

# Run sweeps at several gate voltages (0, -1, -2, -3, -4)
doSweepForGate 0.0 "figures/fpIV0_recompute.csv" "Vg=0"
doSweepForGate -1.0 "figures/fpIV1_recompute.csv" "Vg=-1"
doSweepForGate -2.0 "figures/fpIV2_recompute.csv" "Vg=-2"
doSweepForGate -3.0 "figures/fpIV3_recompute.csv" "Vg=-3"
doSweepForGate -4.0 "figures/fpIV4_recompute.csv" "Vg=-4"
