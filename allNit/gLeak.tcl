proc gateBias {outputFile bias} {
    Initialize
    device init

    set f [open $outputFile w]

    for {set g 0.0} {$g < [expr {$bias + 0.05}]} {set g [expr $g+0.1]} {
        contact name=G supply=$g
        device
        set curS [expr {abs([contact name=S sol=Qfn flux])*1.0e6}] 
        #FLOOXS GIVES A/um, this gives mA/mm
        
        chart graph=Source_Current curve=Source_Current xval=$g yval=$curS leg.left

        set curG [expr {[contact name=G sol=Qfn flux]*1.0e6}]
        chart graph=Gate_Current curve=Gate_Current xval=$g yval=$curG leg.left

        set curD [expr {[contact name=D sol=Qfn flux]*1.0e6}]
        chart graph=Drain_Current curve=Drain_Current xval=$g yval=$curD leg.left
        puts $f "$g, $curG, $curD, $curS"
    }
    close $f
}

set trapEn 1
set trapLevel 1.0
set radTest 0

source GaN_modelfile_masterD
source fieldplate.tcl
window row=1 col=3
gateBias "figures/gateBias.csv" 5.0