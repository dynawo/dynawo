within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.ActivePowerControl;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseActivePowerControl "Base active power control for the HVDC VSC model"
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsActivePowerControl;

  parameter Types.CurrentComponentPu IpMaxPu "Maximum value of the active current in pu (base SNom, UNom) (DC to AC)";

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput blocked1(start = false) "If true, HVDC link is blocked on side 1" annotation(
    Placement(visible = true, transformation(origin = {-220, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.BooleanInput blocked2(start = false) "If true, HVDC link is blocked on side 2" annotation(
    Placement(visible = true, transformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-27, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMaxPu) "Maximum active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-220, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput ipMinPu(start = -IpMaxPu) "Minimum active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-220, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-220, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = P0Pu) "Reference active power in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-220, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput ipRefPu(start = Ip0Pu) "Active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {210, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tMeasureP, y_start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-90, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {0, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {170, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = POpMaxPu, uMin = POpMinPu) annotation(
    Placement(visible = true, transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Rising = SlopePRefPu, y(start = P0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-150, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupVariableLimits pIAntiWindupVariableLimits(Ki = KiP, Kp = KpP, integrator.y_start = Ip0Pu, Y0 = Ip0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.ActivePowerControl.RPFaultFunction RPFault(SlopeRPFault = SlopeRPFault) "rpfault function for HVDC" annotation(
    Placement(visible = true, transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.CurrentComponentPu Ip0Pu "Start value of active current in pu (base SNom, UNom) (DC to AC)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SNom) (DC to AC)";

equation
  connect(switch1.y, ipRefPu) annotation(
    Line(points = {{181, 20}, {210, 20}}, color = {0, 0, 127}));
  connect(feedback.y, add1.u2) annotation(
    Line(points = {{9, -20}, {20, -20}, {20, -6}, {38, -6}}, color = {0, 0, 127}));
  connect(product.y, limiter.u) annotation(
    Line(points = {{-79, -20}, {-62, -20}}, color = {0, 0, 127}));
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{-39, -20}, {-8, -20}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, product.u1) annotation(
    Line(points = {{-139, 20}, {-120, 20}, {-120, -14}, {-102, -14}}, color = {0, 0, 127}));
  connect(pIAntiWindupVariableLimits.y, switch1.u3) annotation(
    Line(points = {{121, 0}, {140, 0}, {140, 12}, {158, 12}}, color = {0, 0, 127}));
  connect(add1.y, pIAntiWindupVariableLimits.u) annotation(
    Line(points = {{61, 0}, {98, 0}}, color = {0, 0, 127}));
  connect(zero.y, switch1.u1) annotation(
    Line(points = {{121, 40}, {140, 40}, {140, 28}, {158, 28}}, color = {0, 0, 127}));
  connect(RPFault.rpfault, product.u2) annotation(
    Line(points = {{-139, -40}, {-120, -40}, {-120, -26}, {-102, -26}}, color = {0, 0, 127}));
  connect(PPu, firstOrder2.u) annotation(
    Line(points = {{-220, -100}, {-102, -100}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback.u2) annotation(
    Line(points = {{-79, -100}, {0, -100}, {0, -28}}, color = {0, 0, 127}));
  connect(ipMaxPu, pIAntiWindupVariableLimits.limitMax) annotation(
    Line(points = {{-220, 140}, {80, 140}, {80, 6}, {98, 6}}, color = {0, 0, 127}));
  connect(ipMinPu, pIAntiWindupVariableLimits.limitMin) annotation(
    Line(points = {{-220, -140}, {80, -140}, {80, -6}, {98, -6}}, color = {0, 0, 127}));
  connect(blocked1, switch1.u2) annotation(
    Line(points = {{-220, -20}, {-180, -20}, {-180, 0}, {0, 0}, {0, 20}, {158, 20}}, color = {255, 0, 255}));
  connect(blocked1, RPFault.blocked1) annotation(
    Line(points = {{-220, -20}, {-180, -20}, {-180, -37}, {-162, -37}}, color = {255, 0, 255}));
  connect(blocked2, RPFault.blocked2) annotation(
    Line(points = {{-220, -60}, {-180, -60}, {-180, -43}, {-162, -43}}, color = {255, 0, 255}));
  connect(PRefPu, slewRateLimiter.u) annotation(
    Line(points = {{-220, 20}, {-162, 20}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -160}, {200, 160}})));
end BaseActivePowerControl;
