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

set radTest 0
set trapEn 0
set trapLevel 1.0

source GaN_modelfile_masterD
source fieldplate.tcl
pen name=low black
bandPlot 6.0 1 low

set trapLevel 1.0

source GaN_modelfile_masterD
source fieldplate.tcl
pen name=high red
bandPlot 10.0 0 high
