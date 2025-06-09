pdbSetDouble Math iterLimit 800
math device dim=2 col umf none scale

mater add name=GaN
mater add name=AlGaN
mater add name=HighK
mater add name=Metal

math diffuse dim=2 umf none col !scale 

set Gate_Length 0.25
set Gate_Height 0.1
set Source_Gate 1.0
set Drain_Gate 3.5
set SourceTLength 0.15
set DrainTLength 0.15
set THeight 0.05
set FP_Gap 0.1
set FP_Width 0.2
set FP_Height 0.1

set AlGaNThick 0.015
set SiNThick 0.5
set Bottom 7.5



proc HEMT { } {
    global Gate_Length Source_Gate Drain_Gate SourceTLength DrainTLength FP_Gap FP_Width FP_Height AlGaNThick SiNThick Bottom THeight Gate_Height

    set Mid_Point 0.0
    set Gate_Left [expr {$Mid_Point - ($Gate_Length / 2.0)}]
    set Gate_Right [expr {$Mid_Point + ($Gate_Length / 2.0)}]


    # Lines
    line x loc=[expr {0.0-$SiNThick}] spac=0.025 tag=Top
    line x loc=[expr {0.0-$Gate_Height-$THeight-$FP_Gap-$FP_Height}] spac=0.025 tag=TopPlate
    line x loc=[expr {0.0-$Gate_Height-$THeight-$FP_Gap}] spac=0.025 tag=BottomPlate
    line x loc=[expr {0.0-$Gate_Height-$THeight}] spac=0.025 tag=TopT
    line x loc=[expr {0.0-$Gate_Height}] spac=0.025 tag=TopGate
    line x loc=[expr {0.0-$Gate_Height-$THeight-$FP_Gap+$FP_Width}] spac=0.025 tag=BottomPlate2
    line x loc=0.0 spac=0.025 tag = BottomGate
    line x loc=$AlGaNThick spac=0.001 tag=AlGaNBottom
    line x loc=0.1 spac=0.05 tag=BulkBottom
    line x loc=$Bottom spac=0.25 tag=Bottom

    line y loc=[expr {$Gate_Left - $Source_Gate}] spac=0.025 tag=Left
    line y loc=[expr {$Gate_Left - $SourceTLength}] spac=0.025 tag=SourceT
    line y loc=$Gate_Left spac=0.001 tag=LeftGate
    line y loc=$Gate_Right spac=0.001 tag=RightGate
    line y loc=[expr {$Gate_Right + $DrainTLength}] spac=0.025 tag=DrainT
    line y loc=[expr {$Gate_Right + $DrainTLength + $FP_Gap}] spac=0.025 tag=LeftPlate2
    line y loc=[expr {$Gate_Right + $FP_Gap + $FP_Width}] spac=0.025 tag=RightPlate
    line y loc=[expr {$Gate_Right+$DrainTLength + $FP_Gap + $FP_Height}] spac=0.025 tag=RightPlate2
    line y loc=[expr {$Gate_Right + $Drain_Gate}] spac=0.025 tag=Right

    # Regions
    # Nitride on top of the device
    region Nitride xlo=Top xhi=TopPlate ylo=Left yhi=Right

    # Nitride on left and right of plate 1, and plate 1 metal
    region Nitride xlo=TopPlate xhi=BottomPlate ylo=Left yhi=RightGate
    region Metal xlo=TopPlate xhi=BottomPlate ylo=RightGate yhi=RightPlate
    region Nitride xlo=TopPlate xhi=BottomPlate ylo=RightPlate yhi=Right

    
    # Nitride on top of the T, and plate 2 metal
    region Nitride xlo=BottomPlate xhi=TopT ylo=Left yhi=LeftPlate2
    region Nitride xlo=BottomPlate xhi=TopT ylo=RightPlate2 yhi=Right
    region Metal xlo=BottomPlate xhi=BottomPlate2 ylo=LeftPlate2 yhi=RightPlate2

    # Nitride and metal on the T
    region Nitride xlo=TopT xhi=TopGate ylo=Left yhi=SourceT
    region Metal xlo=TopT xhi=TopGate ylo=SourceT yhi=DrainT
    region Nitride xlo=TopT xhi=TopGate ylo=DrainT yhi=LeftPlate2
    region Nitride xlo=TopT xhi=TopGate ylo=RightPlate2 yhi=Right

    # Nitride and metal on the gate, as well as the 
    region Nitride xlo=TopGate xhi=BottomGate ylo=Left yhi=LeftGate
    region Metal xlo=TopGate xhi=BottomGate ylo=LeftGate yhi=RightGate
    region Nitride xlo=TopGate xhi=BottomGate ylo=RightGate yhi=Right

    # AlGaN and GaN under the gate
    region AlGaN xlo=BottomGate xhi=AlGaNBottom ylo=Left yhi=Right
    region GaN xlo=AlGaNBottom xhi=Bottom ylo=Left yhi=Right

    init

    
    set buffer 0.005
    # Contacts
   # contact name=FP Metal xlo=[expr -0.3] xhi=[expr -0.3+$buffer] ylo=[expr $Gate_Right+$FP_Gap] yhi=[expr $Gate_Right+$FP_Gap+$FP_Width] add depth=1.0 width=1.0
    contact name=FP Metal xlo=[expr {0.0-$Gate_Height-$THeight-$FP_Gap}] xhi=[expr {0.0-$Gate_Height-$THeight-$FP_Gap+$FP_Width}] ylo=[expr {$Gate_Right + $DrainTLength + $FP_Gap}] yhi=[expr {$Gate_Right+$DrainTLength + $FP_Gap + $FP_Height}] add depth=1.0 width=1.0
    #contact name=LP Metal xlo=[expr {0.0-$Gate_Height-$THeight-$FP_Gap-$FP_Height}] xhi=[expr {0.0-$Gate_Height-$THeight-$FP_Gap}] ylo=[expr {$Gate_Right}] yhi=[expr {$Gate_Right + $FP_Gap + $FP_Width}] add depth=1.0 width=1.0
    #contact name=RP Metal xlo=[expr {0.0-$Gate_Height-$THeight-$FP_Gap}] xhi=[expr {0.0-$Gate_Height-$THeight-$FP_Gap+$FP_Width}] ylo=[expr {$Gate_Right + $DrainTLength + $FP_Gap}] yhi=[expr {$Gate_Right+$DrainTLength + $FP_Gap + $FP_Height}] add depth=1.0 width=1.0
    #contact name=LP Metal xlo=[expr -0.3-$buffer] xhi=[expr -0.3+$buffer] ylo=[expr $RightGate] yhi=[expr $RightPlate] add depth=1.0 width=1.0
    #contact name=RP Metal xlo=[expr -0.15-$buffer] xhi=[expr -0.15+$buffer] ylo=[expr $LeftPlate2] yhi=[expr $RightPlate2] add depth=1.0 width=1.0
    contact name=G Metal xlo=[expr -0.15-$buffer] xhi=[expr -0.15+$buffer] ylo=[expr $Gate_Left] yhi=[expr $Gate_Right] add depth=1.0 width=1.0
    set l [expr $Gate_Left-$Source_Gate] 
    contact name=S AlGaN ylo=[expr $l-$buffer] yhi=[expr $l+$buffer] xlo=[expr 0.0-$buffer] xhi=[expr $AlGaNThick-$buffer] add depth=1.0 width=1.0
    set r [expr $Gate_Right+$Drain_Gate]
    contact name=D AlGaN ylo=[expr $r-$buffer] yhi=[expr $r+$buffer] xlo=[expr 0.0-$buffer] xhi=[expr $AlGaNThick-$buffer] add depth=1.0 width=1.0
    contact name=B GaN xlo=[expr $Bottom-$buffer]  xhi=[expr $Bottom+$buffer] ylo=$l yhi=$r add depth=1.0 width=1.0

    contact name=G voltage supply=0.0
    contact name=B voltage supply=0.0
    contact name=D voltage supply=0.0
    contact name=S voltage supply=0.0
    contact name=FP voltage supply=0.0


    
    #doping definition-will use method from pfmos_qf deck for simplicity
    #GaN Doping-from Dessis file from Heller-acceptor-p-type
    sel z=-5.0e15*Mater(GaN) name=GaN_Doping

    #AlGaN Doping-from Dessis file from Heller-he puts equivalent donor and acceptor doping in region to signify traps
    sel z=1e12 name=AlGaN_Doping

    #Source and Drain contact doping-from contact to 2DEG like Heller-just to make contacts ohmic
    set le [expr $Gate_Left-$Source_Gate]
    set re [expr $Gate_Right+$Drain_Gate]
    sel z=(1e19*(y>$re)+(y<=$re)*1.0e19*exp(-(y-$re)*(y-$re)/(1.5*0.02*0.02)))*(exp(-(x*x)/(2.0*0.03*0.03)))*(x>=0.0) name=Drain_Doping
    sel z=(1e19*(y<$le)+(y>=$le)*1.0e19*exp(-(y-$le)*(y-$le)/(1.5*0.02*0.02)))*(exp(-(x*x)/(2.0*0.03*0.03)))*(x>=0.0) name=Source_Doping

     #Total doping
    sel z=GaN_Doping+AlGaN_Doping+Drain_Doping+Source_Doping name=Doping
    sel z=0.22 name=AlN_Ratio
}
HEMT