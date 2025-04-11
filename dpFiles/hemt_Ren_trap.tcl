DevicePackage
pdbSetDouble Math iterLimit 1000
math device dim=2 col umf none scale
source GaN_modelfile_masterE.tcl
source Poisson.tcl

# Radiation effects in AlGaN/GaN HEMT based on TRIM calculations for various radiation dose, energy
# 2d case
# contact: Erin Patrick

proc Struct2D_coarse {} {

if {0} {
    line x loc=-0.291 spac=0.01 tag=MetTop
    line x loc=-0.087 spac=0.01 tag=Oxtop
    line x loc=0.0 spac=0.015 tag=AlGaNTop
    line x loc=0.014 spac=0.003 tag=AlGaNBottom
    line x loc=1.8 spac=0.55 tag=GaNBottom
    line x loc=2.0 spac=0.02 tag=AlNBottom
    line x loc=3.0 spac=1.5 tag=BBottom
    }
    
if {1} {    
    line x loc=-0.3 spac=0.01 tag=MetTop
    line x loc=-0.1 spac=0.01 tag=Oxtop
    line x loc=0.0 spac=0.015 tag=AlGaNTop
    line x loc=0.015 spac=0.003 tag=AlGaNBottom
    line x loc=1.8 spac=0.2 tag=GaNBottom
    line x loc=2.0 spac=0.02 tag=AlNBottom
    line x loc=3.0 spac=1.5 tag=BBottom
	}

if {0} {    
    line x loc=-0.3 spac=0.01 tag=MetTop
    line x loc=-0.1 spac=0.01 tag=Oxtop
    line x loc=0.0 spac=0.015 tag=AlGaNTop
    line x loc=0.030 spac=0.005 tag=AlGaNBottom
    line x loc=1.8 spac=0.55 tag=GaNBottom
    line x loc=2.0 spac=0.02 tag=AlNBottom
    line x loc=3.0 spac=1.5 tag=BBottom
}

if {0} {
    line y loc=-2.0 spac=0.05 tag=Left
    line y loc=-1.25 spac=0.1 
    line y loc=-0.2155 spac=0.1 tag=Oxleft
    line y loc=-0.0475 spac=0.01 tag=Oxgs
    line y loc=0.0 spac=0.01
    line y loc=0.0475 spac=0.01 tag=Oxgd
    line y loc=0.2155 spac=0.1 tag=Oxright
    line y loc=1.25 spac=0.1
    line y loc=2.0 spac=0.05 tag=Right
 }   
    
 if {0} {    ;#200nm
    line y loc=-2.0 spac=0.1 tag=Left
    line y loc=-1.25 spac=0.1 
    line y loc=-0.431 spac=0.1 tag=Oxleft
    line y loc=-0.095 spac=0.001 tag=Oxgs
    line y loc=0.0 spac=0.005
    line y loc=0.095 spac=0.001 tag=Oxgd
    line y loc=0.431 spac=0.1 tag=Oxright
    line y loc=1.25 spac=0.1
    line y loc=2.0 spac=0.1 tag=Right
 }   
 
 if {0} { ;# 1 um Tgate
    line y loc=-2.0 spac=0.05 tag=Left
    line y loc=-1.25 spac=0.1 
    line y loc=-0.75 spac=0.1 tag=Oxleft
    line y loc=-0.5 spac=0.01 tag=Oxgs
    line y loc=0.0 spac=0.01
    line y loc=0.5 spac=0.01 tag=Oxgd
    line y loc=0.75 spac=0.1 tag=Oxright
    line y loc=1.25 spac=0.1
    line y loc=2.0 spac=0.05 tag=Right
 }
 
 if {1} { ;# 1 um no t-gate
    line y loc=-2.0 spac=0.05 tag=Left  ;#was 0.05
    line y loc=-1.25 spac=0.1 
    line y loc=-0.5 spac=0.1 tag=Oxleft
    line y loc=-0.2 spac=0.01
    line y loc=0.0  spac=0.01
    line y loc=0.2 spac=0.01
    line y loc=0.5 spac=0.1 tag=Oxright
    line y loc=1.25 spac=0.1
    line y loc=2.0 spac=0.05 tag=Right   ;#was 0.05
 }
    #Bulk
    region SiC xlo=AlNBottom xhi=BBottom ylo=Left yhi=Right
   
    #thin AlN layer
    region AlN xlo=GaNBottom xhi=AlNBottom ylo=Left yhi=Right

    #Buffer
    region GaN xlo=AlGaNBottom xhi=GaNBottom ylo=Left yhi=Right

    #AlGaN under gate
    region AlGaN xlo=AlGaNTop xhi=AlGaNBottom ylo=Left yhi=Right

    #Oxides for t-gate
    #region oxide xlo=Oxtop xhi=AlGaNTop ylo=Left yhi=Oxgs
    #region oxide xlo=Oxtop xhi=AlGaNTop ylo=Oxgd yhi=Right
    #region oxide xlo=MetTop xhi=Oxtop ylo=Left yhi=Oxleft
    #region oxide xlo=MetTop xhi=Oxtop ylo=Oxright yhi=Right

    #metal in the middle
    #region metal xlo=Oxtop xhi=AlGaNTop ylo=Oxgs yhi=Oxgd
    #region metal xlo=MetTop xhi=Oxtop ylo=Oxleft yhi=Oxright

#no t-gate
	region oxide xlo=MetTop xhi=AlGaNTop ylo=Left yhi=Oxleft
    region oxide xlo=MetTop xhi=AlGaNTop ylo=Oxright yhi=Right
    region metal xlo=MetTop xhi=AlGaNTop ylo=Oxleft yhi=Oxright


    init 
    #Smooth AlGaN
    #Smooth GaN
    #Smooth SiC

    #Contacts
    contact name=G metal xlo=-0.29 xhi=0.003 ylo=-0.76 yhi=0.76 add depth=1.0 width=1 ;#for 1um length
    #contact name=G metal xlo=-0.19 xhi=0.001 ylo=-0.75 yhi=0.75 add depth=300.0 width=1.0
    contact name=B SiC xlo=2.4 xhi=9.0 add depth=1.0 width=1
    contact name=S AlGaN ylo=-3.4 yhi=-1.99 xlo=-1.0 xhi=0.014 add depth=1.0 width=1
    contact name=D AlGaN ylo=1.99 yhi=3.4 xlo=-1.0 xhi=0.014 add depth=1.0 width=1
}


proc Struct2D {} {

    #Structure definition
    if {0} {
    line x loc=-0.291 spac=0.01 tag=MetTop
    line x loc=-0.087 spac=0.01 tag=Oxtop
    line x loc=0.0 spac=0.001 tag=AlGaNTop
    line x loc=0.014 spac=0.001 tag=AlGaNBottom
    line x loc=1.8 spac=0.2 tag=GaNBottom
    line x loc=2.0 spac=0.02 tag=AlNBottom
    line x loc=3.0 spac=1.8 tag=BBottom
    }
    if {0} {    
    line x loc=-0.3 spac=0.01 tag=MetTop
    line x loc=-0.1 spac=0.01 tag=Oxtop
    line x loc=0.0 spac=0.001 tag=AlGaNTop
    line x loc=0.015 spac=0.001 tag=AlGaNBottom
    line x loc=1.8 spac=0.2 tag=GaNBottom
    line x loc=2.0 spac=0.02 tag=AlNBottom
    line x loc=3.0 spac=1.5 tag=BBottom
    }
    
    if {1} {    
    line x loc=-0.3 spac=0.01 tag=MetTop
    line x loc=-0.1 spac=0.01 tag=Oxtop
    line x loc=0.0 spac=0.001 tag=AlGaNTop
    line x loc=0.015 spac=0.0008 tag=AlGaNBottom
    line x loc=1.8 spac=0.2 tag=GaNBottom
    line x loc=2.0 spac=0.02 tag=AlNBottom
    line x loc=3.0 spac=1.5 tag=BBottom
	}

if {0} {
    line y loc=-2.0 spac=0.1 tag=Left
    line y loc=-1.25 spac=0.1 
    #line y loc=-0.2155 spac=0.1 tag=Oxleft
    line y loc=-0.0475 spac=0.001 tag=Oxgs
    line y loc=0.0 spac=0.005
    line y loc=0.0475 spac=0.001 tag=Oxgd
    #line y loc=0.2155 spac=0.1 tag=Oxright
    line y loc=1.25 spac=0.1
    line y loc=2.0 spac=0.1 tag=Right
   } 
    
if {0} {    ;# 200nm
    line y loc=-2.0 spac=0.1 tag=Left
    line y loc=-1.25 spac=0.1 
    line y loc=-0.431 spac=0.1 tag=Oxleft
    line y loc=-0.095 spac=0.001 tag=Oxgs
    line y loc=0.0 spac=0.005
    line y loc=0.095 spac=0.001 tag=Oxgd
    line y loc=0.431 spac=0.1 tag=Oxright
    line y loc=1.25 spac=0.1
    line y loc=2.0 spac=0.1 tag=Right
 }
 
 if {0} { ;# 1 um T-gate
    line y loc=-2.0 spac=0.05 tag=Left  ;#was 0.05
    line y loc=-1.25 spac=0.1 
    line y loc=-0.75 spac=0.1 tag=Oxleft
    line y loc=-0.5 spac=0.001 tag=Oxgs
    line y loc=-0.2 spac=0.1
    line y loc=0.0  spac=0.001
    line y loc=0.2 spac=0.1
    line y loc=0.5 spac=0.001 tag=Oxgd
    line y loc=0.75 spac=0.1 tag=Oxright
    line y loc=1.25 spac=0.1
    line y loc=2.0 spac=0.05 tag=Right   ;#was 0.05
 }
 
 if {1} { ;# 1 um
    line y loc=-2.0 spac=0.05 tag=Left  ;#was 0.05
    line y loc=-1.25 spac=0.5 
    line y loc=-0.5 spac=0.001 tag=Oxleft
    line y loc=-0.2 spac=0.1
    line y loc=0.0  spac=0.001
    line y loc=0.2 spac=0.1
    line y loc=0.5 spac=0.001 tag=Oxright
    line y loc=1.25 spac=0.5
    line y loc=2.0 spac=0.05 tag=Right   ;#was 0.05
 }
    #Bulk
    region SiC xlo=AlNBottom xhi=BBottom ylo=Left yhi=Right
   
    #thin AlN layer
    region AlN xlo=GaNBottom xhi=AlNBottom ylo=Left yhi=Right

    #Buffer
    region GaN xlo=AlGaNBottom xhi=GaNBottom ylo=Left yhi=Right

    #AlGaN under gate
    region AlGaN xlo=AlGaNTop xhi=AlGaNBottom ylo=Left yhi=Right

    #Oxides for t-gate
    #region oxide xlo=Oxtop xhi=AlGaNTop ylo=Left yhi=Oxgs
    #region oxide xlo=Oxtop xhi=AlGaNTop ylo=Oxgd yhi=Right
    #region oxide xlo=MetTop xhi=Oxtop ylo=Left yhi=Oxleft
    #region oxide xlo=MetTop xhi=Oxtop ylo=Oxright yhi=Right
    
    region oxide xlo=MetTop xhi=AlGaNTop ylo=Left yhi=Oxleft
    region oxide xlo=MetTop xhi=AlGaNTop ylo=Oxright yhi=Right
    #region oxide xlo=MetTop xhi=Oxtop ylo=Left yhi=Oxleft
    #region oxide xlo=MetTop xhi=Oxtop ylo=Oxright yhi=Right

    #metal in the middle
    #region metal xlo=Oxtop xhi=AlGaNTop ylo=Oxgs yhi=Oxgd
    #region metal xlo=MetTop xhi=Oxtop ylo=Oxleft yhi=Oxright
    region metal xlo=MetTop xhi=AlGaNTop ylo=Oxleft yhi=Oxright
    
	#initialize the grid
    init 
    #Smooth AlGaN
    #Smooth GaN
    #Smooth SiC

    #Contacts
if {1} {    
    contact name=G metal xlo=-0.29 xhi=0.001 ylo=-0.75 yhi=0.75 add depth=1.0 width=1.0  ;# 1 um
    #contact name=G metal xlo=-0.28 xhi=0.001 ylo=-0.44 yhi=0.44 add depth=300.0 width=1.0
    contact name=B SiC xlo=2.9 xhi=7.0 add depth=1.0 width=1.0
    contact name=S AlGaN ylo=-3.4 yhi=-1.99 xlo=-1.0 xhi=0.0149 add depth=1.0 width=1.0
    contact name=D AlGaN ylo=1.99 yhi=3.4 xlo=-1.0 xhi=0.0149 add depth=1.0 width=1.0
}

if {0} {    
    contact name=G metal xlo=-0.29 xhi=0.001 ylo=-0.75 yhi=0.75 add depth=1.0 width=1.0  ;# 1 um
    #contact name=G metal xlo=-0.28 xhi=0.001 ylo=-0.44 yhi=0.44 add depth=300.0 width=1.0
    contact name=B SiC xlo=2.9 xhi=7.0 add depth=1.0 width=1.0
    contact name=S AlGaN ylo=-3.4 yhi=-1.99 xlo=-1.0 xhi=0.0015 add depth=1.0 width=1.0
    contact name=D AlGaN ylo=1.99 yhi=3.4 xlo=-1.0 xhi=0.0015 add depth=1.0 width=1.0
}


}
Struct2D  ;#for e-field calc, work for Id calc now also, SD contacts have to be one node short of going through the AlGaN
#Struct2D_coarse ;#for Id calc

    plot2d bound grid
    plot2d contact=G !cle
    plot2d contact=B !cle
    plot2d contact=S !cle
    plot2d contact=D !cle


###--------------Import profile of TRIM data (vacancies created by 5meV of H radiation)
# none of this is used
set dose 2.0e14

profile name=Vgag inf=Vga-gate.flps log ymin=1.0 offset=0.3
sel z= $dose*Vgag*0.5*erfc((y-0.5)/sqrt(2)/5.0e-2) name=profile_r   ;#2.0e13/cm2 rad dose 
sel z= $dose*Vgag*0.5*erfc(-(y+0.5)/sqrt(2)/5.0e-2) name=profile_l
sel z= (profile_r*(y>=0))+(profile_l*(y<0)) name=gate_Vga

profile name=Vng inf=Vn-gate.flps log ymin=1.0 offset=0.3
sel z= $dose*Vng*0.5*erfc((y-0.5)/sqrt(2)/5.0e-2) name=profile_r   ;#2.0e13/cm2 rad dose 
sel z= $dose*Vng*0.5*erfc(-(y+0.5)/sqrt(2)/5.0e-2) name=profile_l
sel z= (profile_r*(y>=0))+(profile_l*(y<0)) name=gate_Vn

profile name=Vga inf=Vn-nitride.flps log ymin=1.0 offset=0.3
sel z= $dose*Vga*0.5*erfc((y-0.5)/sqrt(2)/5.0e-2) name=profile_r   ;#2.0e13/cm2 rad dose 
sel z= $dose*Vga*0.5*erfc(-(y+0.5)/sqrt(2)/5.0e-2) name=profile_l
sel z= (profile_r*(y>=0))+(profile_l*(y<0)) name=nitride_Vga

profile name=Vn inf=Vn-nitride.flps log ymin=1.0 offset=0.3
sel z= $dose*Vn*0.5*erfc((y-0.5)/sqrt(2)/5.0e-2) name=profile_r   ;#2.0e13/cm2 rad dose 
sel z= $dose*Vn*0.5*erfc(-(y+0.5)/sqrt(2)/5.0e-2) name=profile_l
sel z= (profile_r*(y>=0))+(profile_l*(y<0)) name=nitride_Vn


profile name=vac inf=trim_gate.ux3 log ymin=1.0 offset=0.3

sel z= 9.82e16*0.5*erfc((y-0.5)/sqrt(2)/5.0e-2) name=profile_r   ;#2.0e14/cm2 rad dose 
sel z= 9.82e16*0.5*erfc(-(y+0.5)/sqrt(2)/5.0e-2) name=profile_l
sel z= (profile_r*(y>=0))+(profile_l*(y<0)) name=gate_profile_GaN
   

sel z= 6.5e16*0.5*erfc((y+0.5)/sqrt(2)/5.0e-2) name=profile2_l   ;#2.0e14/cm2 rad dose 
sel z= 6.5e16*0.5*erfc(-(y-0.5)/sqrt(2)/5.0e-2) name=profile2_r
sel z= (profile2_r*(y>=0))+(profile2_l*(y<0)) name=sd_profile_GaN   

sel z= 6.18e16*0.5*erfc((y-0.5)/sqrt(2)/5.0e-2) name=profile3_r   ;#2.0e14/cm2 rad dose 
sel z= 6.18e16*0.5*erfc(-(y+0.5)/sqrt(2)/5.0e-2) name=profile3_l
sel z= (profile3_r*(y>=0))+(profile3_l*(y<0)) name=gate_profile_AlGaN
   

sel z= 7.36e16*0.5*erfc((y+0.5)/sqrt(2)/5.0e-2) name=profile4_l   ;#2.0e14/cm2 rad dose 
sel z= 7.36e16*0.5*erfc(-(y-0.5)/sqrt(2)/5.0e-2) name=profile4_r
sel z= (profile4_r*(y>=0))+(profile4_l*(y<0)) name=sd_profile_AlGaN  
#-------------------------------------------------------------------------------

    
    #GaN Doping- acceptor-p-type 2e14 gives comparable IV curves to experiment
    sel z= -2.0e14*Mater(GaN) name=GaN_Doping    

    
#sel z= gate_profile_GaN+sd_profile_GaN name=GaN_profile
#sel z= GaN_profile*(x>0.015)+(x<0.15)-(GaN_profile-2.7e14)*(x>0.15)+(x<1.8) name=GaN_dop
#sel z= -GaN_dop*Mater(GaN) name=GaN_Doping

#sel z=-GaN_profile*Mater(GaN) name=GaN_Doping

    #AlN doping
    sel z= 1.0e12*Mater(AlN) name=AlN_Doping

    #SiC doping
    sel z= 1.0e12*Mater(SiC) name=SiC_Doping

    #AlGaN Doping
	sel z= -1.0e12*Mater(AlGaN) name=AlGaN_Doping
    

    #Source and Drain contact doping-from contact to 2DEG like Heller-just to make contacts ohmic
    sel z=(1e19*(y>1.9)+(y<=1.9)*1.0e19*exp(-(y-1.9)*(y-1.9)/(1.9*0.02*0.02)))*(exp(-(x*x)/(1.9*0.03*0.03))) name=Drain_Doping
    sel z=(1e19*(y<-1.9)+(y>=-1.9)*1.0e19*exp(-(y+1.9)*(y+1.9)/(1.9*0.02*0.02)))*(exp(-(x*x)/(1.9*0.03*0.03))) name=Source_Doping


    #sel z=0.0 name=Doping 
    sel z=GaN_Doping+AlGaN_Doping+Drain_Doping+Source_Doping+SiC_Doping+AlN_Doping name=Doping 
    #when using reduction in Int charge, the AlGaN doping must be positive for convergence
	#sel z=Drain_Doping+Source_Doping+SiC_Doping+AlN_Doping+VN-VGa name=Doping 
    
	#sel z=vac
    #plot.1d x.v=0.01

    #sel z=gate_profile
   # plot.1d x.v=0.01 !cle
    
    #sel z=sd_profile
    #plot.1d x.v=0.01 !cle
    
    
    sel z=0.25 name=AlN_Ratio
    
 #Add nitride interface charge

#pdbSetString AlGaN_Oxide DevPsi Equation "-8.e12"   ;# neg oxide charge makes the e-field decrease, IdVg does not change appreciably, pos charge possibly increases e-field

			#sel z=(-Doping)
			#plot.1d y.v=0.0 plot_name=Trp_conc  !cle
			#plot.1d x.v=0.02 plot_name=trp_concx label=0.02 !cle
			#plot.1d x.v=0.03 plot_name=trp_concx label=0.03 !cle
			#plot.1d x.v=0.5 plot_name=trp_concx label=0.5 !cle 

#Initialize
proc Init_new {Mat} {

newton $Mat eqn=Doping+Donor-Acceptor+Hole-Elec var=DevPsi damp=0.025
}

Init_new GaN
Init_new AlGaN
Init_new AlN
Init_new SiC

solution add name=ETemp solve const val = 300.0 continuous
solution add name=HTemp solve const val = 300.0 continuous
solution add name=Donor solve const val = 10.0
solution add name=Acceptor solve const val = 10.0

###### uncomment these to add traps at varius concentrations and energies (conc  energy level  spread)
#DonorTrap GaN 1.0e17 0.1 0.025
#AcceptorTrap AlGaN 3.1e18 3.4 0.025
#AcceptorTrap GaN 1.0e17 1.0 0.025
Poisson AlGaN
Poisson metal
Poisson oxide
Poisson SiC
Poisson AlN
Poisson GaN
ElecContinuity GaN


    contact name=G AlGaN voltage supply=0.0
    contact name=B SiC voltage supply=0.0
    contact name=S AlGaN voltage supply=0.0
    contact name=D AlGaN voltage supply=0.0


#fix for odd hole spike at gate contact
#pdbSetString G Qfp Equation "Qfp-([pdbDelayDouble AlGaN Elec Ec])+0.1"
#pdbSetBoolean G Qfp Fixed 1
#pdbSetDouble G Qfp Flux.Scale 1.602e-19

#pdbSetString G Qfn Equation "Qfn-([pdbDelayDouble AlGaN Elec Ec])+1.5"
#pdbSetBoolean G Qfn Fixed 1
#pdbSetDouble G Qfn Flux.Scale 1.602e-19

pdbSetString G Qfp Equation "Qfp+G"
pdbSetBoolean G Qfp Fixed 1
pdbSetDouble G Qfp Flux.Scale 1.602e-19



set Vdd 0.0
set Vgs 0.0
set WinA [CreateGraphWindow]
	
	#transient sim
if {0} {
device 

ElecContinuity_trans GaN 1.0e17 0.1 10
DonorContinuity_trans GaN 1.0e17 0.1 10

device init time=300 movie = {
	set cur [expr (1.0e6*(-[contact name=D sol=Qfn flux] + [contact name=D sol=Qfp flux]))]  ;# mA/mm 
    set t  [simGetDouble Device time] 
	AddtoLine $WinA Id $t $cur 
	}
}	
if {0} {
device
device

contact name=D supply=1.0
device
contact name=D supply=2.0
device
contact name=D supply=3.0
device
contact name=D supply=4.0
device
contact name=D supply=5.0
device

sel z=log10(Elec)
	plot.1d y.v=0.0 plot_name=conc label=elec !cle
			
sel z=Econd
	plot.1d y.v=0.0 plot_name=Band label=Ec !cle
			
#sel z=Eval
#	plot.1d y.v=0.0 plot_name=Band label=Ev !cle
			
sel z=Qfn
	plot.1d y.v=0.0 plot_name=Band label=Qfn !cle
}


#IdVg curves
if {0} {
device		
device
device
for {set Vds 0.0} {$Vds<0.5} {set Vds [expr $Vds+0.2]} {
	contact name=D supply=$Vds
	device
	device
}

for {set Vgs 0.00} {$Vgs<1.1} {set Vgs [expr $Vgs+0.5]} {
	contact name=G supply=-$Vgs
	device
	device

			sel z=Econd
			plot.1d y.v=0.0 plot_name=Band label=Ec.$Vgs cle
			sel z=Eval
			plot.1d y.v=0.0 plot_name=Band label=Ev.$Vgs !cle
			sel z=Qfp
			plot.1d y.v=0.0 plot_name=Band label=Qfp.$Vgs !cle
			sel z=Qfn
			plot.1d y.v=0.0 plot_name=Band label=Qn.$Vgs !cle
			sel z=log10(Acceptor)
			plot.1d y.v=0.0 plot_name=Acceptor label=$Vgs cle
			sel z=Donor
			plot.1d y.v=0.0 plot_name=Donor label=$Vgs cle
			sel z=sqrt(dot(DevPsi,DevPsi))
			plot.1d x.v=0.005 plot_name=E_field label=$Vgs !cle
			sel z=log10(Elec)
			plot.1d y.v=0.0 plot_name=elec_conc label=elec.$Vgs cle
			sel z=log10(Hole)
			plot.1d y.v=0.0 plot_name=elec_conc label=hole.$Vgs !cle
			sel z=(Doping+Donor-Acceptor)
			plot.1d y.v=0.0 plot_name=trp_concx label=$Vgs cle
			#sel z=sqrt(dot(DevPsi,DevPsi))
			#plot.1d x.v=0.005 plot_name=E_field label=$Vgs !cle
			#sel z=sqrt(dot(DevPsi,DevPsi))
			#plot.1d y.v=0.0 plot_name=E_field_middle label=$Vgs !cle
			#sel z=Qfn
			#plot.1d y.v=0.0 plot_name=fermiL label=Qfn.$Vgs !cle
			#sel z=Qfp
			#plot.1d y.v=0.0 plot_name=fermiL label=Qfp.$Vgs !cle
			#sel z=CompIPZStrain(xx,DevPsi) 
			#plot.1d x.v=0.01 plot_name=Strain label=exx
			#set cur [expr (50.0*(-[contact name=D sol=Qfn flux] + [contact name=D sol=Qfp flux]))]
			set cur [expr (1.0e6*(-[contact name=D sol=Qfn flux] + [contact name=D sol=Qfp flux]))]  ;# mA/mm (trans width 150um X 2 fingers is set in contact depth)
			AddtoLine $WinA IdVg $Vgs $cur 
			#set mobVvoltage [pdbGetDouble GaN Elec lowfldmob]
			#sel z=$mobVvoltage
			#plot.1d y.v=0.0 plot_name=mobility label=mob.Vgs 
			#plot.1d x.v=0.016
	}
#sel z=sqrt(dot(DevPsi,DevPsi))
#	 plot2d bound
#	 	for {set ctr 3.0e6} {$ctr<6.0e6} {set ctr [expr $ctr+5.0e5]} {
#	 	contour val=$ctr
#	 	}
}



# E-field, off state, high drain bias
if {0} {

set n 0.0

for {set Vgs 0.00} {$Vgs<8.1} {set Vgs [expr $Vgs+1.0]} {
	contact name=G supply=-$Vgs
	device
	device
	device
	}
	for {set Vdd 0.00} {$Vdd<30.5} {set Vdd [expr $Vdd+1.0]} {
			contact name=D supply=$Vdd
			device
			device
			#sel z=sqrt(dot(DevPsi,DevPsi))
			#plot.1d y.v=0.5 plot_name=E_field label=$Vdd !cle
		if {1} {	
		while {$n<31.0} {
			if {$Vdd == $n} {	
			sel z=(dot(DevPsi,x*1.0e-4))
			plot.1d y.v=0.5 plot_name=E_field label=$Vdd !cle
			sel z=sqrt(dot(DevPsi,DevPsi))
			plot.1d x.v=0.001 plot_name=E_fieldx label=$Vdd 
			sel z=Qfn
			plot.1d y.v=-0.4 plot_name=Band label=Qfn.$Vdd !cle
			sel z=Qfp
			plot.1d y.v=-0.4 plot_name=Band label=Qfp.$Vdd !cle
			#sel z=log10(Hole)
			#plot.1d y.v=0.0 plot_name=conc label=hole.$Vdd !cle
			#sel z=log10(Elec)
			#plot.1d y.v=0.0 plot_name=conc label=elec.$Vdd !cle
			sel z=Econd
			plot.1d y.v=-0.4 plot_name=Band label=Ec.$Vdd !cle
			sel z=Eval
			plot.1d y.v=-0.4 plot_name=Band label=Ev.$Vdd !cle
			puts $n
			set n [expr $n+5.0]
			puts $n
			break
			} else break
		}
		}
	}
	 sel z=sqrt(dot(DevPsi,DevPsi))
	 #sel z=log10(Elec)
	 plot2d bound
	 for {set ctr 5.0e6} {$ctr<1.3e7} {set ctr [expr $ctr+1.0e6]} {
	 	contour val=$ctr
	 }
}


if {0} {	
	for {set Vgs 0.0} {$Vgs<30.5} {set Vgs [expr $Vgs+5.0]} {
	contact name=G supply=-$Vgs
	device
	device
	sel z=sqrt(dot(DevPsi,DevPsi))
	plot.1d y.v=0.0475 plot_name=E_field label=$Vgs !cle
	}	
	
	sel z=sqrt(dot(DevPsi,DevPsi))
	 plot2d bound
	 	for {set ctr 5.0e5} {$ctr<5.0e6} {set ctr [expr $ctr+5.0e5]} {
	 	contour val=$ctr
	 	}
}

#proc for saving the graph as gif image
proc SnapImage {win_val filename} {
	puts $win_val ".graph snap .image"
	puts $win_val ".image write Desktop/$filename.gif -format gif"
	flush $win_val
} 	
#SnapImage {E_field Efield1}	
	
	
	

#notes: when plotting the s-d current use the coarse grid b/c the source and drain contact do not
#reach the bottom the the AlGaN layer, which is needed for conversion.  However, when calculating 
#the electric field, use the regular grid b/c the contacts do go all the way through the AlGaN, which is also needed for conversion