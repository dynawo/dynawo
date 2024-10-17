within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified;

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

model VRProportionalIntegral "Proportional integral voltage regulator, keeps machine stator voltage constant"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.VoltageModulePu EfdMaxPu "Maximum allowed exciter field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfdMinPu "Minimum allowed exciter field voltage in pu (user-selected base voltage)";
  parameter Types.PerUnit Gain "Control gain";
  parameter Types.Time LagEfdMax "Time lag before taking action when going above EfdMax in s";
  parameter Types.Time LagEfdMin "Time lag before taking action when going below EfdMin in s";
  parameter Types.Time tIntegral "Integration time constant in s";
  parameter Types.VoltageModulePu UsRefMaxPu "Maximum reference stator voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UsRefMinPu "Minimum reference stator voltage in pu (base UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput deltaUsRefPu(start = 0) "Additional reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Exciter field voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.BPin limitationDown(value(start = false)) "If true, lower limit is reached";
  Dynawo.Connectors.BPin limitationUp(value(start = false)) "If true, upper limit is reached";

  //Blocks
  Dynawo.NonElectrical.Blocks.NonLinear.LimiterWithLag limiterWithLag(LagMax = LagEfdMax, LagMin = LagEfdMin, tUMaxReached0 = Modelica.Constants.inf, tUMinReached0 = Modelica.Constants.inf, UMax = EfdMaxPu, UMin = EfdMinPu) "Limiter activated only after a given period outside the bounds" annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Gain) annotation(
    Placement(visible = true, transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add rawEfd annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Gain / tIntegral, y_start = yIntegrator0) annotation(
    Placement(visible = true, transformation(origin = {30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add integratorEntry annotation(
    Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackNonWindUp annotation(
    Placement(visible = true, transformation(origin = {120, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Nonlinear.Limiter limUsRef(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = UsRefMaxPu, uMin = UsRefMinPu) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add UsRefTotal annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu Efd0Pu "Initial exciter field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UsRef0Pu "Initial reference stator voltage in pu (base UNom)";
  parameter Types.VoltageModulePu yIntegrator0 "Initial integrator output in pu (user-selected base voltage)";

protected
  Boolean limitationEfdMax(start = false) "If true, EfdMax is reached";
  Boolean limitationEfdMin(start = false) "If true, EfdMin is reached";
  Boolean limitationUsRefMax(start = false) "If true, UsRefMax is reached";
  Boolean limitationUsRefMin(start = false) "If true, UsRefMin is reached";

equation
  //Low limit (EfdMin)
  when time - limiterWithLag.tUMinReached >= LagEfdMin then
    Timeline.logEvent1(TimelineKeys.VRLimitationEfdMin);
    limitationEfdMin = true;
  elsewhen time - limiterWithLag.tUMinReached < LagEfdMin and pre(limitationEfdMin) then
    Timeline.logEvent1(TimelineKeys.VRBackToRegulation);
    limitationEfdMin = false;
  end when;

  //High limit (EfdMax)
  when time - limiterWithLag.tUMaxReached >= LagEfdMax then
    Timeline.logEvent1(TimelineKeys.VRLimitationEfdMax);
    limitationEfdMax = true;
  elsewhen time - limiterWithLag.tUMaxReached < LagEfdMax and pre(limitationEfdMax) then
    Timeline.logEvent1(TimelineKeys.VRBackToRegulation);
    limitationEfdMax = false;
  end when;

  //UsRef limits
  when UsRefTotal.y <= UsRefMinPu then
    Timeline.logEvent1(TimelineKeys.VRLimitationUsRefMin);
    limitationUsRefMin = true;
    limitationUsRefMax = false;
  elsewhen UsRefTotal.y >= UsRefMaxPu then
    Timeline.logEvent1(TimelineKeys.VRLimitationUsRefMax);
    limitationUsRefMin = false;
    limitationUsRefMax = true;
  elsewhen UsRefTotal.y < UsRefMaxPu and UsRefTotal.y > UsRefMinPu and (pre(limitationUsRefMin) or pre(limitationUsRefMax)) then
    Timeline.logEvent1(TimelineKeys.VRBackToRegulation);
    limitationUsRefMin = false;
    limitationUsRefMax = false;
  end when;

  limitationUp.value = limitationUsRefMax or limitationEfdMax;
  limitationDown.value = limitationUsRefMin or limitationEfdMin;

  connect(limUsRef.y, feedback.u1) annotation(
    Line(points = {{-99, 0}, {-68, 0}}, color = {0, 0, 127}));
  connect(limiterWithLag.y, feedbackNonWindUp.u1) annotation(
    Line(points = {{161, 0}, {180, 0}, {180, 80}, {128, 80}}, color = {0, 0, 127}));
  connect(rawEfd.y, limiterWithLag.u) annotation(
    Line(points = {{101, 0}, {138, 0}}, color = {0, 0, 127}));
  connect(integrator.y, rawEfd.u1) annotation(
    Line(points = {{41, 40}, {60, 40}, {60, 6}, {78, 6}}, color = {0, 0, 127}));
  connect(gain.y, rawEfd.u2) annotation(
    Line(points = {{21, -20}, {60, -20}, {60, -6}, {78, -6}}, color = {0, 0, 127}));
  connect(rawEfd.y, feedbackNonWindUp.u2) annotation(
    Line(points = {{101, 0}, {120, 0}, {120, 72}}, color = {0, 0, 127}));
  connect(feedbackNonWindUp.y, integratorEntry.u1) annotation(
    Line(points = {{111, 80}, {-40, 80}, {-40, 46}, {-22, 46}}, color = {0, 0, 127}));
  connect(integratorEntry.y, integrator.u) annotation(
    Line(points = {{1, 40}, {18, 40}}, color = {0, 0, 127}));
  connect(gain.u, feedback.y) annotation(
    Line(points = {{-2, -20}, {-40, -20}, {-40, 0}, {-51, 0}}, color = {0, 0, 127}));
  connect(feedback.y, integratorEntry.u2) annotation(
    Line(points = {{-51, 0}, {-40, 0}, {-40, 34}, {-22, 34}}, color = {0, 0, 127}));
  connect(limiterWithLag.y, EfdPu) annotation(
    Line(points = {{162, 0}, {210, 0}}, color = {0, 0, 127}));
  connect(deltaUsRefPu, UsRefTotal.u1) annotation(
    Line(points = {{-220, 20}, {-180, 20}, {-180, 6}, {-162, 6}}, color = {0, 0, 127}));
  connect(UsRefPu, UsRefTotal.u2) annotation(
    Line(points = {{-220, -20}, {-180, -20}, {-180, -6}, {-162, -6}}, color = {0, 0, 127}));
  connect(UsRefTotal.y, limUsRef.u) annotation(
    Line(points = {{-138, 0}, {-122, 0}}, color = {0, 0, 127}));
  connect(UsPu, feedback.u2) annotation(
    Line(points = {{-220, -60}, {-60, -60}, {-60, -8}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end VRProportionalIntegral;
