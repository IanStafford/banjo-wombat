# gate_plot.tcl
# Meant to plot the gate for the power device to see where the issues are

window row=2 col=2

source powerdevice.tcl
source GaN_modelfile_masterD

Initialize
device init

for {set d 0.0} {$d <1.05} {set d [expr $d+0.1]} {
    contact name=D supply=$d
    device 
}


sel z=[expr {"Qfn"}]
plot1d graph=QuasiN yv=0.01 title="Qfn" name="Qfn"

sel z=[expr {"Qfp"}]
plot1d graph=Qfp yv=0.01 title="Qfp" name="Qfp"

sel z=[expr {"DevPsi"}]
plot1d graph=DevPsi yv=0.01 xmax=0.5 title="DevPsi" name="DevPsi"

sel z=[expr {"Elec"}]
plot1d graph=Elec yv=0.01 xmax=0.5 title="Elec" name="Elec"