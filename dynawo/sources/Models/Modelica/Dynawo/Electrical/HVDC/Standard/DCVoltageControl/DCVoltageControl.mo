within Dynawo.Electrical.HVDC.Standard.DCVoltageControl;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model DCVoltageControl "DC Voltage Control for HVDC"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit IpMaxcstPu "Maximum value of the active current in p.u (base SNom, UNom)";
  extends Parameters.Params_DCVoltageControl;

  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = Udc0Pu) "Reference DC voltage in p.u (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 33}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) "DC voltage in p.u (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -33}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput ipRefUdcPu(start = Ip0Pu) "Active current reference in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput activateDeltaP(start = false) "Boolean that indicates whether DeltaP is activated or not" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = UdcRefMaxPu, uMin = UdcRefMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-56, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1)  annotation(
    Placement(visible = true, transformation(origin = {-1, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {81, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = IpMaxcstPu - DUDC) annotation(
    Placement(visible = true, transformation(origin = {41, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = (-IpMaxcstPu) + DUDC) annotation(
    Placement(visible = true, transformation(origin = {41, -55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindup PI(Ki = Kidc, Kp = Kpdc, uMax = IpMaxcstPu, uMin = -IpMaxcstPu, integrator.y_start = - Ip0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu Udc0Pu;
  parameter Types.PerUnit Ip0Pu;

equation
  connect(UdcRefPu, limiter.u) annotation(
    Line(points = {{-120, 0}, {-94, 0}}, color = {0, 0, 127}));
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{-71, 0}, {-64, 0}}, color = {0, 0, 127}));
  connect(UdcPu, feedback.u2) annotation(
    Line(points = {{-120, -40}, {-56, -40}, {-56, -8}}, color = {0, 0, 127}));
  connect(gain1.y, ipRefUdcPu) annotation(
    Line(points = {{10, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, or1.u1) annotation(
    Line(points = {{52, -25}, {61, -25}, {61, -40}, {69, -40}}, color = {255, 0, 255}));
  connect(lessThreshold.y, or1.u2) annotation(
    Line(points = {{52, -55}, {61, -55}, {61, -48}, {69, -48}}, color = {255, 0, 255}));
  connect(gain1.y, greaterThreshold.u) annotation(
    Line(points = {{10, 0}, {25, 0}, {25, -25}, {29, -25}}, color = {0, 0, 127}));
  connect(gain1.y, lessThreshold.u) annotation(
    Line(points = {{10, 0}, {25, 0}, {25, -55}, {29, -55}}, color = {0, 0, 127}));
  connect(or1.y, activateDeltaP) annotation(
    Line(points = {{92, -40}, {110, -40}}, color = {255, 0, 255}));
  connect(feedback.y, PI.u) annotation(
    Line(points = {{-47, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(PI.y, gain1.u) annotation(
    Line(points = {{-19, 0}, {-13, 0}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end DCVoltageControl;
