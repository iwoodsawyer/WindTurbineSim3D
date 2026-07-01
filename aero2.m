function [Dax, Mbeta, Mr, P, Cdax, Cp] = aero2(a, V, theta, betad, omr, xd, P1, P2, P3)
% AERO2 Calculates aerodynamic loads and performance of a wind turbine rotor.
% This is a vectorized version of the blade element method for efficiency.
%
% Inputs:
%   a      - Induction factor [-]
%   V      - Undisturbed wind speed [m/s]
%   theta  - Pitch angle [degrees]
%   betad  - Flap velocity [rad/s]
%   omr    - Rotor angular velocity [rad/s]
%   xd     - Tower top velocity [m/s]
%   P1     - [rho; kp] (Air density [kg/m^3], loss factor [-])
%   P2     - [R; Nb] (Rotor radius [m], number of blades [-])
%   P3     - Blade geometry matrix [4 x N] (r, chord, twist, thickness)
%
% Outputs:
%   Dax    - Total axial thrust [N]
%   Mbeta  - Flapwise bending moment [Nm]
%   Mr     - Rotor torque [Nm]
%   P      - Mechanical power [W]
%   Cdax   - Thrust coefficient [-]
%   Cp     - Power coefficient [-]

% Extract constants and parameters
rho = P1(1);      % Air density
kp  = P1(2);      % Aerodynamic loss factor (Prandtl)
R   = P2(1);      % Rotor radius
Nb  = P2(2);      % Number of blades
Ns  = length(P3) - 1; % Number of radial segments

% Extract blade geometry vectors
r      = P3(1,:); % Radial positions
c      = P3(2,:); % Chord lengths
thetat = P3(3,:); % Local twist angles
th     = P3(4,:); % Local relative thicknesses

% Interpolate geometry to segment midpoints
ri      = (r(1:Ns) + r(2:Ns+1)) / 2;
ci      = (c(1:Ns) + c(2:Ns+1)) / 2;
thi     = (th(1:Ns) + th(2:Ns+1)) / 2;
thetati = (thetat(1:Ns) + thetat(2:Ns+1)) / 2;
dr      = r(2:Ns+1) - r(1:Ns);

% Calculate local flow conditions
% Vp: Velocity component perpendicular to the rotor plane
Vp    = V * (1 - a) .* ones(1, Ns) - betad .* ri - xd .* ones(1, Ns);
% Vt: Velocity component tangential to the rotor plane
Vt    = omr * ri;
W     = sqrt(Vp.^2 + Vt.^2);      % Resultant relative velocity
phi   = atan(Vp ./ Vt);           % Flow angle
alpha = 180/pi .* phi - (theta .* ones(1, Ns) + thetati); % Angle of attack

% Determine aerodynamic coefficients and elemental forces
Cl = lift(alpha, thi);            % Lift coefficient
dL = Cl .* 0.5 * rho .* W.^2 .* ci .* dr; % Elemental lift

Cd = drag(alpha, thi);            % Drag coefficient
dD = Cd .* 0.5 * rho .* W.^2 .* ci .* dr; % Elemental drag

% Projected forces onto rotor coordinates
% dDax: Elemental axial force (Thrust)
dDax   = Nb * (dL .* cos(phi) + dD .* sin(phi));
% dMbeta: Elemental flapwise moment contribution
dMbeta = ri .* (dL .* cos(phi) + dD .* sin(phi));
% dMr: Elemental rotor torque contribution
dMr    = Nb * ri .* (kp .* dL .* sin(phi) - dD .* cos(phi));

% Integrate over the blade length (Sum of segments)
Dax    = sum(dDax);
Mbeta  = sum(dMbeta);
Mr     = sum(dMr);

% Calculate non-dimensional coefficients and total power
Cdax = Dax / (0.5 * rho * pi * R^2 * V^2); % Thrust coefficient
P    = omr * Mr;                           % Mechanical power
Cp   = P / (0.5 * rho * pi * R^2 * V^3);   % Power coefficient