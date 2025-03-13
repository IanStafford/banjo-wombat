source plotPeak.tcl
window row=1 col=1

source fieldplate_150nm.tcl
plotPeak "peak_150nm.csv" 100 150nm
plotPeak "fieldplate_100nm.tcl" "peak_100nm.csv" 100 100nm
plotPeak "fieldplate_50nm.tcl" "peak_50nm.csv" 100 50nm
plotPeak "fieldplate_10nm.tcl" "peak_10nm.csv" 100 10nm