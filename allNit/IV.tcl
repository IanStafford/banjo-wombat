set radTest 0
set trapEn 1
set trapLevel 1.0

source fieldplate.tcl
source GaN_modelfile_masterD

window row=1 col=1

Initialize
device init


set f [open "figures/fpIV0.csv" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=0" xval=$d yval=$cur leg.left
}
close $f

source fieldplate.tcl
source GaN_modelfile_masterD

Initialize
device init
#set g -1.0
#contact name=G supply=$g
for {set g 0.0} {$g > -1.05} {set g [expr $g-0.5]} {
    contact name=G supply=$g
    device
}

set f [open "figures/fpIV1.csv" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-1" xval=$d yval=$cur leg.left
}
close $f

source fieldplate.tcl
source GaN_modelfile_masterD

Initialize
device init
#set g -2.0
#contact name=G supply=$g
for {set g 0.0} {$g > -2.05} {set g [expr $g-0.5]} {
    contact name=G supply=$g
    device
}

set f [open "figures/fpIV2.csv" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-2" xval=$d yval=$cur leg.left
}
close $f

source fieldplate.tcl
source GaN_modelfile_masterD

Initialize
device init
#set g -3.0
#contact name=G supply=$g
for {set g 0.0} {$g > -3.05} {set g [expr $g-0.5]} {
    contact name=G supply=$g
    device
}

set f [open "figures/fpIV3.csv" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-3" xval=$d yval=$cur leg.left
}
close $f

source fieldplate.tcl
source GaN_modelfile_masterD

Initialize
device init
#set g -4.0
#contact name=G supply=$g
for {set g 0.0} {$g > -4.05} {set g [expr $g-0.5]} {
    contact name=G supply=$g
    device
}

set f [open "figures/fpIV4.csv" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-4" xval=$d yval=$cur leg.left
}
close $f