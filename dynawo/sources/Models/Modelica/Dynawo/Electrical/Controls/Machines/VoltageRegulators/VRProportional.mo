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

model VRProportional "Simple Proportional Voltage Regulator"

  import Modelica;

  import Dynawo.NonElectrical.Blocks.NonLinear.LimiterWithLag;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Real Gain "Control gain";
  parameter Types.VoltageModulePu UsRefMaxPu "Maximum stator reference voltage in p.u (base UNom)";
  parameter Types.VoltageModulePu UsRefMinPu "Maximum stator reference voltage in p.u (base UNom)";
  parameter Types.VoltageModulePu EfdMinPu "Minimum allowed EfdPu";
  parameter Types.VoltageModulePu EfdMaxPu "Maximum allowed EfdPu";
  parameter Types.Time LagEfdMin "Time lag before taking action when going below EfdMin";
  parameter Types.Time LagEfdMax "Time lag before taking action when going above EfdMax";

  LimiterWithLag limiterWithLag(UMin = EfdMinPu, UMax = EfdMaxPu, LagMin = LagEfdMin, LagMax = LagEfdMax, tUMinReached0 = tEfdMinReached0, tUMaxReached0 = tEfdMaxReached0) "Limiter activated only after a certain period outside the bounds" annotation(
    Placement(visible = true, transformation(origin = {64, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Gain) annotation(
    Placement(visible = true, transformation(origin = {14, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-22, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "General control voltage" annotation(
    Placement(visible = true, transformation(origin = {-108, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-108, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage" annotation(
    Placement(visible = true, transformation(origin = {-22, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-56, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Exciter field voltage" annotation(
    Placement(visible = true, transformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ImPin EfdPuPin(value(start = Efd0Pu)) "Exciter field voltage Pin";
  Connectors.BPin  limitationUp (value (start = false)) "Limitation up reached ?";
  Connectors.BPin  limitationDown (value (start = false)) "Limitation down reached ?";
  Modelica.Blocks.Nonlinear.Limiter limUsRef(limitsAtInit = true, uMax = UsRefMaxPu, uMin = UsRefMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected

  parameter Types.VoltageModulePu UsRef0Pu "Initial control voltage";
  // p.u. = Unom
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage";
  // p.u. = Unom
  parameter Types.VoltageModulePu Efd0Pu "Initial Efd, i.e Efd0PuLF if compliant with saturations";
  parameter Types.Time tEfdMaxReached0 "Initial time when Efd went above EfdMax";
  parameter Types.Time tEfdMinReached0 "Initial time when Efd went below EfdMin";
  parameter Types.VoltageModulePu Efd0PuLF "Initial Efd from LoadFlow";

equation
  connect(limUsRef.y, feedback.u1) annotation(
    Line(points = {{-50, 0}, {-30, 0}, {-30, 0}, {-30, 0}}, color = {0, 0, 127}));
  connect(UsRefPu, limUsRef.u) annotation(
    Line(points = {{-108, 0}, {-76, 0}, {-76, 0}, {-74, 0}}, color = {0, 0, 127}));
  connect(EfdPuPin.value, EfdPu) annotation(
    Line);
  connect(limiterWithLag.y, EfdPu) annotation(
    Line(points = {{75, 0}, {108, 0}}, color = {0, 0, 127}));
  connect(gain.y, limiterWithLag.u) annotation(
    Line(points = {{25, 0}, {49, 0}, {49, 0}, {51, 0}}, color = {0, 0, 127}));
  connect(gain.u, feedback.y) annotation(
    Line(points = {{2, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(UsPu, feedback.u2) annotation(
    Line(points = {{-22, -48}, {-22, -48}, {-22, -8}, {-22, -8}}, color = {0, 0, 127}));

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

end VRProportional;
