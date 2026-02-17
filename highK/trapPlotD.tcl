proc nearHalfVolt {V {tol 0.001}} {
    set scaled [expr {$V / 0.5}]
    set frac [expr {abs($scaled - round($scaled))}]
    return [expr {$frac < ($tol / 0.5)}]
}

proc trapPlot {ivCSV bias} {
    Initialize
    device init


    for {set g 0.0} {$g > -2.05} {set g [expr $g-0.1]} {
        #contact name=G supply=$g
        #device
    }

    set f [open $ivCSV w]
    close $f


    set f2 [open "figures/acceptor_GaN_AlGaN_6_AcceptorTrapOccupation_Vgm2.csv" w]

    if {$bias <= 0.0} {
        puts "trapPlot: bias <= 0, nothing to sweep."
        close $f2
        return
    }
    # puts $errorCode

    proc solvePoint {ivCSV f2 d} {
        upvar cur cur
        contact name=D supply=$d
        puts "before device"
        device; #This guy is the culprit. Don't know how to catch errors from here.
        puts "Everything from the Qfn equation"
        sel z=ddt(Elec)
        puts [peak AlGaN]
        #puts [peak (Elec+1.0e10)]
        sel z=Qfn
        puts [peak AlGaN]

        ;# Drain current (A/um -> uA/um)
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]

        set f [open $ivCSV a]
        puts $f "$d, $cur"
        close $f

        chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left

        sel z=log10(abs(NeutralAcceptor)+1.0)
        plot1d graph=NeutralAcceptor xv=0.018 xmax=0.5 xmin=0.0 \
               ylab="NeutralAcceptorOccupation" title="NeutralAcceptor" name="Vds=$d" log


        #sel z=log10(abs(Elec)+1.0)
        #sel z=ddt(Elec)
        #plot2d levels=40 xmax=0.5

        if {[nearHalfVolt $d 0.001]} {
            puts $f2 [print1d xv=0.018]
        }
    }

    set inc    0.01; # starting step
    set err    0.10; # 10% 

    # Limits on step size
    set incMin 1.0e-5
    set incMax 1.10

    set max   [expr {$bias + 1.0e-6}]
    set loop  0

    # First point
    set d 0.0
    set error 1
    while {$error} {
        set error 0
        if {[catch {solvePoint $ivCSV $f2 $d}]} {
            set error 1
            puts "ERROR at D=$d (initial point) - reducing step"
            #puts $errorCode
            set inc [expr {$inc/2.0}]
            if {$inc < $incMin} { set inc $incMin }
        }
    }
    set x1 $d
    set y1 $cur

    # Second point
    set d [expr {0.0 + $inc}]
    if {$d > $max} { set d $max }

    set error 1
    while {$error} {
        set error 0
        if {[catch {solvePoint $ivCSV $f2 $d}]} {
            set error 1
            puts "ERROR at D=$d (second point) - reducing step"
            puts $errorCode
            set inc [expr {$inc/2.0}]
            if {$inc < $incMin} { set inc $incMin }
            set d [expr {0.0 + $inc}]
            if {$d > $max} { set d $max }
        }
    }
    set x2 $d
    set y2 $cur

    # Main dynamic loop this is where I may have made some errors
    while {!$loop} {

        # Linear prediction
        set slope [expr {($y2 - $y1)/($x2 - $x1)}]
        set b     [expr {$y2 - ($slope * $x2)}]

        set d [expr {$x2 + $inc}]
        if {$d > $max} { set d $max }

        set p1 [expr {$slope*$d + $b}]

        set error 1
        while {$error} {
            set error 0
            if {[catch {solvePoint $ivCSV $f2 $d}]} {
                set error 1
                puts "ERROR at D=$d - reducing step"
                #puts $errorCode
                set inc [expr {$inc/2.0}]
                if {$inc < $incMin} { set inc $incMin }
                set d [expr {$x2 + $inc}]
                if {$d > $max} { set d $max }
            }
        }
        set y $cur

        set diff     [expr {$p1 - $y}]
        set abserror [expr {abs($diff)}]
        set maxerr   [expr {$err * (abs($y) + 1.0e-30)}]

        if {$abserror < $maxerr} {
            ;# Accept this step
            puts "Accepted D=$d (|err|=$abserror, max=$maxerr)"


            set diffsq [expr {$inc*$inc}]
            set secder 0.0
            # Where I tried to improve the original code by mmaking sure secder isn't 0 unless things really go bad
            if {$diffsq > 0.0} {
                set secder [expr {(2.0*$diff)/$diffsq}]
            }
            if {$secder < 0.0} {
                set secder [expr {-1.0*$secder}]
            }
            if {$secder > 0.0} {
                set inc [expr {sqrt((2.0*$maxerr)/$secder)}]
            }

            # Clamp step to [incMin, incMax]
            if {$inc < $incMin} { set inc $incMin }
            if {$inc > $incMax} { set inc $incMax }


            set x1 $x2
            set y1 $y2
            set x2 $d
            set y2 $y

        } else {
            puts "Rejected D=$d (|err|=$abserror > $maxerr) – reducing step"
            set inc [expr {$inc/2.0}]
            if {$inc < $incMin} { set inc $incMin }
            continue
        }

        if {$d >= $bias} {
            set loop 1
            puts "Reached target bias D=$bias"
        }
    }

    close $f2


    if {0} {
        device time=10.0e-6 t.ini=1.0e-20 userstep=1.0e-12 movie= {

            set d [expr 2.1 + (0.1 * $Time) / 1.0e-6]
            contact name=D supply=$d

            set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}] 
            chart graph=IV curve=DrainCur xval=$d yval=$cur leg.left
            if { [nearHalfVolt $d 0.001] && ($d > 2.0) } {
                sel z=log10(abs(Acceptor)+1.0)
                plot1d graph=Vertical xv=0.01 \
                       ylab="AcceptorTrapOccupation" \
                       title="TrapOccupationLevel" name="Vds=$d" log
            }
        }
    }
}

window row=1 col=2
set trapEn 1

source GaN_modelfile_masterD
source fieldplate_highk.tcl
trapPlot "figures/testing.csv" 10
