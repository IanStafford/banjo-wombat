proc trapPlot {trapLevel bias} {
    Initialize
    device init

    for {set d 0.0} {$d < [expr $bias + 0.01]} {set d [expr $d+0.1]} {
        contact name=D supply=$d
        device
        sel z=Acceptor
    }
    plot1d graph=Vertical xv=0.01 ylab="AcceptorTrapOccupation" title="TrapOccupationLevel" name="Vds=$bias" xmin=-0.5 xmax=0.5
    plot1d graph=Lateral yv=0.01 ylab="AcceptorTrapOccupation" title="TrapOccupationLevel" name="Vds=$bias" penstyle=solid ymin=-0.5 ymax=0.5


}
window row=1 col=2
set trapEn 1
set radTest 0

set trapLevel 5.0
source GaN_modelfile_masterD
source fieldplate.tcl
trapPlot $trapLevel 0.1

source GaN_modelfile_masterD
source fieldplate.tcl
trapPlot $trapLevel 0.5

source GaN_modelfile_masterD
source fieldplate.tcl
trapPlot $trapLevel 1.0

source GaN_modelfile_masterD
source fieldplate.tcl
trapPlot $trapLevel 2.0

source GaN_modelfile_masterD
source fieldplate.tcl
trapPlot $trapLevel 2.4