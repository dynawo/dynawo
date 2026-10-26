within Dynawo.Examples.GridForming.VSM;

model VSM_CurrentLimiting_CSA_Pvirt "Grid-forming VSM converter with current saturation and virtual power: bolted fault followed by a line tripping and reclosing"
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
  extends Modelica.Icons.Example;
  // Grid connection
  parameter Types.ApparentPowerModule SNom = 100 "Nominal apparent power of the converter in MVA";
  parameter Types.PerUnit SCR = 2 "Short-circuit ratio at the PCC (base SNom), with the four lines in service";
  final parameter Types.PerUnit XLinePu = SystemBase.SnRef/(SCR*SNom) "Equivalent reactance of the four parallel lines in pu (base UNom, SnRef)";
  final parameter Types.PerUnit RLinePu = XLinePu/10 "Equivalent resistance of the four parallel lines in pu (base UNom, SnRef)";
  // Scenario
  parameter Types.Time tFaultBegin = 10 "Time when the bolted fault at the PCC begins in s";
  parameter Types.Time tFaultEnd = 10.25 "Time when the bolted fault at the PCC is cleared in s";
  parameter Types.Time tLineTrip = 10.25 "Time when the first line is tripped in s";
  parameter Types.Time tLineReclose = 11.25 "Time when the first line is reclosed in s";
  parameter Types.PerUnit RoCoFValue = 0.04 "Rate of change of frequency of the grid in pu/s (base omegaNom)";
  parameter Types.Time tRoCoF = 15 "Start time of the RoCoF event in s";
  // Operating point at the PCC
  parameter Types.VoltageModulePu U0Pu = 0.9502027101293471 "Start value of voltage module at the PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 = 0.027098087127168706 "Start value of voltage angle at the PCC in rad";
  parameter Types.ActivePowerPu P0Pu = -0.9440416785411966 "Start value of active power at the PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu = 0.07364714495383004 "Start value of reactive power at the PCC in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at the PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu) "Start value of the complex current at the PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uGrid0Pu = u0Pu + Complex(RLinePu, XLinePu)*i0Pu "Grid voltage consistent with the operating point at the PCC in pu (base UNom)";

  // Post processing variables
  Types.Angle DeltaAngle = dynGFMVSM_A.Control_Pvirt.VSM.theta - (Grid.UPhase + Grid.theta) "Angle between the internal EMF of the converter and the grid voltage in rad";

  // Grid
  Electrical.Sources.AcGridRoCoF Grid(SNom = SNom, U0pu = Modelica.ComplexMath.'abs'(uGrid0Pu), Upu = Modelica.ComplexMath.'abs'(uGrid0Pu), UPhase0 = Modelica.ComplexMath.arg(uGrid0Pu), UPhase = Modelica.ComplexMath.arg(uGrid0Pu), StartRoCoF = tRoCoF, TimeRoCoF = 0.5, RoCoFValue = RoCoFValue, StartingFrequency = 0, ReturnRoCoF = false) annotation(
    Placement(transformation(origin = {26, -60}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 4*RLinePu, XPu = 4*XLinePu) annotation(
    Placement(transformation(origin = {98, -36}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 4*RLinePu, XPu = 4*XLinePu) annotation(
    Placement(transformation(origin = {98, -46}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line3(BPu = 0, GPu = 0, RPu = 4*RLinePu, XPu = 4*XLinePu) annotation(
    Placement(transformation(origin = {98, -54}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line4(BPu = 0, GPu = 0, RPu = 4*RLinePu, XPu = 4*XLinePu) annotation(
    Placement(transformation(origin = {98, -66}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0, tBegin = tFaultBegin, tEnd = tFaultEnd) annotation(
    Placement(visible = true, transformation(origin = {98, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Converter (tuning of the original test case)
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM_A_Pvirt dynGFMVSM_A(SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, P0Pu = P0Pu, Q0Pu = Q0Pu,
    H = 5, kVSM = 2*0.7*sqrt(2*5*SystemBase.omegaNom/(0.1 + 0.21 + 0.06 + 0.1)),
    Mq = 0.05, Omegaf = SystemBase.omegaNom/10, Omegaff = 60, Kff = 0.09, XVIPu = 0.21,
    Omegac = 1000, Kfd = 1, Kfq = 1,
    ImaxPu = 1.2, IminPu = 0, EpsUpPu = 0.01, EpsDownPu = 0.01, tSat = 1e-4,
    RFilterPu = 0.003, LFilterPu = 0.1, CFilterPu = 1e-5, RTransformerPu = 0.006, LTransformerPu = 0.06, tVSC = 4e-4,
    OmegaPLL = sqrt(10*SystemBase.omegaNom), KsiPLL = SystemBase.omegaNom/sqrt(10*SystemBase.omegaNom), tPLL = 0.01) annotation(
    Placement(transformation(origin = {17, 45}, extent = {{-39, -39}, {39, 39}})));

  // References equal to the initial values of the control: the simulation starts in steady state
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.95) annotation(
    Placement(transformation(origin = {-136, 76}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {-136, 48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(transformation(origin = {-136, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(transformation(origin = {-136, -12}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.Utilities.Measurements measurements(SNom = SNom)  annotation(
    Placement(transformation(origin = {110, 46}, extent = {{-10, -10}, {10, 10}})));
equation
  // Line 1 is tripped after the fault, then reclosed
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = time >= tLineTrip and time < tLineReclose;
  line2.switchOffSignal1 = false;
  line2.switchOffSignal2 = false;
  line3.switchOffSignal1 = false;
  line3.switchOffSignal2 = false;
  line4.switchOffSignal1 = false;
  line4.switchOffSignal2 = false;
  dynGFMVSM_A.switchOffSignal1 = false;
  dynGFMVSM_A.switchOffSignal2 = false;
  dynGFMVSM_A.switchOffSignal3 = false;
  nodeFault.switchOffSignal1 = false;
  nodeFault.switchOffSignal2 = false;
  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{98, -16}, {98, -18}, {108, -18}, {108, -36}}, color = {0, 0, 255}));
  connect(Grid.aCPower, line.terminal1) annotation(
    Line(points = {{38, -54}, {72, -54}, {72, -36}, {88, -36}}, color = {0, 0, 255}));
  connect(Grid.aCPower, line2.terminal1) annotation(
    Line(points = {{38, -54}, {72, -54}, {72, -46}, {88, -46}}, color = {0, 0, 255}));
  connect(Grid.aCPower, line3.terminal1) annotation(
    Line(points = {{38, -54}, {88, -54}}, color = {0, 0, 255}));
  connect(Grid.aCPower, line4.terminal1) annotation(
    Line(points = {{38, -54}, {72, -54}, {72, -66}, {88, -66}}, color = {0, 0, 255}));
  connect(PRefPu.y, dynGFMVSM_A.PFilterRefPu) annotation(
    Line(points = {{-124, 76}, {-26, 76}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, dynGFMVSM_A.omegaRefPu) annotation(
    Line(points = {{-124, 48}, {-26, 48}, {-26, 60}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, Grid.OmegaRef) annotation(
    Line(points = {{-124, 48}, {-110, 48}, {-110, -55}, {14, -55}}, color = {0, 0, 127}));
  connect(QRefPu.y, dynGFMVSM_A.QFilterRefPu) annotation(
    Line(points = {{-124, 18}, {-48, 18}, {-48, 30}, {-26, 30}}, color = {0, 0, 127}));
  connect(URefPu.y, dynGFMVSM_A.UFilterRefPu) annotation(
    Line(points = {{-124, -12}, {-26, -12}, {-26, 14}}, color = {0, 0, 127}));
  connect(dynGFMVSM_A.terminal, measurements.terminal1) annotation(
    Line(points = {{60, 46}, {100, 46}}, color = {0, 0, 255}));
  connect(measurements.terminal2, line4.terminal2) annotation(
    Line(points = {{120, 46}, {140, 46}, {140, -66}, {108, -66}}, color = {0, 0, 255}));
  connect(line3.terminal2, measurements.terminal2) annotation(
    Line(points = {{108, -54}, {140, -54}, {140, 46}, {120, 46}}, color = {0, 0, 255}));
  connect(line2.terminal2, measurements.terminal2) annotation(
    Line(points = {{108, -46}, {140, -46}, {140, 46}, {120, 46}}, color = {0, 0, 255}));
  connect(line.terminal2, measurements.terminal2) annotation(
    Line(points = {{108, -36}, {140, -36}, {140, 46}, {120, 46}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, 100}, {200, -80}})),
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.001),
    Documentation(info = "<html><head></head><body>
<p>This test case assesses the large-disturbance behavior of a grid-forming Virtual Synchronous Machine with current saturation and virtual power (<b>DynGFMVSM_A_Pvirt</b>), following the scenarios of Y. Laba, PhD thesis, Centrale Lille, 2025, section 3.3.4 (Figures 3.12 and 3.15).</p>
<p>The converter (SNom = 100 MVA) is connected to a grid source through four identical parallel lines, whose equivalent impedance corresponds to a weak grid (SCR = 2, X/R = 10).</p>
<h4>Initialization</h4>
<p>The operating point is defined at the PCC (U0Pu, UPhase0, P0Pu, Q0Pu; P = 0.95 pu generated by default). The grid voltage is computed from this operating point and the line impedance, and the references of the converter are set to the initial values of its control (in particular URefPu = |E<sub>0</sub>|, the module of the internal EMF), so that the simulation starts in steady state.</p>
<h4>Scenario</h4>
<ul>
<li>t = 10 s: bolted three-phase fault at the PCC, cleared at t = 10.25 s. During the fault, the converter current is limited by the current saturation while the VSM keeps evolving on the virtual power.</li>
<li>t = 10.25 s: tripping of one of the four lines (the grid becomes weaker, SCR = 1.5), reclosed at t = 11.25 s.</li>
<li>Optionally, a RoCoF event of the grid can be applied with RoCoFValue and tRoCoF (no RoCoF event by default).</li>
</ul>
<p>The variables UPccPu, IPccPu, IPPu, IQPu and DeltaAngle (angle between the internal EMF and the grid voltage) are provided for post-processing.</p>
</body></html>"));
end VSM_CurrentLimiting_CSA_Pvirt;
