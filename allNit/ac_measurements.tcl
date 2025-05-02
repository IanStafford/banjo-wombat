proc ac_measurements {} {
    for {set d 0.0} {$d <28.05} {set d [expr $d+0.5]} {
    contact name=D supply=$d
    device
    }
    set f 1.0
    while {$f < 5.0e10}  {   #freq sweep
        contact name=G supply=-0.025 acreal
        contact name=G supply=0.0 acimag
        device freq=$f

        set lf [expr (log10($f))]
        #set re_curg [expr log10(abs([contact name=G sol=Elec flux acreal])/0.025)]
        #set im_curg [expr log10(abs([contact name=G sol=Elec flux acimag])/0.025)]
        # These values being 0 means that there is 0 current through the gate
        # The gate is slightly biased so there should be some current
        #chart graph=WinA curve=Real xval=$lf yval=$re_curg xlab=Freq ylab=Siemens title= "Gate Current v. Freq" loglog
        #chart graph=WinA curve=Imag xval=$lf yval=$im_curg loglog

        set re_curd [expr log10(abs([contact name=D sol=Qfn flux acreal])/0.025)]
        #set im_curd [expr log10(abs([contact name=D sol=Qfn flux acimag])/0.025)]
        chart graph=WinB curve=TranReal xval=$lf yval=$re_curd xlab=Freq ylab=Siemens title= "Transconductance v. Freq" loglog
        #chart graph=WinB curve=TranImag xval=$lf yval=$im_curd loglog

        set f [expr $f * 2.0]
    }
}
