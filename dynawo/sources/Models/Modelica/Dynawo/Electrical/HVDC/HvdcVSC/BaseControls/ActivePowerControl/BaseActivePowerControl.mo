within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.ActivePowerControl;

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
  import Modelica;
  import Dynawo.NonElectrical.Blocks;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_BaseActivePowerControl;

  parameter Types.PerUnit IpMaxCstPu "Maximum value of the active current in pu (base SNom, UNom)";

  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -67}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = P0Pu) "Reference active power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -8}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) "Boolean assessing the state of the HVDC link: true if blocked, false if not blocked" annotation(
    Placement(visible = true, transformation(origin = {-130, -35}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput IpMaxPu(start = IpMaxCstPu) "Max active current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, 105}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput IpMinPu(start = - IpMaxCstPu) "Min active current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -95}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput ipRefPPu(start = Ip0Pu) "Active current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {3, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {110, 84}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {31, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-54, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = PMaxOPPu, uMin = PMinOPPu) annotation(
    Placement(visible = true, transformation(origin = {-24, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Rising = SlopePRefPu, y(start = P0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-90, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.PIAntiWindupVariableLimits pIAntiWindupVariableLimits(Ki = KiPControl, Kp = KpPControl, integrator.y_start = Ip0Pu) annotation(
    Placement(visible = true, transformation(origin = {64, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HVDC.HvdcVSC.BaseControls.ActivePowerControl.RPFaultFunction RPFault(SlopeRPFault = SlopeRPFault) "rpfault function for HVDC" annotation(
    Placement(visible = true, transformation(origin = {-90, -35}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Ip0Pu "Start value of active current in pu (base SNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SNom) (generator convention)";

equation
  connect(switch1.y, ipRefPPu) annotation(
    Line(points = {{121, 0}, {140, 0}}, color = {0, 0, 127}));
  connect(PPu, feedback.u2) annotation(
    Line(points = {{-130, -67}, {3, -67}, {3, -22}}, color = {0, 0, 127}));
  connect(feedback.y, add1.u2) annotation(
    Line(points = {{12, -14}, {19, -14}}, color = {0, 0, 127}));
  connect(product.y, limiter.u) annotation(
    Line(points = {{-43, -14}, {-36, -14}}, color = {0, 0, 127}));
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{-13, -14}, {-5, -14}}, color = {0, 0, 127}));
  connect(PRefPu, slewRateLimiter.u) annotation(
    Line(points = {{-130, -8}, {-102, -8}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, product.u1) annotation(
    Line(points = {{-79, -8}, {-66, -8}}, color = {0, 0, 127}));
  connect(pIAntiWindupVariableLimits.y, switch1.u3) annotation(
    Line(points = {{75, -8}, {98, -8}}, color = {0, 0, 127}));
  connect(add1.y, pIAntiWindupVariableLimits.u) annotation(
    Line(points = {{42, -8}, {52, -8}}, color = {0, 0, 127}));
  connect(IpMinPu, pIAntiWindupVariableLimits.limitMin) annotation(
    Line(points = {{-130, -95}, {43, -95}, {43, -14}, {52, -14}}, color = {0, 0, 127}));
  connect(IpMaxPu, pIAntiWindupVariableLimits.limitMax) annotation(
    Line(points = {{-130, 105}, {43, 105}, {43, -2}, {52, -2}}, color = {0, 0, 127}));
  connect(zero.y, switch1.u1) annotation(
    Line(points = {{99, 84}, {90, 84}, {90, 8}, {98, 8}, {98, 8}}, color = {0, 0, 127}));
  connect(blocked, RPFault.blocked) annotation(
    Line(points = {{-130, -35}, {-102, -35}}, color = {255, 0, 255}));
  connect(RPFault.rpfault, product.u2) annotation(
    Line(points = {{-79, -35}, {-72, -35}, {-72, -20}, {-66, -20}, {-66, -20}}, color = {0, 0, 127}));
  connect(blocked, switch1.u2) annotation(
    Line(points = {{-130, -35}, {-106, -35}, {-106, -50}, {90, -50}, {90, 0}, {98, 0}, {98, 0}}, color = {255, 0, 255}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-110, -95}, {130, 105}})),
    Icon(coordinateSystem(grid = {1, 1})));
end BaseActivePowerControl;
