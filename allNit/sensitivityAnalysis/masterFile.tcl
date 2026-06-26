#########################################################################################
#constants for each material
#########################################################################################

set k 1.38066e-23
set q 1.60218e-19
set Vt ($k*Temp/$q)
set eps0 8.854e-14
set kev 8.617e-5
set VtRoom [expr $k*300.0/$q]
global VtRoom
set hbar 1.054571628e-34
set egan 7.88e-13

source GaN.tcl
source AlGaN.tcl
source Insulator.tcl
source Metal.tcl

# Simulation Setup
# =====================================
# Not solving for temp
solution add name=Temp const val=300.0
# =====================================



# DevPsi is continuous for initial solve and Qfn, Qfp are set to 0
# =====================================
solution add name=DevPsi solve negative damp continuous
#solution add name=Qfp solve negative damp continuous
#solution add name=Qfn solve negative damp continuous
# =====================================

puts "Trap parameters: sigma=$sigma, mean_x=$mean_x, mean_y=$mean_y, trapConc=$trapConc, trapEn=$trapEn, trapLevel=$trapLevel, trapWidth=$trapWidth"


# 2D Gaussian trap distribution
if {![info exists sigma]} { set sigma 0.015 }
if {![info exists mean_x]} { set mean_x 0.0 }
#if {![info exists mean_y]} { set mean_y 0.14 }
if {![info exists trapConc]} { set trapConc "3e18*exp(-((x-$mean_x)*(x-$mean_x)+(y-$mean_y)*(y-$mean_y))/(2.0*$sigma*$sigma))" }

if {![info exists trapEn]} { set trapEn 0.0 }
if {![info exists trapLevel]} { set trapLevel 3.1 }
if {![info exists trapWidth]} { set trapWidth 0.025 }

puts "Trap parameters: sigma=$sigma, mean_x=$mean_x, mean_y=$mean_y, trapConc=$trapConc, trapEn=$trapEn, trapLevel=$trapLevel, trapWidth=$trapWidth"

# Poisson's equation for all materials
# No ionized charge terms for metal or insulator
# But we still solve for DevPsi as its continuous 
# across the device and is used to calculate Qfn and Qfp
# =====================================
source Poisson.tcl
Poisson GaN
Poisson AlGaN
InsPoisson Nitride
InsPoisson Metal

if {$trapEn} {
    AcceptorTrap GaN $trapConc $trapLevel $trapWidth ; #GaN bandgap is about 3.4 eV
    AcceptorTrap AlGaN $trapConc $trapLevel $trapWidth ; #AlGaN bandgap is about 3.75 eV at our Al fraction

    #DonorTrap GaN $trapConc 0.84 0.001
    #DonorTrap AlGaN $trapConc 0.84 0.001
}
# =====================================



# Continuity equations in GaN and AlGaN
# =====================================
source Continuity.tcl

ElecContinuity GaN
ElecContinuity AlGaN

HoleContinuity GaN
HoleContinuity AlGaN
# =====================================

# Add interface charge
# =====================================
pdbSetString AlGaN_GaN DevPsi Equation "1.06e13"

#pdbSetString AlGaN_GaN DevPsi Equation "6e12"
#pdbSetString AlGaN_GaN DevPsi Equation "1.486e13"
#pdbSetString AlGaN_GaN DevPsi Equation "-1*(1e13*log(AlN_Ratio)+3e13)"
# =====================================

#Electrical Initial Conditions
proc Initialize {} {
    global Vt
    sel z=300.00 name=Temp
    solution name=Qfn val=0 const
    solution name=Qfp val=0 const

    #four components - GaN ntype, GaN ptype, AlGaN ntype, AlGaN ptype

    #GaN First
    set nc "([pdbDelayDouble GaN Elec Nc])"
    set nv "([pdbDelayDouble GaN Hole Nv])"
    set aff "([pdbGetDouble GaN Affinity])"
    set Eg "([pdbGetDouble GaN Eg])"
    sel z= abs(Doping)+1.0 name=AbsDop

    #sel z = "Mater(GaN) * ((Doping>0.0) ? (-$Vt * log( AbsDop / $nc) + $aff) : 0.0)"  name=GaN_N ;# Is the fraction in the logarithm inverted?
    #sel z = "Mater(GaN) * ((Doping<0.0) ? ($Vt * log(AbsDop / $nv) + $aff + $Eg) : 0.0)"  name=GaN_P

    newton GaN eqn=Doping-Elec+Hole var=DevPsi damp=0.025

    #now AlGaN
    set nc "([pdbDelayDouble AlGaN Elec Nc])"
    set nv "([pdbDelayDouble AlGaN Hole Nv])"
    set aff "([pdbGetDouble AlGaN Affinity])"
    set Eg "([pdbGetDouble AlGaN Eg])"

    #sel z = "Mater(AlGaN) * ((Doping>0.0) ? (-$Vt * log(AbsDop / $nc) + $aff) : 0.0)"  name=AlGaN_N
    #sel z = "Mater(AlGaN) * ((Doping<0.0) ? ($Vt * log(AbsDop / $nv) + $aff + $Eg) : 0.0)"  name=AlGaN_P

    newton AlGaN eqn=Doping-Elec+Hole var=DevPsi damp=0.025

    #newton Nitride eqn=Doping-Elec+Hole var=DevPsi damp=0.025

    #now Metal
    InitMetal
    
    #sum them together
    #sel z=GaN_N+GaN_P+AlGaN_N+AlGaN_P+MetalDevPsi+Nitride_N+Nitride_P name=DevPsi

    sel z=0 name=DonorTraps
    sel z=0.0 name=Qfn
    sel z=0.0 name=Qfp
    sel z=0.0 name=Impurity

    device init
    solution add name=Qfp solve negative damp continuous pde
    solution add name=Qfn solve negative damp continuous pde
}
