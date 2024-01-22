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
  parameter Types.Time tDGovernorSeconds "Governor derivative controller time constant in s";
  parameter Types.Time tEngineSeconds "Transport time delay for diesel engine in s";
  parameter Types.Time tFLoadSeconds "Load limiter time constant in s";
  parameter Types.Time tPElecSeconds "Electrical power transducer time constant in s";
  parameter Types.Time tSASeconds "Temperature detection lead time constant in s";
  parameter Types.Time tSBSeconds "Temperature detection lag time constant in s";
  parameter Types.Time ValveMaxPu "Maximum valve position limit in pu";
  parameter Types.Time ValveMinPu "Minimum valve position limit in pu";
  parameter Types.Time WFnlPu "No load fuel flow in pu";
  parameter Boolean WFspd "Switch for fuel source characteristic";


  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-2, 68}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-114, -60}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) "Reference mechanical power in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {-114, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-114, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {111, -1}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain droop(k = 1/R) annotation(
    Placement(visible = true, transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) "Angular reference frequency" annotation(
    Placement(visible = true, transformation(origin = {-90, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(tFilter = Tg1, YMax = VMax, YMin = VMin, Y0 = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction leadLag(a = {Tg3, 1}, b = {Tg2, 1}, x_scaled(start = {Pm0Pu}), x_start = {Pm0Pu}, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain friction(k = Dt) annotation(
    Placement(visible = true, transformation(origin = {30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNom)";
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body>This model is a simple IEEE steam turbine-governor model type TGOV1 (<u>CIM name:</u>&nbsp;GovSteam0), implemented following the description done in the chapter 2.2 of the<span class=\"pl-c\">&nbsp;IEEE technical report PES-TR1 Jan 2013.&nbsp;</span></body></html>"));
end GovCT2;
