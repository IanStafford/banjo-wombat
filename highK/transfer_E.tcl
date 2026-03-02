# plot=1 → write CSV + update chart; plot=0 → solve only
proc solvePoint {CSV contactName contactVal plot} {
    upvar cur cur
    contact name=$contactName supply=$contactVal 
    device
    device
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}]
    if {$plot} {
        set f [open $CSV a]
        puts $f "$contactVal, $cur"
        close $f
        chart graph=IV curve=DrainCur xval=$contactVal yval=$cur leg.left
    }
}

proc sweepContact {contactName targetBias CSV plot} {
    upvar cur cur

    if {$plot} {
        set f [open $CSV w]; # overwrite existing file
        close $f
    }

    set incMin 1.0e-5
    set incMax 1.10
    set inc    0.05
    set err    1.0e-3
    set max    [expr {$targetBias + 1.0e-6}]
    set loop   0

    # --- First point at 0 ---
    set v 0.0
    set error 1
    while {$error} {
        set error 0
        if {[catch {solvePoint $CSV $contactName $v $plot}]} {
            set error 1
            puts "ERROR at $contactName=$v (initial) – halving step"
            set inc [expr {$inc / 2.0}]
            if {$inc < $incMin} { set inc $incMin }
        }
    }
    set x1 $v
    set y1 $cur

    # --- Second point at 0 + inc ---
    set v [expr {0.0 + $inc}]
    if {$v > $max} { set v $max }
    set error 1
    while {$error} {
        set error 0
        if {[catch {solvePoint $CSV $contactName $v $plot}]} {
            set error 1
            puts "ERROR at $contactName=$v (second) – halving step"
            set inc [expr {$inc / 2.0}]
            if {$inc < $incMin} { set inc $incMin }
            set v [expr {0.0 + $inc}]
            if {$v > $max} { set v $max }
        }
    }
    set x2 $v
    set y2 $cur

    # --- Main adaptive loop ---
    while {!$loop} {
        set slope [expr {($y2 - $y1) / ($x2 - $x1)}]
        set b     [expr {$y2 - ($slope * $x2)}]
        set v     [expr {$x2 + $inc}]
        if {$v > $max} { set v $max }
        set p1 [expr {$slope * $v + $b}]

        set error 1
        while {$error} {
            set error 0
            if {[catch {solvePoint $CSV $contactName $v $plot}]} {
                set error 1
                puts "ERROR at $contactName=$v – halving step"
                set inc [expr {$inc / 2.0}]
                if {$inc < $incMin} { set inc $incMin }
                set v [expr {$x2 + $inc}]
                if {$v > $max} { set v $max }
            }
        }

        set y      $cur
        set diff   [expr {$p1 - $y}]
        set abserr [expr {abs($diff)}]
        set maxerr [expr {$err * (abs($y) + 1.0e-30)*1.0e5}]

        if {$abserr < $maxerr} {
            puts "Accepted $contactName=$v (|err|=$abserr, max=$maxerr)"

            set diffsq [expr {$inc * $inc}]
            set secder 0.0
            if {$diffsq > 0.0} {
                set secder [expr {abs((2.0 * $diff) / $diffsq)}]
            }
            if {$secder > 0.0} {
                set inc [expr {sqrt((2.0 * $maxerr) / $secder)}]
            }
            if {$inc < $incMin} { set inc $incMin }
            if {$inc > $incMax} { set inc $incMax }

        } else {
            puts "Step too large at $contactName=$v (|err|=$abserr > $maxerr) – shrinking next step"
            set inc [expr {$inc / 2.0}]
            if {$inc < $incMin} { set inc $incMin }
            # No 'continue' — fall through and accept this point as-is
        }

        # Advance the window regardless of whether the step was accepted cleanly
        set x1 $x2
        set y1 $y2
        set x2 $v
        set y2 $y

        if {$v >= $targetBias} {
            set loop 1
            puts "Reached target $contactName=$targetBias"
        }
    }
}

source GaN_modelfile_masterD
source powerdevice.tcl

Initialize 
device init

puts "\n=== Sweeping Drain 0 - 10 V ==="
set ::plot 0
sweepContact D 10.0 "" $plot

window row=1 col=1
puts "\n=== Sweeping Gate 0 - 5 V ==="
set ::plot 1
sweepContact G 5 "figures/testing.csv" $plot