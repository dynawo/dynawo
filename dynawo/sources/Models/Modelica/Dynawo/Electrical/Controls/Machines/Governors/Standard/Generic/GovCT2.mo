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
  parameter Integer RSelect "Feedback signal for droop";
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
    Placement(visible = true, transformation(origin = {-317, 37}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-66, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PMechPu annotation(
    Placement(visible = true, transformation(origin = {300, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PElecPu annotation(
    Placement(visible = true, transformation(origin = {-315, -103}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-113, 33}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PMwSetPu annotation(
    Placement(visible = true, transformation(origin = {-315, -81}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-113, -23}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu annotation(
    Placement(visible = true, transformation(origin = {-315, -45}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-113, -45}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Math.Gain OneOverKTurb(k = 1/KTurbPu) annotation(
    Placement(visible = true, transformation(origin = {-30, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PLdref(k = PLdrefPu) annotation(
    Placement(visible = true, transformation(origin = {-74, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add AddWFnlPldref annotation(
    Placement(visible = true, transformation(origin = {12, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant WFnl(k = WFnlPu) annotation(
    Placement(visible = true, transformation(origin = {0, 230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add AddtLimtExm(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {38, 74}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder tFLoad(T = tFLoadSeconds) annotation(
    Placement(visible = true, transformation(origin = {80, 68}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction tSAtSB(a = {tSBSeconds, 1}, b = {tSASeconds, 1}) annotation(
    Placement(visible = true, transformation(origin = {114, 68}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add AddPDmPTurbine(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {276, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Dm(k = DmPu) annotation(
    Placement(visible = true, transformation(origin = {220, 116}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction tCtB(a = {tBSeconds, 1}, b = {tCSeconds, 1}) annotation(
    Placement(visible = true, transformation(origin = {256, 56}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain KTurb(k = KTurbPu) annotation(
    Placement(visible = true, transformation(origin = {256, 24}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.FixedDelay DelaytEngine(delayTime = tEngineSeconds) annotation(
    Placement(visible = true, transformation(origin = {256, -26}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add AddCfeWfnl(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {256, -56}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product MultWFSpdValveStroke annotation(
    Placement(visible = true, transformation(origin = {252, -104}, extent = {{8, -8}, {-8, 8}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch SwitchWFSpd annotation(
    Placement(visible = true, transformation(origin = {272, -176}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant one(k = 1) annotation(
    Placement(visible = true, transformation(origin = {240, -228}, extent = {{9, -9}, {-9, 9}}, rotation = -90)));
  Modelica.Blocks.Sources.BooleanConstant WFSpd(k = WFSpdBool) annotation(
    Placement(visible = true, transformation(origin = {272, -226}, extent = {{8, -8}, {-8, 8}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze tActuatorRatelim(T = tActuatorSeconds, UseRateLim = true) annotation(
    Placement(visible = true, transformation(origin = {214, -138}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant ROpen(k = ROpenPu) annotation(
    Placement(visible = true, transformation(origin = {214, -108}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter ValveMaxValveMin annotation(
    Placement(visible = true, transformation(origin = {130, -138}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant RClose(k = RClosePu) annotation(
    Placement(visible = true, transformation(origin = {214, -164}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant ValveMin(k = ValveMinPu) annotation(
    Placement(visible = true, transformation(origin = {130, -162}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.StandAloneRampRateLimiter PRate(DuMax = PRatePu) annotation(
    Placement(visible = true, transformation(origin = {176, -86}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Math.Gain fNom(k = fNomHz) annotation(
    Placement(visible = true, transformation(origin = {138, 12}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain OneOverKTurb2(k = 1/KTurbPu) annotation(
    Placement(visible = true, transformation(origin = {140, -52}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add AddWfnlValvemax(k1 = +1) annotation(
    Placement(visible = true, transformation(origin = {146, -84}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant WFnl3(k = WFnlPu) annotation(
    Placement(visible = true, transformation(origin = {174, -52}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant WFnl2(k = WFnlPu) annotation(
    Placement(visible = true, transformation(origin = {314, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Tables.CombiTable1Ds PLimFromf(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = PLimFromfPoints, tableOnFile = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {138, -18}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression omegaPu2(y = omegaPu) annotation(
    Placement(visible = true, transformation(origin = {157, 39}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression omegaPu3(y = omegaPu) annotation(
    Placement(visible = true, transformation(origin = {303, -209}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Min LowValueSelect annotation(
    Placement(visible = true, transformation(origin = {68, -108}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min LowValueSelect2 annotation(
    Placement(visible = true, transformation(origin = {69, -137}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Gain KPGov(k = KPGovPu) annotation(
    Placement(visible = true, transformation(origin = {-48, -104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction KDGovTDGov(a = {TDGovSeconds, 1}, b = {KDGovPu, 0}) annotation(
    Placement(visible = true, transformation(origin = {-47, -185}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = KIGovPu)  annotation(
    Placement(visible = true, transformation(origin = {-50, -142}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone DeltaOmegaDb(uMax = DeltaOmegaDbPu)  annotation(
    Placement(visible = true, transformation(origin = {-132, -142}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter DeltaOmegaMinMax(uMax = DeltaOmegaMaxPu, uMin = DeltaOmegaMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-100, -142}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 AddGovController annotation(
    Placement(visible = true, transformation(origin = {22, -142}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = -1, k3 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-172, -142}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(PLdref.y, OneOverKTurb.u) annotation(
    Line(points = {{-63, 94}, {-43, 94}}, color = {0, 0, 127}));
  connect(OneOverKTurb.y, AddWFnlPldref.u2) annotation(
    Line(points = {{-19, 94}, {-1, 94}}, color = {0, 0, 127}));
  connect(WFnl.y, AddWFnlPldref.u1) annotation(
    Line(points = {{0, 219}, {0, 106}}, color = {0, 0, 127}));
  connect(AddWFnlPldref.y, AddtLimtExm.u1) annotation(
    Line(points = {{23, 100}, {55, 100}, {55, 80}, {49, 80}}, color = {0, 0, 127}));
  connect(tFLoad.y, AddtLimtExm.u2) annotation(
    Line(points = {{69, 68}, {50, 68}}, color = {0, 0, 127}));
  connect(tFLoad.u, tSAtSB.y) annotation(
    Line(points = {{92, 68}, {103, 68}}, color = {0, 0, 127}));
  connect(AddPDmPTurbine.y, PMechPu) annotation(
    Line(points = {{287, 82}, {300, 82}}, color = {0, 0, 127}));
  connect(Dm.y, AddPDmPTurbine.u1) annotation(
    Line(points = {{226.6, 116}, {256.6, 116}, {256.6, 88}, {264.6, 88}}, color = {0, 0, 127}));
  connect(tCtB.y, AddPDmPTurbine.u2) annotation(
    Line(points = {{256, 67}, {256, 76}, {264, 76}}, color = {0, 0, 127}));
  connect(KTurb.y, tCtB.u) annotation(
    Line(points = {{256, 35}, {256, 44}}, color = {0, 0, 127}));
  connect(DelaytEngine.y, KTurb.u) annotation(
    Line(points = {{256, -15}, {256, 12}}, color = {0, 0, 127}));
  connect(AddCfeWfnl.y, DelaytEngine.u) annotation(
    Line(points = {{256, -45}, {256, -38}}, color = {0, 0, 127}));
  connect(MultWFSpdValveStroke.y, AddCfeWfnl.u2) annotation(
    Line(points = {{252, -95.2}, {252, -75.7}, {250, -75.7}, {250, -68.2}}, color = {0, 0, 127}));
  connect(SwitchWFSpd.y, MultWFSpdValveStroke.u1) annotation(
    Line(points = {{272, -165}, {272, -123.5}, {257, -123.5}, {257, -114}}, color = {0, 0, 127}));
  connect(one.y, SwitchWFSpd.u3) annotation(
    Line(points = {{240, -218.1}, {240, -197.2}, {263.5, -197.2}, {263.5, -189.2}, {263, -189.2}}, color = {0, 0, 127}));
  connect(WFSpd.y, SwitchWFSpd.u2) annotation(
    Line(points = {{272, -217.2}, {272, -188.4}}, color = {255, 0, 255}));
  connect(tActuatorRatelim.y, MultWFSpdValveStroke.u2) annotation(
    Line(points = {{225, -138}, {248, -138}, {248, -114}}, color = {0, 0, 127}));
  connect(ROpen.y, tActuatorRatelim.dyMax) annotation(
    Line(points = {{207.4, -108}, {181.4, -108}, {181.4, -131}, {201.4, -131}}, color = {0, 0, 127}));
  connect(ValveMaxValveMin.y, tActuatorRatelim.u) annotation(
    Line(points = {{141, -138}, {202, -138}}, color = {0, 0, 127}));
  connect(RClose.y, tActuatorRatelim.dyMin) annotation(
    Line(points = {{207.4, -164}, {182.4, -164}, {182.4, -144}, {202.4, -144}}, color = {0, 0, 127}));
  connect(ValveMin.y, ValveMaxValveMin.limit2) annotation(
    Line(points = {{123.4, -162}, {109.4, -162}, {109.4, -146}, {117.4, -146}}, color = {0, 0, 127}));
  connect(OneOverKTurb2.y, AddWfnlValvemax.u1) annotation(
    Line(points = {{140, -63}, {140, -72}}, color = {0, 0, 127}));
  connect(AddCfeWfnl.u1, WFnl2.y) annotation(
    Line(points = {{262, -68}, {262, -82}, {303, -82}}, color = {0, 0, 127}));
  connect(AddWfnlValvemax.u2, WFnl3.y) annotation(
    Line(points = {{152, -72}, {152, -66.5}, {174, -66.5}, {174, -63}}, color = {0, 0, 127}));
  connect(fNom.y, PLimFromf.u) annotation(
    Line(points = {{138, 1}, {138.5, 1}, {138.5, -6}, {138, -6}}, color = {0, 0, 127}));
  connect(PLimFromf.y, OneOverKTurb2.u) annotation(
    Line(points = {{138, -29}, {138, -35}, {140, -35}, {140, -41}}, color = {0, 0, 127}));
  connect(omegaPu3.y, SwitchWFSpd.u1) annotation(
    Line(points = {{288.7, -209}, {279.7, -209}, {279.7, -188}}, color = {0, 0, 127}));
  connect(omegaPu2.y, fNom.u) annotation(
    Line(points = {{142.7, 39}, {137.7, 39}, {137.7, 24}}, color = {0, 0, 127}));
  connect(AddWfnlValvemax.y, PRate.u) annotation(
    Line(points = {{146, -95}, {146, -101}, {162, -101}, {162, -73}, {176, -73}, {176, -77}}, color = {0, 0, 127}));
  connect(PRate.y, ValveMaxValveMin.limit1) annotation(
    Line(points = {{176, -94.8}, {176, -115.8}, {106, -115.8}, {106, -129.8}, {118, -129.8}}, color = {0, 0, 127}));
  connect(LowValueSelect.y, LowValueSelect2.u1) annotation(
    Line(points = {{79, -108}, {80.5, -108}, {80.5, -122}, {49.25, -122}, {49.25, -134}, {53.625, -134}, {53.625, -132}, {58, -132}}, color = {0, 0, 127}));
  connect(LowValueSelect2.y, ValveMaxValveMin.u) annotation(
    Line(points = {{78.9, -137}, {100.9, -137}, {100.9, -139}, {118.9, -139}}, color = {0, 0, 127}));
  connect(DeltaOmegaDb.y, DeltaOmegaMinMax.u) annotation(
    Line(points = {{-121, -142}, {-113, -142}}, color = {0, 0, 127}));
  connect(DeltaOmegaMinMax.y, integrator.u) annotation(
    Line(points = {{-89, -142}, {-63, -142}}, color = {0, 0, 127}));
  connect(DeltaOmegaMinMax.y, KPGov.u) annotation(
    Line(points = {{-89, -142}, {-81, -142}, {-81, -104}, {-61, -104}}, color = {0, 0, 127}));
  connect(DeltaOmegaMinMax.y, KDGovTDGov.u) annotation(
    Line(points = {{-89, -142}, {-75, -142}, {-75, -184}, {-65, -184}}, color = {0, 0, 127}));
  connect(KPGov.y, AddGovController.u1) annotation(
    Line(points = {{-37, -104}, {-11, -104}, {-11, -134}, {9, -134}}, color = {0, 0, 127}));
  connect(integrator.y, AddGovController.u2) annotation(
    Line(points = {{-39, -142}, {9, -142}}, color = {0, 0, 127}));
  connect(KDGovTDGov.y, AddGovController.u3) annotation(
    Line(points = {{-30.5, -185}, {-12.5, -185}, {-12.5, -151}, {9.5, -151}}, color = {0, 0, 127}));
  connect(AddGovController.y, LowValueSelect2.u2) annotation(
    Line(points = {{33, -142}, {58, -142}}, color = {0, 0, 127}));
  connect(add3.y, DeltaOmegaDb.u) annotation(
    Line(points = {{-160, -142}, {-144, -142}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body>This generic governor model (CIM name GovCT2) can be used to represent a variety of prime movers controlled by PID governors. For more information, see IEC 61970-302.</body></html>"),
    Diagram(coordinateSystem(extent = {{-300, -200}, {300, 200}}), graphics = {Text(origin = {248, -85}, extent = {{-7, -3}, {7, 3}}, textString = "cfe"), Text(origin = {158, -134}, extent = {{-17, -4}, {17, 4}}, textString = "fsr"), Rectangle(origin = {157, -36}, lineColor = {0, 0, 255}, lineThickness = 0.75, extent = {{-41, 68}, {41, -68}}), Text(origin = {175, -6}, textColor = {0, 0, 255}, extent = {{-20, -18}, {20, 18}}, textString = "frequency-
dependent
limit")}),
    Icon(coordinateSystem(extent = {{-300, -200}, {300, 200}})));
end GovCT2;
