# ========================================================
# Transfer curve simulation
# ========================================================

# Load the field plate structure and libraries
source fieldplate.tcl
source GaN_modelfile_masterD

# Open a plot window
window row=1 col=1

# Call initialization procedure to solve the initial conditions
Initialize
device init

# Sweep Drain voltage from 0V to 10V in steps of 0.25V
for {set d 0.0} {$d <10.05} {set d [expr $d+0.25]} {
# update global Vds so the structure's Gaussian amplitude follows the applied drain voltage
set ::Vds $d
contact name=D supply=$d
device 
}
set f [open "figures/transfer.csv" w]

# Loop over gate voltage values from  0.0 down to -4.0 (approximately)
for {set g 0.0} {$g > -3.05} {set g [expr $g-0.1]} {
    contact name=G supply=$g
    device
    # Calculate current in mA/mm (flooxs calculated A/um)
    set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e6}] 
    # Save data to file
    puts $f "$g, $cur"
    # Plot the transfer curve
    chart graph=IV curve=Fieldplate xval=$g yval=$cur leg.left
}
close $f