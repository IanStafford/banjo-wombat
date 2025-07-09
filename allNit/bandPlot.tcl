proc bandPlot {filename bias new} {
    if {$new} {
        window row=1 col=2
    }

    source GaN_modelfile_masterD
    source $filename
    Initialize
    device init

    for {set d 0.0} {$d < [expr $bias+0.1]} {set d [expr $d+0.1]} {
    contact name=D supply=$d
    device
    }

    sel z=[expr {"Econd-Qfn"}]
    plot1d graph=Elec xv=0.08 ylab="Econd-Qfn(eV)" title="ConductingBandDiagram" name="Vds=$bias"

    sel z=[expr {"Eval-Qfp"}]
    plot1d graph=Hole xv=0.08 ylab= "Eval-Qfp (eV)" title= "ValenceBandDiagram" name= "Vds=$bias"


}
bandPlot "fieldplate.tcl" 0.0 1
bandPlot "fieldplate.tcl" 2.0 0
bandPlot "fieldplate.tcl" 5.0 0
bandPlot "fieldplate.tcl" 10.0 0