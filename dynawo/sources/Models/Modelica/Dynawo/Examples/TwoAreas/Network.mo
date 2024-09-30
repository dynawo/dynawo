within Dynawo.Examples.TwoAreas;

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
  //(UNom = 20)
  Dynawo.Electrical.Buses.Bus bus07 annotation(
    Placement(visible = true, transformation(origin = {-60, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  //(UNom = 230)
  Dynawo.Electrical.Buses.Bus bus06 annotation(
    Placement(visible = true, transformation(origin = {-120, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  //(UNom = 230)
  Dynawo.Electrical.Buses.Bus bus08 annotation(
    Placement(visible = true, transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  //(UNom = 230)
  Dynawo.Electrical.Buses.Bus bus11 annotation(
    Placement(visible = true, transformation(origin = {180, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  //(UNom = 230)
  Dynawo.Electrical.Buses.Bus bus05 annotation(
    Placement(visible = true, transformation(origin = {-178, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  //(UNom = 230)
  Dynawo.Electrical.Buses.Bus bus03 annotation(
    Placement(visible = true, transformation(origin = {240, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  //(UNom = 20)
  Dynawo.Electrical.Buses.Bus bus10 annotation(
    Placement(visible = true, transformation(origin = {122, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  //(UNom = 230)
  Dynawo.Electrical.Buses.Bus bus02 annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus04 annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //(UNom = 20)
  Dynawo.Electrical.Buses.Bus bus09 annotation(
    Placement(visible = true, transformation(origin = {60, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  //(UNom = 230)
  Dynawo.Electrical.Lines.Line line0506(BPu = bLinePu / 2 * lengthLine0506Km, GPu = 0, RPu = rLinePu * lengthLine0506Km, XPu = xLinePu * lengthLine0506Km) annotation(
    Placement(visible = true, transformation(origin = {-148, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line0607(BPu = bLinePu / 2 * lengthLine0607Km, GPu = 0, RPu = rLinePu * lengthLine0607Km, XPu = xLinePu * lengthLine0607Km) annotation(
    Placement(visible = true, transformation(origin = {-90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line0708b(BPu = bLinePu / 2 * lengthLine0708Km, GPu = 0, RPu = rLinePu * lengthLine0708Km, XPu = xLinePu * lengthLine0708Km) annotation(
    Placement(visible = true, transformation(origin = {-28, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line0910(BPu = bLinePu / 2 * lengthLine0910Km, GPu = 0, RPu = rLinePu * lengthLine0910Km, XPu = xLinePu * lengthLine0910Km) annotation(
    Placement(visible = true, transformation(origin = {94, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line0708a(BPu = bLinePu / 2 * lengthLine0708Km, GPu = 0, RPu = rLinePu * lengthLine0708Km, XPu = xLinePu * lengthLine0708Km) annotation(
    Placement(visible = true, transformation(origin = {-28, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line0809b(BPu = bLinePu / 2 * lengthLine0809Km, GPu = 0, RPu = rLinePu * lengthLine0809Km, XPu = xLinePu * lengthLine0809Km) annotation(
    Placement(visible = true, transformation(origin = {32, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1011(BPu = bLinePu / 2 * lengthLine1011Km, GPu = 0, RPu = rLinePu * lengthLine1011Km, XPu = xLinePu * lengthLine1011Km) annotation(
    Placement(visible = true, transformation(origin = {154, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Transformer parameters
  final parameter Types.PerUnit xTrPu = 0.15 "Step-uptransformer reactance in pu (SnTr base)";
  final parameter Types.VoltageModule U1TrKv = 20 "Primary (low voltage) transformer voltage in kV";
  final parameter Types.VoltageModule U2TrKv = 230 "Secondary (high voltage) transformer voltage in kV";
  final parameter Types.ApparentPowerModule SnTr = 900 "Transformer rated power in MVA";
  final parameter Types.PerUnit xTrSystemBasePu = xTrPu / SnTr * Dynawo.Electrical.SystemBase.SnRef "Step-uptransformer reactance in pu (system base SnRef)";
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
  parameter Types.ActivePowerPu P0PuL7 = 9.67 + 2.5;
  parameter Types.ReactivePowerPu Q0PuL7 = 1 + 1;
  final parameter Types.ComplexApparentPowerPu s0PuL7 = Complex(P0PuL7, Q0PuL7);
  parameter Types.ActivePowerPu P0PuL9 = 17.67;
  parameter Types.ReactivePowerPu Q0PuL9 = 1;
  final parameter Types.ComplexApparentPowerPu s0PuL9 = Complex(P0PuL9, Q0PuL9);
  // shunt capacitors
  parameter Types.ReactivePowerPu Q0PuC7 = -2;
  final parameter Types.ComplexApparentPowerPu s0PuC7 = Complex(0, Q0PuC7);
  parameter Types.ReactivePowerPu Q0PuC9 = -3.5;
  final parameter Types.ComplexApparentPowerPu s0PuC9 = Complex(0, Q0PuC9);
  parameter Types.Voltage u0PuB7 = Complex(0.96 * cos(-0.08306280535756658), 0.96 * sin(-0.08306280535756658));
  parameter Types.Voltage u0PuB9 = Complex(0.97 * cos(-0.562), 0.97 * sin(-0.562));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tr0105(BPu = 0, GPu = 0, RPu = 0, XPu = xTrSystemBasePu, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-208, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tr0206(BPu = 0, GPu = 0, RPu = 0, XPu = xTrSystemBasePu, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-130, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tr0410(BPu = 0, GPu = 0, RPu = 0, XPu = xTrSystemBasePu, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {130, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tr0311(BPu = 0, GPu = 0, RPu = 0, XPu = xTrSystemBasePu, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {212, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Electrical.Loads.LoadZIP L9(Ip = 1, Iq = 0, Pp = 0, Pq = 0, Zp = 0, Zq = 1, i0Pu = ComplexMath.conj(s0PuL9 / L9.u0Pu), s0Pu = s0PuL9, u0Pu = u0PuB9) annotation(
    Placement(visible = true, transformation(origin = {52, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadZIP C9(Ip = 0, Iq = 0, Pp = 0, Pq = 0, Zp = 0, Zq = 1, i0Pu = ComplexMath.conj(s0PuC9 / C9.u0Pu), s0Pu = s0PuC9, u0Pu = u0PuB9) annotation(
    Placement(visible = true, transformation(origin = {74, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Loads.LoadZIP L7(Ip = 1, Iq = 0, Pp = 0, Pq = 0, Zp = 0, Zq = 1, i0Pu = ComplexMath.conj(s0PuL7 / L7.u0Pu), s0Pu = s0PuL7, u0Pu = u0PuB7) annotation(
    Placement(visible = true, transformation(origin = {-70, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadZIP C7(Ip = 0, Iq = 0, Pp = 0, Pq = 0, Zp = 0, Zq = 1, i0Pu = ComplexMath.conj(s0PuC7 / C7.u0Pu), s0Pu = s0PuC7, u0Pu = u0PuB7) annotation(
    Placement(visible = true, transformation(origin = {-46, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line line0809a(BPu = bLinePu / 2 * lengthLine0809Km, GPu = 0, RPu = rLinePu * lengthLine0809Km, XPu = xLinePu * lengthLine0809Km) annotation(
    Placement(visible = true, transformation(origin = {32, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
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
  connect(line0809b.terminal2, bus09.terminal) annotation(
    Line(points = {{42, 64}, {60, 64}, {60, 70}}, color = {0, 0, 255}));
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
  tr0105.switchOffSignal2.value = false;
  tr0206.switchOffSignal1.value = false;
  tr0206.switchOffSignal2.value = false;
  tr0311.switchOffSignal1.value = false;
  tr0311.switchOffSignal2.value = false;
  tr0410.switchOffSignal1.value = false;
  tr0410.switchOffSignal2.value = false;
  L7.switchOffSignal1.value = false;
  L7.switchOffSignal2.value = false;
  L9.switchOffSignal1.value = false;
  L9.switchOffSignal2.value = false;
  C7.switchOffSignal1.value = false;
  C7.switchOffSignal2.value = false;
  C9.switchOffSignal1.value = false;
  C9.switchOffSignal2.value = false;
// Load references
  L7.PRefPu = s0PuL7.re;
  L7.QRefPu = s0PuL7.im;
  L7.deltaP = 0;
  L7.deltaQ = 0;
  L9.PRefPu = s0PuL9.re;
  L9.QRefPu = s0PuL9.im;
  L9.deltaP = 0;
  L9.deltaQ = 0;
  C7.PRefPu = 0;
  C7.QRefPu = s0PuC7.im;
  C7.deltaP = 0;
  C7.deltaQ = 0;
  C9.PRefPu = 0;
  C9.QRefPu = s0PuC9.im;
  C9.deltaP = 0;
  C9.deltaQ = 0;
  connect(bus01.terminal, tr0105.terminal1) annotation(
    Line(points = {{-240, 70}, {-218, 70}}, color = {0, 0, 255}));
  connect(tr0105.terminal2, bus05.terminal) annotation(
    Line(points = {{-198, 70}, {-178, 70}}, color = {0, 0, 255}));
  connect(tr0206.terminal1, bus02.terminal) annotation(
    Line(points = {{-130, 8}, {-130, -20}}, color = {0, 0, 255}));
  connect(tr0206.terminal2, bus06.terminal) annotation(
    Line(points = {{-130, 28}, {-130, 64}, {-120, 64}, {-120, 70}}, color = {0, 0, 255}));
  connect(tr0410.terminal1, bus04.terminal) annotation(
    Line(points = {{130, 8}, {130, -20}}, color = {0, 0, 255}));
  connect(tr0410.terminal2, bus10.terminal) annotation(
    Line(points = {{130, 28}, {130, 64}, {122, 64}, {122, 70}}, color = {0, 0, 255}));
  connect(bus03.terminal, tr0311.terminal1) annotation(
    Line(points = {{240, 70}, {222, 70}}, color = {0, 0, 255}));
  connect(tr0311.terminal2, bus11.terminal) annotation(
    Line(points = {{202, 70}, {180, 70}}, color = {0, 0, 255}));
  connect(L9.terminal, bus09.terminal) annotation(
    Line(points = {{52, 44}, {60, 44}, {60, 70}}, color = {0, 0, 255}));
  connect(C9.terminal, bus09.terminal) annotation(
    Line(points = {{74, 44}, {60, 44}, {60, 70}}, color = {0, 0, 255}));
  connect(L7.terminal, bus07.terminal) annotation(
    Line(points = {{-70, 44}, {-60, 44}, {-60, 70}}, color = {0, 0, 255}));
  connect(C7.terminal, bus07.terminal) annotation(
    Line(points = {{-46, 44}, {-60, 44}, {-60, 70}}, color = {0, 0, 255}));
  connect(line0809a.terminal1, bus08.terminal) annotation(
    Line(points = {{22, 76}, {0, 76}, {0, 70}}, color = {0, 0, 255}));
  connect(line0809a.terminal2, bus09.terminal) annotation(
    Line(points = {{42, 76}, {60, 76}, {60, 70}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -100}, {300, 100}})),
    Icon(coordinateSystem(extent = {{-300, -100}, {300, 100}})));
end Network;
