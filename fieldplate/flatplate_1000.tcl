    

pdbSetDouble Math iterLimit 800
math device dim=2 col umf none scale

mater add name=Metal
mater add name=Nitride
mater add name=GaN
mater add name=AlGaN
mater add name=HighK alias=highk
mater add name=HighK alias=Highk

math diffuse dim=2 umf none col !scale 
set Gate_Length 0.25
set SourceGate 1.0
set DrainGate 3.5
set SourceT 0.1
set DrainT 0.15
set FP2 0.8
set FPL 0.2
set FPR 2.0

set AlThick 0.018

proc HEMT_Struct { } {
    global Gate_Length AlThick SourceGate SourceT DrainGate DrainT FPL FPR

    #Structure definition (AlGaN is 25nm thick.It is below the critical thickness for relaxation ~65nm Ambacher)
    set Mid_Point 0.0
    set Gtl [expr {$Mid_Point - ($Gate_Length/2.0)}]
    set Gtr [expr {$Mid_Point + ($Gate_Length/2.0)}]
  
    set bot 4.0
    line x loc=-0.5 spac=0.025 tag=toptop
    # line x loc=-0.4 spac=0.025 tag=top
    # Moving field plate to side of T gate (100nm min seperation)
    # line x loc=-0.3 spac=0.025 tag=topIns
    line x loc=-0.15 spac=0.025 tag=topT
    line x loc=-0.10 spac=0.025 tag=topGate
    line x loc=0.0 spac=0.001 tag=AlGaNTop
    line x loc=$AlThick spac=0.001 tag=AlGaNBottom
    line x loc=0.1 spac=0.05
    line x loc=4.0 spac=0.25 tag=BBottom

    line y loc=[expr $Gtl-$SourceGate-0.125] spac=0.05 tag=left
    line y loc=[expr $Gtl-$SourceT] spac=0.03 tag=SourceT
    line y loc=[expr $Gtl] spac=0.025 tag=GateL
    line y loc=[expr $Gtr] spac=0.01 tag=GateR
    line y loc=[expr $Gtr+$DrainT] spac=0.01 tag=DrainT
    # line y loc=[expr $Gtr+$FP2] spac=0.02 tag=FP2
    #line y loc=[expr $Gtr+$DrainGate] spac=0.05 
    line y loc=[expr $Gtr+$DrainT+$FPL] spac=0.01 tag=SourceFP
    line y loc=[expr $Gtr+$DrainT+$FPL+$FPR] spac=0.1 tag=DrainFP
    line y loc=[expr $Gtr+$DrainGate+0.125] spac=0.05 tag=right

    #work layers top down, left to right
    region HighK xlo=toptop xhi=topT ylo=left yhi=right

    # region HighK xlo=top xhi=topIns ylo=left yhi=GateR
    # region Metal xlo=top xhi=topIns ylo=GateR yhi=FP2
    # region HighK xlo=top xhi=topIns ylo=FP2 yhi=right

    #buffer between field plate and top of T gate
    # region HighK xlo=topIns xhi=topT ylo=left yhi=right

    #t gate layer with field plate
    region HighK xlo=topT xhi=topGate ylo=left yhi=SourceT
    region Metal xlo=topT xhi=topGate ylo=SourceT yhi=DrainT
    region HighK xlo=topT xhi=topGate ylo=DrainT yhi=SourceFP
    region Metal xlo=topT xhi=topGate ylo=SourceFP yhi=DrainFP
    region HighK xlo=topT xhi=topGate ylo=DrainFP yhi=right

    #gate layer
    region Nitride xlo=topGate xhi=AlGaNTop ylo=left yhi=GateL
    region Metal   xlo=topGate xhi=AlGaNTop ylo=GateL yhi=GateR
    region Nitride xlo=topGate xhi=AlGaNTop ylo=GateR yhi=right

    #AlGaN GaN under gate
    region AlGaN xlo=AlGaNTop xhi=AlGaNBottom ylo=left yhi=right
    region GaN xlo=AlGaNBottom xhi=BBottom ylo=left yhi=right

    init 

    set buf 0.001

    #Contacts
    contact name=FP Metal xlo=[expr -0.15-$buf] xhi=[expr -0.15+$buf] ylo=[expr $Gtr+$DrainT+$FPL] yhi=[expr $Gtr+$DrainT+$FPL+$FPR] add depth=1.0 width=1.0
    contact name=G Metal xlo=[expr -0.15-$buf] xhi=[expr -0.15+$buf] ylo=[expr $Gtl] yhi=[expr $Gtr] add depth=1.0 width=1.0
    set l [expr $Gtl-$SourceGate-0.125] 
    contact name=S AlGaN ylo=[expr $l-$buf] yhi=[expr $l+$buf] xlo=[expr 0.0-$buf] xhi=[expr $AlThick-$buf] add depth=1.0 width=1.0
    set r [expr $Gtr+$DrainGate+0.125]
    contact name=D AlGaN ylo=[expr $r-$buf] yhi=[expr $r+$buf] xlo=[expr 0.0-$buf] xhi=[expr $AlThick-$buf] add depth=1.0 width=1.0
    contact name=B GaN xlo=[expr $bot-$buf]  xhi=[expr $bot+$buf] ylo=$l yhi=$r add depth=1.0 width=1.0

    contact name=G voltage supply=0.0
    contact name=B voltage supply=0.0
    contact name=D voltage supply=0.0
    contact name=S voltage supply=0.0
    contact name=FP voltage supply=0.0
      
    #doping definition-will use method from pfmos_qf deck for simplicity
    #GaN Doping-from Dessis file from Heller-acceptor-p-type
    sel z=-6.5e16*Mater(GaN)*(x>0.1) name=GaN_Doping

    #AlGaN Doping-from Dessis file from Heller-he puts equivalent donor and acceptor doping in region to signify traps
    sel z=1e12 name=AlGaN_Doping

    #Source and Drain contact doping-from contact to 2DEG like Heller-just to make contacts ohmic
    set le [expr $Gtl-$SourceGate]
    set re [expr $Gtr+$DrainGate]
    sel z=(1e19*(y>$re)+(y<=$re)*1.0e19*exp(-(y-$re)*(y-$re)/(1.5*0.02*0.02)))*(exp(-(x*x)/(2.0*0.03*0.03)))*(x>=0.0) name=Drain_Doping
    sel z=(1e19*(y<$le)+(y>=$le)*1.0e19*exp(-(y-$le)*(y-$le)/(1.5*0.02*0.02)))*(exp(-(x*x)/(2.0*0.03*0.03)))*(x>=0.0) name=Source_Doping

     #Total doping
    sel z=GaN_Doping+AlGaN_Doping+Drain_Doping+Source_Doping name=Doping
    sel z=0.22 name=AlN_Ratio
}

HEMT_Struct 

