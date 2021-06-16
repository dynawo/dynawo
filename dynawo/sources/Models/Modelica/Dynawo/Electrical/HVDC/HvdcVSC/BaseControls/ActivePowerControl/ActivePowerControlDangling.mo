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

model ActivePowerControlDangling "Active power control for the HVDC VSC model that connects two different synchronous areas (P control on the side of the main one)"

  import Modelica;
  import Dynawo.NonElectrical.Blocks;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_ActivePowerControlDangling;
  parameter Types.PerUnit IpMaxCstPu "Maximum value of the active current in p.u (base SNom, UNom)";

  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -61}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = P0Pu) "Reference active power in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) "Boolean assessing the state of the HVDC link: true if blocked, false if not blocked" annotation(
    Placement(visible = true, transformation(origin = {-130, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput IpMaxPu(start = IpMaxCstPu) "Max active current reference in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput IpMinPu(start = - IpMaxCstPu) "Min active current reference in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -95}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput ipRefPPu(start = Ip0Pu) "Active current reference in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {4, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-53, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = PMaxOPPu, uMin = PMinOPPu)  annotation(
    Placement(visible = true, transformation(origin = {-23, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Rising = SlopePRefPu)  annotation(
    Placement(visible = true, transformation(origin = {-90, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.PIAntiWindupVariableLimits pIAntiWindupVariableLimits(Ki = KiPControl, Kp = KpPControl, integrator.y_start = Ip0Pu)  annotation(
    Placement(visible = true, transformation(origin = {64, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HVDC.HvdcVSC.BaseControls.ActivePowerControl.RPFaultFunction RPFault(SlopeRPFault = SlopeRPFault) "rpfault function for HVDC" annotation(
    Placement(visible = true, transformation(origin = {-90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Types.PerUnit Ip0Pu "Start value of active current in p.u (base SNom)";
  parameter Types.ActivePowerPu P0Pu  "Start value of active power in p.u (base SNom) (generator convention)";

equation
  connect(switch1.y, ipRefPPu) annotation(
    Line(points = {{121, 0}, {140, 0}}, color = {0, 0, 127}));
  connect(PPu, feedback.u2) annotation(
    Line(points = {{-130, -61}, {4, -61}, {4, -16}}, color = {0, 0, 127}));
  connect(product.y, limiter.u) annotation(
    Line(points = {{-42, -8}, {-35, -8}}, color = {0, 0, 127}));
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{-12, -8}, {-4, -8}}, color = {0, 0, 127}));
  connect(PRefPu, slewRateLimiter.u) annotation(
    Line(points = {{-130, -2}, {-102, -2}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, product.u1) annotation(
    Line(points = {{-79, -2}, {-65, -2}}, color = {0, 0, 127}));
  connect(pIAntiWindupVariableLimits.y, switch1.u3) annotation(
    Line(points = {{75, -8}, {98, -8}}, color = {0, 0, 127}));
  connect(IpMinPu, pIAntiWindupVariableLimits.limitMin) annotation(
    Line(points = {{-130, -95}, {43, -95}, {43, -14}, {52, -14}}, color = {0, 0, 127}));
  connect(IpMaxPu, pIAntiWindupVariableLimits.limitMax) annotation(
    Line(points = {{-130, 40}, {43, 40}, {43, -2}, {52, -2}}, color = {0, 0, 127}));
  connect(zero.y, switch1.u1) annotation(
    Line(points = {{-109, 80}, {90, 80}, {90, 8}, {98, 8}}, color = {0, 0, 127}));
  connect(blocked, RPFault.blocked) annotation(
    Line(points = {{-130, -30}, {-102, -30}}, color = {255, 0, 255}));
  connect(RPFault.rpfault, product.u2) annotation(
    Line(points = {{-79, -30}, {-71, -30}, {-71, -14}, {-65, -14}}, color = {0, 0, 127}));
  connect(blocked, switch1.u2) annotation(
    Line(points = {{-130, -30}, {-105, -30}, {-105, -44}, {90, -44}, {90, 0}, {98, 0}}, color = {255, 0, 255}));
  connect(feedback.y, pIAntiWindupVariableLimits.u) annotation(
    Line(points = {{13, -8}, {52, -8}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-110, -95}, {130, 105}})),
    Icon(coordinateSystem(grid = {1, 1})));
end ActivePowerControlDangling;
