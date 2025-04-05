mater add name=Nitride    alias = nitride

    #set Nitride electron affinity
    pdbSetDouble Nitride Affinity 0.95
    set affO ([pdbDelayDouble Nitride Affinity])

    #set Nitride bandgap
    pdbSetDouble Nitride Eg 9.0
    pdbSetDouble Nitride DevPsi RelEps 6.3

    #Set Ev and Ec using AlGaN Ei as zero
    pdbSetDouble Nitride Hole Ev "((-[pdbGetDouble Nitride Affinity])-([pdbGetDouble Nitride Eg])+(DevPsi))"
    pdbSetDouble Nitride Elec Ec "((-[pdbGetDouble Nitride Affinity])+(DevPsi))"

mater add name=Oxide    alias=oxide
    #et Oxide electron affinity
    pdbSetDouble Oxide Affinity 2.89

    pdbSetDouble Oxide DevPsi RelEps 3.9
    pdbSetDouble Oxide Eg 9.3
   
    #Set Ev and Ec using AlGaN Ei as zero
    pdbSetDouble Oxide Hole Ev "((-[pdbGetDouble Oxide Affinity])-([pdbGetDouble Oxide Eg])+(DevPsi))"
    pdbSetDouble Oxide Elec Ec "((-[pdbGetDouble Oxide Affinity])+(DevPsi))"

mater add name=HighK    alias=highk
    #et Oxide electron affinity
    pdbSetDouble HighK Affinity 2.89

    pdbSetDouble HighK DevPsi RelEps 35
    pdbSetDouble HighK Eg 9.3
   
    #Set Ev and Ec using AlGaN Ei as zero
    pdbSetDouble HighK Hole Ev "((-[pdbGetDouble Oxide Affinity])-([pdbGetDouble Oxide Eg])+(DevPsi))"
    pdbSetDouble HighK Elec Ec "((-[pdbGetDouble Oxide Affinity])+(DevPsi))"



pdbSetDouble Nitride Temp Abs.Error 0.1
pdbSetDouble Nitride Temp Rel.Error 1.0e-2
pdbSetDouble Nitride Temp DampValue 10.0
pdbSetDouble Oxide Temp Abs.Error 0.1
pdbSetDouble Oxide Temp Rel.Error 1.0e-2
pdbSetDouble Oxide Temp DampValue 10.0

pdbSetDouble Nitride Thermalk 2.85
pdbSetDouble Nitride Heatcap 2.584


pdbSetDouble Nitride Temp Abs.Error 0.1
pdbSetDouble Nitride Temp Rel.Error 1.0e-2
pdbSetDouble Nitride Temp DampValue 10.0
pdbSetDouble Oxide Temp Abs.Error 0.1
pdbSetDouble Oxide Temp Rel.Error 1.0e-2
pdbSetDouble Oxide Temp DampValue 10.0

pdbSetDouble Nitride Thermalk 2.85
pdbSetDouble Nitride Heatcap 2.584

pdbSetDouble Oxide Thermalk 2.85
pdbSetDouble Oxide Heatcap 2.584

set eqn "([pdbGetDouble Nitride Heatcap] * ddt(Temp)) - (([pdbGetDouble Nitride Thermalk]) * (grad(Temp)))"
pdbSetString Nitride Temp Equation $eqn

set eqn "([pdbGetDouble Oxide Heatcap] * ddt(Temp)) - (([pdbGetDouble Oxide Thermalk]) * (grad(Temp)))"
pdbSetString Oxide Temp Equation $eqn

proc InitInsulator {Mat} {
    sel z = "Mater($Mat) * [pdbDelayDouble AlGaN Affinity]" name=DevPsi$Mat
}
