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

model SimplifiedSFR "Simplified system frequency response model, based on the proposition by Anderson in 1990"
  extends SFRParameters;

  // Input variable
  Modelica.Blocks.Interfaces.RealInput PePu(start = Pe0Pu) "Generator electrical load power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-112, 6}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-111, 1}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput deltaFrequency(start = 0) "Frequency variation in Hz" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput deltaOmegaPu(start = 0) "Incremental speed in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction inertia(a = {2 * H, DPu}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {-22, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction feedbackLoop(a = {R * Tr, R}, b = {Km * Fh * Tr, Km}) annotation(
    Placement(visible = true, transformation(origin = {-22, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Gain gain(k = Dynawo.Electrical.SystemBase.fNom) annotation(
    Placement(visible = true, transformation(origin = {56, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameter
  parameter Types.ActivePowerPu Pe0Pu "Initial electrical power in pu (base SNom)";

 equation
  connect(gain.y, deltaFrequency) annotation(
    Line(points = {{68, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(inertia.y, gain.u) annotation(
    Line(points = {{-10, 0}, {44, 0}}, color = {0, 0, 127}));
  connect(feedbackLoop.u, inertia.y) annotation(
    Line(points = {{-10, -48}, {20, -48}, {20, 0}, {-10, 0}}, color = {0, 0, 127}));
  connect(PePu, add.u1) annotation(
    Line(points = {{-112, 6}, {-80, 6}}, color = {0, 0, 127}));
  connect(feedbackLoop.y, add.u2) annotation(
    Line(points = {{-32, -48}, {-90, -48}, {-90, -6}, {-80, -6}}, color = {0, 0, 127}));
  connect(add.y, inertia.u) annotation(
    Line(points = {{-56, 0}, {-34, 0}}, color = {0, 0, 127}));
  connect(deltaOmegaPu, inertia.y) annotation(
    Line(points = {{110, -40}, {20, -40}, {20, 0}, {-10, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model is a simplified model that allows representing the average frequency behaviour of a reheat steam turbine.<div><br><div>It is an implementation of the model described in the following paper:</div><div><br></div><div>P. M. Anderson and M. Mirheydar, \"A low-order system frequency response model,\" in IEEE Transactions on Power Systems, vol. 5, no. 3, pp. 720-729, Aug. 1990, doi: 10.1109/59.65898.<div>keywords: {Frequency response;Power system modeling;Power system dynamics;Frequency estimation;Power generation;Impedance;Frequency synchronization;Nonlinear dynamical systems;Nonlinear equations;Turbines}</div></div></div><div><br></div><div>and is a simplification of the reduced order model described in the same paper which is valid when we are only interested in a variation of Pe for Psp = 0.</div></body></html>"),
    Icon(graphics = {Text(origin = {-33, 34}, extent = {{-59, 22}, {129, -88}}, textString = "SimplifiedSFR"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end SimplifiedSFR;
