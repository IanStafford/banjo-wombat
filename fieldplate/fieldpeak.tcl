pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
source fieldplate.tcl
source GaN_modelfile_masterD
Initialize
device init

contact name=D supply=0.1

window row=1 col=2
set f [open "IV1.csv" w]

for {set g 0.0} {$g > -4.05} {set g [expr $g-0.1]} {
    contact name=G supply = $g
    device
    set cur [expr abs([contact name=D sol=Qfn flux])*1.0e3]
    puts $f $g
    puts $f $cur
    chart graph=IV curve=IdsVgNit xval=$g yval=$cur leg.left ylab= "Current (mA/cm)" xlab = "V#dGS#u"
}

close $f

set f [open "peak1.csv" w]

for {set vds 0.0} {$vds < 20.1} {set vds [expr $vds+0.25]} {
    contact name=D supply = $vds
    device
    sel z=sqrt(dot(DevPsi,DevPsi))
    set pstr [peak]
    puts [peak]
    set peakfield [lindex $pstr 1]
    puts $f $vds
    puts $f $peakfield
    chart graph=PeakField curve= PeakFieldNit xval= $vds yval= $peakfield leg.left ylab = "Electric Field (V/cm)" xlab = "V#dDS#u"
}

close $f

pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
# source bigate.tcl
source fieldplate2.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

set f [open "IV2.csv" w]

for {set g 0.0} {$g > -4.05} {set g [expr $g-0.1]} {
    contact name=G supply = $g
    device
    set cur [expr abs([contact name=D sol=Qfn flux])*1.0e3]
    puts $f $g
    puts $f $cur
    chart graph=IV curve=IdsVgHighK xval=$g yval=$cur leg.left
}
close $f

set f [open "peak2.csv" w]

for {set vds 0.0} {$vds < 20.1} {set vds [expr $vds+0.25]} {
    contact name=D supply = $vds
    device
    sel z=sqrt(dot(DevPsi,DevPsi))
    set pstr [peak]
    puts [peak]
    set peakfield [lindex $pstr 1]
    puts $f $vds
    puts $f $peakfield
    chart graph=PeakField curve= PeakFieldHighK xval= $vds yval= $peakfield leg.left
}

close $f

pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
#source bigate.tcl
source fieldplate3.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

set f [open "IV3.csv" w]

for {set g 0.0} {$g > -4.05} {set g [expr $g-0.1]} {
    contact name=G supply = $g
    device
    set cur [expr abs([contact name=D sol=Qfn flux])*1.0e3]
    puts $f $g
    puts $f $cur
    chart graph=IV curve=IdsVgBiLayer xval=$g yval=$cur leg.left
}

close $f

set f [open "peak3.csv" w]

for {set vds 0.0} {$vds < 20.1} {set vds [expr $vds+0.25]} {
    contact name=D supply = $vds
    device
    sel z=sqrt(dot(DevPsi,DevPsi))
    set pstr [peak]
    puts [peak]
    set peakfield [lindex $pstr 1]
    puts $f $vds
    puts $f $peakfield
    chart graph=PeakField curve= PeakFieldBiLayer xval= $vds yval= $peakfield leg.left
}

close $f
