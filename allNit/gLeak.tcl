proc gateBias {outputFile bias} {
    Initialize
    device init

    set f [open $outputFile w]
    
    contact name=D supply=0.0
    device

    for {set g 0.0} {$g < [expr {$bias + 0.05}]} {set g [expr $g+0.1]} {
        contact name=G supply=$g
        device
        set curS [expr {abs([contact name=S sol=Qfn flux])*1.0e6}] 
        #FLOOXS GIVES A/um, this gives mA/mm
        puts $f "$g, $curS"
        chart graph=Source_Current curve=Source_Current xval=$g yval=$curS leg.left

        set curD [expr {[contact name=G sol=Qfn flux]*1.0e6}]
        chart graph=Drain_Current curve=Drain_Current xval=$g yval=$curD leg.left
    }
    close $f
}

set donkey 0
set radTest 0

source GaN_modelfile_masterD
source fieldplate.tcl
window row=1 col=2
gateBias "figures/gateBias.csv" 5.0