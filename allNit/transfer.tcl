source run_measurements.tcl
window row=1 col=1

if {0} {
source tgate_mod.tcl
source GaN_modelfile_masterD
Initialize
device init
contact name=D supply=0.1

run_measurements "tgate_Vt.csv" "tgate_peakField.csv" tgate
}

if {0} {
set radTest 0
source fieldplate.tcl
source GaN_modelfile_masterD
run_measurements "fieldplate_Vt.csv" "fieldplate_peakField.csv" fieldplate
}

if {0} {
source fieldplate_ox.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "fieldplate_ox_Vt.csv" "fieldplate_ox_peakField.csv" fieldplate_ox
}

if {0} {
source fieldplate_wrap.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "fieldplate_wrap_Vt.csv" "fieldplate_wrap_peakField.csv" fieldplate_wrap
}


if {1} {
set radTest 0
source fieldplate.tcl
source GaN_modelfile_masterD
run_measurements "fieldplate_Vt.csv" "fieldplate_peakField.csv" fieldplate

set radTest 1
source fieldplate.tcl
source GaN_modelfile_masterD
run_measurements "fieldplate_rad_Vt.csv" "fieldplate_rad_peakField.csv" fieldplate_rad
}

if {0} {
source fieldplate_strike.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "fieldplate_strike_Vt.csv" "fieldplate_strike_peakField.csv" fieldplate_wrap
}