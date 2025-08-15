proc Poisson {Mat} {
    global VtRoom k q eps0

    pdbSetDouble $Mat DevPsi DampValue $VtRoom
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-1
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-1

    set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) + Doping - Elec + Hole"
    pdbSetString $Mat DevPsi Equation $eqn
}

proc PoissonTrap {Mat TrapName} {
    global VtRoom k q eps0

    pdbSetDouble $Mat DevPsi DampValue $VtRoom
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-2
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-2

    solution name=DevPsi damp negative add solve

    set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) + Doping - Elec + Hole + TrapName"
    pdbSetString $Mat DevPsi Equation $eqn
}

proc InsPoisson {Mat} {
    global VtRoom k q eps0

    pdbSetDouble $Mat DevPsi DampValue $VtRoom
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-2
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-2
    set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) + Doping" 
    pdbSetString $Mat DevPsi Equation $eqn
}

proc PoissonAcceptorTrap {Mat Conc Level} {
    global k q eps0 Vt

    pdbSetDouble $Mat DevPsi DampValue 0.025
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-2
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-2

    set e "(($Conc) / 1 + 2 * exp( (Eval + $Level - Qfp) / ($Vt) ))"
    solution add name=Trap solve $Mat const val = ($e)

    set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) + Doping - Trap - Elec + Hole"
    pdbSetString $Mat DevPsi Equation $eqn
}
proc AcceptorTrap {Mat Ntrap Etrap Efwhm} {
    global k q

    set Acceptor [solution name=Acceptor $Mat print]
    set Vt ($k*HTemp/$q)

    #do a switch so we can figure out testing...
    if {$Efwhm == 0.0} {
	set e1 0.0
	set e2 "(($Ntrap) / (1 + 4.0 * exp( (Eval + $Etrap - Qfp) / ($Vt) )))"
	set e3 0.0
    } else {
	#set the evaluation point for the Gaussian-Hermite Quadrature
	set Off [expr sqrt(12.0)*$Efwhm/2.0]
	set e1 "(($Ntrap/6.0) * ((1 / (1 + 4.0 * exp( (Eval + $Etrap + $Off - Qfp) / ($Vt) )))))"
	set e2 "((2.0*$Ntrap/3.0) * ((1 / (1 + 4.0 * exp( (Eval + $Etrap - Qfp) / ($Vt) )))))"
	set e3 "(($Ntrap/6.0) * ((1 / (1 + 4.0 * exp( (Eval + $Etrap - $Off - Qfp) / ($Vt) )))))"
    }
    set Acceptor "$Acceptor + $e1 + $e2 + $e3"
    solution name=Acceptor $Mat solve const val = "$Acceptor"
}
