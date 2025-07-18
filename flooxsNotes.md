# Model Files
## Masterfile
The masterfile sets constants, sources all the materials required for a deck, defines the thermal and electrical characteristics for the device, loads the models, establishes the interface charge, and gives a function to take an initial guess for the simulator.
___
**Setting constants:**
- Boltzmanns constant ($\frac{J}{K} \text{ and } eV$)
- Indivisible charge
- Thermal voltage offset (Operating temp and room temp)
- Permittivity of free space
- Permittivity of GaN
- Plancks constant
___
**Sourcing material files:**
- GaN
- AlGaN
- SiC
- AlN
- Metal (gate material)
- Insulator (Contains all dielectrics)
___
**Thermal Domain**
Temp is set constant to 300K
___
**Electrical Domain**
Sets "solutions" for 
- DevPsi (Device potential)
- Qfp (Hole quasi fermi level)
- Qfn (Electron quasi fermi level)
___
**Poisson:**
Load the poisson file, then solve Poisson's equation for different materials:
- GaN
- AlGaN
- Metal
- Nitride
- Oxide
- HighK
___
**Continuity:** 
Load the continuity equation file, then solve the continuity equations for holes and electrons different materials
- GaN
- AlGaN
- AlN
- SiC

These previous two run to give a baseline for the device in equilibrium?
___
**Interface Charge:**
Since we aren't able to simulate the heterostructure directly, we add a sheet charge at the GaN-AlGaN interface
___
**Initial Conditions:**
This is the Initialize function we run to start the device.
Passes in thermal voltage variable defined earlier and defines Temp at 300K throughout the entire device. Then we pull in density of states, affinity, and band gap for every material. For every material we also compute absolute value of doping with a built in safety so we can't divide by or take the logarithm of 0. Then we for each region decide whether the doping is positive or negative then use the following equations where $N_{c},N_{v}$ are the density of states for conduction and valence band, $V_{T}$ is thermal offset, $E_{g}$ is bandgap, and $\chi$ is the electron affinity for the material in question. These equations give the initial quasi-Fermi potentials for holes, electrons for each material
$$\text{Mater}_{N}=-V_{T}*\ln\left(\frac{|\text{Doping}|}{N_{c}}\right)+\chi$$
$$\text{Mater}_{P}=V_{T}*\ln\left(\frac{|\text{Doping}|}{N_{v}}\right)+\chi+E_{g}$$
For other materials without doping such as metals and insulators, the script just initializes them. They don't require any complicated guesses because metals are defined by their work function and insulators have no charge at equilibrium

After everything is initialized, we add it all into "DevPsi" (Device potential) which gives us the total device potential. This is the "initial guess" hence why it takes a while to converge if doping is crazy. We also include DonorTraps and Impurities which we set to 0 for the initial guess. I'm assuming this is where we will add our spatial trap and impurity distributions when we run TRIM.

## Poisson
The Poisson file creates a bunch of functions to call for Poisson's equation optimized for different situations. Below are the equations. Each function first calls in some global variables to the math, the damping value shows the max allowable shift in the device potential. It is set to the thermal voltage at room temperature.

**Standard Poisson:**
$$-\frac{\epsilon_{0} \epsilon_{r} \nabla \psi}{q}+\text{Doping}-\text{Electrons}-\text{Holes}=0$$
**Poisson for Traps:**
Adds traps for donors, subtracts for acceptors.

**Poisson for Insulators:**
Lacks any bulk charge terms (No mobile charge in insulators).

## Continuity
Split into two halves for electrons and holes. We add a new field for the conduction and valence band edges, as well as the electron concentration? The equations that define those fields are as follows
$$\frac{dn}{dt}+\mu_{e}(n+10^{10})\nabla E_{Fn}=0$$ Which is just the continuity equation with a minimum value for electron concentration so we don't divide by 0. When we solve for the negative quasi-Fermi level we do so with this equation, using different values of Qfn to ensure the continuity equation results to 0 everywhere in the material/device.


# Material Files

## AlGaN
AlGaN is used in the heterostructure which forms the channel. The polarization mismatch it has with GaN forms a positive charge at the interface, which attracts electrons, forming the 2DEG. If we increase the Al content, we form a stronger polarization which creates a larger sheet charge, changing threshold voltages. If we make it thinner, we of course reduce the size of the 2DEG but get better control (Lower voltages required for I/O). Generally, AlGaN is undoped to reduce impurity scattering which is a problem for high frequency current.
___
**Properties:**
All properties for AlGaN depend on a AlN ratio being set as spatial variable. Some properties are listed below

- $\epsilon_{r}=9.0$
- $\nu=0.352$
- $\chi=2.02275*\left(1-\text{AlN Ratio}\right)+1.07725$
- $E_g=6.13(\text{AlN Ratio})+E_{g\text{ GaN}}*\left(1-\text{AlN Ratio}\right) -(\text{AlN Ratio})\left(1-\text{AlN Ratio}\right)$
- $E_{v}=-\chi-E_{g}+\psi_{Dev}$
- $E_{v}=-\chi+\psi_{Dev}$
- $m_e=0.4(\text{AlN Ratio})+0.20\left(1-\text{AlN Ratio}\right)$
- $m_h=1.5(\text{AlN Ratio})+3.53\left(1-\text{AlN Ratio}\right)$
- $N_c \approx 2.509 \times 10^{19} \cdot \left( m_e \right)^{3/2} \cdot T^{3/2}$
- $N_v \approx 2.509 \times 10^{19} \cdot \left( m_h \right)^{3/2} \cdot T^{3/2}$
___
**Low field mobility model:**
This low field mobility model defines the electron mobility of the AlGaN during the region where drift velocity is linear with electric field. My initial research says that our model is based on the "Caughey-Thomas" mobility model.

- $\mu_{\text{min}} = 312.1$
- $\mu_{\text{max}} = 1401.3$
- $\alpha = 0.74$ (Doping dependence)
- $\beta_1 = -6.51$ (Temperature dependence for minimum mobility)
- $\beta_2 = -2.31$ (Temperature dependence for middle range)
- $\beta_3 = 7.07$ (Temperature dependence for reference doping?)
- $\beta_4 = -0.86$ (Temperature dependence for doping)
- $N_{\text{ref}} = 1 \times 10^{17}$ (Reference doping?)

Intermediate expressions:
- $A_1 = \mu_{\text{min}} \cdot \left( \frac{T}{300} \right)^{\beta_1}$
- $A_2 = (\mu_{\text{max}} - \mu_{\text{min}}) \cdot \left( \frac{T}{300} \right)^{\beta_2}$
- $A_3 = N_{\text{ref}} \cdot \left( \frac{T}{300} \right)^{\beta_3}$
- $A_4 = \left| \frac{N_D + 1}{A_3} \right|$
- $A_5 = \alpha \cdot \left( \frac{T}{300} \right)^{\beta_4}$
- $A_6 = A_4^{A_5}$
- $A_7 = 1 + A_6$
- $\mu_{\text{low-field}} = A_1 + \frac{A_2}{A_7}$
---
**High field mobility model:**
This high-field mobility model defines the electron mobility in AlGaN when the electric field is strong enough to cause velocity saturation and non-linear transport. This expression is based on the Farahmand model, which extends the drift-diffusion framework to account for velocity-field nonlinearity by introducing empirically fit parameters that govern the transition from low-field to high-field behavior.

- $\alpha = 6.9502$ (Nonlinear weighting factor for high-field)
- $n_1 = 7.8138$ (Exponent for first field term)
- $n_2 = 0.7897$ (Exponent for second field term)
- $E_{c\text{mob}} = 245{,}579.4$ (Critical field for mobility model?)
- $v_{\text{sat}} = 2.02 \times 10^7$ (Saturation velocity)
- $|\nabla \psi| = \sqrt{|\nabla \psi|^2 + 1.0 \times 10^2}$ 
- $E_{\text{norm}} = \frac{|\nabla \psi|}{E_{c\text{mob}}}$

Intermediate expressions:
- $A_1 = E_{\text{norm}}^{n_1 - 1}$
- $A_2 = E_{\text{norm}}^{n_2}$
- $\text{Numerator} = \mu_{\text{low-field}} + \frac{v_{\text{sat}} \cdot A_1}{E_{c\text{mob}}}$
- $\text{Denominator} = 1 + \alpha \cdot A_2 + A_1 \cdot E_{\text{norm}}$
- $\mu_{\text{high-field}} = \frac{\mu_{\text{low-field}} + \frac{v_{\text{sat}} \cdot A_1}{E_{c\text{mob}}}}{1 + \alpha \cdot A_2 + A_1 \cdot E_{\text{norm}}}$

## AlN
Aluminum Nitride is an alternative to AlGaN with an even higher bandgap, resulting in an even stronger polarization. It results in an even stronger polarization charge and therefore larger 2DEG. Our simulations do not rely on AlN but it was in the deck so I had chatGPT copy the values in anyway.

The values below are initialized based on literature values and empirical fits (e.g. Farahmand, *IEEE TED*, 2001).

---
 **Properties:**
 
- $E = 3.31 \times 10^{12}$ 
- $\nu = 0.25$ 
- $\varepsilon_r = 8.5$
- $\chi = 1.2121$ 
- $E_g = 6.13 + \frac{1.80 \times 10^{-3} \cdot T^2}{1462 + T} - \frac{1.80 \times 10^{-3} \cdot 300^2}{1462 + 300}$ (Bandgap with temperature correction)  
- $E_v = -\chi - E_g + \psi_{Dev}$  
- $E_c = -\chi + \psi_{Dev}$  
- $N_c = 2.3 \times 10^{18} \cdot \left( \frac{T^3}{2.7 \times 10^7} \right)^{1/2}$  
- $N_v = 4.6 \times 10^{19} \cdot \left( \frac{T^3}{2.7 \times 10^7} \right)^{1/2}$  
---
**Low-field mobility model:**
This model defines the **electron mobility in AlN** when drift velocity is linearly proportional to the electric field. It uses a temperature- and doping-dependent variant of the **Caughey-Thomas model**, calibrated to Farahmand et al.'s 2001 formulation.

- $\mu_{\text{min}} = 297.8$  
- $\mu_{\text{max}} = 683.8$  
- $\alpha = 1.16$ (Doping dependence)  
- $\beta_1 = -1.82$ (Temp dependence of min mobility)  
- $\beta_2 = -3.43$ (Temp dependence of range)  
- $\beta_3 = 3.78$ (Temp dependence of $N_{\text{ref}}$)  
- $\beta_4 = 0.86$ (Temp dependence of alpha)  
- $N_{\text{ref}} = 1 \times 10^{17}$  

Intermediate expressions:

- $A_1 = \mu_{\text{min}} \cdot \left( \frac{T}{300} \right)^{\beta_1}$  
- $A_2 = (\mu_{\text{max}} - \mu_{\text{min}}) \cdot \left( \frac{T}{300} \right)^{\beta_2}$  
- $A_3 = N_{\text{ref}} \cdot \left( \frac{T}{300} \right)^{\beta_3}$  
- $A_4 = \left| \frac{N_D + 1}{A_3} \right|$  
- $A_5 = \alpha \cdot \left( \frac{T}{300} \right)^{\beta_4}$  
- $A_6 = A_4^{A_5}$  
- $A_7 = 1 + A_6$  
- $\mu_{\text{low-field}} = A_1 + \frac{A_2}{A_7}$  
---
**High-field mobility model**:
This high-field model captures velocity saturation effects in AlN when subjected to large electric fields. It is based on a Farahmand-type non-linear transport model and is built to smoothly transition from low-field mobility to a field-dependent mobility that includes saturation.

- $\alpha = 8.7253$ (High-field weighting factor)  
- $n_1 = 17.3681$ (Exponent for first nonlinearity)  
- $n_2 = 0.8554$ (Exponent for second nonlinearity)  
- $E_{c\text{mob}} = 447{,}033.9$ (Critical electric field)  
- $v_{\text{sat}} = 2.167 \times 10^7$ (Saturation velocity)  
- $|\nabla \psi| = \sqrt{|\nabla \psi|^2 + 1.0 \times 10^2}$  
- $E_{\text{norm}} = \frac{|\nabla \psi|}{E_{c\text{mob}}}$  

Intermediate expressions:

- $A_1 = E_{\text{norm}}^{n_1 - 1}$  
- $A_2 = E_{\text{norm}}^{n_2}$  
- $\mu_{\text{high-field}} = \frac{\mu_{\text{low-field}} + \frac{v_{\text{sat}} \cdot A_1}{E_{c\text{mob}}}}{1 + \alpha \cdot A_2 + A_1 \cdot E_{\text{norm}}}$  
---
**Additional Properties:**

- $\mu_{p} = 14.0$ (Hole mobility, cm²/V·s)  
- $k = 2.85$ (Thermal conductivity, W/cm·K)  
- $C_p = 2.584$ (Heat capacity, J/g·K)  

Temperature dynamics equation:
$$C_p \cdot \frac{\partial T}{\partial t} - k \cdot \nabla T - q \cdot \mu_n \cdot n \cdot |\nabla \psi|^2 = 0$$
___
## GaN
Gallium Nitride (GaN) is the foundational material in many wide bandgap electronic devices, including HEMTs, LEDs, and power transistors. It offers a high breakdown field, strong thermal stability, and excellent carrier transport properties. GaN serves as the channel material, and the wide bandgap materials are placed "on top" of them where they form the 2DEG.

In TCAD simulations, GaN models require accurate treatment of both low- and high-field mobility to simulate drift-diffusion transport under a wide range of conditions. This implementation includes both temperature-dependent band structure and mobility behavior derived from literature (e.g., Farahmand and Eric Heller).

---
 **Properties:**
 
- $E = 3.9 \times 10^{12} - 1.6 \times 10^{11}(T - 300)$ (Young’s modulus, dyn/cm²)  
- $\nu = 0.352$ (Poisson’s ratio)  
- $\varepsilon_r = 8.9$ (Relative permittivity)  
- $\chi = 3.1$ (Electron affinity)  
- $E_g = 3.51 - \frac{7.7 \times 10^{-4} \cdot T^2}{600 + T}$ (Temperature-dependent bandgap)  
- $E_v = -\chi - E_g + \psi_{Dev}$  
- $E_c = -\chi + \psi_{Dev}$  
- $N_c = 2.3 \times 10^{18} \cdot \sqrt{\frac{T^3}{2.7 \times 10^7}}$  
- $N_v = 4.6 \times 10^{19} \cdot \sqrt{\frac{T^3}{2.7 \times 10^7}}$  

---
 **Low-field mobility model:**
This low-field model defines electron mobility in GaN under linear transport (low electric field). It follows a modified Caughey-Thomas form calibrated to data from Farahmand.

- $\mu_{\text{min}} = 295.0$  
- $\mu_{\text{max}} = 1907$  
- $\alpha = 0.66$  
- $\beta_1 = -1.02$  
- $\beta_2 = -3.84$  
- $\beta_3 = 3.02$  
- $\beta_4 = 0.81$  
- $N_{\text{ref}} = 1 \times 10^{17}$  

Intermediate expressions:

- $G_1 = \mu_{\text{min}} \cdot \left( \frac{T}{300} \right)^{\beta_1}$  
- $G_2 = (\mu_{\text{max}} - \mu_{\text{min}}) \cdot \left( \frac{T}{300} \right)^{\beta_2}$  
- $G_3 = N_{\text{ref}} \cdot \left( \frac{T}{300} \right)^{\beta_3}$  
- $G_4 = \left| \frac{N_D + 1}{G_3} \right|$  
- $G_5 = \alpha \cdot \left( \frac{T}{300} \right)^{\beta_4}$  
- $G_6 = G_4^{G_5}$  
- $G_7 = 1 + G_6$  
- $\mu_{\text{low-field}} = G_1 + \frac{G_2}{G_7}$  
---
**High-field mobility model:**
This model captures velocity saturation behavior in GaN at large electric fields. The expression is based on the Farahmand model using empirical fits for critical field behavior.

- $\alpha = 6.1973$  
- $n_1 = 7.2044$  
- $n_2 = 0.7857$  
- $E_{c\text{mob}} = 220{,}893.6$  
- $v_{\text{sat}} = \frac{2.7 \times 10^7}{1 + 0.8 \cdot \exp(T / 600)}$  
- $|\nabla \psi| = \left| \nabla \psi \cdot y \cdot 10^{-4} \right| + 1$  
- $E_{\text{norm}} = \frac{|\nabla \psi|}{E_{c\text{mob}}}$  

Intermediate expressions:

- $H_1 = |\nabla \psi|^{n_1 - 1}$  
- $H_2 = E_{\text{norm}}^{n_1}$  
- $H_3 = E_{\text{norm}}^{n_2}$  
- $\mu_{\text{high-field}} = \frac{\mu_{\text{low-field}} + \frac{v_{\text{sat}} \cdot H_1}{E_{c\text{mob}}^{n_1}}}{1 + \alpha \cdot H_3 + H_2}$  
___
## Insulators
The insulators are combined into one file. They are more simple to model and don't necessitate their own. These layers are defined with fixed properties since they are non-conductive and not actively involved in charge transport under normal operating conditions.

The following insulator materials are defined: Nitride, Oxide, and High-k dielectric.

---
**Nitride**
Nitride (commonly SiNₓ or similar) is used for passivation and isolation, offering a balance between dielectric constant and stability. Its parameters are:

- $\chi = 0.95$ (Electron affinity)  
- $E_g = 9.0$ (Bandgap)  
- $\varepsilon_r = 6.3$ (Relative permittivity)  
- $E_v = -\chi - E_g + \psi_{Dev}$  
- $E_c = -\chi + \psi_{Dev}$  
- $k = 2.85$ (Thermal conductivity, W/cm·K)  
- $C_p = 2.584$ (Heat capacity, J/g·K)  

Thermal transport equation:  
$$C_p \cdot \frac{\partial T}{\partial t} - k \cdot \nabla T = 0$$
---|Property|Value (approx.)|
|---|---|
|**Bandgap**|~5.0 – 5.3 eV (insulator)|
|**Electron mobility**|~1e-2 – 1 cm²/V·s (very low)|
|**Hole mobility**|~1e-4 – 1e-2 cm²/V·s (very low)|
|**Relative permittivity (εᵣ)**|~7.0 – 7.8|
|**Breakdown field**|~10 MV/cm|
|**Electron affinity**|~2.0 eV (varies with deposition)|

**Oxide**
Oxide (typically SiO₂ or equivalent) is used for insulation and interface control. It has a higher band offset and lower dielectric constant than high-k materials. We don't use it in our simulations except to define High-K.

- $\chi = 2.89$ (Electron affinity)  
- $E_g = 9.3$ (Bandgap)  
- $\varepsilon_r = 3.9$ (Relative permittivity)  
- $E_v = -\chi - E_g + \psi_{Dev}$  
- $E_c = -\chi + \psi_{Dev}$  
- $k = 2.85$  
- $C_p = 2.584$  

Thermal transport equation:  
$$C_p \cdot \frac{\partial T}{\partial t} - k \cdot \nabla T = 0$$
---
**High-K**

- $\chi = 2.89$ (Electron affinity)  
- $E_g = 9.3$ (Bandgap)  
- $\varepsilon_r = 35.0$ (High dielectric constant)  
- $E_v = -\chi - E_g + \psi_{Dev}$  
- $E_c = -\chi + \psi_{Dev}$  

> *Note:* High-k values reuse affinity and bandgap from the Oxide definition

___
## SiC

Silicon Carbide (SiC) is a wide bandgap semiconductor valued for its extremely high thermal conductivity, high breakdown electric field, and chemical robustness. It is widely used in high-power and high-temperature electronic devices such as Schottky diodes and MOSFETs. In heterostructures, SiC is often used as a substrate or buffer layer for GaN-based HEMTs due to its lattice compatibility and superior heat dissipation.

---
 **Properties:**

- $E = 4.50 \times 10^{12}$ (Young’s modulus, dyn/cm²)  
- $\nu = 0.183$ (Poisson’s ratio)  
- $\varepsilon_r = 9.6$ (Relative permittivity)  
- $\chi = 3.0$ (Electron affinity)  
- $E_g = 3.2 - \frac{3.3 \times 10^{-2} \cdot T^2}{1.0 \times 10^5 + T}$ (Temperature-dependent bandgap)  
- $E_v = -\chi - E_g + \psi_{Dev}$  
- $E_c = -\chi + \psi_{Dev}$  
- $N_c = 2.3 \times 10^{18} \cdot \sqrt{\frac{T^3}{2.7 \times 10^7}}$  
- $N_v = 4.6 \times 10^{19} \cdot \sqrt{\frac{T^3}{2.7 \times 10^7}}$  

---
 **Low-field mobility model:**
This model is based on empirical data from Roschke and Schwierz (*IEEE TED*, July 2001). The model includes both temperature and doping dependence, though it does not include velocity saturation behavior from the paper.

- $\mu_{\text{min}} = 40.0$  
- $\mu_{\text{max}} = 950.0$  
- $\alpha = 0.76$ (Doping dependence)  
- $\beta_1 = -2.4$ (Temperature dependence of $\mu_{\text{max}}$)  
- $\beta_2 = -0.5$ (Temperature dependence of $\mu_{\text{min}}$)  
- $N_{\text{ref}} = 2 \times 10^{17}$  

Intermediate expressions:

- $T_{\mu_{\text{max}}} = \mu_{\text{max}} \cdot \left( \frac{T}{300} \right)^{\beta_1}$  
- $T_{\mu_{\text{min}}} = \mu_{\text{min}} \cdot \left( \frac{T}{300} \right)^{\beta_2}$  
- $T_{N_{\text{ref}}} = N_{\text{ref}} \cdot \left( \frac{T}{300} \right)$  
- $D_{\text{rel}} = \left( \frac{N_D + 1}{T_{N_{\text{ref}}}} \right)^{\alpha}$  
- $\mu_{\text{low-field}} = T_{\mu_{\text{min}}} + \frac{T_{\mu_{\text{max}}} - T_{\mu_{\text{min}}}}{1 + D_{\text{rel}}}$  
---
# Research Notes and Goals
Until August 20th, we are trying to model and explain the phenomena that appears in the HEMT devices from MACOM that were irradiated by NASA scientists.

## 6/3/2025
The current goal is to match the fieldplate structure to the experimental data, get TRIM working, quantify the effects on $I_{\text{off}}$ with the gate nitride structure, and a literature review on simulating radiation effects on GaN HEMTs.

**Matching to experimental**
Currently the fieldplate structure with the is close to REF, I need to slightly shift the threshold voltage and reduce the slope of the $V_{GS}\text{ vs. }I_{D}$ curve at $V_{\text{GS}}=10V$ 


**Test Parameters**
These are only for the transistor with no gate nitride.

| $\Phi_B$ | Doping (GaN) | Al Ratio | Interface Charge |                                                                                        Notes                                                                                        |
| :------: | :----------: | :------: | :--------------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|   1.35   |   -5.0e17    |   0.22   |     1.486e13     |                                                                 Threshold voltage close. Slope still slightly high                                                                  |
|   1.5    |   -5.0e16    |   0.22   |     1.486e13     |                                                          Current way too high, slope too steep, threshold voltage too high                                                          |
|   1.5    |   -5.0e16    |   0.22   |     1.060e13     |                                              Threshold voltage too low (in magnitude) current in correct realm, slope still too steep.                                              |
|   1.5    |   -5.0e16    |   0.22   |     1.200e13     |                                            Threshold voltage is like exact, but now the slope is too steep and the current is too high.                                             |
|   1.5    |   -5.0e15    |   0.22   |     1.060e13     |                                                                             Same problems as last time                                                                              |
|   1.5    |   -5.0e15    |   0.18   |     1.060e13     |                                                                                   Didn't converge                                                                                   |
|   1.5    |   -5.0e15    |   0.21   |     1.060e13     |                                                         Didn't seem to do as much. Maybe some critical threshold near 0.22?                                                         |
|   1.6    |   -5.0e15    |   0.20   |     1.060e13     |                                                           Didn't do too much again. Going to look for other alternatives                                                            |
|   1.6    |   -5.0e15    |   0.15   |     1.060e13     |                                                                            Started bringing current down                                                                            |
|   1.6    |   -5.0e15    |   0.20   |     1.060e13     | Reduced AlGaN thickness to 12nm. Turnoff way too soon now but current in the right regime. Thinking variation in AlGaN thickness can explain high variation in threshold voltage... |
|   1.6    |   -5.0e15    |   0.20   |     1.060e13     | Reduced AlGaN thickness to 13nm. Turnoff way too soon now but current in the right regime. Thinking variation in AlGaN thickness can explain high variation in threshold voltage... |
|   1.6    |   -5.0e15    |   0.20   |     1.060e13     |      Reduced AlGaN thickness to 14nm. Turnoff almost right but now current too high. Thinking variation in AlGaN thickness can explain high variation in threshold voltage...       |
|   1.6    |   -5.0e14    |   0.20   |     1.060e13     |                                   Keeping 13nm AlGaN. Threshold voltage too High and current too high. want to get doping into reasonable range.                                    |
|   1.6    |   -5.0e14    |   0.25   |     1.060e13     |                                                            Transistor doesnt full turn off now and current way too high.                                                            |
|   1.23   |   -5.0e14    |   0.22   |     1.060e13     |                                                     Threshold voltage perfect. current too high. contact resistance fix it????                                                      |

*Suggestions*
- Wait for contact resistance to show up and change the slope of the curve????
- Ask for help

**Gate Nitride**
Dr. Law proposed that the transistor may have a thin layer of SiN between the AlGaN and the gate, I implemented this but the transistor was a 2 for 1 special and behaved like a PMOS and HEMT. So I am trying to sort that out. I've reduced the channel charge to a point where it wont converge any longer. I am going to try thinning out the nitride layer so that the gate field can deplete the channel faster than it can attract holes.

localized field plate to gate and gate to channel

## 6/11/25
We got data from Dr. Anderson and we are trying to model 2 main phenomena now.

**High drain stress during irradiation causes an off-state current change, but not necessarily a threshold voltage shift**

**High gate stress during irradiation causes gate leakage at a certain drain bias**

These two phenomena can explain the behavior in the first round of tested devices. It could potentially be the same phenomena showing up different ways in the measurements. We are trying to explain this phenomenon by importing a lateral gaussian of doping (or really just charge density) to show a current path between the gate and the drain, or the gate and the source. We assume the mechanism of damage is field related, as we see the devices under heavy S-D stress have drain leakage, and we theorize that the devices under heavy gate stress have high gate leakages. More on that later.

Adding a $10^{18}$ doping in a Gaussian distribution to the GaN didn't do too much. Going to mess around with the insulator Poisson and see if I can incorporate charge into the insulator instead of the GaN or the AlGaN.

## 6/12/25
We can create a continuity equation for the SiN potentially and throw some charge in the insulator and potentially create a pseudo-diode model

It would require significant reworking of how FLOOXS handles insulators as we make assumptions about no charge transport in insulators

## 6/18/25 Ideas
Studies show that when Bi impacts on the gate there is a massive threshold voltage shift. This is not good for matching the experimental data, and we can deduce that the ions do not penetrate the whole gate directly. Due to the fields the device experiences under heavy DC bias, the Bi ion likely gets swept away. Maybe to the drain region? Modelling filaments will involve inserting material strips/regions with higher conductivity or traps. It will likely span down into the GaN buffer, or at least we assume so due to TRIM plots. We implement defect characteristics potential. We can interrupt the heterojunction with a spatially confined interface charge. Will learn more about where the current is going soon.

Try putting GaN in the new regions and dope it heavily.

## New idea
What if there is a virtual gate forming from traps caused by the strike path of the heavy ion? The fluences are low but really are of no consequence. We can find a model for vacancies produced by a single ion strike, throw them into a deck and see if the drain-> source field is producing such a virtual gate by flooding the traps with more charge than the gate can repel.





