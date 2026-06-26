# trapPlotProcs.tcl — proc definitions only (no top-level simulation code).
# Source this after setting up the model to get nearHalfVolt and trapPlot.

proc nearHalfVolt {V {tol 0.001}} {
    set scaled [expr {$V / 0.5}]
    set frac   [expr {abs($scaled - round($scaled))}]
    return     [expr {$frac < ($tol / 0.5)}]
}

# trapPlot  ivCSV  vdsMax  ?vgBias?  ?eOffset?  ?cutX?
proc trapPlot {ivCSV vdsMax {vgBias -2.0} {eOffset 2.6} {cutX 0.05}} {

    Initialize
    device init

    for {set g 0.0} {$g > [expr {$vgBias - 0.05}]} {set g [expr {$g - 0.1}]} {
        contact name=G supply=$g
        device
    }

    set fIV [open $ivCSV w]
    puts $fIV "Vds_V,Id_uA_per_um"
    close $fIV

    set step  0.05
    set limit [expr {$vdsMax + $step * 0.01}]

    for {set d 0.0} {$d < $limit} {set d [expr {$d + $step}]} {

        contact name=D supply=$d
        device

        set cur [expr {abs([contact name=D sol=Qfn flux]) * 1.0e6}]
        set fIV [open $ivCSV a]
        puts $fIV "$d,$cur"
        close $fIV
        chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left

        if {[nearHalfVolt $d 0.001]} {

            sel z=log10(abs(Acceptor)+1.0)
            plot1d graph=Acceptor xv=$cutX xmin=0.0 xmax=0.5 \
                   ylab="AcceptorOccupation" \
                   title="Acceptor(Vg=${vgBias}V)" \
                   name="Vds=$d" log

            sel z=Qfn
            plot1d graph=Elec xv=$cutX xmin=0.0 xmax=0.5 \
                   ylab="Qfn(eV)" \
                   title="ElectronQuasi-FermiLevel" \
                   name="Vds=$d"

            sel z=Eval+$eOffset
            plot1d graph=EtrapAbs xv=$cutX xmin=0.0 xmax=0.5 \
                   ylab="Eval+${eOffset}eV" \
                   title="TrapEnergy(abs)" \
                   name="Vds=$d"

            sel z=Eval+$eOffset-Qfn
            plot1d graph=OccForce xv=$cutX xmin=0.0 xmax=0.5 \
                   ylab="E_trap-Qfn(eV)" \
                   title="OccupancyDrivingForce" \
                   name="Vds=$d"
        }
    }
}
