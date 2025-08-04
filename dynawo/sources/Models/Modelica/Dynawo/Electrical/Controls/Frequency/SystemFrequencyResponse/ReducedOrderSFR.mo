within Dynawo.Electrical.Controls.Frequency.SystemFrequencyResponse;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ReducedOrderSFR "Reduced order system frequency response model, based on the proposition by Anderson in 1990"
  extends SFRParameters;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PePu(start = Pe0Pu) "Generator electrical load power in pu (base SNom)" annotation(
    Placement(transformation(origin = {76, 114}, extent = {{-14, -14}, {14, 14}}, rotation = -90), iconTransformation(origin = {-160, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput PspPu(start = Psp0Pu) "Incremental power set point in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-156, 30}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-160, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput Frequency(start = SystemBase.fNom) "Frequency variation in Hz" annotation(
    Placement(visible = true, transformation(origin = {150, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput OmegaPu(start = SystemBase.omega0Pu) "Incremental speed in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {150, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {-53, 19}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Math.Gain gain2(k = DPu) annotation(
    Placement(transformation(origin = {46, -22}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(transformation(origin = {-123, 25}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Math.Add3 add3(k1 = -1, k2 = +1, k3 = -1) annotation(
    Placement(transformation(origin = {46, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1/(2*H), y_start = SystemBase.omega0Pu) annotation(
    Placement(transformation(origin = {78, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain1(k = Km) annotation(
    Placement(transformation(origin = {-21, 19}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Math.Gain gain(k = 1/R) annotation(
    Placement(transformation(origin = {-54, -76}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Gain gain4(k = Fh) annotation(
    Placement(transformation(origin = {-87, 41}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tr, k = 1 - Fh, y_start = (1 - Fh)*Psp0Pu) annotation(
    Placement(transformation(origin = {-87, -1}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Math.Gain gain3(k = Dynawo.Electrical.SystemBase.fNom) annotation(
    Placement(visible = true, transformation(origin = {123, 19}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  // Initial parameters
  parameter Types.ActivePowerPu Pe0Pu "Initial electrical power in pu (base SNom)";
  final parameter Types.ActivePowerPu Psp0Pu = Pe0Pu/Km "Initial incremental speed in pu (base SNom)";

  Modelica.Blocks.Math.Add add2(k2 = -1) annotation(
    Placement(transformation(origin = {80, -22}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {58, 70}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(transformation(origin = {12, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = SystemBase.omega0Pu)  annotation(
    Placement(transformation(origin = {76, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add4(k2 = -1) annotation(
    Placement(transformation(origin = {80, -76}, extent = {{10, 10}, {-10, -10}}, rotation = -0)));

equation
  connect(firstOrder.y, add.u2) annotation(
    Line(points = {{-77.1, -1}, {-70.3, -1}, {-70.3, 14}, {-64.1, 14}}, color = {0, 0, 127}));
  connect(add.y, gain1.u) annotation(
    Line(points = {{-43.1, 19}, {-32.1, 19}}, color = {0, 0, 127}));
  connect(add3.y, integrator.u) annotation(
    Line(points = {{57, 20}, {66, 20}}, color = {0, 0, 127}));
  connect(PspPu, add1.u1) annotation(
    Line(points = {{-156, 30}, {-134, 30}}, color = {0, 0, 127}));
  connect(add1.y, gain4.u) annotation(
    Line(points = {{-113.1, 25}, {-105.2, 25}, {-105.2, 41}, {-98.1, 41}}, color = {0, 0, 127}));
  connect(firstOrder.u, add1.y) annotation(
    Line(points = {{-97.8, -1}, {-105.6, -1}, {-105.6, 25}, {-112.8, 25}}, color = {0, 0, 127}));
  connect(gain2.y, add3.u3) annotation(
    Line(points = {{35, -22}, {29.1, -22}, {29.1, 12}, {34, 12}}, color = {0, 0, 127}));
  connect(add1.u2, gain.y) annotation(
    Line(points = {{-133.8, 19.6}, {-139.6, 19.6}, {-139.6, -76}, {-65, -76}}, color = {0, 0, 127}));
  connect(gain3.y, Frequency) annotation(
    Line(points = {{133, 19}, {139, 19}, {139, 20}, {150, 20}}, color = {0, 0, 127}));
  connect(gain4.y, add.u1) annotation(
    Line(points = {{-77.1, 41}, {-72.1, 41}, {-72.1, 24}, {-64.1, 24}}, color = {0, 0, 127}));
  connect(add2.y, gain2.u) annotation(
    Line(points = {{69, -22}, {58, -22}}, color = {0, 0, 127}));
  connect(PePu, division.u1) annotation(
    Line(points = {{76, 114}, {76, 76}, {70, 76}}, color = {0, 0, 127}));
  connect(division.y, add3.u1) annotation(
    Line(points = {{48, 70}, {28, 70}, {28, 28}, {34, 28}}, color = {0, 0, 127}));
  connect(gain1.y, division1.u1) annotation(
    Line(points = {{-12, 20}, {-6, 20}, {-6, 26}, {0, 26}}, color = {0, 0, 127}));
  connect(add4.y, gain.u) annotation(
    Line(points = {{69, -76}, {-42, -76}}, color = {0, 0, 127}));
  connect(integrator.y, gain3.u) annotation(
    Line(points = {{89, 20}, {112, 20}}, color = {0, 0, 127}));
  connect(division1.y, add3.u2) annotation(
    Line(points = {{23, 20}, {34, 20}}, color = {0, 0, 127}));
  connect(integrator.y, division.u2) annotation(
    Line(points = {{90, 20}, {100, 20}, {100, 64}, {70, 64}}, color = {0, 0, 127}));
  connect(integrator.y, OmegaPu) annotation(
    Line(points = {{90, 20}, {100, 20}, {100, -6}, {150, -6}}, color = {0, 0, 127}));
  connect(integrator.y, add2.u1) annotation(
    Line(points = {{90, 20}, {100, 20}, {100, -16}, {92, -16}}, color = {0, 0, 127}));
  connect(integrator.y, division1.u2) annotation(
    Line(points = {{90, 20}, {100, 20}, {100, -6}, {-6, -6}, {-6, 14}, {0, 14}}, color = {0, 0, 127}));
  connect(integrator.y, add4.u1) annotation(
    Line(points = {{90, 20}, {100, 20}, {100, -82}, {92, -82}}, color = {0, 0, 127}));
  connect(const.y, add2.u2) annotation(
    Line(points = {{88, -50}, {96, -50}, {96, -28}, {92, -28}}, color = {0, 0, 127}));
  connect(const.y, add4.u2) annotation(
    Line(points = {{88, -50}, {96, -50}, {96, -70}, {92, -70}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model is a reduced order model that allows representing the average frequency behaviour of a reheat steam turbine.<div><br><div>It is an implementation of the model described in the following paper:</div><div><br></div><div>P. M. Anderson and M. Mirheydar, \"A low-order system frequency response model,\" in IEEE Transactions on Power Systems, vol. 5, no. 3, pp. 720-729, Aug. 1990, doi: 10.1109/59.65898.<div>keywords: {Frequency response;Power system modeling;Power system dynamics;Frequency estimation;Power generation;Impedance;Frequency synchronization;Nonlinear dynamical systems;Nonlinear equations;Turbines}</div><div><br></div><div><br></div></div></div></body></html>"),
    Icon(graphics = {Text(origin = {-35, 34}, extent = {{-59, 22}, {129, -88}}, textString = "ReducedOrderSFR"), Rectangle(origin = {-1, 0}, extent = {{-140, 100}, {140, -100}})}, coordinateSystem(extent = {{-140, -100}, {140, 100}})),
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
end ReducedOrderSFR;
