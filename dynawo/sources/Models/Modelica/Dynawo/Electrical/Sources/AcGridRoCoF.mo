within Dynawo.Electrical.Sources;

model AcGridRoCoF "AC Grid emulating a single permanent RoCoF disturbance"
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
  parameter Real SNom;
  parameter Real U0pu;
  parameter Real UPhase0;
  parameter Real Upu(start = U0pu);
  parameter Real UPhase(start = UPhase0);
  parameter Real StartRoCoF "Start Time of the RoCoF event (in s)";
  parameter Real TimeRoCoF "Time interval (in s) of the RoCoF event";
  parameter Real RoCoFValue "Value Rate of Change of Frequency (pu/s, base omegaNom)";
  parameter Real StartingFrequency "Starting frequency compared to the nominal value of 1 p.u. : e.g. for a starting frequency of 49.5 Hz --> -0.01 p.u";
  parameter Boolean ReturnRoCoF = false "If true, after the RoCoF ramp the frequency returns to its starting value with the opposite ramp";
  // ----- Voltage source terminal -----
  Dynawo.Connectors.ACPower aCPower annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 74}, extent = {{-20, -20}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PPu annotation(
    Placement(visible = true, transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QPu annotation(
    Placement(visible = true, transformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // ----- Inputs / outputs -----
  Modelica.Blocks.Interfaces.RealInput OmegaRef annotation(
    Placement(transformation(origin = {-110, -94}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 52}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput omegaPu annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(extent = {{99, -73}, {129, -43}}, rotation = 0)));
  Modelica.Blocks.Sources.Step RoCof(height = RoCoFValue, offset = 0, startTime = StartRoCoF) annotation(
    Placement(visible = true, transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = -RoCoFValue, offset = 0, startTime = StartRoCoF + TimeRoCoF) annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step stepReturnStart(height = if ReturnRoCoF then -RoCoFValue else 0, offset = 0, startTime = StartRoCoF + TimeRoCoF) annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step stepReturnEnd(height = if ReturnRoCoF then RoCoFValue else 0, offset = 0, startTime = if ReturnRoCoF then StartRoCoF + 2*TimeRoCoF else StartRoCoF + TimeRoCoF) annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addReturn annotation(
    Placement(visible = true, transformation(origin = {-75, 10}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Blocks.Math.Add3 add6 annotation(
    Placement(visible = true, transformation(origin = {-40, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator integrator3(k = 1, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {40, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add4(k2 = -1) annotation(
    Placement(transformation(origin = {44, -66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator integrator1(k = SystemBase.omegaNom, y_start = 0) annotation(
    Placement(transformation(origin = {84, -66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput theta annotation(
    Placement(transformation(origin = {114, -66}, extent = {{-15, -15}, {15, 15}}), iconTransformation(extent = {{99, -73}, {129, -43}})));
equation
  aCPower.V.re = Upu*cos(UPhase + integrator1.y);
  aCPower.V.im = Upu*sin(UPhase + integrator1.y);
  PPu = -(aCPower.V.re*aCPower.i.re + aCPower.V.im*aCPower.i.im)*SystemBase.SnRef/SNom;
  QPu = -(aCPower.V.im*aCPower.i.re - aCPower.V.re*aCPower.i.im)*SystemBase.SnRef/SNom;
  connect(RoCof.y, add6.u1) annotation(
    Line(points = {{-69, 80}, {-52, 80}, {-52, 68}}, color = {0, 0, 127}));
  connect(step.y, add6.u2) annotation(
    Line(points = {{-69, 40}, {-60, 40}, {-60, 60}, {-52, 60}}, color = {0, 0, 127}));
  connect(stepReturnStart.y, addReturn.u1) annotation(
    Line(points = {{-99, 20}, {-90, 20}, {-90, 14}, {-83, 14}}, color = {0, 0, 127}));
  connect(stepReturnEnd.y, addReturn.u2) annotation(
    Line(points = {{-99, -20}, {-90, -20}, {-90, 6}, {-83, 6}}, color = {0, 0, 127}));
  connect(addReturn.y, add6.u3) annotation(
    Line(points = {{-67, 10}, {-56, 10}, {-56, 52}, {-52, 52}}, color = {0, 0, 127}));
  connect(add6.y, integrator3.u) annotation(
    Line(points = {{-29, 60}, {-12, 60}}, color = {0, 0, 127}));
  connect(integrator3.y, add5.u1) annotation(
    Line(points = {{11, 60}, {20, 60}, {20, 36}, {28, 36}}, color = {0, 0, 127}));
  connect(OmegaRef, add5.u2) annotation(
    Line(points = {{-110, -94}, {20, -94}, {20, 24}, {28, 24}}, color = {0, 0, 127}));
  omegaPu = add5.y + StartingFrequency;
  connect(omegaPu, add4.u1) annotation(
    Line(points = {{110, 60}, {20, 60}, {20, -60}, {32, -60}}, color = {0, 0, 127}));
  connect(OmegaRef, add4.u2) annotation(
    Line(points = {{-110, -94}, {-41, -94}, {-41, -72}, {32, -72}}, color = {0, 0, 127}));
  connect(add4.y, integrator1.u) annotation(
    Line(points = {{55, -66}, {72, -66}}, color = {0, 0, 127}));
  connect(integrator1.y, theta) annotation(
    Line(points = {{96, -66}, {114, -66}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>AC Grid model imposing a SINGLE, PERMANENT RoCoF disturbance on the frequency seen at the connected terminal (DTR I18 Test 4 : the simulation runs until steady state is reached at the NEW frequency level, there is no return to the original reference), with no synchronous machine dynamics (no governor, turbine, or inertia), and no precompiled sub-component (voltage source equations written explicitly to avoid any nested-precompiled-model issue). The frequency starts at StartingFrequency (pu, base omegaNom -- e.g. the 'valeur initiale' 49.5/50.5 Hz of the DTR's 4 profiles), then ramps by RoCoFValue (pu/s) between t=StartRoCoF and t=StartRoCoF+TimeRoCoF, and is held at that new level permanently afterwards.<br><br>Optionally, with ReturnRoCoF = true (default false), the frequency then ramps back to its starting value with the opposite rate (-RoCoFValue) between t=StartRoCoF+TimeRoCoF and t=StartRoCoF+2*TimeRoCoF, and is held at its starting value afterwards (V-shaped frequency profile).</body></html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Text(origin = {175, -38}, extent = {{-45, 40}, {45, -40}}, textString = "OmegaPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 8}, extent = {{-74, 50}, {74, -50}}, textString = "ACGrid")}));
end AcGridRoCoF;
