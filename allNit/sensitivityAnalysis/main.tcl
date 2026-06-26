# Sensitivity analysis main script
# This will use the trapPlot procedure to sweep through a range of trap parameters and generate plots of the IV 
# curve and trap occupation.

# Helper script calls
source make_list.tcl
source nearHalfVolt.tcl
source trapPlot.tcl

# "Home" parameters for the trap distribution
# Centered right at the AlGaN Metal interface with a standard deviation of 0.015 um (~90nm total width)
# and a total trap density of 3e18 cm^-3
set sigma 0.015
set mean_x 0.0
set mean_y 0.14
set trapConc "3e18*exp(-((x-($mean_x))*(x-($mean_x))+(y-($mean_y))*(y-($mean_y)))/(2.0*$sigma*$sigma))"

# Trap parameters for the sensitivity analysis
set trapEn 1
set trapLevel 3.1
set trapWidth 0.025

# CSV files
set ivCSV "figures/acceptor_GaN_AlGaN_6.csv"
set trapCSV "figures/acceptor_GaN_AlGaN_6_trap.csv"

# Test block (5 runs, 50nm apart)
set ylist [make_list -0.1 0.1 5]
set critBias 0.5
set finalBias 1.0
set gateBias -2.0

foreach mean_y $ylist {
    #exec xterm -hold -e flooxs trapPlot.tcl $ivCSV $trapCSV $critBias $finalBias $gateBias $sigma $mean_x $y0 $trapLevel $trapWidth &
    #set cmd "flooxs trapPlot.tcl $ivCSV $trapCSV $critBias $finalBias $gateBias $sigma $mean_x $mean_y $trapLevel $trapWidth"
    #exec xterm -hold -e sh -c $cmd &
    set bundle [join [list $ivCSV $trapCSV $critBias $finalBias $gateBias $sigma $mean_x $mean_y $trapLevel $trapWidth $trapConc $trapEn] "|"]
    exec xterm -hold -e sh -c "flooxs trapPlot.tcl '$bundle'" &
}



