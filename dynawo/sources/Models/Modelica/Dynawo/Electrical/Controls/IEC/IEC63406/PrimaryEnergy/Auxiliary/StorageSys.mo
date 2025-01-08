within Dynawo.Electrical.Controls.IEC.IEC63406.PrimaryEnergy.Auxiliary;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model StorageSys "Primary energy source-driven electric conversion module of energy generation systems (IEC 63406)"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Parameters
  parameter Types.PerUnit PMaxPu "Maximum active power at converter terminal in pu (base SNom)" annotation(
    Dialog(tab = "StorageSys"));
  parameter Boolean SOCFlag "0 for battery energy storage systems, 1 for supercapacitor energy storage systems and flywheel energy storage systems" annotation(
    Dialog(tab = "StorageSys"));
  parameter Types.Percent SOCMax "Maximum SOC amount for charging in %" annotation(
    Dialog(tab = "StorageSys"));
  parameter Types.Percent SOCMin "Minimum SOC amount for discharging in %" annotation(
    Dialog(tab = "StorageSys"));
  parameter Types.Time Tess "Equivalent time constant (in s) for the battery, supercapacitor or flywheel energy storage systems (if you have Tess = 10, a system with 100% SOC and P = Pmax, the system will discharge completely in 10s)" annotation(
    Dialog(tab = "StorageSys"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput pMeasPu(start = -P0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) active power component in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 8.88178e-16}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput pAvailInPu(start = PAvailIn0Pu) "Minimum output electrical power available to the active power control module in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput pAvailOutPu(start = PMaxPu) "Maximum output electrical power available to the active power control module in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-76, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch SOCFlagSwitch annotation(
    Placement(visible = true, transformation(origin = {-42, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / Tess) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = -1, k2 = +1) annotation(
    Placement(visible = true, transformation(origin = {20, 9.99201e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter SOClimiter(limitsAtInit = true, uMax = SOCMax, uMin = SOCMin) annotation(
    Placement(visible = true, transformation(origin = {50, 4.44089e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = SOCInit) annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.PrimaryEnergy.Auxiliary.SOCcontrol sOCcontrol(PAvailIn0Pu = PAvailIn0Pu,PMaxPu = PMaxPu, SOCInit = SOCInit, SOCMax = SOCMax, SOCMin = SOCMin) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 100) annotation(
    Placement(visible = true, transformation(origin = {-84, 0}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression boolean(y = SOCFlag) annotation(
    Placement(visible = true, transformation(origin = {-60, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit PAvailIn0Pu "Initial minimum output electrical power available to the active power control module in pu (base SNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Percent SOCInit "Initial SOC amount in %" annotation(
    Dialog(tab = "StorageSys"));

equation
  connect(gain.y, SOCFlagSwitch.u3) annotation(
    Line(points = {{-75, 0}, {-66.5, 0}, {-66.5, -8}, {-54, -8}}, color = {0, 0, 127}));
  connect(pMeasPu, gain.u) annotation(
    Line(points = {{-120, 0}, {-94, 0}}, color = {0, 0, 127}));
  connect(integrator.y, add.u1) annotation(
    Line(points = {{1, 0}, {3.5, 0}, {3.5, 6}, {8, 6}}, color = {0, 0, 127}));
  connect(const.y, add.u2) annotation(
    Line(points = {{1, -50}, {8, -50}, {8, -6}}, color = {0, 0, 127}));
  connect(add.y, SOClimiter.u) annotation(
    Line(points = {{31, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(SOClimiter.y, sOCcontrol.soc) annotation(
    Line(points = {{61, 0}, {68, 0}}, color = {0, 0, 127}));
  connect(gain.y, division.u1) annotation(
    Line(points = {{-75, 0}, {-66, 0}, {-66, 20}, {-100, 20}, {-100, 56}, {-88, 56}}, color = {0, 0, 127}));
  connect(SOClimiter.y, division.u2) annotation(
    Line(points = {{61, 0}, {64, 0}, {64, 32}, {-92, 32}, {-92, 44}, {-88, 44}}, color = {0, 0, 127}));
  connect(division.y, SOCFlagSwitch.u1) annotation(
    Line(points = {{-65, 50}, {-61, 50}, {-61, 8}, {-54, 8}}, color = {0, 0, 127}));
  connect(boolean.y, SOCFlagSwitch.u2) annotation(
    Line(points = {{-60, -19}, {-60, 0}, {-54, 0}}, color = {255, 0, 255}));
  connect(SOCFlagSwitch.y, integrator.u) annotation(
    Line(points = {{-31, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(sOCcontrol.pAvailOutPu, pAvailOutPu) annotation(
    Line(points = {{92, -2}, {96, -2}, {96, -40}, {110, -40}}, color = {0, 0, 127}));
  connect(sOCcontrol.pAvailInPu, pAvailInPu) annotation(
    Line(points = {{92, 2}, {96, 2}, {96, 40}, {110, 40}}, color = {0, 0, 127}));
protected

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {8, -19}, extent = {{-107, 118}, {92, -81}}, textString = "Storage\nModule")}));
end StorageSys;
