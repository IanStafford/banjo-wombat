proc nearHalfVolt {V {tol 0.001}} {
    set scaled [expr {$V / 0.5}]
    set frac [expr {abs($scaled - round($scaled))}]
    return [expr {$frac < ($tol / 0.5)}]
}

proc run_measurements_E {ivCSV peakCSV label} {
    # Source the provided Tcl file and the GaN model file
    Initialize
    device init

    if {1} {
    for {set d 0.0} {$d <1.05} {set d [expr $d+0.1]} {
        contact name=D supply=$d
        device 
    }

    set f [open $ivCSV w]
    close $f

    # Loop over gate voltage values from  10.0 down to -4.0 (approximately)
    # window row=1 col=2 make window declaration seperately to avoid new window for each run
    for {set g 0.0} {$g < 5.0} {set g [expr $g+0.05]} {
        contact name=G supply=$g
        if {[catch {device}]} {
            puts "Timeout at G=$g, trying again"
            #set g [expr $g-0.005]
            if {[catch {device}]} {
                puts "Timeout at G=$g, trying again"
            #set g [expr $g-0.005]
                device
            }
        }
        set f [open $ivCSV a]
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]; # converted to mA/mm
        set curG [expr {abs([contact name=G sol=Qfn flux])*1.0e6}]; # converted to mA/mm
        set curGH [expr {abs([contact name=G sol=Qfp flux])*1.0e6}]; # converted to mA/mm

        #FLOOXS GIVES A/um
        puts $f "$g, $cur"
        close $f
        chart graph=IV curve=$label xval=$g yval=$cur leg.left title= "Vd=1V"
        chart graph=IV_G curve=gate_cur xval=$g yval=$curG leg.left title= "Vd=1V"
        chart graph=IV_GH curve=gate_cur_hole xval=$g yval=$curGH leg.left title= "Vd=1V"
        #chart graph=IV_S curve=source_cur xval=$g yval=$curS leg.left title= "Vd=1V"
        set band 0
        if { [nearHalfVolt $g 0.001] || 1.0} {
            if {$band} {
                sel z=Econd name=gate_Ec
                plot1d graph=band yv=0.001 xmin=-0.1 xmax=0.1 title="GateEc" name="$g"

                sel z=Eval name=gate_Ev
                plot1d graph=band yv=0.001 xmin=-0.1 xmax=0.1 title="GateEv" name="$g"

                sel z=log10(abs(Elec)+1.0)
                plot1d graph=Elec yv=0.001 xmin=-0.1 xmax=0.1 title="E" name="$g" log

                sel z=log10(abs(Hole)+1.0)
                plot1d graph=Hole yv=0.001 xmin=-0.1 xmax=0.1 title="H" name="$g" log

                sel z=Qfp
                plot1d graph=Qfp yv=0.001 xmin=-0.1 xmax=0.1 title="Qfp" name="$g"                

                #sel z=DevPsi
                #plot1d graph=DevPsi yv=0.001 xmin=-0.1 xmax=0.1 title="DevPsi" name="$g"
            } else {

                sel z=log10(abs(Elec)+1.0)
                plot1d graph=Elec yv=0.001 xmin=-0.1 xmax=0.1 title="E" name="$g" log

                sel z=log10(abs(Hole)+1.0)
                plot1d graph=Hole yv=0.001 xmin=-0.1 xmax=0.1 title="H" name="$g" log

                sel z=Qfp
                plot1d graph=Qfp yv=0.001 xmin=-0.1 xmax=0.1 title="Qfp" name="$g"  

            }
        }

        #sel z=[expr {"DevPsi"}]
        #plot1d graph=DevPsi yv=0.01 xmin=-0.1 xmax=0.1 title="DevPsi" name="$g"

    }

    pdbSetDouble GaN Qfn DampValue 0.0512
    pdbSetDouble GaN Qfp DampValue 0.0512
    pdbSetDouble AlGaN Qfn DampValue 0.01
    pdbSetDouble AlGaN Qfp DampValue 0.01
    pdbSetDouble GaN2 Qfn DampValue 0.0512
    pdbSetDouble GaN2 Qfp DampValue 0.0512
    pdbSetDouble GaN2 Qfn Rel.Error 5.0e-2
    pdbSetDouble GaN2 Qfn Abs.Error 5.0e-2
    pdbSetDouble GaN2 Qfn Rel.Error 5.0e-2
    pdbSetDouble GaN2 Qfn Abs.Error 5.0e-2

    set eqn "ddt(Elec) + ([pdbDelayDouble AlGaN Elec mob]) * (Elec+1.0e10) * grad(Qfn)"
    #pdbSetString AlGaN Qfn Equation $eqn

    set eqn "ddt(Hole) - ([pdbDelayDouble AlGaN Hole mob]) * (Hole+1.0e10) * grad(Qfp)"
    #pdbSetString AlGaN Qfp Equation $eqn

    device init
    for {set g 1.4} {$g < 5.0} {set g [expr $g+0.01]} {
        contact name=G supply=$g
        if {[catch {device}]} {
            puts "Timeout at G=$g, trying again"
            #set g [expr $g-0.005]
            if {[catch {device}]} {
                puts "Timeout at G=$g, trying again"
            #set g [expr $g-0.005]
                device
            }
        }
        set f [open $ivCSV a]
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]; # converted to mA/mm
        set curG [expr {abs([contact name=G sol=Qfn flux])*1.0e6}]; # converted to mA/mm
        set curGH [expr {abs([contact name=G sol=Qfp flux])*1.0e6}]; # converted to mA/mm

        #FLOOXS GIVES A/um
        puts $f "$g, $cur"
        close $f
        chart graph=IV curve=$label xval=$g yval=$cur leg.left title= "Vd=1V"
        #chart graph=IV_G curve=gate_cur xval=$g yval=$curG leg.left title= "Vd=1V"
        chart graph=IV_GH curve=gate_cur_hole xval=$g yval=$curGH leg.left title= "Vd=1V"
        #chart graph=IV_S curve=source_cur xval=$g yval=$curS leg.left title= "Vd=1V"
        set band 1
        if { [nearHalfVolt $g 0.01]} {
            if {$band} {
                sel z=Econd name=gate_Ec
                plot1d graph=band yv=0.001 xmin=-0.1 xmax=0.1 title="GateEc" name="$g"

                sel z=Eval name=gate_Ev
                plot1d graph=band yv=0.001 xmin=-0.1 xmax=0.1 title="GateEv" name="$g"

                sel z=log10(abs(Elec)+1.0)
                plot1d graph=Elec yv=0.001 xmin=-0.1 xmax=0.1 title="E" name="$g" log

                sel z=log10(abs(Hole)+1.0)
                plot1d graph=Hole yv=0.001 xmin=-0.1 xmax=0.1 title="H" name="$g" log

                sel z=Qfp
                plot1d graph=Qfp yv=0.001 xmin=-0.1 xmax=0.1 title="Qfp" name="$g"                     

                #sel z=DevPsi
                #plot1d graph=DevPsi yv=0.001 xmin=-0.1 xmax=0.1 title="DevPsi" name="$g"
            } else {

                sel z=log10(abs(Acceptor)+1.0)
                plot1d graph=MgOcc yv=0.01 xmin=-0.1 xmax=0.1 title="MgOccupation" name="$g" log

                sel z=log10(abs(Elec)+1.0)
                plot1d graph=Elec yv=0.01 xmin=-0.1 xmax=0.1 title="E" name="$g" log

                sel z=log10(abs(Hole)+1.0)
                plot1d graph=Hole yv=0.01 xmin=-0.1 xmax=0.1 title="H" name="$g" log

            }
        }
    }

    }

    if {0} {
    for {set g 0.0} {$g <-4.0} {set d [expr $g-0.5]} {
        contact name=G supply=$g
        device
    }
    set f [open $peakCSV a]

    # Loop over Vds values from 0.0 to 50 (approximately)
    for {set vds 0.0} {$vds < 50.1} {set vds [expr $vds+0.5]} {
        contact name=D supply=$vds
        device
        sel z=abs(dot(DevPsi,y))*1.0e-4
        set pstr [peak GaN]
        puts [peak GaN]
        set peakfield [lindex $pstr 1]
        puts $f "$vds, $peakfield"
        chart graph=PeakField curve=$label xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field GaN"

        set pstr [peak AlGaN]
        puts [peak AlGaN]
        set peakfield [lindex $pstr 1]
        chart graph=PeakField_AlGaN curve=$label xval=$vds yval=$peakfield leg.left ylab= "Electric Field (V/cm)" title= "Peak Field AlGaN"
    }
    close $f
    }
}