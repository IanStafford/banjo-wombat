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
