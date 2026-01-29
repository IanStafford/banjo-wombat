proc Poisson {Mat} {
    global VtRoom k q eps0
    pdbSetDouble $Mat DevPsi DampValue $VtRoom
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-1
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-1

    set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) + Doping - Donor - Elec + Hole"
    #set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) + Doping - Elec + Hole"
    # To let the mobility model work with new acceptor term.
    if {[catch {solution name=Acceptor solve $Mat const val = 0.0} err]} {
        puts "ERROR in Poisson: Failed to set Acceptor constraint for material $Mat"
        puts "  Error: $err"
        error "Poisson Acceptor constraint failed: $err"
    }
    if {[catch {solution name=Donor solve $Mat const val = 1.0} err]} {
        puts "ERROR in Poisson: Failed to set Donor constraint for material $Mat"
        puts "  Error: $err"
        error "Poisson Donor constraint failed: $err"
    }

    if {[catch {pdbSetString $Mat DevPsi Equation $eqn} err]} {
        puts "ERROR in Poisson: Failed to set DevPsi equation for material $Mat"
        puts "  Equation: $eqn"
        puts "  Error: $err"
        error "Poisson DevPsi equation failed: $err"
    }
}

proc InsPoisson {Mat} {
    global VtRoom k q eps0

    pdbSetDouble $Mat DevPsi DampValue $VtRoom
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-2
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-2
    set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) + Doping"
    if {[catch {pdbSetString $Mat DevPsi Equation $eqn} err]} {
        puts "ERROR in InsPoisson: Failed to set DevPsi equation for material $Mat"
        puts "  Equation: $eqn"
        puts "  Error: $err"
        error "InsPoisson DevPsi equation failed: $err"
    }
}

proc AcceptorTrapOld {Mat Ntrap Etrap Efwhm} {
    global k q

    set Acceptor [solution name=Acceptor $Mat print]
    set Vt ($k*Temp/$q)

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
    if {[catch {solution name=Acceptor $Mat solve const val = "$Acceptor"} err]} {
        puts "ERROR in AcceptorTrapOld: Failed to set Acceptor constraint for material $Mat"
        puts "  Ntrap: $Ntrap, Etrap: $Etrap, Efwhm: $Efwhm"
        puts "  Acceptor equation: $Acceptor"
        puts "  Error: $err"
        error "AcceptorTrapOld constraint failed: $err"
    }
}

proc AcceptorTrap {Mat Ntrap Etrap Efwhm} {
    global k q eps0 sigma mean_x mean_y

    #set Acceptor [solution name=Acceptor $Mat print]
    set Vt ($k*Temp/$q)
    pdbSetDouble $Mat DevPsi DampValue $Vt
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-1
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-1
    #do a switch so we can figure out testing...
    #solution name=TrapConc solve $Mat const val = ($Ntrap)

    if {$Efwhm == 0.0} {
        set e1 0.0
        set e2 "(($Ntrap) / (1 + 4.0 * exp( (Eval + $Etrap - Qfn) / ($Vt) )))"
        set e3 0.0
    } else {
        #set the evaluation point for the Gaussian-Hermite Quadrature
        set sigma [expr $Efwhm/2.355]
        set Off   [expr sqrt(3.0)*$sigma]
        set e1 "((1.0/6.0) * ((1 / (1 + 4.0 * exp( (Eval + $Etrap + $Off - Qfp) / ($Vt) )))))"
        set e2 "((2.0/3.0) * ((1 / (1 + 4.0 * exp( (Eval + $Etrap - Qfp) / ($Vt) )))))"
        set e3 "((1.0/6.0) * ((1 / (1 + 4.0 * exp( (Eval + $Etrap - $Off - Qfp) / ($Vt) )))))"
        #set e1 "((1.0/6.0) * ((1 / (1 + 4.0 * exp( (Qfp - (Eval + $Etrap + $Off)) / ($Vt) )))))"
        #set e2 "((2.0/3.0) * ((1 / (1 + 4.0 * exp( (Qfp - (Eval + $Etrap)) / ($Vt) )))))"
        #set e3 "((1.0/6.0) * ((1 / (1 + 4.0 * exp( (Qfp - (Eval + $Etrap - $Off)) / ($Vt) )))))"
    }
    set Acceptor "$Ntrap * ($e1 + $e2 + $e3) + 1.0"
    if {[catch {solution name=Acceptor solve $Mat const val = ($Acceptor)} err]} {
        puts "ERROR in AcceptorTrap: Failed to set Acceptor constraint for material $Mat"
        puts "  Ntrap: $Ntrap, Etrap: $Etrap, Efwhm: $Efwhm"
        puts "  Acceptor equation: $Acceptor"
        puts "  e1: $e1"
        puts "  e2: $e2"
        puts "  e3: $e3"
        puts "  Error: $err"
        error "AcceptorTrap constraint failed: $err"
    }

    #set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) + Doping - Acceptor - Elec + Hole"
    #pdbSetString $Mat DevPsi Equation $eqn
}

proc DonorTrap {Mat Ntrap Etrap Efwhm} {
    global k q eps0 sigma mean_x mean_y

    #set Acceptor [solution name=Acceptor $Mat print]
    set Vt ($k*Temp/$q)
    pdbSetDouble $Mat DevPsi DampValue $Vt
    pdbSetDouble $Mat DevPsi Abs.Error 1.0e-1
    pdbSetDouble $Mat DevPsi Rel.Error 1.0e-1

    #do a switch so we can figure out testing...
    #solution name=TrapConc solve $Mat const val = ($Ntrap)

    if {$Efwhm == 0.0} {
        set e1 0.0
        set e2 "(($Ntrap) / (1 + 4.0 * exp( (Econd - $Etrap - Qfn) / ($Vt) )))"
        set e3 0.0
    } else {
        #set the evaluation point for the Gaussian-Hermite Quadrature
        set sigma [expr $Efwhm/2.355]
        set Off   [expr sqrt(3.0)*$sigma]
        if {1} {
            set e1 "((1.0/6.0) * ((1 / (1 + 4.0 * exp( (Econd - $Etrap + $Off - Qfn) / ($Vt) )))))"
            set e2 "((2.0/3.0) * ((1 / (1 + 4.0 * exp( (Econd - $Etrap - Qfn) / ($Vt) )))))"
            set e3 "((1.0/6.0) * ((1 / (1 + 4.0 * exp( (Econd - $Etrap - $Off - Qfn) / ($Vt) )))))"
        } else {
            set e1 "((1.0/6.0) * ((1 / (1 + 4.0 * exp( ($Etrap + $Off - Qfn) / ($Vt) )))))"
            set e2 "((2.0/3.0) * ((1 / (1 + 4.0 * exp( ($Etrap - Qfn) / ($Vt) )))))"
            set e3 "((1.0/6.0) * ((1 / (1 + 4.0 * exp( ($Etrap - $Off - Qfn) / ($Vt) )))))"
        }
    }
    set Donor "$Ntrap - $Ntrap * ($e1 + $e2 + $e3)"
    if {[catch {solution name=Donor solve $Mat const val = ($Donor)} err]} {
        puts "ERROR in DonorTrap: Failed to set Donor constraint for material $Mat"
        puts "  Ntrap: $Ntrap, Etrap: $Etrap, Efwhm: $Efwhm"
        puts "  Donor equation: $Donor"
        puts "  e1: $e1"
        puts "  e2: $e2"
        puts "  e3: $e3"
        puts "  Error: $err"
        error "DonorTrap constraint failed: $err"
    }
    
    #set eqn "- ($eps0 * [pdbDelayDouble $Mat DevPsi RelEps] * grad(DevPsi) / $q) + Doping + Donor - Elec + Hole"
    #pdbSetString $Mat DevPsi Equation $eqn
}