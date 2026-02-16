# Source Organization — Heavy Ion Current Collapse in AlGaN/GaN HEMTs

---

## HEMT Operation & Fundamentals

- **Ambacher et al. (2000)** 
	- The go-to reference for 2DEG formation from spontaneous and piezoelectric polarization in AlGaN/GaN. Need this to establish the basic channel physics behind the devices we're simulating and irradiating.
    
- **Farahmand et al. (2001)** 
	- Monte Carlo transport parameters for III-nitrides. Useful for backing up the mobility models and velocity-field stuff in our TCAD setup.
    
- **Haziq et al. (2022)** 
	- Review of high-power/high-frequency HEMT applications. Helps motivate why GaN HEMTs matter for aerospace and space environments where radiation hardness is a big deal.
    
- **Talukder et al. (2025)** 
	- Recent comprehensive review covering architectures, reliability, and challenges. Good for framing the intro and showing where the field is at right now.
    

---

## Radiation Effects — Reviews & General

- **Pearton et al. (2015)**
	- Broad review of ionizing radiation damage in GaN devices. Sets up known radiation sensitivities and mechanisms that our work builds on.
    
- **Pearton et al. (2021)** 
	- Updated review that extends into wide and ultra-wide bandgap semiconductors. Good for positioning GaN HEMTs relative to other rad-hard materials and citing more recent trends.
    
- **Fleetwood et al. (2022)**
	- Focused specifically on radiation effects in AlGaN/GaN HEMTs. Probably my most directly relevant review — covers displacement damage, ionization effects, and responses.
    
- **Weaver et al. (2016)** 
	- Covers radiation tolerance of AlGaN/GaN HEMTs more broadly. Helpful for contextualizing before the more recent heavy ion work.
    

---

## SEE & Heavy Ion Effects

- **Kuboyama et al. (2011)**
	- One of the earlier experimental observations of single-event damage from heavy ions in GaN HEMTs. Early experimental work demonstrating permanent heavy ion damage in GaN HEMTs, analogous to effects seen in SiC devices. Good reference for the introduction to establish that heavy ion SEE is a real concern for GaN HEMTs in space applications.
    
- **Onoda et al. (2013)** 
	- Showed enhanced charge collection from single ion strikes. Directly ties into understanding the transient charge dynamics happen during irradiation. Useful for characterising field during heavy ion strikes?
    
- **Islam et al. (2019)** 
	- Heavy ion irradiation effects at off-state bias. Good comparison since our work uses DC-biased irradiation compares on-state vs. off-state responses will strengthen the discussion.
    
- **Zhang et al. (2024)**
	- SEE in enhanced GaN HEMTs under various bias conditions. Recent work I can compare against, especially for how bias state changes the SEE response and trap generation.
    
- **Yu et al. (2026)** 
	- Heavy-ion irradiation response with reduced surface field tech. Super recent useful for showing the cutting edge of mitigation strategies and framing our current collapse findings as motivating those kinds of design improvements.
    

---

## Current Collapse & Trapping

- **Faqir et al. (2010)** 
	- Experimental and numerical analysis of current collapse. Key reference for our methodology since they also combine measurement with simulation to explain collapse mechanisms, which is basically what we're doing too.
    
- **Yu et al. (2013)**
	- Identifies donor-like surface traps as a driver of current collapse. Directly relevant to my trap modeling — gives physical justification for the trap species and energy levels I'm implementing in FLOOXS.
    
- **Sharma et al. (2020)** 
	- Links trapping effects to both leakage and current collapse. Useful for talking about how radiation-induced traps show up in multiple electrical signatures, not just drain current degradation.
    
- **Zou et al. (2023)**
	- Critical review of trap characterization techniques (DLTS, pulsed I-V, etc.). Supports our experimental methodology choices and gives context for interpreting trap-related results.
    
- **Koehler et al. (2016)** 
	- Surface passivation effects on dynamic on-resistance in proton-irradiated HEMTs. Relevant parallel — proton-induced trapping and passivation effects connect to the surface/interface trap mechanisms in my heavy ion work.
    

---

## Simulation & TCAD

- **Liang and Law (1994)** 
	- The original FLOOXS paper. Have to cite this since it's the foundation of my simulation framework.
    
- **Patrick et al. (2014)**
	- Simulation of radiation damage in GaN HEMT structures. Directly relevant predecessor. Used device simulation to model radiation-induced defects in similar structures.
    
- **Patrick et al. (2015)** 
	- simulation of radiation effects in AlGaN/GaN HEMTs. Together with the 2014 paper, these establish the simulation methodology lineage that our TCAD work utilizes
    
- **Zerarka et al. (2017)**
	- TCAD simulation of SETs in normally-OFF GaN transistors after heavy ion radiation. Good modeling comparison. I can contrast their approach and device type with my depletion-mode FLOOXS work.
    
- **Wang et al. (2023)**
	- Recent SET simulation for GaN HEMTs. Handy for benchmarking our simulation approach against contemporary TCAD methods and checking modeling assumptions.
    
- **Singha et al. (2026)** 
	- Numerical analysis of SET in enhancement-mode p-GaN HEMTs. Very recent simulation work positions my FLOOXS-based approach alongside other current numerical efforts in the field.
    
- **Sandeep and Pravin (2025)** 
	- Numerical modelling of GaN HEMTs. General modeling reference that can support our device structure setup and parameter choices. I can't find a copy online though.
    

---

## Misc.

- **Anderson et al.** — Failure mechanisms with 2 MeV protons. Could be relevant if I end up discussing proton vs. heavy ion damage comparisons, but it's not as central as the Bi-ion focused stuff.

