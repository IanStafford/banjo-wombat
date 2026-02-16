pdbSetDouble Math iterLimit 250
math device dim=2 col umf none scale

mater add name=Metal
mater add name=Nitride
mater add name=GaN
mater add name=AlGaN

math diffuse dim=2 umf none col !scale 
set Gate_Length 1.2
set SourceGate 0.25
set SD_Length 1.1
set DrainGate 7.2
set SiN 0.08
set HPD 0.1
set pGaN 0.047
set gate_height 0.09
set FP2 0.5

set AlThick 0.015

proc HEMT_Struct { } {
    global Gate_Length AlThick SourceGate SD_Length DrainGate SiN HPD pGaN gate_height FP2

    #Structure definition (AlGaN is 25nm thick.It is below the critical thickness for relaxation ~65nm Ambacher)
    set Mid_Point 0.0
    set Gtl [expr {$Mid_Point - ($Gate_Length/2.0)}]
    set Gtr [expr {$Mid_Point + ($Gate_Length/2.0)}]
  
    set bot 7.5
    line x loc=-0.4 spac=0.05 tag=topInsulator
    line x loc=-0.28 spac=0.025 tag=topFP
    line x loc=-0.217 spac=0.025 tag=topSiN
    line x loc=-0.137 spac=0.025 tag=topGate
    line x loc=-0.08 spac=0.01 tag=bottomFP
    line x loc=-0.047 spac=0.005 tag=topP
    line x loc=0.0 spac=0.001 tag=AlGaNTop
    line x loc=$AlThick spac=0.001 tag=AlGaNBottom
    line x loc=0.1 spac=0.01
    line x loc=7.5 spac=0.25 tag=BBottom

    line y loc=[expr $Gtl-$SourceGate-$SD_Length] spac=0.05 tag=left
    line y loc=[expr $Gtl-$SourceGate] spac=0.05 tag=SourceContactR
    line y loc=[expr $Gtl-$SiN] spac=0.01 tag=LeftGateSiN
    line y loc=[expr $Gtl] spac=0.01 tag=GateL
    line y loc=0.0 spac=0.025 tag=FP_Left
    line y loc=[expr $Gtr] spac=0.005 tag=GateR
    line y loc=[expr $Gtr+$SiN] spac=0.01 tag=FP2_Left
    line y loc=[expr $Gtr+$FP2] spac=0.02 tag=FP2
    line y loc=[expr $Gtr+$DrainGate] spac=0.05 
    line y loc=[expr $Gtr+$DrainGate+$SD_Length] spac=0.05 tag=right

    #work layers top down, left to right
    # Top cap of HfO2
    region Nitride xlo=topInsulator xhi=topFP ylo=left yhi=right

    # Next layer including top part of field plate
    region Nitride xlo=topFP xhi=topSiN ylo=left yhi=FP_Left
    region Metal xlo=topFP xhi=topSiN ylo=FP_Left yhi=FP2
    region Nitride xlo=topFP xhi=topSiN ylo=FP2 yhi=right

    # Next layer including gate nitride and second part of field plate
    region Nitride xlo=topSiN xhi=bottomFP ylo=left yhi=LeftGateSiN
    region Nitride xlo=topSiN xhi=bottomFP ylo=LeftGateSiN yhi=GateL
    region Nitride xlo=topSiN xhi=topGate ylo=GateL yhi=GateR
    region Nitride xlo=topSiN xhi=bottomFP ylo=GateR yhi=FP2_Left
    region Metal xlo=topSiN xhi=bottomFP ylo=FP2_Left yhi=FP2
    region Nitride xlo=topSiN xhi=bottomFP ylo=FP2 yhi=right


    # Gate layer including pGaN and rest of nitride
    region Metal xlo=topGate xhi=topP ylo=GateL yhi=GateR 
    region Nitride xlo=bottomFP xhi=AlGaNTop ylo=left yhi=GateL
    region Nitride xlo=bottomFP xhi=AlGaNTop ylo=GateR yhi=right
    region GaN xlo=topP xhi=AlGaNTop ylo=GateL yhi=GateR

    #AlGaN GaN under gate
    region AlGaN xlo=AlGaNTop xhi=AlGaNBottom ylo=left yhi=right
    region GaN xlo=AlGaNBottom xhi=BBottom ylo=left yhi=right

    init 

    set buf 0.001

    #Contacts
    contact name=FP Metal xlo=[expr -0.28-$buf] xhi=[expr -0.22+$buf] ylo=[expr 0+$buf] yhi=[expr $FP2] add depth=1.0 width=1.0
    contact name=G GaN xlo=[expr -0.047-$buf] xhi=[expr -0.04+$buf] ylo=[expr $Gtl] yhi=[expr $Gtr] add depth=1.0 width=1.0
    # contact name=G AlGaN xlo=[expr 0.0-$buf] xhi=0.001 ylo=[expr $Gtl+$buf] yhi=[expr $Gtr-$buf] add depth=1.0 width=1.0
    # contact name=G Nitride xlo=[expr -0.006] xhi=-0.001 ylo=[expr $Gtl+$buf] yhi=[expr $Gtr-$buf] add depth=1.0 width=1.0

    set l [expr $Gtl-$SourceGate-$SD_Length] 
    contact name=S AlGaN ylo=[expr $l-$buf] yhi=[expr $l+$buf] xlo=[expr 0.0-$buf] xhi=[expr $AlThick-$buf] add depth=1.0 width=1.0
    set r [expr $Gtr+$DrainGate+$SD_Length]
    contact name=D AlGaN ylo=[expr $r-$buf] yhi=[expr $r+$buf] xlo=[expr 0.0-$buf] xhi=[expr $AlThick-$buf] add depth=1.0 width=1.0
    contact name=B GaN xlo=[expr $bot-$buf]  xhi=[expr $bot+$buf] ylo=$l yhi=$r add depth=1.0 width=1.0

    contact name=G current=(Hole_GaN-Elec_GaN) voltage supply=0.0
    contact name=B current=(Hole_GaN-Elec_GaN) voltage supply=0.0
    contact name=D current=(Hole_GaN-Elec_GaN) voltage supply=0.0
    contact name=S current=(Hole_GaN-Elec_GaN) voltage supply=0.0
    contact name=FP voltage supply=0.0
      
    #doping definition-will use method from pfmos_qf deck for simplicity
    #GaN Doping-from Dessis file from Heller-acceptor-p-type
    sel z=-8e15*Mater(GaN)*(x>0) name=GaN_Doping
    sel z=-1e20*Mater(GaN)*(x<=0) name=pGaN_Doping

    #AlGaN Doping-from Dessis file from Heller-he puts equivalent donor and acceptor doping in region to signify traps
    sel z=1e12 name=AlGaN_Doping

    #Source and Drain contact doping-from contact to 2DEG like Heller-just to make contacts ohmic
    set le [expr $Gtl-$SourceGate]
    set re [expr $Gtr+$DrainGate]
    sel z=(1e19*(y>$re)+(y<=$re)*1.0e19*exp(-(y-$re)*(y-$re)/(1.5*0.02*0.02)))*(exp(-(x*x)/(2.0*0.03*0.03)))*(x>=0.0) name=Drain_Doping
    sel z=(1e19*(y<$le)+(y>=$le)*1.0e19*exp(-(y-$le)*(y-$le)/(1.5*0.02*0.02)))*(exp(-(x*x)/(2.0*0.03*0.03)))*(x>=0.0) name=Source_Doping

    #Total doping
    sel z=GaN_Doping+AlGaN_Doping+Drain_Doping+Source_Doping+pGaN_Doping name=Doping

    sel z=0.22 name=AlN_Ratio
}
HEMT_Struct