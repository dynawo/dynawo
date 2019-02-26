within Dynawo.Electrical.Controls.Machines.VoltageRegulators;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model VRProportionalIntegral "Proportional Integral Voltage Regulator, keeps machine stator's voltage constant"

  import Modelica.Blocks;

  import Dynawo.Connectors;
  import Dynawo.NonElectrical.Blocks.NonLinear.LimiterWithLag;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Real Gain "Control gain";
  parameter Types.AC.VoltageModule EfdMinPu "Minimum allowed EfdPu";
  parameter Types.AC.VoltageModule EfdMaxPu "Maximum allowed EfdPu";
  parameter SIunits.Time LagEfdMin "Time lag before taking action when going below EfdMin";
  parameter SIunits.Time LagEfdMax "Time lag before taking action when going above EfdMax";
  parameter SIunits.Time tIntegral "Time integration constant";

  LimiterWithLag limiterWithLag (UMin = EfdMinPu, UMax = EfdMaxPu, LagMin = LagEfdMin, LagMax = LagEfdMax, tUMinReached0 = tEfdMinReached0, tUMaxReached0 = tEfdMaxReached0) "Limiter activated only after a certain period outside the bounds" annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain gain (k = Gain) annotation(
    Placement(visible = true, transformation(origin = {-48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput UcEfdPu (start = UcEfd0Pu) "General control voltage" annotation(
    Placement(visible = true, transformation(origin = {-142, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-142, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput UsPu (start = Us0Pu) "Stator voltage" annotation(
    Placement(visible = true, transformation(origin = {-100, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-56, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealOutput EfdPu (start = Efd0Pu) "Exciter field voltage" annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add rawEfd annotation(
    Placement(visible = true, transformation(origin = {6, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.Integrator integrator(y_start = yIntegrator0, k = Gain/tIntegral)  annotation(
    Placement(visible = true, transformation(origin = {-28, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ImPin EfdPuPin(value(start = Efd0Pu)) "Exciter field voltage Pin";
  Connectors.BPin  limitationUp (value (start = false)) "Limitation up reached ?";
  Connectors.BPin  limitationDown (value (start = false)) "Limitation down reached ?";
  Blocks.Math.Add integratorEntry annotation(
    Placement(visible = true, transformation(origin = {-68, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Feedback feedbackNonWindUp annotation(
    Placement(visible = true, transformation(origin = {0, 64}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
    
protected

  parameter Types.AC.VoltageModule UcEfd0Pu  "Initial control voltage, p.u. = Unom";
  parameter Types.AC.VoltageModule Us0Pu  "Initial stator voltage, p.u. = Unom";
  parameter Types.AC.VoltageModule Efd0Pu "Initial Efd";
  parameter Types.AC.VoltageModule yIntegrator0 "Initial control before saturation";
  parameter SIunits.Time tEfdMaxReached0 "Initial time when the Efd went above EfdMax";
  parameter SIunits.Time tEfdMinReached0 "Initial time when the Efd went below EfdMin";


equation
  connect(rawEfd.y, feedbackNonWindUp.u2) annotation(
    Line(points = {{18, 0}, {20, 0}, {20, 46}, {0, 46}, {0, 56}, {0, 56}}, color = {0, 0, 127}));
  connect(rawEfd.y, limiterWithLag.u) annotation(
    Line(points = {{18, 0}, {28, 0}}, color = {0, 0, 127}));
  connect(feedbackNonWindUp.y, integratorEntry.u1) annotation(
    Line(points = {{-10, 64}, {-88, 64}, {-88, 38}, {-80, 38}, {-80, 38}}, color = {0, 0, 127}));
  connect(limiterWithLag.y, feedbackNonWindUp.u1) annotation(
    Line(points = {{52, 0}, {60, 0}, {60, 64}, {8, 64}, {8, 64}}, color = {0, 0, 127}));
  connect(limiterWithLag.y, EfdPu) annotation(
    Line(points = {{52, 0}, {80, 0}}, color = {0, 0, 127}));
  connect(integratorEntry.y, integrator.u) annotation(
    Line(points = {{-56, 32}, {-40, 32}, {-40, 32}, {-40, 32}}, color = {0, 0, 127}));
  connect(feedback.y, integratorEntry.u2) annotation(
    Line(points = {{-90, 0}, {-88, 0}, {-88, 26}, {-80, 26}, {-80, 26}}, color = {0, 0, 127}));
  connect(gain.u, feedback.y) annotation(
    Line(points = {{-60, 0}, {-91, 0}}, color = {0, 0, 127}));
  connect(gain.y, rawEfd.u2) annotation(
    Line(points = {{-37, 0}, {-10.5, 0}, {-10.5, -6}, {-6, -6}}, color = {0, 0, 127}));
  connect(UsPu, feedback.u2) annotation(
    Line(points = {{-100, -48}, {-100, -8}}, color = {0, 0, 127}));
  connect(UcEfdPu, feedback.u1) annotation(
    Line(points = {{-142, 0}, {-108, 0}}, color = {0, 0, 127}));
  connect(integrator.y, rawEfd.u1) annotation(
    Line(points = {{-17, 32}, {-10, 32}, {-10, 6}, {-6, 6}}, color = {0, 0, 127}));
  connect(EfdPuPin.value, EfdPu);

//TimeLine
  when time - limiterWithLag.tUMinReached >= LagEfdMin then
// low limit
    Timeline.logEvent1(TimelineKeys.VRLimitationDownward);
    limitationDown.value = true;
  elsewhen time - limiterWithLag.tUMinReached < LagEfdMin and pre(limitationDown.value) then
    Timeline.logEvent1(TimelineKeys.VRBackToRegulation);
    limitationDown.value = false;
  end when;

  when time - limiterWithLag.tUMaxReached >= LagEfdMax then
// high limit
    Timeline.logEvent1(TimelineKeys.VRLimitationUpward);
    limitationUp.value = true;
  elsewhen time - limiterWithLag.tUMaxReached < LagEfdMax and pre(limitationUp.value) then
    Timeline.logEvent1(TimelineKeys.VRBackToRegulation);
    limitationUp.value = false;
  end when;

end VRProportionalIntegral;
