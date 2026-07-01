function [P1, P2, P3, P4] = NM80
% NM80  Defines configuration and geometry data for the NEG-Micon NM80 turbine.
% This script provides the physical and aerodynamic parameters for the 
% Vestas/NEG-Micon NM80/2750 (2.75 MW) wind turbine model.
%
% Outputs:
%   P1 - Aerodynamic constants [rho, kp]
%   P2 - Mechanical/Electrical system parameters [R, Nb, Jb, kb, mt, dt, kt, nu, Jr, dr, kr, Jg, Un, Pn, omgn, If, p]
%   P3 - Blade geometry matrix [4 x Ns+1] (radius, chord, twist, thickness)
%   P4 - Nominal operating point [Vn, lambdan, thetan]

% --- 1. Aerodynamic Parameters (P1) ---
rho = 1.25;  % Air density [kg/m^3]
kp  = 0.81;  % Power loss factor [-] (Empirical correction for BEM simplifications)
P1  = [rho, kp];

% --- 2. Turbine & Mechanical Parameters (P2) ---

% Rotor Geometry
R  = 40.04;  % Rotor radius [m]
Nb = 3;      % Number of blades [-]

% Blade Structural Properties (Flapwise)
mb  = 9590;  % Individual blade mass [kg]
Jb  = 2e6;   % Flapwise mass moment of inertia (at blade root) [kg*m^2]
omb = 6;     % First flapwise natural frequency [rad/s]
kb  = Jb * omb^2; % Equivalent flapwise stiffness [Nm/rad]

% Tower Structural Properties (Fore-Aft)
mt  = 150000; % Equivalent tower mass (Top mass + 1/4 tower mass) [kg]
omt = 2.8;    % Tower first natural frequency [rad/s]
kt  = mt * omt^2; % Equivalent tower stiffness [N/m]
dt  = 2 * 0.01 * sqrt(kt * mt); % Tower damping [N/(m/s)] (Assumes 1% critical damping)

% Drivetrain & Transmission
nu   = 66.12; % Gearbox transmission ratio [-]
Jr   = Nb * Jb; % Total rotor inertia [kg*m^2]
kr   = 4.9e8;   % Transmission/Main shaft stiffness [Nm/rad]
Jg   = 244;     % Generator inertia (on high-speed side) [kg*m^2]
Jtot = (nu^2 * Jg * Jr) / (nu^2 * Jg + Jr); % Equivalent system inertia
dr   = 2 * 0.03 * sqrt(kr * Jtot); % Transmission damping (Assumes 3% critical damping)

% Generator Electrical Parameters
Un   = 690;     % Nominal terminal voltage (Line-to-Line) [V]
Pn   = 2.75e6;  % Nominal rated power [W]
omgn = 2*pi*19; % Nominal generator angular velocity [rad/s] (~1140 RPM)
If   = 80;      % Nominal field current [A]
p    = 2;       % Number of pole pairs [-]

P2 = [R Nb Jb kb mt dt kt nu Jr dr kr Jg Un Pn omgn If p];

% --- 3. Blade Geometry (P3) ---
% These vectors define the cross-sectional properties at 23 radial stations.

% r: Radial positions from rotor center to tip [m]
r = [1.24 3.12 5.24 7.24 9.24 11.24 13.24 15.24 17.24 19.24 20.44 23.24 ...
     25.24 27.24 29.24 31.24 33.24 35.24 37.24 38.24 39.24 39.64 40.04];

% c: Local chord length at each station [m]
c = [1.24 2.48 2.65 2.81 2.98 3.14 3.17 2.99 2.79 2.58 2.46 2.21 ...
     2.06 1.92 1.80 1.68 1.55 1.41 1.18 0.98 0.62 0.48 0.07];

% thetat: Local aerodynamic twist angle [degrees]
thetat = [0 5.52 8.60 13.84 14.65 13.27 10.15 6.94 5.05 3.91 3.45 2.68 ...
          2.13 1.50 1.13 0.77 0.29 -0.24 -0.42 0.31 1.04 1.12 1.20];

% th: Local relative thickness [% of chord]
th = [99.99 96.41 80.53 65.08 51.67 40.30 32.53 28.40 25.62 23.77 22.86 20.99 ...
      20.03 19.40 19.03 18.79 18.60 18.39 17.95 17.39 16.33 15.70 14.84];

% Consistency check
Ns = length(r) - 1;
if any([length(c), length(thetat), length(th)] ~= Ns + 1)
    error('Geometry vectors must have identical lengths (Ns+1).');
end

P3 = [r; c; thetat; th];

% --- 4. Nominal Design Values (P4) ---
Vn      = 9.5;  % Rated wind speed for design analysis [m/s]
lambdan = 7.6;  % Nominal/Optimal Tip Speed Ratio (TSR) [-]
thetan  = 0.1;  % Optimal pitch angle for design TSR [degrees]

P4 = [Vn, lambdan, thetan];