pdbSetDouble Nitride DevPsi RelEps 6.9
pdbSetDouble HighK DevPsi RelEps 35.0

# source run_measurements.tcl
source test1.tcl

source flatplate.tcl
source GaN_modelfile_masterD

test1 30 flatplate

if {0} {

window row=1 col=2

run_measurements "flatplate.csv" flatplate

source flatplate_1000.tcl
source GaN_modelfile_masterD

run_measurements "flatplate1000.csv" flatplate1000

window row=1 col=1
}