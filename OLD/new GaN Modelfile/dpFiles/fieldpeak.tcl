source run_measurements.tcl


source fieldplate.tcl
source GaN_modelfile_masterE.tcl
pdbSetDouble Nitride DevPsi RelEps 6.3
Initialize
device init
contact name=D supply=0.1
window row=1 col=1

run_measurements "null.csv" "null.csv" Fieldplate_All_Nit


source tgate.tcl
source GaN_modelfile_masterE.tcl
pdbSetDouble Nitride DevPsi RelEps 6.3
Initialize
device
contact name=D supply=0.1

run_measurements "null.csv" "null.csv" Tgate_All_Nit
