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

  parameter Real SNom;
  parameter Real U0pu;
  parameter Real UPhase0;
  parameter Real Upu(start = U0pu);
  parameter Real UPhase(start = UPhase0);
  parameter Real StartRoCoF "Start Time of the RoCoF event (in s)";
  parameter Real TimeRoCoF "Time interval (in s) of the RoCoF event";
  parameter Real RoCoFValue "Value Rate of Change of Frequency (pu/s, base omegaNom)";
  parameter Real StartingFrequency "Starting frequency compared to the nominal value of 1 p.u. : e.g. for a starting frequency of 49.5 Hz --> -0.01 p.u";

  // ----- Voltage source terminal -----
  Dynawo.Connectors.ACPower aCPower annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 74}, extent = {{-20, -20}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PPu annotation(
    Placement(visible = true, transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QPu annotation(
    Placement(visible = true, transformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // ----- Inputs / outputs -----
  Modelica.Blocks.Interfaces.RealInput OmegaRef annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 52}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(extent = {{99, -73}, {129, -43}}, rotation = 0)));

  // ----- Unique RoCoF event : rampe de StartRoCoF a StartRoCoF+TimeRoCoF, puis
  // PLATEAU PERMANENT (plus de second evenement de retour -- cf. DTR I18 Test
  // 4, qui demande un seul changement de frequence, tenu jusqu'au regime
  // permanent). StartRoCoF/TimeRoCoF pilotent reellement les Step ci-dessous
  // .
  Modelica.Blocks.Sources.Step RoCof(height = RoCoFValue, offset = 0, startTime = StartRoCoF) annotation(
    Placement(visible = true, transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = -RoCoFValue, offset = 0, startTime = StartRoCoF + TimeRoCoF) annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add6 annotation(
    Placement(visible = true, transformation(origin = {-40, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator integrator3(k = 1, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}})));

  // ----- Combinaison de la rampe avec la reference de frequence -----
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {40, 30}, extent = {{-10, -10}, {10, 10}})));

  // ----- Phase integration driven by the frequency deviation (RoCoF) -----
  Modelica.Blocks.Math.Add add4(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {40, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator integrator1(k = SystemBase.omegaNom, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {80, -10}, extent = {{-10, -10}, {10, 10}})));

equation
  // ----- Explicit voltage source equations (replaces PhasorGrid sub-component) -----
  aCPower.V.re = Upu * cos(UPhase + integrator1.y);
  aCPower.V.im = Upu * sin(UPhase + integrator1.y);
  PPu = -(aCPower.V.re * aCPower.i.re + aCPower.V.im * aCPower.i.im) * SystemBase.SnRef / SNom;
  QPu = -(aCPower.V.im * aCPower.i.re - aCPower.V.re * aCPower.i.im) * SystemBase.SnRef / SNom;

  // Rampe unique : RoCof (demarre a StartRoCoF) + step (l'annule a
  // StartRoCoF+TimeRoCoF) -> integrator3 donne une rampe puis un plateau tenu
  // en permanence (plus de second evenement de retour).
  connect(RoCof.y, add6.u1) annotation(
    Line(points = {{-69, 80}, {-52, 80}, {-52, 66}}, color = {0, 0, 127}));
  connect(step.y, add6.u2) annotation(
    Line(points = {{-69, 40}, {-52, 40}, {-52, 54}}, color = {0, 0, 127}));
  connect(add6.y, integrator3.u) annotation(
    Line(points = {{-29, 60}, {-12, 60}}, color = {0, 0, 127}));

  // omegaPu = OmegaRef + StartingFrequency + rampe (plus de contribution
  // gouverneur/inertie, ni de second evenement de retour)
  connect(integrator3.y, add5.u1) annotation(
    Line(points = {{11, 60}, {20, 60}, {20, 36}, {28, 36}}, color = {0, 0, 127}));
  connect(OmegaRef, add5.u2) annotation(
    Line(points = {{-110, 0}, {20, 0}, {20, 24}, {28, 24}}, color = {0, 0, 127}));
  omegaPu = add5.y + StartingFrequency;

  // Phase integration: dTheta/dt = omegaNom * (omegaPu - OmegaRef)
  connect(omegaPu, add4.u1) annotation(
    Line(points = {{110, 60}, {20, 60}, {20, -4}, {28, -4}}, color = {0, 0, 127}));
  connect(OmegaRef, add4.u2) annotation(
    Line(points = {{-110, 0}, {20, 0}, {20, -16}, {28, -16}}, color = {0, 0, 127}));
  connect(add4.y, integrator1.u) annotation(
    Line(points = {{51, -10}, {68, -10}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>AC Grid model imposing a SINGLE, PERMANENT RoCoF disturbance on the frequency seen at the connected terminal (DTR I18 Test 4 : the simulation runs until steady state is reached at the NEW frequency level, there is no return to the original reference), with no synchronous machine dynamics (no governor, turbine, or inertia), and no precompiled sub-component (voltage source equations written explicitly to avoid any nested-precompiled-model issue). The frequency starts at StartingFrequency (pu, base omegaNom -- e.g. the 'valeur initiale' 49.5/50.5 Hz of the DTR's 4 profiles), then ramps by RoCoFValue (pu/s) between t=StartRoCoF and t=StartRoCoF+TimeRoCoF, and is held at that new level permanently afterwards.</body></html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Text(origin = {175, -38}, extent = {{-45, 40}, {45, -40}}, textString = "OmegaPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 8}, extent = {{-74, 50}, {74, -50}}, textString = "ACGrid")}));
end AcGridRoCoF;
