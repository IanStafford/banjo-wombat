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
1. **Title**
2. **HEMTs in Space**
HEMTs are characterized by their power density and efficiency. They have a high breakdown field and operating voltage as a result of their wide bandgaps (3.4eV in this case). Power densities are an order of magnitude higher than SiC-based devices, and the compact nature of these devices makes them attractive for space power and telecommunication systems (Fleetwood, 2022).

It is a happy coincidence, then, that HEMTs (and GaN HEMTs especially) have an inherent radiation tolerance. It is difficult to define what makes something "rad-hard" but for an overview, HEMTs have no gate oxide to accumulate charge that shifts the threshold voltage, and the materials themselves (especially GaN) have higher displacement threshold energies making them more resistant to lattice damage (Pearton, 2021).

Radiation tolerance should not be conflated with immunity, however, as solar particle events can deliver ions with LET up to 100 MeV. These heavy ions create displacement cascades that accumulate into electrical hiccups and defects. Cumulative damage to the lattice can still degrade drain current, threshold voltage, and leakage through gate and drain (Fleetwood, 2022).

**FIGURE IDEAS**
- A comparison table showing differences in mobility, bandgap, displacement energy, power density, between GaN, GaAs, and SiC, maybe even Si? Would look AI generated, though.
	- Could also do a comparison bar graph.
- Size comparison between SiC, GaAs, and GaN devices

4. **HEMT Operation**
Quick crash course on the HEMT device structure. In the standard AlGaN/GaN heterostructure we have the combination of spontaneous and piezoelectric polarization at the interface between the two materials. This creates a sheet of electrons we refer to as 2 dimensional electron gas. The key thing I want to take away from this slide is the field distribution at off-state. The lateral field peaks at the gate-drain edge. This is going to matter a lot more when we get to where the radiation damage has its greatest effect.

**FIGURE IDEAS**
- Cross section of HEMT

5. **Delineation from conventional current collapse** 
Before talking about the experimental and simulated setups, I need to be specific about what we mean by current collapse in this work. It is not the same as what is conventionally talked about in GaN literature. It usually refers to a dynamic effect where you bias the device at off-state and pulse to on-state, and the drain current you measure is lower than what you'd expect from the DC I-V curve. That is classic gate-lag / drain-lag. Surface states or buffer traps capture charge under stress and form a virtual gate, when you pulse on the traps haven't had time to recombine, so the channel is partially depleted. The key difference is that this is transient. If you give it enough time the traps will recombine, the virtual gate disappears, and the drain current will recover.

This is not what we observed in our work, however. We see a DC characteristic. On an non-irradiated device, you sweep the drain at various gate biases, the device will increase in drain current until saturation normally. After irradiation, the current begins to rise as expected, but then at some critical drain voltage, it rolls over and collapses entirely. The channel completely pinches off while the gate is biased on. 

And two trends confirm that this is tied to the radiation damage and the electric field. First, the critical voltage where collapse begins shifts lower with increasing fluence. More damage seemingly equates to an earlier pinch-off. Second, devices irradiated under higher DC bias, meaning higher field in the gate–drain region during exposure, show more severe collapse. Both of those are consistent with a mechanism where the radiation creates traps in the region of highest field stress, and those traps capture enough charge to deplete the channel once the drain voltage pushes the local field high enough.

**Figure Ideas**
- Example standard, current collapse IV curves to show the differences. Probably best to keep RF current collapse out of the visual regime to avoid confusion. I do like the idea of a regular current collapse next to ours, though it doesn't show the nuances with pulsed vs dc measurement...

6. **Experimental Setup**
7. **Experimental Results**
8. **Hypothesis**
So the research question of this work is: What physical mechanism explains a DC pinch-off that worsens with fluence and with the electric field present during irradiation?

Yu and co-workers showed through 2D simulation that when negative charge accumulates near the surface in the gate–drain region, it depletes the 2DEG through the virtual gate effect. In their work, this was donor-like surface traps interacting with the intrinsic polarization charge. But the underlying physics is general: any source of persistent negative charge above the channel in the access region will deplete the 2DEG.

Now, Islam and co-workers at Sandia gave us direct evidence of what heavy ions do to the crystal. They irradiated GaN HEMTs with gold ions and performed in-situ TEM, and what they found was a significant population of vacancies, interstitials, and dislocations throughout the device layers. Their EDS mapping specifically identified nitrogen and oxygen vacancies as the dominant electrically active defects. And, perhaps most importantly, they hypothesized that these defects act as charge traps whose accumulation lowers the breakdown voltage. Furthermore, they saw degradation worsen as these defects interacted with the electric field during device operation.

Our hypothesis relates these two ideas to explain the phenomena we observe. The Bi ions create displacement damage in the form of nitrogen and gallium vacancies (for the most part). This generates traps near the GaN buffer and near the heterointerface (heterostructure?). These traps are distributed along the ion tracks but the ones that dominate the electrical behavior of the device are located near the gate-drain edge, where SRIM profiles predict the damage profile overlaps with the peak lateral electric field. Under drain bias, that field drives electrons into the traps, where they form a persistent negative space charge that depletes the 2DEG. Because these are deep level traps, they don't release under DC conditions, so at a certain level, the depleted region expands and at a critical drain voltage the channel pinches off entirely.

9. **TCAD Model and Calibration to Pre-rad**
To simulate this, we first needed to calibrate to some pre-irradiation devices. We replicated the structure in FLOOXS, a custom TCAD tool developed by UF's own Dr. Mark Law. Our simulation used a mobility model that includes ionized impurity scattering based on Faramand et al. where they used Monte Carlo simulation to extract a dependence of mobility on impurity scattering. To achieve performance similar to the device in hand, we used Ambacher's formula for 2DEG density as a function of Schottky barrier height, which itself is derived from the Al mole fraction. For finishing touches, we adjusted variables like the Al mole fraction, background doping, and contact resistance. The gate contact model is important to get right as the field near the gate is the focus of this study. For this, we modeled the gate as a Schottky contact to be consistent with literature. 

**Figure Ideas**
- Plot showing the microstructure again
- Plot showing the transfer curves next to each other

10. **TCAD Model and Post-rad Modeling**
With the pre-irradiated calibration done, we were left needing to translate the hypothesis into something we could simulate. We introduced neutral electron traps (which are donor-like Yu et al.) that are neutral when empty and capture electrons when ionized. These trap types are consistent with the vacancy defects that Islam identified and the charge signs are consistent with requirements to deplete the 2DEG.

The first question was where to put them. We used the calibrated baseline device, ramped up the drain voltage to the values used during irradiation, and extracted the electric field profiles. You can see the field peaks sharply here at the drain-gate edge and even continues into the access region. This is our critical field region. Physically, why hypothesize that this is where two things coincide: the ion damage track passes through the device, and the field is strong enough to drive efficient electron capture. So this is where we center the trap distribution.

For the spatial profile, we use a 2D Gaussian centered in that peak field location. It gives us a smooth reasonable distribution that concentrates the traps in the critical region and tapers off. We used a trap energy distribution centered at 0.78 eV below the conduction band, based on DLTS measurements by Faqir and co-workers. The energy distribution helps with numerical stability. Rather than placing all the traps at the same energy level, which causes convergence issues with the solver, we distribute them in energy space using a Gaussian spread around a center trap level. The fractional occupancy integral doesn't have a closed form solution, so we evaluate it numerically using a three-point Guassian-Hermite quadrature. This gives us 3 distinct energy levels with appropriate weights that approximate a continuous distribution. Each of those trap levels get folded into Poisson's equation as an ionized charge term, and the result is a self-consistent solution for the trapped charge.

**Figure Ideas**
- 2D contour plot
- contour plot with trap distribution in it

11. **Simulation Results**
So here is what the simulation produces. We have the simulated IV characteristic with the trap distribution in place. You can see exactly the behavior we've set out to explain. The drain current rises normally at low Vds and then at a critical drain voltage, it rolls over and collapses as the trapped charge depletes the 2DEG. This is a DC steady-state solution by solving the DC operating point over and over throughout the sweep. The channel is pinching off because the filled traps in the gate-drain region have created enough negative space charge to deplete the 2DEG underneath. 

Here, we have the comparison to the expierment. We have the measured IV cures at several fluences, and on the right are the corresponding simulations. The model captures the essential features:
1. The onset of collapse
2. The shape of the rollover
3. And the rend that higher density produces earlier and more severe pinch off.
The simulations don't do a great job of matching quantitatively. This is because the trap density was taken as a free parameter that we're estimating from the fluence and SRIM damage profile, but the actual number of electrically active traps per ion strike is incredibly difficult to know. Not every displaced atom produces an electrically active trap, and the fraction that do depends on the local environment which we cannot measure or predict directly. So the conclusion we can draw from this is that neutral electron traps depleting the 2DEG reproduces the qualitative behavior and correct trends. There were no changes from the baseline device. The only thing we added was the trap distribution.

**Figure Ideas**
- Post rad current collapse (simulated vs experimental)
- Lateral trap occupation increasing with drain voltage

11. **Summary / Conclusion**
To summarize, We've shown that 8.4 MeV Bi ion irradiation produces a current collapse in AlGaN/GaN HEMTs that is fundamentally different from the conventional, transient phenomenon. This is a DC steady state effect where the channel pinches off at a critical drain voltage, and scales with fluence and electric field present during irradiation.

We proposed a mechanism grounded in existing literature, where heavy ions generate neutral electron traps through displacement damage. Those traps concentrate at the gate-drain edge where the field is highest, and the strain on the device is highest from the electric field. Once filled, they persistently deplete the 2DEG in the way Yu and others have described the virtual gate effect, with the primary difference being that our charge source is radiation based defects rather than intrinsic ones. 

Our TCAD model validates this idea. From a calibrated baseline device, our only modification was to insert a spatially localized trap distribution guided by the electric field profile and SRIM damage predictions. That single addition reproduces the onset, shape, and fluence-dependent trends of the collapse. The challenge is quantitatively mapping the ion fluence to electrically active trap density, and improving that is a clear direction for future work. 

Thank you - I'd like to share my references, and I'm happy to take questions.
11. **References**
12. **Questions**
