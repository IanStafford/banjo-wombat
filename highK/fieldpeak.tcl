window row=1 col=3
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
    pdbSetDouble HighK DevPsi RelEps 35
    source rfdevice.tcl
    #source fieldplate_highk.tcl
    source GaN_modelfile_masterD
    run_measurements "figures/testing.csv" "figures/50V_plot_HighK.csv" HighK
}