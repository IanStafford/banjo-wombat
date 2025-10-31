# ===========================================
# FLOOXS INPUT FILE
# BOILERPLATE
# ===========================================

# ===========================================
# transferCurve
# INPUTS:
# struct: tcl file containing the script for the device being tested
#	 i.e. fieldplate.tcl
# vd: Voltage applied to the drain which you would like to sweep the gate at
#	 i.e. 10.0
# vgMax: maximum voltage applied to gate, normally 0V for the MACOM device (vgMax > 0)
#	 i.e. 0.0
# vgMin: minimum voltage applied to gate (end of sweep), normally -3V or -4V for the MACOM device
#	 i.e. -4.0
# dataFile: location and name of the file the plot is stored in
#	 i.e. "figures/transfer.csv"
#
# OUTPUTS:
# - Transfer curve plot into plot window
# - Data in the form of a .csv file specified by the dataFile variable
# ===========================================
set trapEn 0
proc transferCurve {lib struct vd vgMax vgMin dataFile} {
    source $lib
	source $struct
    
	Initialize
	device init

	for {set d 0.0} {$d < [expr $vd + 0.05]} {set d [expr $d+0.5]} {
		# expose the current drain voltage to the global scope so structure expressions can use it
		set ::Vds $d
		contact name=D supply=$d
		device
	}

	for {set g 0.0} {$g < [expr $vgMax + 0.05]} {set g [expr $d+0.5]} {
		# keep the drain voltage visible globally in case the struct uses it
		set ::Vds $d
		contact name=D supply=$d
		device
	}	

	set f [open $dataFile w]

	# Gate voltage sweep
	for {set g 0.0} {$g > [expr $vgMin - 0.05]} {set g [expr $g-0.1]} {
        contact name=G supply=$g
        device
        #FLOOXS GIVES A/um as defined in struct file
        set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}] 
        puts $f "$g, $cur"
        chart graph=transfer curve=$label xval=$g yval=$cur leg.left
    }
    close $f

}

# ===========================================
# IVCurves  {struct vd vgMax vgMin}
# INPUTS:
# lib: tcl file containing the material database and library
# struct: tcl file containing the script for the device being tested
#	 i.e. fieldplate.tcl
# vd: maximum voltage applied to the drain during sweep
#	 i.e. 10.0
# vgMax: maximum voltage applied to gate, normally 0V for the MACOM device (vgMax >= 0)
#	 i.e. 0.0
# vgMin: minimum voltage applied to gate, normally -3V or -4V for the MACOM device
#	 i.e. -4.0
# step: spacer designating the size of the step
# dataFile: location and name of the file the plot is stored in
#	 i.e. "figures/transfer.csv"
#
# OUTPUTS:
# - Transfer curve plot into plot window
# - Data in the form of a .csv file specified by the dataFile variable
# ===========================================
proc IVCurves {lib struct vd vgMax vgMin step dataFile} {
	source $struct
    source $lib

	Initialize
	device init
	for {set g 0.0} {$g > [expr $vgMin - 0.05]} {set g [expr $g-0.5]} {
		contact name=G supply=$g
		device
	}

	set f [open $dataFile w]

	set n $vgMin
	while {n < $vgMax} {

		for {set d 0.0} {$d < [expr $vd + 0.05]} {set d [expr $d+0.5]} {
				# update global Vds so structure expressions follow the drain sweep
				set ::Vds $d
			contact name=D supply=$d
			device
			set cur [expr {abs([contact name=D sol=Qfn flux])*1.0e3}] 
        	puts $f "$d, $cur"
        	chart graph=IV curve=$n xval=$g yval=$cur leg.left
		}

		for {set g $n} {$g < [expr $n + $step + 0.05]} {set g [expr $g + 0.25]} {
			contact name=G supply=$g
			device
		}

		set n [expr $n + $step]
	}
	close $f
}

# Creating a transfer curve
window row=1 col=1
set lib "GaN_modelfile_masterD"
set struct "fieldplate.tcl"
set vd 10.0
set vgMax 0.0
set vgMin -4.0
set dataFile "figures/transfer.csv"
set trapEn 0; # Disable trapping for transfer curve
transferCurve $lib $struct $vd $vgMax $vgMin $dataFile





















