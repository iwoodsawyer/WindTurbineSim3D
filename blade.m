function [Pb1, Pb2, Pb3, Pb4, Pb5, Pb6] = blade
% BLADE  Detailed structural properties of the NM80 rotor blade.
% This function defines the radial distribution of mass and stiffness for the 
% NEG-Micon NM80 blade, including the hub and spacer sections.
%
% Outputs:
%   Pb1 - Radial positions [m]
%   Pb2 - Cumulative mass (from station to tip) [kg]
%   Pb3 - Edgewise (Lead-Lag) bending stiffness (EI_yy) [Nm^2]
%   Pb4 - Flapwise bending stiffness (EI_xx) [Nm^2]
%   Pb5 - Torsional stiffness (GJ) [Nm^2]
%   Pb6 - Mass per unit length (m') [kg/m]

% --- Pb1: Radial stations [m] ---
% Includes hub (0.0 - 1.03m), spacer (1.03 - 1.24m), and aerodynamic blade.
Pb1 = [
    0.00; 1.031; 1.032; 1.239; 1.24; % Hub and Spacer
    3.12; 5.24; 7.24; 9.24; 11.24;   % Inner Blade
    13.24; 15.24; 17.24; 19.24; 20.44; % Mid Blade
    23.24; 25.24; 27.24; 29.24; 31.24; % Outer Blade
    33.24; 35.24; 37.24; 38.24; 39.24; % Tip region
    39.64; 40.04 ]; % Blade Tip

% --- Pb2: Cumulative mass [kg] ---
% Represents the total mass from the current radial position to the tip.
% Note: The total mass of one blade assembly is ~17,732 kg.
Pb2 = [
    17732.12; 17732.02; 17732.02; 9628.59; 9589.45;
    7683.80; 6587.08; 5858.38; 5290.21; 4767.71;
    4240.81; 3716.11; 3212.30; 2731.60; 2457.03;
    1859.50; 1464.60; 1113.13; 816.11; 564.20;
    361.35; 211.85; 98.98; 52.72; 14.27;
    3.79; 0 ];

% --- Pb3: Edgewise (Lead-Lag) Stiffness [Nm^2] ---
% High values (2e13) at the start approximate a rigid hub/connection.
Pb3 = [
    20.979e12; 20.979e12; 20.979e12; 20.979e12; 7.3656e9;
    5.9767e9; 3.5836e9; 2.7403e9; 2.0707e9; 2.3436e9;
    1.9715e9; 1.7484e9; 1.4384e9; 1.1408e9; 0.9870e9;
    0.7130e9; 0.6002e9; 0.4514e9; 0.3670e9; 0.2554e9;
    0.1339e9; 63.115e6; 26.536e6; 15.252e6; 3.894e6;
    1.947e6; 124 ];

% --- Pb4: Flapwise Stiffness [Nm^2] ---
% Defines the flexibility in the direction of the wind thrust.
Pb4 = [
    20.979e12; 20.979e12; 20.979e12; 20.979e12; 5.7380e9;
    4.7988e9; 2.7621e9; 1.5996e9; 0.9105e9; 0.6278e9;
    0.4408e9; 0.3088e9; 0.2167e9; 0.1562e9; 0.1274e9;
    78.026e6; 56.358e6; 37.013e6; 24.831e6; 16.461e6;
    8.0816e6; 3.7944e6; 1.5903e6; 851.89e3; 113.46e3;
    56.822e3; 93 ];

% --- Pb5: Torsional Stiffness [Nm^2] ---
% Resistance to twisting along the radial axis.
Pb5 = [
    1.5984e12; 1.5984e12; 1.5984e12; 1.5984e12; 2.2227e9;
    1.8050e9; 1.0430e9; 0.6672e9; 0.2267e9; 0.1698e9;
    0.1046e9; 74.720e6; 48.192e6; 35.294e6; 29.998e6;
    20.074e6; 14.866e6; 10.944e6; 8.7447e6; 6.6300e6;
    3.6231e6; 1.8793e6; 934.21e3; 617.20e3; 110.91e3;
    110.91e3; 110.91e3 ];

% --- Pb6: Mass distribution [kg/m] ---
% Linear mass density at each station.
Pb6 = [
    10000; 10000; 10000; 10000; 2071.12; % Hub/Spacer sections
    941.41; 535.44; 352.77; 339.05; 374.85;
    390.11; 337.02; 278.46; 228.51; 196.10;
    145.73; 117.77; 86.63; 64.19; 47.77;
    30.41; 18.18; 10.19; 5.93; 1.94;
    0.60; 0.0008 ];