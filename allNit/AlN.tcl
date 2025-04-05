mater add name=AlN
    
    #Set Youngs Modulus and Poissons Ratio(google)
    pdbSetString AlN YoungsModulus 3.31e12
    pdbSetString AlN PoissonRatio 0.25
    
    
    #define the parameters for AlN 
    pdbSetDouble AlN DevPsi RelEps 8.5

    #set AlN electron affinity
    pdbSetDouble AlN Affinity 1.2121

    #set AlN bandgap
    pdbSetDouble AlN Eg "6.13+((1.80e-3*300*300)/(1.462e3+300))-((1.80e-3*Temp*Temp)/(1.462e3+Temp))"
    
    #Set Ev and Ec using AlN Ei as zero
    pdbSetDouble AlN Hole Ev "((-[pdbGetDouble AlN Affinity])-([pdbGetDouble AlN Eg])+(DevPsi))"
    pdbSetDouble AlN Elec Ec "((-[pdbGetDouble AlN Affinity])+(DevPsi))"

    #Set AlN Nc and Nv 
    pdbSetDouble AlN Hole Nv (4.6e19*sqrt(Temp*Temp*Temp/2.7e7))
    pdbSetDouble AlN Elec Nc (2.3e18*sqrt(Temp*Temp*Temp/2.7e7))

    #parameters for AlN low field mobility from Farahmand, et al, IEEE TED March 2001
    pdbSetDouble AlN Elec mumin 297.8
    pdbSetDouble AlN Elec mumax 683.8
    pdbSetDouble AlN Elec alpha 1.16
    pdbSetDouble AlN Elec beta1 -1.82
    pdbSetDouble AlN Elec beta2 -3.43
    pdbSetDouble AlN Elec beta3 3.78
    pdbSetDouble AlN Elec beta4 0.86
    pdbSetDouble AlN Elec Nref 1e17

    set ANmumin ([pdbGetDouble AlN Elec mumin])
    set ANmumax ([pdbGetDouble AlN Elec mumax])
    set ANlowalpha ([pdbGetDouble AlN Elec alpha])
    set ANbeta1 ([pdbGetDouble AlN Elec beta1])
    set ANbeta2 ([pdbGetDouble AlN Elec beta2])
    set ANbeta3 ([pdbGetDouble AlN Elec beta3])
    set ANbeta4 ([pdbGetDouble AlN Elec beta4])
    set ANNref ([pdbGetDouble AlN Elec Nref])
 
    #build equation for low field mobility
    set ANseg1 "($ANmumin)*(exp(log(Temp/300)*($ANbeta1)))"
    set ANseg2 "($ANmumax-$ANmumin)*(exp(log(Temp/300)*($ANbeta2)))"
    set ANseg3 "$ANNref*(exp(log(Temp/300)*($ANbeta3)))"
    set ANseg4 "abs((Doping+1)/$ANseg3)"
    set ANseg5 "$ANlowalpha*(exp(log(Temp/300)*($ANbeta4)))"
    set ANseg6 "exp(log($ANseg4)*($ANseg5))"
    set ANseg7 "1+$ANseg6"

    pdbSetDouble AlN Elec lowfldmob "($ANseg1+(($ANseg2)/($ANseg7)))"
  
    #set electron mobility via analytical expression from Farahmand for high field mobility U=0
    pdbSetDouble AlN Elec alpha 8.7253
    pdbSetDouble AlN Elec n1 17.3681
    pdbSetDouble AlN Elec n2 0.8554
    pdbSetDouble AlN Elec Ecmob 447033.9
    pdbSetDouble AlN vsat 2.167e7 
   
    set ANlowfldmob ([pdbGetDouble AlN Elec lowfldmob]) 
    set ANhighalpha ([pdbGetDouble AlN Elec alpha])
    set ANn1 ([pdbGetDouble AlN Elec n1])
    set ANn2 ([pdbGetDouble AlN Elec n2])
    set ANEcmob ([pdbGetDouble AlN Elec Ecmob])
    set ANvsat ([pdbGetDouble AlN vsat])
    set ANEfield "(sqrt(dot(DevPsi,DevPsi)+1.0e2))"
    set ANEfield_EcRatio "($ANEfield)/($ANEcmob)"

    set ANEn1 "exp(log($ANEfield_EcRatio)*($ANn1-1))"
    set ANEn2 "exp(log($ANEfield_EcRatio)*($ANn2))"

    set ANnum "($ANlowfldmob+($ANvsat*($ANEn1)/($ANEcmob)))"
    set ANden "(1.0+($ANhighalpha*($ANEn2))+($ANEn1*$ANEfield_EcRatio))"

    pdbSetDouble AlN Elec mob $ANlowfldmob

    #pdbSetDouble AlN Elec mob "($ANnum)/($ANden)"
    #pdbSetDouble AlN Elec mob 230
    
    pdbSetDouble AlN Hole mob 14.0

pdbSetDouble AlN Temp Abs.Error 0.1
pdbSetDouble AlN Temp Rel.Error 1.0e-2
pdbSetDouble AlN Temp DampValue 10.0

#Set thermal transport parameters

pdbSetDouble AlN Thermalk 2.85
pdbSetDouble AlN Heatcap 2.584

#Thermal Transport Equations

set eqn "([pdbGetDouble AlN Heatcap] * ddt(Temp)) - (([pdbGetDouble AlN Thermalk]) * (grad(Temp))) - ($q * [pdbGetDouble AlN Elec mob] * (Elec) * dot(Qfn,Qfn))"
pdbSetString AlN Temp Equation $eqn

