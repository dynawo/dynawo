within Dynawo.Examples.Nordic.TestCases;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model LoadFlowB "Model of load flow calculation for the Nordic 32 test system used for voltage stability studies (operating point B)"
  import Modelica.ComplexMath;
  import Modelica.SIunits;
  import Dynawo;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;

  extends Dynawo.Examples.Nordic.TestCases.LoadFlowA(
    g16(u0Pu = u0Pu_g16b, i0Pu = i0Pu_g16b, QGen0Pu = Q0Pu_g16b));

  Dynawo.Electrical.Buses.Bus bus_BG16b annotation(
    Placement(visible = true, transformation(origin = {5, -145}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Dynawo.Electrical.Transformers.TransformerFixedRatio trafo_g16b_4051(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 700.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {5, -137}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));

  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed g16b(u0Pu = u0Pu_g16b, i0Pu = i0Pu_g16b, PGen0Pu = P0Pu_g16, QGen0Pu = Q0Pu_g16b, U0Pu = U0Pu_g16) annotation(
    Placement(visible = true, transformation(origin = {5, -150}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));

protected
  // Generator g16b init values:
  // P0Pu, Q0Pu in SnRef, generator convention
  // i0Pu in receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g16b = 59.9 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g16b = SIunits.Conversions.from_deg(-18.51);
  final parameter Types.ComplexApparentPowerPu s0Pu_g16b = Complex(P0Pu_g16, Q0Pu_g16b);
  final parameter Types.ComplexVoltagePu u0Pu_g16b = ComplexMath.fromPolar(U0Pu_g16, UPhase0_g16b);
  final parameter Types.ComplexCurrentPu i0Pu_g16b = -ComplexMath.conj(s0Pu_g16b / u0Pu_g16b);

equation
  trafo_g16b_4051.switchOffSignal1.value = false;
  trafo_g16b_4051.switchOffSignal2.value = false;
  g16b.switchOffSignal1.value = false;
  g16b.switchOffSignal2.value = false;
  g16b.switchOffSignal3.value = false;

  connect(trafo_g16b_4051.terminal1, bus_BG16b.terminal) annotation(
    Line(points = {{5, -142}, {5, -145}}, color = {0, 0, 255}));
  connect(trafo_g16b_4051.terminal2, bus_4051.terminal) annotation(
    Line(points = {{5, -132}, {5, -130}, {14, -130}}, color = {0, 0, 255}));
  connect(g16b.terminal, bus_BG16b.terminal) annotation(
    Line(points = {{5, -151}, {5, -145}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002), __OpenModelica_commandLineOptions = "--daemode", __OpenModelica_simulationFlags(lv = "LOG_STATS", noEquidistantTimeGrid = "()", s = "ida"),
    Diagram(graphics = {Line(origin = {1.18, 21.94}, points = {{-103.176, -26.9412}, {19.8235, -26.9412}, {103.824, 42.0588}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {-58.3, -98.4}, points = {{-44.7012, 54.3963}, {-25.7012, 54.3963}, {-13.7012, 42.3963}, {-13.7012, -9.60369}, {31.2988, -54.6037}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {-80.5, 104}, points = {{-22.5, -48}, {22.5, -48}, {22.5, 48}}, pattern = LinePattern.Dash, thickness = 0.5), Text(origin = {-55, -145}, extent = {{-15, 5}, {15, -5}}, textString = "SOUTH", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {-35, -25}, extent = {{-15, 5}, {15, -5}}, textString = "CENTRAL", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {5, 145}, extent = {{-15, 5}, {15, -5}}, textString = "NORTH", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {-100, 150}, extent = {{-15, 5}, {15, -5}}, textString = "EQUIV.", textStyle = {TextStyle.Bold, TextStyle.Italic})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body>The LoadFlow model for operating point B extends the LoadFlow model for operating point A.<div><br></div><div>The initial power values have been taken from the&nbsp;<span style=\"font-size: 12px; font-family: 'MS Shell Dlg 2';\">IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.&nbsp;</span><span style=\"font-size: 12px; font-family: 'MS Shell Dlg 2';\">The initial voltage values are taken from the report, operating point B.</span></div><div><br></div><div>The initial power and voltage values should produce steady state.</div></body></html>"),
  Icon);
end LoadFlowB;
