source run_measurements.tcl


source bigate_corrected.tcl
source GaN_modelfile_masterD
Initialize
device init
contact name=D supply=0.1
window row=1 col=1

run_measurements "peak_5nm.csv" 5nm


source bg_c_10nm.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "peak_10nm.csv" 10nm


source bg_c_20nm.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "peak_20nm.csv" 20nm

source bg_c_30nm.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "peak_30nm.csv" 30nm

source bg_c_40nm.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "peak_40nm.csv" 40nm

source bg_c_50nm.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "peak_50nm.csv" 50nm

source bg_c_60nm.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements  "peak_60nm.csv" 60nm

source bg_c_70nm.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "peak_70nm.csv" 70nm

source bg_c_80nm.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "peak_80nm.csv" 80nm

source bg_c_90nm.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements  "peak_90nm.csv" 90nm