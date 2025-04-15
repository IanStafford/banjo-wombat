function qns = calculate_qns(x, d_nm)
    % Inputs:
    %   x     - Al mole fraction (0 < x < ~0.35 typically)
    %   d_nm  - AlGaN barrier thickness in nanometers

    % Constants
    q = 1.602e-19;           % Elementary charge [C]
    eps_0 = 8.854e-14;       % Vacuum permittivity [F/cm]
    eps_r = 9.0 + x * 2.6;   % Approximate relative permittivity for AlGaN
    eps = eps_r * eps_0;     % Absolute permittivity [F/cm]
    
    d = d_nm * 1e-7;         % Convert thickness from nm to cm

    % Schottky barrier height from Ambacher model [eV]
    phi_b = 1.3 * x + 0.84;  % [eV]

    % Conduction band offset ΔEc ≈ 0.7x eV
    delta_Ec = 0.7 * x;

    % Energy difference from Fermi level to 2DEG [eV]
    delta_Ef = 0.2;  % Can be fine-tuned or extracted from simulation

    % Net polarization charge density [C/cm^2]
    % Based on linear interpolation of Ambacher data
    sigma_tot = (0.052 * (x / 0.3)) * 1e-4;  % From C/m^2 to C/cm^2

    % Effective band bending
    Vb = delta_Ec - delta_Ef - phi_b;

    % Compute sheet charge density [C/cm^2]
    qns = (eps / d) * Vb + sigma_tot;
end
