# =============================================================================================================
# New metal code with schottky contact and option for thermionic emission current as well as ohmic pGaN contact
# =============================================================================================================

mater add name=Metal
pdbSetDouble Metal Temp Abs.Error 0.1
pdbSetDouble Metal Temp Rel.Error 1.0e-2
pdbSetDouble Metal Temp DampValue 10.0
pdbSetDouble Metal DevPsi RelEps 1.0e12

#pdbSetString Metal Qfp Equation "Qfp + G"
#pdbSetBoolean Metal Qfp Fixed 1
#pdbSetDouble  Metal Qfp DampValue 0.025
#pdbSetDouble  Metal Qfp Flux.Scale 1.602e-19

if {0} {
    pdbSetString Metal Qfn Equation "Qfn + G"
    pdbSetBoolean Metal Qfn Fixed 1
    pdbSetDouble  Metal Qfn DampValue 0.025
    pdbSetDouble  Metal Qfn Flux.Scale 1.602e-19
}

#create a procedure for ohmic contacts
proc Ohmic {Mat Contact} {
    global Vt

    pdbSetDouble $Contact Qfp Rel.Error 1.0e-2
    pdbSetDouble $Contact Qfp Abs.Error 1.0e-2
    pdbSetDouble $Contact Qfp DampValue 0.025
    pdbSetDouble $Contact Qfn Rel.Error 1.0e-2
    pdbSetDouble $Contact Qfn Abs.Error 1.0e-2
    pdbSetDouble $Contact Qfn DampValue 0.025
    pdbSetDouble $Contact DevPsi Rel.Error 1.0e-2
    pdbSetDouble $Contact DevPsi Abs.Error 1.0e-2
    pdbSetDouble $Contact DevPsi DampValue 0.025

    #set all quantities fixed here
    pdbSetBoolean $Contact Qfn Fixed 1
    pdbSetBoolean $Contact Qfp Fixed 1
    pdbSetBoolean $Contact DevPsi Fixed 1

    #we'd like to keep fluxes around
    pdbSetBoolean $Contact Qfn Flux 1
    pdbSetBoolean $Contact Qfp Flux 1
    pdbSetBoolean $Contact DevPsi Flux 1

    pdbSetDouble $Contact Qfn Flux.Scale 1.602e-19
    pdbSetDouble $Contact Qfp Flux.Scale 1.602e-19
    pdbSetDouble $Contact DevPsi Flux.Scale 1.602e-19

    pdbSetString $Contact DevPsi Equation "Doping-Elec+Hole"
    pdbSetString $Contact Qfn Equation "Qfn+$Contact"
    pdbSetString $Contact Qfp Equation "Qfp+$Contact"
}

Ohmic AlGaN S
Ohmic AlGaN D
Ohmic GaN B

proc SchottkyPGaN2 {Mat Contact} {
    global Vt k q h mo0 egan
    # Trying this from scratch
    # Boilerplate solver settings
    pdbSetDouble $Contact Qfp Rel.Error 1.0e-2
    pdbSetDouble $Contact Qfp Abs.Error 1.0e-2
    pdbSetDouble $Contact Qfp DampValue 0.025
    #pdbSetDouble $Contact Qfn Rel.Error 1.0e-2
    #pdbSetDouble $Contact Qfn Abs.Error 1.0e-2
    #pdbSetDouble $Contact Qfn DampValue 0.025
    pdbSetDouble $Contact DevPsi Rel.Error 1.0e-2
    pdbSetDouble $Contact DevPsi Abs.Error 1.0e-2
    pdbSetDouble $Contact DevPsi DampValue 0.025

    # Metal/pGaN barrier height from table IV 0.85-0.9 eV
    set phiP 0.85

    set e "(-([pdbDelayDouble $Mat Affinity]) - [pdbDelayDouble $Mat Eg]) + DevPsi + $Contact +$phiP"
    pdbSetString $Contact DevPsi Equation $e  
    pdbSetBoolean $Contact DevPsi Fixed 1
    pdbSetDouble $Contact DevPsi Flux.Scale 1.602e-19

    # Electron pileup at metal/pGaN interface... need a thermionic emission current
    # Just going to adapt an old one for now
    set vn 1.0e5
    set ni 3.0e-10

    #set ni2 "[expr {$ni * $ni}]"
    if {1} {
        set eqn "($q * $vn * (Elec - $ni * $ni * (1.0 / Hole+1.0)))"
        pdbSetString G Qfn Equation $eqn
        pdbSetDouble $Contact Qfn Fixed 0
        pdbSetDouble $Contact Qfn Flux 1
        pdbSetDouble $Contact Qfn Flux.Scale 1.602e-19
    }
    # Richardson constant for holes
    # A* = 4*pi*q*mp*k^2/h^3, where mp is the effective mass of holes in GaN, 
    set Astar [expr {12.5663 * $q * 0.8 * $mo0 * pow($k, 2) / pow($h, 3) * 1.0e-4}] ;# in A/cm^2/K^2
    set Astar 96.1

    # not super sure what this quantity is physically
    set beta [expr sqrt($q / (3.14159 * $egan * 1.0e-2))]

    # psi_a is the Mg activation energy 0.16-0.17 eV from Alves et al as well as Bhat et al.
    set psiA 0.16
    set Na 1.0e19

    # Equation 2 from Bhat et al.
    set Vsh0 "(sqrt(2.0*$egan*($phiP - $psiA)/($q*$Na)))"

    # Equation 16 need to find Vbarrier, going to try 2.15 for now
    set Vbarrier 2.15
    set Emax "sqrt(abs(2.0*$q*$Na*(G - $Vsh0 + $Vbarrier)/$egan) + 1.0)"

    # Thermionic emission current density (equation 15)
    set kT "($k * Temp / $q)"
    #set JTE "$Astar * Temp * Temp * exp(-($phiP - $beta * sqrt($Emax)))"
    set JTE2 "($Astar * Temp * Temp * exp(-($phiP-$beta * sqrt($Emax))) / ($Vt)) * (exp($Contact-Qfp/ $Vt) - 1)"
    pdbSetString $Contact Qfp Equation $JTE2
    pdbSetBoolean $Contact Qfp Fixed 0
    pdbSetBoolean $Contact Qfp Flux 1
    pdbSetDouble $Contact Qfp Flux.Scale 1.602e-19


}

proc SchottkyPGaN {Mat Contact} {
    global Vt k q h mo0 egan
    # Trying this from scratch
    # Boilerplate solver settings
    pdbSetDouble $Contact Qfp Rel.Error 1.0e-2
    pdbSetDouble $Contact Qfp Abs.Error 1.0e-2
    pdbSetDouble $Contact Qfp DampValue 0.025
    pdbSetDouble $Contact DevPsi Rel.Error 1.0e-2
    pdbSetDouble $Contact DevPsi Abs.Error 1.0e-2
    pdbSetDouble $Contact DevPsi DampValue 0.025

    # Metal/pGaN barrier height from table IV 0.85-0.9 eV
    set phiP 0.85

    set e "(-([pdbDelayDouble $Mat Affinity]) - [pdbDelayDouble $Mat Eg]) + DevPsi + $Contact +$phiP"
    pdbSetString $Contact DevPsi Equation $e  
    pdbSetBoolean $Contact DevPsi Fixed 1
    pdbSetDouble $Contact DevPsi Flux.Scale 1.602e-19

    # Qfn floating, don't think electron current is physical due to 
    # The total lack of electron density in the region
    pdbSetBoolean $Contact Qfn Fixed 0

    # Richardson constant for holes
    # A* = 4*pi*q*mp*k^2/h^3, where mp is the effective mass of holes in GaN, 
    set Astar [expr {12.5663 * $q * 0.8 * $mo0 * pow($k, 2) / pow($h, 3) * 1.0e-4}] ;# in A/cm^2/K^2
    set Astar 96.1

    # not super sure what this quantity is physically
    set beta [expr sqrt($q / (3.14159 * $egan * 1.0e-2))]

    # psi_a is the Mg activation energy 0.16-0.17 eV from Alves et al as well as Bhat et al.
    set psiA 0.16
    set Na 1.0e19

    # Equation 2 from Bhat et al.
    set Vsh0 "(sqrt(2.0*$egan*($phiP - $psiA)/($q*$Na)))"

    # Equation 16 need to find Vbarrier, going to try 2.15 for now
    set Vbarrier 2.15
    set Emax "sqrt(abs(2.0*$q*$Na*(G - $Vsh0 + $Vbarrier)/$egan) + 1.0)"

    # Thermionic emission current density
    set kT "($k * Temp / $q)"
    #set JTE "$Astar * Temp * Temp * exp(-($phiP - $beta * sqrt($Emax)))"
    # Needed the extra feedback term, wrapped in exponent to keep units same. May need to take it all out of exponents??? not sure
    set JTE2 "($Astar * Temp * Temp * exp(-($phiP-$beta * sqrt($Emax))) / ($Vt)) * (exp($Contact-Qfp/ $Vt) - 1)"

    pdbSetString G Qfp Equation $JTE2
    pdbSetBoolean $Contact Qfp Fixed 0
    pdbSetBoolean $Contact Qfp Flux 1
    pdbSetDouble $Contact Qfp Flux.Scale 1.602e-19


}

if {![info exists eMode]} { set eMode 0.0 }
set eMode 1.0

    # Fieldplate electrostatics - Present in both the schottky and ohmic cases, but with different phiB

    # Using AlGaN Ec because we aren't getting current through it anyway.
    # If we used Nitride Ec we would have diff model for gate and FP
    set phiB 1.65; # Placeholder for field plate when using pGaN contact
    pdbSetString FP DevPsi Equation "([pdbDelayDouble Nitride Elec Ec])+FP-$phiB"
    pdbSetBoolean FP DevPsi Fixed 1
    pdbSetDouble FP DevPsi Flux.Scale 1.602e-19

if {0} {
    # Ambacher's formula can be applied when we have AlGaN/Metal or potentially with a thin layer of Nitride,
    # but not with pGaN/Metal, so only set phiB if we don't have a pGaN contact
    # 1.3x+0.84, where x is the Al mole fraction, so with x=0.26, this gives 1.2255 eV, but I don't know if Ambacher's formula applies to GaN/Metal contacts,
    # so I'm using a higher value that is more consistent with the literature for GaN/Metal schottky contacts


    # Schottky Contact - assume that the contact itself is in contact with the AlGaN or very close thru thin layer of SiN
    pdbSetString G DevPsi Equation "([pdbDelayDouble Nitride Elec Ec])+G-$phiB"
    pdbSetBoolean G DevPsi Fixed 1
    pdbSetDouble G DevPsi Flux.Scale 1.602e-19

    # Pin holes, leave Qfn floating
    pdbSetString G Qfp Equation "Qfp+G"
    pdbSetBoolean G Qfp Fixed 1
    #pdbSetDouble G Qfp Flux.Scale 1.602e-19
    #set eqn "200 * 5.0e12 * grad(Qfp)"
    #pdbSetString Metal Qfp Equation $eqn

}

    SchottkyPGaN2 GaN2 G

proc InitMetal {} {
    global phiP psiA
    set phiP 0.85    
    set psiA 0.16    

    if {1} {
        # DevPsi_metal = Affinity_GaN2 + Eg_GaN2 - phiP
        # psiA = Mg activation energy = 0.16 eV (cancels but
        # included explicitly for clarity)
        sel z = "Mater(Metal) * ([pdbDelayDouble GaN2 Affinity] +[pdbDelayDouble GaN2 Eg] -$phiP)" name=MetalDevPsi
    } else {
        sel z = "Mater(Metal) * ([pdbDelayDouble AlGaN Affinity]+$phiB)" name=MetalDevPsi; # for regular d mode device
    }
}
