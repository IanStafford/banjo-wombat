if {0} {
source run_measurements.tcl


source flatplate.tcl
source GaN_modelfile_masterD

Initialize
device init
contact name=D supply=0.1

window row=1 col=2

run_measurements "flatplate.csv" flatplate


source fieldplate_50nm.tcl
source GaN_modelfile_masterD

Initialize
device init
contact name=D supply=0.1

run_measurements "peak_50nm2.csv" 50nm
}
source measure_peak_and_levels.tcl
source flatplate.tcl
source GaN_modelfile_masterD

Initialize
device init
contact name=D supply=0.1

window row=1 col=2

measure_peak_and_levels flatplate