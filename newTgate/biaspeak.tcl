mater add name=GaN
mater add name=AlGaN
mater add name=HighK
mater add name=Metal

source bigate.tcl
source GaN_modelfile_masterD

#pdbSetDouble Nitride DevPsi RelEps 6.3
#InsPoisson Nitride
#pdbSetDouble HighK DevPsi RelEps 6.3
#InsPoisson HighK

Initialize
device init

contact name=D supply=0.1

window row=1 col=2

for {set g 0.0} {$g > -3.05} {set g [expr $g-0.1]} {
    contact name=G supply = $g
    device
    set cur [expr abs([contact name=D sol=Qfn flux])]
    chart graph=IV curve=IdsVgNit xval=$g yval=$cur leg.left
}

if {0} {
for {set vds 0.0} {$vds < 20.1} {set vds [expr $vds+0.25]} {
    contact name=D supply = $vds
    device
    sel z=sqrt(dot(DevPsi,DevPsi))
    set pstr [peak]
    puts [peak]
    set peakfield [lindex $pstr 1]
    chart graph=PeakField curve= PeakFieldNit xval= $vds yval= $peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field"
}
}


source bigate.tcl
pdbSetDouble Nitride DevPsi RelEps 35.0
InsPoisson Nitride
pdbSetDouble HighK DevPsi RelEps 35.0
InsPoisson HighK

Initialize
device init

contact name=D supply=0.1

for {set g 0.0} {$g > -3.05} {set g [expr $g-0.1]} {
    contact name=G supply = $g
    device
    set cur [expr abs([contact name=D sol=Qfn flux])]
    chart graph=IV curve=IdsVgHighK xval=$g yval=$cur leg.left
}

if {0} {
for {set vds 0.0} {$vds < 20.1} {set vds [expr $vds+0.25]} {
    contact name=D supply = $vds
    device
    sel z=sqrt(dot(DevPsi,DevPsi))
    set pstr [peak]
    puts [peak]
    set peakfield [lindex $pstr 1]
    chart graph=PeakField curve= PeakFieldHighK xval= $vds yval= $peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field"
}
}



source bigate.tcl
pdbSetDouble Nitride DevPsi RelEps 35.0
InsPoisson Nitride
pdbSetDouble HighK DevPsi RelEps 35.0
InsPoisson HighK

Initialize
device init
contact name=D supply=0.1

for {set g 0.0} {$g > -3.05} {set g [expr $g-0.1]} {
    contact name=G supply = $g
    device
    set cur [expr abs([contact name=D sol=Qfn flux])]
    chart graph=IV curve=IdsVgBiLayer xval=$g yval=$cur leg.left
}

if {0} {
for {set vds 0.0} {$vds < 20.1} {set vds [expr $vds+0.25]} {
    contact name=D supply = $vds
    device
    sel z=sqrt(dot(DevPsi,DevPsi))
    set pstr [peak]
    puts [peak]
    set peakfield [lindex $pstr 1]
    chart graph=PeakField curve= PeakFieldBiLayer xval= $vds yval= $peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field"
}
}




