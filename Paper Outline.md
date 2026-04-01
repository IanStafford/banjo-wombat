ee1 for the password
# Simulation of heavy ion damage and current collapse in GaN HEMTs
## Introduction
- Introduce GaN HEMTs and benefits, drawbacks
- Explain role in aerospace and telecommunications industry
- Introduce concept of ion damage as it pertains to devices in space
- Explain the current collapse phenomenon and how it is detrimental to device performance?

- Need for physics-based models to explain current collapse
- Overview of subsequent sections of paper

### Draft
Gallium nitride (GaN) based high electron mobility transistors (HEMT) have emerged as a leading technology for high-power, high-frequency electrnoic applications. Their performance stems from the formation of a two-dimensional electron gas (2DEG) at the AlGaN/GaN heterojunction, induced by spontaneous and piezoelectric polarization discontinuities that generate sheet charger densities on the order of 10^13 cm^-2 [Ambacher] The resultant channel supports high density sheets of electrons that, when combined with GaN's wide bandgap and critical electric field, can achieve power densities greater than those achievable in silicon or even GaAs devices [Farahmand]. These (attributes/characteristics) have driven widespread adoption of GaN HEMTs in high frequency, high power amplifiers as well as radar systems and telecommunications equipment [Haziq].

Current research in GaN technology aims to extend device performance and lifespan in demanding environments such as space and aerospace applications. Satellites, deep-space probes, and the launch vehicle electronics themselves are subjected to sustained exposure to high concentrations of energetic particles. Protons and electrons that are trapped in the Van Allen belts as well as solar energetic particles can degrade and destroy semiconductor components and compromise device operation over a devices operating lifetime [Pearton, 2015]. GaN HEMTs are attracting attention as radiation tolerant alternativesa to conventional devices due to their wide bandgap and the high displacement energies in the crystal itself [Pearton, 2021]. Heavy ions, in particular, present a distinct threat to all electronics technologies, and GaN is no exception. A single energetic ion traversing the active region of a device deposits a dense ionization column along its path on picosecond timescales, producing carrier densities far exceeding equilibrum values and inducing transient, and potentially permanent changes to device behavior [Kuboyama, Onoda]. As GaN HEMTs are increasingly used in space applications, understanding their response to heavy ion strikes and the mechanisms by which those strikes degrade performance has become a point of concern in GaN technology reliability [Islam].

The central performance degradation mechanism observed in GaN HEMTs following heavy ion exposure is current collapse, also referred to as drain current dispersion. Current collapse describes the reduction in pulsed or RF drain current relative to the DC-measured value at equivalent bias conditions, arising when charge becomes trapped at surface states, passivation interfaces, or bulk defect sites within the AlGaN barrier or GaN buffer [Faqir et al., 2010; Yu et al., 2013]. Occupied traps partially deplete the 2DEG through a virtual gate effect, elevating on-resistance and suppressing the saturation current in a manner that cannot be  ~~fixed~~ recovered by adjusting the applied gate bias [Sharma et al., 2020]. Heavy ion irradiation exacerbates this phenomenon by introducing new deep-level trap states through displacement damage and by transiently charging existing traps via the ion-generated carrier plasma, both of which persist long after the initiating strike [Koehler et al., 2016; Yu et al., 2026]. The resulting effect is measurable degradation of output power, efficiency, and dynamic switching performance. Accurate trap characterization, through techniques such as deep-level transient spectroscopy and pulsed I-V measurements, is essential for identifying the trap species and energy levels responsible [Zou et al., 2023].

*AI helped make this paragraph sound more formal*
Experimental irradiation measurements establish the phenomenon of heavy ion current collapse, but cannot directly resolve the spatial distribution of trapped charge contributing to the effect. Physics-based simulations address this gap by self-consistently solving coupled carrier transport and Poisson equations together with trap occupancy rate equations [Patrick, Patrick]. These technologies enable us to resolve specific physical processes against experimental results. Conventional TCAD studies in GaN HEMTs have primarily examined single-event transients in normally-off devices [Zerarka]. Detailed simulation of of radiation induced current collapse in depletion-mode GaN HEMTs using a drift-diffusion framework with calibrated trap physics is an open area of investigation. This paper presents a TCAD simulation study of heavy ion irradiation and current collapse in depletion-mode AlGaN/GaN HEMTs using the FLOOXS simulation framework.

Section 2 describes the device structure, polarization charge treatment, trap parameter calibration, and heavy ion ionization track implementation. 

Section 3 presents baseline device characteristics and validation against experimental data. 

The simulated collapse response following heavy ion strike events is analyzed in Section 4, with emphasis on the dependence of collapse magnitude and recovery on trap species, energy level, and spatial distribution. 

Section 5 discusses implications for radiation-hardening design strategies, and 

Section 6 presents conclusions.

## Background / Literature Review
### Electric Field Distribution and Critical Device Regions
The performance and reliability of AlGaN/GaN HEMTs are strongly governed by the internal electric field distribution, particularly in the gate-to-drain access region. Under typical off-state or high-drain-bias operating conditions, the electric field is highly non-uniform, with a pronounced peak concentrated at the drain-side edge of the gate electrode where the depletion region terminates abruptly at the AlGaN surface [Haziq et al., 2022]. This localized field enhancement is a consequence of the planar gate geometry and the high sheet charge density of the 2DEG channel, and it scales inversely with gate-to-drain spacing as devices are reduced for high-frequency operation. The intensity of this peak field has direct implications for both breakdown voltage and charge trapping: surface and interface states located in this high-field region are preferentially charged under gate or drain bias, making the gate edge the primary locus of trapping-related degradation mechanisms.

Field plate (FP) structures were developed specifically to redistribute this concentrated field. By extending the gate metallization over the passivation layer toward the drain, the field plate introduces a secondary peak in the electric field profile at its drain-side edge, effectively broadening the depletion region and replacing a single sharp maximum with a more uniform, multi-peak distribution [Haziq et al., 2022]. This redistribution reduces the absolute peak field at the gate edge, suppresses surface electron trapping in the high-field region, and increases the gate-to-drain breakdown voltage in proportion to the channel length over which the field is spread.

### Current Collapse Mechanisms and Characterization

### Radiation Effects in AlGaN/GaN HEMTs




**OLD**
- 2DEG formation
- Device operation
- Field Distribution
- High field / critical energy area

- Radiation damage effects
- Heavy ion interactions (TRIM?)
- Previous studies on radiation (Proton and heavy ion)
- Known / theorized effects

- Characteriztion methods of current collapse (How to define)
- Previously reported/theorized causes of current collapse
- Current studies on heavy-ion current collapse

- Electron trap physics and formation
- Trap energy levels in GaN
- Role of traps electrostatically
- Justification of spatial distribution
___
**NEW**
Notes: We probably don't want to talk about 2DEG and normal device operation, we have a lot to talk about otherwise. We should talk about the high field area under the gate and the floating plate area because that relates to the trap characterization. Haziq 2022 talks about that here:
:
	*“This high electric field may facilitate charge trapping between the passivation layer and III-nitrides interface. Electrons may also become stuck in free surface states under a strong electric field, triggering virtual gating and current collapse [173]. Owing to smaller gate–drain spacing, devices undergo significantly higher current collapse when scaled down for high-speed operation, amplifying the virtual gating effect of surface traps. Moreover, controlling the electric field distribution between the gate and drain is critical for obtaining a linearly scaled breakdown voltage per channel length. Scaling high-power GaN-based HEMTs to achieve low on-resistance and gate charge (Qg) is thus still a challenge for high-power and high-speed operation. Hence, the peak strength of the electric field at the gate edge must be reduced to achieve a high breakdown voltage [174].” (Haziq et al., 2022, p. 14)
	 Some viable solutions to address these concerns include FP implementation, surface passivation, and gate structure variations. FP refers to an extension of the gate deposited onto the passivation layer toward the drain side, where the electric field at the AlGaN surface decreases. As shown in Figure 12a, the metallization layer sits on top of the passivation layer of HEMTs and prevents the current collapse effect by reducing the peak electric field near the gate’s drain edge [178]. In theory, the profile of the electric field distribution improves as FP successfully broadens the depletion region with multiple peaks that may substitute for a single peak, resulting in a more uniform electric field distribution [179]. FP implementation also helps reduce reverse leakage current. By providing an extra surface for field line termination and thus dispersing the electric field over a longer gate-to-drain interval, FP can reduce the maximum electric field and lessen electrical field congestion at the drain side of the gate edge. (Haziq et al., 2022, p. 15)*

We also have some more specific charge trapping info from Yu, Faqir, Zou, and Sharma. I can consolidate more of that later I think the justification of the spatial distribution of traps can be derived from some of these trap characterization papers and our own electric field measurements. 

Info on radiation damage effects and electrostatic effects can be derived from Patrick, Anderson, and some of the previously mentioned like Yu, Zou, Sharma. I can pull specifics soon. Dr. Patrick used TRIM and I have a little (We would have to dust it off) to discuss damage characteristics. Not sure device damage characteristics and ion tunneling and worth mentioning, although they can help explain the spatial distribution idea more? We have multiple previous studies on heavy ion but my Zotero isn't synced so I cannot list them (on my TODO)

Current collapse is one of the most discussed phenomena with these devices, and I think it may be best to mention it before getting to radiation effects since it can manifest without radiation. Obviously the radiation worsens it. The two review papers I have are great for their in-depth explanation of current collapse and paraphrasing from them is probably going to be the best, most accurate way of incorporating it into the paper. **I'm thinking something along the lines of "current collapse is x,y,z caused by i,j,k and radiation effects are l,m,n caused by d,e,f and radiation effects worsen current collapse because il, jm, kn" for a general topic statement for the lit review** 

**OLD**
## Experimental Methods

- Devices sent from MACOM
- Devices irradiated by NASA
- Devices tested by UF

- Device specs and dimensions
- Device configuration
- Irradiation methods
## TCAD Methods
- TCAD Platform (explain flooxs)
- Device geometry
- Material parameters / choices (How modeled sheet charge)
- Other constraining physics

- Calibration to regular devices
- parameter extraction (Kinda experimental)
- Radiation damage implmenetation
- Failed approahes?
- DC Bias dependent radiation damage

- Simulation methodology?
___
**NEW**
## Methods
Combining two sections from my previous outline into one methods section. More in line with everything I've been reading. I won't have much to add on the experimental methods portion, the technical specifics of the cyclotron they used and the pulse width of the curve tracer I'm not really familiar with (Does that stuff need to be in the paper?). But I would like to contain a good overview of the testing methodology to complete the paper.

The TCAD or Simulation Methods section is going to be our jam here. I'm going to introduce FLOOXS as a tool, explain the mobility models (Farahmad?) and justify the changes to the model. Using info from Dr. Law and Dr. Patrick's papers I aim to create a simulation framework and then specify the specific changes we made to the model and the justifications for them(Do we make justifications here or in the results/discussion section?). The main points I want to hit are:
- Inclusion of trap states in charge carrier portion of the mobility model
	- This highlights FLOOXS ability to custom tune every aspect of the solver
- Inclusion of the spatially confined trap area
	- If the trapping characteristics are affected by a high field region, then it should be easily justifiable to use the spatially confined "High field" region to change where traps form
- Maybe a transient or two to see if reproducibility is a thing?

## Results
- Repeatable current collapse (NOT burnout)
- RF changes less noticeable
- DC Bias dependence
- Gate leakage (If we ever get data)

- Matched pre-irradiation device
- Reproduced behavior with trapped charge cloud
- Visualizations of field, charge cloud, etc.

## Discussion
- Heavy ion strike creates localized damage region
- neutral electron traps form at high field region (gate-drain edge)
- Electron traps create negative charge
- Negative charge depletes 2DEG\
- Role of DC bias during irradiation

- Consistency with GaN defects and defect physics
- Device operation (still useable for RF?)
- Strengths of TCAD (Self justification)

- Mitigation strategies
- Topology optimization
- Rad hardness design and performance


## Conclusion
Summary of findings, future work, and acknowledgements.

- Summary of findings
- Validity of proposed damage method restated
- Implications for GaN designs?

Future work
- Temp dependence?
- Different device structures (Tgate?)

## Sources
- Challenges and Opportunities for High-Power and High-Frequency AlGaN/GaN High-Electron-Mobility Transistor (HEMT) Applications: A Review
	- https://doi.org/10.3390/mi13122133
	- The emergence of gallium nitride high-electron-mobility transistor (GaN HEMT) devices has the potential to deliver high power and high frequency with performances surpassing mainstream silicon and other advanced semiconductor field-effect transistor (FET) technologies. Nevertheless, HEMT devices suffer from certain parasitic and reliability concerns that limit their performance. This paper aims to review the latest experimental evidence regarding HEMT technologies on the parasitic issues that affect aluminum gallium nitride (AlGaN)/GaN HEMTs. The first part of this review provides a brief introduction to AlGaN/GaN HEMT technologies, and the second part outlines the challenges often faced during HEMT fabrication, such as normally-on operation, self-heating effects, current collapse, peak electric field distribution, gate leakages, and high ohmic contact resistance. Finally, a number of effective approaches to enhancing the device’s performance are addressed.
	- I like this source for explaining HEMT drawbacks and strenths
	- 2022
- Comprehensive review of GaN HEMTs: Architectures, recent developments, reliability concerns, challenges, and multifaceted applications
	- https://doi.org/10.1016/j.prime.2025.101059
	- The emerging need for high-frequency, high-power electronics and biosensors necessitates the demand for high electron mobility transistors (HEMTs) that outperform the mainstream silicon and other direct bandgap materials. Gallium Nitride (GaN)-based HEMTs can operate in both depletion-mode (D-mode) and enhancement-mode (E-mode), and have garnered significant attention for their superior performance in these applications. These wide band-gap semiconductors exhibit significant outcomes in DC as well as RF applications, such as a higher threshold voltage of 8.6 V, transconductance of 680 S/mm with OIP3 (output third-order intercept point) of 41.2 dB, cut-off frequency (fT) of 391 GHz compared to the conventional devices. There are also found some meticulous parameters e.g. breakdown voltage (Vbr) of 1513 V, drain saturation current of 3.41 kA/cm2 with an equivalent noise resistance (Rn) of 1.21 dB and 20 Ω at 20 GHz, a low on-resistance (RON) of 0.00269 Ω-mm, at gate length (LG) of 100 nm in a [GaN](https://www.sciencedirect.com/topics/engineering/nitride "Learn more about GaN from ScienceDirect's AI-generated Topic Pages") HEMT by using quaternary InAlGaN barrier is achieved maximum drain current (IDS, max) of 1940 mA/mm while another HEMT with Carbon doped [GaN](https://www.sciencedirect.com/topics/physics-and-astronomy/nitride "Learn more about GaN from ScienceDirect's AI-generated Topic Pages") buffer as well as AlGaN back barrier gets Vbr around 2900 V. The RF metrics, like a fT of 200 GHz with moderate LG of 80 nm for AlGaN/GaN HEMT with Si substrate of plasma molecular beam epitaxy, a maximum oscillation frequency (fmax) of 308 GHz, show great impact on High-frequency and microwave applications. Nevertheless, the E-mode outperforms the D-mode HEMTs for secured operations with low leakage loss; there are still some challenges, such as current collapse, short-channel effects, and pinch-off phenomena that persist, impacting device reliability. This review article examines recent advancements in [GaN](https://www.sciencedirect.com/topics/materials-science/gallium-nitride "Learn more about GaN from ScienceDirect's AI-generated Topic Pages") HEMT architectures, emerging materials, and their applications in power and radio-frequency devices, as well as explores future applications in biosensing, satellite, and optical communications.
	- I like this one because it talks about the function, different architectures, mentions current collapse as a problem that needs solving, and it discusses GaN HEMT use in telecom and aerospace applications
	- 2025
- Trapping Effects on Leakage and Current Collapse in AlGaN/GaN HEMTs
	- no doi i can find
	- Can't copy abstract. Basically investigates acceptor traps in GaN buffer layer and AlGaN barrier lays and relates current collapse to higher trap concentrations. Proposes a trade-off between current collapse and leakage current
	- 2020
- Analysis of current collapse effect in AlGaN/GaN HEMT: Experiments and numerical simulations
	- In this work, current collapse effects in AlGaN/GaN HEMTs are investigated by means of measurements and two-dimensional physical simulations. According to pulsed measurements, the used devices exhibit a significant gate-lag and a less pronounced drain-lag ascribed to the presence of surface/barrier and buffer traps, respectively. As a matter of fact, two trap levels (0.45 eV and 0.78 eV) were extracted by trapping analysis based on isothermal current transient. On the other hand, 2D physical simulations suggest that the kink effect can be explained by electron trapping into barrier traps and a consequent electron emission after a certain electric-field is reached.
	- Basically exactly what we've been doing...
	- 2010
- Trap Characterization Techniques for GaN-Based HEMTs: A Critical Review
	- https://doi.org/10.3390/mi14112044
	- Gallium nitride (GaN) high-electron-mobility transistors (HEMTs) have been considered promising candidates for power devices due to their superior advantages of high current density, high breakdown voltage, high power density, and high-frequency operations. However, the development of GaN HEMTs has been constrained by stability and reliability issues related to traps. In this article, the locations and energy levels of traps in GaN HEMTs are summarized. Moreover, the characterization techniques for bulk traps and interface traps, whose characteristics and scopes are included as well, are reviewed and highlighted. Finally, the challenges in trap characterization techniques for GaN-based HEMTs are discussed to provide insights into the reliability assessment of GaN-based HEMTs.
	- This article surmises that different bias conditions can result in different trap formation in GaN HEMTs in the GaN buffer layer and the AlGaN barrier layer
	- 2023
- 


