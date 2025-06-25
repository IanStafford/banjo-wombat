source fieldplate_strike.tcl
source GaN_modelfile_masterD
window row=1 col=1
Initialize
#set g -3.0
#contact name=G supply=$g
for {set g 0.0} {$g > -3.05} {set g [expr $g-0.5]} {
    contact name=G supply=$g
    device
}

set f [open "strikeIV.csv" w]

for {set d 0.0} {$d < 10.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d 
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
    puts $f "$d, $cur"
    chart graph=IV curve="Vg=-3" xval=$d yval=$cur leg.left
}
close $f