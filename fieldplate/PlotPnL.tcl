source measure_peak_and_levels.tcl
source fieldplate_150nm.tcl
source GaN_modelfile_masterD

pdbSetDouble Nitride DevPsi RelEps 6.3
pdbSetDouble HighK DevPsi RelEps 35.0
Initialize
device init
contact name=D supply=0.1
window row=1 col=2

measure_peak_and_levels 150nm