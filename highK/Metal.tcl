mater add name=Metal    

pdbSetDouble Metal Temp Abs.Error 0.1
pdbSetDouble Metal Temp Rel.Error 1.0e-2
pdbSetDouble Metal Temp DampValue 0.025

pdbSetDouble Metal DevPsi RelEps 1.0e12
if {0} {
#set phiB 
#per Ambacher et al, used by Heller, 1.3x+0.84, with x=0.26, but this is with GaN now, so I don't know if Ambacher's formula applies
set phiB 1.65
#set phiB 1.4
#set phiB 1.2255


#Jsut electrostatics for the field plate
pdbSetString FP DevPsi Equation "([pdbDelayDouble Nitride Elec Ec])+FP-$phiB"
pdbSetBoolean FP DevPsi Fixed 1
pdbSetDouble FP DevPsi Flux.Scale 1.602e-19


#Schottky Contact - assume that the contact itself is in contact with the Nitride
#a more complicated way would be to solve the metal and have an interface equation for the current
pdbSetString G DevPsi Equation "([pdbDelayDouble GaN Elec Ec])+G"
pdbSetBoolean G DevPsi Fixed 1
pdbSetDouble G DevPsi Flux.Scale 1.602e-19

set Original 1

if {$Original} {
    #original code to pin holes and electrons. I think since this is ohmic with the GaN, we can pin both.
    pdbSetString G Qfp Equation "Qfp+G"
    pdbSetBoolean G Qfp Fixed 1

    pdbSetString G Qfn Equation "Qfn+G"
    pdbSetBoolean G Qfn Fixed 1

    pdbSetDouble G Qfn Abs.Error 0.01
    pdbSetDouble G Qfn Rel.Error 1.0e-2
    pdbSetDouble G Qfn DampValue 0.0125
    pdbSetDouble G Qfp Abs.Error 1.0
    pdbSetDouble G Qfp Rel.Error 1.0e-1
    pdbSetDouble G Qfp DampValue 0.0125

    #original code had no no equation for Qfn, so comment out the next three lines to go back
} else {
    #thermionic emission current at the contact using guesstimates of the emission velocity
    set p0B "(([pdbDelayDouble Nitride Hole Nv]) * f12( -(([pdbDelayDouble Nitride Eg]) - $phiB) / ($Vt) ))"
    set v_p 2.0e5
    pdbSetString G Qfp Equation "-$v_p * (Hole - $p0B)"
    pdbSetDouble G Qfp Flux.Scale 1.602e-19

    #thermionic emission current for electrons
    set n0B "([pdbDelayDouble Nitride Elec Nc]) * f12( - ($phiB) / ($Vt) )"
    set v_n 2.0e5
    pdbSetString G Qfn Equation "-$v_n * (Elec - $n0B)"
    pdbSetDouble G Qfn Flux.Scale 1.602e-19

    pdbSetDouble G Qfn Abs.Error 0.01
    pdbSetDouble G Qfn Rel.Error 1.0e-2
    pdbSetDouble G Qfn DampValue 0.0125
    pdbSetDouble G Qfp Abs.Error 1.0
    pdbSetDouble G Qfp Rel.Error 1.0e-1
    pdbSetDouble G Qfp DampValue 0.002
}
}

# 1 for Ohmic pGaN contact, 0 for schottky contact with option for basic hole pinning or thermionic emission current
set pGaN 0

if {$pGaN} {

    # Ambachers formula doesn't apply to GaN/Metal contacts,
    # This is the value for the HF02 surrounding the field plate, 
    # which we will model as a schottky contact but I don't know a proven barrier height
    set phiB 1.65

    #Jsut electrostatics for the field plate
    pdbSetString FP DevPsi Equation "([pdbDelayDouble Nitride Elec Ec])+FP-$phiB"; # <- only place with $phiB
    pdbSetBoolean FP DevPsi Fixed 1
    pdbSetDouble FP DevPsi Flux.Scale 1.602e-19


    #Ohmic Contact - assume that the contact itself is in contact with the pGaN
    pdbSetString G DevPsi Equation "([pdbDelayDouble GaN Elec Ec])+G"
    pdbSetBoolean G DevPsi Fixed 1
    pdbSetDouble G DevPsi Flux.Scale 1.602e-19

    #original code to pin holes and electrons. I think since this is ohmic with the GaN, we can pin both.
    pdbSetString G Qfp Equation "Qfp+G"
    pdbSetBoolean G Qfp Fixed 1

    pdbSetString G Qfn Equation "Qfn+G"
    pdbSetBoolean G Qfn Fixed 1

    pdbSetDouble G Qfn Abs.Error 0.01
    pdbSetDouble G Qfn Rel.Error 1.0e-2
    pdbSetDouble G Qfn DampValue 0.0125
    pdbSetDouble G Qfp Abs.Error 1.0
    pdbSetDouble G Qfp Rel.Error 1.0e-1
    pdbSetDouble G Qfp DampValue 0.0125

} else {
    #set phiB 
    #per Ambacher et al, used by Heller, 1.3x+0.84, with x=0.26, but this is with GaN now, so I don't know if Ambacher's formula applies
    set phiB 1.65
    #set phiB 1.4
    #set phiB 1.2255


    #Jsut electrostatics for the field plate
    pdbSetString FP DevPsi Equation "([pdbDelayDouble Nitride Elec Ec])+FP-$phiB"
    pdbSetBoolean FP DevPsi Fixed 1
    pdbSetDouble FP DevPsi Flux.Scale 1.602e-19


    #Schottky Contact - assume that the contact itself is in contact with the Nitride
    #a more complicated way would be to solve the metal and have an interface equation for the current
    pdbSetString G DevPsi Equation "([pdbDelayDouble Nitride Elec Ec])+G-$phiB"
    pdbSetBoolean G DevPsi Fixed 1
    pdbSetDouble G DevPsi Flux.Scale 1.602e-19

    #thermionic emission current at the contact using guesstimates of the emission velocity
    set p0B "(([pdbDelayDouble Nitride Hole Nv]) * f12( -(([pdbDelayDouble Nitride Eg]) - $phiB) / ($Vt) ))"
    set v_p 2.0e5
    pdbSetString G Qfp Equation "-$v_p * (Hole - $p0B)"
    pdbSetDouble G Qfp Flux.Scale 1.602e-19

    #thermionic emission current for electrons
    set n0B "([pdbDelayDouble Nitride Elec Nc]) * f12( - ($phiB) / ($Vt) )"
    set v_n 2.0e5
    pdbSetString G Qfn Equation "-$v_n * (Elec - $n0B)"
    pdbSetDouble G Qfn Flux.Scale 1.602e-19

    pdbSetDouble G Qfn Abs.Error 0.01
    pdbSetDouble G Qfn Rel.Error 1.0e-2
    pdbSetDouble G Qfn DampValue 0.0125
    pdbSetDouble G Qfp Abs.Error 1.0
    pdbSetDouble G Qfp Rel.Error 1.0e-1
    pdbSetDouble G Qfp DampValue 0.002
}

proc InitMetal {} {
    global phiB
    sel z = "Mater(Metal) * ( ([pdbDelayDouble Nitride Affinity])+$phiB)" name=MetalDevPsi
}

#create a procedure for ohmic contacts
proc Ohmic {Mat Contact} {
    global Vt

    pdbSetDouble $Contact Qfp Rel.Error 1.0e-2
    pdbSetDouble $Contact Qfp Abs.Error 1.0e-2
    pdbSetDouble $Contact Qfp DampValue 0.0125
    pdbSetDouble $Contact Qfn Rel.Error 1.0e-2
    pdbSetDouble $Contact Qfn Abs.Error 1.0e-2
    pdbSetDouble $Contact Qfn DampValue 0.0125
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

#Ohmic GaN G
Ohmic Nitride S
Ohmic Nitride D
Ohmic GaN B

