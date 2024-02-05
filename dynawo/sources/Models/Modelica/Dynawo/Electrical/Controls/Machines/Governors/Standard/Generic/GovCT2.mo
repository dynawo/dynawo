within Dynawo.Electrical.Controls.Machines.Governors.Standard.Generic;

model GovCT2 "IEEE Governor type TGOV1"
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
  parameter Types.PerUnit aSetPu = 10 "Acceleration limiter setpoint in pu/s" annotation(
    Dialog(tab = "Acceleration limiter"));
  parameter Types.PerUnit DeltaOmegaDbPu = 0 "Speed governor deadband in PU speed." annotation(
    Dialog(tab = "Main control path"));
  parameter Types.PerUnit DeltaOmegaMaxPu = 1 "Maximum value for speed error signal in pu" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.PerUnit DeltaOmegaMinPu = -1 "Minimum value for speed error signal in pu" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.Time DeltaTSeconds = 1 "Correction factor in s (to adapt the unit of the acceleration limiter gain from pu/s to pu)" annotation(
    Dialog(tab = "Acceleration limiter"));
  parameter Types.PerUnit DmPu = 0 "Speed sensitivity coefficient in pu (damping)" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.Frequency fLim1Hz = 49 "Frequency threshold 1 in Hz" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim2Hz = 8 "Frequency threshold 2 in Hz" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim3Hz = 7 "Frequency threshold 3 in Hz" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim4Hz = 6 "Frequency threshold 4 in Hz" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim5Hz = 5 "Frequency threshold 5 in Hz" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim6Hz = 4 "Frequency threshold 6 in Hz" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim7Hz = 3 "Frequency threshold 7 in Hz" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim8Hz = 2 "Frequency threshold 8 in Hz" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim9Hz = 1 "Frequency threshold 9 in Hz" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fLim10Hz = 0 "Frequency threshold 10 in Hz" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.Frequency fNomHz = 50 "Nominal Frequency in Hz";
  parameter Types.PerUnit KAPu = 10 "Acceleration limiter gain in pu" annotation(
    Dialog(tab = "Acceleration limiter"));
  parameter Types.PerUnit KDGovPu = 0 "Governor derivative gain in pu" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.PerUnit KIGovPu = 0.45 "Governor integral gain in pu" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.PerUnit KILoadPu = 1 "Load limiter integral gain for PI controller in pu" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.PerUnit KIMwPu = 0 "Power controller gain in pu" annotation(
    Dialog(tab = "Supervisory load controller"));
  parameter Types.PerUnit KPGovPu = 4 "Governor proportional gain in pu" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.PerUnit KPLoadPu = 1 "Load limiter proportional gain for PI controller in pu" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.PerUnit KTurbPu = 1.9168 "Turbine gain in pu" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.ActivePower PBaseMw "Base for power values (> 0) in MW";
  parameter Types.ActivePowerPu PLdRefPu = 1 "Load limiter reference value in pu (base PBaseMw)" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.ActivePowerPu PLim1Pu = 0.8325 "Power limit 1 in pu (base PBaseMw)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim2Pu = 0.8325 "Power limit 2 in pu (base PBaseMw)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim3Pu = 0.8325 "Power limit 3 in pu (base PBaseMw)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim4Pu = 0.8325 "Power limit 4 in pu (base PBaseMw)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim5Pu = 0.8325 "Power limit 5 in pu (base PBaseMw)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim6Pu = 0.8325 "Power limit 6 in pu (base PBaseMw)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim7Pu = 0.8325 "Power limit 7 in pu (base PBaseMw)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim8Pu = 0.8325 "Power limit 8 in pu (base PBaseMw)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim9Pu = 0.8325 "Power Limit 9 in pu (base PBaseMw)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLim10Pu = 0.8325 "Power limit 10 in pu (base PBaseMw)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.ActivePowerPu PLimFromfPoints[:, :] = [fLim10Hz-0.000001, PLim10Pu; fLim10Hz, PLim10Pu; fLim9Hz, PLim9Pu; fLim8Hz, PLim8Pu; fLim7Hz, PLim7Pu; fLim6Hz, PLim6Pu; fLim5Hz, PLim5Pu; fLim4Hz, PLim4Pu; fLim3Hz, PLim3Pu; fLim2Hz, PLim2Pu; fLim1Hz, PLim1Pu; fLim1Hz + 0.000001, (ValveMaxPu - WFnlPu)*KTurbPu; fLim1Hz + 1, (ValveMaxPu - WFnlPu)*KTurbPu] "Pair of points for frequency-dependent active power limit piecewise linear curve [u1,y1; u2,y2;...] (above fLim1Hz, jump to power associated with ValveMaxPu)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.PerUnit PMech0Pu "Initial value of mechanical power";
  parameter Types.PerUnit PRatePu = 0.017 "Ramp rate for frequency-dependent power limit" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
  parameter Types.PerUnit RPu = 0.05 "Permanent droop in pu" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.PerUnit RClosePu = -99 "Minimum valve closing rate in pu/s" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.PerUnit RDownPu = -99 "Maximum rate of load limit decrease in pu" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.PerUnit ROpenPu = 99 "Maximum valve opening rate in pu/s" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Integer RSelectInt "Feedback signal for droop" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.PerUnit RUpPu = 99 "Maximum rate of load limit increase in pu" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.Time tASeconds = 1 "Acceleration limiter time constant in s" annotation(
    Dialog(tab = "Acceleration limiter"));
  parameter Types.Time tActuatorSeconds = 0.4 "Actuator time constant in s" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.Time tBSeconds = 0.1 "Turbine lag time constant in s" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.Time tCSeconds = 0 "Turbine lead time constant in s" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.Time tDGovSeconds = 1 "Governor derivative controller time constant in s" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.Time tEngineSeconds = 0 "Transport time delay for diesel engine in s" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.Time tFLoadSeconds = 3 "Load limiter time constant in s" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.Time tPElecSeconds = 2.5 "Electrical power transducer time constant in s" annotation(
    Dialog(tab = "Main control path"));
  parameter Types.Time tSSeconds "Simulation step size in s";
  parameter Types.Time tSASeconds = 0 "Temperature detection lead time constant in s" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.Time tSBSeconds = 50 "Temperature detection lag time constant in s" annotation(
    Dialog(tab = "Load limit controller"));
  parameter Types.Time ValveMaxPu = 1 "Maximum valve position limit in pu" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.Time ValveMinPu = 0.175 "Minimum valve position limit in pu" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Types.Time WFnlPu = 0.187 "No load fuel flow in pu" annotation(
    Dialog(tab = "Turbine/engine"));
  parameter Boolean WFSpdBool = false "Switch for fuel source characteristic" annotation(
    Dialog(tab = "Turbine/engine"));
    
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-329, -19}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-344, 190}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PMechPu(start = PMech0Pu) annotation(
    Placement(visible = true, transformation(origin = {330, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {350, 2}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PElecPu(start = PMech0Pu) annotation(
    Placement(visible = true, transformation(origin = {-335, -183}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-345, -161}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PMwSetPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-333, -139}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-344, -70}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PMech0Pu) annotation(
    Placement(visible = true, transformation(origin = {-333, -87}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-344, 68}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainOneOverKTurb(k = 1/KTurbPu) annotation(
    Placement(visible = true, transformation(origin = {-236, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constPLdRef(k = PLdRefPu) annotation(
    Placement(visible = true, transformation(origin = {-298, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addWFnlPldRef annotation(
    Placement(visible = true, transformation(origin = {-142, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constWFnl(k = WFnlPu) annotation(
    Placement(visible = true, transformation(origin = {-176, 200}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add addtLimtExm(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-64, 120}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrdertFLoad(T = tFLoadSeconds) annotation(
    Placement(visible = true, transformation(origin = {34, 114}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunctSAtSB(a = {tSBSeconds, 1}, b = {tSASeconds, 1}) annotation(
    Placement(visible = true, transformation(origin = {80, 114}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPDmPTurbine(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {276, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunctCtB(a = {tBSeconds, 1}, b = {tCSeconds, 1}, initType = Modelica.Blocks.Types.Init.SteadyState, x_start = {PMech0Pu}, y_start = PMech0Pu) annotation(
    Placement(visible = true, transformation(origin = {256, 106}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gainKTurb(k = KTurbPu) annotation(
    Placement(visible = true, transformation(origin = {256, 74}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.FixedDelay delaytEngine(delayTime = tEngineSeconds) annotation(
    Placement(visible = true, transformation(origin = {256, 24}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add addCfeWfnl(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {256, -6}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product prodWFSpdValveStroke annotation(
    Placement(visible = true, transformation(origin = {252, -54}, extent = {{8, -8}, {-8, 8}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switchWFSpd annotation(
    Placement(visible = true, transformation(origin = {272, -126}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constOne(k = 1) annotation(
    Placement(visible = true, transformation(origin = {240, -178}, extent = {{9, -9}, {-9, 9}}, rotation = -90)));
  Modelica.Blocks.Sources.BooleanConstant constWFSpd(k = WFSpdBool) annotation(
    Placement(visible = true, transformation(origin = {272, -176}, extent = {{8, -8}, {-8, 8}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze firstOrdertActuatorRatelim(T = tActuatorSeconds, UseRateLim = true, y(start = PMech0Pu / KTurbPu)) annotation(
    Placement(visible = true, transformation(origin = {214, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constROpen(k = ROpenPu) annotation(
    Placement(visible = true, transformation(origin = {214, -58}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter limitValveMaxValveMin(limitsAtInit = true, strict = false)  annotation(
    Placement(visible = true, transformation(origin = {130, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constRClose(k = RClosePu) annotation(
    Placement(visible = true, transformation(origin = {214, -114}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constValveMin(k = ValveMinPu) annotation(
    Placement(visible = true, transformation(origin = {130, -112}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.StandAloneRampRateLimiter rateLimitPRate(DuMax = PRatePu, tS = tSSeconds) annotation(
    Placement(visible = true, transformation(origin = {176, -36}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gainfNom(k(unit = "") = fNomHz) annotation(
    Placement(visible = true, transformation(origin = {138, 62}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gainOneOverKTurb2(k = 1/KTurbPu) annotation(
    Placement(visible = true, transformation(origin = {140, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add addWfnlValvemax(k1 = +1) annotation(
    Placement(visible = true, transformation(origin = {146, -34}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constWFnl3(k = WFnlPu) annotation(
    Placement(visible = true, transformation(origin = {174, -2}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constWFnl2(k = WFnlPu) annotation(
    Placement(visible = true, transformation(origin = {302, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Tables.CombiTable1Ds tablePLimFromf(extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = PLimFromfPoints, tableOnFile = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {138, 32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression omegaPu2(y = omegaPu) annotation(
    Placement(visible = true, transformation(origin = {157, 89}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression omegaPu3(y = omegaPu) annotation(
    Placement(visible = true, transformation(origin = {341, -157}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Min minLowValueSelect annotation(
    Placement(visible = true, transformation(origin = {72, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min minLowValueSelect2 annotation(
    Placement(visible = true, transformation(origin = {69, -87}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKPGov(k = KPGovPu) annotation(
    Placement(visible = true, transformation(origin = {-48, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFuncKDGovTDGov(a = {tDGovSeconds, 1}, b = {KDGovPu, 0}) annotation(
    Placement(visible = true, transformation(origin = {-50, -132}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorKIGov(initType = Modelica.Blocks.Types.Init.SteadyState, k = KIGovPu) annotation(
    Placement(visible = true, transformation(origin = {-50, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZoneDeltaOmegaDb(uMax = DeltaOmegaDbPu) annotation(
    Placement(visible = true, transformation(origin = {-132, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limitDeltaOmegaMinMax(uMax = DeltaOmegaMaxPu, uMin = DeltaOmegaMinPu) annotation(
    Placement(visible = true, transformation(origin = {-100, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addGovController annotation(
    Placement(visible = true, transformation(origin = {8, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addDeltaOmega(k1 = -1, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-172, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addSupervisoryLoadController annotation(
    Placement(visible = true, transformation(origin = {-216, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedIntegrator integratorKIMw(K = KIMwPu, YMax = 1.1*RPu, YMin = -1.1*RPu) annotation(
    Placement(visible = true, transformation(origin = {-238, -120}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add addPmwsetPefilt(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-238, -148}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.FirstOrder firstOrdertPElec(T = tPElecSeconds) annotation(
    Placement(visible = true, transformation(origin = {-250, -182}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainR(k = RPu) annotation(
    Placement(visible = true, transformation(origin = {-172, -124}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add addFsrKaDeltat annotation(
    Placement(visible = true, transformation(origin = {26, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKADeltat(k(unit = "") = KAPu*DeltaTSeconds) annotation(
    Placement(visible = true, transformation(origin = {-20, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addAsetOmega(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-68, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constASet(k = aSetPu) annotation(
    Placement(visible = true, transformation(origin = {-178, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunctA(a = {tASeconds, 1}, b = {1, 0}) annotation(
    Placement(visible = true, transformation(origin = {-142, -18}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rateLimitFsrt(DuMax = RUpPu, DuMin = RDownPu, tS = tSSeconds) annotation(
    Placement(visible = true, transformation(origin = {-4, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limitFsrt(uMax = 1.0, uMin = -9999) annotation(
    Placement(visible = true, transformation(origin = {28, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addLoadLimitController annotation(
    Placement(visible = true, transformation(origin = {-38, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorKILoad(k = KILoadPu) annotation(
    Placement(visible = true, transformation(origin = {-104, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKPLoad(k = KPLoadPu) annotation(
    Placement(visible = true, transformation(origin = {-102, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max maxDm annotation(
    Placement(visible = true, transformation(origin = {160, 186}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min minDm annotation(
    Placement(visible = true, transformation(origin = {144, 158}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constZero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {84, 202}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constDm(k = DmPu) annotation(
    Placement(visible = true, transformation(origin = {86, 164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product prodOmegaDm annotation(
    Placement(visible = true, transformation(origin = {236, 180}, extent = {{8, -8}, {-8, 8}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression omegaPu4(y = omegaPu) annotation(
    Placement(visible = true, transformation(origin = {149, 227}, extent = {{-13, -9}, {13, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Product prodOmegaCfe annotation(
    Placement(visible = true, transformation(origin = {184, 114}, extent = {{-8, -8}, {8, 8}}, rotation = -180)));
  Dynawo.NonElectrical.Blocks.Continuous.PowerExternalBase expOmegaToTheDm annotation(
    Placement(visible = true, transformation(origin = {214, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constIsochronous(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-200, -156}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Sources.IntegerConstant constRSelect(k = RSelectInt) annotation(
    Placement(visible = true, transformation(origin = {-108, -160}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constDummy(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-154, -168}, extent = {{-4, -4}, {4, 4}}, rotation = 180)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchNoVector multiSwitchNoVector annotation(
    Placement(visible = true, transformation(origin = {-172, -156}, extent = {{5, -10}, {-5, 10}}, rotation = -90)));

equation
  connect(constPLdRef.y, gainOneOverKTurb.u) annotation(
    Line(points = {{-287, 144}, {-248, 144}}, color = {0, 0, 127}));
  connect(gainOneOverKTurb.y, addWFnlPldRef.u2) annotation(
    Line(points = {{-225, 144}, {-154, 144}}, color = {0, 0, 127}));
  connect(firstOrdertFLoad.u, transferFunctSAtSB.y) annotation(
    Line(points = {{46, 114}, {69, 114}}, color = {0, 0, 127}));
  connect(addPDmPTurbine.y, PMechPu) annotation(
    Line(points = {{287, 132}, {330, 132}}, color = {0, 0, 127}));
  connect(transferFunctCtB.y, addPDmPTurbine.u2) annotation(
    Line(points = {{256, 117}, {256, 126}, {264, 126}}, color = {0, 0, 127}));
  connect(gainKTurb.y, transferFunctCtB.u) annotation(
    Line(points = {{256, 85}, {256, 94}}, color = {0, 0, 127}));
  connect(delaytEngine.y, gainKTurb.u) annotation(
    Line(points = {{256, 35}, {256, 62}}, color = {0, 0, 127}));
  connect(addCfeWfnl.y, delaytEngine.u) annotation(
    Line(points = {{256, 5}, {256, 12}}, color = {0, 0, 127}));
  connect(prodWFSpdValveStroke.y, addCfeWfnl.u2) annotation(
    Line(points = {{252, -45.2}, {252, -25.7}, {250, -25.7}, {250, -18.2}}, color = {0, 0, 127}));
  connect(switchWFSpd.y, prodWFSpdValveStroke.u1) annotation(
    Line(points = {{272, -115}, {272, -73.5}, {257, -73.5}, {257, -64}}, color = {0, 0, 127}));
  connect(constOne.y, switchWFSpd.u3) annotation(
    Line(points = {{240, -168.1}, {240, -147.2}, {263.5, -147.2}, {263.5, -139.2}, {263, -139.2}}, color = {0, 0, 127}));
  connect(constWFSpd.y, switchWFSpd.u2) annotation(
    Line(points = {{272, -167.2}, {272, -138.4}}, color = {255, 0, 255}));
  connect(firstOrdertActuatorRatelim.y, prodWFSpdValveStroke.u2) annotation(
    Line(points = {{225, -88}, {248, -88}, {248, -64}}, color = {0, 0, 127}));
  connect(constROpen.y, firstOrdertActuatorRatelim.dyMax) annotation(
    Line(points = {{207.4, -58}, {181.4, -58}, {181.4, -81}, {201.4, -81}}, color = {0, 0, 127}));
  connect(limitValveMaxValveMin.y, firstOrdertActuatorRatelim.u) annotation(
    Line(points = {{141, -88}, {202, -88}}, color = {0, 0, 127}));
  connect(constRClose.y, firstOrdertActuatorRatelim.dyMin) annotation(
    Line(points = {{207.4, -114}, {182.4, -114}, {182.4, -94}, {202.4, -94}}, color = {0, 0, 127}));
  connect(constValveMin.y, limitValveMaxValveMin.limit2) annotation(
    Line(points = {{123.4, -112}, {109.4, -112}, {109.4, -96}, {117.4, -96}}, color = {0, 0, 127}));
  connect(gainOneOverKTurb2.y, addWfnlValvemax.u1) annotation(
    Line(points = {{140, -13}, {140, -22}}, color = {0, 0, 127}));
  connect(addCfeWfnl.u1, constWFnl2.y) annotation(
    Line(points = {{262, -18}, {262, -34}, {291, -34}}, color = {0, 0, 127}));
  connect(addWfnlValvemax.u2, constWFnl3.y) annotation(
    Line(points = {{152, -22}, {152, -16.5}, {174, -16.5}, {174, -13}}, color = {0, 0, 127}));
  connect(gainfNom.y, tablePLimFromf.u) annotation(
    Line(points = {{138, 51}, {138.5, 51}, {138.5, 44}, {138, 44}}, color = {0, 0, 127}));
  connect(omegaPu3.y, switchWFSpd.u1) annotation(
    Line(points = {{327, -157}, {282, -157}, {282, -138}, {279.7, -138}}, color = {0, 0, 127}));
  connect(omegaPu2.y, gainfNom.u) annotation(
    Line(points = {{142.7, 89}, {137.7, 89}, {137.7, 74}}, color = {0, 0, 127}));
  connect(addWfnlValvemax.y, rateLimitPRate.u) annotation(
    Line(points = {{146, -45}, {146, -51}, {162, -51}, {162, -23}, {176, -23}, {176, -27}}, color = {0, 0, 127}));
  connect(rateLimitPRate.y, limitValveMaxValveMin.limit1) annotation(
    Line(points = {{176, -44.8}, {176, -65.8}, {106, -65.8}, {106, -79.8}, {118, -79.8}}, color = {0, 0, 127}));
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
    Line(points = {{-89, -92}, {-75, -92}, {-75, -132}, {-64, -132}}, color = {0, 0, 127}));
  connect(gainKPGov.y, addGovController.u1) annotation(
    Line(points = {{-37, -54}, {-11, -54}, {-11, -84}, {-4, -84}}, color = {0, 0, 127}));
  connect(integratorKIGov.y, addGovController.u2) annotation(
    Line(points = {{-39, -92}, {-4, -92}}, color = {0, 0, 127}));
  connect(transferFuncKDGovTDGov.y, addGovController.u3) annotation(
    Line(points = {{-37, -132}, {-12.5, -132}, {-12.5, -100}, {-4, -100}}, color = {0, 0, 127}));
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
  connect(PElecPu, firstOrdertPElec.u) annotation(
    Line(points = {{-335, -183}, {-289, -183}, {-289, -182}, {-262, -182}}, color = {0, 0, 127}));
  connect(firstOrdertPElec.y, addPmwsetPefilt.u1) annotation(
    Line(points = {{-239, -182}, {-218, -182}, {-218, -165}, {-232, -165}, {-232, -160}}, color = {0, 0, 127}));
  connect(gainR.y, addDeltaOmega.u3) annotation(
    Line(points = {{-172, -112}, {-172, -108}, {-192, -108}, {-192, -100}, {-184, -100}}, color = {0, 0, 127}));
  connect(addFsrKaDeltat.y, minLowValueSelect.u2) annotation(
    Line(points = {{37, -18}, {50, -18}, {50, -28}, {60, -28}}, color = {0, 0, 127}));
  connect(limitValveMaxValveMin.y, addFsrKaDeltat.u2) annotation(
    Line(points = {{142, -88}, {158, -88}, {158, -180}, {26, -180}, {26, -34}, {6, -34}, {6, -24}, {14, -24}}, color = {0, 0, 127}));
  connect(gainKADeltat.y, addFsrKaDeltat.u1) annotation(
    Line(points = {{-9, -12}, {14, -12}}, color = {0, 0, 127}));
  connect(addAsetOmega.y, gainKADeltat.u) annotation(
    Line(points = {{-56, -12}, {-32, -12}}, color = {0, 0, 127}));
  connect(constASet.y, addAsetOmega.u1) annotation(
    Line(points = {{-167, 4}, {-94, 4}, {-94, -6}, {-80, -6}}, color = {0, 0, 127}));
  connect(transferFunctA.y, addAsetOmega.u2) annotation(
    Line(points = {{-129, -18}, {-80, -18}}, color = {0, 0, 127}));
  connect(transferFunctA.u, omegaPu) annotation(
    Line(points = {{-156, -18}, {-233, -18}, {-233, -19}, {-329, -19}}, color = {0, 0, 127}));
  connect(omegaPu, addDeltaOmega.u1) annotation(
    Line(points = {{-329, -19}, {-194, -19}, {-194, -84}, {-184, -84}}, color = {0, 0, 127}));
  connect(rateLimitFsrt.y, limitFsrt.u) annotation(
    Line(points = {{7, 40}, {16, 40}}, color = {0, 0, 127}));
  connect(limitFsrt.y, minLowValueSelect.u1) annotation(
    Line(points = {{39, 40}, {54, 40}, {54, -16}, {60, -16}}, color = {0, 0, 127}));
  connect(addLoadLimitController.y, rateLimitFsrt.u) annotation(
    Line(points = {{-27, 40}, {-16, 40}}, color = {0, 0, 127}));
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
  connect(transferFunctSAtSB.u, prodOmegaCfe.y) annotation(
    Line(points = {{92, 114}, {175, 114}}, color = {0, 0, 127}));
  connect(omegaPu4.y, prodOmegaDm.u2) annotation(
    Line(points = {{163, 227}, {214, 227}, {214, 184}, {226, 184}}, color = {0, 0, 127}));
  connect(omegaPu4.y, expOmegaToTheDm.u1) annotation(
    Line(points = {{163, 227}, {196, 227}, {196, 156}, {202, 156}}, color = {0, 0, 127}));
  connect(minDm.y, expOmegaToTheDm.u2) annotation(
    Line(points = {{155, 158}, {176, 158}, {176, 144}, {202, 144}}, color = {0, 0, 127}));
  connect(expOmegaToTheDm.y, prodOmegaCfe.u2) annotation(
    Line(points = {{226, 150}, {232, 150}, {232, 118}, {194, 118}}, color = {0, 0, 127}));
  connect(prodOmegaCfe.u1, prodWFSpdValveStroke.y) annotation(
    Line(points = {{194, 110}, {230, 110}, {230, -40}, {252, -40}, {252, -46}}, color = {0, 0, 127}));
  connect(PMwSetPu, addPmwsetPefilt.u2) annotation(
    Line(points = {{-332, -138}, {-286, -138}, {-286, -164}, {-244, -164}, {-244, -160}}, color = {0, 0, 127}));
  connect(tablePLimFromf.y[1], gainOneOverKTurb2.u) annotation(
    Line(points = {{138, 22}, {138, 18}, {140, 18}, {140, 10}}, color = {0, 0, 127}));
  connect(gainR.u, multiSwitchNoVector.y) annotation(
    Line(points = {{-172, -136}, {-172, -150}}, color = {0, 0, 127}));
  connect(multiSwitchNoVector.selection, constRSelect.y) annotation(
    Line(points = {{-160, -156}, {-134, -156}, {-134, -160}, {-118, -160}}, color = {255, 127, 0}));
  connect(multiSwitchNoVector.u0, constDummy.y) annotation(
    Line(points = {{-164, -162}, {-164, -168}, {-158, -168}}, color = {0, 0, 127}));
  connect(constIsochronous.y, multiSwitchNoVector.u4) annotation(
    Line(points = {{-200, -164}, {-200, -170}, {-180, -170}, {-180, -162}}, color = {0, 0, 127}));
  connect(firstOrdertPElec.y, multiSwitchNoVector.u3) annotation(
    Line(points = {{-238, -182}, {-176, -182}, {-176, -162}}, color = {0, 0, 127}));
  connect(multiSwitchNoVector.u2, firstOrdertActuatorRatelim.y) annotation(
    Line(points = {{-172, -162}, {-172, -190}, {200, -190}, {200, -140}, {240, -140}, {240, -88}, {226, -88}}, color = {0, 0, 127}));
  connect(multiSwitchNoVector.u1, limitValveMaxValveMin.y) annotation(
    Line(points = {{-168, -162}, {-168, -180}, {158, -180}, {158, -88}, {142, -88}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body>This generic governor model (CIM name GovCT2) can be used to represent a variety of prime movers controlled by PID governors. For more information, see IEC 61970-302.</body></html>"),
    Diagram(coordinateSystem(extent = {{-320, -200}, {320, 220}}), graphics = {Text(origin = {248, -35}, extent = {{-7, -3}, {7, 3}}, textString = "cfe"), Text(origin = {158, -84}, extent = {{-17, -4}, {17, 4}}, textString = "fsr"), Rectangle(origin = {157, 14}, lineColor = {0, 0, 255}, lineThickness = 0.75, extent = {{-41, 68}, {41, -68}}), Text(origin = {174, 45}, lineColor = {0, 0, 255}, extent = {{-23, -21}, {23, 21}}, textString = "frequency-
dependent
limit"), Text(origin = {135, -194}, extent = {{-44, -4}, {44, 4}}, textString = "valve stroke"), Text(origin = {85, -184}, extent = {{-30, -4}, {30, 4}}, textString = "governor output"), Rectangle(origin = {70, -20}, lineColor = {0, 0, 255}, lineThickness = 0.75, extent = {{-24, 86}, {24, -86}}), Text(origin = {-22, 120}, extent = {{-13, -4}, {13, 4}}, textString = "Texm"), Text(origin = {106, 125}, extent = {{-11, -3}, {11, 3}}, textString = "Tex"), Text(origin = {-70, 156}, extent = {{-13, -4}, {13, 4}}, textString = "tlim"), Text(origin = {73, 44}, lineColor = {0, 0, 255}, extent = {{-20, -18}, {20, 18}}, textString = "Low
Value
Select"), Text(origin = {182, 192}, extent = {{-17, -4}, {17, 4}}, textString = "dm>=0"), Text(origin = {168, 164}, extent = {{-17, -4}, {17, 4}}, textString = "dm<=0")}),
    Icon(coordinateSystem(extent = {{-320, -200}, {320, 220}}), graphics = {Text(origin = {7, 7}, extent = {{-279, 123}, {279, -123}}, textString = "GovCT2"), Rectangle(origin = {0, 10}, extent = {{-320, 210}, {320, -210}})}),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", variableFilter = ".*"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian");
end GovCT2;
