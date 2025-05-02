source tgate_mod.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
Initialize
device init
window row=1 col=2

set f 1.0
while {$f < 5.0e11}  {   #freq sweep
        contact name=gate voltage supply=0.025 acreal
        contact name=gate voltage supply=0.0 acimag
        device freq=$f

        set lf [expr (log10($f))]
        set re_curg [expr log10(abs([contact name=gate sol=Elec flux acreal])/0.025)]
        set im_curg [expr log10(abs([contact name=gate sol=Elec flux acimag])/0.025)]
        chart graph=WinA curve=Real xval=$lf yval=$re_curg xlab=Freq ylab=Siemens title= "Gate Current v. Freq" loglog
        chart graph=WinA curve=Imag xval=$lf yval=$im_curg loglog

        set re_curd [expr log10(abs([contact name=drain sol=Elec flux acreal])/0.025)]
        set im_curd [expr log10(abs([contact name=drain sol=Elec flux acimag])/0.025)]
        chart graph=WinB curve=TranReal xval=$lf yval=$re_curd xlab=Freq ylab=Siemens title= "Transconductance v. Freq" loglog
        chart graph=WinB curve=TranImag xval=$lf yval=$im_curd loglog

        set f [expr $f * 2.0]
    }
}