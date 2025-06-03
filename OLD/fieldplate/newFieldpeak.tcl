source run_measurements.tcl


source oops_all_nitride.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 6.3
Initialize
device init
contact name=D supply=0.1
window row=1 col=2

run_measurements "null.csv" "null.csv" Fieldplate_All_Nit

if {0} {

source fp_HighK.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
Initialize
device
contact name=D supply=0.1

run_measurements "IV_50nm.csv" "peak_50nm.csv" 50nm_Nit
}