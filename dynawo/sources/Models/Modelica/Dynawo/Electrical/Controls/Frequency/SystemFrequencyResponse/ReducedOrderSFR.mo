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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ReducedOrderSFR "Reduced order system frequency response model, based on the proposition by Anderson in 1990"
  extends SFRParameters;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PePu(start = Pe0Pu) "Generator electrical load power in pu (base SNom)" annotation(
    Placement(transformation(origin = {4, 114}, extent = {{-14, -14}, {14, 14}}, rotation = -90), iconTransformation(origin = {-180, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput PspPu(start = Psp0Pu) "Incremental power set point in pu (base SNom)" annotation(
    Placement(transformation(origin = {-176, 30}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-180, 40}, extent = {{-20, -20}, {20, 20}})));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput frequency(start = Dynawo.Electrical.SystemBase.fNom) "Frequency in Hz" annotation(
    Placement(transformation(origin = {170, 26}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {170, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Speed in pu (base OmegaNom)" annotation(
    Placement(transformation(origin = {170, -10}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {170, -40}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {-43, 19}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Math.Gain gain2(k = DPu) annotation(
    Placement(transformation(origin = {31, -29}, extent = {{9, -9}, {-9, 9}})));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(transformation(origin = {-113, 25}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Math.Add3 add3(
    k1 = -1,
    k2 = +1,
    k3 = -1) annotation(
    Placement(transformation(origin = {25, 19}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1/(2*H)) annotation(
    Placement(transformation(origin = {57, 19}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Math.Gain gain1(k = Km) annotation(
    Placement(transformation(origin = {-11, 19}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Math.Gain gain(k = 1/R) annotation(
    Placement(transformation(origin = {-45, -61}, extent = {{9, -9}, {-9, 9}})));
  Modelica.Blocks.Math.Gain gain4(k = Fh) annotation(
    Placement(transformation(origin = {-77, 41}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    T = Tr,
    k = 1 - Fh,
    y_start = (1 - Fh)*Psp0Pu) annotation(
    Placement(transformation(origin = {-77, -1}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Math.Gain gain3(k = Dynawo.Electrical.SystemBase.fNom) annotation(
    Placement(transformation(origin = {101, 19}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Sources.Constant fNom(k = Dynawo.Electrical.SystemBase.fNom) annotation(
    Placement(transformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {140, 26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add4 annotation(
    Placement(transformation(origin = {140, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant wNom(k = SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.ActivePowerPu Pe0Pu "Initial electrical power in pu (base SNom)";
  final parameter Types.ActivePowerPu Psp0Pu = Pe0Pu/Km "Initial incremental speed in pu (base SNom)";

equation
  connect(firstOrder.y, add.u2) annotation(
    Line(points = {{-67.1, -1}, {-60.3, -1}, {-60.3, 14}, {-54.1, 14}}, color = {0, 0, 127}));
  connect(add.y, gain1.u) annotation(
    Line(points = {{-33.1, 19}, {-22.1, 19}}, color = {0, 0, 127}));
  connect(add3.y, integrator.u) annotation(
    Line(points = {{34.9, 19}, {45.9, 19}}, color = {0, 0, 127}));
  connect(PspPu, add1.u1) annotation(
    Line(points = {{-176, 30}, {-124, 30}}, color = {0, 0, 127}));
  connect(add1.y, gain4.u) annotation(
    Line(points = {{-103.1, 25}, {-95.2, 25}, {-95.2, 41}, {-88.1, 41}}, color = {0, 0, 127}));
  connect(firstOrder.u, add1.y) annotation(
    Line(points = {{-87.8, -1}, {-95.6, -1}, {-95.6, 25}, {-102.8, 25}}, color = {0, 0, 127}));
  connect(gain1.y, add3.u2) annotation(
    Line(points = {{-1.1, 19}, {13.9, 19}}, color = {0, 0, 127}));
  connect(gain2.y, add3.u3) annotation(
    Line(points = {{21.1, -29}, {9.2, -29}, {9.2, 12}, {14.1, 12}}, color = {0, 0, 127}));
  connect(add1.u2, gain.y) annotation(
    Line(points = {{-123.8, 19.6}, {-129.6, 19.6}, {-129.6, -61.4}, {-54.8, -61.4}}, color = {0, 0, 127}));
  connect(PePu, add3.u1) annotation(
    Line(points = {{4, 114}, {4, 26}, {14, 26}}, color = {0, 0, 127}));
  connect(integrator.y, gain2.u) annotation(
    Line(points = {{66.9, 19}, {71.9, 19}, {71.9, -29}, {41.9, -29}}, color = {0, 0, 127}));
  connect(gain.u, integrator.y) annotation(
    Line(points = {{-34.2, -61}, {71.8, -61}, {71.8, 19}, {66.8, 19}}, color = {0, 0, 127}));
  connect(gain3.u, integrator.y) annotation(
    Line(points = {{90.2, 19}, {67.2, 19}}, color = {0, 0, 127}));
  connect(gain4.y, add.u1) annotation(
    Line(points = {{-67.1, 41}, {-62.1, 41}, {-62.1, 24}, {-54.1, 24}}, color = {0, 0, 127}));
  connect(gain3.y, add2.u2) annotation(
    Line(points = {{110.9, 19}, {119.9, 19}, {119.9, 20}, {128, 20}}, color = {0, 0, 127}));
  connect(fNom.y, add2.u1) annotation(
    Line(points = {{111, 80}, {128, 80}, {128, 32}}, color = {0, 0, 127}));
  connect(add2.y, frequency) annotation(
    Line(points = {{151, 26}, {170, 26}}, color = {0, 0, 127}));
  connect(integrator.y, add4.u1) annotation(
    Line(points = {{66.9, 19}, {71.9, 19}, {71.9, -4}, {127.9, -4}}, color = {0, 0, 127}));
  connect(wNom.y, add4.u2) annotation(
    Line(points = {{111, -40}, {120, -40}, {120, -16}, {128, -16}}, color = {0, 0, 127}));
  connect(add4.y, omegaPu) annotation(
    Line(points = {{151, -10}, {170, -10}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model is a reduced order model that allows representing the average frequency behaviour of a reheat steam turbine.<div><br><div>It is an implementation of the model described in the following paper:</div><div><br></div><div>P. M. Anderson and M. Mirheydar, \"A low-order system frequency response model,\" in IEEE Transactions on Power Systems, vol. 5, no. 3, pp. 720-729, Aug. 1990, doi: 10.1109/59.65898.<div>keywords: {Frequency response;Power system modeling;Power system dynamics;Frequency estimation;Power generation;Impedance;Frequency synchronization;Nonlinear dynamical systems;Nonlinear equations;Turbines}</div><div><br></div><div><br></div></div></div></body></html>"),
    Icon(graphics = {Text(origin = {-35, 34}, extent = {{-59, 22}, {129, -88}}, textString = "ReducedOrderSFR"), Rectangle(extent = {{-161, 100}, {161, -100}})}, coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})));
end ReducedOrderSFR;
