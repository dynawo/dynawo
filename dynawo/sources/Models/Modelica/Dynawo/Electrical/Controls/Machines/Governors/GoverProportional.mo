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

  import Modelica.Blocks;

  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  type status = enumeration (Standard "Active power is modulated by the frequency deviation",
                             LimitPMin "Active power is fixed to its minimum value",
                             LimitPMax "Active power is fixed to its maximum value");

  //Input variables
  Connectors.ImPin omegaPu(value (start = SystemBase.omega0Pu)) "Angular frequency" annotation(
    Placement(visible = true, transformation(origin = {-106, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-106, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Connectors.ImPin PmRefPu(value(start = Pm0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-106, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-106, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  //Output variables
  Connectors.ImPin PmPu(value (start = Pm0Pu)) "Mechanical power" annotation(
    Placement(visible = true, transformation(origin = {72, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {72, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  parameter Types.PerUnit KGover  "Mechanical power sensitivity to frequency";
  parameter Types.ActivePower PMin  "Minimum mechanical power";
  parameter Types.ActivePower PMax  "Maximum mechanical power";   // may be negative (for power plants which may be pumping)
  parameter Types.ActivePower PNom  "Nominal active power";

  Blocks.Math.Gain gain(k=KGover) annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add PmRawPu annotation(
    Placement(visible = true, transformation(origin = {-16, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-106, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) "Angular reference frequency" annotation(
    Placement(visible = true, transformation(origin = {-154, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-154, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Nonlinear.Limiter limiter(limitsAtInit = true,uMax=PMaxPu, uMin=PMinPu) annotation(
    Placement(visible = true, transformation(origin = {28, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
    parameter Types.ActivePowerPu PMinPu = PMin/PNom "Minimum mechanical power Pu";
    parameter Types.ActivePowerPu PMaxPu = PMax/PNom "Maximum mechanical power Pu";
    parameter Types.ActivePowerPu Pm0Pu  "Initial mechanical power";

    status state (start = status.Standard);
equation
  connect(PmRawPu.u1, PmRefPu.value) annotation(
    Line(points = {{-28, 6}, {-38, 6}, {-38, 60}, {-106, 60}}, color = {0, 0, 127}));
  connect(limiter.y, PmPu.value) annotation(
    Line(points = {{40, 0}, {64, 0}, {64, 0}, {72, 0}}, color = {0, 0, 127}));
  connect(PmRawPu.y, limiter.u) annotation(
    Line(points = {{-4, 0}, {14, 0}, {14, 0}, {16, 0}}, color = {0, 0, 127}));
  connect(gain.y, PmRawPu.u2) annotation(
    Line(points = {{-48, 0}, {-40, 0}, {-40, -6}, {-28, -6}, {-28, -6}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-96, 0}, {-72, 0}, {-72, 0}, {-72, 0}}, color = {0, 0, 127}));
  connect(omegaPu.value, feedback.u2) annotation(
    Line(points = {{-106, -48}, {-106, -48}, {-106, -8}, {-106, -8}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, feedback.u1) annotation(
    Line(points = {{-154, 0}, {-114, 0}, {-114, 0}, {-114, 0}}, color = {0, 0, 127}));
  when PmRawPu.y >= PMaxPu then
    state = status.LimitPMax;
    Timeline.logEvent1(TimelineKeys.ActivatePMAX);
  elsewhen PmRawPu.y <= PMinPu then
    state = status.LimitPMin;
    Timeline.logEvent1(TimelineKeys.ActivatePMIN);
  elsewhen PmRawPu.y > PMinPu and PmRawPu.y < PMaxPu and pre(state) == status.LimitPMin then
    state = status.Standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMIN);
  elsewhen PmRawPu.y > PMinPu and PmRawPu.y < PMaxPu and pre(state) == status.LimitPMax then
    state = status.Standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMAX);
  end when;
end GoverProportional;
