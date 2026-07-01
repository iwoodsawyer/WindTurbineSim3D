# 3D Simulink Wind Turbine Model - NEG-Micon NM80/NM92

3D animation model of the **NEG-Micon NM80/NM92** (2.75 MW) wind turbine implemented in MATLAB and Simulink. Uses the aerodynamic model based on the modular framework of WindSim for calculating aerodynamic loads using the **Blade Element Momentum (BEM)** theory.

## Features
- **Vectorized BEM Implementation**: Efficient calculation of lift, drag, and thrust across blade segments.
- **Dynamic Inflow**: Models the time-lag of the wake development using a first-order state-space representation (Dynamic Inflow/Pitt-Peters model).
- **High-Induction Correction**: Includes the Glauert empirical correction for the turbulent wake state.
- **Thickness-Dependent Airfoil Data**: Integrated lookup tables for NACA 63-4xx and FFA-W3 airfoil series across various relative thicknesses (15% to 100%).
- **Simulink Integration**: Level-2 MATLAB S-Function (`Sbem.m`) for seamless inclusion in larger aero-servo-elastic turbine simulations.

## Repository Structure

### Core Aerodynamics
- `aero2.m`: The primary engine. Calculates total axial thrust, flapwise moments, rotor torque, and power coefficients.
- `bem.m`: Residual function used to solve for the induction factor 'a' by balancing Blade Element and Momentum theories.
- `lift.m`, `drag.m`, `mom.m`: Airfoil coefficient estimators that interpolate data based on local angle of attack and blade thickness.

### System Modeling
- `Sbem.m`: A Level-2 S-Function that wraps the BEM logic for Simulink, handling continuous state updates for dynamic induction.
- `wtmodel_init.m`: Initialization script for setting up turbine parameters, constants, and initial operating points.

### Turbine Configuration
- `NM80.m` & `NM92.m`: Configuration files defining the geometry, chord distribution, twist, and mass properties specific to the NM80/NM92 rotor.

### 3D Actors
- `actors3d`: Contains the 3D actors to create the 3D animation model of the NM92 wind turbine.

## Technical Specifications (NM80/NM92)
- **Rotor Diameter**: 80 m / 92m
- **Rated Power**: 2.75 MW
- **Control**: Pitch regulated, variable speed.
- **Airfoils**: Transition from FFA-W3 root sections to NACA 63-4xx tip sections.

## References
- **Aerodynamic Research Group (TU Delft)**: [WindSim](https://www.tudelft.nl/en/ae/organisation/departments/flow-physics-and-technology/wind-energy/research/wind-conditions/windsim)
- Hansen, M. H., Fuglsang, P., Thomsen, K, *Aeroelastic modeling of the NM80 turbine with HAWC*. (Ris&oslash;-I-2017)
- Hansen, M. O. L., *Aerodynamics of Wind Turbines*.