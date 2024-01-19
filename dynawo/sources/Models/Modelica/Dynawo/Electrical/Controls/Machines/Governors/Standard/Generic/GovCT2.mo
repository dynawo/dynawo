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
  parameter Types.PerUnit RPu "permanent droop in pu";
  parameter Types.PerUnit RSelect "switch to choose feedback signal for droop. Typical value is 1.";
  parameter Types.Time tPElec "electrical power transducer time constant in seconds";
  parameter Types.PerUnit KPGovPu "governor proportional gain in pu";
  parameter Types.PerUnit KIGovPu "governor integral gain in pu";
  parameter Types.PerUnit KDGovPu "governor derivative gain in pu";
  parameter Types.Time tDGov "governor derivative controller time constant in seconds";
  parameter Types.Time tAct "actuator time constant in seconds";
  parameter Types.PerUnit KTurbPu "turbine gain in pu";
  parameter Types.PerUnit wFNLPu "no load fuel flow in pu";
  parameter Types.Time tB "turbine lag time constant in seconds";
  parameter Types.Time tC "turbine lead time constant in seconds";
  parameter Boolean FuelFlowFlag "switch for fuel source characteristic: fuel flow independent of speed (0) or proportional to speed (1)";
  parameter Types.Time tEngine "transport time delay for diesel engine in seconds";
  parameter Types.Time tFLoad "load limiter time constant in seconds";
  parameter Types.PerUnit KPLoadPu "load limiter proportional gain for PI controller in pu";
  parameter Types.PerUnit KILoadPu "load limiter integral gain for PI controller in pu";
  parameter Types.PerUnit LdRefPu "load limiter reference value in pu";
  parameter Types.PerUnit DMPu "speed sensitivity coefficient in pu";
  parameter Types.PerUnit KIMwPu "power controller (reset) gain in pu";
  parameter Types.PerUnit aSetPu "acceleration limiter setpoint in pu";
  parameter Types.PerUnit KAPu "acceleration limiter gain in pu";
  parameter Types.Time tAPu "acceleration limiter time constant in seconds";
  parameter Types.PerUnit dBPu "speed governor dead band in pu";
  parameter Types.Time tSA "temperature detection lead time constant in seconds";
  parameter Types.Time tSB "temperature detection lag time constant in seconds";
  parameter Types.PerUnit OmegaErrorMaxPu "maximum value for speed error signal in pu";
  parameter Types.PerUnit OmegaErrorMinPu "minimum value for speed error signal in pu";
  parameter Types.PerUnit ValveRateMaxPu "maximum valve opening rate in pu/s";
  parameter Types.PerUnit ValveRateMinPu "minimum valve opening rate in pu/s";
  parameter Types.PerUnit loadLimitMaxPu "maximum rate of load limit increase in pu";
  parameter Types.PerUnit loadLimitMinPu "maximum rate of load limit decrease in pu";
  parameter Types.PerUnit valveMaxPu "maximum valve position limit in pu";
  parameter Types.PerUnit valveMinPu "minimum valve position limit in pu";

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
