source fieldplate.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
Initialize
device init
contact name=D supply=0.1
device
window row=1 col=3


# Loop over Vds values from 0.0 to 50.0 (approximately)
set g -4.0
set vdsMAX 100.0
contact name=G supply=$g

for {set vds 0.0} {$vds < [expr $vdsMAX + 0.1]} {set vds [expr $vds+0.25]} {
    contact name=D supply=$vds
    device
    sel z=abs(dot(DevPsi,y))*1.0e-4         
    set pstr [peak GaN]
    puts [peak GaN]
    set peakfield [lindex $pstr 1]
    
    chart graph=PeakField curve=Fieldplate xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field"
    if { [expr {$vds - floor($vds/25)*25}] == 0 } {
        plot1d graph=Channel xv=0.018 ylab= "Electric Field (V/cm)" title= "Channel Field" name = "Vds = $vds"
    }
}


source fp_HighK.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
Initialize
device init
contact name=D supply=0.1
device

for {set vds 0.0} {$vds < [expr $vdsMAX + 0.1]} {set vds [expr $vds+0.25]} {
    contact name=D supply=$vds
    device
    sel z=abs(dot(DevPsi,y))*1.0e-4         
    set pstr [peak GaN]
    puts [peak GaN]
    set peakfield [lindex $pstr 1]
    
    chart graph=PeakField curve=Fieldplate_HighK xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field"
    if { [expr {$vds - floor($vds/25)*25}] == 0 } {
        plot1d graph=Channel2 xv=0.018 ylab= "Electric Field (V/cm)" title= "Channel Field (With 50nm Nitride Layer)" name = "Vds = $vds"
    }
}