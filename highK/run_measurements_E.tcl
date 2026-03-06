proc run_measurements_E {ivCSV peakCSV label} {
    # Source the provided Tcl file and the GaN model file
    Initialize
    device init

    if {1} {
    for {set d 0.0} {$d <1.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d
    device 
    }


    # Loop over gate voltage values from  10.0 down to -4.0 (approximately)
    # window row=1 col=2 make window declaration seperately to avoid new window for each run
    for {set g 0.0} {$g < 1.8} {set g [expr $g+0.05]} {
        contact name=G supply=$g
        device
        set f [open $ivCSV a]
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]; # converted to mA/mm
        #FLOOXS GIVES A/um
        puts $f "$g, $cur"
        close $f
        chart graph=IV curve=$label xval=$g yval=$cur leg.left title= "Vd=10V"
    }

    pdbSetDouble GaN Qfn DampValue 0.0512
    pdbSetDouble GaN Qfp DampValue 0.0512
    pdbSetDouble AlGaN Qfn DampValue 0.0512
    pdbSetDouble AlGaN Qfp DampValue 0.0512
    #pdbSetDouble AlGaN Qfn Rel.Error 5.0e-2
    #pdbSetDouble AlGaN Qfn Abs.Error 5.0e-2
    #pdbSetDouble AlGaN Qfn Rel.Error 5.0e-2
    #pdbSetDouble AlGaN Qfn Abs.Error 5.0e-2

    set eqn "ddt(Elec) + ([pdbDelayDouble AlGaN Elec mob]) * (Elec+1.0e4) * grad(Qfn)"
    pdbSetString AlGaN Qfn Equation $eqn

    device init
    for {set g 1.8} {$g < 5.0} {set g [expr $g+0.01]} {
        contact name=G supply=$g
        if {[catch {device}]} {
            puts "Timeout at G=$g, trying again"
            #set g [expr $g-0.005]
            device
        }
        set f [open $ivCSV a]
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]; # converted to mA/mm
        #FLOOXS GIVES A/um
        puts $f "$g, $cur"
        close $f
        chart graph=IV curve=$label xval=$g yval=$cur leg.left title= "Vd=10V"
    }

    }

    if {0} {
    for {set g 0.0} {$g <-4.0} {set d [expr $g-0.5]} {
        contact name=G supply=$g
        device
    }
    set f [open $peakCSV a]

    # Loop over Vds values from 0.0 to 50 (approximately)
    for {set vds 0.0} {$vds < 50.1} {set vds [expr $vds+0.5]} {
        contact name=D supply=$vds
        device
        sel z=abs(dot(DevPsi,y))*1.0e-4
        set pstr [peak GaN]
        puts [peak GaN]
        set peakfield [lindex $pstr 1]
        puts $f "$vds, $peakfield"
        chart graph=PeakField curve=$label xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field GaN"

        set pstr [peak AlGaN]
        puts [peak AlGaN]
        set peakfield [lindex $pstr 1]
        chart graph=PeakField_AlGaN curve=$label xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field AlGaN"
    }
    close $f
    }
}