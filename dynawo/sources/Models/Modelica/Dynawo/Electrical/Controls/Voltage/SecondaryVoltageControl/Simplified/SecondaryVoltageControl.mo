within Dynawo.Electrical.Controls.Voltage.SecondaryVoltageControl.Simplified;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SecondaryVoltageControl "Model for simplified secondary voltage control"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  //Regulation parameters
  parameter Types.PerUnit Alpha "PI integral gain";
  parameter Types.PerUnit Beta "PI proportional gain";
  parameter Types.PerUnit DerLevelMaxPu "Level slope limitation in pu/min (base QNomAlt)";
  parameter Boolean FreezingActivated = false "If true, the freezing functionality is activated";
  parameter Integer NbMaxGen = 50 "Maximum number of generators that can participate in the secondary voltage control";

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput[NbMaxGen] limUQDown(start = limUQDown0) "If true, the reactive power lower limits are reached (for each generator participating in the secondary voltage control)";
  Modelica.Blocks.Interfaces.BooleanInput[NbMaxGen] limUQUp(start = limUQUp0) "If true, the reactive power upper limits are reached (for each generator participating in the secondary voltage control)";
  Modelica.Blocks.Interfaces.RealInput UpPu(start = Up0Pu) "Voltage of pilot point in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UpRefPu(start = UpRef0Pu) "Reference voltage of pilot point in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput level(start = Level0) "Level demand (between -1 and 1)" annotation(
    Placement(visible = true, transformation(origin = {230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Blocks
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 1) annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(outMax = 1, y_start = Level0) annotation(
    Placement(visible = true, transformation(origin = {50, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = DerLevelMaxPu / 60) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Alpha) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Beta) annotation(
    Placement(visible = true, transformation(origin = {-90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-180, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {140, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {10, -8}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit Level0 "Initial level demand (between -1 and 1)" annotation(
    Dialog(group = "Initialization"));
  parameter Boolean[NbMaxGen] limUQDown0 = fill(true, NbMaxGen) "If true, the reactive power lower limits are initially reached (for each generator participating in the secondary voltage control)";
  parameter Boolean[NbMaxGen] limUQUp0 = fill(true, NbMaxGen) "If true, the reactive power upper limits are initially reached (for each generator participating in the secondary voltage control)";
  parameter Types.VoltageModulePu Up0Pu "Initial pilot point voltage in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu UpRef0Pu "Initial reference voltage of pilot point in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Boolean Frozen0 = false "Start value of the frozen status";

protected
  Boolean blockedDown(start = Modelica.Math.BooleanVectors.allTrue(limUQDown0)) "If true, all generators have reached their reactive power lower limits";
  Boolean blockedUp(start = Modelica.Math.BooleanVectors.allTrue(limUQUp0)) "If true, all generators have reached their reactive power upper limits";
  Boolean frozen(start = Frozen0) "True if the integration is frozen";

equation
  blockedUp = Modelica.Math.BooleanVectors.allTrue(limUQUp);
  blockedDown = Modelica.Math.BooleanVectors.allTrue(limUQDown);
  frozen = FreezingActivated and ((blockedUp and (UpRefPu - UpPu) > 0) or (blockedDown and (UpRefPu - UpPu) < 0));
  when frozen and not(pre(frozen)) then
    Timeline.logEvent1 (TimelineKeys.VRFrozen);
  elsewhen not(frozen) and pre(frozen) then
    Timeline.logEvent1 (TimelineKeys.VRUnfrozen);
  end when;
  switch1.u2 = frozen;

  connect(limiter.y, level) annotation(
    Line(points = {{181, 0}, {230, 0}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{-79, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(UpRefPu, feedback1.u1) annotation(
    Line(points = {{-220, 0}, {-188, 0}}, color = {0, 0, 127}));
  connect(add.y, limiter.u) annotation(
    Line(points = {{121, 0}, {158, 0}}, color = {0, 0, 127}));
  connect(UpPu, feedback1.u2) annotation(
    Line(points = {{-220, -60}, {-180, -60}, {-180, -8}}, color = {0, 0, 127}));
  connect(feedback1.y, gain1.u) annotation(
    Line(points = {{-171, 0}, {-160, 0}, {-160, 40}, {-102, 40}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{-79, 40}, {80, 40}, {80, 6}, {98, 6}}, color = {0, 0, 127}));
  connect(add.y, feedback.u2) annotation(
    Line(points = {{121, 0}, {140, 0}, {140, -52}}, color = {0, 0, 127}));
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{181, 0}, {200, 0}, {200, -60}, {148, -60}}, color = {0, 0, 127}));
  connect(feedback1.y, add1.u1) annotation(
    Line(points = {{-171, 0}, {-160, 0}, {-160, 6}, {-142, 6}}, color = {0, 0, 127}));
  connect(add1.y, gain.u) annotation(
    Line(points = {{-119, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(feedback.y, add1.u2) annotation(
    Line(points = {{131, -60}, {-160, -60}, {-160, -6}, {-142, -6}}, color = {0, 0, 127}));
  connect(limiter1.y, switch1.u3) annotation(
    Line(points = {{-38, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(Zero.y, switch1.u1) annotation(
    Line(points = {{-39, -40}, {-20, -40}, {-20, -16}, {-2, -16}}, color = {0, 0, 127}));
  connect(switch1.y, limIntegrator.u) annotation(
    Line(points = {{22, -8}, {38, -8}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add.u2) annotation(
    Line(points = {{62, -8}, {80, -8}, {80, -6}, {98, -6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -100}, {220, 100}})));
end SecondaryVoltageControl;
