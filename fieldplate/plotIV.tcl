source oops_all_nitride.tcl
source GaN_modelfile_masterD
Initialize
device init
window row=1 col=1

set f [open "newIV" w]

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
