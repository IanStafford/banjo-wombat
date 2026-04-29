# RF HEMT Data Package
FLOOXS-compatible simulation data package for the RF HEMT developed by NCSU.

Includes material parameter libraries, equation procedure files, simulation scripts, and output figures
gan-hemt-data-package/

These scripts require FLOOXS to be installed to be run.
See http://www.flooxs.ece.ufl.edu/index.php/Manual#Installation for installation instructions
___

## Transfer curve
The script file transfer.tcl plots the linear-scale transfer curve of the RF HEMT. 
Opening the script file and changing the value of HighK will allow you to simulate the device with SiN or HfO2

To run the script: 
1. Open a terminal in this directory and type ```flooxs``` to launch flooxs
2. Type ```source transfer.tcl```
3. Your figures should be saved in the figures directory for analysis

## Electric field
The script file fieldPeakAndChannel.tcl plots the peak electric field in the GaN of the device, as well as the field in the channel at 0, 25, and 50V.
It does this for both the SiN and HfO2 devices. Opening the script and changing the value of vdsMAX will change the end point of the sweep.

To run the script: 
1. Open a terminal in this directory and type ```flooxs``` to launch flooxs
2. Type ```source fieldPeakAndChannel.tcl```
3. Your figures should be saved in the figures directory for analysis

## IV curve with traps
The script file trapPlot.tcl plots the drain current as drain voltage is swept at a given gate voltage.
It also plots the trap occupation through the near-channel region.
This plot contains traps defined in GaN_modelfile_masterD.

To run the script: 
1. Open a terminal in this directory and type ```flooxs``` to launch flooxs
2. Type ```source trapPlot.tcl```
3. Your figures should be saved in the figures directory for analysis

___
## Other files
Material and simulation structure files are also found in the package.