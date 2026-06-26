# sensitivityModelfile.tcl — parameterized replacement for GaN_modelfile_masterD.
#
# Set any sens_* variables before sourcing to override trap defaults.
# This file also aliases sigma/mean_x/mean_y so fieldplate.tcl's HEMT_Struct
# can access the swept values via its global declarations.

# ── Trap parameter defaults ───────────────────────────────────────────────────
if {![info exists sens_density]} { set sens_density 3e18     }
if {![info exists sens_sigma]}   { set sens_sigma   0.015    }
if {![info exists sens_mean_x]}  { set sens_mean_x  0.0      }
if {![info exists sens_mean_y]}  { set sens_mean_y  0.14     }
if {![info exists sens_type]}    { set sens_type    Acceptor }
if {![info exists sens_energy]}  { set sens_energy  3.1      }
if {![info exists sens_width]}   { set sens_width   0.025    }

# ── Physical constants ────────────────────────────────────────────────────────
set k    1.38066e-23
set q    1.60218e-19
set Vt   [expr {$k * 300.0 / $q}]
set eps0 8.854e-14
set kev  8.617e-5
set VtRoom [expr {$k * 300.0 / $q}]
global VtRoom
set hbar 1.054571628e-34
set egan 7.88e-13

# ── Alias legacy names so fieldplate.tcl's HEMT_Struct globals still resolve ──
set sigma  $sens_sigma
set mean_x $sens_mean_x
set mean_y $sens_mean_y

# ── Material and physics files ────────────────────────────────────────────────
source GaN.tcl
source AlGaN.tcl
source Insulator.tcl
source Metal.tcl

solution add name=Temp const val=300.0
solution add name=DevPsi solve negative damp continuous

source Poisson.tcl

# ── 2D Gaussian trap distribution (parameterized) ─────────────────────────────
# x and y are FLOOXS spatial variables; the sens_* values are substituted now.
set trapConc "${sens_density}*exp(-((x-(${sens_mean_x}))*(x-(${sens_mean_x}))+(y-(${sens_mean_y}))*(y-(${sens_mean_y})))/(2.0*${sens_sigma}*${sens_sigma}))"

InsPoisson Nitride
Poisson GaN
Poisson AlGaN

if {$sens_type eq "Acceptor"} {
    AcceptorTrap GaN   $trapConc $sens_energy $sens_width
    AcceptorTrap AlGaN $trapConc $sens_energy $sens_width
} elseif {$sens_type eq "Donor"} {
    DonorTrap GaN   $trapConc $sens_energy $sens_width
    DonorTrap AlGaN $trapConc $sens_energy $sens_width
} else {
    error "sens_type must be Acceptor or Donor (got: $sens_type)"
}

InsPoisson Metal

source Continuity.tcl
ElecContinuity GaN
ElecContinuity AlGaN
HoleContinuity GaN
HoleContinuity AlGaN

pdbSetString AlGaN_GaN DevPsi Equation "6e12"

# ── Initialize proc (identical to GaN_modelfile_masterD) ─────────────────────
proc Initialize {} {
    global Vt
    sel z=300.00 name=Temp
    solution name=Qfn val=0 const
    solution name=Qfp val=0 const

    set nc  "([pdbDelayDouble GaN Elec Nc])"
    set nv  "([pdbDelayDouble GaN Hole Nv])"
    set aff "([pdbGetDouble GaN Affinity])"
    set Eg  "([pdbGetDouble GaN Eg])"
    sel z= abs(Doping)+1.0 name=AbsDop

    newton GaN eqn=Doping-Elec+Hole var=DevPsi damp=0.025

    set nc  "([pdbDelayDouble AlGaN Elec Nc])"
    set nv  "([pdbDelayDouble AlGaN Hole Nv])"
    set aff "([pdbGetDouble AlGaN Affinity])"
    set Eg  "([pdbGetDouble AlGaN Eg])"

    newton AlGaN eqn=Doping-Elec+Hole var=DevPsi damp=0.025

    InitMetal

    sel z=0   name=DonorTraps
    sel z=0.0 name=Qfn
    sel z=0.0 name=Qfp
    sel z=0.0 name=Impurity

    device init
    solution add name=Qfp solve negative damp continuous pde
    solution add name=Qfn solve negative damp continuous pde
}
