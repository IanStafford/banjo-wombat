source measure_peak_and_levels.tcl
source fieldplate.tcl
source GaN_modelfile_masterD

pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
Initialize
device init
contact name=D supply=0.1
window row=1 col=1

measure_peak_and_levels flatplate 100

if {0} {
source flatplate.tcl
source GaN_modelfile_masterD

pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
Initialize
device init
contact name=D supply=0.1
window row=1 col=2

measure_peak_and_levels flatplate100
}