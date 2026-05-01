**Abstract**
High Electron Mobility Transistors (HEMTs) are widely used in aerospace systems for their high efficiency and inherent radiation tolerance, yet heavy ion strikes can still induce significant damage and performance degradation. This work investigates the origin of current collapse observed in AlGaN/GaN HEMTs exposed to 8.4 MeV Bi ions over a range of fluences. The hypothesis is that heavy-ion damage creates a localized region of neutral electron traps near the gate–drain edge, coinciding with the device’s highest electric-field stress. These traps capture electrons and form a persistent negative charge distribution that depletes the 2DEG channel, suppressing drain current. DC-biased irradiation measurements confirm this behavior, showing increasing collapse with increasing fluence and field strength. A TCAD model calibrated to non-irradiated devices reproduces this mechanism and provides a quantitative explanation for the observed current collapse phenomenon.

# Organization

## Opening: HEMTs in Space, Radiation Environment
Talk about why HEMTs are in space (RF telecommunications in rad hard environment. Wide bandgap means SEUs are less likley, etc.)

State objective: Investigative work into unusual current collapse observed when HEMTs were irradiated with heavy ions
## Brief Background
Cover HEMT structure quickly? Might assume knowledge of it.
Distinguish between the RF current collapse (gate lag effects) and DC collapse we see here.
Explain with its own slide ideally.
##  Experimental Setup
Go over device structure (field plate , gate length, stack, etc.)
8.4MeV Bi: talk about fluence ranges, and the various DC biases were applied during the irradiation
Talk about measurement? Repeatability? not my forte as I didn't do it. Dr. Anderson will have something for that I'm sure

## Hypothesis
Heavy ions create a localized band of neutral electron traps concentrated at the gate–drain edge (highest E-field region). Electrons captured by these traps form a persistent negative space charge that depletes the 2DEG from above, effectively pinching the channel at a threshold V_DS. Emphasize why it's spatially localized (damage profile from TRIM/SRIM, field-enhanced trapping) and why it's persistent (deep traps, slow detrapping).

## TCAD Model
Describe the FLOOXS model calibrated to the non-irradiated device, then show how inserting a trap distribution at the gate–drain edge reproduces the observed DC collapse. 
Probably best to avoid mentioning how difficult simulation was?
Aim on keeping simulation details minimal, focusing more on the results

## Results
Compare simulated and measured I–V curves.
Sensitivity analysis if i get to it in time

## Summary, Implications
Recap: heavy ion damage -> localized traps -> persistent 2DEG depletion -> DC current collapse at critical V_DS. Note what this means for device hardening (epi design, field management at gate–drain edge). Mention any future work (additional fluences, temperature dependence, transient recovery studies).

# Slide Layout
1. Title
2. HEMTs in Space
3. HEMT Operation
	1. Might not be needed idk
4. Delineation from conventional current collapse
5. Experimental Setup
6. Experimental Results
7. Hypothesis
8. TCAD Model and Calibration to Pre-rad
9. Simulation Results
10. Summary / Conclusion
11. References
12. Questions
