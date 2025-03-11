proc ElecContinuity {Mat} {
    global Vt VtRoom

    pdbSetDouble $Mat Qfn Rel.Error 1.0e-2
    pdbSetDouble $Mat Qfn Abs.Error 1.0e-2
    pdbSetDouble $Mat Qfn DampValue $VtRoom

    set eqn "ddt(Elec) + ([pdbDelayDouble $Mat Elec mob]) * (Elec+1.0e10) * grad(Qfn)"
    pdbSetString $Mat Qfn Equation $eqn

    set e "([pdbDelayDouble $Mat Elec Ec])"
    solution add name=Econd solve $Mat const val = ($e)

    set e "([pdbDelayDouble $Mat Elec Nc]) * f12( -(Econd-Qfn) / ($Vt) )"
    solution add name=Elec solve $Mat const val = "($e)"
}

proc HoleContinuity {Mat} {
    global Vt VtRoom

    pdbSetDouble $Mat Qfp Rel.Error 1.0e-2
    pdbSetDouble $Mat Qfp Abs.Error 1.0e-2
    pdbSetDouble $Mat Qfp DampValue $VtRoom

    set eqn "ddt(Hole) - ([pdbDelayDouble $Mat Hole mob]) * (Hole+1.0e10) * grad(Qfp)"
    pdbSetString $Mat Qfp Equation $eqn

    set e "([pdbDelayDouble $Mat Hole Ev])"
    solution add name=Eval solve $Mat const val = ($e)

    set e "([pdbDelayDouble $Mat Hole Nv]) * f12( -(Qfp - Eval) / ($Vt) )"
    solution name=Hole solve $Mat const val = "($e)"
}

