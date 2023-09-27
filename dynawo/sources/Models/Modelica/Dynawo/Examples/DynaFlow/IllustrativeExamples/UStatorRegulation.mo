within Dynawo.Examples.DynaFlow.IllustrativeExamples;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

model UStatorRegulation "System with two PV generators regulating their stator voltages"
  extends Icons.Example;

  // Generators
  Dynawo.Electrical.Machines.SignalN.GeneratorPVTfo Generator3(
    KGover        =  1,
    PGen0Pu       = -1.5,
    PMaxPu        =  10000,
    PMinPu        = -10000,
    PNom          =  1,
    PRef0Pu       = -1.5,
    QGen0Pu       = -0.5,
    QMaxPu        =  0.62,
    QMinPu        = -2,
    QNomAlt       =  200,
    QStator0Pu    =  0.306689,
    SNom          =  200,
    U0Pu          =  1.05,
    UStator0Pu    =  1.07618,
    UStatorRef0Pu =  1.07618,
    XTfoPu        =  0.1,
    i0Pu          =  Complex(-1.42857, 0.47619),
    iStator0Pu    =  Complex(0.714286, -0.238095),
    limUQDown0    =  false,
    limUQUp0      =  false,
    qStatus0      =  Dynawo.Electrical.Machines.SignalN.GeneratorPVTfo.QStatus.Standard,
    sStator0Pu    =  Complex(0.75, 0.306689),
    u0Pu          =  Complex(1.05, 0),
    uStator0Pu    =  Complex(1.07381, 0.0714286)
    ) annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Machines.SignalN.GeneratorPVTfoDiagramPQ Generator4(
    KGover        =  1,
    PGen0Pu       = -1.5,
    PMaxPu        =  10000,
    PMinPu        = -10000,
    PNom          =  1,
    PRef0Pu       = -1.5,
    QGen0Pu       = -0.5,
    QMax0Pu       =  2,
    QMaxTableFile =  "nrt/data/DynaFlow/GeneratorPVTfo/Diagram.txt",
    QMaxTableName =  "tableqmax",
    QMin0Pu       = -1.85,
    QMinTableFile =  "nrt/data/DynaFlow/GeneratorPVTfo/Diagram.txt",
    QMinTableName =  "tableqmin",
    QNomAlt       =  200,
    QStator0Pu    =  0.306689,
    SNom          =  200,
    U0Pu          =  1.05,
    UStator0Pu    =  1.07618,
    UStatorRef0Pu =  1.07618,
    XTfoPu        =  0.1,
    i0Pu          =  Complex(-1.42857, 0.47619),
    iStator0Pu    =  Complex(0.714286, -0.238095),
    limUQDown0    =  false,
    limUQUp0      =  false,
    qStatus0      =  Dynawo.Electrical.Machines.SignalN.GeneratorPVTfo.QStatus.Standard,
    sStator0Pu    =  Complex(0.75, 0.306689),
    u0Pu          =  Complex(1.05, 0),
    uStator0Pu    =  Complex(1.07381, 0.0714286)
    ) annotation(
    Placement(visible = true, transformation(origin = {-80, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Bus
  Dynawo.Electrical.Buses.InfiniteBus InfiniteBus2(
    UPhase        =  0,
    UPu           =  1.0305614
    ) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Dynawo.Electrical.Buses.Bus Bus1 annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // Lines
  Dynawo.Electrical.Lines.Line Line2(
    BPu           =  0,
    GPu           =  0,
    RPu           =  0,
    XPu           =  0.045044
    ) annotation(
    Placement(visible = true, transformation(origin = {0, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Lines.Line Line2Bis(
    BPu           =  0,
    GPu           =  0,
    RPu           =  0,
    XPu           =  0.0450440
    ) annotation(
    Placement(visible = true, transformation(origin = {0, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Events
  Dynawo.Electrical.Controls.Basics.Step SignalN(
    Height        =  0.1,
    Value0        =  0,
    tStep         =  70
    );

  Dynawo.Electrical.Events.Event.SingleBooleanEvent DisconnectLine(
    tEvent        =  50,
    stateEvent1   =  true
    );

equation
  // Generators steps
  SignalN.step.value = Generator3.N;
  SignalN.step.value = Generator4.N;

  // Generators intialisation
  Generator3.PRefPu = Generator3.PRef0Pu;
  Generator4.PRefPu = Generator4.PRef0Pu;
  Generator3.UStatorRefPu = Generator3.UStatorRef0Pu;
  Generator4.UStatorRefPu = Generator4.UStatorRef0Pu;

  // SwitchOff signals
  Generator3.switchOffSignal1.value = false;
  Generator3.switchOffSignal2.value = false;
  Generator3.switchOffSignal3.value = false;
  Generator4.switchOffSignal1.value = false;
  Generator4.switchOffSignal2.value = false;
  Generator4.switchOffSignal3.value = false;
  Line2.switchOffSignal1.value      = false;
  Line2.switchOffSignal2.value      = false;
  Line2Bis.switchOffSignal1.value   = false;

  // Grid connections
  connect(DisconnectLine.state1, Line2Bis.switchOffSignal2);
  connect(Generator3.terminal, Bus1.terminal) annotation(
    Line(points = {{-80, 20}, {-60, 20}, {-60, 0}, {-40, 0}}, color = {0, 0, 255}));
  connect(Bus1.terminal, Line2.terminal1) annotation(
    Line(points = {{-40, 0}, {-20, 0}, {-20, 20}, {-10, 20}}, color = {0, 0, 255}));
  connect(Bus1.terminal, Line2Bis.terminal1) annotation(
    Line(points = {{-40, 0}, {-20, 0}, {-20, -20}, {-10, -20}}, color = {0, 0, 255}));
  connect(Line2.terminal2, InfiniteBus2.terminal) annotation(
    Line(points = {{10, 20}, {20, 20}, {20, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(Line2Bis.terminal2, InfiniteBus2.terminal) annotation(
    Line(points = {{10, -20}, {20, -20}, {20, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(Generator4.terminal, Bus1.terminal) annotation(
    Line(points = {{-80, -20}, {-60, -20}, {-60, 0}, {-40, 0}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 300, Tolerance = 1e-6, Interval = 10),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(ls = "klu", lv = "LOG_STATS", nls = "kinsol", s = "euler"),
    Documentation(info = "<html><head></head><body>The grid simulated in this model is composed of :<div>- Two PV generators with stator voltage regulation</div><div>- One bus at the output of the generators</div><div>- One inifite bus acting as a load</div><div>- Two lines connecting the two buses</div><div><br></div><div>The PV generators regulate their stator voltage, meaning that they try to maintain the voltage level behing their stator fixed at UStatorRef0Pu. However, if they reach their reactive power limits and cannot maintain the voltage target, they will provide the reactive power limit they reached (upper reactive limit in case of a low voltage and lower reactive limit in case of a high voltage).</div></body></html>"));
end UStatorRegulation;
