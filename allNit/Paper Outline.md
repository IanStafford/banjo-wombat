Right now thinking each bullet can be sentence or two. Gaps between bullets are topics of interest (Will add subheadings at least for the outline)
# Simulation of heavy ion damage and current collapse in GaN HEMTs
## Introduction
- Introduce GaN HEMTs and benefits, drawbacks
- Explain role in aerospace and telecommunications industry
- Introduce concept of ion damage as it pertains to devices in space
- Explain the current collapse phenomenon and how it is detrimental to device performance?

- Need for physics-based models to explain current collapse
- Overview of subsequent sections of paper
## Background / Literature Review
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


