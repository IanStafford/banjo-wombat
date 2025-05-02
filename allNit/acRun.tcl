source ac_measurements.tcl


source tgate_mod.tcl
source GaN_modelfile_masterD
pdbSetDouble Nitride DevPsi RelEps 6.3
Initialize
device init
window row=1 col=1

ac_measurements