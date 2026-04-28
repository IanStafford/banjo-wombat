mater add name=pGaN
    set k 1.38066e-23
    set q 1.60218e-19
    set Vt ($k*Temp/$q)

	#Set Youngs Modulus and Poissons Ratio(for WZ crystal 0001 plane) plus temperature dependance ***check this number
	pdbSetString pGaN YoungsModulus (3.9e12-0.16e10*(Temp-300.0))
	pdbSetString pGaN PoissonRatio 0.352

    #set some pGaN parameters
    pdbSetDouble pGaN DevPsi RelEps 8.9
    
    #set pGaN electron affinity
    
    pdbSetDouble pGaN Affinity 3.1
	    
    #set Bandgap according to Eric Heller info
    pdbSetDouble pGaN Eg (3.51-(7.7e-4*Temp*Temp)/(600+Temp))

    #set Ev and Ec for pGaN 
    pdbSetDouble pGaN Hole Ev "((-[pdbGetDouble pGaN Affinity])-([pdbGetDouble pGaN Eg])+(DevPsi))"
    pdbSetDouble pGaN Elec Ec "((-[pdbGetDouble pGaN Affinity])+(DevPsi))"

    pdbSetDouble pGaN Hole Nv (4.6e19*sqrt(Temp*Temp*Temp/2.7e7))
    pdbSetDouble pGaN Elec Nc (2.3e18*sqrt(Temp*Temp*Temp/2.7e7))

    set Eg 3.51-(7.7e-4*9e4)/(1500)
    set Nv 4.6e19*sqrt(27e6/2.7e7)
    set Nc 2.3e18*sqrt(27e6/2.7e7)

    pdbSetDouble pGaN ni "(sqrt($Nv*$Nc)*exp(-$Eg/(2*$Vt))))"

    #set low field electron mobility via analytical expression from Farahmand for low field mobility


    #paramters for pGaN for low field mobility from Farahmand
    pdbSetDouble pGaN Elec mumin 295.0
    pdbSetDouble pGaN Elec mumax 1907    ;#1460.7 before
    pdbSetDouble pGaN Elec alpha 0.66
    pdbSetDouble pGaN Elec beta1 -1.02
    pdbSetDouble pGaN Elec beta2 -3.84
    pdbSetDouble pGaN Elec beta3 3.02
    pdbSetDouble pGaN Elec beta4 0.81
    pdbSetDouble pGaN Elec Nref 1e17 


    set Gmumin ([pdbGetDouble pGaN Elec mumin])
    set Gmumax ([pdbGetDouble pGaN Elec mumax])
    set Glowalpha ([pdbGetDouble pGaN Elec alpha])
    set Gbeta1 ([pdbGetDouble pGaN Elec beta1])
    set Gbeta2 ([pdbGetDouble pGaN Elec beta2])
    set Gbeta3 ([pdbGetDouble pGaN Elec beta3])
    set Gbeta4 ([pdbGetDouble pGaN Elec beta4])
    set GNref ([pdbGetDouble pGaN Elec Nref])
 
    #build equation for low field mobility
    set Gseg1 "$Gmumin*(1*exp(log(Temp/300)*($Gbeta1)))"
    set Gseg2 "($Gmumax-$Gmumin)*(1*exp(log(Temp/300)*($Gbeta2)))"
    set Gseg3 "$GNref*(1*exp(log(Temp/300)*($Gbeta3)))"
    set Gseg4 "abs((Doping+Acceptor+1)/$Gseg3)";     #modified to include ionized donor or acceptor traps
    set Gseg5 "$Glowalpha*(1*exp(log(Temp/300)*($Gbeta4)))"
    set Gseg6 "1*exp(log($Gseg4)*($Gseg5))"
    set Gseg7 "1+$Gseg6"
    set Gseg8 "($Gseg2)/($Gseg7)"

    #pdbSetDouble pGaN Elec lowfldmob "($Gseg1+(($Gseg2)/($Gseg7)))"
    #pdbSetDouble pGaN Elec lowfldmob $Gseg1+((($Gmumax-$Gmumin)*(exp(log(Temp/300)*($Gbeta2))))/($Gseg7))
    pdbSetDouble pGaN Elec lowfldmob "($Gseg1)+($Gseg8)"



    #parameters for pGaN low field mobility using Eric Heller's equations
    set top "1630"
    set bot1 "(Temp/300)"
    set bot2 "exp(log($bot1)*(1.88))"
    set ericmob "($top)/($bot2)"

    #pdbSetDouble pGaN Elec lowfldmob $ericmob
   
    #pdbSetDouble pGaN Elec mob $ericmob
   
    #parameters and expression for high field mobility using Eric Heller's equations
    set Gvsat "3.3e7-(3.0e6*(Temp/300))"
    set Gbeta "0.85*(exp(log(Temp/300)*(0.4)))"
    set GEfield "abs(dot(DevPsi,y*1e-4))+1"

    #set GEfield "(sqrt(dot(DevPsi,DevPsi)+1.0))"

    #set GEfield "(sqrt(dot(Qfn,Qfn)+1.0))"

    set G1 "((([pdbGetDouble pGaN Elec lowfldmob])*($GEfield))/($Gvsat))"
    set G2 "(exp(log($G1)*($Gbeta)))"
    set G3 "(1+($G2))"
    set G4 "(1/$Gbeta)"
    set G5 "(exp(log($G3)*($G4)))"

    set Ghigh "(([pdbGetDouble pGaN Elec lowfldmob])/($G5))"

    set lowfldmob [pdbGetDouble pGaN Elec lowfldmob]

    pdbSetDouble pGaN Elec mob $lowfldmob ;
      
    pdbSetDouble pGaN Elec mob $Ghigh   ; # turn this one back on to get Farhamand mobility
   
    #set parameters for pGaN High Field mobility from Farahmand 
    pdbSetDouble pGaN Elec alpha 6.1973
    pdbSetDouble pGaN Elec n1 7.2044
    pdbSetDouble pGaN Elec n2 0.7857
    pdbSetDouble pGaN Elec Ecmob 220893.6
    pdbSetDouble pGaN vsat 1.9064e7 
    pdbSetDouble pGaN vsat (2.7e7/(1+0.8*exp(Temp/600)))

    #set electron mobility via analytical expression from Farahmand for high field mobility

    set Glowfldmob ([pdbGetDouble pGaN Elec lowfldmob]) 
    set Ghighalpha ([pdbGetDouble pGaN Elec alpha])
    set Gn1 ([pdbGetDouble pGaN Elec n1])
    set Gn2 ([pdbGetDouble pGaN Elec n2])
    set GEcmob ([pdbGetDouble pGaN Elec Ecmob])
    set Gvsat ([pdbGetDouble pGaN vsat])
    set GEfield1 "abs(dot(DevPsi,y*1.e-4))+1"    

    set GEfield_EcRatio1 "(($GEfield1)/($GEcmob))"
    set GEn1_1 "(exp(log($GEfield1)*($Gn1-1)))"
    set GEn1_3 "(exp(log($GEcmob)*($Gn1)))"
    set GEn1_2 "(exp(log($GEfield_EcRatio1)*($Gn1)))"
    set GEn2_1 "(exp(log($GEfield_EcRatio1)*($Gn2)))"
    set num1 "($Glowfldmob+($Gvsat*(($GEn1_1)/($GEn1_3))))"
    set denom1 "(1.0+($Ghighalpha*($GEn2_1))+($GEn1_2))"

    #set testmob1 "($num1)/($denom1)"

# set pGaN mobility as a constatn based on Lu's results for 1um AFRL devices 1907 cm2/V-s
    #pdbSetDouble pGaN Elec mob 1907      ;# 1907,  decrease 41% with 2e14 radiation is 1125  
    #dbSetDouble pGaN Elec mob 600

    #set hole mobility as constant
    #pdbSetDouble pGaN Hole mob 100

    # Caughy-Thomas for doping dependent hole mobility
    set p_mumax 170.0
    set p_mumin 10.0
    set p_Nref 2e17
    set p_alpha 0.7
    set pHolemob "($p_mumin + ($p_mumax - $p_mumin)/(1 + abs(Doping)/$p_Nref)^$p_alpha)"
    pdbSetDouble pGaN Hole mob $pHolemob

