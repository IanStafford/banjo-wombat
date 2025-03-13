source run_measurements.tcl


source fieldplate_50nm.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
Initialize
device init
contact name=D supply=0.1
window row=1 col=2

run_measurements "IV_50nm2.csv" "peak_50nm2.csv" 50nm

source fieldplate_50nm_100nm.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
Initialize
device
contact name=D supply=0.1

run_measurements "IV_50nm_100nm.csv" "peak_50nm_100nmnm.csv" 100nm_Shift

if {0} {
source fieldplate_50nm.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
Initialize
device
contact name=D supply=0.1

run_measurements "IV_50nm.csv" "peak_50nm.csv" 50nm


source fieldplate_10nm.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
Initialize
device
contact name=D supply=0.1

run_measurements "IV_10nm.csv" "peak_10nm.csv" 10nm
}