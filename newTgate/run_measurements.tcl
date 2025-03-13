 proc run_measurements {peakCSV label} {
    # Source the provided Tcl file and the GaN model file


    if {0} {
    # Loop over gate voltage values from 0.0 down to -4.0 (approximately)
    for {set g 0.0} {$g > -4.05} {set g [expr $g-0.1]} {
        contact name=G supply=$g
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}]
        chart graph=IV curve=$label xval=$g yval=$cur leg.left
    }
    }
    set f [open $peakCSV w]

    set g -4.0
    contact name=G supply=$g

    # Loop over Vds values from 0.0 to 20.0 (approximately)
    for {set vds 0.0} {$vds < 100.1} {set vds [expr $vds+0.25]} {
        contact name=D supply=$vds
        device
        sel z=abs(dot(DevPsi,y))*1.0e-4         
        set pstr [peak GaN]
        puts [peak GaN]
        set peakfield [lindex $pstr 1]
        puts $f $vds
        puts $f $peakfield
        chart graph=PeakField curve=$label xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field"
    }
    close $f
}
