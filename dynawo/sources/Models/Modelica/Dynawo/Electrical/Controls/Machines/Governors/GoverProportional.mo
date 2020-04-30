within Dynawo.Electrical.Controls.Machines.Governors;

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

model GoverProportional "Keep the mechanical power as a constant modulated by the difference between omega and a reference"
  // as a result, the mechanical power will vary with (angular) frequency

  import Modelica;
  import Dynawo;

  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  type status = enumeration (Standard "Active power is modulated by the frequency deviation",
                             LimitPMin "Active power is fixed to its minimum value",
                             LimitPMax "Active power is fixed to its maximum value");

  //Input variables
  Dynawo.Connectors.ImPin omegaPu(value (start = SystemBase.omega0Pu)) "Angular frequency" annotation(
    Placement(visible = true, transformation(origin = {-106, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-106, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Dynawo.Connectors.ImPin PmRefPu(value(start = Pm0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-106, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-106, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  //Output variables
  Dynawo.Connectors.ImPin PmPu(value (start = Pm0Pu)) "Mechanical power in p.u (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {130, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  parameter Types.PerUnit KGover  "Mechanical power sensitivity to frequency";
  parameter Types.ActivePower PMin  "Minimum mechanical power in MW";
  parameter Types.ActivePower PMax  "Maximum mechanical power in MW";   // may be negative (for power plants which may be pumping)
  parameter Types.ActivePower PNom  "Nominal active power in MW";

  Modelica.Blocks.Math.Gain gain(k=KGover) annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add PmRawPu annotation(
    Placement(visible = true, transformation(origin = {-24, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-106, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) "Angular reference frequency" annotation(
    Placement(visible = true, transformation(origin = {-154, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-154, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true,uMax=PMaxPu, uMin=PMinPu) annotation(
    Placement(visible = true, transformation(origin = {14, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmCst(k = Pm0Pu)  annotation(
    Placement(visible = true, transformation(origin = {14, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant activeFrequencyRegulation(k = ActiveFrequencyRegulation) annotation(
    Placement(visible = true, transformation(origin = {14, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in p.u (base PNom)";
  final parameter Types.ActivePowerPu PMinPu = PMin/PNom "Minimum mechanical power in p.u (base PNom)";
  final parameter Types.ActivePowerPu PMaxPu = PMax/PNom "Maximum mechanical power in p.u (base PNom)";
  final parameter Boolean ActiveFrequencyRegulation= if Pm0Pu<PMin/PNom then false else true "Boolean indicating whether the group participates to primary frequency control or not";

  status state (start = status.Standard);

equation
  connect(activeFrequencyRegulation.y, switch.u2) annotation(
    Line(points = {{25, -34}, {41.5, -34}, {41.5, 0}, {66, 0}}, color = {255, 0, 255}));
  connect(PmCst.y, switch.u3) annotation(
    Line(points = {{25, -66}, {52, -66}, {52, -8}, {66, -8}}, color = {0, 0, 127}));
  connect(limiter.y, switch.u1) annotation(
    Line(points = {{26, 0}, {32, 0}, {32, 8}, {66, 8}, {66, 8}}, color = {0, 0, 127}));
  connect(switch.y, PmPu.value) annotation(
    Line(points = {{90, 0}, {118, 0}, {118, 0}, {130, 0}}, color = {0, 0, 127}));
  connect(PmRawPu.y, limiter.u) annotation(
    Line(points = {{-13, 0}, {2, 0}}, color = {0, 0, 127}));
  connect(gain.y, PmRawPu.u2) annotation(
    Line(points = {{-57, 0}, {-52, 0}, {-52, 0}, {-49, 0}, {-49, -6}, {-35, -6}, {-35, -6}, {-37, -6}, {-37, -6}}, color = {0, 0, 127}));
  connect(PmRawPu.u1, PmRefPu.value) annotation(
    Line(points = {{-36, 6}, {-46, 6}, {-46, 60}, {-106, 60}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-96, 0}, {-80, 0}}, color = {0, 0, 127}));
  connect(omegaPu.value, feedback.u2) annotation(
    Line(points = {{-106, -48}, {-106, -48}, {-106, -8}, {-106, -8}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, feedback.u1) annotation(
    Line(points = {{-154, 0}, {-114, 0}, {-114, 0}, {-114, 0}}, color = {0, 0, 127}));
  when PmRawPu.y >= PMaxPu  and pre(state) <> status.LimitPMax then
    state = status.LimitPMax;
    Timeline.logEvent1(TimelineKeys.ActivatePMAX);
  elsewhen PmRawPu.y <= PMinPu and pre(state) <> status.LimitPMin then
    state = status.LimitPMin;
    Timeline.logEvent1(TimelineKeys.ActivatePMIN);
  elsewhen PmRawPu.y > PMinPu and PmRawPu.y < PMaxPu and pre(state) == status.LimitPMin then
    state = status.Standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMIN);
  elsewhen PmRawPu.y > PMinPu and PmRawPu.y < PMaxPu and pre(state) == status.LimitPMax then
    state = status.Standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMAX);
  end when;

annotation(preferredView = "diagram");
end GoverProportional;
