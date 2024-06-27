within Dynawo.Electrical.Controls.Machines.Governors.Standard.Generic;

model GovCT2 "Governor type GovCT2"
  /*
                  * Copyright (c) 2021, RTE (http://www.rte-france.com) and UPC/Citcea (https://www.citcea.upc.edu/)
                  * See AUTHORS.txt
                  * All rights reserved.
                  * This Source Code Form is subject to the terms of the Mozilla Public
                  * License, v. 2.0. If a copy of the MPL was not distributed with this
                  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
                  * SPDX-License-Identifier: MPL-2.0
                  *
                  * This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
                  */
  //
  // Inputs, Outputs
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) annotation( Placement(visible = true, transformation(origin = {-329, -19}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-344, 100}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omega0Pu) annotation(Placement(visible = true, transformation(origin = {-333, 23}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-343, 181}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PePu(start = Pm0Pu) annotation( Placement(visible = true, transformation(origin = {-335, -183}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-343, -161}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PMwSetPu(start = PRef0Pu) annotation( Placement(visible = true, transformation(origin = {-333, -139}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-344, -80}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) annotation( Placement(visible = true, transformation(origin = {-333, -87}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-346, 10}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  //
  // Parameters
  parameter Types.PerUnit aSetPu = 10 "Acceleration limiter setpoint in pu/s" annotation( Dialog(tab = "Acceleration limiter"));
  parameter Types.PerUnit DeltaOmegaDbPu = 0 "Speed governor deadband in PU speed." annotation( Dialog(tab = "Main control path"));
  parameter Types.PerUnit DeltaOmegaMaxPu = 1 "Maximum value for speed error signal in pu" annotation( Dialog(tab = "Main control path"));
  parameter Types.PerUnit DeltaOmegaMinPu = -1 "Minimum value for speed error signal in pu" annotation( Dialog(tab = "Main control path"));
  parameter Types.Time DeltaTSeconds = 1 "Correction factor in s (to adapt the unit of the acceleration limiter gain from pu/s to pu)" annotation( Dialog(tab = "Acceleration limiter"));
  parameter Types.PerUnit DmPu = 0 "Speed sensitivity coefficient in pu (damping)" annotation( Dialog(tab = "Turbine/engine"));
  parameter Types.Frequency fLim10Hz = 0 "Frequency threshold 10 in Hz" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim1Hz = 49 "Frequency threshold 1 in Hz" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim2Hz = 8 "Frequency threshold 2 in Hz" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim3Hz = 7 "Frequency threshold 3 in Hz" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim4Hz = 6 "Frequency threshold 4 in Hz" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim5Hz = 5 "Frequency threshold 5 in Hz" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim6Hz = 4 "Frequency threshold 6 in Hz" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim7Hz = 3 "Frequency threshold 7 in Hz" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim8Hz = 2 "Frequency threshold 8 in Hz" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim9Hz = 1 "Frequency threshold 9 in Hz" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fNomHz = 50 "Nominal Frequency in Hz";
  parameter Types.PerUnit KAPu = 10 "Acceleration limiter gain in pu" annotation( Dialog(tab = "Acceleration limiter"));
  parameter Types.PerUnit KDGovPu = 0 "Governor derivative gain in pu" annotation( Dialog(tab = "Main control path"));
  parameter Types.PerUnit KIGovPu = 0.45 "Governor integral gain in pu" annotation( Dialog(tab = "Main control path"));
  parameter Types.PerUnit KILoadPu = 1 "Load limiter integral gain for PI controller in pu" annotation( Dialog(tab = "Load limit controller"));
  parameter Types.PerUnit KIMwPu = 0 "Power controller gain in pu" annotation( Dialog(tab = "Supervisory load controller"));
  parameter Types.PerUnit KPGovPu = 4 "Governor proportional gain in pu" annotation( Dialog(tab = "Main control path"));
  parameter Types.PerUnit KPLoadPu = 1 "Load limiter proportional gain for PI controller in pu" annotation( Dialog(tab = "Load limit controller"));
  parameter Types.PerUnit KTurbPu = 1.9168 "Turbine gain in pu" annotation( Dialog(tab = "Turbine/engine"));
  parameter Types.PerUnit omega0Pu = SystemBase.omega0Pu "Initial rotor speed";
  parameter Types.ActivePower PBaseMw "Base for power values (> 0) in MW";
  parameter Types.ActivePowerPu PLdRefPu = 1 "Load limiter reference value in pu (base PBaseMw)" annotation( Dialog(tab = "Load limit controller"));
  parameter Types.ActivePowerPu PLim10Pu = 0.8325 "Power limit 10 in pu (base PBaseMw)" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim1Pu = 0.8325 "Power limit 1 in pu (base PBaseMw)" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim2Pu = 0.8325 "Power limit 2 in pu (base PBaseMw)" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim3Pu = 0.8325 "Power limit 3 in pu (base PBaseMw)" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim4Pu = 0.8325 "Power limit 4 in pu (base PBaseMw)" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim5Pu = 0.8325 "Power limit 5 in pu (base PBaseMw)" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim6Pu = 0.8325 "Power limit 6 in pu (base PBaseMw)" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim7Pu = 0.8325 "Power limit 7 in pu (base PBaseMw)" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim8Pu = 0.8325 "Power limit 8 in pu (base PBaseMw)" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim9Pu = 0.8325 "Power Limit 9 in pu (base PBaseMw)" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLimFromfPoints[:, :] = [fLim10Hz-0.000001, PLim10Pu; fLim10Hz, PLim10Pu; fLim9Hz, PLim9Pu; fLim8Hz, PLim8Pu; fLim7Hz, PLim7Pu; fLim6Hz, PLim6Pu; fLim5Hz, PLim5Pu; fLim4Hz, PLim4Pu; fLim3Hz, PLim3Pu; fLim2Hz, PLim2Pu; fLim1Hz, PLim1Pu; fLim1Hz + 0.000001, (ValveMaxPu - WFnlPu)*KTurbPu; fLim1Hz + 1, (ValveMaxPu - WFnlPu)*KTurbPu] "Pair of points for frequency-dependent active power limit piecewise linear curve [u1,y1; u2,y2;...] (above fLim1Hz, jump to power associated with ValveMaxPu)" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.PerUnit Pm0Pu "Initial value of mechanical power";
  parameter Types.PerUnit PRatePu = 0.017 "Ramp rate for frequency-dependent power limit" annotation( Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.PerUnit RClosePu = -99 "Minimum valve closing rate in pu/s" annotation( Dialog(tab = "Turbine/engine"));
  parameter Types.PerUnit RDownPu = -99 "Maximum rate of load limit decrease in pu" annotation( Dialog(tab = "Load limit controller"));
  parameter Types.PerUnit ROpenPu = 99 "Maximum valve opening rate in pu/s" annotation( Dialog(tab = "Turbine/engine"));
  parameter Types.PerUnit RPu = 0.05 "Permanent droop in pu" annotation( Dialog(tab = "Main control path"));
  parameter Integer RSelectInt "Feedback signal for droop" annotation( Dialog(tab = "Main control path"));
  parameter Types.PerUnit RUpPu = 99 "Maximum rate of load limit increase in pu" annotation( Dialog(tab = "Load limit controller"));
  parameter Types.Time tActuatorSeconds = 0.4 "Actuator time constant in s" annotation( Dialog(tab = "Turbine/engine"));
  parameter Types.Time tASeconds = 1 "Acceleration limiter time constant in s" annotation( Dialog(tab = "Acceleration limiter"));
  parameter Types.Time tBSeconds = 0.1 "Turbine lag time constant in s" annotation( Dialog(tab = "Turbine/engine"));
  parameter Types.Time tCSeconds = 0 "Turbine lead time constant in s" annotation( Dialog(tab = "Turbine/engine"));
  parameter Types.Time tDGovSeconds = 1 "Governor derivative controller time constant in s" annotation( Dialog(tab = "Main control path"));
  parameter Types.Time tDRatelimSeconds = 0.001 "Ramp rate limter derivative time constant in s";
  parameter Types.Time tEngineSeconds = 0 "Transport time delay for diesel engine in s" annotation( Dialog(tab = "Turbine/engine"));
  parameter Types.Time tFLoadSeconds = 3 "Load limiter time constant in s" annotation( Dialog(tab = "Load limit controller"));
  parameter Types.Time tLastValueSeconds = 1e-9 "Fast delay block time constant in s" annotation( Dialog(tab = "Main control path"));
  parameter Types.Time tPElecSeconds = 2.5 "Electrical power transducer time constant in s" annotation( Dialog(tab = "Main control path"));
  parameter Types.Time tSASeconds = 1e-6 "Temperature detection lead time constant in s" annotation( Dialog(tab = "Load limit controller"));
  parameter Types.Time tSBSeconds = 50 "Temperature detection lag time constant in s" annotation( Dialog(tab = "Load limit controller"));
  parameter Types.Time ValveMaxPu = 1 "Maximum valve position limit in pu" annotation( Dialog(tab = "Turbine/engine"));
  parameter Types.Time ValveMinPu = 0.175 "Minimum valve position limit in pu" annotation( Dialog(tab = "Turbine/engine"));
  parameter Types.Time WFnlPu = 0.187 "No load fuel flow in pu" annotation( Dialog(tab = "Turbine/engine"));
  parameter Boolean WFSpdBool = false "Switch for fuel source characteristic" annotation( Dialog(tab = "Turbine/engine")); 
//
  // initialization helpers
  final parameter Real initCfe = WFnlPu + (if KTurbPu > 0 then initPMechNoLoss/KTurbPu else 0);
  final parameter Types.PerUnit initFsrt = (PLdRefPu/KTurbPu + WFnlPu - initTex)*KPLoadPu + initIntegratorKILoad;
  final parameter Real initIntegratorKILoad = 1;
  final parameter Types.PerUnit initPMechNoLoss = if DmPu>0.0 then Pm0Pu + omega0Pu*DmPu else Pm0Pu;
  final parameter Real initTex = initCfe * (if DmPu<0 then omega0Pu^(-DmPu) else 1);
  final parameter Real initValve = if WFSpdBool then initCfe/omega0Pu else initCfe;
  final parameter Types.PerUnit PRef0Pu = RPu*(if RSelectInt == 0 then 0 else if RSelectInt == 1 then Pm0Pu else initValve) "Initial value of reference power";
  //
  // blocks
  Modelica.Blocks.Math.Add add(k1 = -1) annotation( Placement(visible = true, transformation(origin = {-244, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addAsetOmega(k2 = -1) annotation( Placement(visible = true, transformation(origin = {-68, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addCfeWfnl(k1 = -1) annotation( Placement(visible = true, transformation(origin = {256, -6}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add3 addDeltaOmega(k1 = -1, k3 = -1) annotation( Placement(visible = true, transformation(origin = {-172, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addFsra annotation( Placement(visible = true, transformation(origin = {26, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addGovController annotation( Placement(visible = true, transformation(origin = {8, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addLoadLimitController annotation( Placement(visible = true, transformation(origin = {-38, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPDmPTurbine(k1 = -1) annotation( Placement(visible = true, transformation(origin = {276, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPmwsetPefilt(k1 = -1) annotation( Placement(visible = true, transformation(origin = {-238, -148}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add addSupervisoryLoadController annotation( Placement(visible = true, transformation(origin = {-216, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addtLimtExm(k2 = -1) annotation( Placement(visible = true, transformation(origin = {-64, 120}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addWFnlPldRef annotation( Placement(visible = true, transformation(origin = {-142, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addWfnlValvemax(k1 = +1) annotation( Placement(visible = true, transformation(origin = {146, -38}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constASet(k = aSetPu) annotation( Placement(visible = true, transformation(origin = {-178, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constDm(k = DmPu) annotation( Placement(visible = true, transformation(origin = {86, 164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constDummy(k = 0) annotation( Placement(visible = true, transformation(origin = {-154, -168}, extent = {{-4, -4}, {4, 4}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant constIsochronous(k = 0) annotation( Placement(visible = true, transformation(origin = {-200, -160}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constOne(k = 1) annotation( Placement(visible = true, transformation(origin = {240, -178}, extent = {{9, -9}, {-9, 9}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constPLdRef(k = PLdRefPu) annotation( Placement(visible = true, transformation(origin = {-298, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constRClose(k = RClosePu) annotation( Placement(visible = true, transformation(origin = {214, -114}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constROpen(k = ROpenPu) annotation( Placement(visible = true, transformation(origin = {214, -58}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant constRSelect(k = RSelectInt) annotation( Placement(visible = true, transformation(origin = {-114, -160}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constValveMin(k = ValveMinPu) annotation( Placement(visible = true, transformation(origin = {130, -112}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constWFnl(k = WFnlPu) annotation( Placement(visible = true, transformation(origin = {-176, 200}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constWFnl2(k = WFnlPu) annotation( Placement(visible = true, transformation(origin = {305, -37}, extent = {{-13, -13}, {13, 13}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant constWFnl3(k = WFnlPu) annotation( Placement(visible = true, transformation(origin = {182, 6}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanConstant constWFSpd(k = WFSpdBool) annotation( Placement(visible = true, transformation(origin = {272, -176}, extent = {{8, -8}, {-8, 8}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constZero(k = 0) annotation( Placement(visible = true, transformation(origin = {84, 202}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZoneDeltaOmegaDb(uMax = DeltaOmegaDbPu) annotation( Placement(visible = true, transformation(origin = {-132, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay delaytEngine(delayTime = tEngineSeconds) annotation( Placement(visible = true, transformation(origin = {256, 24}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.Continuous.PowerExternalBase expOmegaToTheDm annotation( Placement(visible = true, transformation(origin = {214, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze firstOrdertActuatorRatelim(T = tActuatorSeconds, UseRateLim = true, Y0 = initValve, y(fixed = true)) annotation( Placement(visible = true, transformation(origin = {214, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrdertFLoad(T = tFLoadSeconds, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = initTex) annotation( Placement(visible = true, transformation(origin = {34, 114}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrdertPElec(T = tPElecSeconds, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = Pm0Pu) annotation( Placement(visible = true, transformation(origin = {-250, -182}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainfNom(k(unit = "") = fNomHz) annotation( Placement(visible = true, transformation(origin = {138, 66}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gainKADeltat(k(unit = "") = KAPu*DeltaTSeconds) annotation( Placement(visible = true, transformation(origin = {-20, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKPGov(k = KPGovPu) annotation( Placement(visible = true, transformation(origin = {-48, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKPLoad(k = KPLoadPu) annotation( Placement(visible = true, transformation(origin = {-102, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKTurb(k = KTurbPu) annotation( Placement(visible = true, transformation(origin = {256, 74}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gainOneOverKTurb(k = 1/KTurbPu) annotation( Placement(visible = true, transformation(origin = {-236, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainOneOverKTurb2(k = 1/KTurbPu) annotation( Placement(visible = true, transformation(origin = {140, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gainR(k = RPu) annotation( Placement(visible = true, transformation(origin = {-172, -124}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.Integrator integratorKIGov(initType = Modelica.Blocks.Types.Init.InitialState, k = KIGovPu, y_start = initValve) annotation( Placement(visible = true, transformation(origin = {-50, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorKILoad(initType = Modelica.Blocks.Types.Init.InitialState, k = KILoadPu, y_start = initIntegratorKILoad) annotation( Placement(visible = true, transformation(origin = {-104, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedIntegrator integratorKIMw(K = KIMwPu, YMax = 1.1*RPu, YMin = -1.1*RPu) annotation( Placement(visible = true, transformation(origin = {-238, -120}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.FirstOrder lastValue(T = tLastValueSeconds, y(fixed = true), y_start = initValve) annotation( Placement(visible = true, transformation(origin = {124, -152}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limitDeltaOmegaMinMax(uMax = DeltaOmegaMaxPu, uMin = DeltaOmegaMinPu) annotation( Placement(visible = true, transformation(origin = {-100, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limitFsrt(uMax = 1.0, uMin = -9999) annotation( Placement(visible = true, transformation(origin = {28, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter limitValveMaxValveMin(limitsAtInit = true, strict = false)  annotation( Placement(visible = true, transformation(origin = {130, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max maxDm annotation( Placement(visible = true, transformation(origin = {160, 186}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min minDm annotation( Placement(visible = true, transformation(origin = {144, 158}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min minLowValueSelect annotation( Placement(visible = true, transformation(origin = {72, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min minLowValueSelect2 annotation( Placement(visible = true, transformation(origin = {69, -87}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchNoVector multiSwitchNoVector annotation( Placement(visible = true, transformation(origin = {-172, -156}, extent = {{5, 10}, {-5, -10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression omegaPu2(y = omegaPu) annotation( Placement(visible = true, transformation(origin = {157, 89}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression omegaPu3(y = omegaPu) annotation( Placement(visible = true, transformation(origin = {341, -157}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression omegaPu4(y = omegaPu) annotation( Placement(visible = true, transformation(origin = {149, 227}, extent = {{-13, -9}, {13, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) annotation( Placement(visible = true, transformation(origin = {330, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {350, 2}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Blocks.Math.Product prodCfe annotation( Placement(visible = true, transformation(origin = {252, -54}, extent = {{8, -8}, {-8, 8}}, rotation = -90)));
  Modelica.Blocks.Math.Product prodOmegaCfe annotation( Placement(visible = true, transformation(origin = {184, 114}, extent = {{-8, -8}, {8, 8}}, rotation = -180)));
  Modelica.Blocks.Math.Product prodOmegaDm annotation( Placement(visible = true, transformation(origin = {236, 180}, extent = {{8, -8}, {-8, 8}}, rotation = 180)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter rateLimitFsrt(Falling = RDownPu,Rising = RUpPu, Td = tDRatelimSeconds, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = initFsrt) annotation( Placement(visible = true, transformation(origin = {-4, 40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter rateLimitPRate(Rising = PRatePu, Td = tDRatelimSeconds, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = (ValveMaxPu - WFnlPu) * KTurbPu)  annotation( Placement(visible = true, transformation(origin = {138, 14}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switchWFSpd annotation( Placement(visible = true, transformation(origin = {272, -126}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Tables.CombiTable1Ds tablePLimFromf(extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = PLimFromfPoints, tableOnFile = false, verboseRead = false) annotation( Placement(visible = true, transformation(origin = {138, 38}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.TransferFunction transferFuncKDGovTDGov(a = {tDGovSeconds, 1}, b = {KDGovPu, 0}, initType = Modelica.Blocks.Types.Init.InitialState) annotation( Placement(visible = true, transformation(origin = {-49, -133}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunctA(a = {tASeconds, 1}, b = {1, 0}) annotation( Placement(visible = true, transformation(origin = {-142, -18}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunctCtB(a = {tBSeconds, 1}, b = {tCSeconds, 1}, initType = Modelica.Blocks.Types.Init.InitialState, x_start = {initPMechNoLoss}, y_start = initPMechNoLoss) annotation( Placement(visible = true, transformation(origin = {254, 106}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.TransferFunction transferFunctSAtSB(a = {tSBSeconds, 1}, b = {tSASeconds, 1}, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = initTex) annotation( Placement(visible = true, transformation(origin = {80, 114}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  
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
    Line(points = {{327, -157}, {282, -157}, {282, -138}, {279.7, -138}}, color = {0, 0, 127}));
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
  connect(limitDeltaOmegaMinMax.y, transferFuncKDGovTDGov.u) annotation(
    Line(points = {{-89, -92}, {-75, -92}, {-75, -133}, {-65, -133}}, color = {0, 0, 127}));
  connect(gainKPGov.y, addGovController.u1) annotation(
    Line(points = {{-37, -54}, {-11, -54}, {-11, -84}, {-4, -84}}, color = {0, 0, 127}));
  connect(integratorKIGov.y, addGovController.u2) annotation(
    Line(points = {{-39, -92}, {-4, -92}}, color = {0, 0, 127}));
  connect(transferFuncKDGovTDGov.y, addGovController.u3) annotation(
    Line(points = {{-35, -133}, {-12.5, -133}, {-12.5, -100}, {-4, -100}}, color = {0, 0, 127}));
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
  connect(PePu, firstOrdertPElec.u) annotation(
    Line(points = {{-335, -183}, {-289, -183}, {-289, -182}, {-262, -182}}, color = {0, 0, 127}));
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
  connect(transferFunctA.y, addAsetOmega.u2) annotation(
    Line(points = {{-129, -18}, {-80, -18}}, color = {0, 0, 127}));
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
  connect(constDm.y, maxDm.u1) annotation(
    Line(points = {{97, 164}, {108.5, 164}, {108.5, 192}, {148, 192}}, color = {0, 0, 127}));
  connect(constDm.y, minDm.u1) annotation(
    Line(points = {{97, 164}, {132, 164}}, color = {0, 0, 127}));
  connect(constZero.y, maxDm.u2) annotation(
    Line(points = {{95, 202}, {122, 202}, {122, 180}, {148, 180}}, color = {0, 0, 127}));
  connect(constZero.y, minDm.u2) annotation(
    Line(points = {{95, 202}, {122, 202}, {122, 152}, {132, 152}}, color = {0, 0, 127}));
  connect(prodOmegaDm.y, addPDmPTurbine.u1) annotation(
    Line(points = {{244, 180}, {248, 180}, {248, 138}, {264, 138}}, color = {0, 0, 127}));
  connect(maxDm.y, prodOmegaDm.u1) annotation(
    Line(points = {{172, 186}, {182, 186}, {182, 176}, {226, 176}}, color = {0, 0, 127}));
  connect(omegaPu4.y, prodOmegaDm.u2) annotation(
    Line(points = {{163, 227}, {214, 227}, {214, 184}, {226, 184}}, color = {0, 0, 127}));
  connect(omegaPu4.y, expOmegaToTheDm.u1) annotation(
    Line(points = {{163, 227}, {196, 227}, {196, 156}, {202, 156}}, color = {0, 0, 127}));
  connect(expOmegaToTheDm.y, prodOmegaCfe.u2) annotation(
    Line(points = {{226, 150}, {232, 150}, {232, 118}, {194, 118}}, color = {0, 0, 127}));
  connect(prodOmegaCfe.u1, prodCfe.y) annotation(
    Line(points = {{194, 110}, {230, 110}, {230, -40}, {252, -40}, {252, -46}}, color = {0, 0, 127}));
  connect(PMwSetPu, addPmwsetPefilt.u2) annotation(
    Line(points = {{-332, -138}, {-286, -138}, {-286, -164}, {-244, -164}, {-244, -160}}, color = {0, 0, 127}));
  connect(gainR.u, multiSwitchNoVector.y) annotation(
    Line(points = {{-172, -136}, {-172, -150}}, color = {0, 0, 127}));
  connect(omegaPu, add.u2) annotation(
    Line(points = {{-328, -18}, {-292, -18}, {-292, -24}, {-256, -24}}, color = {0, 0, 127}));
  connect(add.y, transferFunctA.u) annotation(
    Line(points = {{-233, -18}, {-156, -18}}, color = {0, 0, 127}));
  connect(add.y, addDeltaOmega.u1) annotation(
    Line(points = {{-233, -18}, {-194, -18}, {-194, -84}, {-184, -84}}, color = {0, 0, 127}));
  connect(constRSelect.y, multiSwitchNoVector.selection) annotation(
    Line(points = {{-124, -160}, {-144, -160}, {-144, -146}, {-184, -146}, {-184, -156}}, color = {255, 127, 0}));
  connect(constIsochronous.y, multiSwitchNoVector.u0) annotation(
    Line(points = {{-200, -168}, {-200, -170}, {-180, -170}, {-180, -162}}, color = {0, 0, 127}));
  connect(constDummy.y, multiSwitchNoVector.u4) annotation(
    Line(points = {{-158, -168}, {-164, -168}, {-164, -162}}, color = {0, 0, 127}));
  connect(firstOrdertPElec.y, multiSwitchNoVector.u1) annotation(
    Line(points = {{-238, -182}, {-176, -182}, {-176, -162}}, color = {0, 0, 127}));
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
  connect(firstOrdertActuatorRatelim.y, multiSwitchNoVector.u2) annotation(
    Line(points = {{226, -88}, {238, -88}, {238, -140}, {170, -140}, {170, -190}, {-172, -190}, {-172, -162}}, color = {0, 0, 127}));
  connect(lastValue.y, addFsra.u2) annotation(
    Line(points = {{114, -152}, {104, -152}, {104, -180}, {30, -180}, {30, -36}, {4, -36}, {4, -24}, {14, -24}}, color = {0, 0, 127}));
  connect(lastValue.y, multiSwitchNoVector.u3) annotation(
    Line(points = {{114, -152}, {104, -152}, {104, -180}, {-168, -180}, {-168, -162}}, color = {0, 0, 127}));
  connect(limitValveMaxValveMin.y, lastValue.u) annotation(
    Line(points = {{142, -88}, {150, -88}, {150, -152}, {136, -152}}, color = {0, 0, 127}));
  connect(minDm.y, expOmegaToTheDm.u2) annotation(
    Line(points = {{156, 158}, {174, 158}, {174, 144}, {202, 144}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u1) annotation(
    Line(points = {{-332, 24}, {-280, 24}, {-280, -12}, {-256, -12}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body>This generic governor model (CIM name GovCT2) can be used to represent a variety of prime movers controlled by PID governors. For more information, see IEC 61970-302.</body></html>"),
    Diagram(coordinateSystem(extent = {{-320, -200}, {320, 220}}), graphics = {Text(origin = {248, -35}, extent = {{-7, -3}, {7, 3}}, textString = "cfe"), Text(origin = {158, -84}, extent = {{-17, -4}, {17, 4}}, textString = "fsr"), Rectangle(origin = {157, 14}, lineColor = {0, 0, 255}, lineThickness = 0.75, extent = {{-41, 68}, {41, -68}}), Text(origin = {174, 45}, lineColor = {0, 0, 255}, extent = {{-23, -21}, {23, 21}}, textString = "frequency-
dependent
limit"), Text(origin = {135, -194}, extent = {{-44, -4}, {44, 4}}, textString = "valve stroke"), Text(origin = {85, -184}, extent = {{-30, -4}, {30, 4}}, textString = "governor output"), Rectangle(origin = {70, -20}, lineColor = {0, 0, 255}, lineThickness = 0.75, extent = {{-24, 86}, {24, -86}}), Text(origin = {-22, 120}, extent = {{-13, -4}, {13, 4}}, textString = "Texm"), Text(origin = {106, 125}, extent = {{-11, -3}, {11, 3}}, textString = "Tex"), Text(origin = {-70, 156}, extent = {{-13, -4}, {13, 4}}, textString = "tlim"), Text(origin = {73, 44}, lineColor = {0, 0, 255}, extent = {{-20, -18}, {20, 18}}, textString = "Low
Value
Select"), Text(origin = {182, 192}, extent = {{-17, -4}, {17, 4}}, textString = "dm>=0"), Text(origin = {168, 164}, extent = {{-17, -4}, {17, 4}}, textString = "dm<=0"), Text(origin = {-190, -21}, extent = {{-19, -1}, {19, 1}}, textString = "deltaOmega"), Text(origin = {-106, -15}, extent = {{-19, -1}, {19, 1}}, textString = "acceleration")}),
    Icon(coordinateSystem(extent = {{-320, -200}, {320, 220}}), graphics = {Text(origin = {7, 7}, extent = {{-279, 123}, {279, -123}}, textString = "GovCT2"), Rectangle(origin = {0, 10}, extent = {{-320, 210}, {320, -210}})}),
    experiment(StartTime = 0, StopTime = 10.5, Tolerance = 0.001, Interval = 0.002),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "rungekutta"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian");
end GovCT2;
