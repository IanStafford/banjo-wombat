
# Zotero Group
https://www.zotero.org/groups/6526536/hemt_simulation
## Title
Review of Simulation of High Electron Mobility Transistor Devices

## Motivation
More motivation for III-V technologies, GaN on SiC/Si, as well as InAlN/GaN, and AlGaN/AlN. Growing adoption in power electronics and mmWave RF as well as space and defense. Simulation is challenged compared to conventional silicon devices due to polarization-induced 2DEG, lattice strain induced mobility effects,  deep traps, and extreme operating conditions (high-rad). 

From Talukder 2025
> GaN-based HEMTs nowadays have gained significant attention for high power and high frequency applications due to their heterostructures having superior material properties, wide band-gap, higher voltage, current, frequency and temperature withstand due to the high electric field strength of the material combined with the high mobility and electron density of the two-dimensional electron gas (2DEG) formed at the heterointerface between the channel and barrier layers [1]. Because of having a strong market share, researchers have recently put enormous effort into optimizing GaN-based HEMT devices [2–8] with improved reliability [9–15], better circuitry and device architecture [16–18]. 

>In short, even though GaN–HEMTs have widespread applications in power [126,127] & RF devices multiple challenges like epitaxial growth & material quality control [27], device scaling, thermal management, ohmic contact [28] quality and the impact of interface and surface states [29] remain concerning issues which must be resolved for reliable and effective performance of the devices. Continuous research & studies are ongoing to mitigate the reliability challenges. Surface passivation techniques have been proposed to mitigate current collapse [30], uniform distribution of electric fields can be achieved through field plate designs [31,32] that reduce the risk of carrier trapping, but these adaptations must be assessed in terms of their impact on other performance metrics such as gate leakage and switching speed.


Introduce the scope of the talk (device-level TCAD from drift-diffusion modeling through full-3D, emphasizing defect physics and radiation response and modeling). Realistically, this is fluid and depends on what we want the 12 minutes to focus on.

## Device Physics
Spontaneous and piezoelectric polarization leads to 2DEG formation, introduce challenge with modeling the charge signs and magnitudes (ambacher). Talk about the band diagram essentials through the AlGaN barrier, GaN channel, buffer layer. Then we can discuss contact modeling. Talk about d-mode vs e-mode device modeling and how that changes the gate, ohmic, schottky, thermionic emission, barrier height sensitivity.

> Basically the entire introduction section of Ambacher paper has qualitative info on this. Also, the formula used for sheet density concentration in section IV (using Al mole fraction) is something we use in the simulations at least for the D mode devices.

To tie it back into simulation we can talk about how Al mole fraction sets the Schottky barrier height starting point, background GaN doping controls the fit near threshold voltage, polarization charge and contact resistance taken from experiment

There is also the surface donor model that claims that the 2DEG density comes from 1.65eV donors from Ibbetson

>The origin of the two-dimensional electron gas ~2DEG! in AlGaN/GaN heterostructure field effect transistors is examined theoretically and experimentally. Based on an analysis of the electrostatics, surface states are identified as an important source of electrons. The role of the polarization-induced dipole is also clarified. Experimental Hall data for nominally undoped Al0.34Ga0.66N/GaN structures indicate that ;1.65 eV surface donors are the actual source of the electrons in the 2DEG, which forms only when the barrier thickness exceeds 35 Å. 

There was some work in 2016 introducing corrected polarization constants, but I don't know anything about it and haven't read the paper myself.

>Accurate values for polarization discontinuities between pyroelectric materials are critical for understanding and designing the electronic properties of heterostructures. For wurtzite materials, the zincblende structure has been used in the literature as a reference to determine the effective spontaneous polarization constants. We show that, because the zincblende structure has a nonzero formal polarization, this method results in a spurious contribution to the spontaneous polarization differences between materials. In addition, we address the correct choice of “improper” versus “proper” piezoelectric constants. For the technologically important III-nitride materials GaN, AlN, and InN, we determine polarization discontinuities using a consistent reference based on the layered hexagonal structure and the correct choice of piezoelectric constants, and discuss the results in light of available experimental data

[1] J. D. Albrecht, R. P. Wang, P. P. Ruden, M. Farahmand, and K. F. Brennan, “Electron transport characteristics of GaN for high temperature device modeling,” _J. Appl. Phys._, vol. 83, no. 9, pp. 4777–4781, May 1998, doi: [10.1063/1.367269](https://doi.org/10.1063/1.367269).

[2] O. Ambacher _et al._, “Two dimensional electron gases induced by spontaneous and piezoelectric polarization undoped and doped AlGaN/GaN heterostructures,” _Journal of Applied Physics_, vol. 87, pp. 334–344, Jan. 2000, doi: [10.1063/1.371866](https://doi.org/10.1063/1.371866).

[3] C. E. Dreyer, A. Janotti, C. G. Van de Walle, and D. Vanderbilt, “Correct Implementation of Polarization Constants in Wurtzite Materials and Impact on III-Nitrides,” _Phys. Rev. X_, vol. 6, no. 2, p. 021038, Jun. 2016, doi: [10.1103/PhysRevX.6.021038](https://doi.org/10.1103/PhysRevX.6.021038).

[4] M. Farahmand _et al._, “Monte Carlo simulation of electron transport in the III-nitride wurtzite phase materials system: binaries and ternaries,” _IEEE Transactions on Electron Devices_, vol. 48, no. 3, pp. 535–542, Mar. 2001, doi: [10.1109/16.906448](https://doi.org/10.1109/16.906448).

[5] J. P. Ibbetson, P. T. Fini, K. D. Ness, S. P. DenBaars, J. S. Speck, and U. K. Mishra, “Polarization effects, surface states, and the source of electrons in AlGaN/GaN heterostructure field effect transistors,” _Appl. Phys. Lett._, vol. 77, no. 2, pp. 250–252, Jul. 2000, doi: [10.1063/1.126940](https://doi.org/10.1063/1.126940).

[6] F. Bernardini, V. Fiorentini, and D. Vanderbilt, “Spontaneous Polarization and Piezoelectric Constants of III-V Nitrides,” _Physical review. B, Condensed matter_, vol. 56, May 1997, doi: [10.1103/PhysRevB.56.R10024](https://doi.org/10.1103/PhysRevB.56.R10024).
## Simulation (2D, quasi-3D, 3D)
Introduce the governing equations such as poisson, e,h continuity, urrent density via quasi fermi-levels. In your 2014 paper you talk about finite element vs finite volume

 >Traditionally, the carrier continuity equations have been formulated using a finite volume approach using the Scharfetter-Gummel (1) discretization. The ScharfetterGummel (SG) discretization method is applied to the continuity equations in order to avoid instabilities otherwise found in a standard difference scheme
 >
 >The SG method solves this problem in one dimension, assuming a constant electric field along an edge. For multi-dimensional problems, the current is defined along the grid edges and appropriate weighting factors are used to sum the current. Some disadvantages of the SG method include current being defined only on the edge of an element resulting in imprecise evaluation of the total current over the element; and current flow being dependent on the grid (2). Despite these limitations this method is stable and reliable, serving as the approach for many device simulators including PICESII, PADRE, Sentaurus SDevice, and Silvaco Atlas.
 >
 >Though using finite element methods to discretize the Poisson and continuity equations is less common, this approach is viable (3-6). For formulation in a finite element-based discretization scheme, the continuity equations are written in terms of the electron and hole quasi-Fermi levels (φn,p) as compared to the drift-diffusion formula that is implemented with a finite volume SG scheme.  [4] 
 >
 >Recent work has shown that simulation results obtained by the finite volume SG method or quasi-Fermi FEM are comparable and that the FEM approach is preferable when current flow is not in the direction of the grid, such as ionizing radiation in single event upsets (6).

### Dimensionality
This is my least knowledgeable section, given that the talk is only 12 minutes it could make sense to give this a brief mention in the simulation section
## Power Device Simulation
Breakdown voltage predictions, impact ionization models and field plate geometry optimization are main things to talk about. Optimizing for low on-resistance and high voltage operation are common for these devices. There can also be a big talk about contact modeling here.

Can talk about how negative trapped charge reduced peak field at gate edges (threshold shift)

**Sources for this section**

[1] Z. Bhat and S. A. Ahsan, “A Comprehensive Model for Gate Current in E-Mode p-GaN HEMTs,” _IEEE Transactions on Electron Devices_, vol. 71, no. 3, pp. 1812–1819, Mar. 2024, doi: [10.1109/TED.2024.3356432](https://doi.org/10.1109/TED.2024.3356432).

[2] M. Meneghini _et al._, “GaN-based power devices: Physics, reliability, and perspectives,” _J. Appl. Phys._, vol. 130, no. 18, p. 181101, Nov. 2021, doi: [10.1063/5.0061354](https://doi.org/10.1063/5.0061354).
## RF Device Simulation
Small signal parameter extraction is big one for this. Large signal behavior is more difficult to simulate but still useful so we can mention that as well.

Hot carrier effects such as high-field transport in the channel and gate-drain access region.

Can talk about where drift-diffusion falls short for high frequencies and where hydrodynamic transport models work best.

**Sources for this section**
[1] J. D. Albrecht, R. P. Wang, P. P. Ruden, M. Farahmand, and K. F. Brennan, “Electron transport characteristics of GaN for high temperature device modeling,” _J. Appl. Phys._, vol. 83, no. 9, pp. 4777–4781, May 1998, doi: [10.1063/1.367269](https://doi.org/10.1063/1.367269).

[2] M. Farahmand _et al._, “Monte Carlo simulation of electron transport in the III-nitride wurtzite phase materials system: binaries and ternaries,” _IEEE Transactions on Electron Devices_, vol. 48, no. 3, pp. 535–542, Mar. 2001, doi: [10.1109/16.906448](https://doi.org/10.1109/16.906448).

## Trap and Defect Modeling
Traps are critical to reliability in III-V devices. Carbon, nitrogen, oxygen vacancies all cause charge trapping. Common dopants in GaN/AlGaN also have deep levels for dopants, such as Mg and Fe.
SRH recombination is very slow with wide bandgap of III-V materials, so there is high field dependence. 
Transient trap dynamics such as capture/emission time constants and how that effects RF simulations with gate/drain lag and pulsed IV predictions

**I haven't pulled anything yet but Zou et al in the Zotero is good for this. I'll be getting more for my paper soon**

[1] C. Yu, Q. Luo, X. Luo, and P. Liu, “Donor-Like Surface Traps on Two-Dimensional Electron Gas and Current Collapse of AlGaN/GaN HEMTs,” _ScientificWorldJournal_, vol. 2013, p. 931980, Nov. 2013, doi: [10.1155/2013/931980](https://doi.org/10.1155/2013/931980).

[2] X. Zou _et al._, “Trap Characterization Techniques for GaN-Based HEMTs: A Critical Review,” _Micromachines_, vol. 14, no. 11, p. 2044, Nov. 2023, doi: [10.3390/mi14112044](https://doi.org/10.3390/mi14112044).

[3] M. J. Uren, J. Moreke, and M. Kuball, “Buffer Design to Minimize Current Collapse in GaN/AlGaN HFETs,” _IEEE Trans. Electron Devices_, vol. 59, no. 12, pp. 3327–3333, Dec. 2012, doi: [10.1109/TED.2012.2216535](https://doi.org/10.1109/TED.2012.2216535).
## Radiation Effects Modeling
- TCAD implementation of traps in FLOODS: Shockley-Read-Hall with explicit trap levels. The ionization function for a donor trap (Eq. 4) is a steep function around the trap level
	- Ionization changes from 90% to 10% over only 0.1 V change in the Fermi level, which is a typical bias step size. 
	- Newton's method becomes unstable.
- Solution: distribute traps in energy space using a Gaussian distribution around the center trap level, then integrate the fractional occupancy using Gaussian-Hermite quadrature with three points. This avoids the convergence oscillation while preserving the physics.
-  Spatial dependence of partial ionization: acceptor traps are always fully ionized at the AlGaN/GaN interface and fall off exponentially into the GaN bulk. The depth of ionization depends on the trap energy level relative to the valence band
	- shallow acceptors penetrate deeper.
- Donor-acceptor compensation is critical: donor traps are not ionized at the interface but become ionized deeper into the GaN, compensating the acceptor traps and confining the net negative space charge to within tens of nanometers of the AlGaN/GaN interface (Figure 11 of Patrick 2015). A model with only acceptor traps cannot simultaneously explain both the small threshold shift and the large mobility reduction.
### TID
Talk about dielectric charge buildup and interface state buildup. Mainly how it impacts threshold voltage shift. We model it by dose-dependent fixed charge injection at the interfaces and measure the shift in Vt. Also with trap states instead of fixed charge for more dynamic simulation

Negative charge at the SiN/AlGaN interface (passivation charging) can reduce the peak electric field at gate edges without affecting threshold voltage. This is a separate mechanism from bulk GaN trapping and explains the experimentally observed increase in critical voltage for field-induced degradation

GaN is already rad-hard so these effects are very minimal and often not noticeable
### Displacement Damage
Displacement damage creates frenkel pairs (V+I) and increases deep trap density in the buffer and barrier layers.

Mobility degradation: the Farahmand ionized impurity scattering model explains the observed mobility reduction in the experimental data from Karmarkar, Kalavagunta, and Liu all can be validated with TRIM.

Concentrations of acceptor and donor traps account for Vt shift, Ids reduction, and mobility reduction. (AlGaN barrier layer doesn't contribute much)

### Single Event (no)
Single event effects creat transient carrier generation along an ion track and creates current transients and current collapse

Coupling SEE with pre-existing traps: how buffer traps affect
single-event transients
___
**Not to throw the book at this section but...**
[1] E. Patrick, M. Choudhury, and M. E. Law, “Simulation of Radiation Damage in GaN HEMT Structures,” _ECS Trans._, vol. 64, no. 17, p. 35, Aug. 2014, doi: [10.1149/06417.0035ecst](https://doi.org/10.1149/06417.0035ecst).

[2] E. E. Patrick, M. Choudhury, F. Ren, S. J. Pearton, and M. E. Law, “Simulation of Radiation Effects in AlGaN/GaN HEMTs,” _ECS J. Solid State Sci. Technol._, vol. 4, no. 3, p. Q21, Jan. 2015, doi: [10.1149/2.0181503jss](https://doi.org/10.1149/2.0181503jss).

[3] S. J. Pearton _et al._, “Review—Radiation Damage in Wide and Ultra-Wide Bandgap Semiconductors,” _ECS J. Solid State Sci. Technol._, vol. 10, no. 5, p. 055008, May 2021, doi: [10.1149/2162-8777/abfc23](https://doi.org/10.1149/2162-8777/abfc23).

[4] S. J. Pearton, F. Ren, E. Patrick, M. E. Law, and A. Y. Polyakov, “Review—Ionizing Radiation Damage Effects on GaN Devices,” _ECS J. Solid State Sci. Technol._, vol. 5, no. 2, p. Q35, Nov. 2015, doi: [10.1149/2.0251602jss](https://doi.org/10.1149/2.0251602jss).

[5] S. Kuboyama _et al._, “Single-Event Damages Caused by Heavy Ions Observed in AlGaN/GaN HEMTs,” _IEEE Transactions on Nuclear Science_, vol. 58, no. 6, pp. 2734–2738, Dec. 2011, doi: [10.1109/TNS.2011.2171504](https://doi.org/10.1109/TNS.2011.2171504).

[6] M. Faqir _et al._, “Analysis of current collapse effect in AlGaN/GaN HEMT: Experiments and numerical simulations,” _Microelectronics Reliability_, vol. 50, no. 9, pp. 1520–1522, Sep. 2010, doi: [10.1016/j.microrel.2010.07.020](https://doi.org/10.1016/j.microrel.2010.07.020).

[7] M. J. Uren, J. Moreke, and M. Kuball, “Buffer Design to Minimize Current Collapse in GaN/AlGaN HFETs,” _IEEE Trans. Electron Devices_, vol. 59, no. 12, pp. 3327–3333, Dec. 2012, doi: [10.1109/TED.2012.2216535](https://doi.org/10.1109/TED.2012.2216535).
## Case Study / Example
Use the 2014 and 2015 research as examples? Can go through a process flow like
1. Calibrate to pre-rad
2. use TRIM to esimate vacancies for given fluence
3. Insert acceptor and donor traps with the estimations
4. Assign gaussian energy distribution
5. Add traps into poisson's equation
6. Compare results?
## Conclusion