mater add name=SiC
    
    #Set Youngs Modulus and Poissons Ratio(google)
    pdbSetString SiC YoungsModulus 4.50e12    
    pdbSetString SiC PoissonRatio 0.183

    
    #define the parameters for SiC 
    pdbSetDouble SiC DevPsi RelEps 9.6

    #set SiC electron affinity
    pdbSetDouble SiC Affinity 3.

    #set SiC bandgap
    pdbSetDouble SiC Eg "3.2-((3.3e-2*Temp*Temp)/(1.0e5+Temp))"
    
    #Set Ev and Ec using SiC Ei as zero
    pdbSetDouble SiC Hole Ev "((-[pdbGetDouble SiC Affinity])-([pdbGetDouble SiC Eg])+(DevPsi))"
    pdbSetDouble SiC Elec Ec "((-[pdbGetDouble SiC Affinity])+(DevPsi))"

    #copied from GaN need to look up constants for SiC   
    pdbSetDouble SiC Hole Nv (4.6e19*sqrt(Temp*Temp*Temp/2.7e7))
    pdbSetDouble SiC Elec Nc (2.3e18*sqrt(Temp*Temp*Temp/2.7e7))

    #parameters for SiC low field mobility copied from AlGaN
    #paramters from Roschke and Schwierz, IEEE TED July 2001
    #the paper also has velocity saturation fits as well for SiC, but we don't implement them here
    pdbSetDouble SiC Elec mumin 40.0
    pdbSetDouble SiC Elec mumax 950.0
    pdbSetDouble SiC Elec alpha 0.76
    pdbSetDouble SiC Elec Nref 2e17
    pdbSetDouble SiC Elec Beta1 -2.4
    pdbSetDouble SiC Elec Beta2 -0.5

    set Smumin ([pdbGetDouble SiC Elec mumin])
    set Smumax ([pdbGetDouble SiC Elec mumax])
    set Salph ([pdbGetDouble SiC Elec alpha])
    set SNref ([pdbGetDouble SiC Elec Nref])
    set SBeta1 ([pdbGetDouble SiC Elec Beta1])
    set SBeta2 ([pdbGetDouble SiC Elec Beta2])
 
    #build temperature dependent equation for low field mobility
    set STumax "(($Smumax)*(exp(log(Temp/300)*($SBeta1))))"
    set STumin "(($Smumin)*(exp(log(Temp/300)*($SBeta2))))"
    set STNref "($SNref*(Temp/300))"
    set STDopRef "(exp(log(abs((Doping+1)/$STNref))*Salph))"

    pdbSetDouble SiC Elec lowfldmob "($STumin + ($STumax-$STumin) / (1.0 + $STDopRef))"
    pdbSetDouble SiC Elec mob "([pdbGetDouble SiC Elec lowfldmob])"

    pdbSetDouble SiC Hole mob 320

pdbSetDouble SiC Temp Abs.Error 0.1
pdbSetDouble SiC Temp Rel.Error 1.0e-2
pdbSetDouble SiC Temp DampValue 10.0

pdbSetDouble SiC Thermalk 1.20
pdbSetDouble SiC Heatcap 2.40

set eqn "([pdbGetDouble SiC Heatcap] * ddt(Temp)) - (([pdbGetDouble SiC Thermalk]) * (grad(Temp))) - ($q * [pdbGetDouble SiC Elec mob] * (Elec) * dot(Qfn,Qfn))"
pdbSetString SiC Temp Equation $eqn
