source run_measurements.tcl
window row=1 col=1

# Set HighK to 0 for SiN and 1 for HighK simulations. The run_measurmenets proc is currently configured to give the transfer curve of the device in linear scale.
set HighK 0

if {!$HighK} {
    set trapEn 0
    pdbSetDouble HighK DevPsi RelEps 6.3
    source rfdevice.tcl
    source GaN_modelfile_masterD
    run_measurements "figures/SiN_rf_IV.csv" "figures/50V_GaN_SiN.csv" HighK
}


if {$HighK} {
    set trapEn 0
    pdbSetDouble HighK DevPsi RelEps 35
    source rfdevice.tcl
    source GaN_modelfile_masterD
    run_measurements "figures/HighK_rf_IV.csv" "figures/50V_GaN_HighK.csv" HighK
}
