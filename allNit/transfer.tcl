source run_measurements.tcl
window row=1 col=1

if {1} {
set trapEn 0
source fieldplate.tcl
source GaN_modelfile_masterD
run_measurements "figures/4e19cloud3.csv" "null" fieldplate
}

if {0} {
set trapEn 1
set trapLevel 3.0
source fieldplate.tcl
source GaN_modelfile_masterD
run_measurements "figures/null.csv" "null" fieldplate
}