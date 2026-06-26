set xlist {0.1 0.2 0.3}

foreach x0 $xlist {
    exec xterm -hold -e flooxs run.tcl $x0 &
}