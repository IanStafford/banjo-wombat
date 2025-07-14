    
    set radTest 0
    source fieldplate.tcl
    source GaN_modelfile_masterD
    Initialize
    device init
        window row=1 col=1


    for {set d 0.0} {$d <10.05} {set d [expr $d+0.5]} {
    contact name=D supply=$d
    device
    }

    # Loop over gate voltage values from  10.0 down to -4.0 (approximately)
    # window row=1 col=2 make window declaration seperately to avoid new window for each run
    for {set g 0.0} {$g > -4.05} {set g [expr $g-0.1]} {
        contact name=G supply=$g
        device
        sel z=DevPsi
        plot1d name=$g yval=0

    }
