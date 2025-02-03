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
    Placement(visible = true, transformation(origin = {24, 114}, extent = {{-14, -14}, {14, 14}}, rotation = -90), iconTransformation(origin = {-160, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PspPu(start = Psp0Pu) "Incremental power set point in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-156, 30}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-160, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput deltaFrequency(start = 0) "Frequency variation in Hz" annotation(
    Placement(visible = true, transformation(origin = {150, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput deltaOmegaPu(start = 0) "Incremental speed in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {150, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-23, 19}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = DPu) annotation(
    Placement(visible = true, transformation(origin = {51, -29}, extent = {{9, -9}, {-9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-93, 25}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = -1, k2 = +1, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {45, 19}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / (2 * H)) annotation(
    Placement(visible = true, transformation(origin = {77, 19}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Km) annotation(
    Placement(visible = true, transformation(origin = {9, 19}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / R) annotation(
    Placement(visible = true, transformation(origin = {-25, -61}, extent = {{9, -9}, {-9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain4(k = Fh) annotation(
    Placement(visible = true, transformation(origin = {-57, 41}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tr, k = 1 - Fh, y_start = (1 - Fh) * Psp0Pu) annotation(
    Placement(visible = true, transformation(origin = {-57, -1}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = Dynawo.Electrical.SystemBase.fNom) annotation(
    Placement(visible = true, transformation(origin = {123, 19}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  // Initial parameters
  parameter Types.ActivePowerPu Pe0Pu "Initial electrical power in pu (base SNom)";
  final parameter Types.ActivePowerPu Psp0Pu = Pe0Pu / Km "Initial incremental speed in pu (base SNom)";

equation
  connect(firstOrder.y, add.u2) annotation(
    Line(points = {{-47.1, -1}, {-40.2, -1}, {-40.2, 14}, {-34.1, 14}}, color = {0, 0, 127}));
  connect(add.y, gain1.u) annotation(
    Line(points = {{-13.1, 19}, {-2, 19}}, color = {0, 0, 127}));
  connect(add3.y, integrator.u) annotation(
    Line(points = {{55, 19}, {65.9, 19}}, color = {0, 0, 127}));
  connect(PspPu, add1.u1) annotation(
    Line(points = {{-156, 30}, {-104, 30}}, color = {0, 0, 127}));
  connect(add1.y, gain4.u) annotation(
    Line(points = {{-83.1, 25}, {-75.1, 25}, {-75.1, 41}, {-67.1, 41}}, color = {0, 0, 127}));
  connect(firstOrder.u, add1.y) annotation(
    Line(points = {{-67.8, -1}, {-75.8, -1}, {-75.8, 25}, {-83.8, 25}}, color = {0, 0, 127}));
  connect(gain1.y, add3.u2) annotation(
    Line(points = {{19, 19}, {34, 19}}, color = {0, 0, 127}));
  connect(gain2.y, add3.u3) annotation(
    Line(points = {{41.1, -29}, {29.1, -29}, {29.1, 12}, {34, 12}}, color = {0, 0, 127}));
  connect(add1.u2, gain.y) annotation(
    Line(points = {{-103.8, 19.6}, {-109.8, 19.6}, {-109.8, -60.4}, {-33.8, -60.4}}, color = {0, 0, 127}));
  connect(PePu, add3.u1) annotation(
    Line(points = {{24, 114}, {24, 26}, {34, 26}}, color = {0, 0, 127}));
  connect(integrator.y, gain2.u) annotation(
    Line(points = {{86, 20}, {92, 20}, {92, -28}, {62, -28}}, color = {0, 0, 127}));
  connect(gain.u, integrator.y) annotation(
    Line(points = {{-14, -60}, {92, -60}, {92, 20}, {86, 20}}, color = {0, 0, 127}));
  connect(gain3.y, deltaFrequency) annotation(
    Line(points = {{133, 19}, {139, 19}, {139, 20}, {150, 20}}, color = {0, 0, 127}));
  connect(gain3.u, integrator.y) annotation(
    Line(points = {{112, 19}, {92, 19}, {92, 20}, {86, 20}}, color = {0, 0, 127}));
  connect(gain4.y, add.u1) annotation(
    Line(points = {{-48, 42}, {-42, 42}, {-42, 24}, {-34, 24}}, color = {0, 0, 127}));
  connect(deltaOmegaPu, integrator.y) annotation(
    Line(points = {{150, -6}, {92, -6}, {92, 20}, {86, 20}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model is a reduced order model that allows representing the average frequency behaviour of a reheat steam turbine.<div><br><div>It is an implementation of the model described in the following paper:</div><div><br></div><div>P. M. Anderson and M. Mirheydar, \"A low-order system frequency response model,\" in IEEE Transactions on Power Systems, vol. 5, no. 3, pp. 720-729, Aug. 1990, doi: 10.1109/59.65898.<div>keywords: {Frequency response;Power system modeling;Power system dynamics;Frequency estimation;Power generation;Impedance;Frequency synchronization;Nonlinear dynamical systems;Nonlinear equations;Turbines}</div><div><br></div><div><br></div></div></div></body></html>"),
    Icon(graphics = {Text(origin = {-35, 34}, extent = {{-59, 22}, {129, -88}}, textString = "ReducedOrderSFR"), Rectangle(origin = {-1, 0}, extent = {{-140, 100}, {140, -100}})}, coordinateSystem(extent = {{-140, -100}, {140, 100}})),
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
end ReducedOrderSFR;
