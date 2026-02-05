source fieldplate_highk.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0

Initialize
device init

window row=1 col=3


set vdsMAX 50.0

# Bring gate down to -4.0V
for {set g 0.0} {$g > -4.0} {set g [expr $g-0.25]} {
    contact name=G supply=$g
    device
}

# Loop over Vds values from 0.0 to 50.0 (approximately)
for {set vds 0.0} {$vds < [expr $vdsMAX + 0.1]} {set vds [expr $vds+0.25]} {
    contact name=D supply=$vds
    device
    sel z=abs(dot(DevPsi,y))*1.0e-4    
    # plot2d levels=20 xmax=0.5 <-- uncomment to see the field distribution
    set pstr [peak GaN]
    puts [peak GaN]
    set peakfield [lindex $pstr 1]
    
    chart graph=PeakField curve=HighK xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field"
    if { [expr {$vds - floor($vds/25)*25}] == 0 } {
        plot1d graph=Channel xv=0.018 ylab= "Electric Field (V/cm)" title= "Channel Field" name = "Vds = $vds"
    }
}


source fieldplate_highk.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 6.3

Initialize
device init

# Bring gate down to -4.0V
for {set g 0.0} {$g > -4.0} {set g [expr $g-0.25]} {
    contact name=G supply=$g
    device
}

# Loop over Vds values from 0.0 to 50.0 (approximately)
for {set vds 0.0} {$vds < [expr $vdsMAX + 0.1]} {set vds [expr $vds+0.25]} {
    contact name=D supply=$vds
    device

    # Calculate the peak electric field in the GaN layer and plot it against Vds
    sel z=abs(dot(DevPsi,y))*1.0e-4         
    set pstr [peak GaN]
    puts [peak GaN]
    set peakfield [lindex $pstr 1]
    
    chart graph=PeakField curve=SiN xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field"
    if { [expr {$vds - floor($vds/25)*25}] == 0 } {
        plot1d graph=Channel2 xv=0.018 ylab= "Electric Field (V/cm)" title= "Channel Field (With 50nm Nitride Layer)" name = "Vds = $vds"
    }
}