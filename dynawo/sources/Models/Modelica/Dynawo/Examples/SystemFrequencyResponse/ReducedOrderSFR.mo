within Dynawo.Examples.SystemFrequencyResponse;

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
model ReducedOrderSFR
  extends Icons.Example;

  parameter Real Pe0Pu = 0;

  Dynawo.Electrical.Controls.Frequency.SystemFrequencyResponse.ReducedOrderSFR reducedOrderSFR(R = 0.05, H = 4, Km = 0.95, Fh = 0.3, Tr = 8, DPu = 1, gain3.k = 60, Pe0Pu = Pe0Pu) annotation(
      Placement(visible = true, transformation(origin = {4, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Psp(k = Pe0Pu / reducedOrderSFR.Km) annotation(
      Placement(visible = true, transformation(origin = {-34, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Step Pe(height = 0.3, offset = Pe0Pu, startTime = 1) annotation(
      Placement(visible = true, transformation(origin = {-34, -14}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

equation

  connect(Psp.y, reducedOrderSFR.PspPu) annotation(
      Line(points = {{-28, 20}, {-18, 20}, {-18, 4}, {-8, 4}}, color = {0, 0, 127}));
  connect(reducedOrderSFR.PePu, Pe.y) annotation(
      Line(points = {{-8, -4}, {-20, -4}, {-20, -14}, {-28, -14}}, color = {0, 0, 127}));

annotation(preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-6, Interval = 0.004),
  Documentation(info = "<html><head></head><body>This test case enables to reproduce the examples and plots provided by Anderson in its paper.<div><br></div><div>By modifying the different parameters, the results of the paper can be easily reproduced which validates the implementation of the model.</div><div><br></div><div>The results for different variations of active power, governor droop, inertia constants, reheat time constants, high pressure fraction and damping constant are presented below:</div>
<figure>
    <img width=\"300\" src=\"modelica://Dynawo/Examples/SystemFrequencyResponse/Resources/Images/Figure6.png\">
</figure>

<figure>
    <img width=\"300\" src=\"modelica://Dynawo/Examples/SystemFrequencyResponse/Resources/Images/Figure7.png\">
</figure>

<figure>
    <img width=\"300\" src=\"modelica://Dynawo/Examples/SystemFrequencyResponse/Resources/Images/Figure9.png\">
</figure>

<figure>
    <img width=\"300\" src=\"modelica://Dynawo/Examples/SystemFrequencyResponse/Resources/Images/Figure10.png\">
</figure>

<figure>
    <img width=\"300\" src=\"modelica://Dynawo/Examples/SystemFrequencyResponse/Resources/Images/Figure11.png\">
</figure>

<figure>
    <img width=\"300\" src=\"modelica://Dynawo/Examples/SystemFrequencyResponse/Resources/Images/Figure12.png\">
</figure>

<div><br></div><div>The reference of the model is the following:</div><div><br></div><div><div>P. M. Anderson and M. Mirheydar, \"A low-order system frequency response model,\" in IEEE Transactions on Power Systems, vol. 5, no. 3, pp. 720-729, Aug. 1990, doi: 10.1109/59.65898.</div><div>keywords: {Frequency response;Power system modeling;Power system dynamics;Frequency estimation;Power generation;Impedance;Frequency synchronization;Nonlinear dynamical systems;Nonlinear equations;Turbines},</div><div><br></div></div><div><br></div><div><br></div><div><br></div><div><br><div><br></div></div></body></html>"));
end ReducedOrderSFR;
