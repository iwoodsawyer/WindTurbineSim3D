function Sbem(block)
% SBEM Level-2 S-function for the Blade Element Momentum (BEM) method.
% This block calculates aerodynamic loads for a wind turbine rotor and 
% models the dynamic induction (dynamic inflow) using a first-order filter.
%
% States:
%   x(1) - Axial induction factor 'a' (Continuous)
%
% Inputs:
%   u(1) - V: Undisturbed wind speed [m/s]
%   u(2) - theta: Pitch angle [deg]
%   u(3) - betad: Flap velocity [rad/s]
%   u(4) - omr: Rotor angular velocity [rad/s]
%   u(5) - xd: Tower top velocity [m/s]
%
% Outputs:
%   y(1) - Mbeta: Flapwise bending moment [Nm]
%   y(2) - Mr: Rotor torque [Nm]
%   y(3) - Dax: Axial thrust [N]
%   y(4) - P: Mechanical power [W]
%   y(5) - Cdax: Thrust coefficient [-]
%   y(6) - Cp: Power coefficient [-]
%   y(7) - a: Current induction factor [-]
%
% Parameters:
%   P0: Initial condition operating point
%   P1: Aerodynamic constants [rho, kp]
%   P2: Turbine constants [R, Nb]
%   P3: Blade geometry matrix
%   P4: Optional/Auxiliary parameters

setup(block);

% -------------------------------------------------------------------------
function setup(block)
    % Register number of parameters
    block.NumDialogPrms = 5; % P0, P1, P2, P3, P4

    % Register number of ports
    block.NumInputPorts  = 1;
    block.NumOutputPorts = 1;

    % Setup Input Port: Vector of 5 signals
    block.InputPort(1).Dimensions        = 5;
    block.InputPort(1).DirectFeedthrough = true;
    block.InputPort(1).Complexity        = 'Real';

    % Setup Output Port: Vector of 7 signals
    block.OutputPort(1).Dimensions       = 7;
    block.OutputPort(1).Complexity       = 'Real';

    % Register continuous states
    block.NumContStates = 1;

    % Set sample time (Inherited)
    block.SampleTimes = [-1 0];

    % Register methods
    block.RegBlockMethod('InitializeConditions', @InitializeConditions);
    block.RegBlockMethod('Outputs',              @Outputs);
    block.RegBlockMethod('Derivatives',          @Derivatives);
    block.RegBlockMethod('Terminate',            @Terminate);

% -------------------------------------------------------------------------
function InitializeConditions(block)
    % Extract parameters for the initial steady-state solve
    P0 = block.DialogPrm(1).Data;
    P1 = block.DialogPrm(2).Data;
    P2 = block.DialogPrm(3).Data;
    P3 = block.DialogPrm(4).Data;

    % Solver options for initial induction factor search
    options = optimset('Display','off','TolFun',1e-3,'TolX',1e-3);
    
    % Find initial 'a' such that BEM matches Momentum Theory at t=0
    % Operating point: P0(9)=V, P0(8)=theta, P0(2)=betad, P0(5)=omr, P0(4)=xd
    a_init = fzero('bem', [-0.5 2], options, ...
                   P0(9), P0(8), P0(2), P0(5), P0(4), P1, P2, P3);
               
    block.ContStates.Data = a_init;

% -------------------------------------------------------------------------
function Outputs(block)
    % Extract inputs and current state
    u = block.InputPort(1).Data;
    a = block.ContStates.Data;
    
    % Extract parameters
    P1 = block.DialogPrm(2).Data;
    P2 = block.DialogPrm(3).Data;
    P3 = block.DialogPrm(4).Data;

    % Calculate aerodynamic loads using Blade Element Method
    % aero2 returns: [Dax, Mbeta, Mr, P, Cdax, Cp]
    [Dax, Mbeta, Mr, P, Cdax, Cp] = aero2(a, u(1), u(2), u(3), u(4), u(5), P1, P2, P3);

    % Map results to output vector
    block.OutputPort(1).Data = [Mbeta; Mr; Dax; P; Cdax; Cp; a];

% -------------------------------------------------------------------------
function Derivatives(block)
    % Extract inputs and current state
    u = block.InputPort(1).Data;
    a = block.ContStates.Data;
    
    % Extract parameters
    P1 = block.DialogPrm(2).Data;
    P2 = block.DialogPrm(3).Data;
    P3 = block.DialogPrm(4).Data;

    % Get current Thrust Coefficient (Cdax)
    [~, ~, ~, ~, Cdax, ~] = aero2(a, u(1), u(2), u(3), u(4), u(5), P1, P2, P3);

    % Dynamic Inflow Calculation (Time constant tau = 1.4s)
    % This models the delay in the wake development.
    tau = 1.4;
    if Cdax <= 1.0
        % Normal Momentum Theory range
        a_target = 0.5 - 0.5 * sqrt(1 - Cdax);
    else
        % Turbulent Wake State (Glauert correction range)
        a_target = 1.99 - 1.49 / Cdax;
    end
    
    % First order lag: da/dt = (a_target - a) / tau
    block.Derivatives.Data = (a_target - a) / tau;

% -------------------------------------------------------------------------
function Terminate(block)
    % No specific cleanup required