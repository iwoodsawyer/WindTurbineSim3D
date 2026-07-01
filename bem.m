function Cdaxd = bem(a, V, theta, betad, omr, xd, P1, P2, P3)
% BEM Residual function for the Blade Element Momentum (BEM) method.
% This function calculates the difference (residual) between the thrust 
% coefficient derived from Blade Element Theory and Momentum Theory. 
% It is typically solved iteratively (e.g., using 'fzero') to find the 
% equilibrium induction factor 'a'.
%
% Inputs:
%   a      - Axial induction factor [-]
%   V      - Undisturbed wind speed [m/s]
%   theta  - Pitch angle [degrees]
%   betad  - Flap velocity [rad/s]
%   omr    - Rotor angular velocity [rad/s]
%   xd     - Tower top velocity [m/s]
%   P1,P2,P3 - Aerodynamic, turbine, and blade geometry parameters
%
% Output:
%   Cdaxd  - Difference in thrust coefficient (BEM - Momentum) [-]

% 1. Calculate thrust coefficient (Cdax) using the Blade Element Method
% This accounts for local airfoil lift/drag and blade geometry.
[~, ~, ~, ~, Cdax, ~] = aero2(a, V, theta, betad, omr, xd, P1, P2, P3);

% 2. Calculate thrust coefficient (Cdax2) using Momentum Theory
% The calculation depends on whether the turbine is in the normal operating
% state or the turbulent wake state (high induction).
if (a > 0.5 && a < 1.62)
  % High Induction State: Momentum theory breaks down (predicted Cdax > 1).
  % An empirical relationship (Glauert correction) is used to model 
  % the heavily loaded rotor.
  Cdax2 = 1.49 / (1.99 - a);
else
  % Normal Operating State: Standard 1D Momentum Theory.
  % Cdax = 4 * a * (1 - a). 
  % 'abs' is used to maintain stability in various flow conditions.
  Cdax2 = 4 * a * abs(1 - a);
end

% 3. Calculate the residual
% At the correct induction factor 'a', Cdaxd should be zero.
Cdaxd = Cdax - Cdax2;