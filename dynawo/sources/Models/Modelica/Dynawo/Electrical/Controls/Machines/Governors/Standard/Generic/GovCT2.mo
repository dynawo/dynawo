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
  parameter Types.PerUnit aSetPu "Acceleration limiter setpoint in pu/s";
  parameter Types.PerUnit DeltaOmegaDbPu "Speed governor deadband in PU speed.";
  parameter Types.PerUnit DeltaOmegaMaxPu "Maximum value for speed error signal in pu";
  parameter Types.PerUnit DeltaOmegaMinPu "Minimum value for speed error signal in pu";
  parameter Types.Time DeltaTSeconds "Correction factor to adapt the unit of the acceleration limiter gain from pu/s to pu in s";
  parameter Types.PerUnit DmPu "Speed sensitivity coefficient in pu";
  parameter Types.Frequency fLim1Hz "Frequency threshold 1 in Hz";
  parameter Types.Frequency fLim10Hz "Frequency threshold 10 in Hz";
  parameter Types.Frequency fLim2Hz "Frequency threshold 2 in Hz";
  parameter Types.Frequency fLim3Hz "Frequency threshold 3 in Hz";
  parameter Types.Frequency fLim4Hz "Frequency threshold 4 in Hz";
  parameter Types.Frequency fLim5Hz "Frequency threshold 5 in Hz";
  parameter Types.Frequency fLim6Hz "Frequency threshold 6 in Hz";
  parameter Types.Frequency fLim7Hz "Frequency threshold 7 in Hz";
  parameter Types.Frequency fLim8Hz "Frequency threshold 8 in Hz";
  parameter Types.Frequency fLim9Hz "Frequency threshold 9 in Hz";
  parameter Types.Frequency fNomHz "Nominal Frequency in Hz";
  parameter Types.PerUnit KaPu "Acceleration limiter gain in pu";
  parameter Types.PerUnit KDGovPu "Governor derivative gain in pu";
  parameter Types.PerUnit KIGovPu "Governor integral gain in pu";
  parameter Types.PerUnit KILoadPu "Load limiter integral gain for PI controller in pu";
  parameter Types.PerUnit KIMwPu "Power controller gain in pu";
  parameter Types.PerUnit KPGovPu "Governor proportional gain in pu";
  parameter Types.PerUnit KPLoadPu "Load limiter proportional gain for PI controller in pu";
  parameter Types.PerUnit KTurbPu "Turbine gain in pu";
  parameter Types.ActivePower PBaseMw "Base for power values (> 0) in MW";
  parameter Types.ActivePowerPu PLdRefPu "Load limiter reference value in pu (base PBaseMw)";
  parameter Types.ActivePowerPu PLim1Pu "Power limit 1 in pu (base PBaseMw)";
  parameter Types.ActivePowerPu PLim10Pu "Power limit 10 in pu (base PBaseMw)";
  parameter Types.ActivePowerPu PLim2Pu "Power limit 2 in pu (base PBaseMw)";
  parameter Types.ActivePowerPu PLim3Pu "Power limit 3 in pu (base PBaseMw)";
  parameter Types.ActivePowerPu PLim4Pu "Power limit 4 in pu (base PBaseMw)";
  parameter Types.ActivePowerPu PLim5Pu "Power limit 5 in pu (base PBaseMw)";
  parameter Types.ActivePowerPu PLim6Pu "Power limit 6 in pu (base PBaseMw)";
  parameter Types.ActivePowerPu PLim7Pu "Power limit 7 in pu (base PBaseMw)";
  parameter Types.ActivePowerPu PLim8Pu "Power limit 8 in pu (base PBaseMw)";
  parameter Types.ActivePowerPu PLim9Pu "Power Limit 9 in pu (base PBaseMw)";
  parameter Types.ActivePowerPu PLimFromfPoints[:, :] = [fLim1Hz + 0.000001, (ValveMaxPu - WFnlPu)*KTurbPu; // above fLim1Hz, jump to power associated with ValveMaxPu
  fLim1Hz, PLim1Pu; fLim1Hz, PLim1Pu; fLim1Hz, PLim1Pu; fLim1Hz, PLim1Pu; fLim1Hz, PLim1Pu; fLim1Hz, PLim1Pu; fLim1Hz, PLim1Pu; fLim1Hz, PLim1Pu; fLim1Hz, PLim1Pu; fLim1Hz, PLim1Pu] "Pair of points for frequency-dependent active power limit piecewise linear curve [u1,y1; u2,y2;...]";
  parameter Types.PerUnit PRatePu "Ramp rate for frequency-dependent power limit";
  parameter Types.PerUnit RPu "Permanent droop in pu";
  parameter Types.PerUnit RClosePu "Minimum valve closing rate in pu/s";
  parameter Types.PerUnit RDownPu "Maximum rate of load limit decrease in pu";
  parameter Types.PerUnit ROpenPu "Maximum valve opening rate in pu/s";
  parameter Integer RSelectInt "Feedback signal for droop";
  parameter Types.PerUnit RUpPu "Maximum rate of load limit increase in pu";
  parameter Types.Time tASeconds "Acceleration limiter time constant in s";
  parameter Types.Time tActuatorSeconds "Actuator time constant in s";
  parameter Types.Time tBSeconds "Turbine lag time constant in s";
  parameter Types.Time tCSeconds "Turbine lead time constant in s";
  parameter Types.Time tDGovSeconds "Governor derivative controller time constant in s";
  parameter Types.Time tEngineSeconds "Transport time delay for diesel engine in s";
  parameter Types.Time tFLoadSeconds "Load limiter time constant in s";
  parameter Types.Time tPElecSeconds "Electrical power transducer time constant in s";
  parameter Types.Time tSASeconds "Temperature detection lead time constant in s";
  parameter Types.Time tSBSeconds "Temperature detection lag time constant in s";
  parameter Types.Time ValveMaxPu "Maximum valve position limit in pu";
  parameter Types.Time ValveMinPu "Minimum valve position limit in pu";
  parameter Types.Time WFnlPu "No load fuel flow in pu";
  parameter Boolean WFSpdBool "Switch for fuel source characteristic";
  Modelica.Blocks.Interfaces.RealInput omegaPu annotation(
    Placement(visible = true, transformation(origin = {-317, 87}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-66, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PMechPu annotation(
    Placement(visible = true, transformation(origin = {300, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PElecPu annotation(
    Placement(visible = true, transformation(origin = {-317, -183}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-113, 33}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PMwSetPu annotation(
    Placement(visible = true, transformation(origin = {-315, -139}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-113, -23}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu annotation(
    Placement(visible = true, transformation(origin = {-315, 5}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-113, -45}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Math.Gain OneOverKTurb(k = 1/KTurbPu) annotation(
    Placement(visible = true, transformation(origin = {-30, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PLdref(k = PLdrefPu) annotation(
    Placement(visible = true, transformation(origin = {-74, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add AddWFnlPldref annotation(
    Placement(visible = true, transformation(origin = {12, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant WFnl(k = WFnlPu) annotation(
    Placement(visible = true, transformation(origin = {0, 280}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add AddtLimtExm(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {38, 124}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder tFLoad(T = tFLoadSeconds) annotation(
    Placement(visible = true, transformation(origin = {80, 118}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction tSAtSB(a = {tSBSeconds, 1}, b = {tSASeconds, 1}) annotation(
    Placement(visible = true, transformation(origin = {114, 118}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add AddPDmPTurbine(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {276, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Dm(k = DmPu) annotation(
    Placement(visible = true, transformation(origin = {220, 166}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction tCtB(a = {tBSeconds, 1}, b = {tCSeconds, 1}) annotation(
    Placement(visible = true, transformation(origin = {256, 106}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain KTurb(k = KTurbPu) annotation(
    Placement(visible = true, transformation(origin = {256, 74}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.FixedDelay DelaytEngine(delayTime = tEngineSeconds) annotation(
    Placement(visible = true, transformation(origin = {256, 24}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add AddCfeWfnl(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {256, -6}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product MultWFSpdValveStroke annotation(
    Placement(visible = true, transformation(origin = {252, -54}, extent = {{8, -8}, {-8, 8}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch SwitchWFSpd annotation(
    Placement(visible = true, transformation(origin = {272, -126}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant one(k = 1) annotation(
    Placement(visible = true, transformation(origin = {240, -178}, extent = {{9, -9}, {-9, 9}}, rotation = -90)));
  Modelica.Blocks.Sources.BooleanConstant WFSpd(k = WFSpdBool) annotation(
    Placement(visible = true, transformation(origin = {272, -176}, extent = {{8, -8}, {-8, 8}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze tActuatorRatelim(T = tActuatorSeconds, UseRateLim = true) annotation(
    Placement(visible = true, transformation(origin = {214, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant ROpen(k = ROpenPu) annotation(
    Placement(visible = true, transformation(origin = {214, -58}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter ValveMaxValveMin annotation(
    Placement(visible = true, transformation(origin = {130, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant RClose(k = RClosePu) annotation(
    Placement(visible = true, transformation(origin = {214, -114}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant ValveMin(k = ValveMinPu) annotation(
    Placement(visible = true, transformation(origin = {130, -112}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.StandAloneRampRateLimiter PRate(DuMax = PRatePu) annotation(
    Placement(visible = true, transformation(origin = {176, -36}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Math.Gain fNom(k = fNomHz) annotation(
    Placement(visible = true, transformation(origin = {138, 62}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain OneOverKTurb2(k = 1/KTurbPu) annotation(
    Placement(visible = true, transformation(origin = {140, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add AddWfnlValvemax(k1 = +1) annotation(
    Placement(visible = true, transformation(origin = {146, -34}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant WFnl3(k = WFnlPu) annotation(
    Placement(visible = true, transformation(origin = {174, -2}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant WFnl2(k = WFnlPu) annotation(
    Placement(visible = true, transformation(origin = {314, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Tables.CombiTable1Ds PLimFromf(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = PLimFromfPoints, tableOnFile = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {138, 32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression omegaPu2(y = omegaPu) annotation(
    Placement(visible = true, transformation(origin = {157, 89}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression omegaPu3(y = omegaPu) annotation(
    Placement(visible = true, transformation(origin = {303, -159}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Min LowValueSelect annotation(
    Placement(visible = true, transformation(origin = {68, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min LowValueSelect2 annotation(
    Placement(visible = true, transformation(origin = {69, -87}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Gain KPGov(k = KPGovPu) annotation(
    Placement(visible = true, transformation(origin = {-48, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction KDGovTDGov(a = {TDGovSeconds, 1}, b = {KDGovPu, 0}) annotation(
    Placement(visible = true, transformation(origin = {-47, -135}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = KIGovPu) annotation(
    Placement(visible = true, transformation(origin = {-50, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone DeltaOmegaDb(uMax = DeltaOmegaDbPu) annotation(
    Placement(visible = true, transformation(origin = {-132, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter DeltaOmegaMinMax(uMax = DeltaOmegaMaxPu, uMin = DeltaOmegaMinPu) annotation(
    Placement(visible = true, transformation(origin = {-100, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 AddGovController annotation(
    Placement(visible = true, transformation(origin = {22, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 AddDeltaOmega(k1 = -1, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-172, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add AddSupervisoryLoadController annotation(
    Placement(visible = true, transformation(origin = {-216, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedIntegrator KIMw(K = KIMwPu, YMax = 1.1*RPu, YMin = -1.1*RPu)  annotation(
    Placement(visible = true, transformation(origin = {-238, -120}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add AddPmwsetPefilt(k1 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-238, -148}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.FirstOrder tPElec(T = tPElecSeconds)  annotation(
    Placement(visible = true, transformation(origin = {-276, -182}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain R(k = RPu) annotation(
    Placement(visible = true, transformation(origin = {-190, -120}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch RSelectSwitch(nu = 4)  annotation(
    Placement(visible = true, transformation(origin = {-189, -157}, extent = {{13, -13}, {-13, 13}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant Isochronous(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-196, -224}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant RSelect(k = RSelectInt)  annotation(
    Placement(visible = true, transformation(origin = {-112, -154}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(PLdref.y, OneOverKTurb.u) annotation(
    Line(points = {{-63, 144}, {-43, 144}}, color = {0, 0, 127}));
  connect(OneOverKTurb.y, AddWFnlPldref.u2) annotation(
    Line(points = {{-19, 144}, {-1, 144}}, color = {0, 0, 127}));
  connect(WFnl.y, AddWFnlPldref.u1) annotation(
    Line(points = {{0, 269}, {0, 156}}, color = {0, 0, 127}));
  connect(AddWFnlPldref.y, AddtLimtExm.u1) annotation(
    Line(points = {{23, 150}, {55, 150}, {55, 130}, {49, 130}}, color = {0, 0, 127}));
  connect(tFLoad.y, AddtLimtExm.u2) annotation(
    Line(points = {{69, 118}, {50, 118}}, color = {0, 0, 127}));
  connect(tFLoad.u, tSAtSB.y) annotation(
    Line(points = {{92, 118}, {103, 118}}, color = {0, 0, 127}));
  connect(AddPDmPTurbine.y, PMechPu) annotation(
    Line(points = {{287, 132}, {300, 132}}, color = {0, 0, 127}));
  connect(Dm.y, AddPDmPTurbine.u1) annotation(
    Line(points = {{226.6, 166}, {256.6, 166}, {256.6, 138}, {264.6, 138}}, color = {0, 0, 127}));
  connect(tCtB.y, AddPDmPTurbine.u2) annotation(
    Line(points = {{256, 117}, {256, 126}, {264, 126}}, color = {0, 0, 127}));
  connect(KTurb.y, tCtB.u) annotation(
    Line(points = {{256, 85}, {256, 94}}, color = {0, 0, 127}));
  connect(DelaytEngine.y, KTurb.u) annotation(
    Line(points = {{256, 35}, {256, 62}}, color = {0, 0, 127}));
  connect(AddCfeWfnl.y, DelaytEngine.u) annotation(
    Line(points = {{256, 5}, {256, 12}}, color = {0, 0, 127}));
  connect(MultWFSpdValveStroke.y, AddCfeWfnl.u2) annotation(
    Line(points = {{252, -45.2}, {252, -25.7}, {250, -25.7}, {250, -18.2}}, color = {0, 0, 127}));
  connect(SwitchWFSpd.y, MultWFSpdValveStroke.u1) annotation(
    Line(points = {{272, -115}, {272, -73.5}, {257, -73.5}, {257, -64}}, color = {0, 0, 127}));
  connect(one.y, SwitchWFSpd.u3) annotation(
    Line(points = {{240, -168.1}, {240, -147.2}, {263.5, -147.2}, {263.5, -139.2}, {263, -139.2}}, color = {0, 0, 127}));
  connect(WFSpd.y, SwitchWFSpd.u2) annotation(
    Line(points = {{272, -167.2}, {272, -138.4}}, color = {255, 0, 255}));
  connect(tActuatorRatelim.y, MultWFSpdValveStroke.u2) annotation(
    Line(points = {{225, -88}, {248, -88}, {248, -64}}, color = {0, 0, 127}));
  connect(ROpen.y, tActuatorRatelim.dyMax) annotation(
    Line(points = {{207.4, -58}, {181.4, -58}, {181.4, -81}, {201.4, -81}}, color = {0, 0, 127}));
  connect(ValveMaxValveMin.y, tActuatorRatelim.u) annotation(
    Line(points = {{141, -88}, {202, -88}}, color = {0, 0, 127}));
  connect(RClose.y, tActuatorRatelim.dyMin) annotation(
    Line(points = {{207.4, -114}, {182.4, -114}, {182.4, -94}, {202.4, -94}}, color = {0, 0, 127}));
  connect(ValveMin.y, ValveMaxValveMin.limit2) annotation(
    Line(points = {{123.4, -112}, {109.4, -112}, {109.4, -96}, {117.4, -96}}, color = {0, 0, 127}));
  connect(OneOverKTurb2.y, AddWfnlValvemax.u1) annotation(
    Line(points = {{140, -13}, {140, -22}}, color = {0, 0, 127}));
  connect(AddCfeWfnl.u1, WFnl2.y) annotation(
    Line(points = {{262, -18}, {262, -32}, {303, -32}}, color = {0, 0, 127}));
  connect(AddWfnlValvemax.u2, WFnl3.y) annotation(
    Line(points = {{152, -22}, {152, -16.5}, {174, -16.5}, {174, -13}}, color = {0, 0, 127}));
  connect(fNom.y, PLimFromf.u) annotation(
    Line(points = {{138, 51}, {138.5, 51}, {138.5, 44}, {138, 44}}, color = {0, 0, 127}));
  connect(PLimFromf.y, OneOverKTurb2.u) annotation(
    Line(points = {{138, 21}, {138, 15}, {140, 15}, {140, 9}}, color = {0, 0, 127}));
  connect(omegaPu3.y, SwitchWFSpd.u1) annotation(
    Line(points = {{288.7, -159}, {279.7, -159}, {279.7, -138}}, color = {0, 0, 127}));
  connect(omegaPu2.y, fNom.u) annotation(
    Line(points = {{142.7, 89}, {137.7, 89}, {137.7, 74}}, color = {0, 0, 127}));
  connect(AddWfnlValvemax.y, PRate.u) annotation(
    Line(points = {{146, -45}, {146, -51}, {162, -51}, {162, -23}, {176, -23}, {176, -27}}, color = {0, 0, 127}));
  connect(PRate.y, ValveMaxValveMin.limit1) annotation(
    Line(points = {{176, -44.8}, {176, -65.8}, {106, -65.8}, {106, -79.8}, {118, -79.8}}, color = {0, 0, 127}));
  connect(LowValueSelect.y, LowValueSelect2.u1) annotation(
    Line(points = {{79, -58}, {80.5, -58}, {80.5, -72}, {49.25, -72}, {49.25, -84}, {53.625, -84}, {53.625, -82}, {58, -82}}, color = {0, 0, 127}));
  connect(LowValueSelect2.y, ValveMaxValveMin.u) annotation(
    Line(points = {{78.9, -87}, {100.9, -87}, {100.9, -89}, {118.9, -89}}, color = {0, 0, 127}));
  connect(DeltaOmegaDb.y, DeltaOmegaMinMax.u) annotation(
    Line(points = {{-121, -92}, {-113, -92}}, color = {0, 0, 127}));
  connect(DeltaOmegaMinMax.y, integrator.u) annotation(
    Line(points = {{-89, -92}, {-63, -92}}, color = {0, 0, 127}));
  connect(DeltaOmegaMinMax.y, KPGov.u) annotation(
    Line(points = {{-89, -92}, {-81, -92}, {-81, -54}, {-61, -54}}, color = {0, 0, 127}));
  connect(DeltaOmegaMinMax.y, KDGovTDGov.u) annotation(
    Line(points = {{-89, -92}, {-75, -92}, {-75, -134}, {-65, -134}}, color = {0, 0, 127}));
  connect(KPGov.y, AddGovController.u1) annotation(
    Line(points = {{-37, -54}, {-11, -54}, {-11, -84}, {9, -84}}, color = {0, 0, 127}));
  connect(integrator.y, AddGovController.u2) annotation(
    Line(points = {{-39, -92}, {9, -92}}, color = {0, 0, 127}));
  connect(KDGovTDGov.y, AddGovController.u3) annotation(
    Line(points = {{-30.5, -135}, {-12.5, -135}, {-12.5, -101}, {9.5, -101}}, color = {0, 0, 127}));
  connect(AddGovController.y, LowValueSelect2.u2) annotation(
    Line(points = {{33, -92}, {58, -92}}, color = {0, 0, 127}));
  connect(AddDeltaOmega.y, DeltaOmegaDb.u) annotation(
    Line(points = {{-161, -92}, {-145, -92}}, color = {0, 0, 127}));
  connect(omegaPu, AddDeltaOmega.u1) annotation(
    Line(points = {{-317, 87}, {-195, 87}, {-195, -85}, {-185, -85}}, color = {0, 0, 127}));
  connect(AddSupervisoryLoadController.y, AddDeltaOmega.u2) annotation(
    Line(points = {{-205, -92}, {-184, -92}}, color = {0, 0, 127}));
  connect(PRefPu, AddSupervisoryLoadController.u1) annotation(
    Line(points = {{-315, 5}, {-271, 5}, {-271, -87}, {-229, -87}}, color = {0, 0, 127}));
  connect(KIMw.y, AddSupervisoryLoadController.u2) annotation(
    Line(points = {{-238, -109}, {-238, -98}, {-228, -98}}, color = {0, 0, 127}));
  connect(AddPmwsetPefilt.y, KIMw.u) annotation(
    Line(points = {{-238, -137}, {-238, -132}}, color = {0, 0, 127}));
  connect(PMwSetPu, AddPmwsetPefilt.u2) annotation(
    Line(points = {{-314, -138}, {-266, -138}, {-266, -166}, {-244, -166}, {-244, -160}}, color = {0, 0, 127}));
  connect(PElecPu, tPElec.u) annotation(
    Line(points = {{-316, -182}, {-288, -182}}, color = {0, 0, 127}));
  connect(tPElec.y, AddPmwsetPefilt.u1) annotation(
    Line(points = {{-264, -182}, {-232, -182}, {-232, -160}}, color = {0, 0, 127}));
  connect(R.y, AddDeltaOmega.u3) annotation(
    Line(points = {{-190, -109}, {-190, -100}, {-184, -100}}, color = {0, 0, 127}));
  connect(Isochronous.y, RSelectSwitch.u[1]) annotation(
    Line(points = {{-184, -224}, {-151, -224}, {-151, -170}, {-189, -170}}, color = {0, 0, 127}));
  connect(tPElec.y, RSelectSwitch.u[2]) annotation(
    Line(points = {{-264, -182}, {-151, -182}, {-151, -170}, {-189, -170}}, color = {0, 0, 127}));
  connect(tActuatorRatelim.y, RSelectSwitch.u[3]) annotation(
    Line(points = {{226, -88}, {230, -88}, {230, -150}, {0, -150}, {0, -208}, {-150, -208}, {-150, -170}, {-189, -170}}, color = {0, 0, 127}));
  connect(ValveMaxValveMin.y, RSelectSwitch.u[4]) annotation(
    Line(points = {{142, -88}, {160, -88}, {160, -146}, {-6, -146}, {-6, -202}, {-150, -202}, {-150, -170}, {-189, -170}}, color = {0, 0, 127}));
  connect(RSelectSwitch.f, RSelect.y) annotation(
    Line(points = {{-173, -157}, {-129.5, -157}, {-129.5, -154}, {-123, -154}}, color = {255, 127, 0}));
  connect(RSelectSwitch.y, R.u) annotation(
    Line(points = {{-189, -143}, {-189, -136}, {-190, -136}, {-190, -132}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body>This generic governor model (CIM name GovCT2) can be used to represent a variety of prime movers controlled by PID governors. For more information, see IEC 61970-302.</body></html>"),
    Diagram(coordinateSystem(extent = {{-300, -200}, {300, 200}}), graphics = {Text(origin = {248, -35}, extent = {{-7, -3}, {7, 3}}, textString = "cfe"), Text(origin = {158, -84}, extent = {{-17, -4}, {17, 4}}, textString = "fsr"), Rectangle(origin = {157, 14}, lineColor = {0, 0, 255}, lineThickness = 0.75, extent = {{-41, 68}, {41, -68}}), Text(origin = {175, 44}, textColor = {0, 0, 255}, extent = {{-20, -18}, {20, 18}}, textString = "frequency-
dependent
limit")}),
    Icon(coordinateSystem(extent = {{-300, -200}, {300, 200}})));
end GovCT2;
