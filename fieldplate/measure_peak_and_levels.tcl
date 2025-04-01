proc measure_peak_and_levels {label vdsMAX} {

    # Loop over Vds values from 0.0 to 50.0 (approximately)
    set g -4.0
    contact name=G supply=$g

    for {set vds 0.0} {$vds < [expr $vdsMAX+0.1]} {set vds [expr $vds+0.25]} {
        contact name=D supply=$vds
        device
        sel z=abs(dot(DevPsi,y))*1.0e-4         
        set pstr [peak GaN]
        puts [peak GaN]
        set peakfield [lindex $pstr 1]
        
        # chart curve=$label xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field"

    }


    sel z=DevPsi
    plot2d levels=20
    plot2d xmax=0.5

}
