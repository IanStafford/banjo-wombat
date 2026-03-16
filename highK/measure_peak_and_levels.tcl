proc measure_peak_and_levels {label vdsMAX} {

    # Loop over Vds values from 0.0 to 50.0 (approximately)
    for {set g 0.0} {$g > -4.05} {set g [expr $g-0.5]} {
        contact name=G supply=$g
        device
    }

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

source rfdevice.tcl
source GaN_modelfile_masterD
pdbSetDouble HighK DevPsi RelEps 6.3

Initialize
device init

measure_peak_and_levels "SiN" 25