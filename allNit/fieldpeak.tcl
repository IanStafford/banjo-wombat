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
source fieldplate_mod.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "fieldplate_Vt.csv" "fieldplate_peakField.csv" fieldplate
}

if {1} {
source fieldplate_ox.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "fieldplate_ox_Vt.csv" "fieldplate_ox_peakField.csv" fieldplate_ox
}