

# ===============================================================================
# ===============================================================================
# ===============================================================================


source fieldplate_matchedGate.tcl
source GaN_modelfile_masterD

window row=1 col=1

Initialize
device init
set g 0.0
contact name=G supply=$g

set f [open "fpIV0" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=0" xval=$d yval=$cur leg.left
}
close $f

source fieldplate_matchedGate.tcl
source GaN_modelfile_masterD

Initialize
device init
#set g -1.0
#contact name=G supply=$g
for {set g 0.0} {$g > -1.05} {set g [expr $g-0.5]} {
    contact name=G supply=$g
    device
}

set f [open "fpIV1" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-1" xval=$d yval=$cur leg.left
}
close $f

source fieldplate_matchedGate.tcl
source GaN_modelfile_masterD

Initialize
device init
#set g -2.0
#contact name=G supply=$g
for {set g 0.0} {$g > -2.05} {set g [expr $g-0.5]} {
    contact name=G supply=$g
    device
}

set f [open "fpIV2" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-2" xval=$d yval=$cur leg.left
}
close $f

source fieldplate_matchedGate.tcl
source GaN_modelfile_masterD

Initialize
device init
#set g -3.0
#contact name=G supply=$g
for {set g 0.0} {$g > -3.05} {set g [expr $g-0.5]} {
    contact name=G supply=$g
    device
}

set f [open "fpIV3" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-3" xval=$d yval=$cur leg.left
}
close $f

source fieldplate_matchedGate.tcl
source GaN_modelfile_masterD

Initialize
device init
#set g -4.0
#contact name=G supply=$g
for {set g 0.0} {$g > -4.05} {set g [expr $g-0.5]} {
    contact name=G supply=$g
    device
}

set f [open "fpIV4" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-4" xval=$d yval=$cur leg.left
}
close $f