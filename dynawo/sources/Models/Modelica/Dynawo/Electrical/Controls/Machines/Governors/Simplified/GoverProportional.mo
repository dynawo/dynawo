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
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GoverProportional "Keeps the mechanical power as a constant modulated by the difference between omega and a reference"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  type status = enumeration(Standard "Active power is modulated by the frequency deviation",
                            LimitPMin "Active power is fixed to its minimum value",
                            LimitPMax "Active power is fixed to its maximum value");

  //Input variables
  Modelica.Blocks.Interfaces.RealInput deltaPmRefPu(start = 0) "Additional reference mechanical power in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) "Reference mechanical power in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
  parameter Types.ActivePower PMax "Maximum mechanical power in MW";
  parameter Types.ActivePower PMin "Minimum mechanical power in MW";
  parameter Types.ActivePower PNom "Nominal active power in MW";

  final parameter Boolean ActiveFrequencyRegulation = if Pm0Pu < PMin / PNom or Pm0Pu > PMax / PNom then false else true "If true, the group participates to primary frequency control";
  final parameter Types.ActivePowerPu PMaxPu = PMax / PNom "Maximum mechanical power in pu (base PNom)";
  final parameter Types.ActivePowerPu PMinPu = PMin / PNom "Minimum mechanical power in pu (base PNom)";

  status state(start = status.Standard);

  Modelica.Blocks.Math.Gain gain(k = KGover) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 PmRawPu annotation(
    Placement(visible = true, transformation(origin = {30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) "Angular reference frequency" annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmCst(k = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant activeFrequencyRegulation(k = ActiveFrequencyRegulation) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNom)";

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

  connect(activeFrequencyRegulation.y, switch.u2) annotation(
    Line(points = {{81, 0}, {118, 0}}, color = {255, 0, 255}));
  connect(PmCst.y, switch.u3) annotation(
    Line(points = {{81, -40}, {100, -40}, {100, -8}, {118, -8}}, color = {0, 0, 127}));
  connect(limiter.y, switch.u1) annotation(
    Line(points = {{81, 40}, {100, 40}, {100, 8}, {118, 8}}, color = {0, 0, 127}));
  connect(PmRawPu.y, limiter.u) annotation(
    Line(points = {{41, 40}, {58, 40}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-71, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, feedback.u1) annotation(
    Line(points = {{-119, 0}, {-88, 0}}, color = {0, 0, 127}));
  connect(switch.y, PmPu) annotation(
    Line(points = {{141, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(omegaPu, feedback.u2) annotation(
    Line(points = {{-180, -40}, {-80, -40}, {-80, -8}}, color = {0, 0, 127}));
  connect(PmRefPu, PmRawPu.u2) annotation(
    Line(points = {{-180, 40}, {18, 40}}, color = {0, 0, 127}));
  connect(deltaPmRefPu, PmRawPu.u1) annotation(
    Line(points = {{-180, 80}, {0, 80}, {0, 48}, {18, 48}}, color = {0, 0, 127}));
  connect(gain.y, PmRawPu.u3) annotation(
    Line(points = {{-19, 0}, {0, 0}, {0, 32}, {17, 32}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
  Documentation(info = "<html><head></head><body>As a result, the mechanical power will vary with (angular) frequency.<div><br></div><div>PMax and PMin may be negative, for power plants which may be pumping.</div></body></html>"));
end GoverProportional;
