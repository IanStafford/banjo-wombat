source run_measurements.tcl
window row=1 col=1

if {1} {
set trapEn 0
source fieldplate.tcl
source GaN_modelfile_masterD
run_measurements "figures/fieldplate_Vt.csv" "null" fieldplate
}

if {0} {
set trapEn 1
set trapLevel 5.0
source fieldplate.tcl
source GaN_modelfile_masterD
run_measurements "figures/fieldplate.csv" "null" fieldplate
}