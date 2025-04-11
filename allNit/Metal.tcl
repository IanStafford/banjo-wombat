mater add name=Metal    

pdbSetDouble Metal Temp Abs.Error 0.1
pdbSetDouble Metal Temp Rel.Error 1.0e-2
pdbSetDouble Metal Temp DampValue 10.0

pdbSetDouble Metal DevPsi RelEps 1.0e12

#set phiB 
#per Ambacher et al, used by Heller, 1.3x+0.84, with x=0.26
set phiB 1.126
# 1.2255 initially
# with AlN ratio of 0.22 we have theoretical value of 1.126

pdbSetString FP DevPsi Equation "([pdbDelayDouble AlGaN Elec Ec])+FP-$phiB"
pdbSetBoolean FP DevPsi Fixed 1
pdbSetDouble FP DevPsi Flux.Scale 1.602e-19

pdbSetString G DevPsi Equation "([pdbDelayDouble AlGaN Elec Ec])+G-$phiB"
pdbSetBoolean G DevPsi Fixed 1
pdbSetDouble G DevPsi Flux.Scale 1.602e-19

pdbSetString G Qfp Equation "Qfp+G"
pdbSetBoolean G Qfp Fixed 1
pdbSetDouble G Qfp Flux.Scale 1.602e-19
set eqn "200 * 5.0e12 * grad(Qfp)"
pdbSetString Metal Qfp Equation $eqn

proc InitMetal {} {
    global phiB
    sel z = "Mater(Metal) * ( ([pdbDelayDouble AlGaN Affinity])+$phiB)" name=MetalDevPsi
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

