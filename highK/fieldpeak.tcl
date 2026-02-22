window row=1 col=1
source run_measurements.tcl

if {0} {
    set trapEn 0
    source fieldplate_highk.tcl
    source GaN_modelfile_masterD
    run_measurements "figures/highkIV.csv" "figures/highkField_GaN.csv" HighK
}

if {0} {
    set trapEn 0
    source fieldplate.tcl
    source GaN_modelfile_masterD
    run_measurements "figures/nitrideIV.csv" "figures/nitrideField_GaN.csv" Nitride
}

if {1} {
    set trapEn 0
    source fieldplate_highk.tcl
    source GaN_modelfile_masterD
    run_measurements "figures/testing.csv" "figures/testing.csv" HighK
}