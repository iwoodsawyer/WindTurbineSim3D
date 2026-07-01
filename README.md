# 3D Simulink Wind Turbine Model - NM80/NM92

3D animation model of the **NEG-Micon NM80/NM92** (2.75 MW) wind turbine implemented in MATLAB and Simulink. This model utilizes a modular aerodynamic framework based on [WindSim](https://www.tudelft.nl/en/ae/organisation/departments/flow-physics-and-technology/wind-energy/research/wind-conditions/windsim) for calculating loads based on **Blade Element Momentum (BEM)** theory, integrated with a variable-speed, pitch-regulated controller.

## Features
- **Vectorized BEM Implementation**: Efficiently calculates lift, drag, and thrust across blade segments using optimized matrix operations.
- **Dynamic Inflow**: Models wake development time-lag using a first-order state-space representation (Pitt-Peters model).
- **High-Induction Correction**: Includes the Glauert empirical correction for the turbulent wake state.
- **Thickness-Dependent Airfoil Data**: Integrated lookup tables for NACA 63-4xx and FFA-W3 airfoil series across relative thicknesses (15% to 100%).
- **Advanced Control**: Includes Region 2 (MPPT) torque control and Region 3 gain-scheduled pitch control.
- **3D Visualization**: Real-time 3D animation using Simulink 3D Animation and X3D actors.

## Repository Structure

### Core Aerodynamics
- `aero2.m`: Primary engine calculating axial thrust, flapwise moments, rotor torque, and power.
- `bem.m`: Residual function used to solve for the induction factor 'a'.
- `lift.m`, `drag.m`, `mom.m`: Airfoil coefficient estimators (Cl, Cd, Cm) with thickness-based interpolation.
- `Sbem.m`: Level-2 MATLAB S-Function wrapping the BEM logic for Simulink integration.

### System Modeling & Simulation
- **`WindTurbineNM80.mdl`**: The main Simulink block diagram for the wind turbine simulation.
- **`WindTurbineNM80_init.m`**: The primary initialization script. Run this to load parameters and initial conditions before starting the simulation.
- **`V*_init.mat`**: Pre-calculated steady-state initial conditions for various wind speeds (e.g., `V5_init.mat`, `V12_init.mat`).

### Turbine Configuration
- `NM80.m`: Configuration for the 80m rotor diameter variant.
- `NM92.m`: Configuration for the 92m rotor diameter variant.

### 3D Visualization
- `actors3d/`: Contains X3D geometry files (`NM92_Blade1.x3d`, `NM92_Tower.x3d`, etc.) and the `NM92setup.m` script for configuring the 3D environment.

## Getting Started
1. Open MATLAB and navigate to the project directory.
2. Run `WindTurbineNM80_init.m` to load the turbine parameters into the workspace.
3. Open `WindTurbineNM80.mdl` in Simulink.
4. Press **Run** to start the simulation and view the 3D animation.

## Technical Specifications (NM80/NM92)
- **Rotor Diameter**: 80 m / 92 m
- **Rated Power**: 2.75 MW
- **Control Strategy**: Variable speed (Region 2) and Pitch regulated (Region 3).
- **Generator**: 4-pole, 690V, 1140 RPM nominal.

## References
- **Aerodynamic Research Group (TU Delft)**: [WindSim](https://www.tudelft.nl/en/ae/organisation/departments/flow-physics-and-technology/wind-energy/research/wind-conditions/windsim)
- Hansen, M. H., et al., *Aeroelastic modeling of the NM80 turbine with HAWC*. (Ris&oslash;-I-2017)
- Hansen, M. O. L., *Aerodynamics of Wind Turbines*.
