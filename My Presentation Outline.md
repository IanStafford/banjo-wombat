**Abstract**
High Electron Mobility Transistors (HEMTs) are widely used in aerospace systems for their high efficiency and inherent radiation tolerance, yet heavy ion strikes can still induce significant damage and performance degradation. This work investigates the origin of current collapse observed in AlGaN/GaN HEMTs exposed to 8.4 MeV Bi ions over a range of fluences. The hypothesis is that heavy-ion damage creates a localized region of neutral electron traps near the gate–drain edge, coinciding with the device’s highest electric-field stress. These traps capture electrons and form a persistent negative charge distribution that depletes the 2DEG channel, suppressing drain current. DC-biased irradiation measurements confirm this behavior, showing increasing collapse with increasing fluence and field strength. A TCAD model calibrated to non-irradiated devices reproduces this mechanism and provides a quantitative explanation for the observed current collapse phenomenon.
# Slide Script
1. **Title**
2. **HEMTs in Space**
HEMTs are characterized by their high power density and efficiency. They have a high breakdown field and operating voltage as a result of their wide bandgaps (3.4eV in this case). Power densities are an order of magnitude higher than SiC-based devices, and the compact nature of these devices makes them attractive for space power and telecommunication systems (Fleetwood, 2022).

It is a happy coincidence, then, that HEMTs (and GaN HEMTs especially) have an inherent radiation tolerance. It is difficult to define what makes something "rad-hard" but for an overview, HEMTs have no gate oxide to accumulate charge that shifts the threshold voltage, and the materials themselves (especially GaN) have higher displacement threshold energies making them more resistant to lattice damage (Pearton, 2021).

Radiation tolerance should not be conflated with immunity, however, as solar particle events can deliver ions with LET up to 100 MeV. These heavy ions create displacement cascades that accumulate into electrical hiccups and defects. Cumulative damage to the lattice can still degrade drain current, threshold voltage, and leakage through gate and drain (Fleetwood, 2022).

4. **HEMT Operation**
Quick overview on the HEMT device structure. In the standard AlGaN/GaN heterostructure we have the combination of spontaneous and piezoelectric polarization at the interface between the two materials. This creates a sheet of electrons we refer to as 2 dimensional electron gas.

5. **Delineation from conventional current collapse** 
Before talking about the experimental and simulated setups, I need to be specific about what we mean by current collapse in this work. It is not the same as what is conventionally talked about in GaN literature. It usually refers to a dynamic effect where you bias the device at off-state and pulse to on-state, and the drain current you measure is lower than what you'd expect from the DC I-V curve. That is classic gate-lag / drain-lag. Surface states or buffer traps capture charge under stress and form a virtual gate, when you pulse on the traps haven't had time to recombine, so the channel is partially depleted. The key difference is that this is transient. If you give it enough time the traps will recombine, the virtual gate disappears, and the drain current will recover.

This is not what we observed in our work, however. We see a DC characteristic. On a non-irradiated device, you sweep the drain at various gate biases, the device will increase in drain current until saturation normally. After irradiation, the current begins to rise as expected, but then at some critical drain voltage, it rolls over and collapses entirely. The channel completely pinches off while the gate is biased on. 

6. **Experimental Setup**
The devices tested were commercial RF HEMTs, so they were depletion-mode devices. As HEMTs go, this is the simplest configuration, just AlGaN and GaN interfacing to form the 2DEG at 0 gate bias. These devices were irradiated with heavy ions under various conditions. They were biased at off-state with varying drain biases at various LETs. After we got them back from the accelerator facilities, we performed DC I-V testing to see how the radiation affected device performance, and thus began the work of mapping the performance changes we observed to a TCAD model that explains the damage mechanisms. We used values and techniques from literature to develop the TCAD model as we attempted to replicate the devices we tested.

7. **Experimental Results**
After irradiation, we ran many of these same tests again. On the left, we have the transfer characteristics of the devices. We saw some slight changes at low LET but at high LET we have some leakage through the drain. This is on top of the gate leakage current seen in the middle, which worsens in the off-state of the gate's Schottky junction, before the diode forward biases. 

Again, this is only evident at high LET. 

Finally, on the right we can get to the crux of the issue. The low LET device appears to be consistently similar, if not slightly lower in output, than the reference device. The high LET device, however, experiences drain current that completely shuts off at a critical gate-drain bias, roughly 7V between the gate and drain. The current completely shuts off at these critical points on this high LET device. This is the phenomenon we want to capture in a TCAD model. Notably, we only included 3 of the devices tested for clarity.

8. **Hypothesis**
So the research question of this work is: What physical mechanism explains a DC pinch-off that worsens with fluence during irradiation?

Yu and co-workers showed through 2D simulation that when negative charge accumulates near the surface in the gate–drain region, it depletes the 2DEG through the virtual gate effect. In their work, this was donor-like surface traps interacting with the intrinsic polarization charge. But the underlying physics is general: any source of persistent negative charge above the channel in the access region will deplete the 2DEG.

Now, Islam and co-workers at Sandia gave us direct evidence of what heavy ions do to the crystal. They irradiated GaN HEMTs with gold ions and performed in-situ TEM, and what they found was a significant population of vacancies, interstitials, and dislocations throughout the device layers. Their EDS mapping specifically identified nitrogen and oxygen vacancies as the dominant electrically active defects. And, perhaps most importantly, they hypothesized that these defects act as charge traps whose accumulation lowers the breakdown voltage. Furthermore, they saw degradation worsen as these defects interacted with the electric field during device operation, such as the gate bias.

Our hypothesis relates these two ideas to explain the phenomena we observe. The Bi ions create displacement damage in the form of nitrogen and gallium vacancies (for the most part). This generates traps near the GaN buffer and near the heterointerface (heterostructure?). These traps are distributed along the ion tracks but the ones that dominate the electrical behavior of the device are located near the gate-drain edge, where SRIM profiles predict the damage profile overlaps with the peak lateral electric field. Under drain bias, that field drives electrons into the traps, where they form a persistent negative space charge that depletes the 2DEG. Because these are deep level traps, they don't release under DC conditions, so at a certain level, the depleted region expands and at a critical drain voltage the channel pinches off entirely.

9. **TCAD Model and Calibration to Pre-rad**
To simulate this, we first needed to calibrate to some pre-irradiation devices. We did not have access the the exact devices before radiation, so we could not make direct before & after data for the devices, and the device-to-device variance was significant  We replicated the structure in FLOOXS, a custom TCAD tool developed by UF's own Dr. Mark Law. Our simulation used a mobility model based on Faramand et al. where they used Monte Carlo simulation to extract a dependence of mobility on impurity scattering which will be discussed in more dtail by Dr. Law later in this conference. To achieve performance similar to the device in hand, we used Ambacher's formula for Schottky barrier height, which is derived from the Al mole fraction where we then predict the 2DEG density. The gate contact model is important to get right as the field near the gate is the focus of this study. For this, we modeled the gate as a Schottky contact to be consistent with literature.  These were commercial devices without available data for device characteristics such as Al mole fraction and doping, so we used these as tuning levers (Keeping them inside recognized industry norms) along with other parameters such as contact resistance, for the finishing touches. 

10. **TCAD Model and Post-rad Modeling**
With the pre-irradiated calibration done, we were left needing to translate the hypothesis into something we could simulate. We introduced neutral electron traps (which are donor-like Yu et al.) that are neutral when empty and capture electrons when ionized. These trap types are consistent with the vacancy defects that Islam identified and the charge signs are consistent with requirements to deplete the 2DEG.

The first question was where to put them. We used the calibrated baseline device, ramped up the drain voltage to the values used during irradiation, and extracted the electric field profiles. You can see the field peaks sharply here at the drain-gate edge and even continues into the access region. This is our critical field region. Physically, why hypothesize that this is where two things coincide: the ion damage track passes through the device, and the field is strong enough to drive efficient electron capture. So this is where we center the trap distribution.

For the spatial profile, we use a 2D Gaussian centered in that peak field location. It gives us a smooth reasonable distribution that concentrates the traps in the critical region and tapers off. We used a trap energy distribution centered at 0.78 eV below the conduction band, which we derived from literature. We use an energy distribution to help with numerical stability. Rather than placing all the traps at the same energy level, which causes convergence issues with the solver, we distribute them in energy space using a Gaussian spread around a center trap level. The fractional occupancy integral doesn't have a closed form solution, so we evaluate it numerically using a three-point Guass-Hermite quadrature which can hear more about this as well from Dr. Law later this week. The long and short of it is:  We get 3 distinct energy levels with appropriate weights that approximate a continuous distribution. Each of those trap levels get included in Poisson's equation as an ionized charge term, and the result is a self-consistent solution for the trapped charge that doesn't play hardball with the iterative solver.

11. **Simulation Results**
So here is what the simulation produces after the addition of the trap distribution, and no other changes. We have the simulated IV characteristic with the trap distribution in place. You can see exactly the behavior we've set out to explain. The drain current rises normally at low Vds and then at a critical drain voltage, it rolls over and collapses as the trapped charge depletes the 2DEG. This is a DC steady-state solution by solving the DC operating point over and over throughout the sweep. The channel is pinching off because the filled traps in the gate-drain region have created enough negative space charge to deplete the 2DEG underneath. 

Here, we have the comparison to the experiment. We have the measured IV curves of an example device, and on the right are the corresponding simulations. The model captures the essential features:
1. The onset of collapse
The simulations don't do a great job of matching quantitatively. This is partly because we saw great device-to-device variance in the non-irradiated samples, and we didn't have pre-rad and post-rad data for the HEMTs that went through the accelerator facilities. Furthermore, the trap density was taken as a free parameter that we're estimating from the LET and some SRIM damage simulations. The actual number of electrically active traps per ion strike is incredibly difficult to know. Not every displaced atom produces an electrically active trap, and the fraction that do depends on factors which we cannot measure or predict reliably. So the conclusion we can draw from this is that neutral electron traps depleting the 2DEG reproduces the qualitative behavior and correct trends. 

2. **Summary / Conclusion**
To summarize, We've shown that high LET ion irradiation produces a current collapse in AlGaN/GaN HEMTs that is fundamentally different from the conventional, transient phenomenon. This is a DC steady state effect where the channel pinches off at a critical drain voltage, and scales with the LET of ions used.

We proposed a mechanism grounded in existing literature, where heavy ions generate neutral electron traps through displacement damage. Those traps concentrate at the gate-drain edge where the field is highest, and the strain on the device is highest from the electric field. Once filled, they persistently deplete the 2DEG in the way Yu and others have described the virtual gate effect, with the primary difference being that our charge source is radiation based defects rather than intrinsic ones. 

Our TCAD model validates this idea. From a calibrated baseline device, our only modification was to insert a spatially localized trap distribution guided by the electric field profile and SRIM damage predictions. That single addition reproduces the onset, shape, and fluence-dependent trends of the collapse. The challenge is quantitatively mapping the ion fluence to electrically active trap density, and improving that is a clear direction for future work. 

11. **Questions**

- Use the pointer
- ~~Add in the "we don't have the real devices bit to make the exact matches pre and post rad"~~
- Use the conlcusion to make up time at the end if needed
- ~~Define LET in slide 2~~
- Mentioned the drain-gate bias instead of drain bias
- Mention that this is low dose and we get a "lucky" strike.
- farahmand did velocity field saturation relationship
	- could say we used farahmand model that dr law will talk about it.
- ~~Yu sounds like you~~

