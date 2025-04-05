if {0} {
source tgate.tcl
source GaN_modelfile_masterD
Initialize
device init
window row=1 col=2

set f [open "newIV.csv" w]

# Loop over gate voltage values from  10.0 down to -4.0 (approximately)
# window row=1 col=2 make window declaration seperately to avoid new window for each run
for {set g 0.0} {$g < 5.05} {set g [expr $g+1.0]} {
    Initialize
    device init
    contact name=G supply=$g
    device
    for {set d 0.0} {$d <6.05} {set d [expr $d+0.1]} {
        contact name=D supply=$d
        device
         set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}]
         puts $f "$d, $cur"
         chart graph=IV curve=$g xval=$d yval=$cur leg.left
    }
}
close $f

source fieldplate.tcl
source GaN_modelfile_masterD
Initialize
device init
window row=1 col=2

set f [open "newIV2.csv" w]

# Loop over gate voltage values from  10.0 down to -4.0 (approximately)
# window row=1 col=2 make window declaration seperately to avoid new window for each run
for {set g 0.0} {$g > -1.05} {set g [expr $g-0.1]} {
    contact name=G supply=$g
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}]
    puts $f "$g, $cur"
    chart graph=IV curve=$label xval=$g yval=$cur leg.left
}
for {set g 0.0} {$g < 5.05} {set g [expr $g+1.0]} {
    Initialize
    device init
    contact name=G supply=$g
    device
    for {set d 0.0} {$d <6.05} {set d [expr $d+0.1]} {
        contact name=D supply=$d
        device
         set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}]
         puts $f "$d, $cur"
         chart graph=IV2 curve=$g xval=$d yval=$cur leg.left
    }
}
close $f
}


# ===============================================================================
# ===============================================================================
# ===============================================================================


source oops_all_nitride.tcl
source GaN_modelfile_masterD

window row=1 col=1

Initialize
device init
set g 0.0
contact name=G supply=$g

set f [open "newIV0" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=0" xval=$d yval=$cur leg.left
}
close $f

source oops_all_nitride.tcl
source GaN_modelfile_masterD

Initialize
device init
#set g -1.0
#contact name=G supply=$g
for {set g 0.0} {$g > -1.05} {set g [expr $g-0.1]} {
    contact name=G supply=$g
    device
}

set f [open "newIV1" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-1" xval=$d yval=$cur leg.left
}
close $f

source oops_all_nitride.tcl
source GaN_modelfile_masterD

Initialize
device init
#set g -2.0
#contact name=G supply=$g
for {set g 0.0} {$g > -2.05} {set g [expr $g-0.1]} {
    contact name=G supply=$g
    device
}

set f [open "newIV2" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-2" xval=$d yval=$cur leg.left
}
close $f

source oops_all_nitride.tcl
source GaN_modelfile_masterD

Initialize
device init
#set g -3.0
#contact name=G supply=$g
for {set g 0.0} {$g > -3.05} {set g [expr $g-0.1]} {
    contact name=G supply=$g
    device
}

set f [open "newIV3" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-3" xval=$d yval=$cur leg.left
}
close $f

source oops_all_nitride.tcl
source GaN_modelfile_masterD

Initialize
device init
#set g -4.0
#contact name=G supply=$g
for {set g 0.0} {$g > -4.05} {set g [expr $g-0.1]} {
    contact name=G supply=$g
    device
}

set f [open "newIV4" w]

for {set d 0.0} {$d < 6.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-4" xval=$d yval=$cur leg.left
}
close $f