proc measure_peak_and_levels {label} {
    # Source the provided Tcl file and the GaN model file

    # Loop over gate voltage values from 0.0 down to -4.0 (approximately)
    for {set g 0.0} {$g > -4.05} {set g [expr $g-0.1]} {
        contact name=G supply=$g
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}]
        #chart graph=IV curve=$label xval=$g yval=$cur leg.left
    }

    # Loop over Vds values from 0.0 to 50.0 (approximately)
    set g -4.0
    for {set vds 0.0} {$vds < 50.1} {set vds [expr $vds+0.25]} {
        contact name=D supply=$vds
        device
        sel z=abs(dot(DevPsi,y))*1.0e-4         
        set pstr [peak GaN]
        puts [peak GaN]
        set peakfield [lindex $pstr 1]
        
        chart graph=PeakField curve=$label xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field"
    }

    sel z=DevPsi
    plot2d levels=40
    plot2d xmax=0.5

}
