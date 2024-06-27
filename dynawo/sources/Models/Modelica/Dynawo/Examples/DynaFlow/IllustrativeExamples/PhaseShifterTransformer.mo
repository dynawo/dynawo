within Dynawo.Examples.DynaFlow.IllustrativeExamples;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model PhaseShifterTransformer "Elementary system with one infinite bus, one load, two lines and a Phase Tap Changer Transformer"
  extends Icons.Example;

  // Base calculation
  final parameter Modelica.SIunits.Impedance ZBASE69_0 = 69.0^2/Dynawo.Electrical.SystemBase.SnRef;

  // gen01 init values:
  parameter Dynawo.Types.VoltageModulePu U0PuGen01 = 1.;

  // load01 init values:
  parameter Dynawo.Types.ActivePowerPu P0PuLoad01 = 1.;
  parameter Dynawo.Types.ReactivePowerPu Q0PuLoad01 = 0.;
  final parameter Dynawo.Types.ComplexApparentPowerPu s0Pu_load01 = Complex(P0PuLoad01, Q0PuLoad01);

  // Generator
  Dynawo.Electrical.Buses.InfiniteBus gen01(UPu = U0PuGen01, UPhase = 0) annotation(
    Placement(transformation(origin = {1, 80}, extent = {{-12, -12}, {11, 11}})));
  Dynawo.Types.ActivePower checkGen01P;
  Dynawo.Types.ReactivePower checkGen01Q;

  // Load
  Dynawo.Electrical.Loads.LoadPQ load01(s0Pu = s0Pu_load01, u0Pu = Complex(1, 0), i0Pu = s0Pu_load01) annotation(
    Placement(transformation(origin = {0, -80}, extent = {{-14, -14}, {14, 14}})));
  Dynawo.Electrical.Controls.Basics.SetPoint PrefPuLoad01(Value0 = P0PuLoad01);
  Dynawo.Electrical.Controls.Basics.SetPoint QrefPuLoad01(Value0 = Q0PuLoad01);

  // Buses
  Dynawo.Electrical.Buses.Bus bus01 annotation(
    Placement(transformation(origin = {0, 60}, extent = {{-12, -12}, {12, 12}})));
  Dynawo.Electrical.Buses.Bus bus02 annotation(
    Placement(transformation(origin = {0, -60}, extent = {{-12, -12}, {12, 12}})));
  Dynawo.Electrical.Buses.Bus bus03 annotation(
    Placement(transformation(origin = {20, 0}, extent = {{-12, -12}, {12, 12}})));

  // Phase Tap Changer Transformer
  Dynawo.Electrical.Transformers.TransformerPhaseTapChanger tfo01(BPu = 0.0*ZBASE69_0, GPu = 0.0*ZBASE69_0, RPu = 0.0/ZBASE69_0, XPu = 0./ZBASE69_0, RatioTfoPu = 1.0, NbTap = 19, Tap0 = 9, ThetaTfoMin = -0.19634954084936207, ThetaTfoMax = 0.19634954084936207) annotation(
    Placement(transformation(origin = {20, 20}, extent = {{-12, -12}, {12, 12}}, rotation = -90)));

  // Lines
  Dynawo.Electrical.Lines.Line line01(BPu = 0.*ZBASE69_0, GPu = 0.*ZBASE69_0, RPu = 0.15/ZBASE69_0, XPu = 18/ZBASE69_0) annotation(
    Placement(transformation(origin = {-20, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line02(BPu = 0.*ZBASE69_0, GPu = 0.*ZBASE69_0, RPu = 0.15/ZBASE69_0, XPu = 18/ZBASE69_0) annotation(
    Placement(transformation(origin = {20, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // Controller
  Dynawo.Electrical.Controls.Transformers.PhaseShifterP shiftController01(P0 = 0.7, PDeadBand = 0.05, PTarget = 0.7, state0 = Dynawo.Electrical.Controls.Transformers.BaseClasses.TapChangerPhaseShifterParams.State.Standard, t1st = 25, tNext = 15, tap0 = 9, tapMax = 18, tapMin = 0, increaseTapToIncreaseValue = false);

  // output connectors
  Dynawo.Connectors.ImPin PPuLine01 "Active power transitting in line 01 in pu (base SnRef)";

equation
  connect(bus01.terminal, line01.terminal1) annotation(
    Line(points = {{0, 60}, {0, 40}, {-20, 40}, {-20, -20}}, color = {0, 0, 255}));
  connect(bus01.terminal, tfo01.terminal1) annotation(
    Line(points = {{0, 60}, {0, 40}, {20, 40}, {20, 32}}, color = {0, 0, 255}));
  connect(line01.terminal2, bus02.terminal) annotation(
    Line(points = {{-20, -40}, {0, -40}, {0, -60}}, color = {0, 0, 255}));
  connect(line02.terminal2, bus02.terminal) annotation(
    Line(points = {{20, -40}, {0, -40}, {0, -60}}, color = {0, 0, 255}));
  connect(gen01.terminal, bus01.terminal) annotation(
    Line(points = {{0.5, 79.5}, {0.5, 60}, {0, 60}}, color = {0, 0, 255}));
  connect(load01.terminal, bus02.terminal) annotation(
    Line(points = {{0, -80}, {0, -60}}, color = {0, 0, 255}));
  connect(tfo01.terminal2, bus03.terminal) annotation(
    Line(points = {{20, 8}, {20, 0}}, color = {0, 0, 255}));
  connect(bus03.terminal, line02.terminal1) annotation(
    Line(points = {{20, 0}, {20, -20}}, color = {0, 0, 255}));
  connect(shiftController01.PMonitored, PPuLine01);

  //PhaseShifter
  shiftController01.locked = if time < 50 then true else false;
  PPuLine01.value = -line01.P2Pu;
  when shiftController01.tap.value <> pre(shiftController01.tap.value) then
    tfo01.tap.value = shiftController01.tap.value;
  end when;
  PrefPuLoad01.setPoint.value = load01.PRefPu;
  QrefPuLoad01.setPoint.value = load01.QRefPu;
  load01.deltaP = 0.;
  load01.deltaQ = 0.;
  load01.switchOffSignal1.value = false;
  load01.switchOffSignal2.value = false;
  tfo01.switchOffSignal1.value = false;
  tfo01.switchOffSignal2.value = false;
  line01.switchOffSignal1.value = false;
  line02.switchOffSignal1.value = false;
  line01.switchOffSignal2.value = false;
  line02.switchOffSignal2.value = false;
  shiftController01.switchOffSignal1.value = false;
  shiftController01.switchOffSignal2.value = false;
  checkGen01P = Dynawo.Electrical.SystemBase.SnRef*Modelica.ComplexMath.real(gen01.terminal.V*Modelica.ComplexMath.conj(gen01.terminal.i));
  checkGen01Q = Dynawo.Electrical.SystemBase.SnRef*Modelica.ComplexMath.imag(gen01.terminal.V*Modelica.ComplexMath.conj(gen01.terminal.i));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-6, Interval = 1),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(ls = "klu", lv = "LOG_STATS", nls = "kinsol", s = "euler"),
    Documentation(info = "<html><head></head><body><div>This test case is composed one infinite bus, three regular buses, one load, two lines a phase tap changer transformer and the associated phase shifter controller.&nbsp;</div><div>This is inspired by the <a href='https://en.wikipedia.org/wiki/Quadrature_booster'>quadrature_booster Wikipedia page</a>.</div><div><br></div><div>At t = 0s, the phase tap changer transformer is at its centre tap position of 9 and has a phase angle of 0°. It thus does not affect the power flow through the circuit and both lines are equally loaded at 0.5 Pu.</div><div>At t = 50s, the phase shifter controller is turned on with a target PMonitored = 0.7 Pu (+/- tolerance) through line01.</div><div>The controller then passes several taps down. The resulting negative phase angle (-7.5°) has diverted portion of loading onto the parallel circuit, while the total load supplied is unchanged.<div/>

    <figure>
    <img width=\"350\" src=\"modelica://Dynawo/Examples/DynaFlow/IllustrativeExamples/Resources/PhaseShifterPPuLine01.png\">
    </figure>

</body></html>"),
    Diagram);
end PhaseShifterTransformer;
