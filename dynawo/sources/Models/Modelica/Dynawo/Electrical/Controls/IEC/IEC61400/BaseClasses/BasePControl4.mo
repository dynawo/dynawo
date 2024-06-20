within Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

partial model BasePControl4 "Base active power control module for type 4 wind turbines (IEC N°61400-27-1)"

  /*
    An anti-windup has been added to the first order filter
    because the standard does not specify any change of behavior when the limits are reached.
  */

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //PControl parameters
  parameter Types.PerUnit Kpaw "Anti-windup gain for the integrator of the ramp-limited first order in pu/s (base SNom)" annotation(
    Dialog(tab = "PControl"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {130, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {70, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0.01) annotation(
    Placement(visible = true, transformation(origin = {10, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderAntiWindup absLimRateLimFirstOrderAntiWindup(DyMin = -999, Kaw = Kpaw, UseLimits = true, Y0 = -P0Pu * SystemBase.SnRef / SNom, YMax = 999) annotation(
    Placement(visible = true, transformation(origin = {90, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = -999) annotation(
    Placement(visible = true, transformation(origin = {50, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit IpMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(const.y, max.u1) annotation(
    Line(points = {{21, 140}, {40, 140}, {40, 126}, {58, 126}}, color = {0, 0, 127}));
  connect(division.y, ipCmdPu) annotation(
    Line(points = {{142, -100}, {170, -100}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderAntiWindup.y, division.u1) annotation(
    Line(points = {{102, -100}, {110, -100}, {110, -106}, {118, -106}}, color = {0, 0, 127}));
  connect(max.y, division.u2) annotation(
    Line(points = {{82, 120}, {110, 120}, {110, -94}, {118, -94}}, color = {0, 0, 127}));
  connect(ipMaxPu, product1.u1) annotation(
    Line(points = {{-180, 60}, {-20, 60}, {-20, 54}, {-2, 54}}, color = {0, 0, 127}));
  connect(product1.y, absLimRateLimFirstOrderAntiWindup.yMax) annotation(
    Line(points = {{22, 60}, {70, 60}, {70, -94}, {78, -94}}, color = {0, 0, 127}));
  connect(const2.y, absLimRateLimFirstOrderAntiWindup.yMin) annotation(
    Line(points = {{61, -68}, {66.25, -68}, {66.25, -106}, {78, -106}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-16, 31}, extent = {{-76, -18}, {92, 28}}, textString = "IEC WT 4"), Text(origin = {-12, -79}, extent = {{-77, -16}, {100, 30}}, textString = "PControl")}),
    Diagram(coordinateSystem(extent = {{-160, -160}, {160, 160}})));
end BasePControl4;
