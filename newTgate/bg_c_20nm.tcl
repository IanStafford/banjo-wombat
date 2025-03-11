DevicePackage

mater add name=Metal
mater add name=Oxide
mater add name=Nitride
mater add name=GaN
mater add name=AlGaN
mater add name=HighK alias=Highk
mater add name=HighK alias=highk

#***Set Gate dimensions****
set Gate_LengthT 1.5
set Gate_LengthB 1.0
set Mid_Point 0.0
set buf 0.01

#Compute edges of the gate
set Gtl [expr {$Mid_Point - ($Gate_LengthT/2.0)}]
set Gtr [expr {$Mid_Point + ($Gate_LengthT/2.0)}]
set Gbl [expr {$Mid_Point - ($Gate_LengthB/2.0)}]
set Gbr [expr {$Mid_Point + ($Gate_LengthB/2.0)}]

#***Set AlGaN thickness and how thick the passivation nitride is****
set Althick 0.015
set Buffer 0.02

pdbSetDouble Math iterLimit 800
math device dim=2 col umf none scale

#Set up solution for displacement 
solution name = displacement add solve dim continuous negative
#solution name = Temp add solve 

math diffuse dim=2 umf none col !scale 

#Structure definition (AlGaN is 25nm thick.It is below the critical thickness for relaxation ~65nm Ambacher)
  
    line x loc=-0.2 spac=0.01 tag=Gwt
    line x loc=-0.1 spac=0.01 tag=Gwb
    line x loc= [expr -$Buffer] spac=0.001 tag=Ox
    line x loc=0.0 spac=0.001 tag=AlGaNTop
    line x loc=$Althick spac=0.001 tag=AlGaNBottom
    line x loc=2.5 spac=0.1 tag=BBottom

    line y loc=-2.0 spac=0.02 tag=Left
    line y loc=-1.8 spac=0.05 tag=S1
    line y loc=$Gtl spac=0.05 tag=sidewL
    line y loc=$Gbl spac=0.02 tag=sidenL
    line y loc=$Gbr spac=0.02 tag=sidenR
    line y loc=$Gtr spac=0.05 tag=sidewR
    line y loc=1.8 spac=0.05 tag=D1
    line y loc=2.0 spac=0.02 tag=Right


    #Bulk
    region GaN xlo=AlGaNBottom xhi=BBottom ylo=Left yhi=Right

    #AlGaN under gate
    region AlGaN xlo=AlGaNTop xhi=AlGaNBottom ylo=Left yhi=Right

    #Metal alloy for T-gate
    region Metal xlo=Gwt xhi=Gwb ylo=sidewL yhi=sidewR
    region Metal xlo=Gwb xhi=AlGaNTop ylo=sidenL yhi=sidenR

    #Nitride cap layer 
    region HighK xlo=Gwt xhi=Gwb ylo=Left yhi=sidewL
    region HighK xlo=Gwt xhi=Gwb ylo=sidewR yhi=Right

    region HighK xlo=Gwb xhi=Ox ylo=Left yhi=sidenL
    region HighK xlo=Gwb xhi=Ox ylo=sidenR yhi=Right

    region Nitride xlo=Ox xhi=AlGaNTop ylo=Left yhi=sidenL
    region Nitride xlo=Ox xhi=AlGaNTop ylo=sidenR yhi=Right

    init 

    #Contacts
    contact name=G Metal xlo=-0.3 xhi=-0.15 ylo=[expr {$Gbl+$buf}] yhi=[expr {$Gbr-$buf}] add depth=1.0 width=1.0
    contact name=B GaN xlo=2.4 xhi=2.6 ylo=-2.0 yhi=2.0 add depth=1.0 width=1.0
    contact name=S AlGaN ylo=-2.0 yhi=-1.9 xlo=-0.7 xhi=0.01 add depth=1.0 width=1.0
    contact name=D AlGaN ylo=1.9 yhi=2.0 xlo=-0.7 xhi=0.01 add depth=1.0 width=1.0

    contact name=G current=(Hole_AlGaN-Elec_AlGaN) voltage supply=0.0
    contact name=B current=(Hole_GaN-Elec_GaN) voltage supply=0.0
    contact name=D current=(Hole_GaN-Elec_GaN) voltage supply=0.0
    contact name=S current=(Hole_GaN-Elec_GaN) voltage supply=0.0
      
    #GaN Doping-from Dessis file from Heller-acceptor-p-type
    sel z=-6.5e16*Mater(GaN)*(x>0.1) name=GaN_Doping

    #AlGaN Doping-from Dessis file from Heller-he puts equivalent donor and acceptor doping in region to signify traps
    sel z=1e12 name=AlGaN_Doping

    #Source and Drain contact doping-from contact to 2DEG like Heller-just to make contacts ohmic
    sel z=(1e19*(y>1.5)+(y<=1.5)*1.0e19*exp(-(y-1.5)*(y-1.5)/(1.5*0.02*0.02)))*(exp(-(x*x)/(2.0*0.03*0.03)))*(x>=0.0) name=Drain_Doping
    sel z=(1e19*(y<-1.5)+(y>=-1.5)*1.0e19*exp(-(y+1.5)*(y+1.5)/(1.5*0.02*0.02)))*(exp(-(x*x)/(2.0*0.03*0.03)))*(x>=0.0) name=Source_Doping

    #Total doping
    sel z=GaN_Doping+AlGaN_Doping+Drain_Doping+Source_Doping name=Doping
    sel z=0.1 name=AlN_Ratio

