#initialize device simulation
DevicePackage

####################################
#rate kinetics
##################################


#########################################################################################
#constants for each material
#########################################################################################

set k 1.38066e-23
set q 1.60218e-19
set Vt ($k*Temp/$q)
set eps0 8.854e-14

#Set Youngs Modulus and Poissons Ratio
pdbSetString Oxide YoungsModulus 7.5e11
pdbSetString Oxide PoissonRatio 0.17

pdbSetString OxPhase YoungsModulus 7.5e11
pdbSetString OxPhase PoissonRatio 0.17


#paramaters for Nickel form wikipedia
pdbSetString metal YoungsModulus 2.0e12
pdbSetString metal PoissonRatio 0.31


#create all the materials we need to have
mater add name=GaN

	#Set Youngs Modulus and Poissons Ratio(for WZ crystal 0001 plane) plus temperature dependance ***check this number
	pdbSetString GaN YoungsModulus (3.9e12-0.16e10*(Temp-300.0))
	pdbSetString GaN PoissonRatio 0.352

    #set some GaN parameters
    pdbSetDouble GaN DevPsi RelEps 8.9
    
    #set GaN electron affinity
    
    pdbSetDouble GaN Affinity 3.1
	    
    #set Bandgap according to Eric Heller info
    pdbSetDouble GaN Eg (3.51-(7.7e-4*Temp*Temp)/(600+Temp))

    #set Ev and Ec for GaN 
    pdbSetDouble GaN Hole Ev "((-[pdbGetDouble GaN Affinity])-([pdbGetDouble GaN Eg])+(DevPsi))"
    pdbSetDouble GaN Elec Ec "((-[pdbGetDouble GaN Affinity])+(DevPsi))"

    pdbSetDouble GaN Hole Nv (4.6e19*sqrt(Temp*Temp*Temp/2.7e7))
    pdbSetDouble GaN Elec Nc (2.3e18*sqrt(Temp*Temp*Temp/2.7e7))

    #set low field electron mobility via analytical expression from Farahmand for low field mobility


    #paramters for GaN for low field mobility from Farahmand
    pdbSetDouble GaN Elec mumin 295.0
    pdbSetDouble GaN Elec mumax 1907    ;#1460.7 before
    pdbSetDouble GaN Elec alpha 0.66
    pdbSetDouble GaN Elec beta1 -1.02
    pdbSetDouble GaN Elec beta2 -3.84
    pdbSetDouble GaN Elec beta3 3.02
    pdbSetDouble GaN Elec beta4 0.81
    pdbSetDouble GaN Elec Nref 1e17 


    set Gmumin ([pdbGetDouble GaN Elec mumin])
    set Gmumax ([pdbGetDouble GaN Elec mumax])
    set Glowalpha ([pdbGetDouble GaN Elec alpha])
    set Gbeta1 ([pdbGetDouble GaN Elec beta1])
    set Gbeta2 ([pdbGetDouble GaN Elec beta2])
    set Gbeta3 ([pdbGetDouble GaN Elec beta3])
    set Gbeta4 ([pdbGetDouble GaN Elec beta4])
    set GNref ([pdbGetDouble GaN Elec Nref])
 
    #build equation for low field mobility
    set Gseg1 "$Gmumin*(1*exp(log(Temp/300)*($Gbeta1)))"
    set Gseg2 "($Gmumax-$Gmumin)*(1*exp(log(Temp/300)*($Gbeta2)))"
    set Gseg3 "$GNref*(1*exp(log(Temp/300)*($Gbeta3)))"
    set Gseg4 "abs((Doping+Donor+Acceptor+1)/$Gseg3)";     #modified to include ionized donor or acceptor traps
    set Gseg5 "$Glowalpha*(1*exp(log(Temp/300)*($Gbeta4)))"
    set Gseg6 "1*exp(log($Gseg4)*($Gseg5))"
    set Gseg7 "1+$Gseg6"
    set Gseg8 "($Gseg2)/($Gseg7)"

    #pdbSetDouble GaN Elec lowfldmob "($Gseg1+(($Gseg2)/($Gseg7)))"
    #pdbSetDouble GaN Elec lowfldmob $Gseg1+((($Gmumax-$Gmumin)*(exp(log(Temp/300)*($Gbeta2))))/($Gseg7))
    pdbSetDouble GaN Elec lowfldmob "($Gseg1)+($Gseg8)"



    #parameters for GaN low field mobility using Eric Heller's equations
    set top "1630"
    set bot1 "(Temp/300)"
    set bot2 "exp(log($bot1)*(1.88))"
    set ericmob "($top)/($bot2)"

    #pdbSetDouble GaN Elec lowfldmob $ericmob
   
    #pdbSetDouble GaN Elec mob $ericmob
   
    #parameters and expression for high field mobility using Eric Heller's equations
    set Gvsat "3.3e7-(3.0e6*(Temp/300))"
    set Gbeta "0.85*(exp(log(Temp/300)*(0.4)))"
    set GEfield "abs(dot(DevPsi,y*1e-4))+1"

    #set GEfield "(sqrt(dot(DevPsi,DevPsi)+1.0))"

    #set GEfield "(sqrt(dot(Qfn,Qfn)+1.0))"

    set G1 "((([pdbGetDouble GaN Elec lowfldmob])*($GEfield))/($Gvsat))"
    set G2 "(exp(log($G1)*($Gbeta)))"
    set G3 "(1+($G2))"
    set G4 "(1/$Gbeta)"
    set G5 "(exp(log($G3)*($G4)))"

    set Ghigh "(([pdbGetDouble GaN Elec lowfldmob])/($G5))"
      
    pdbSetDouble GaN Elec mob $Ghigh   ; # turn this one back on to get Farhamand mobility
   
    #set parameters for GaN High Field mobility from Farahmand 
    pdbSetDouble GaN Elec alpha 6.1973
    pdbSetDouble GaN Elec n1 7.2044
    pdbSetDouble GaN Elec n2 0.7857
    pdbSetDouble GaN Elec Ecmob 220893.6
    pdbSetDouble GaN vsat 1.9064e7 
    pdbSetDouble GaN vsat (2.7e7/(1+0.8*exp(Temp/600)))

    #set electron mobility via analytical expression from Farahmand for high field mobility

    set Glowfldmob ([pdbGetDouble GaN Elec lowfldmob]) 
    set Ghighalpha ([pdbGetDouble GaN Elec alpha])
    set Gn1 ([pdbGetDouble GaN Elec n1])
    set Gn2 ([pdbGetDouble GaN Elec n2])
    set GEcmob ([pdbGetDouble GaN Elec Ecmob])
    set Gvsat ([pdbGetDouble GaN vsat])
    set GEfield1 "abs(dot(DevPsi,y*1.e-4))+1"    

    set GEfield_EcRatio1 "(($GEfield1)/($GEcmob))"
    set GEn1_1 "(exp(log($GEfield1)*($Gn1-1)))"
    set GEn1_3 "(exp(log($GEcmob)*($Gn1)))"
    set GEn1_2 "(exp(log($GEfield_EcRatio1)*($Gn1)))"
    set GEn2_1 "(exp(log($GEfield_EcRatio1)*($Gn2)))"
    set num1 "($Glowfldmob+($Gvsat*(($GEn1_1)/($GEn1_3))))"
    set denom1 "(1.0+($Ghighalpha*($GEn2_1))+($GEn1_2))"

    #set testmob1 "($num1)/($denom1)"

# set GaN mobility as a constatn based on Lu's results for 1um AFRL devices 1907 cm2/V-s
    #pdbSetDouble GaN Elec mob 1907      ;# 1907,  decrease 41% with 2e14 radiation is 1125  

    #set hole mobility as constant
    pdbSetDouble GaN Hole mob 100

mater add name=AlGaN
    #define the parameters for AlGaN - all depend on a AlN_Ratio being set as a spatial variable
    pdbSetDouble AlGaN DevPsi RelEps 9.0

    #Set Youngs Modulus and Poissons Ratio(approximation from Nanoindentation in AlGaN paper, Caceres '99)
	pdbSetString AlGaN YoungsModulus (3.9e12+(5.555e11*AlN_Ratio)-0.16e10*(Temp-300.0))
	pdbSetString AlGaN PoissonRatio 0.352

    
    #set AlN_Eg 6.13

    #set AlGaN electron affinity
    pdbSetDouble AlGaN Affinity "((2.02275*(1-AlN_Ratio))+1.07725)"

    #set AlGaN bandgap-Don't know where the 1.3 value comes from
    pdbSetDouble AlGaN Eg "(6.13*AlN_Ratio+[pdbDelayDouble GaN Eg]*(1-AlN_Ratio)-1.0*AlN_Ratio*(1-AlN_Ratio))"

    #Set Ev and Ec using AlGaN Ei as zero
    pdbSetDouble AlGaN Hole Ev "((-[pdbGetDouble AlGaN Affinity])-([pdbGetDouble AlGaN Eg])+(DevPsi))"
    pdbSetDouble AlGaN Elec Ec "((-[pdbGetDouble AlGaN Affinity])+(DevPsi))"

    #copied from Full deck, don't know where the constants come from
    pdbSetDouble AlGaN Elec me "((0.4*AlN_Ratio+0.20*(1-AlN_Ratio)))"
    pdbSetDouble AlGaN Hole mh "((1.5*AlN_Ratio+3.53*(1-AlN_Ratio)))"

    set me ([pdbDelayDouble AlGaN Elec me])
    set mh ([pdbDelayDouble AlGaN Hole mh])
    pdbSetDouble AlGaN Elec Nc (2.50945e19*sqrt($me*$me*$me)*sqrt(Temp*Temp*Temp/2.7e7))
    pdbSetDouble AlGaN Hole Nv (2.50945e19*sqrt($mh*$mh*$mh)*sqrt(Temp*Temp*Temp/2.7e7))
  
    #parameters for AlGaN low field mobility U=0
    pdbSetDouble AlGaN Elec mumin 312.1
    pdbSetDouble AlGaN Elec mumax 1401.3
    pdbSetDouble AlGaN Elec alpha 0.74
    pdbSetDouble AlGaN Elec beta1 -6.51
    pdbSetDouble AlGaN Elec beta2 -2.31
    pdbSetDouble AlGaN Elec beta3 7.07
    pdbSetDouble AlGaN Elec beta4 -0.86
    pdbSetDouble AlGaN Elec Nref 1e17


    #parameters for AlGaN low field mobility U=deltaEc
    #pdbSetDouble AlGaN Elec mumin 132.0
    #pdbSetDouble AlGaN Elec mumax 306.1
    #pdbSetDouble AlGaN Elec alpha 0.29
    #pdbSetDouble AlGaN Elec beta1 -1.33
    #pdbSetDouble AlGaN Elec beta2 -1.75
    #pdbSetDouble AlGaN Elec beta3 6.02
    #pdbSetDouble AlGaN Elec beta4 1.44
    #pdbSetDouble AlGaN Elec Nref 1e17


    set Amumin ([pdbGetDouble AlGaN Elec mumin])
    set Amumax ([pdbGetDouble AlGaN Elec mumax])
    set Alowalpha ([pdbGetDouble AlGaN Elec alpha])
    set Abeta1 ([pdbGetDouble AlGaN Elec beta1])
    set Abeta2 ([pdbGetDouble AlGaN Elec beta2])
    set Abeta3 ([pdbGetDouble AlGaN Elec beta3])
    set Abeta4 ([pdbGetDouble AlGaN Elec beta4])
    set ANref ([pdbGetDouble AlGaN Elec Nref])
 
    #build equation for low field mobility
    set Aseg1 "$Amumin*(exp(log(Temp/300)*($Abeta1)))"
    set Aseg2 "($Amumax-$Amumin)*(exp(log(Temp/300)*($Abeta2)))"
    set Aseg3 "$ANref*(exp(log(Temp/300)*($Abeta3)))"
    set Aseg4 "abs((Doping+1)/$Aseg3)"
    set Aseg5 "$Alowalpha*(exp(log(Temp/300)*($Abeta4)))"
    set Aseg6 "exp(log($Aseg4)*($Aseg5))"
    set Aseg7 "1+$Aseg6"

    pdbSetDouble AlGaN Elec lowfldmob "($Aseg1+(($Aseg2)/($Aseg7)))"
  
    #set electron mobility via analytical expression from Farahmand for high field mobility U=0
    #pdbSetDouble AlGaN Elec lowfldmob 213.1
    pdbSetDouble AlGaN Elec alpha 6.9502
    pdbSetDouble AlGaN Elec n1 7.8138
    pdbSetDouble AlGaN Elec n2 0.7897
    pdbSetDouble AlGaN Elec Ecmob 245579.4
    pdbSetDouble AlGaN vsat 2.02e7 
    #pdbSetDouble AlGel N vsat ((2.5e7*AlN_Ratio)+(1.4e7*(1-AlN_Ratio)))

    #set electron mobility via analytical expression from Farahmand for high field mobility U=deltaEc
    #pdbSetDouble AlGaN Elec lowfldmob 213.1
    #pdbSetDouble AlGaN Elec alpha 3.2332
    #pdbSetDouble AlGaN Elec n1 5.3193
    #pdbSetDouble AlGaN Elec n2 1.0396
    #pdbSetDouble AlGaN Elec Ecmob 365552.9
    #pdbSetDouble AlGaN vsat 1.1219e5 
    #pdbSetDouble AlGaN vsat ((2.5e7*AlN_Ratio)+(1.4e7*(1-AlN_Ratio)))

    set Alowfldmob ([pdbGetDouble AlGaN Elec lowfldmob]) 
    set Ahighalpha ([pdbGetDouble AlGaN Elec alpha])
    set An1 ([pdbGetDouble AlGaN Elec n1])
    set An2 ([pdbGetDouble AlGaN Elec n2])
    set AEcmob ([pdbGetDouble AlGaN Elec Ecmob])
    set Avsat ([pdbGetDouble AlGaN vsat])
    set AEfield "(sqrt(dot(DevPsi,DevPsi)+1.0e2))"
    set AEfield_EcRatio "($AEfield)/($AEcmob)"

    set AEn1 "exp(log($AEfield_EcRatio)*($An1-1))"
    set AEn2 "exp(log($AEfield_EcRatio)*($An2))"

    set Anum "($Alowfldmob+($Avsat*($AEn1)/($AEcmob)))"
    set Aden "(1.0+($Ahighalpha*($AEn2))+($AEn1*$AEfield_EcRatio))"


    #pdbSetDouble AlGaN Elec mob $Alowfldmob
    
    #pdbSetDouble AlGaN Elec mob "($Anum)/($Aden)"
    pdbSetDouble AlGaN Elec mob 213.3

    pdbSetDouble AlGaN Hole mob 0.2

mater add name=SiC
    
    #Set Youngs Modulus and Poissons Ratio(google)
	pdbSetString SiC YoungsModulus 4.50e12    
	pdbSetString SiC PoissonRatio 0.183

    
    #define the parameters for SiC 
    pdbSetDouble SiC DevPsi RelEps 9.6

    #set SiC electron affinity
    pdbSetDouble SiC Affinity 3.7

    #set SiC bandgap
    pdbSetDouble SiC Eg "3.2-((3.3e-2*Temp*Temp)/(1.0e5+Temp))"
    

    #Set Ev and Ec using SiC Ei as zero
    pdbSetDouble SiC Hole Ev "((-[pdbGetDouble SiC Affinity])-([pdbGetDouble SiC Eg])+(DevPsi))"
    pdbSetDouble SiC Elec Ec "((-[pdbGetDouble SiC Affinity])+(DevPsi))"

    #copied from GaN need to look up constants for SiC   
    pdbSetDouble SiC Hole Nv (4.6e19*sqrt(Temp*Temp*Temp/2.7e7))
    pdbSetDouble SiC Elec Nc (2.3e18*sqrt(Temp*Temp*Temp/2.7e7))

    #parameters for SiC low field mobility copied from AlGaN
    pdbSetDouble SiC Elec mumin 312.1
    pdbSetDouble SiC Elec mumax 1401.3
    pdbSetDouble SiC Elec alpha 0.74
    pdbSetDouble SiC Elec beta1 -6.51
    pdbSetDouble SiC Elec beta2 -2.31
    pdbSetDouble SiC Elec beta3 7.07
    pdbSetDouble SiC Elec beta4 -0.86
    pdbSetDouble SiC Elec Nref 1e17

    set Smumin ([pdbGetDouble SiC Elec mumin])
    set Smumax ([pdbGetDouble SiC Elec mumax])
    set Slowalpha ([pdbGetDouble SiC Elec alpha])
    set Sbeta1 ([pdbGetDouble SiC Elec beta1])
    set Sbeta2 ([pdbGetDouble SiC Elec beta2])
    set Sbeta3 ([pdbGetDouble SiC Elec beta3])
    set Sbeta4 ([pdbGetDouble SiC Elec beta4])
    set SNref ([pdbGetDouble SiC Elec Nref])
 
    #build equation for low field mobility
    set Sseg1 "($Smumin)*(exp(log(Temp/300)*($Sbeta1)))"
    set Sseg2 "($Smumax-$Smumin)*(exp(log(Temp/300)*($Sbeta2)))"
    set Sseg3 "$SNref*(exp(log(Temp/300)*($Sbeta3)))"
    set Sseg4 "abs((Doping+1)/$Sseg3)"
    set Sseg5 "$Slowalpha*(exp(log(Temp/300)*($Sbeta4)))"
    set Sseg6 "exp(log($Sseg4)*($Sseg5))"
    set Sseg7 "1+$Sseg6"

    pdbSetDouble SiC Elec lowfldmob "($Sseg1+(($Sseg2)/($Sseg7)))"
  
    #set electron mobility copied from AlGaN
    #pdbSetDouble SiC Elec lowfldmob 213.1
    pdbSetDouble SiC Elec alpha 6.9502
    pdbSetDouble SiC Elec n1 7.8138
    pdbSetDouble SiC Elec n2 0.7897
    pdbSetDouble SiC Elec Ecmob 245579.4
    pdbSetDouble SiC vsat 2.02e7 
   
    set Slowfldmob ([pdbGetDouble SiC Elec lowfldmob]) 
    set Shighalpha ([pdbGetDouble SiC Elec alpha])
    set Sn1 ([pdbGetDouble SiC Elec n1])
    set Sn2 ([pdbGetDouble SiC Elec n2])
    set SEcmob ([pdbGetDouble SiC Elec Ecmob])
    set Svsat ([pdbGetDouble SiC vsat])
    set SEfield "(sqrt(dot(DevPsi,DevPsi)+1.0e2))"
    set SEfield_EcRatio "($SEfield)/($SEcmob)"

    set SEn1 "exp(log($SEfield_EcRatio)*($Sn1-1))"
    set SEn2 "exp(log($SEfield_EcRatio)*($Sn2))"

    set Snum "($Slowfldmob+($Svsat*($SEn1)/($SEcmob)))"
    set Sden "(1.0+($Shighalpha*($SEn2))+($SEn1*$SEfield_EcRatio))"

    pdbSetDouble SiC Elec mob $Slowfldmob


    #pdbSetDouble SiC Elec mob "($Snum)/($Sden)"
    #pdbSetDouble SiC Elec mob 230
    
    pdbSetDouble SiC Hole mob 0.20

mater add name=AlN
    
    #Set Youngs Modulus and Poissons Ratio(google)
	pdbSetString AlN YoungsModulus 3.31e12
	pdbSetString AlN PoissonRatio 0.22
    
    
    #define the parameters for AlN 
    pdbSetDouble AlN DevPsi RelEps 8.5

    #set AlN electron affinity
    pdbSetDouble AlN Affinity 1.2121

    #set AlN bandgap
    #pdbSetDouble AlN Eg 3.0
    pdbSetDouble AlN Eg "6.13+((1.80e-3*300*300)/(1.462e3+300))-((1.80e-3*Temp*Temp)/(1.462e3+Temp))"
    
    #Set Ev and Ec using AlN Ei as zero
    pdbSetDouble AlN Hole Ev "((-[pdbGetDouble AlN Affinity])-([pdbGetDouble AlN Eg])+(DevPsi))"
    pdbSetDouble AlN Elec Ec "((-[pdbGetDouble AlN Affinity])+(DevPsi))"

    #Set AlN Nc and Nv 
    pdbSetDouble AlN Hole Nv (4.6e19*sqrt(Temp*Temp*Temp/2.7e7))
    pdbSetDouble AlN Elec Nc (2.3e18*sqrt(Temp*Temp*Temp/2.7e7))

    #parameters for AlN low field mobility from Farahmand
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
    #pdbSetDouble AlN Elec lowfldmob 213.1
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
    
    pdbSetDouble AlN Hole mob 0.20
    
#############################################################################
#Solution variables and PDEs
##############################################################################

if {0} {

#mechanical domain
#solution name = displacement add solve dim continuous negative

pdbSetBoolean GaN displacement Negative 1 
pdbSetBoolean ReflectLeft displacement Negative 1 
pdbSetDouble GaN displacement Abs.Error 1.0e-8 
pdbSetDouble ReflectLeft displacement Abs.Error 1.0e-8 

pdbSetBoolean AlGaN displacement Negative 1 
pdbSetBoolean ReflectLeft displacement Negative 1 
pdbSetDouble AlGaN displacement Abs.Error 1.0e-8 
pdbSetDouble ReflectLeft displacement Abs.Error 1.0e-8

pdbSetBoolean Oxide displacement Negative 1 
pdbSetBoolean ReflectLeft displacement Negative 1 
pdbSetDouble Oxide displacement Abs.Error 1.0e-8 
pdbSetDouble ReflectLeft displacement Abs.Error 1.0e-8

pdbSetBoolean AlN displacement Negative 1 
pdbSetBoolean ReflectLeft displacement Negative 1 
pdbSetDouble AlN displacement Abs.Error 1.0e-8 
pdbSetDouble ReflectLeft displacement Abs.Error 1.0e-8

pdbSetBoolean SiC displacement Negative 1 
pdbSetBoolean ReflectLeft displacement Negative 1 
pdbSetDouble SiC displacement Abs.Error 1.0e-8 
pdbSetDouble ReflectLeft displacement Abs.Error 1.0e-8

pdbSetBoolean ReflectRight displacement Negative 1 
pdbSetDouble ReflectRight displacement Abs.Error 1.0e-8

#Fix base 
#pdbSetBoolean ReflectBottom displacement Fixed 1 
#pdbSetString ReflectBottom displacement Equation "displacement" 
 
#Fix sides 
#pdbSetBoolean ReflectLeft displacement Fixed 1 
#pdbSetString ReflectLeft displacement Equation "displacement" 

#pdbSetBoolean ReflectRight displacement Fixed 1 
#pdbSetString ReflectRight displacement Equation "displacement" 

#pdbSetString metal displacement Equation "elastic(displacement)" 
#pdbSetString GaN displacement Equation "elastic(displacement)+BodyStrain(0.02e-6*(Temp-300.0))+IPZ(DevPsi)" 
#pdbSetString AlGaN displacement Equation "elastic(displacement)+IPZ(DevPsi)" 
#pdbSetString AlGaN displacement Equation "elastic(displacement)+BodyStrain(0.004)" 
#pdbSetString Oxide displacement Equation "elastic(displacement)" 
#pdbSetString AlN displacement Equation "elastic(displacement)" 
#pdbSetString SiC displacement Equation "elastic(displacement)" 

}
###################################################################################
#solution add name=Temp solve continuous
solution add name=Temp const val=300.0

if {0} {
#thermal domain
solution add name=Temp solve pde !negative continuous damp
pdbSetDouble AlGaN Temp Abs.Error 0.1
pdbSetDouble AlGaN Temp Rel.Error 1.0e-2
pdbSetDouble AlGaN Temp DampValue 10.0
pdbSetDouble GaN Temp Abs.Error 0.1
pdbSetDouble GaN Temp Rel.Error 1.0e-2
pdbSetDouble GaN Temp DampValue 10.0
pdbSetDouble SiC Temp Abs.Error 0.1
pdbSetDouble SiC Temp Rel.Error 1.0e-2
pdbSetDouble SiC Temp DampValue 10.0
pdbSetDouble AlN Temp Abs.Error 0.1
pdbSetDouble AlN Temp Rel.Error 1.0e-2
pdbSetDouble AlN Temp DampValue 10.0

#Set thermal transport parameters

pdbSetDouble GaN Thermalk "2.6725+(-4.25e-3*Temp)+(3.0e-6*Temp*Temp)"
pdbSetDouble GaN Heatcap "1.395+(5.14e-3*Temp)+(-3.67e-6*Temp*Temp)"

pdbSetDouble AlGaN Thermalk 0.33
pdbSetDouble AlGaN Heatcap 2.0

pdbSetDouble SiC Thermalk 1.20
pdbSetDouble SiC Heatcap 2.40

pdbSetDouble AlN Thermalk 2.85
pdbSetDouble AlN Heatcap 2.584

set kn 1
set s 1
set Nc "[pdbGetDouble GaN Elec Nc]"



#Thermal Transport Equations

set eqn "((([pdbGetDouble GaN Heatcap]) * ddt(Temp))) - ((2.6725+(-4.25e-3*Temp)+(3.0e-6*Temp*Temp)) * grad(Temp)) - ($q * ([pdbGetDouble GaN Elec mob]) * (Elec) * dot(Qfn,Qfn))"
pdbSetString GaN Temp Equation $eqn

set eqn "((([pdbGetDouble AlGaN Heatcap]) * ddt(Temp))) - (([pdbGetDouble AlGaN Thermalk]) * (grad(Temp))) - ($q * [pdbGetDouble AlGaN Elec mob] * (Elec) * dot(Qfn,Qfn))"
pdbSetString AlGaN Temp Equation $eqn

set eqn "([pdbGetDouble SiC Heatcap] * ddt(Temp)) - (([pdbGetDouble SiC Thermalk]) * (grad(Temp))) - ($q * [pdbGetDouble SiC Elec mob] * (Elec) * dot(Qfn,Qfn))"
pdbSetString SiC Temp Equation $eqn

set eqn "([pdbGetDouble AlN Heatcap] * ddt(Temp)) - (([pdbGetDouble AlN Thermalk]) * (grad(Temp))) - ($q * [pdbGetDouble AlN Elec mob] * (Elec) * dot(Qfn,Qfn))"
pdbSetString AlN Temp Equation $eqn

#old eqns
#set eqn "((([pdbGetDouble GaN Heatcap]) * ddt(Temp))) - ([pdbGetDouble GaN Thermalk] * grad(Temp)) - ($q * ([pdbGetDouble GaN Elec mob]) * (Elec) * dot(Qfn,Qfn))"
#pdbSetString GaN Temp Equation $eqn

#set eqn "((([pdbGetDouble AlGaN Heatcap]) * ddt(Temp))) - (([pdbGetDouble AlGaN Thermalk]) * (grad(Temp))) - ($q * [pdbGetDouble AlGaN Elec mob] * (Elec) * dot(Qfn,Qfn))"
#pdbSetString AlGaN Temp Equation $eqn

#set eqn "([pdbGetDouble SiC Heatcap] * ddt(Temp)) - (([pdbGetDouble SiC Thermalk]) * (grad(Temp))) - ($q * [pdbGetDouble SiC Elec mob] * (Elec) * dot(Qfn,Qfn))"
#pdbSetString SiC Temp Equation $eqn

#set eqn "([pdbGetDouble AlN Heatcap] * ddt(Temp)) - (([pdbGetDouble AlN Thermalk]) * (grad(Temp))) - ($q * [pdbGetDouble AlN Elec mob] * (Elec) * dot(Qfn,Qfn))"
#pdbSetString AlN Temp Equation $eqn

}
####################################################################################################################

#electrical domain

solution add name=DevPsi solve negative damp continuous
solution add name=Qfp solve negative damp continuous
solution add name=Qfn solve negative damp continuous

pdbSetDouble OxPhase DevPsi RelEps 3.9
pdbSetDouble oxide DevPsi RelEps 3.9
pdbSetDouble metal DevPsi RelEps 5e6


proc Poissonold {Mat} {
    global k q eps0

    pdbSetDouble $Mat DevPsi DampValue 0.025
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-2
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-2

    set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) + Doping - Elec + Hole"
    pdbSetString $Mat DevPsi Equation $eqn
}

#Poisson AlGaN
#Poisson metal
#Poisson oxide
#Poisson SiC
#Poisson AlN
#Poisson GaN

proc Poisson2 {Mat} {
    global k q eps0

    pdbSetDouble $Mat DevPsi DampValue 0.025
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-2
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-2

    set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) )"
    pdbSetString $Mat DevPsi Equation $eqn
}

#Poisson2 metal 
#Poisson2 oxide 

proc PoissonTrap {Mat ConcA LevelA ConcD LevelD} {
    global k q eps0 Vt

    pdbSetDouble $Mat DevPsi DampValue 0.025
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-2
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-2

   
    set e "(($ConcA) / (1 + 2 * exp( (Eval + $LevelA - Qfp) / ($Vt) )))"
    solution add name=Trap_a solve $Mat const val = ($e)
    
    set e2 "(($ConcD) * (1 - (1 / (1 + 0.5 * exp( (Econd - $LevelD - Qfn) / ($Vt) )))))"
    solution add name=Trap_d solve $Mat const val = ($e2)

    set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) - Trap_a + Trap_d + Doping - Elec + Hole"
    pdbSetString $Mat DevPsi Equation $eqn
}
 
#PoissonTrap GaN 7.5e16 3.1 9.0e15 0.05 
#PoissonTrap AlGaN VGa 1.1 VN 0.05  
 
proc PoissonAcceptorTrap {Mat Conc Level} {
    global k q eps0 Vt

    pdbSetDouble $Mat DevPsi DampValue 0.025
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-2
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-2

    #set Trap "(($Conc) / 1 + 2 * exp( (Eval + $Level - Qfp) / ($Vt) ))"
    #set e "$Trap"
 
    set e "(($Conc) / (1 + 2 * exp( (Eval + $Level - Qfp) / ($Vt) )))"
    solution add name=Trap solve $Mat const val = ($e)
    
    set e2 "(($Conc) / (1 + 2 * exp( (Eval + $Level - Qfp) / ($Vt) )))"
    solution add name=Trap2 solve $Mat const val = ($e2)

    set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) - Trap + Doping - Elec + Hole"
    pdbSetString $Mat DevPsi Equation $eqn
}

#PoissonAcceptorTrap GaN 3.0e17 1.1
#PoissonAcceptorTrap AlGaN 3.0e17 1.1

#PoissonAcceptorTrap GaN 2.0e15 1.1
#PoissonAcceptorTrap AlN 5.0e16 1.1

proc PoissonDonorTrap {Mat Conc Level} {
    global k q eps0 Vt

    pdbSetDouble $Mat DevPsi DampValue 0.025
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-2
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-2

    
    set e "(($Conc) * (1 - (1 / (1 + 0.5 * exp( (Econd - $Level - Qfn) / ($Vt) )))))"
    solution add name=Trap solve $Mat const val = ($e)
    

    set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) + Trap + Doping - Elec + Hole"
    pdbSetString $Mat DevPsi Equation $eqn
}
#PoissonDonorTrap GaN VN 0.96
#PoissonDonorTrap AlGaN VN 0.96


proc ElecContinuity {Mat} {
    global Vt

    pdbSetDouble $Mat Qfn Rel.Error 1.0e-2
    pdbSetDouble $Mat Qfn Abs.Error 1.0e-2
    pdbSetDouble $Mat Qfn DampValue 0.025

    set eqn "ddt(Elec) - ([pdbDelayDouble $Mat Elec mob]) * (Elec+1.0) * grad(Qfn)"
   
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

proc ElecContinuity_trans {Mat Ntrap Etrap tau} {
    global Vt 

    pdbSetDouble $Mat Qfn Rel.Error 1.0e-2
    pdbSetDouble $Mat Qfn Abs.Error 1.0e-2
    pdbSetDouble $Mat Qfn DampValue 0.025

	set kr "(1/$tau)"
	
	set kf "($kr * 2 / [pdbDelayDouble $Mat Elec Nc] * exp( $Etrap / ($Vt)))"
	#set kr "($kf * [pdbDelayDouble $Mat Elec Nc] / 2 * exp(- $Etrap / ($Vt)))"
	
    set eqn "ddt(Elec) - ([pdbDelayDouble $Mat Elec mob]) * (Elec+1.0) * grad(Qfn) + ($kf * (Donor * Elec)) - ($kr * ($Ntrap - Donor)) "
    pdbSetString $Mat Qfn Equation $eqn
    
    set e "([pdbDelayDouble $Mat Elec Ec])"
    solution add name=Econd solve $Mat const val = ($e)

    set e "([pdbDelayDouble $Mat Elec Nc]) * exp( -(Econd-Qfn) / ($Vt) )"
    solution add name=Elec solve $Mat const val = "($e)"
    
}


proc DonorContinuity_trans {Mat Ntrap Etrap tau} {
    global Vt 

    pdbSetDouble $Mat Donor Rel.Error 1.0e-2
    pdbSetDouble $Mat Donor Abs.Error 1.0e-2
    pdbSetDouble $Mat Donor DampValue 0.025

	set kr "(1/$tau)"
	
	set kf "($kr * 2 / [pdbDelayDouble $Mat Elec Nc] * exp( $Etrap / $Vt))"
	#set kr "($kf * [pdbDelayDouble $Mat Elec Nc] / 2 * exp(- $Etrap / ($Vt)))"
	
    set eqn "ddt(Donor) + ( $kf * (Donor * Elec)) - ($kr * ($Ntrap - Donor))"
    pdbSetString $Mat Donor Equation $eqn
   
}


proc HoleContinuity {Mat} {
    global Vt

    pdbSetDouble $Mat Qfp Rel.Error 1.0e-2
    pdbSetDouble $Mat Qfp Abs.Error 1.0e-2
    pdbSetDouble $Mat Qfp DampValue 0.025

    set eqn "ddt(Hole) - ([pdbDelayDouble $Mat Hole mob]) * (Hole+1.0) * grad(Qfp)"
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

solution name=Hole Gas const val=0.0
solution name=Eval Gas const val=0.0

#Add interface charge

pdbSetString AlGaN_GaN DevPsi Equation  "1.06e13"    
#"1.17e13" changed to 1.06e13 from Lu's experimental results on 1um gate AFRL devices, 1.7e13 for Ray's 1um, 10V Vt 
#pdbSetString AlGaN_GaN DevPsi Equation "1.0e13"  ;#10% reduction as seen experimentally for 2e14 radiation dose



#set phiB 
#per Ambacher et al, used by Heller, 1.3x+0.84, with x=0.26
set phiB 0.7   ;#used 0.9 for Ray's 10 Vt 1um gate, used 1.03 for Ren trap sims
pdbSetString G DevPsi Equation "([pdbDelayDouble AlGaN Elec Ec])+G-$phiB"
pdbSetBoolean G DevPsi Fixed 1

############################################################################
#Electrical Boundary Conditions
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

    #this needs streamlining!
    set e "([pdbDelayDouble $Mat Elec Nc]) * exp(-([pdbDelayDouble $Mat Elec Ec] - Qfn) / ($Vt) )"
    set h "([pdbDelayDouble $Mat Hole Nv]) * exp(-(Qfp - [pdbDelayDouble $Mat Hole Ev]) / ($Vt) )"

    pdbSetString $Contact DevPsi Equation "Doping-$e+$h"
    pdbSetString $Contact Qfn Equation "Qfn+$Contact"
    pdbSetString $Contact Qfp Equation "Qfp+$Contact"
}


Ohmic AlGaN S
Ohmic AlGaN D
Ohmic SiC B

#fix for odd hole spike at gate contact
#pdbSetString G Qfp Equation "Qfp+G"
#pdbSetBoolean G Qfp Fixed 1
#pdbSetDouble G Qfp Flux.Scale 1.602e-19

if {1} { ;#turn off for e-field calc, turn on for Id calc
pdbSetDouble S Qfn Resistance -1000.0 ;#change from 2200 to 300 per Lu's measurements (was way off, 2000 was good) 2140 is 7% increase from 2000
pdbSetDouble D Qfn Resistance -1000.0
}

pdbSetBoolean B Temp Fixed 0
pdbSetString B Temp Equation "(2.7*(Temp-300.0))/0.00125"

#Electrical Initial Conditions
proc Initialize {} {
    global Vt
    sel z=300.00 name=Temp

    #four components - GaN ntype, GaN ptype, AlGaN ntype, AlGaN ptype

    #GaN First
    set nc "([pdbDelayDouble GaN Elec Nc])"
    set nv "([pdbDelayDouble GaN Hole Nv])"
    set aff "([pdbGetDouble GaN Affinity])"
    set Eg "([pdbGetDouble GaN Eg])"
    sel z= abs(Doping)+1.0 name=AbsDop

    sel z = "Mater(GaN) * ((Doping>0.0) ? (-$Vt * log( AbsDop / $nc) + $aff) : 0.0)"  name=GaN_N
    sel z = "Mater(GaN) * ((Doping<0.0) ? ($Vt * log(AbsDop / $nv) + $aff + $Eg) : 0.0)"  name=GaN_P

    #now AlGaN
    set nc "([pdbDelayDouble AlGaN Elec Nc])"
    set nv "([pdbDelayDouble AlGaN Hole Nv])"
    set aff "([pdbGetDouble AlGaN Affinity])"
    set Eg "([pdbGetDouble AlGaN Eg])"

    sel z = "Mater(AlGaN) * ((Doping>0.0) ? (-$Vt * log(AbsDop / $nc) + $aff) : 0.0)"  name=AlGaN_N
    sel z = "Mater(AlGaN) * ((Doping<0.0) ? ($Vt * log(AbsDop / $nv) + $aff + $Eg) : 0.0)"  name=AlGaN_P

 
    #now SiC
    set nc "([pdbDelayDouble SiC Elec Nc])"
    set nv "([pdbDelayDouble SiC Hole Nv])"
    set aff "([pdbGetDouble SiC Affinity])"
    set Eg "([pdbGetDouble SiC Eg])"

    sel z = "Mater(SiC) * ((Doping>0.0) ? (-$Vt * log(AbsDop / $nc) + $aff) : 0.0)"  name=SiC_N
    sel z = "Mater(SiC) * ((Doping<0.0) ? ($Vt * log(AbsDop / $nv) + $aff + $Eg) : 0.0)"  name=SiC_P

    #now AlN
    set nc "([pdbDelayDouble AlN Elec Nc])"
    set nv "([pdbDelayDouble AlN Hole Nv])"
    set aff "([pdbGetDouble AlN Affinity])"
    set Eg "([pdbGetDouble AlN Eg])"

    sel z = "Mater(AlN) * ((Doping>0.0) ?  (-$Vt * log(AbsDop / $nc) + $aff) : 0.0)"  name=AlN_N
    sel z = "Mater(AlN) * ((Doping<0.0) ?  ($Vt * log(AbsDop / $nv) + $aff + $Eg) : 0.0)"  name=AlN_P


    sel z=GaN_N+GaN_P+AlGaN_N+AlGaN_P+SiC_N+SiC_P+AlN_N+AlN_P name=DevPsi
}
