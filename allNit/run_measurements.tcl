proc run_measurements {ivCSV peakCSV label} {
    # Source the provided Tcl file and the GaN model file
    Initialize
    device init

    if {1} {
    for {set d 0.0} {$d <6.05} {set d [expr $d+0.5]} {
    contact name=D supply=$d
    device
    }
    set f [open $ivCSV w]

    # Loop over gate voltage values from  10.0 down to -4.0 (approximately)
    # window row=1 col=2 make window declaration seperately to avoid new window for each run
    for {set g 0.0} {$g > -4.05} {set g [expr $g-0.1]} {
        contact name=G supply=$g
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}] 
        #FLOOXS GIVES A/um
        puts $f "$g, $cur"
        chart graph=IV curve=$label xval=$g yval=$cur leg.left
    }
    close $f
    }

    if {0} {
    for {set g 0.0} {$g <-4.0} {set d [expr $g-0.5]} {
        contact name=G supply=$g
        device
    }
    set f [open $peakCSV w]

    # Loop over Vds values from 0.0 to 20.0 (approximately)
    for {set vds 0.0} {$vds < 100.1} {set vds [expr $vds+0.25]} {
        contact name=D supply=$vds
        device
        sel z=abs(dot(DevPsi,y))*1.0e-4         
        set pstr [peak GaN]
        puts [peak GaN]
        set peakfield [lindex $pstr 1]
        puts $f "$vds, $peakfield"
        chart graph=PeakField curve=$label xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field"
    }
    close $f
    }
}