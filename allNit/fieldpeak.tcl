source run_measurements.tcl


source tgate_mod.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
Initialize
device init
contact name=D supply=0.1
window row=1 col=1

# run_measurements "tgate_Vt.csv" "null.csv" tgate


source fieldplate_mod.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
Initialize
device
contact name=D supply=0.1

run_measurements "fieldplate_Vt.csv" "null.csv" fieldplate
