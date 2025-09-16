proc nearHalfVolt {V {tol 0.01}} {
    set scaled [expr {$V / 0.5}]
    set frac [expr {abs($scaled - round($scaled))}]
    return [expr {$frac < ($tol / 0.5)}]
}

proc trapPlot {ivCSV trapLevel bias} {
    Initialize
    device init

    for {set g 0.0} {$g > -2.0} {set g [expr $g-0.25]} {
        contact name=G supply=$g
        device
    }   

    set f [open $ivCSV w]

    for {set d 0.0} {$d < [expr $bias + 0.01]} {set d [expr $d+0.1]} {
        contact name=D supply=$d
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}] 
        #FLOOXS GIVES A/um
        puts $f "$d, $cur"
        chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left
        if { [nearHalfVolt $d 0.01] } {
            sel z=log10(abs(Acceptor)+1.0)
            plot1d graph=Vertical xv=0.01 ylab="AcceptorTrapOccupation" title="TrapOccupationLevel" name="Vds=$d" log
            #plot1d graph=Lateral yv=0.01 ylab="AcceptorTrapOccupation" title="TrapOccupationLevel" name="Vds=$d" penstyle=solid ymin=-0.5 ymax=0.5
        }        
    }

    close $f

}
window row=1 col=2
set trapEn 1
set radTest 0

set trapLevel 5.0
source GaN_modelfile_masterD
source fieldplate.tcl
trapPlot "figures/test.csv" $trapLevel 10.0