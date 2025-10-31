proc nearHalfVolt {V {tol 0.001}} {
    set scaled [expr {$V / 0.5}]
    set frac [expr {abs($scaled - round($scaled))}]
    return [expr {$frac < ($tol / 0.5)}]
}

proc trapPlot {ivCSV trapLevel bias} {
    Initialize
    device init
# CURRENTLY VG=0
    for {set g 0.0} {$g < -2.05} {set g [expr $g-0.25]} {
        contact name=G supply=$g
        device
    }   

    set f [open $ivCSV w]
    close $f

    for {set d 0.0} {$d < [expr $bias + 0.001]} {set d [expr $d+0.1]} {
        set f [open $ivCSV a]
        contact name=D supply=$d
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}] 
        #FLOOXS GIVES A/um
        puts $f "$d, $cur"
        close $f
        chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left
        if { [nearHalfVolt $d 0.001] } {
            sel z=log10(abs(Acceptor)+1.0)
            plot1d graph=Vertical xv=0.018 ylab="TrapOccupation" title="TrapOccupationLevel" name="Vds=$d" log
            
            sel z=[expr {"Eval+3.1-Qfp"}]
            plot1d graph=Elec xv=0.018 ylab="Eval-Qfn(eV)" title="GaN" name="Vds=$d" 

            sel z=[expr {"Eval+3.4-Qfp"}]
            plot1d graph=Hole xv=0.01 ylab= "Econd-Qfn(eV)" title="AlGaN" name= "Vds=$d"
            #plot1d graph=Lateral yv=0.01 ylab="AcceptorTrapOccupation" title="TrapOccupationLevel" name="Vds=$d" penstyle=solid ymin=-0.5 ymax=0.5
        }        
    }
    if {0} {
        device time=10.0e-6 t.ini=1.0e-20 userstep=1.0e-12 movie= {

            set d [expr 2.1 + (0.1 * $Time) / 1.0e-6]
            contact name=D supply=$d


            set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}] 
            chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left
            if { [nearHalfVolt $d 0.001] } {
                sel z=log10(abs(Acceptor)+1.0)
                plot1d graph=Vertical xv=0.01 ylab="AcceptorTrapOccupation" title="TrapOccupationLevel" name="Vds=$d" log
                #plot1d graph=Lateral yv=0.01 ylab="AcceptorTrapOccupation" title="TrapOccupationLevel" name="Vds=$d" penstyle=solid ymin=-0.5 ymax=0.5
            }
        }
    }
    if {0} {
        for {set d 3.105} {$d < [expr $bias + 0.001]} {set d [expr $d+0.002]} {
            contact name=D supply=$d
            device
            set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}] 
            #FLOOXS GIVES A/um
            puts $f "$d, $cur"
            chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left
            if { [nearHalfVolt $d 0.01] } {
                sel z=log10(abs(Acceptor)+1.0)
                plot1d graph=Vertical xv=0.02 ylab="TrapOccupation" title="TrapOccupationLevel" name="Vds=$d" log
                #plot1d graph=Lateral yv=0.01 ylab="AcceptorTrapOccupation" title="TrapOccupationLevel" name="Vds=$d" penstyle=solid ymin=-0.5 ymax=0.5
            }        
        }
    }


}
window row=2 col=2
set trapEn 1

set trapLevel 3.4
source GaN_modelfile_masterD
source fieldplate.tcl
trapPlot "figures/acceptor_GaN_AlGaN_3.csv" $trapLevel 10.0