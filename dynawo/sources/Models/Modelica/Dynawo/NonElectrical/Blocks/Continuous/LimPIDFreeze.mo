within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model LimPIDFreeze "PI controller with limited output, anti-windup compensation, setpoint weighting, optional feed-forward and optional freezing of the state"
  extends Modelica.Blocks.Interfaces.SVcontrol;

  parameter Real K = 1 "Gain of controller";
  parameter Types.Time Ti = 0.5 "Time constant of Integrator block";
  parameter Real Wp = 1 "Set-point weight for Proportional block (0..1)";
  parameter Real Ni = 0.9 "Ni*Ti is time constant of anti-windup compensation";
  parameter Boolean WithFeedForward = false "Use feed-forward input?" annotation(
    Evaluate = true,
    choices(checkBox = true));
  parameter Real Kff = 1 "Gain of feed-forward input" annotation(
    Dialog(enable = WithFeedForward));
  parameter Real Xi0 = 0 "Initial or guess value for integrator output (= integrator state)";
  parameter Real Y0 = 0 "Initial value of output";
  parameter Boolean Strict = false "= true, if Strict limits with noEvent(..)" annotation(
    Evaluate = true,
    choices(checkBox = true),
    Dialog(tab = "Advanced"));
  constant Types.Time unitTime = 1 annotation(
    HideResult = true);
  parameter Real YMax(start = 1) "Upper limit of output";
  parameter Real YMin = - YMax "Lower limit of output";

  Modelica.Blocks.Interfaces.RealInput uFF if WithFeedForward "Optional connector of feed-forward input signal" annotation(
    Placement(transformation(origin = {60, -120}, extent = {{20, -20}, {-20, 20}}, rotation = 270)));
  Modelica.Blocks.Interfaces.BooleanInput freeze annotation(
    Placement(visible = true, transformation(origin = {-94, -124}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-68, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

  output Real controlError = u_s - u_m "Control error (set point - measurement)";

  Modelica.Blocks.Math.Add addP(k1 = Wp, k2 = -1) annotation(
    Placement(transformation(extent = {{-80, 40}, {-60, 60}})));
  Modelica.Blocks.Math.Gain P(k = 1) annotation(
    Placement(transformation(extent = {{-50, 40}, {-30, 60}})));
  Modelica.Blocks.Math.Gain gainPID(k = K) annotation(
    Placement(transformation(extent = {{20, -10}, {40, 10}})));
  Modelica.Blocks.Math.Add addPID annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add3 addI(k2 = -1) annotation(
    Placement(transformation(extent = {{-80, -60}, {-60, -40}})));
  Modelica.Blocks.Math.Add addSat(k1 = 1, k2 = -1) annotation(
    Placement(transformation(origin = {80, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Math.Gain gainTrack(k = 1 / (K * Ni)) annotation(
    Placement(transformation(extent = {{0, -80}, {-20, -60}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, strict = true, uMax = YMax, uMin = YMin) annotation(
    Placement(transformation(extent = {{70, -10}, {90, 10}})));
  Modelica.Blocks.Sources.Constant FFzero(k = 0) if not WithFeedForward annotation(
    Placement(transformation(extent = {{30, -35}, {40, -25}})));
  Modelica.Blocks.Math.Add addFF(k1 = 1, k2 = Kff) annotation(
    Placement(transformation(extent = {{48, -6}, {60, 6}})));
  IntegratorSetFreeze I(K = unitTime / Ti, UseFreeze = true, Y0 = Xi0) annotation(
    Placement(visible = true, transformation(origin = {-38, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(freeze, I.freeze) annotation(
    Line(points = {{-94, -124}, {-94, -95}, {-44, -95}, {-44, -62}}, color = {255, 0, 255}));
  connect(addI.y, I.u) annotation(
    Line(points = {{-58, -50}, {-52, -50}, {-52, -50}, {-50, -50}}, color = {0, 0, 127}));
  connect(u_s, addP.u1) annotation(
    Line(points = {{-120, 0}, {-96, 0}, {-96, 56}, {-82, 56}}, color = {0, 0, 127}));
  connect(u_s, addI.u1) annotation(
    Line(points = {{-120, 0}, {-96, 0}, {-96, -42}, {-82, -42}}, color = {0, 0, 127}));
  connect(addP.y, P.u) annotation(
    Line(points = {{-59, 50}, {-52, 50}}, color = {0, 0, 127}));
  connect(limiter.y, addSat.u1) annotation(
    Line(points = {{91, 0}, {94, 0}, {94, -20}, {86, -20}, {86, -38}}, color = {0, 0, 127}));
  connect(limiter.y, y) annotation(
    Line(points = {{91, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(addSat.y, gainTrack.u) annotation(
    Line(points = {{80, -61}, {80, -70}, {2, -70}}, color = {0, 0, 127}));
  connect(gainTrack.y, addI.u3) annotation(
    Line(points = {{-21, -70}, {-88, -70}, {-88, -58}, {-82, -58}}, color = {0, 0, 127}));
  connect(u_m, addP.u2) annotation(
    Line(points = {{0, -120}, {0, -92}, {-92, -92}, {-92, 44}, {-82, 44}}, color = {0, 0, 127}, thickness = 0.5));
  connect(u_m, addI.u2) annotation(
    Line(points = {{0, -120}, {0, -92}, {-92, -92}, {-92, -50}, {-82, -50}}, color = {0, 0, 127}, thickness = 0.5));
  connect(addPID.y, gainPID.u) annotation(
    Line(points = {{11, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(addFF.y, limiter.u) annotation(
    Line(points = {{60.6, 0}, {68, 0}}, color = {0, 0, 127}));
  connect(gainPID.y, addFF.u1) annotation(
    Line(points = {{41, 0}, {44, 0}, {44, 3.6}, {46.8, 3.6}}, color = {0, 0, 127}));
  connect(FFzero.y, addFF.u2) annotation(
    Line(points = {{40.5, -30}, {44, -30}, {44, -3.6}, {46.8, -3.6}}, color = {0, 0, 127}));
  connect(addFF.u2, uFF) annotation(
    Line(points = {{46.8, -3.6}, {44, -3.6}, {44, -92}, {60, -92}, {60, -120}}, color = {0, 0, 127}));
  connect(addFF.y, addSat.u2) annotation(
    Line(points = {{60.6, 0}, {64, 0}, {64, -20}, {74, -20}, {74, -38}}, color = {0, 0, 127}));
  connect(P.y, addPID.u1) annotation(
    Line(points = {{-28, 50}, {-20, 50}, {-20, 6}, {-12, 6}}, color = {0, 0, 127}));
  connect(I.y, addPID.u2) annotation(
    Line(points = {{-26, -50}, {-20, -50}, {-20, -6}, {-12, -6}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    defaultComponentName = "PID", preferredView = "diagram",
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-80, 78}, {-80, -90}}, color = {192, 192, 192}), Polygon(points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}, lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid), Line(points = {{-90, -80}, {82, -80}}, color = {192, 192, 192}), Polygon(points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}, lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid), Line(points = {{-80, -80}, {-80, -20}, {30, 60}, {80, 60}}, color = {0, 0, 127}), Text(extent = {{-20, -20}, {80, -60}}, lineColor = {192, 192, 192}), Line(visible = Strict, points = {{30, 60}, {81, 60}}, color = {255, 0, 0})}),
    Diagram(graphics = {Text(lineColor = {0, 0, 255}, extent = {{79, -112}, {129, -102}}, textString = " (feed-forward)")}),
    Documentation(info = "<html>
The following features are present:
</p>
<ul>
<li> The output of this controller is limited. If the controller is
     in its limits, anti-windup compensation is activated to drive
     the integrator state to zero.</li>
<li> Setpoint weighting is present, which allows to weight
     the setpoint in the proportional part
     independently from the measurement. The controller will respond
     to load disturbances and measurement noise independently of this setting
     (parameters Wp). However, setpoint changes will depend on this
     setting.</li>
<li> Optional feed-forward. It is possible to add a feed-forward signal.
     The feed-forward signal is added before limitation.</li>
</ul>

<p>
<strong>Extended with Freeze functionality:</strong> If boolean input is set to true, the derivative of the state variable is set to zero.
</p>
</html>"));
end LimPIDFreeze;
