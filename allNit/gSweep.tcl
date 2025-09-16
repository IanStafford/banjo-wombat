proc gSweep {vds vgmin vgmax} {

    Initialize
    device init

    for {set d 0.0} {$d < [expr $vds + 0.01]} {set d [expr $d+0.25]} {
        contact name=D supply=$d
        device
    }

    for {set g 0.0} {$g < [expr $vgmax + 0.01]} {set g [expr $g+0.25]} {
        contact name=G supply=$g
        device
    }    

    for {set g $vgmax} {$g > [expr $vgmin-0.01]} {set g [expr $g-0.1]} {
        contact name=G supply=$g
        device
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}] 
        #FLOOXS GIVES A/um
        chart graph=IV curve=current xval=$g yval=$cur leg.left
    }
}
window row=1 col=1

set trapEn 0
set trapLevel 5.0
source fieldplate.tcl
source GaN_modelfile_masterD
gSweep 10.0 -6.0 4.0

