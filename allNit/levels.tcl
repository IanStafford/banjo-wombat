proc levels {label vdsMAX} {

    # Loop over Vds values from 0.0 to 50.0 (approximately)

    Initialize
    device init
    #set g -1.0
    #contact name=G supply=$g
    for {set g 0.0} {$g > -10.05} {set g [expr $g-0.5]} {
        contact name=G supply=$g
        device
    }

    for {set vds 0.0} {$vds < [expr $vdsMAX+0.1]} {set vds [expr $vds+0.25]} {
        contact name=D supply=$vds
        device

    }

    
    sel z=DevPsi
    #puts peak
    plot2d levels=20
    plot2d xmax=0.5
    #plot2d zmax=3e6

}

window row=1 col=1
set radTest 0
set trapEn 0
set trapLevel 1.0

source GaN_modelfile_masterD
source fieldplate.tcl

levels fieldplate 10.0