proc ElecContinuity {Mat} {
    global Vt

    pdbSetDouble $Mat Qfn Rel.Error 1.0e-2
    pdbSetDouble $Mat Qfn Abs.Error 1.0e-2
    pdbSetDouble $Mat Qfn DampValue 0.026

    set eqn "ddt(Elec) + ([pdbDelayDouble $Mat Elec mob]) * (Elec+1.0e10) * grad(Qfn)"
    pdbSetString $Mat Qfn Equation $eqn

    set e "([pdbDelayDouble $Mat Elec Ec])"
    if {[catch {solution add name=Econd solve $Mat const val = ($e)} err]} {
        puts "ERROR in ElecContinuity: Failed to set Econd constraint for material $Mat"
        puts "  Equation: $e"
        puts "  Error: $err"
        error "ElecContinuity Econd constraint failed: $err"
    }

    set e "([pdbDelayDouble $Mat Elec Nc]) * f12( -(Econd-Qfn) / ($Vt) )"
    if {[catch {solution add name=Elec solve $Mat const val = "($e)"} err]} {
        puts "ERROR in ElecContinuity: Failed to set Elec constraint for material $Mat"
        puts "  Equation: $e"
        puts "  Vt: $Vt"
        puts "  Error: $err"
        error "ElecContinuity Elec constraint failed: $err"
    }
}

proc HoleContinuity {Mat} {
    global Vt

    pdbSetDouble $Mat Qfp Rel.Error 1.0e-2
    pdbSetDouble $Mat Qfp Abs.Error 1.0e-2
    pdbSetDouble $Mat Qfp DampValue 0.026

    set eqn "ddt(Hole) - ([pdbDelayDouble $Mat Hole mob]) * (Hole+1.0e10) * grad(Qfp)"
    pdbSetString $Mat Qfp Equation $eqn

    set e "([pdbDelayDouble $Mat Hole Ev])"
    if {[catch {solution add name=Eval solve $Mat const val = ($e)} err]} {
        puts "ERROR in HoleContinuity: Failed to set Eval constraint for material $Mat"
        puts "  Equation: $e"
        puts "  Error: $err"
        error "HoleContinuity Eval constraint failed: $err"
    }

    set e "([pdbDelayDouble $Mat Hole Nv]) * f12( -(Qfp - Eval) / ($Vt) )"
    if {[catch {solution name=Hole solve $Mat const val = "($e)"} err]} {
        puts "ERROR in HoleContinuity: Failed to set Hole constraint for material $Mat"
        puts "  Equation: $e"
        puts "  Vt: $Vt"
        puts "  Error: $err"
        error "HoleContinuity Hole constraint failed: $err"
    }
}

