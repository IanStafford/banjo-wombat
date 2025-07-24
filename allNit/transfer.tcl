source run_measurements.tcl
window row=1 col=1

if {0} {
set donkey 0
set radTest 0
source fieldplate.tcl
source GaN_modelfile_masterD
run_measurements "figures/fieldplate_Vt.csv" "null" fieldplate
}

if {0} {
source fieldplate_ox.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "figures/fieldplate_ox_Vt.csv" "figures/fieldplate_ox_peakField.csv" fieldplate_ox
}

if {0} {
source fieldplate_wrap.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "figures/fieldplate_wrap_Vt.csv" "figures/fieldplate_wrap_peakField.csv" fieldplate_wrap
}


if {0} {
set radTest 0
source fieldplate.tcl
source GaN_modelfile_masterD
run_measurements "figures/fieldplate_Vt.csv" "figures/fieldplate_peakField.csv" fieldplate

set radTest 1
source fieldplate.tcl
source GaN_modelfile_masterD
run_measurements "figures/fieldplate_rad_Vt.csv" "figures/fieldplate_rad_peakField.csv" fieldplate_rad
}

if {0} {
source fieldplate_strike.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "figures/fieldplate_strike_Vt.csv" "figures/fieldplate_strike_peakField.csv" fieldplate_wrap
}

if {1} {
    set donkey 1
    set radTest 0
    source fieldplate.tcl
    source GaN_modelfile_masterD
    run_measurements "figures/fieldplate_trap_Vt.csv" "null" fieldplate_trap
    }

