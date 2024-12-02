within Dynawo.Electrical.Controls.Machines.Governors.Standard.Generic;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GovCt2 "Governor type GovCT2"

  // Parameters
  parameter Types.PerUnit aSetPu "Acceleration limiter setpoint in pu/s (base omegaNom), typical value = 10" annotation(
    Dialog(tab = "Acceleration limiter"));
  parameter Types.AngularVelocityPu DeltaOmegaDbPu "Speed governor deadband in pu (base omegaNom), typical value = 0" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.AngularVelocityPu DeltaOmegaMaxPu "Maximum value for speed error signal in pu (base omegaNom), typical value = 1" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.AngularVelocityPu DeltaOmegaMinPu "Minimum value for speed error signal in pu (base omegaNom), typical value = -1" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.Time DeltaT "Correction factor in s (to adapt the unit of the acceleration limiter gain from pu/s to pu), typical value = 1" annotation(
    Dialog(tab = "Acceleration limiter"));
  parameter Types.PerUnit Dm "Speed sensitivity coefficient (damping), typical value = 0 (deactivated)" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.Frequency fLim10Hz "Frequency threshold 10 in Hz, typical value = 0" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim1Hz "Frequency threshold 1 in Hz, typical value = 49" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim2Hz "Frequency threshold 2 in Hz, typical value = 8" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim3Hz "Frequency threshold 3 in Hz, typical value = 7" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim4Hz "Frequency threshold 4 in Hz, typical value = 6" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim5Hz "Frequency threshold 5 in Hz, typical value = 5" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim6Hz "Frequency threshold 6 in Hz, typical value = 4" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim7Hz "Frequency threshold 7 in Hz, typical value = 3" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim8Hz "Frequency threshold 8 in Hz, typical value = 2" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim9Hz "Frequency threshold 9 in Hz, typical value = 1" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.PerUnit KA "Acceleration limiter gain, typical value = 10" annotation(
    Dialog(tab = "Acceleration limiter"));
  parameter Types.PerUnit KDGov "Governor derivative gain, typical value = 0" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.PerUnit KIGov "Governor integral gain, typical value = 0.45" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.PerUnit KILoad "Load limiter integral gain for PI controller, typical value = 1" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.PerUnit KIMw "Power controller gain, typical value = 0 (deactivated)" annotation(
    Dialog(tab = "Supervisory load controller"));
  parameter Types.PerUnit KPGov "Governor proportional gain, typical value = 4" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.PerUnit KPLoad "Load limiter proportional gain for PI controller, typical value = 1" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.PerUnit KTurb "Turbine gain, typical value = 1.9168" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.ActivePowerPu PBaseMw "Base power in [MW, MVA], typical value = PNomTurb" annotation(
    Dialog(tab = "General"));
  parameter Types.ActivePowerPu PGenBaseMw "Base power for measured electrical power in [MW, MVA], typical value = SystemBase.SnRef" annotation(
    Dialog(tab = "General"));
  parameter Types.ActivePowerPu PLdRefPu "Load limiter reference value in pu (base PBaseMw), typical value = 1" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.ActivePowerPu PLim10Pu "Power limit 10 in pu (base PBaseMw), typical value = 0.8325" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim1Pu "Power limit 1 in pu (base PBaseMw), typical value = 0.8325" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim2Pu "Power limit 2 in pu (base PBaseMw), typical value = 0.8325" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim3Pu "Power limit 3 in pu (base PBaseMw), typical value = 0.8325" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim4Pu "Power limit 4 in pu (base PBaseMw), typical value = 0.8325" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim5Pu "Power limit 5 in pu (base PBaseMw), typical value = 0.8325" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim6Pu "Power limit 6 in pu (base PBaseMw), typical value = 0.8325" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim7Pu "Power limit 7 in pu (base PBaseMw), typical value = 0.8325" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim8Pu "Power limit 8 in pu (base PBaseMw), typical value = 0.8325" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim9Pu "Power Limit 9 in pu (base PBaseMw), typical value = 0.8325" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.PerUnit PRatePu "Ramp rate for frequency-dependent power limit in pu/s (base PBaseMw*KTurb), typical value = 0.017" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.PerUnit RClosePu "Minimum valve closing rate in pu/s (base PBaseMw*KTurb), typical value = -99" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.PerUnit RDownPu "Maximum rate of load limit decrease in pu/s (base PBaseMw*KTurb), typical value = -99" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.PerUnit ROpenPu "Maximum valve opening rate in pu/s (base PBaseMw*KTurb), typical value = 99" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.PerUnit RDroop "Permanent droop, typical value = 0.05" annotation(
    Dialog(tab = "Main control path"));
  parameter Integer RSelectInt "Feedback signal for droop: (0) Isochronous, (1) Electrical power, (2) Valve Stroke, (3) Governor Output" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.PerUnit RUpPu "Maximum rate of load limit increase in pu/s (base PBaseMw*KTurb), typical value = 99" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.Time tActuator "Actuator time constant in s, typical value = 0.4" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.Time tA "Acceleration limiter time constant in s, typical value = 1" annotation(
    Dialog(tab = "Acceleration limiter"));
  parameter Types.Time tB "Turbine lag time constant in s, typical value = 0.1" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.Time tC "Turbine lead time constant in s, typical value = 0" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.Time tDGov "Governor derivative controller time constant in s, typical value = 1" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.Time tDRatelim "Ramp rate limter derivative time constant in s, typical value = 0.001";
  parameter Types.Time tEngine "Transport time delay for diesel engine in s, typical value = 0" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.Time tFLoad "Load limiter time constant in s, typical value = 3" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.Time tLastValue "Fast delay block time constant in s, typical value = 1e-9" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.Time tPElec "Electrical power transducer time constant in s, typical value = 2.5" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.Time tSA "Temperature detection lead time constant in s, typical value = 1e-6" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.Time tSB "Temperature detection lag time constant in s, typical value = 50" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.PerUnit ValveMaxPu "Maximum valve position limit in pu (base PBaseMw*KTurb), typical value = 1" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.PerUnit ValveMinPu "Minimum valve position limit in pu (base PBaseMw*KTurb), typical value = 0.175" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.PerUnit WFnlPu "No load fuel flow in pu (base PBaseMw*KTurb), typical value = 0.187" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Boolean WFSpdBool "Switch for fuel source characteristic, typical value = false" annotation(
    Dialog(tab = "Turbine/engine"));

  // Inputs
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Rotor speed in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-333, -21}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-333, 100}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Rotor speed set-point in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-333, 9}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-333, 181}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PGenPu(start = PGen0Pu) "Generated electrical active power in pu (base PGenBaseMw (system base)) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-333, -181}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-343, -161}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PMwSetPu(start = PGen0Pu * PGenBaseMw / PBaseMw) "Supervisory power controller set-point / automatic generation control (base PBaseMw) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-333, -141}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-344, -80}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Power set-point in pu (base PBaseMw/RDroop) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-333, -87}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-346, 10}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));

  // Output
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power output in pu (base PBaseMw) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {330, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {350, 2}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));

  // Blocks
  Modelica.Blocks.Math.Add add(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-244, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addAsetOmega(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-68, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addCfeWfnl(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {256, -6}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add3 addDeltaOmega(k1 = -1, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-172, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addFsra annotation(
    Placement(visible = true, transformation(origin = {26, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addGovController annotation(
    Placement(visible = true, transformation(origin = {8, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addLoadLimitController annotation(
    Placement(visible = true, transformation(origin = {-38, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPDmPTurbine(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {276, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPmwsetPefilt(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-238, -148}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add addSupervisoryLoadController annotation(
    Placement(visible = true, transformation(origin = {-216, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addtLimtExm(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-64, 120}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addWFnlPldRef annotation(
    Placement(visible = true, transformation(origin = {-142, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addWfnlValvemax(k1 = +1) annotation(
    Placement(visible = true, transformation(origin = {146, -38}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constASet(k = aSetPu) annotation(
    Placement(visible = true, transformation(origin = {-178, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constDmFactor(k = initDmFactor) annotation(
    Placement(visible = true, transformation(origin = {198, 198}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant constIsochronous(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-200, -160}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constOne(k = 1) annotation(
    Placement(visible = true, transformation(origin = {240, -178}, extent = {{9, -9}, {-9, 9}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constPLdRef(k = PLdRefPu) annotation(
    Placement(visible = true, transformation(origin = {-298, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constRClose(k = RClosePu) annotation(
    Placement(visible = true, transformation(origin = {214, -114}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constROpen(k = ROpenPu) annotation(
    Placement(visible = true, transformation(origin = {214, -58}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant constRSelect(k = RSelectInt) annotation(
    Placement(visible = true, transformation(origin = {-114, -160}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constValveMin(k = ValveMinPu) annotation(
    Placement(visible = true, transformation(origin = {130, -112}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constWFnl(k = WFnlPu) annotation(
    Placement(visible = true, transformation(origin = {-176, 200}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constWFnl2(k = WFnlPu) annotation(
    Placement(visible = true, transformation(origin = {305, -37}, extent = {{-13, -13}, {13, 13}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant constWFnl3(k = WFnlPu) annotation(
    Placement(visible = true, transformation(origin = {182, 6}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanConstant constWFSpd(k = WFSpdBool) annotation(
    Placement(visible = true, transformation(origin = {272, -176}, extent = {{8, -8}, {-8, 8}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.DeadZone deadZoneDeltaOmegaDb(uMax = DeltaOmegaDbPu) annotation(
    Placement(visible = true, transformation(origin = {-132, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay delaytEngine(delayTime = tEngine) annotation(
    Placement(visible = true, transformation(origin = {256, 24}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.Derivative derivativetA(T = tA, k = 1) annotation(
    Placement(visible = true, transformation(origin = {-130, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivativeKDGovTDGov(T = tDGov, initType = Modelica.Blocks.Types.Init.InitialState, k = KDGov) annotation(
    Placement(visible = true, transformation(origin = {-50, -128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze firstOrdertActuatorRatelim(T = tActuator, UseRateLim = true, Y0 = initValvePu, y(fixed = true)) annotation(
    Placement(visible = true, transformation(origin = {214, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Power expOmegaToTheDm(N = initDmExponent, NInteger = false) annotation(
    Placement(visible = true, transformation(origin = {204, 152}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrdertFLoad(T = tFLoad, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = initTexPu) annotation(
    Placement(visible = true, transformation(origin = {34, 114}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrdertPElec(T = tPElec, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = PGen0Pu * PGenBaseMw / PBaseMw) annotation(
    Placement(visible = true, transformation(origin = {-250, -182}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainChangeBaseIn(k = PGenBaseMw / PBaseMw) annotation(
    Placement(visible = true, transformation(origin = {-296, -182}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainfNom(k(unit = "") = SystemBase.fNom) annotation(
    Placement(visible = true, transformation(origin = {138, 66}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gainKADeltat(k(unit = "") = KA * DeltaT) annotation(
    Placement(visible = true, transformation(origin = {-20, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKPGov(k = KPGov) annotation(
    Placement(visible = true, transformation(origin = {-48, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKPLoad(k = KPLoad) annotation(
    Placement(visible = true, transformation(origin = {-102, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKTurb(k = KTurb) annotation(
    Placement(visible = true, transformation(origin = {256, 74}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gainOneOverKTurb(k = 1 / KTurb) annotation(
    Placement(visible = true, transformation(origin = {-236, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainOneOverKTurb2(k = 1 / KTurb) annotation(
    Placement(visible = true, transformation(origin = {140, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gainR(k = RDroop) annotation(
    Placement(visible = true, transformation(origin = {-172, -124}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.Integrator integratorKIGov(initType = Modelica.Blocks.Types.Init.InitialState, k = KIGov, y_start = initValvePu) annotation(
    Placement(visible = true, transformation(origin = {-50, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorKILoad(initType = Modelica.Blocks.Types.Init.InitialOutput, k = KILoad, y_start = initIntegratorKILoadPu) annotation(
    Placement(visible = true, transformation(origin = {-104, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedIntegrator integratorKIMw(K = KIMw, YMax = 1.1 * RDroop, YMin = -1.1 * RDroop) annotation(
    Placement(visible = true, transformation(origin = {-238, -120}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.FirstOrder lastValue(T = tLastValue, y(fixed = true), y_start = initValvePu) annotation(
    Placement(visible = true, transformation(origin = {124, -152}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limitDeltaOmegaMinMax(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = DeltaOmegaMaxPu, uMin = DeltaOmegaMinPu) annotation(
    Placement(visible = true, transformation(origin = {-100, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limitFsrt(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = 1.0, uMin = -9999) annotation(
    Placement(visible = true, transformation(origin = {28, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter limitValveMaxValveMin(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy, strict = false) annotation(
    Placement(visible = true, transformation(origin = {130, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min minLowValueSelect annotation(
    Placement(visible = true, transformation(origin = {72, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min minLowValueSelect2 annotation(
    Placement(visible = true, transformation(origin = {69, -87}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {-172, -158}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression omegaPu2(y = omegaPu) annotation(
    Placement(visible = true, transformation(origin = {157, 89}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression omegaPu3(y = omegaPu) annotation(
    Placement(visible = true, transformation(origin = {307, -159}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression omegaPu4(y = omegaPu) annotation(
    Placement(visible = true, transformation(origin = {107, 215}, extent = {{-13, -9}, {13, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Product prodCfe annotation(
    Placement(visible = true, transformation(origin = {252, -54}, extent = {{8, -8}, {-8, 8}}, rotation = -90)));
  Modelica.Blocks.Math.Product prodOmegaCfe annotation(
    Placement(visible = true, transformation(origin = {184, 114}, extent = {{-8, -8}, {8, 8}}, rotation = -180)));
  Modelica.Blocks.Math.Product prodOmegaDm annotation(
    Placement(visible = true, transformation(origin = {236, 202}, extent = {{8, -8}, {-8, 8}}, rotation = 180)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter rateLimitFsrt(Falling = RDownPu, Rising = RUpPu, Td = tDRatelim, strict = false, y_start = initFsrtPu, y(start = initFsrtPu)) annotation(
    Placement(visible = true, transformation(origin = {-4, 40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter rateLimitPRate(Rising = PRatePu, Td = tDRatelim, y_start = (ValveMaxPu - WFnlPu) * KTurb, y(start = (ValveMaxPu - WFnlPu) * KTurb)) annotation(
    Placement(visible = true, transformation(origin = {138, 14}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switchWFSpd annotation(
    Placement(visible = true, transformation(origin = {272, -126}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Tables.CombiTable1Ds tablePLimFromf(extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = PLimFromfPoints, tableOnFile = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {138, 38}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunctCtB(a = {tB, 1}, b = {tC, 1}, x_start = {initPMechNoLossPu}, y_start = initPMechNoLossPu) annotation(
    Placement(visible = true, transformation(origin = {254, 106}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunctSAtSB(a = {tSB, 1}, b = {tSA, 1}, x_start = {initTexPu}, y_start = initTexPu) annotation(
    Placement(visible = true, transformation(origin = {80, 114}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ActivePowerPu PGen0Pu "Initial value of generated active power in pu, e.g. Pm0Pu * PBaseMw / PGenBaseMw, but calculated by INIT model in dynawo (base PGenBaseMw, generator convention)";
  parameter Types.ActivePowerPu Pm0Pu "Initial value of mechanical power in pu (base PBaseMw)";

  final parameter Types.ActivePowerPu PLimFromfPoints[:, :] = [fLim10Hz - 0.000001, PLim10Pu; fLim10Hz, PLim10Pu; fLim9Hz, PLim9Pu; fLim8Hz, PLim8Pu; fLim7Hz, PLim7Pu; fLim6Hz, PLim6Pu; fLim5Hz, PLim5Pu; fLim4Hz, PLim4Pu; fLim3Hz, PLim3Pu; fLim2Hz, PLim2Pu; fLim1Hz, PLim1Pu; fLim1Hz + 0.000001, (ValveMaxPu - WFnlPu) * KTurb; fLim1Hz + 1, (ValveMaxPu - WFnlPu) * KTurb] "Pair of points for frequency-dependent active power limit piecewise linear curve [u1,y1; u2,y2;...] (above fLim1Hz, jump to power associated with ValveMaxPu)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  final parameter Types.ActivePowerPu PRef0Pu = RDroop * (if RSelectInt == 0 then 0 elseif RSelectInt == 1 then PGen0Pu*PGenBaseMw/PBaseMw else initValvePu) "Initial value of reference power in pu (base PBaseMw/RDroop)";

protected
  // Initialization helpers
  final parameter Types.PerUnit initCfePu = WFnlPu + (if KTurb > 0 then initPMechNoLossPu / KTurb else 0) "Initial value of cfe in pu (base PBaseMw*KTurb)";
  final parameter Types.PerUnit initDmExponent = if Dm < 0 then Dm else 0 "Exponent for speed sensitivity path";
  final parameter Types.PerUnit initDmFactor = if Dm >= 0 then Dm else 0 "Multiplication factor for speed sensitivity path";
  final parameter Types.PerUnit initFsrtPu = (PLdRefPu / KTurb + WFnlPu - initTexPu) * KPLoad + initIntegratorKILoadPu "Initial value of cfe in fsrt in pu (base PBaseMw*KTurb)";
  final parameter Types.PerUnit initIntegratorKILoadPu = 1 "Initial value of load controller integrator in pu (base PBaseMw*KTurb)";
  final parameter Types.PerUnit initPMechNoLossPu = if Dm > 0.0 then Pm0Pu + SystemBase.omega0Pu * Dm else Pm0Pu "Initial value of mechanical power without losses in pu (base PBaseMw)";
  final parameter Types.PerUnit initTexPu = initCfePu * (if Dm < 0 then SystemBase.omega0Pu ^ Dm else 1) "Initial value of Tex (exhaust temperature) in pu (base PBaseMw*KTurb)";
  final parameter Types.PerUnit initValvePu = if WFSpdBool then initCfePu / SystemBase.omega0Pu else initCfePu "Initial value of valve position in pu (base PBaseMw*KTurb)";

equation
  connect(constPLdRef.y, gainOneOverKTurb.u) annotation(
    Line(points = {{-287, 144}, {-248, 144}}, color = {0, 0, 127}));
  connect(gainOneOverKTurb.y, addWFnlPldRef.u2) annotation(
    Line(points = {{-225, 144}, {-154, 144}}, color = {0, 0, 127}));
  connect(addPDmPTurbine.y, PmPu) annotation(
    Line(points = {{287, 132}, {330, 132}}, color = {0, 0, 127}));
  connect(transferFunctCtB.y, addPDmPTurbine.u2) annotation(
    Line(points = {{254, 117}, {254, 126}, {264, 126}}, color = {0, 0, 127}));
  connect(gainKTurb.y, transferFunctCtB.u) annotation(
    Line(points = {{256, 85}, {256, 89.5}, {254, 89.5}, {254, 94}}, color = {0, 0, 127}));
  connect(delaytEngine.y, gainKTurb.u) annotation(
    Line(points = {{256, 35}, {256, 62}}, color = {0, 0, 127}));
  connect(addCfeWfnl.y, delaytEngine.u) annotation(
    Line(points = {{256, 5}, {256, 12}}, color = {0, 0, 127}));
  connect(prodCfe.y, addCfeWfnl.u2) annotation(
    Line(points = {{252, -45.2}, {252, -25.7}, {250, -25.7}, {250, -18.2}}, color = {0, 0, 127}));
  connect(switchWFSpd.y, prodCfe.u1) annotation(
    Line(points = {{272, -115}, {272, -73.5}, {257, -73.5}, {257, -64}}, color = {0, 0, 127}));
  connect(constOne.y, switchWFSpd.u3) annotation(
    Line(points = {{240, -168.1}, {240, -147.2}, {263.5, -147.2}, {263.5, -139.2}, {263, -139.2}}, color = {0, 0, 127}));
  connect(constWFSpd.y, switchWFSpd.u2) annotation(
    Line(points = {{272, -167.2}, {272, -138.4}}, color = {255, 0, 255}));
  connect(constValveMin.y, limitValveMaxValveMin.limit2) annotation(
    Line(points = {{123.4, -112}, {109.4, -112}, {109.4, -96}, {117.4, -96}}, color = {0, 0, 127}));
  connect(gainOneOverKTurb2.y, addWfnlValvemax.u1) annotation(
    Line(points = {{140, -21}, {140, -26}}, color = {0, 0, 127}));
  connect(addCfeWfnl.u1, constWFnl2.y) annotation(
    Line(points = {{262, -18}, {262, -37}, {291, -37}}, color = {0, 0, 127}));
  connect(gainfNom.y, tablePLimFromf.u) annotation(
    Line(points = {{138, 55}, {138.5, 55}, {138.5, 50}, {138, 50}}, color = {0, 0, 127}));
  connect(omegaPu3.y, switchWFSpd.u1) annotation(
    Line(points = {{293, -159}, {282, -159}, {282, -138}, {279.7, -138}}, color = {0, 0, 127}));
  connect(omegaPu2.y, gainfNom.u) annotation(
    Line(points = {{142.7, 89}, {138, 89}, {138, 78}}, color = {0, 0, 127}));
  connect(minLowValueSelect.y, minLowValueSelect2.u1) annotation(
    Line(points = {{83, -22}, {86.5, -22}, {86.5, -72}, {49.25, -72}, {49.25, -84}, {53.625, -84}, {53.625, -82}, {58, -82}}, color = {0, 0, 127}));
  connect(minLowValueSelect2.y, limitValveMaxValveMin.u) annotation(
    Line(points = {{78.9, -87}, {100.9, -87}, {100.9, -89}, {118.9, -89}}, color = {0, 0, 127}));
  connect(deadZoneDeltaOmegaDb.y, limitDeltaOmegaMinMax.u) annotation(
    Line(points = {{-121, -92}, {-113, -92}}, color = {0, 0, 127}));
  connect(limitDeltaOmegaMinMax.y, integratorKIGov.u) annotation(
    Line(points = {{-89, -92}, {-63, -92}}, color = {0, 0, 127}));
  connect(limitDeltaOmegaMinMax.y, gainKPGov.u) annotation(
    Line(points = {{-89, -92}, {-75, -92}, {-75, -54}, {-61, -54}}, color = {0, 0, 127}));
  connect(gainKPGov.y, addGovController.u1) annotation(
    Line(points = {{-37, -54}, {-11, -54}, {-11, -84}, {-4, -84}}, color = {0, 0, 127}));
  connect(integratorKIGov.y, addGovController.u2) annotation(
    Line(points = {{-39, -92}, {-4, -92}}, color = {0, 0, 127}));
  connect(addGovController.y, minLowValueSelect2.u2) annotation(
    Line(points = {{19, -92}, {58, -92}}, color = {0, 0, 127}));
  connect(addDeltaOmega.y, deadZoneDeltaOmegaDb.u) annotation(
    Line(points = {{-161, -92}, {-145, -92}}, color = {0, 0, 127}));
  connect(addSupervisoryLoadController.y, addDeltaOmega.u2) annotation(
    Line(points = {{-205, -92}, {-184, -92}}, color = {0, 0, 127}));
  connect(PRefPu, addSupervisoryLoadController.u1) annotation(
    Line(points = {{-333, -87}, {-229, -87}}, color = {0, 0, 127}));
  connect(integratorKIMw.y, addSupervisoryLoadController.u2) annotation(
    Line(points = {{-238, -109}, {-238, -98}, {-228, -98}}, color = {0, 0, 127}));
  connect(addPmwsetPefilt.y, integratorKIMw.u) annotation(
    Line(points = {{-238, -137}, {-238, -132}}, color = {0, 0, 127}));
  connect(firstOrdertPElec.y, addPmwsetPefilt.u1) annotation(
    Line(points = {{-239, -182}, {-218, -182}, {-218, -165}, {-232, -165}, {-232, -160}}, color = {0, 0, 127}));
  connect(gainR.y, addDeltaOmega.u3) annotation(
    Line(points = {{-172, -112}, {-172, -108}, {-192, -108}, {-192, -100}, {-184, -100}}, color = {0, 0, 127}));
  connect(addFsra.y, minLowValueSelect.u2) annotation(
    Line(points = {{37, -18}, {50, -18}, {50, -28}, {60, -28}}, color = {0, 0, 127}));
  connect(gainKADeltat.y, addFsra.u1) annotation(
    Line(points = {{-9, -12}, {14, -12}}, color = {0, 0, 127}));
  connect(addAsetOmega.y, gainKADeltat.u) annotation(
    Line(points = {{-56, -12}, {-32, -12}}, color = {0, 0, 127}));
  connect(constASet.y, addAsetOmega.u1) annotation(
    Line(points = {{-167, 4}, {-94, 4}, {-94, -6}, {-80, -6}}, color = {0, 0, 127}));
  connect(limitFsrt.y, minLowValueSelect.u1) annotation(
    Line(points = {{39, 40}, {54, 40}, {54, -16}, {60, -16}}, color = {0, 0, 127}));
  connect(integratorKILoad.y, addLoadLimitController.u2) annotation(
    Line(points = {{-93, 34}, {-50, 34}}, color = {0, 0, 127}));
  connect(gainKPLoad.y, addLoadLimitController.u1) annotation(
    Line(points = {{-91, 70}, {-60, 70}, {-60, 46}, {-50, 46}}, color = {0, 0, 127}));
  connect(addWFnlPldRef.u1, constWFnl.y) annotation(
    Line(points = {{-154, 156}, {-176, 156}, {-176, 189}}, color = {0, 0, 127}));
  connect(addtLimtExm.y, gainKPLoad.u) annotation(
    Line(points = {{-75, 120}, {-132, 120}, {-132, 70}, {-114, 70}}, color = {0, 0, 127}));
  connect(addtLimtExm.y, integratorKILoad.u) annotation(
    Line(points = {{-75, 120}, {-132, 120}, {-132, 34}, {-116, 34}}, color = {0, 0, 127}));
  connect(addtLimtExm.u2, firstOrdertFLoad.y) annotation(
    Line(points = {{-52, 114}, {23, 114}}, color = {0, 0, 127}));
  connect(addWFnlPldRef.y, addtLimtExm.u1) annotation(
    Line(points = {{-131, 150}, {-44, 150}, {-44, 126}, {-52, 126}}, color = {0, 0, 127}));
  connect(prodOmegaDm.y, addPDmPTurbine.u1) annotation(
    Line(points = {{245, 202}, {248, 202}, {248, 138}, {264, 138}}, color = {0, 0, 127}));
  connect(omegaPu4.y, prodOmegaDm.u2) annotation(
    Line(points = {{121, 215}, {214, 215}, {214, 207}, {226, 207}}, color = {0, 0, 127}));
  connect(prodOmegaCfe.u1, prodCfe.y) annotation(
    Line(points = {{194, 110}, {230, 110}, {230, -40}, {252, -40}, {252, -46}}, color = {0, 0, 127}));
  connect(PMwSetPu, addPmwsetPefilt.u2) annotation(
    Line(points = {{-333, -141}, {-286, -141}, {-286, -164}, {-244, -164}, {-244, -160}}, color = {0, 0, 127}));
  connect(omegaPu, add.u2) annotation(
    Line(points = {{-334, -21}, {-292, -21}, {-292, -24}, {-256, -24}}, color = {0, 0, 127}));
  connect(add.y, addDeltaOmega.u1) annotation(
    Line(points = {{-233, -18}, {-194, -18}, {-194, -84}, {-184, -84}}, color = {0, 0, 127}));
  connect(addWfnlValvemax.y, limitValveMaxValveMin.limit1) annotation(
    Line(points = {{146, -48}, {146, -66}, {108, -66}, {108, -80}, {118, -80}}, color = {0, 0, 127}));
  connect(addWfnlValvemax.u2, constWFnl3.y) annotation(
    Line(points = {{152, -26}, {152, -16.5}, {164, -16.5}, {164, -15.75}, {180, -15.75}, {180, -13.375}, {182, -13.375}, {182, -5}}, color = {0, 0, 127}));
  connect(tablePLimFromf.y[1], rateLimitPRate.u) annotation(
    Line(points = {{138, 28}, {138, 24}}, color = {0, 0, 127}));
  connect(rateLimitPRate.y, gainOneOverKTurb2.u) annotation(
    Line(points = {{138, 5}, {138, 3.5}, {140, 3.5}, {140, 2}}, color = {0, 0, 127}));
  connect(addLoadLimitController.y, rateLimitFsrt.u) annotation(
    Line(points = {{-26, 40}, {-14, 40}}, color = {0, 0, 127}));
  connect(rateLimitFsrt.y, limitFsrt.u) annotation(
    Line(points = {{4, 40}, {16, 40}}, color = {0, 0, 127}));
  connect(transferFunctSAtSB.u, prodOmegaCfe.y) annotation(
    Line(points = {{92, 114}, {175, 114}}, color = {0, 0, 127}));
  connect(firstOrdertFLoad.u, transferFunctSAtSB.y) annotation(
    Line(points = {{46, 114}, {69, 114}}, color = {0, 0, 127}));
  connect(firstOrdertActuatorRatelim.y, prodCfe.u2) annotation(
    Line(points = {{225, -88}, {248, -88}, {248, -64}}, color = {0, 0, 127}));
  connect(constROpen.y, firstOrdertActuatorRatelim.dyMax) annotation(
    Line(points = {{207.4, -58}, {181.4, -58}, {181.4, -81}, {201.4, -81}}, color = {0, 0, 127}));
  connect(limitValveMaxValveMin.y, firstOrdertActuatorRatelim.u) annotation(
    Line(points = {{141, -88}, {202, -88}}, color = {0, 0, 127}));
  connect(constRClose.y, firstOrdertActuatorRatelim.dyMin) annotation(
    Line(points = {{207.4, -114}, {182.4, -114}, {182.4, -94}, {202.4, -94}}, color = {0, 0, 127}));
  connect(lastValue.y, addFsra.u2) annotation(
    Line(points = {{114, -152}, {104, -152}, {104, -180}, {30, -180}, {30, -36}, {4, -36}, {4, -24}, {14, -24}}, color = {0, 0, 127}));
  connect(limitValveMaxValveMin.y, lastValue.u) annotation(
    Line(points = {{142, -88}, {150, -88}, {150, -152}, {136, -152}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u1) annotation(
    Line(points = {{-333, 9}, {-280, 9}, {-280, -12}, {-256, -12}}, color = {0, 0, 127}));
  connect(constRSelect.y, multiSwitch.f) annotation(
    Line(points = {{-124, -160}, {-142, -160}, {-142, -146}, {-184, -146}, {-184, -158}, {-180, -158}}, color = {255, 127, 0}));
  connect(constIsochronous.y, multiSwitch.u[1]) annotation(
    Line(points = {{-200, -168}, {-200, -174}, {-172, -174}, {-172, -164}}, color = {0, 0, 127}));
  connect(firstOrdertPElec.y, multiSwitch.u[2]) annotation(
    Line(points = {{-238, -182}, {-172, -182}, {-172, -164}}, color = {0, 0, 127}));
  connect(firstOrdertActuatorRatelim.y, multiSwitch.u[3]) annotation(
    Line(points = {{226, -88}, {240, -88}, {240, -136}, {166, -136}, {166, -190}, {-172, -190}, {-172, -164}}, color = {0, 0, 127}));
  connect(lastValue.y, multiSwitch.u[4]) annotation(
    Line(points = {{114, -152}, {104, -152}, {104, -180}, {-172, -180}, {-172, -164}}, color = {0, 0, 127}));
  connect(multiSwitch.y, gainR.u) annotation(
    Line(points = {{-172, -152}, {-172, -136}}, color = {0, 0, 127}));
  connect(gainChangeBaseIn.y, firstOrdertPElec.u) annotation(
    Line(points = {{-284, -182}, {-262, -182}}, color = {0, 0, 127}));
  connect(limitDeltaOmegaMinMax.y, derivativeKDGovTDGov.u) annotation(
    Line(points = {{-88, -92}, {-76, -92}, {-76, -128}, {-62, -128}}, color = {0, 0, 127}));
  connect(derivativeKDGovTDGov.y, addGovController.u3) annotation(
    Line(points = {{-38, -128}, {-12, -128}, {-12, -100}, {-4, -100}}, color = {0, 0, 127}));
  connect(add.y, derivativetA.u) annotation(
    Line(points = {{-232, -18}, {-142, -18}}, color = {0, 0, 127}));
  connect(derivativetA.y, addAsetOmega.u2) annotation(
    Line(points = {{-118, -18}, {-80, -18}}, color = {0, 0, 127}));
  connect(expOmegaToTheDm.y, prodOmegaCfe.u2) annotation(
    Line(points = {{215, 152}, {218, 152}, {218, 118}, {194, 118}}, color = {0, 0, 127}));
  connect(omegaPu4.y, expOmegaToTheDm.u) annotation(
    Line(points = {{121, 215}, {176, 215}, {176, 152}, {192, 152}}, color = {0, 0, 127}));
  connect(constDmFactor.y, prodOmegaDm.u1) annotation(
    Line(points = {{209, 198}, {226, 198}}, color = {0, 0, 127}));
  connect(PGenPu, gainChangeBaseIn.u) annotation(
    Line(points = {{-333, -181}, {-308, -181}, {-308, -182}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body>This generic governor model (CIM name GovCT2) can be used to represent a variety of prime movers controlled by PID governors. For more information, see IEC 61970-302.</body></html>"),
    Diagram(coordinateSystem(extent = {{-320, -200}, {320, 220}}), graphics = {Text(origin = {248, -35}, extent = {{-7, -3}, {7, 3}}, textString = "cfe"), Text(origin = {158, -84}, extent = {{-17, -4}, {17, 4}}, textString = "fsr"), Text(origin = {135, -194}, extent = {{-44, -4}, {44, 4}}, textString = "valve stroke"), Text(origin = {85, -184}, extent = {{-30, -4}, {30, 4}}, textString = "governor output"), Rectangle(origin = {70, -20}, lineColor = {0, 91, 127}, lineThickness = 0.75, extent = {{-24, 86}, {24, -86}}), Text(origin = {73, 44}, lineColor = {0, 91, 127}, extent = {{-20, -18}, {20, 18}}, textString = "Low
Value
Select"), Text(origin = {234, 216}, extent = {{-17, -4}, {17, 4}}, textString = "dm>=0"), Text(origin = {162, 164}, extent = {{-17, -4}, {17, 4}}, textString = "dm<0"), Text(origin = {-220, 3}, extent = {{-27, -1}, {27, 1}}, textString = "deltaOmega"), Text(origin = {-106, -15}, extent = {{-19, -1}, {19, 1}}, textString = "acceleration"), Rectangle(origin = {-75, -10}, lineColor = {23, 156, 125}, fillColor = {166, 187, 200}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-115, 28}, {115, -28}}), Rectangle(origin = {-82, -93}, lineColor = {23, 156, 125}, fillColor = {166, 187, 200}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-122, 53}, {122, -53}}), Text(origin = {-152, -47}, lineColor = {0, 8, 11}, lineThickness = 2, extent = {{-39, -11}, {39, 11}}, textString = "Main Control Path", textStyle = {TextStyle.Bold}), Text(origin = {-122, 12}, lineColor = {0, 8, 11}, lineThickness = 2, extent = {{-45, -10}, {45, 10}}, textString = "Acceleration Limiter", textStyle = {TextStyle.Bold}), Rectangle(origin = {34, 115}, lineColor = {23, 156, 125}, fillColor = {166, 187, 200}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-174, 17}, {174, -17}}), Rectangle(origin = {-59, 77}, lineColor = {23, 156, 125}, fillColor = {166, 187, 200}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-101, 55}, {101, -55}}), Rectangle(origin = {-172, 155}, lineColor = {23, 156, 125}, fillColor = {166, 187, 200}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-142, 63}, {142, -63}}), Text(origin = {-80, 156}, extent = {{-13, -4}, {13, 4}}, textString = "tlim"), Text(origin = {106, 125}, extent = {{-11, -3}, {11, 3}}, textString = "Tex"), Text(origin = {-22, 120}, extent = {{-13, -4}, {13, 4}}, textString = "Texm"), Text(origin = {-264, 206}, lineColor = {0, 8, 11}, lineThickness = 2, extent = {{-45, -10}, {45, 10}}, textString = "Load Limit Controller", textStyle = {TextStyle.Bold}), Rectangle(origin = {208, -97}, lineColor = {23, 156, 125}, fillColor = {166, 187, 200}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-110, 35}, {110, -35}}), Rectangle(origin = {278, 38}, lineColor = {23, 156, 125}, fillColor = {166, 187, 200}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-40, 118}, {40, -118}}), Text(origin = {301, 50}, rotation = 90, lineColor = {0, 8, 11}, lineThickness = 2, extent = {{-39, -3}, {39, 3}}, textString = "Turbine/Engine", textStyle = {TextStyle.Bold}), Rectangle(origin = {-266, -132}, lineColor = {23, 156, 125}, fillColor = {166, 187, 200}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-52, 38}, {52, -38}}), Text(origin = {-288, -109}, lineColor = {0, 8, 11}, lineThickness = 2, extent = {{-61, -9}, {61, 9}}, textString = "Supervisory
load
controller", textStyle = {TextStyle.Bold}), Rectangle(origin = {159, 23}, lineColor = {23, 156, 125}, fillColor = {166, 187, 200}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-49, 69}, {49, -69}}), Text(origin = {183, 53}, lineColor = {0, 8, 11}, lineThickness = 2, extent = {{-32, -15}, {32, 15}}, textString = "frequency-
dependent
limit", textStyle = {TextStyle.Bold})}),
    Icon(coordinateSystem(extent = {{-320, -200}, {320, 220}}), graphics = {Text(origin = {7, 7}, extent = {{-279, 123}, {279, -123}}, textString = "GovCT2"), Rectangle(origin = {0, 10}, extent = {{-320, 210}, {320, -210}})}),
    experiment(StartTime = 0, StopTime = 10.5, Tolerance = 0.001, Interval = 0.002),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "rungekutta"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian");
end GovCt2;
