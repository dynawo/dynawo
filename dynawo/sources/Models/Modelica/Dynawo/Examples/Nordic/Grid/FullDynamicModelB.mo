within Dynawo.Examples.Nordic.Grid;

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

model FullDynamicModelB "Nordic test grid with buses, lines, shunts, voltage-dependent loads, transformers and generators (operating point B)"
  import Modelica.SIunits;
  import Dynawo;
  import Dynawo.Examples.Nordic.Components.GeneratorWithControl;
  import Dynawo.Types;

  extends Dynawo.Examples.Nordic.Grid.FullDynamicModelA(
    g15(P0Pu = P0Pu_g15a, Q0Pu = Q0Pu_g15a),
    g16(P0Pu = P0Pu_g16a, Q0Pu = Q0Pu_g16a),
    g18(P0Pu = P0Pu_g18a, Q0Pu = Q0Pu_g18a),
    g20(P0Pu = P0Pu_g20b),
    trafo_g15_4047.XPu = 0.15 * 1.05 ^ 2 * (100 / 600.0),
    trafo_g18_4063.XPu = 0.15 * 1.05 ^ 2 * (100 / 600.0));

  Dynawo.Electrical.Buses.Bus bus_BG15b annotation(
    Placement(visible = true, transformation(origin = {95, -95}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_BG16b annotation(
    Placement(visible = true, transformation(origin = {5, -145}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_BG18b annotation(
    Placement(visible = true, transformation(origin = {-110, -145}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Dynawo.Electrical.Transformers.TransformerFixedRatio trafo_g15_4047b(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 600.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {95, -103}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio trafo_g16_4051b(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 700.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {5, -137}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio trafo_g18_4063b(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 600.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-110, -137}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));

  GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g15b(P0Pu = P0Pu_g15b, Q0Pu = Q0Pu_g15b, U0Pu = 1.0455, UPhase0 = SIunits.Conversions.from_deg(-52.19), gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g15) annotation(
    Placement(visible = true, transformation(origin = {95, -89}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g16b(P0Pu = P0Pu_g16b, Q0Pu = Q0Pu_g16b, U0Pu = 1.0531, UPhase0 = SIunits.Conversions.from_deg(-64.1), gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g16b) annotation(
    Placement(visible = true, transformation(origin = {5, -151}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g18b(P0Pu = P0Pu_g18b, Q0Pu = Q0Pu_g18b, U0Pu = 1.0307, UPhase0 = SIunits.Conversions.from_deg(-43.32), gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g18) annotation(
    Placement(visible = true, transformation(origin = {-110, -151}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));

protected
  // Generator g15a init values:
  // P0Pu, Q0Pu in SnRef, receptor convention
  final parameter Types.ActivePowerPu P0Pu_g15a = -540.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_g15a = -74.1 / Electrical.SystemBase.SnRef;
  // Generator g15b init values:
  // P0Pu, Q0Pu in SnRef, receptor convention
  final parameter Types.ActivePowerPu P0Pu_g15b = -540.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_g15b = -74.1 / Electrical.SystemBase.SnRef;
  // Generator g16a init values:
  // P0Pu, Q0Pu in SnRef, receptor convention
  final parameter Types.ActivePowerPu P0Pu_g16a = -600.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_g16a = -59.9 / Electrical.SystemBase.SnRef;
  // Generator g16b init values:
  // P0Pu, Q0Pu in SnRef, receptor convention
  final parameter Types.ActivePowerPu P0Pu_g16b = -600.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_g16b = -59.9 / Electrical.SystemBase.SnRef;
  // Generator g18a init values:
  // P0Pu, Q0Pu in SnRef, receptor convention
  final parameter Types.ActivePowerPu P0Pu_g18a = -530.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_g18a = -110.5 / Electrical.SystemBase.SnRef;
  // Generator g18b init values:
  // P0Pu, Q0Pu in SnRef, receptor convention
  final parameter Types.ActivePowerPu P0Pu_g18b = -530.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_g18b = -110.5 / Electrical.SystemBase.SnRef;
  // Generator g20 init values:
  // P0Pu, Q0Pu in SnRef, receptor convention
  final parameter Types.ActivePowerPu P0Pu_g20b = -1537.4 / Electrical.SystemBase.SnRef;

equation
  trafo_g15_4047b.switchOffSignal1.value = false;
  trafo_g15_4047b.switchOffSignal2.value = false;
  trafo_g16_4051b.switchOffSignal1.value = false;
  trafo_g16_4051b.switchOffSignal2.value = false;
  trafo_g18_4063b.switchOffSignal1.value = false;
  trafo_g18_4063b.switchOffSignal2.value = false;

  connect(trafo_g15_4047b.terminal1, bus_BG15b.terminal) annotation(
    Line(points = {{95, -98}, {95, -95}}, color = {0, 0, 255}));
  connect(trafo_g15_4047b.terminal2, bus_4047.terminal) annotation(
    Line(points = {{95, -108}, {95, -110}, {70, -110}}, color = {0, 0, 255}));
  connect(trafo_g16_4051b.terminal1, bus_BG16b.terminal) annotation(
    Line(points = {{5, -142}, {5, -145}}, color = {0, 0, 255}));
  connect(trafo_g16_4051b.terminal2, bus_4051.terminal) annotation(
    Line(points = {{5, -132}, {5, -130}, {14, -130}}, color = {0, 0, 255}));
  connect(trafo_g18_4063b.terminal1, bus_BG18b.terminal) annotation(
    Line(points = {{-110, -142}, {-110, -145}}, color = {0, 0, 255}));
  connect(trafo_g18_4063b.terminal2, bus_4063.terminal) annotation(
    Line(points = {{-110, -132}, {-110, -130}, {-87, -130}}, color = {0, 0, 255}));
  connect(g15b.terminal, bus_BG15b.terminal) annotation(
    Line(points = {{95, -89}, {95, -95}}, color = {0, 0, 255}));
  connect(g16b.terminal, bus_BG16b.terminal) annotation(
    Line(points = {{5, -151}, {5, -145}}, color = {0, 0, 255}));
  connect(g18b.terminal, bus_BG18b.terminal) annotation(
    Line(points = {{-110, -151}, {-110, -145}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.001), __OpenModelica_commandLineOptions = "--daemode", __OpenModelica_simulationFlags(lv = "LOG_STATS", noEquidistantTimeGrid = "()", s = "ida"),
    Diagram(graphics = {Line(origin = {1.18, 21.94}, points = {{-103.176, -26.9412}, {19.8235, -26.9412}, {103.824, 42.0588}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {-58.3, -98.4}, points = {{-44.7012, 54.3963}, {-25.7012, 54.3963}, {-13.7012, 42.3963}, {-13.7012, -9.60369}, {31.2988, -54.6037}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {-80.5, 104}, points = {{-22.5, -48}, {22.5, -48}, {22.5, 48}}, pattern = LinePattern.Dash, thickness = 0.5), Text(origin = {-55, -145}, extent = {{-15, 5}, {15, -5}}, textString = "SOUTH", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {-35, -25}, extent = {{-15, 5}, {15, -5}}, textString = "CENTRAL", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {5, 145}, extent = {{-15, 5}, {15, -5}}, textString = "NORTH", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {-100, 150}, extent = {{-15, 5}, {15, -5}}, textString = "EQUIV.", textStyle = {TextStyle.Bold, TextStyle.Italic})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body>This model extends the full dynamic model.<div>This model implements the Nordic 32 test system, operating point B, presented in the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.<br></div><div>In this modified version, a generator g16b is added while the generators g15 and g18 are split into two identical generators, g15a and g15b, g18a and g18b, respectively.</div></body></html>"));
end FullDynamicModelB;
