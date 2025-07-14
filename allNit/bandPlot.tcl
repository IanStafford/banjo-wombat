proc bandPlot {bias new penstyle} {
    if {$new} {
        window row=1 col=2
    }

    Initialize
    device init

    for {set d 0.0} {$d < [expr $bias+0.1]} {set d [expr $d+0.1]} {
    contact name=D supply=$d
    device
    }

    sel z=[expr {"Econd-Qfn"}]
    plot1d graph=Elec xv=0.01 ylab="Econd-Qfn(eV)" title="ConductingBandDiagram" name="Vds=$bias" penstyle=$penstyle

    sel z=[expr {"Eval-Qfp"}]
    plot1d graph=Hole xv=0.01 ylab= "Eval-Qfp (eV)" title= "ValenceBandDiagram" name= "Vds=$bias" penstyle=$penstyle


}
source GaN_modelfile_masterD
set radTest 1
source fieldplate.tcl
pen name=noRad black
bandPlot 10.0 1 noRad

set radTest 0
source fieldplate.tcl
pen name=rad red
bandPlot 10.0 0 rad
