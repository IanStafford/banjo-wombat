source run_measurements_E.tcl
window row=2 col=3

if {0} {
    set trapEn 0
    set ::pGaN 1.0
    source powerdevice.tcl
    source GaN_modelfile_masterD
    run_measurements_E "figures/powerIV.csv" "null" fieldplate
}

if {0} {
    set trapEn 0
    set ::pGaN 1.0
    source powerdevice.tcl
    source GaN_modelfile_masterD
    run_measurements_E "figures/SiNpowerIV.csv" "null" fieldplate
}

if {1} {
    set trapEn 0
    set ::eMode 1.0
    source GaN_modelfile_masterD
    source powerdevice.tcl
    run_measurements_E "figures/null.csv" "null" fieldplate
}