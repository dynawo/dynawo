within Dynawo.Electrical.Controls.Machines.Governors.Standard.Generic;

model GovCT2_MWE "IEEE Governor type TGOV1"
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
  parameter Types.ActivePowerPu PLimFromfPoints[:, :] = [fLim10Hz, PLim10Pu; fLim9Hz, PLim9Pu; fLim8Hz, PLim8Pu; fLim7Hz, PLim7Pu; fLim6Hz, PLim6Pu; fLim5Hz, PLim5Pu; fLim4Hz, PLim4Pu; fLim3Hz, PLim3Pu; fLim2Hz, PLim2Pu; fLim1Hz, PLim1Pu; fLim1Hz + 0.000001, (ValveMaxPu - WFnlPu)*KTurbPu] "Pair of points for frequency-dependent active power limit piecewise linear curve [u1,y1; u2,y2;...] (above fLim1Hz, jump to power associated with ValveMaxPu)" annotation(
    Dialog(tab = "Frequency dependent valve limit"));
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
  Modelica.Blocks.Interfaces.RealOutput PMechPu annotation(
    Placement(visible = true, transformation(origin = {340, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {350, 2}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constIsochronous(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-222, -122}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Sources.IntegerConstant constRSelect(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-96, -106}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch switchRSelect(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {-160, -106}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constant1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-164, -214}, extent = {{-8, -8}, {8, 8}}, rotation = 90)));
equation
  connect(constRSelect.y, switchRSelect.f) annotation(
    Line(points = {{-107, -106}, {-148, -106}}, color = {255, 127, 0}));
  connect(switchRSelect.y, PMechPu) annotation(
    Line(points = {{-160, -95}, {-160, -88}, {340, -88}}, color = {0, 0, 127}));
  connect(switchRSelect.u[1], constIsochronous.y) annotation(
    Line(points = {{-160, -116}, {-176, -116}, {-176, -184}, {-222, -184}, {-222, -131}}, color = {0, 0, 127}));
  connect(switchRSelect.u[2], constant1.y) annotation(
    Line(points = {{-160, -116}, {-164, -116}, {-164, -206}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body>This generic governor model (CIM name GovCT2) can be used to represent a variety of prime movers controlled by PID governors. For more information, see IEC 61970-302.</body></html>"),
    Diagram(coordinateSystem(extent = {{-320, -200}, {320, 220}})),
    Icon(coordinateSystem(extent = {{-320, -200}, {320, 220}}), graphics = {Text(origin = {7, 7}, extent = {{-279, 123}, {279, -123}}, textString = "GovCT2"), Rectangle(origin = {0, 10}, extent = {{-320, 210}, {320, -210}})}),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", variableFilter = ".*"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian");
end GovCT2_MWE;
