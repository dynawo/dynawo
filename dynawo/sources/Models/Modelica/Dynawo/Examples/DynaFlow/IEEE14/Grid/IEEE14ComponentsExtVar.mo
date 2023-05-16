within Dynawo.Examples.DynaFlow.IEEE14.Grid;

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

model IEEE14ComponentsExtVar "IEEE 14-bus system benchmark formed with 14 buses, 5 generators, 1 shunt, 3 transformers , 17 lines and 11 loads. This model inherite from IEEE14.BaseClasses.NetworkWithAlphaBetaRestorativeLoads."
  import Dynawo;
  import Modelica;

  extends Modelica.Icons.Example;
  extends Dynawo.Examples.DynaFlow.IEEE14.Grid.BaseClasses.NetworkWithAlphaBetaRestorativeLoads;

  // Generators
    Dynawo.Electrical.Machines.SignalN.GeneratorPV Gen1(KGover = 1, PGen0Pu = 2.3239, PMaxPu = 10.9, PMinPu = 0, PNom = 1090, PRef0Pu = -2.3239, QGen0Pu = -0.1655, QMaxPu = 100, QMinPu = -100, QNomAlt = 10000, U0Pu = 1.06, URef0Pu = 1.06, i0Pu = Complex(-2.192358, -0.156132), limUQDown0 = false, limUQUp0 = false, qStatus0 = Dynawo.Electrical.Machines.SignalN.GeneratorPV.QStatus.Standard, u0Pu = Complex(1.06, 0)) annotation(
    Placement(visible = true, transformation(origin = {-120, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV Gen2(KGover = 1, PGen0Pu = 0.4, PMaxPu = 10.08, PMinPu = 0, PNom = 1008, PRef0Pu = -0.4, QGen0Pu = 0.4356, QMaxPu = 100, QMinPu = -100, QNomAlt = 10000, U0Pu = 1.045072, URef0Pu = 1.045072, i0Pu = Complex(-0.345121, 0.448465), limUQDown0 = false, limUQUp0 = false, qStatus0 = Dynawo.Electrical.Machines.SignalN.GeneratorPV.QStatus.Standard, u0Pu = Complex(1.041127, -0.090721)) annotation(
    Placement(visible = true, transformation(origin = {-94, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV Gen3(KGover = 1, PGen0Pu = 0, PMaxPu = 14.85, PMinPu = 0, PNom = 1485, PRef0Pu = 0, QGen0Pu = 0.250700, QMaxPu = 100, QMinPu = -100, QNomAlt = 10000, U0Pu = 1.01, URef0Pu = 1.01, i0Pu = Complex(0.054697, 0.242116), limUQDown0 = false, limUQUp0 = false, qStatus0 = Dynawo.Electrical.Machines.SignalN.GeneratorPV.QStatus.Standard, u0Pu = Complex(0.985173, -0.222561)) annotation(
    Placement(visible = true, transformation(origin = {136, -108}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV Gen6(KGover = 1, PGen0Pu = 0, PMaxPu = 0.744, PMinPu = 0, PNom = 74.4, PRef0Pu = 0, QGen0Pu = 0.1273, QMaxPu = 100, QMinPu = -100, QNomAlt = 10000, U0Pu = 1.070290, URef0Pu = 1.070290, i0Pu = Complex(0.029217, 0.115295), limUQDown0 = false, limUQUp0 = false, qStatus0 = Dynawo.Electrical.Machines.SignalN.GeneratorPV.QStatus.Standard, u0Pu = Complex(1.037496, -0.262912)) annotation(
    Placement(visible = true, transformation(origin = {-18, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV Gen8(KGover = 1, PGen0Pu = 0, PMaxPu = 2.28, PMinPu = 0, PNom = 228, PRef0Pu = 0, QGen0Pu = 0.1762, QMaxPu = 100, QMinPu = -100, QNomAlt = 10000, U0Pu = 1.089855, URef0Pu = 1.089855, i0Pu = Complex(0.037358, 0.157298), limUQDown0 = false, limUQUp0 = false, qStatus0 = Dynawo.Electrical.Machines.SignalN.GeneratorPV.QStatus.Standard, u0Pu = Complex(1.060361, -0.251831)) annotation(
    Placement(visible = true, transformation(origin = {132, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Generators control
  Dynawo.Electrical.Controls.Frequency.SignalN ModelSignalN;
  Dynawo.Types.Angle Theta_Bus1;

equation
  // Switch off signals for generators
  Gen1.switchOffSignal1.value = false;
  Gen1.switchOffSignal2.value = false;
  Gen1.switchOffSignal3.value = false;
  Gen2.switchOffSignal1.value = false;
  Gen2.switchOffSignal2.value = false;
  Gen2.switchOffSignal3.value = false;
  Gen3.switchOffSignal1.value = false;
  Gen3.switchOffSignal2.value = false;
  Gen3.switchOffSignal3.value = false;
  Gen6.switchOffSignal1.value = false;
  Gen6.switchOffSignal2.value = false;
  Gen6.switchOffSignal3.value = false;
  Gen8.switchOffSignal1.value = false;
  Gen8.switchOffSignal2.value = false;
  Gen8.switchOffSignal3.value = false;

  // Generators controls and references
  ModelSignalN.thetaRef = Theta_Bus1;
  Theta_Bus1 = Modelica.ComplexMath.arg(Bus1.terminal.V);
  Gen1.N = ModelSignalN.N;
  Gen2.N = ModelSignalN.N;
  Gen3.N = ModelSignalN.N;
  Gen6.N = ModelSignalN.N;
  Gen8.N = ModelSignalN.N;
  Gen1.URefPu = Gen1.URef0Pu;
  Gen1.PRefPu = Gen1.PRef0Pu;
  Gen2.URefPu = Gen2.URef0Pu;
  Gen2.PRefPu = Gen2.PRef0Pu;
  Gen3.URefPu = Gen3.URef0Pu;
  Gen3.PRefPu = Gen3.PRef0Pu;
  Gen6.URefPu = Gen6.URef0Pu;
  Gen6.PRefPu = Gen6.PRef0Pu;
  Gen8.URefPu = Gen8.URef0Pu;
  Gen8.PRefPu = Gen8.PRef0Pu;

  // Network connections
  connect(Gen1.terminal, Bus1.terminal) annotation(
    Line(points = {{-120, -20}, {-120, -40}}, color = {0, 0, 255}));
  connect(Gen2.terminal, Bus2.terminal) annotation(
    Line(points = {{-94, -84}, {-78, -84}, {-78, -100}}, color = {0, 0, 255}));
  connect(Gen3.terminal, Bus3.terminal) annotation(
    Line(points = {{136, -108}, {112, -108}, {112, -120}}, color = {0, 0, 255}));
  connect(Gen8.terminal, Bus8.terminal) annotation(
    Line(points = {{132, 58}, {132, 40}}, color = {0, 0, 255}));
  connect(Gen6.terminal, Bus6.terminal) annotation(
    Line(points = {{-18, 14}, {-30, 14}, {-30, 0}}, color = {0, 0, 255}));

  annotation(
    experiment(StartTime = 0, StopTime = 2000, Tolerance = 1e-06, Interval = 10),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(ls = "klu", lv = "LOG_STATS", nls = "kinsol", s = "euler"),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})));
end IEEE14ComponentsExtVar;
