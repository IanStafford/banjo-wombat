
pdbSetDouble Math iterLimit 100
math device dim=2 col umf none scale
source GaN_modelfile_rad_mech.tcl

# 2d case, trying to do first order simulation of electron trapping at AlGaN surface from e/h pair generation durring irradiation 


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
    
    if {1} {    
    line x loc=-0.3 spac=0.01 tag=MetTop
    line x loc=-0.1 spac=0.01 tag=Oxtop
    line x loc=0.0 spac=0.001 tag=AlGaNTop
    line x loc=0.015 spac=0.001 tag=AlGaNBottom
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
    contact name=G metal xlo=-0.29 xhi=0.001 ylo=-0.75 yhi=0.75 add depth=300.0 width=1.0  ;# 1 um
    #contact name=G metal xlo=-0.28 xhi=0.001 ylo=-0.44 yhi=0.44 add depth=300.0 width=1.0
    contact name=B SiC xlo=2.9 xhi=7.0 add depth=300.0 width=1.0
    contact name=S AlGaN ylo=-3.4 yhi=-1.99 xlo=-1.0 xhi=0.0145 add depth=300.0 width=1.0
    contact name=D AlGaN ylo=1.99 yhi=3.4 xlo=-1.0 xhi=0.0145 add depth=300.0 width=1.0
    #contact name=AlGaN_l ylo=-2.0 yhi=-0.5 xlo=-0.005 xhi=0.001 add depth=300.0 width=1.0
	#contact name=AlGaN_r ylo=0.5 yhi=2.0 xlo=-0.005 xhi=0.001 add depth=300.0 width=1.0

}

if {0} {    
    contact name=G metal xlo=-0.29 xhi=0.001 ylo=-0.75 yhi=0.75 add depth=300.0 width=1.0  ;# 1 um
    #contact name=G metal xlo=-0.28 xhi=0.001 ylo=-0.44 yhi=0.44 add depth=300.0 width=1.0
    contact name=B SiC xlo=2.9 xhi=7.0 add depth=300.0 width=1.0
    contact name=S AlGaN ylo=-3.4 yhi=-1.99 xlo=-1.0 xhi=0.0015 add depth=300.0 width=1.0
    contact name=D AlGaN ylo=1.99 yhi=3.4 xlo=-1.0 xhi=0.0015 add depth=300.0 width=1.0
}


}
Struct2D  ;#for e-field calc, work for Id calc now also, SD contacts have to be one node short of going through the AlGaN
#Struct2D_coarse ;#for Id calc
#init inf=Poisson_only.str

    plot.2d bound grid
    plot.2d contact=G !cle
    plot.2d contact=B !cle
    plot.2d contact=S !cle
    plot.2d contact=D !cle
	#plot.2d contact=AlGaN_l !cle
	#plot.2d contact=AlGaN_r !cle


    #doping definition-will use method from pfmos_qf deck for simplicity
    #GaN Doping-from Dessis file from Heller-acceptor-p-type
    #sel z= -6.5e16*Mater(GaN) name=GaN_Doping
    sel z= -2.7e14*Mater(GaN) name=GaN_Doping  ;#doping matched to pre-rad case  
    #sel z = -9.82e16*Mater(GaN)*(x>0.015)+(x<0.03)+(9.793e16)*Mater(GaN)*(x>0.03)+(x<1.8) name=GaN_Doping
    # sel z= -3.10e15*Mater(GaN) name=GaN_Doping 
    
    #AlN doping
    sel z= 1.0e12*Mater(AlN) name=AlN_Doping

    #SiC doping
    sel z= 1.0e12*Mater(SiC) name=SiC_Doping

    #AlGaN Doping-from Dessis file from Heller-he puts equivalent donor and acceptor doping in region to signify traps
    #sel z= -3.10e15*Mater(AlGaN) name=AlGaN_Doping
	sel z= -1.0e12*Mater(AlGaN) name=AlGaN_Doping
    #sel z = -(gate_profile_AlGaN+sd_profile_AlGaN)*Mater(AlGaN) name=AlGaN_Doping

    #Source and Drain contact doping-from contact to 2DEG like Heller-just to make contacts ohmic
    sel z=(1e19*(y>1.9)+(y<=1.9)*1.0e19*exp(-(y-1.9)*(y-1.9)/(1.9*0.02*0.02)))*(exp(-(x*x)/(1.9*0.03*0.03))) name=Drain_Doping
    sel z=(1e19*(y<-1.9)+(y>=-1.9)*1.0e19*exp(-(y+1.9)*(y+1.9)/(1.9*0.02*0.02)))*(exp(-(x*x)/(1.9*0.03*0.03))) name=Source_Doping

	
    #Total doping
     
    sel z=GaN_Doping+AlGaN_Doping+Drain_Doping+Source_Doping+SiC_Doping+AlN_Doping name=Doping 

    
    sel z=0.25 name=AlN_Ratio
    
 #Add nitride interface charge

#pdbSetString AlGaN_Oxide DevPsi Equation "-8.e12"   ;# neg oxide charge makes the e-field decrease, IdVg does not change appreciably, pos charge possibly increases e-field

			#sel z=(-Doping)
			#plot.1d y.v=0.0 plot_name=Trp_conc  !cle
			#plot.1d x.v=0.02 plot_name=trp_concx label=0.02 !cle
			#plot.1d x.v=0.03 plot_name=trp_concx label=0.03 !cle
			#plot.1d x.v=0.5 plot_name=trp_concx label=0.5 !cle 

###############################################################################
# set initial conditions
Initialize

    contact name=G AlGaN voltage supply=0.0
    contact name=B SiC voltage supply=0.0
    contact name=S AlGaN voltage supply=0.0
    contact name=D AlGaN voltage supply=0.0


#fix for odd hole spike at gate contact
pdbSetString G Qfp Equation "Qfp+G"
pdbSetBoolean G Qfp Fixed 1
pdbSetDouble G Qfp Flux.Scale 1.602e-19

#turn on physics routines
# 1st run, poisson only
solution add name=DevPsi solve negative damp continuous
solution add name=Qfp const val=0.0
solution add name=Qfn const val=0.0

Poisson AlGaN
Poisson metal
Poisson oxide
Poisson SiC
Poisson AlN
Poisson GaN

ElecContinuity GaN
ElecContinuity AlGaN
ElecContinuity SiC
ElecContinuity AlN

HoleContinuity GaN
HoleContinuity AlGaN
HoleContinuity SiC
HoleContinuity AlN

#Ohmic AlGaN S
#Ohmic AlGaN D
#Ohmic SiC B


#Poisson only soln - fix Qfn, Qfp
device init


if {1} {
#run again with Qfn, Qfp floating
solution add name=Qfp solve pde negative damp continuous
solution add name=Qfn solve pde negative damp continuous


device init
sel z=Elec name=Eo
sel z=Hole name=Ho

device
} ;#end if

set WinA [CreateGraphWindow]
###############################turn on generation terms
if {1} {
#set ramping generation rate
set rampr 1.0e5
#set t [simGetDouble Device time]
#if {$t < 1} {
#	set gen ($rampr*$t)
#} else {	
#	set gen 1.0e5
#	}	
	
#pdbSetDouble AlGaN Elec gen ([simGetDouble Device time]*1.0e5)
#pdbSetDouble GaN Elec gen ([simGetDouble Device time]*1.0e5)
#pdbSetDouble AlN Elec gen ([simGetDouble Device time]*1.0e5)
#pdbSetDouble SiC Elec gen ([simGetDouble Device time]*1.0e5)

set gen [expr {[simGetDouble Device time]*2.0e12*2.4e4}]

proc ElecContinuity {Mat} {
    global Vt rampr gen

    pdbSetDouble $Mat Qfn Rel.Error 1.0e-2
    pdbSetDouble $Mat Qfn Abs.Error 1.0e-2
    pdbSetDouble $Mat Qfn DampValue 0.025

    set eqn "ddt(Elec) - ([pdbDelayDouble $Mat Elec mob]) * (Elec+1.0) * grad(Qfn) - (2.0e16)"
    pdbSetString $Mat Qfn Equation $eqn
    
    set e "([pdbDelayDouble $Mat Elec Ec])"
    solution add name=Econd solve $Mat const val = ($e)

    set e "([pdbDelayDouble $Mat Elec Nc]) * exp( -(Econd-Qfn) / ($Vt) )"
    solution add name=Elec solve $Mat const val = "($e)"
}

ElecContinuity GaN
ElecContinuity AlGaN
ElecContinuity SiC
ElecContinuity AlN

proc HoleContinuity {Mat} {
    global Vt gen rampr t

    pdbSetDouble $Mat Qfp Rel.Error 1.0e-2
    pdbSetDouble $Mat Qfp Abs.Error 1.0e-2
    pdbSetDouble $Mat Qfp DampValue 0.025

    set eqn "ddt(Hole) + ([pdbDelayDouble $Mat Hole mob]) * (Hole+1.0) * grad(Qfp) - 0"
    pdbSetString $Mat Qfp Equation $eqn

    set e "([pdbDelayDouble $Mat Hole Ev])"
    solution add name=Eval solve $Mat const val = ($e)

    set e "([pdbDelayDouble $Mat Hole Nv]) * exp( -(Qfp - Eval) / ($Vt) )"
    solution name=Hole solve $Mat const val = "($e)"
}

HoleContinuity GaN
HoleContinuity AlGaN
HoleContinuity SiC
HoleContinuity AlN


#interface (AlGaN/nitride) capture equation
set rvel0 1.0e-3
set rvel1 1.0e7

#set e1 "([pdbDelayDouble AlGaN Elec Nc]) * exp(-([pdbDelayDouble AlGaN Elec Ec] - Qfn) / ($Vt) )"
#set h1 "([pdbDelayDouble AlGaN Hole Nv]) * exp(-(Qfp - [pdbDelayDouble AlGaN Hole Ev]) / ($Vt) )"
#pdbSetString AlGaN_Oxide Qfn Equation  "$rvel0*(Elec-Eo)" 
pdbSetString AlGaN_Metal Qfn Equation  "($rvel1*(Elec))" 
#pdbSetString AlGaN_Oxide Qfp Equation  "$rvel0*(1.0-(Ho-10.0))"

set oldflux 0.0
set oldtime 0.0
set excarr 0.0
set Total 0.0

device init time=1.0 t.init=1.0e-16 movie = {
puts $gen
set t [simGetDouble Device time]
sel z=log10(Elec)
plot.1d y.v=1.5 label=elec.t$t !cle plot_name=elec_conc
sel z=log10(Elec)
plot.1d y.v=0.0 label=elec_mid.t$t !cle plot_name=elec_mid_conc
sel z=Econd
plot.1d y.v=1.5 label=Ec.t$t !cle plot_name=Ec

sel z=Elec-Eo name=diff
set flux1 [interface y.v=0.5 AlGaN /Oxide value]
sel z=diff+$excarr
plot.1d x.v=0.0 label=diff.t$t !cle plot_name=excess_elec
		set excarr diff

#set Total "(0.5 * ($t - $oldtime) * (1.0 + $oldflux))"
#		set oldtime $t
#		set oldflux $flux1
#		AddtoLine $WinA Chrg $t $flux1 
		

}

if {0} {
set gen 1.0e7
set oldtime 0.0
set oldflux 0.0
set Total 0.0
device  time=1.0  user=1.0e-2 movie = {
	incr i
	set t [simGetDouble Device time]
		sel z=log10(Elec)
		plot.1d y.v=1.5 label=elec.t$t !cle plot_name=elec_conc2
		sel z=Econd
		plot.1d y.v=1.5 label=Ec.t$t !cle plot_name=Ec2
		set flux1 [interface x.v=1.5 Oxide /AlGaN value]
		set count [expr ([contact name=D sol=Qfn flux])]
		#set Total "(0.5 * ($t - $oldtime) * (1.0 + $oldflux))"
		set oldtime $t
		set oldflux $flux1
		#AddtoLine $WinA Chrg $t $Total 
		puts $gen
	}
	}
} ; #end if


 
