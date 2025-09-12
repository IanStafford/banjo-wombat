source run_measurements.tcl
window row=1 col=1

if {0} {
set trapEn 0
set radTest 0
source fieldplate.tcl
source GaN_modelfile_masterD
run_measurements "figures/fieldplate_Vt.csv" "null" fieldplate
}

if {0} {
source fieldplate_ox.tcl
source GaN_modelfile_masterD
set trapEn 0

run_measurements "figures/fieldplate_ox_Vt.csv" "figures/fieldplate_ox_peakField.csv" fieldplate_ox
}

if {0} {
source fieldplate_wrap.tcl
source GaN_modelfile_masterD
set trapEn 0

run_measurements "figures/fieldplate_wrap_Vt.csv" "figures/fieldplate_wrap_peakField.csv" fieldplate_wrap
}

if {0} {
source fieldplate_wrap.tcl
source GaN_modelfile_masterD
set trapEn 0

run_measurements "figures/fieldplate_strike_Vt.csv" "null" fieldplate_strike
}


if {0} {
set radTest 0
set trapEn 0
source fieldplate.tcl
source GaN_modelfile_masterD
#run_measurements "figures/fieldplate_Vt.csv" "figures/fieldplate_peakField.csv" fieldplate

set radTest 1
source fieldplate.tcl
source GaN_modelfile_masterD
run_measurements "figures/fieldplate_sourceCloud_Vt.csv" "figures/fieldplate_rad_peakField.csv" fieldplate_rad
}

if {0} {
set radTest 0
set trapEn 0
source fieldplate_strike.tcl
source GaN_modelfile_masterD
Initialize
device
contact name=D supply=0.1

run_measurements "figures/fieldplate_strike_Vt.csv" "figures/fieldplate_strike_peakField.csv" fieldplate_wrap
}

if {1} {
    if {1} {
        set trapEn 0
        set radTest 0
        source fieldplate.tcl
        source GaN_modelfile_masterD
        run_measurements "null" "null" fieldplate
    }

    set trapEn 1
    set radTest 0
    set trapLevel 5.0
    source fieldplate.tcl
    source GaN_modelfile_masterD
    run_measurements "figures/fieldplate_trap_Vt.csv" "null" fieldplate_trap.1

    set trapEn 1
    set radTest 0
    set trapLevel 0.5
    source fieldplate.tcl
    source GaN_modelfile_masterD
    run_measurements "null" "null" fieldplate_trap.5

    set trapEn 1
    set radTest 0
    set trapLevel 1.0
    source fieldplate.tcl
    source GaN_modelfile_masterD
    run_measurements "null" "null" fieldplate_trap1

    set trapEn 1
    set radTest 0
    set trapLevel 2.0
    source fieldplate.tcl
    source GaN_modelfile_masterD
    run_measurements "null" "null" fieldplate_trap2

    set trapEn 1
    set radTest 0
    set trapLevel 5.0
    source fieldplate.tcl
    source GaN_modelfile_masterD
    run_measurements "null" "null" fieldplate_trap5
}

