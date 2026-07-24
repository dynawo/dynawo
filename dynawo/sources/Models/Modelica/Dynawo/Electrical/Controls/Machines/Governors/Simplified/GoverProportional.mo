within Dynawo.Electrical.Controls.Machines.Governors.Simplified;

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

model GoverProportional "Keeps the mechanical power as a constant modulated by the difference between omega and a reference"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;
  type status = enumeration(Standard "Active power is modulated by the frequency deviation",
                            LimitPMin "Active power is fixed to its minimum value",
                            LimitPMax "Active power is fixed to its maximum value");
  //Input variables
  Modelica.Blocks.Interfaces.RealInput deltaPmRefPu(start = 0) "Additional reference mechanical power in pu (base PNom)" annotation(
    Placement(transformation(origin = {-178, -26}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-178, 16}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) "Reference mechanical power in pu (base PNom)" annotation(
    Placement(transformation(origin = {-178, -66}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.BooleanInput activeFrequencyRegulation(start = ActiveFrequencyRegulation) "If true, the group participates to primary frequency control" annotation(
    Placement(transformation(origin = {36, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {70, 0}, extent = {{-20, -20}, {20, 20}})));
  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
  parameter Types.ActivePower PMax "Maximum mechanical power in MW";
  parameter Types.ActivePower PMin "Minimum mechanical power in MW";
  parameter Types.ActivePower PNom "Nominal active power in MW";
  final parameter Boolean ActiveFrequencyRegulation = if Pm0Pu < PMin/PNom or Pm0Pu > PMax/PNom then false else true "If true, the group initially participates to primary frequency control";
  final parameter Types.ActivePowerPu PMaxPu = PMax / PNom "Maximum mechanical power in pu (base PNom)";
  final parameter Types.ActivePowerPu PMinPu = PMin / PNom "Minimum mechanical power in pu (base PNom)";
  status state(start = status.Standard);
  Modelica.Blocks.Math.Gain gain(k = KGover) annotation(
    Placement(transformation(origin = {-40, 58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(origin = {-90, 58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) "Angular reference frequency" annotation(
    Placement(transformation(origin = {-140, 58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(transformation(origin = {70, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNom)";
  Modelica.Blocks.Math.Add PmRefTotPu annotation(
    Placement(transformation(origin = {-42, -32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add PmRawPu annotation(
    Placement(transformation(origin = {22, 42}, extent = {{-10, -10}, {10, 10}})));
equation
  when PmRawPu.y >= PMaxPu and pre(state) <> status.LimitPMax then
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
  connect(limiter.y, switch.u1) annotation(
    Line(points = {{81, 42}, {100, 42}, {100, 8}, {118, 8}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-81, 58}, {-52, 58}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, feedback.u1) annotation(
    Line(points = {{-129, 58}, {-98, 58}}, color = {0, 0, 127}));
  connect(switch.y, PmPu) annotation(
    Line(points = {{141, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(omegaPu, feedback.u2) annotation(
    Line(points = {{-178, 16}, {-90, 16}, {-90, 50}}, color = {0, 0, 127}));
  connect(deltaPmRefPu, PmRefTotPu.u1) annotation(
    Line(points = {{-178, -26}, {-54, -26}}, color = {0, 0, 127}));
  connect(PmRefPu, PmRefTotPu.u2) annotation(
    Line(points = {{-178, -66}, {-74, -66}, {-74, -37}, {-56, -37}, {-56, -38.5}, {-54, -38.5}, {-54, -38}}, color = {0, 0, 127}));
  connect(gain.y, PmRawPu.u1) annotation(
    Line(points = {{-28, 58}, {-6, 58}, {-6, 49}, {10, 49}, {10, 48}}, color = {0, 0, 127}));
  connect(PmRefTotPu.y, PmRawPu.u2) annotation(
    Line(points = {{-30, -32}, {-6, -32}, {-6, 36}, {10, 36}, {10, 36}}, color = {0, 0, 127}));
  connect(PmRawPu.y, limiter.u) annotation(
    Line(points = {{34, 42}, {58, 42}}, color = {0, 0, 127}));
  connect(PmRefTotPu.y, switch.u3) annotation(
    Line(points = {{-30, -32}, {98, -32}, {98, -8}, {118, -8}, {118, -8}}, color = {0, 0, 127}));
  connect(activeFrequencyRegulation, switch.u2) annotation(
    Line(points = {{36, 0}, {118, 0}}, color = {255, 0, 255}));
  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body>As a result, the mechanical power will vary with (angular) frequency.<div><br></div><div>PMax and PMin may be negative, for power plants which may be pumping.</div></body></html>"));
end GoverProportional;
