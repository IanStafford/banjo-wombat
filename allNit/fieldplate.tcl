pdbSetDouble Math iterLimit 800
math device dim=2 col umf none scale

mater add name=Metal
mater add name=Nitride
mater add name=GaN
mater add name=AlGaN
mater add name=HighK alias=highk
mater add name=HighK alias=Highk

math diffuse dim=2 umf none col !scale 
set Gate_Length 0.2
set SourceGate 1.0
set DrainGate 3.5
set SourceT 0.1
set DrainT 0.15
set FP2 0.8

set AlThick 0.015 ;# 15nm AlGaN thickness

# Parameters for the Gaussian radial cloud (exposed globals so other scripts can recompute)
set radBase -4.0e17
set radVscale 10.0
set sigma 0.015
set mean_x 0.0

proc HEMT_Struct { } {
    global Gate_Length AlThick SourceGate SourceT DrainGate DrainT FP2 radTest Vds radBase radVscale sigma mean_x mean_y

    #Structure definition (AlGaN is 25nm thick.It is below the critical thickness for relaxation ~65nm Ambacher)
    set Mid_Point 0.0
    set Gtl [expr {$Mid_Point - ($Gate_Length/2.0)}]
    set Gtr [expr {$Mid_Point + ($Gate_Length/2.0)}]
  
    set bot 7.5
    line x loc=-0.5 spac=0.025 tag=toptop
    line x loc=-0.4 spac=0.025 tag=top
    line x loc=-0.3 spac=0.025 tag=topIns
    line x loc=-0.15 spac=0.025 tag=topT
    line x loc=-0.10 spac=0.01 tag=topGate
    line x loc=-0.005 spac=0.001 tag=topGateIns
    line x loc=0.0 spac=0.001 tag=AlGaNTop
    line x loc=$AlThick spac=0.001 tag=AlGaNBottom
    line x loc=0.1 spac=0.01
    line x loc=7.5 spac=0.25 tag=BBottom

    line y loc=[expr $Gtl-$SourceGate-0.125] spac=0.05 tag=left
    line y loc=[expr $Gtl-$SourceT] spac=0.03 tag=SourceT
    line y loc=[expr $Gtl] spac=0.01 tag=GateL
    line y loc=[expr $Gtr] spac=0.001 tag=GateR
    line y loc=[expr $Gtr+$DrainT] spac=0.005 tag=DrainT
    line y loc=[expr $Gtr+$FP2] spac=0.02 tag=FP2
    line y loc=[expr $Gtr+$DrainGate] spac=0.05 
    line y loc=[expr $Gtr+$DrainGate+0.125] spac=0.05 tag=right

    #work layers top down, left to right
    region Nitride xlo=toptop xhi=top ylo=left yhi=right

    region Nitride xlo=top xhi=topIns ylo=left yhi=GateR
    region Metal xlo=top xhi=topIns ylo=GateR yhi=FP2
    region Nitride xlo=top xhi=topIns ylo=FP2 yhi=right

    #buffer between field plate and top of T gate
    region Nitride xlo=topIns xhi=topT ylo=left yhi=right

    #t gate layer
    region Nitride xlo=topT xhi=topGate ylo=left yhi=SourceT
    region Metal xlo=topT xhi=topGate ylo=SourceT yhi=DrainT
    region Nitride xlo=topT xhi=topGate ylo=DrainT yhi=right

    #gate layer
    region Nitride xlo=topGate xhi=AlGaNTop ylo=left yhi=GateL
    region Metal   xlo=topGate xhi=topGateIns ylo=GateL yhi=GateR
    region Nitride xlo=topGateIns xhi=AlGaNTop ylo=GateL yhi=GateR
    region Nitride xlo=topGate xhi=AlGaNTop ylo=GateR yhi=right

    #AlGaN GaN under gate
    region AlGaN xlo=AlGaNTop xhi=AlGaNBottom ylo=left yhi=right
    region GaN xlo=AlGaNBottom xhi=BBottom ylo=left yhi=right

    init 

    set buf 0.001

    #Contacts
    contact name=FP Metal xlo=[expr -0.4-$buf] xhi=[expr -0.4+$buf] ylo=[expr $Gtr] yhi=[expr $Gtr+$FP2] add depth=1.0 width=1.0
    contact name=G Metal xlo=[expr -0.15-$buf] xhi=[expr -0.15+$buf] ylo=[expr $Gtl] yhi=[expr $Gtr] add depth=1.0 width=1.0
    # contact name=G AlGaN xlo=[expr 0.0-$buf] xhi=0.001 ylo=[expr $Gtl+$buf] yhi=[expr $Gtr-$buf] add depth=1.0 width=1.0
    #contact name=G Nitride xlo=[expr -0.006] xhi=-0.001 ylo=[expr $Gtl+$buf] yhi=[expr $Gtr-$buf] add depth=1.0 width=1.0

    set l [expr $Gtl-$SourceGate-0.125] 
    contact name=S AlGaN ylo=[expr $l-$buf] yhi=[expr $l+$buf] xlo=[expr 0.0-$buf] xhi=[expr $AlThick-$buf] add depth=1.0 width=1.0
    set r [expr $Gtr+$DrainGate+0.125]
    contact name=D AlGaN ylo=[expr $r-$buf] yhi=[expr $r+$buf] xlo=[expr 0.0-$buf] xhi=[expr $AlThick-$buf] add depth=1.0 width=1.0
    contact name=B GaN xlo=[expr $bot-$buf]  xhi=[expr $bot+$buf] ylo=$l yhi=$r add depth=1.0 width=1.0

    contact name=G current=(Hole_Nitride-Elec_Nitride) voltage supply=0.0
    contact name=B current=(Hole_GaN-Elec_GaN) voltage supply=0.0
    contact name=D current=(Hole_GaN-Elec_GaN) voltage supply=0.0
    contact name=S current=(Hole_GaN-Elec_GaN) voltage supply=0.0
    contact name=FP voltage supply=0.0
      
    #doping definition-will use method from pfmos_qf deck for simplicity
    #GaN Doping-from Dessis file from Heller-acceptor-p-type
    sel z=-8e16*Mater(GaN) name=GaN_Doping

    #AlGaN Doping-from Dessis file from Heller-he puts equivalent donor and acceptor doping in region to signify traps
    sel z=1e12 name=AlGaN_Doping

    #Source and Drain contact doping-from contact to 2DEG like Heller-just to make contacts ohmic
    set le [expr $Gtl-$SourceGate]
    set re [expr $Gtr+$DrainGate]
    sel z=(1e19*(y>$re)+(y<=$re)*1.0e19*exp(-(y-$re)*(y-$re)/(1.5*0.02*0.02)))*(exp(-(x*x)/(2.0*0.03*0.03)))*(x>=0.0) name=Drain_Doping
    sel z=(1e19*(y<$le)+(y>=$le)*1.0e19*exp(-(y-$le)*(y-$le)/(1.5*0.02*0.02)))*(exp(-(x*x)/(2.0*0.03*0.03)))*(x>=0.0) name=Source_Doping

    # Gaussian distribution for single event charge deposition centered at x=0, y=Gtr
    # Expose mean_y so external procs can recompute Rad_Doping when Vds changes
    set mean_y [expr $Gtr + 0.34]

    # Ensure defaults exist for Vds
    if {![info exists Vds]} {
        set Vds 0.0
    }

    # initial Rad_Doping (will be recomputed by RecomputeRad during sweeps)
    set radAmp [expr {$radBase * (1.0 + ($Vds / $radVscale))}]
    sel z=$radAmp*exp(-((x-$mean_x)*(x-$mean_x)+(y-$mean_y)*(y-$mean_y))/(2.0*$sigma*$sigma)) name=Rad_Doping
    
    

    #Total doping
    sel z=GaN_Doping+AlGaN_Doping+Drain_Doping+Source_Doping+Rad_Doping name=Doping
    if {0} {
        window row=1 col=1
        sel z=Rad_Doping
        plot2d levels=20
        plot2d xmax=0.5
    }
    sel z=0.22 name=AlN_Ratio
}
HEMT_Struct

# Helper to explicitly recompute the radial Gaussian doping based on the current global Vds.
proc RecomputeRad {} {
    global radBase radVscale Vds sigma mean_x mean_y
    if {![info exists Vds]} { set Vds 0.0 }
    set radAmp [expr {$radBase * (1.0 + ($Vds / $radVscale))}]
    sel z=$radAmp*exp(-((x-$mean_x)*(x-$mean_x)+(y-$mean_y)*(y-$mean_y))/(2.0*$sigma*$sigma)) name=Rad_Doping
}

