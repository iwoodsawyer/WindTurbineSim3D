% WTMODEL_INIT  Initialization script for the NM80 Wind Turbine Model.
% This script sets up the environmental constants, turbine geometry, 
% and control parameters (Torque/Pitch) for the Simulink simulation.

%% 1. Load Turbine Parameters
% Load data for the NEG-Micon NM80 turbine. 
% P1: Aero, P2: Turbine, P3: Blade Geometry, P4: Nominal Values
[P1, P2, P3, P4] = NM80;

% Extract key constants for convenience
rho     = P1(1);      % Air density [kg/m^3]
R       = P2(1);      % Rotor radius [m]
nu      = P2(8);      % Gearbox transmission ratio [-]
Pn      = P2(14);     % Nominal generator power [W]
omgn    = P2(15);     % Nominal generator shaft angular velocity [rad/s]
Vn      = P4(1);      % Nominal wind speed [m/s]
lambdan = P4(2);      % Nominal tip speed ratio [-]
thetan  = P4(3);      % Nominal blade pitch angle [degrees]

%% 2. Power and Torque Control Parameters
% Define the power coefficient (Cp) and operating points
Cp = 0.44; 

% Generator speed operating points (on the high-speed shaft side)
omgA = 0.5 * omgn - (0.1 * nu); % Cut-in speed
omgB = 0.8 * omgn;              % Start of optimal TSR tracking
omgC = omgn - (0.1 * nu);       % Start of transition to rated power
omgD = 0.98*omgn;                     % Intermediate point
omgE = omgn;                    % Rated generator speed

% Kopt: Optimal torque coefficient for Region 2 (Maximum Power Point Tracking)
% Kopt = (0.5 * rho * pi * R^5 * Cp) / (lambda_opt^3 * nu^3)
Kopt = (pi * rho * Cp * R^5) / (2 * lambdan^3 * nu^3);

% Generator torque at specific operating points
MB = Kopt * omgB^2;             % Torque at end of Region 1
MC = Kopt * omgC^2;             % Torque at start of Region 2.5
ME = Pn / omgE;                 % Rated torque (Region 3)

% Store parameters in array
Pc = [omgA omgB omgC omgD omgE MB MC ME Kopt];

%% 3. Torque Look-up Table Generation
% Create a mapping between generator speed (Lomg) and target torque (Ltorque)
Lomg = 0:0.1:2*omgn;
Ltorque = zeros(1, length(Lomg));

for k = 1:length(Lomg)
    speed = Lomg(k);
    if speed < omgA
        % Region 1: Below cut-in (No torque)
        Ltorque(k) = 0;
    elseif speed >= omgA && speed < omgB
        % Region 1.5: Linear ramp up to optimal curve
        Ltorque(k) = (speed - omgA) / (omgB - omgA) * MB;
    elseif speed >= omgB && speed < omgC
        % Region 2: Optimal TSR tracking (K*omega^2)
        Ltorque(k) = Kopt * speed^2;
    elseif speed >= omgC && speed < omgE
        % Region 2.5: Transition to rated power
        Ltorque(k) = MC + (speed - omgC) / (omgE - omgC) * (ME - MC);
    else
        % Region 3: Rated power (Constant torque)
        Ltorque(k) = ME;
    end
end

%% 4. Pitch Controller Data
% Mapping for pitch sensitivity (Gain Scheduling)
Ptheta = [0 1 2 5 10 15 20 30]; % Pitch angles
Kp     = -[1.50 1.10 0.95 0.75 0.60 0.40 0.30 0.25]; % Proportional gains
Ki     = 0.5; % Integral weight

%% 5. Simulation Initial Conditions
V0 = 5; % Initial wind speed [m/s]

% Load steady-state initial condition file if it exists
if exist(['V' num2str(V0) '_init.mat'], 'file')
    load(['V' num2str(V0) '_init.mat']);
else
    warning(['Initial condition file V' num2str(V0) '_init.mat not found. Using defaults.']);
end

% Consolidation of controller parameters for the Simulink block
control_params = [omgA omgB omgC omgD omgE MB MC ME Kopt];

disp('NM80 Wind Turbine Model Initialized Successfully.');