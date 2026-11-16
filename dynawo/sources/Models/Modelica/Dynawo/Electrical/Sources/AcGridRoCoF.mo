within Dynawo.Electrical.Sources;

/*
  * Copyright (c) 2026, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, a hybrid C++/Modelica open source suite
  * of simulation tools for power systems.
*/

model AcGridRoCoF "AC Grid emulating a single permanent RoCoF disturbance"

  parameter Types.VoltageModulePu U0Pu "Voltage amplitude at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Voltage phase angle at terminal in rad";
  parameter Types.Time tRoCoFStart "Start time of the RoCoF event in s";
  parameter Types.Time tRoCoFDuration "Duration of the RoCoF ramp in s";
  parameter Real RoCoFPu "Rate of change of frequency in pu/s (base omegaNom)";
  parameter Types.PerUnit deltaOmega0Pu "Initial angular frequency deviation from omegaRef in pu (base omegaNom), e.g. -0.01 for 49.5 Hz";
  parameter Boolean ReturnRoCoF = false "If true, after the RoCoF ramp the frequency returns to its starting value with the opposite ramp";

  // Input
  Modelica.Blocks.Interfaces.RealInput omegaRefPu "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-120, 52}, extent = {{-20, -20}, {20, 20}})));

  // Output
  Modelica.Blocks.Interfaces.RealOutput omegaPu "Angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {110, 60}, extent = {{-11, -11}, {11, 11}}), iconTransformation(extent = {{99, -73}, {129, -43}})));

  // Voltage source terminal
  Dynawo.Connectors.ACPower aCPower annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {120, 74}, extent = {{-20, -20}, {10, 10}})));

  Modelica.Blocks.Sources.Step RoCof(height = RoCoFPu, offset = 0, startTime = tRoCoFStart) annotation(
    Placement(transformation(origin = {-90, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = -RoCoFPu, offset = 0, startTime = tRoCoFStart + tRoCoFDuration) annotation(
    Placement(transformation(origin = {-90, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step stepReturnStart(height = if ReturnRoCoF then -RoCoFPu else 0, offset = 0, startTime = tRoCoFStart + tRoCoFDuration) annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step stepReturnEnd(height = if ReturnRoCoF then RoCoFPu else 0, offset = 0, startTime = if ReturnRoCoF then tRoCoFStart + 2*tRoCoFDuration else tRoCoFStart + tRoCoFDuration) annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addReturn annotation(
    Placement(transformation(origin = {-70, -1}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add3 add6 annotation(
    Placement(visible = true, transformation(origin = {-40, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator integrator3(k = 1, y_start = 0) annotation(
    Placement(transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(transformation(origin = {40, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add4(k2 = -1) annotation(
    Placement(transformation(origin = {50, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator integrator1(k = SystemBase.omegaNom, y_start = 0) annotation(
    Placement(transformation(origin = {78, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput theta annotation(
    Placement(transformation(origin = {109, -61}, extent = {{-10, -10}, {10, 10}}), iconTransformation(extent = {{99, -73}, {129, -43}})));
  Modelica.Blocks.Sources.Constant initialFreq(k = deltaOmega0Pu) annotation(
    Placement(transformation(origin = {38, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}})));

equation
  aCPower.V.re = U0Pu*cos(UPhase0 + integrator1.y);
  aCPower.V.im = U0Pu*sin(UPhase0 + integrator1.y);

  connect(RoCof.y, add6.u1) annotation(
    Line(points = {{-79, 80}, {-60.25, 80}, {-60.25, 68}, {-52, 68}}, color = {0, 0, 127}));
  connect(step.y, add6.u2) annotation(
    Line(points = {{-79, 40}, {-60, 40}, {-60, 60}, {-52, 60}}, color = {0, 0, 127}));
  connect(stepReturnStart.y, addReturn.u1) annotation(
    Line(points = {{-99, 20}, {-90, 20}, {-90, 5}, {-82, 5}}, color = {0, 0, 127}));
  connect(stepReturnEnd.y, addReturn.u2) annotation(
    Line(points = {{-99, -20}, {-90, -20}, {-90, -7}, {-82, -7}}, color = {0, 0, 127}));
  connect(addReturn.y, add6.u3) annotation(
    Line(points = {{-59, -1}, {-56, -1}, {-56, 52}, {-52, 52}}, color = {0, 0, 127}));
  connect(add6.y, integrator3.u) annotation(
    Line(points = {{-29, 60}, {-22, 60}}, color = {0, 0, 127}));
  connect(integrator3.y, add5.u1) annotation(
    Line(points = {{1, 60}, {20, 60}, {20, 46}, {28, 46}}, color = {0, 0, 127}));
  connect(omegaRefPu, add5.u2) annotation(
    Line(points = {{-110, -80}, {20, -80}, {20, 34}, {28, 34}}, color = {0, 0, 127}));
  connect(omegaPu, add4.u1) annotation(
    Line(points = {{110, 60}, {20, 60}, {20, -54}, {38, -54}}, color = {0, 0, 127}));
  connect(omegaRefPu, add4.u2) annotation(
    Line(points = {{-110, -80}, {-36, -80}, {-36, -66}, {38, -66}}, color = {0, 0, 127}));
  connect(add4.y, integrator1.u) annotation(
    Line(points = {{61, -60}, {66, -60}}, color = {0, 0, 127}));
  connect(integrator1.y, theta) annotation(
    Line(points = {{89, -60}, {105, -60}, {105, -61}, {109, -61}}, color = {0, 0, 127}));
  connect(add5.y, add.u1) annotation(
    Line(points = {{51, 40}, {58, 40}, {58, 26}}, color = {0, 0, 127}));
  connect(initialFreq.y, add.u2) annotation(
    Line(points = {{49, 0}, {58, 0}, {58, 14}}, color = {0, 0, 127}));
  connect(add.y, omegaPu) annotation(
    Line(points = {{81, 20}, {84, 20}, {84, 60}, {110, 60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>AC Grid model imposing a SINGLE, PERMANENT RoCoF disturbance on the frequency seen at the connected terminal (DTR I18 Test 4 : the simulation runs until steady state is reached at the NEW frequency level, there is no return to the original reference), with no synchronous machine dynamics (no governor, turbine, or inertia), and no precompiled sub-component (voltage source equations written explicitly to avoid any nested-precompiled-model issue). The frequency starts at omegaRefPu + deltaOmega0Pu (pu, base omegaNom -- e.g. the initial value 49.5/50.5 Hz of the DTR's 4 profiles), then ramps by RoCoFPu (pu/s) between t=tRoCoFStart and t=tRoCoFStart+tRoCoFDuration, and is held at that new level permanently afterwards.<br><br>Optionally, with ReturnRoCoF = true (default false), the frequency then ramps back to its starting value with the opposite rate (-RoCoFPu) between t=tRoCoFStart+tRoCoFDuration and t=tRoCoFStart+2*tRoCoFDuration, and is held at its starting value afterwards (V-shaped frequency profile).</body></html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Text(origin = {175, -38}, extent = {{-45, 40}, {45, -40}}, textString = "OmegaPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 8}, extent = {{-74, 50}, {74, -50}}, textString = "ACGrid")}));
end AcGridRoCoF;
