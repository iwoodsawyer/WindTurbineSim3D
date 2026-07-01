function [P1, P2, P3, P4] = NM92
% NM92  Defines configuration and geometry data for the NEG-Micon NM92 turbine.
% This script provides the physical and aerodynamic parameters for the 
% Vestas/NEG-Micon NM92/2750 (2.75 MW) wind turbine model.
%
% Outputs:
%   P1 - Aerodynamic constants [rho, kp]
%   P2 - Mechanical/Electrical system parameters [R, Nb, Jb, kb, mt, dt, kt, nu, Jr, dr, kr, Jg, Un, Pn, omgn, If, p]
%   P3 - Blade geometry matrix [3 x Ns+1] (radius, chord, twist)
%   P4 - Nominal operating point [Vn, lambdan, thetan]

% --- 1. Aerodynamic Parameters (P1) ---
rho = 1.25;  % Air density [kg/m^3]
kp  = 0.9;   % Power loss factor [-] (Empirical correction for BEM)
P1  = [rho, kp];

% --- 2. Turbine & Mechanical Parameters (P2) ---

% Rotor Geometry
R  = 46;     % Rotor radius [m] (Larger rotor compared to NM80)
Nb = 3;      % Number of blades [-]

% Blade Structural Properties (Flapwise)
mb  = 9700;  % Individual blade mass [kg]
Jb  = 3.4e6; % Flapwise mass moment of inertia (at blade root) [kg*m^2]
omb = 4.5;   % First flapwise natural frequency [rad/s]
kb  = Jb * omb^2; % Equivalent flapwise stiffness [Nm/rad]

% Tower Structural Properties (Fore-Aft)
mt  = 170000; % Equivalent tower mass [kg]
omt = 2.45;   % Tower first natural frequency [rad/s]
kt  = mt * omt^2; % Equivalent tower stiffness [N/m]
dt  = 2 * 0.01 * sqrt(kt * mt); % Tower damping [N/(m/s)] (1% critical assumed)

% Drivetrain & Transmission
nu   = 71;    % Gearbox transmission ratio [-]
Jr   = Nb * Jb; % Total rotor inertia [kg*m^2]
kr   = 4.9e8;   % Transmission/Main shaft stiffness [Nm/rad]
Jg   = 210;     % Generator inertia (high-speed side) [kg*m^2]
Jtot = (nu^2 * Jg * Jr) / (nu^2 * Jg + Jr); % Equivalent system inertia
dr   = 2 * 0.03 * sqrt(kr * Jtot); % Transmission damping (3% critical assumed)

% Generator Electrical Parameters
Un   = 960;     % Nominal terminal voltage [V]
Pn   = 2.75e6;  % Nominal rated power [W]
omgn = 2*pi*25; % Nominal generator angular velocity [rad/s] (~1500 RPM)
If   = 80;      % Nominal field current [A]
p    = 2;       % Number of pole pairs [-]

P2 = [R Nb Jb kb mt dt kt nu Jr dr kr Jg Un Pn omgn If p];

% --- 3. Blade Geometry (P3) ---
% These vectors define the cross-sectional properties at 12 radial stations.

% r: Radial positions from rotor center to tip [m]
r = [4 8 12 16 20 24 28 32 36 42 44 46];

% c: Local chord length [m]
c = [2.6 3.0 3.2 2.8 2.4 2.1 1.8 1.6 1.3 0.73 0.46 0.05];

% thetat: Local aerodynamic twist angle [degrees]
thetat = [6.695 9.37 9.39 5.42 3.499 2.31 1.281 0.559 -0.07 -1.17 -1.27 0];

% Consistency check
Ns = length(r) - 1;
if any([length(c), length(thetat)] ~= Ns + 1)
    error('Geometry vectors must have identical lengths (Ns+1).');
end

P3 = [r; c; thetat];

% --- 4. Nominal Design Values (P4) ---
Vn      = 11.5; % Rated wind speed [m/s]
lambdan = 9.0;  % Nominal/Optimal Tip Speed Ratio (TSR) [-]
thetan  = -0.3; % Optimal pitch angle for design TSR [degrees]

P4 = [Vn, lambdan, thetan];