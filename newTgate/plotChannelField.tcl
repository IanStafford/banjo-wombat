proc plotChannelField {vdsMAX label} {
    window row=1 col=2

    Initialize
    device init
    contact name=D supply=0.05
    device

    # Loop over Vds values from 0.0 to 50.0 (approximately)
    set g -4.0
    contact name=G supply=$g

    for {set vds 0.0} {$vds < [expr $vdsMAX + 0.1]} {set vds [expr $vds+0.25]} {
        contact name=D supply=$vds
        device
        sel z=abs(dot(DevPsi,y))*1.0e-4         
        set pstr [peak GaN]
        puts [peak GaN]
        set peakfield [lindex $pstr 1]
        
        chart graph=PeakField curve=$label xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field"
        if { [expr {$vds - floor($vds/10)*10}] == 0 } {
            plot1d graph=Channel xv=0.015 ylab= "Electric Field (V/cm)" title= "Channel Field" name = "Vds = $vds"
        }
    }
}