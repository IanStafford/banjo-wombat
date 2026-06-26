#proc trapPlot {ivCSV trapCSV {critBias 1.0} {finalBias 2.0} {gateBias -2.0} {sigma 0.015} {mean_x 0.0} {mean_y 0.14} {trapLevel 3.1} {trapWidth 0.025}} {

if {1} {
    set parts [split [lindex $argv 0] "|"]
    set ivCSV     [lindex $parts 0]
    set trapCSV   [lindex $parts 1]
    set critBias  [lindex $parts 2]
    set finalBias [lindex $parts 3]
    set gateBias  [lindex $parts 4]
    set sigma     [lindex $parts 5]
    set mean_x    [lindex $parts 6]
    set mean_y    [lindex $parts 7]
    set trapLevel [lindex $parts 8]
    set trapWidth [lindex $parts 9]
    set trapConc  [lindex $parts 10]
    set trapEn    [lindex $parts 11]
}
#if {$sigma == ""} { set sigma 0 }

puts "ivCSV=$ivCSV trapCSV=$trapCSV critBias=$critBias finalBias=$finalBias gateBias=$gateBias sigma=$sigma mean_x=$mean_x mean_y=$mean_y trapLevel=$trapLevel trapWidth=$trapWidth"

if {$sigma != ""} {

    source fieldplate.tcl
    source masterFile.tcl
    
    Initialize
    device init

    # Ramp up the gate
    for {set g 0.0} {$g > [expr {$gateBias - 0.05}]} {set g [expr $g-0.1]} {
        contact name=G supply=$g
        device
    }   

    # Reset files for IV and trap plots
    set f [open $ivCSV w]
    close $f
    set f2 [open $trapCSV w]
    close $f2

    # First loop is to get to the critical bias, then we can relax damping and go slower to get over the hump
    for {set d 0.0} {$d < [expr $critBias + 0.001]} {set d [expr $d+0.1]} {
        set f [open $ivCSV a]
        contact name=D supply=$d
        device
        #FLOOXS GIVES A/um so we correct by 1e6
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}] 
        # Put into the CSV file
        puts $f "$d, $cur"
        close $f
        # Plot the IV curve in the X window
        chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left
        # If we are near a half volt, plot the trap occupation and Qfn/Qfp/Eval
        if { [nearHalfVolt $d 0.001]} {
            sel z=log10(abs(Acceptor)+1.0)
            plot1d graph=Acceptor xv=0.025 xmax=0.5 xmin=0.0 ylab="AcceptorOccupation" title="Acceptor" name="Vds=$d" log
            # Write the trap occupation to a CSV file
            set $f2 [open $trapCSV a]
            puts $f2 [print1d xv=0.025]
            close $f2

            sel z=[expr {"Qfn"}]
            plot1d graph=Elec xv=0.025 ylab="Qfn(eV)" title="GaN" name="Vds=$d" 

            sel z=[expr {"Eval"}]
            plot1d graph=Val xv=0.025 ylab="Eval(eV)+2.6(eV)" title="GaN" name= "Vds=$d"
        } 
         
    }

    # Relax damping for Qfn/Qfp/DevPsi to improve convergence at critical Vds
    pdbSetDouble GaN Qfn DampValue 0.10
    pdbSetDouble GaN Qfp DampValue 0.10
    pdbSetDouble GaN DevPsi DampValue 0.10
    pdbSetDouble AlGaN Qfn DampValue 0.10
    pdbSetDouble AlGaN Qfp DampValue 0.10
    pdbSetDouble AlGaN DevPsi DampValue 0.10
    pdbSetDouble Nitride DevPsi DampValue 0.10


    for {set d $critBias} {$d < [expr $critBias + 0.1]} {set d [expr $d+0.0005]} {
        set f [open $ivCSV a]
        contact name=D supply=$d
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}] 
        #FLOOXS GIVES A/um
        puts $f "$d, $cur"
        close $f
        chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left
        if { [nearHalfVolt $d 0.001]} {
            sel z=log10(abs(Acceptor)+1.0)
            plot1d graph=Acceptor xv=0.025 xmax=0.5 xmin=0.0 ylab="AcceptorOccupation" title="Acceptor" name="Vds=$d" log
            set $f2 [open $trapCSV a]
            puts $f2 [print1d xv=0.025]
            close $f2

            sel z=[expr {"Qfn"}]
            plot1d graph=Elec xv=0.025 ylab="Qfn(eV)" title="GaN" name="Vds=$d" 

            sel z=[expr {"Eval"}]
            plot1d graph=Val xv=0.025 ylab="Eval(eV)+2.6(eV)" title="GaN" name= "Vds=$d"
        } 
    }

    for {set d [expr $critBias + 0.1]} {$d < [expr $finalBias + 0.1]} {set d [expr $d+0.01]} {
        set f [open $ivCSV a]
        contact name=D supply=$d
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}] 
        #FLOOXS GIVES A/um
        puts $f "$d, $cur"
        close $f
        chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left
        if { [nearHalfVolt $d 0.001]} {
            sel z=log10(abs(Acceptor)+1.0)
            plot1d graph=Acceptor xv=0.025 xmax=0.5 xmin=0.0 ylab="AcceptorOccupation" title="Acceptor" name="Vds=$d" log
            set $f2 [open $trapCSV a]
            puts $f2 [print1d xv=0.025]
            close $f2

            sel z=[expr {"Qfn"}]
            plot1d graph=Elec xv=0.025 ylab="Qfn(eV)" title="GaN" name="Vds=$d" 

            sel z=[expr {"Eval"}]
            plot1d graph=Val xv=0.025 ylab="Eval(eV)+2.6(eV)" title="GaN" name= "Vds=$d"
        } 
    }
}