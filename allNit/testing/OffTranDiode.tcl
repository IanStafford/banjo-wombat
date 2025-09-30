DevicePackage
math diffuse dim=1 umf none col !scale

solution add name=DevPsi solve negative damp
set eps [expr 11.8 * 8.854e-14 / 1.619e-19]
set Quasi 1

if { $Quasi } {
    solution add name=Qfn solve negative 
    solution add name=Qfp solve negative
    solution add name=Elec const solve val= "1.0e10*exp((DevPsi-Qfn)/0.025)"
    solution add name=Hole const solve val= "1.0e10*exp((Qfp-DevPsi)/0.025)"


    #set some very simple equations
    set eqnP "$eps * grad(DevPsi) + Doping - Elec + Hole"
    set eqnE "ddt(Elec) + 400.0 * Elec * grad(Qfn)"
    set eqnH "ddt(Hole) - 200.0 * Hole * grad(Qfp)"

    pdbSetDouble Si DevPsi DampValue 0.025
    pdbSetDouble Si DevPsi Abs.Error 1.0e-9
    pdbSetString Si DevPsi Equation $eqnP
    pdbSetDouble Si Qfn DampValue 0.025
    pdbSetDouble Si Qfn Abs.Error 1.0e-9
    pdbSetString Si Qfn Equation $eqnE
    pdbSetDouble Si Qfp DampValue 0.025
    pdbSetDouble Si Qfp Abs.Error 1.0e-9
    pdbSetString Si Qfp Equation $eqnH

    #top contact equations
	pdbSetBoolean top Qfn Flux 1
	pdbSetBoolean top Qfp Flux 1
	pdbSetBoolean top DevPsi Flux 1
	pdbSetBoolean top Qfn Fixed 1
	pdbSetBoolean top Qfp Fixed 1
	pdbSetBoolean top DevPsi Fixed 1
	pdbSetDouble top Qfn Flux.Scale 1.62e-19
	pdbSetDouble top Qfp Flux.Scale 1.62e-19
	pdbSetString top Qfn Equation "Qfn-top"
	pdbSetString top Qfp Equation "Qfp-top"
	pdbSetString top DevPsi Equation "Doping - Elec + Hole"
	pdbSetString top Equation "1.619e-19 * (Flux_Hole - Flux_Elec)"

    #bottom contact equations
	pdbSetBoolean bot Qfn Flux 1
	pdbSetBoolean bot Qfp Flux 1
	pdbSetBoolean bot DevPsi Flux 1
	pdbSetBoolean bot Qfn Fixed 1
	pdbSetBoolean bot Qfp Fixed 1
	pdbSetBoolean bot DevPsi Fixed 1
	pdbSetDouble bot Qfn Flux.Scale 1.62e-19
	pdbSetDouble bot Qfp Flux.Scale 1.62e-19
	pdbSetString bot Qfn Equation "Qfn-bot"
	pdbSetString bot Qfp Equation "Qfp-bot"
	pdbSetString bot DevPsi Equation "Doping - Elec + Hole"
	pdbSetString bot Equation "1.619e-19 * (Flux_Hole - Flux_Elec)"
} else {
    solution add name=Elec solve pde !negative
    solution add name=Hole solve pde !negative

    #set some very simple equations
    set eqnP "$eps * grad(DevPsi) + Doping - Elec + Hole"
    set eqnE "ddt(Elec) - 400.0 * 0.025 * sgrad(Elec, DevPsi/0.025)"
    set eqnH "ddt(Hole) - 200.0 * 0.025 * sgrad(Hole, -DevPsi/0.025)"

    pdbSetDouble Si DevPsi DampValue 0.025
    pdbSetDouble Si DevPsi Abs.Error 1.0e-9
    pdbSetString Si DevPsi Equation $eqnP
    pdbSetDouble Si Elec Abs.Error 1.0
    pdbSetString Si Elec Equation $eqnE
    pdbSetDouble Si Hole Abs.Error 1.0
    pdbSetString Si Hole Equation $eqnH

    pdbSetBoolean top Elec   Fixed 1
    pdbSetBoolean top Hole   Fixed 1
    pdbSetBoolean top DevPsi Fixed 1
    pdbSetString top Elec Equation {Doping - Elec + Hole}
    pdbSetString top Hole Equation {DevPsi + 0.025*log((Hole+1.0e-10)/1.0e10) - top}
    pdbSetString top DevPsi Equation {DevPsi - 0.025*log((Elec+1.0e-10)/1.0e10) - top}
    pdbSetDouble  top Elec   Flux.Scale 1.619e-19
    pdbSetDouble  top Hole   Flux.Scale 1.619e-19

    pdbSetBoolean bot Elec   Fixed 1
    pdbSetBoolean bot Hole   Fixed 1
    pdbSetBoolean bot DevPsi Fixed 1
    pdbSetString bot Hole Equation {Doping - Elec + Hole}
    pdbSetString bot Elec Equation {DevPsi + 0.025*log((Hole+1.0e-10)/1.0e10) - bot}
    pdbSetString bot DevPsi Equation {DevPsi - 0.025*log((Elec+1.0e-10)/1.0e10) - bot}
    pdbSetDouble  bot Elec   Flux.Scale 1.619e-19
    pdbSetDouble  bot Hole   Flux.Scale 1.619e-19
} 

#Create a simple diode structure
    line x loc=0.0 spac=0.01 tag=top
    line x loc=2.0 spac=0.01 tag=bot
    region xlo=top xhi=bot silicon
    init

    #add contacts
    contact name=top silicon xlo=-0.1 xhi=0.005 add supply =0.0
    contact name=bot silicon xlo=1.999 xhi=2.1 add supply =0.0

    #add doping and make initial guesses for DevPsi, Elec, Hole
    sel z=1.0e19*exp(-x*x/(0.2*0.2))-1.0e16 name=Doping
    sel z=0.5*(Doping+sqrt(Doping*Doping+4.0e20))/1.0e10 name=arg
    if {$Quasi} {
	sel z=0.025*log(arg/2.0) name=DevPsi
	sel z=0.0 name=Qfn
	sel z=0.0 name=Qfp
    } else {
	sel z=0.025*log(abs(arg)) name=DevPsi
	sel z=1.0e10*exp(DevPsi/0.025)  name=Elec
	sel z=1.0e10*exp(-DevPsi/0.025) name=Hole
    }

    device
    for {set Vss 0.0} {$Vss <1.01} {set Vss [expr $Vss+0.05]} {
	contact name=top supply=-$Vss
	device
    }

if {1} {
    window row=1 col=2 aqt

    sel z=log10(abs(Doping))
    plot1d graph=Conc name=Doping

    set cnt 0
    contact name=top supply=-1.0
    device time=2.0e-9 t.ini=1.0e-20 userstep=1.0e-11 movie= {
	#this is weird, yes?
	set VSS [expr 1.0 - $Time / 1.0e-9 ]
	if {$VSS < 0.0} {set VSS 0.0}
	contact name=top supply = [expr - $VSS]

	if { $cnt == 10 } {
	    sel z=log10(Elec)
	    plot1d graph=Conc name=Elec ymin=10 ymax=19
	    sel z=log10(Hole)
	    plot1d graph=Conc name=Hole ymin=10 ymax=19
	    set cnt 0
	} else {
	    incr cnt
	}

	if {$Quasi} {
	    set cur [expr (([contact name=top sol=Qfn flux] - [contact name=top sol=Qfp flux]))]
	    chart graph=IV curve=IV xval=$Time yval=$cur xlab = Time(s) 
	} else {
	    set cur [expr (([contact name=top sol=Elec flux] - [contact name=top sol=Hole flux]))]
	    chart graph=IV curve=IV xval=$Time yval=$cur xlab = Time(s) 
	}
    }
}
