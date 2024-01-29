within Dynawo.Examples.KundurTwoArea.Grid.BaseClasses;

model Network "Kundur two-area system with buses, lines and transformers"
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
  Dynawo.Electrical.Buses.Bus bus01 annotation(
    Placement(visible = true, transformation(origin = {-240, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus07 annotation(
    Placement(visible = true, transformation(origin = {-60, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus06 annotation(
    Placement(visible = true, transformation(origin = {-120, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus08 annotation(
    Placement(visible = true, transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus11 annotation(
    Placement(visible = true, transformation(origin = {180, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus05 annotation(
    Placement(visible = true, transformation(origin = {-178, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus03 annotation(
    Placement(visible = true, transformation(origin = {240, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus10 annotation(
    Placement(visible = true, transformation(origin = {122, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus02 annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus04 annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus09 annotation(
    Placement(visible = true, transformation(origin = {60, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line0506(BPu = bLinePu*lengthLine0506Km, GPu = 0, RPu = rLinePu*lengthLine0506Km, XPu = xLinePu*lengthLine0506Km)  annotation(
    Placement(visible = true, transformation(origin = {-148, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line0607(BPu = bLinePu*lengthLine0607Km, GPu = 0, RPu = rLinePu*lengthLine0607Km, XPu = xLinePu*lengthLine0607Km) annotation(
    Placement(visible = true, transformation(origin = {-90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line0708b(BPu = bLinePu*lengthLine0708Km, GPu = 0, RPu = rLinePu*lengthLine0708Km, XPu = xLinePu*lengthLine0708Km) annotation(
    Placement(visible = true, transformation(origin = {-28, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line0910(BPu = bLinePu*lengthLine0910Km, GPu = 0, RPu = rLinePu*lengthLine0910Km, XPu = xLinePu*lengthLine0910Km) annotation(
    Placement(visible = true, transformation(origin = {94, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line0809a(BPu = bLinePu*lengthLine0809Km, GPu = 0, RPu = rLinePu*lengthLine0809Km, XPu = xLinePu*lengthLine0809Km) annotation(
    Placement(visible = true, transformation(origin = {32, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line0708a(BPu = bLinePu*lengthLine0708Km, GPu = 0, RPu = rLinePu*lengthLine0708Km, XPu = xLinePu*lengthLine0708Km) annotation(
    Placement(visible = true, transformation(origin = {-28, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line0809b(BPu = bLinePu*lengthLine0809Km, GPu = 0, RPu = rLinePu*lengthLine0809Km, XPu = xLinePu*lengthLine0809Km) annotation(
    Placement(visible = true, transformation(origin = {32, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1011(BPu = bLinePu*lengthLine1011Km, GPu = 0, RPu = rLinePu*lengthLine1011Km, XPu = xLinePu*lengthLine1011Km) annotation(
    Placement(visible = true, transformation(origin = {154, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.GeneratorTransformer tr0105(BPu = 0, GPu = 0, RPu = 0, XPu = xTrSystemBasePu, rTfoPu = U2TrKv/U1TrKv)  annotation(
    Placement(visible = true, transformation(origin = {-206, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.GeneratorTransformer tr0206(BPu = 0, GPu = 0, RPu = 0, XPu = xTrSystemBasePu, rTfoPu = U2TrKv/U1TrKv) annotation(
    Placement(visible = true, transformation(origin = {-130, 18}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.GeneratorTransformer tr0410(BPu = 0, GPu = 0, RPu = 0, XPu = xTrSystemBasePu, rTfoPu = U2TrKv/U1TrKv) annotation(
    Placement(visible = true, transformation(origin = {130, 18}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.GeneratorTransformer tr0311(BPu = 0, GPu = 0, RPu = 0, XPu = xTrSystemBasePu, rTfoPu = U2TrKv/U1TrKv) annotation(
    Placement(visible = true, transformation(origin = {212, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Transformer parameters
  final parameter Types.PerUnit xTrPu = 0.15 "Step-uptransformer reactance in pu (SnTr base)";
  final parameter Types.VoltageModule U1TrKv = 20 "Primary (low voltage) transformer voltage in kV";
  final parameter Types.VoltageModule U2TrKv = 230 "Secondary (high voltage) transformer voltage in kV";
  final parameter Types.ApparentPowerModule SnTr = 900 "Transformer rated power in MVA";
  final parameter Types.PerUnit xTrSystemBasePu = xTrPu/SnTr*Dynawo.Electrical.SystemBase.SnRef "Step-uptransformer reactance in pu (system base SnRef)";
  // Line parameters
  final parameter Real lengthLine0506Km = 25;
  final parameter Real lengthLine0607Km = 10;
  final parameter Real lengthLine0708Km = 110;
  final parameter Real lengthLine0809Km = 110;
  final parameter Real lengthLine0910Km = 10;
  final parameter Real lengthLine1011Km = 25;
  final parameter Types.PerUnit rLinePu = 0.0001 "Resistance in pu/km";
  final parameter Types.PerUnit xLinePu = 0.001 "Reactance in pu/km";
  final parameter Types.PerUnit bLinePu = 0.00175 "Susceptance in pu/km";
  final parameter Types.ApparentPowerModule SRLine = 100 "Line rated power in MVA";
  
equation
//line_4032_4044.switchOffSignal1.value = false; // to be disconnected to clear short circuit
  connect(bus05.terminal, line0506.terminal1) annotation(
    Line(points = {{-178, 70}, {-158, 70}}, color = {0, 0, 255}));
  connect(line0506.terminal2, bus06.terminal) annotation(
    Line(points = {{-138, 70}, {-120, 70}}, color = {0, 0, 255}));
  connect(bus06.terminal, line0607.terminal1) annotation(
    Line(points = {{-120, 70}, {-100, 70}}, color = {0, 0, 255}));
  connect(line0607.terminal2, bus07.terminal) annotation(
    Line(points = {{-80, 70}, {-60, 70}}, color = {0, 0, 255}));
  connect(line0708a.terminal1, bus07.terminal) annotation(
    Line(points = {{-38, 76}, {-60, 76}, {-60, 70}}, color = {0, 0, 255}));
  connect(line0708b.terminal1, bus07.terminal) annotation(
    Line(points = {{-38, 64}, {-60, 64}, {-60, 70}}, color = {0, 0, 255}));
  connect(line0708a.terminal2, bus08.terminal) annotation(
    Line(points = {{-18, 76}, {0, 76}, {0, 70}}, color = {0, 0, 255}));
  connect(line0708b.terminal2, bus08.terminal) annotation(
    Line(points = {{-18, 64}, {0, 64}, {0, 70}}, color = {0, 0, 255}));
  connect(line0809a.terminal2, bus09.terminal) annotation(
    Line(points = {{42, 76}, {60, 76}, {60, 70}}, color = {0, 0, 255}));
  connect(line0809b.terminal2, bus09.terminal) annotation(
    Line(points = {{42, 64}, {60, 64}, {60, 70}}, color = {0, 0, 255}));
  connect(line0809a.terminal1, bus08.terminal) annotation(
    Line(points = {{22, 76}, {0, 76}, {0, 70}}, color = {0, 0, 255}));
  connect(line0809b.terminal1, bus08.terminal) annotation(
    Line(points = {{22, 64}, {0, 64}, {0, 70}}, color = {0, 0, 255}));
  connect(bus09.terminal, line0910.terminal1) annotation(
    Line(points = {{60, 70}, {84, 70}}, color = {0, 0, 255}));
  connect(line0910.terminal2, bus10.terminal) annotation(
    Line(points = {{104, 70}, {122, 70}}, color = {0, 0, 255}));
  connect(line1011.terminal2, bus11.terminal) annotation(
    Line(points = {{164, 70}, {180, 70}}, color = {0, 0, 255}));
  connect(bus10.terminal, line1011.terminal1) annotation(
    Line(points = {{122, 70}, {144, 70}}, color = {0, 0, 255}));
  connect(bus01.terminal, tr0105.terminal1) annotation(
    Line(points = {{-240, 70}, {-216, 70}}, color = {0, 0, 255}));
  connect(tr0105.terminal2, bus05.terminal) annotation(
    Line(points = {{-196, 70}, {-178, 70}}, color = {0, 0, 255}));
  connect(bus11.terminal, tr0311.terminal2) annotation(
    Line(points = {{180, 70}, {202, 70}}, color = {0, 0, 255}));
  connect(tr0311.terminal1, bus03.terminal) annotation(
    Line(points = {{222, 70}, {240, 70}}, color = {0, 0, 255}));
  connect(tr0410.terminal1, bus04.terminal) annotation(
    Line(points = {{130, 8}, {130, -20}}, color = {0, 0, 255}));
  connect(tr0206.terminal1, bus02.terminal) annotation(
    Line(points = {{-130, 8}, {-130, -20}}, color = {0, 0, 255}));
  connect(tr0206.terminal2, bus06.terminal) annotation(
    Line(points = {{-130, 28}, {-130, 62}, {-120, 62}, {-120, 70}}, color = {0, 0, 255}));
  connect(tr0410.terminal2, bus10.terminal) annotation(
    Line(points = {{130, 28}, {130, 62}, {122, 62}, {122, 70}}, color = {0, 0, 255}));
  // Switchoff signals
  // Lines
  line0506.switchOffSignal1.value = false;
  line0506.switchOffSignal2.value = false;
  line0607.switchOffSignal1.value = false;
  line0607.switchOffSignal2.value = false;
  line0708a.switchOffSignal1.value = false;
  line0708a.switchOffSignal2.value = false;
  line0708b.switchOffSignal1.value = false;
  line0708b.switchOffSignal2.value = false;
  line0809a.switchOffSignal1.value = false;
  line0809a.switchOffSignal2.value = false;
  line0809b.switchOffSignal1.value = false;
  line0809b.switchOffSignal2.value = false;
  line0910.switchOffSignal1.value = false;
  line0910.switchOffSignal2.value = false;
  line1011.switchOffSignal1.value = false;
  line1011.switchOffSignal2.value = false;
  // Transformers
  tr0105.switchOffSignal1.value = false;
  tr0206.switchOffSignal2.value = false;
  tr0311.switchOffSignal1.value = false;
  tr0410.switchOffSignal2.value = false;
  annotation(
    Diagram(coordinateSystem(extent = {{-300, -100}, {300, 100}})),
    Icon(coordinateSystem(extent = {{-300, -100}, {300, 100}})));
end Network;
