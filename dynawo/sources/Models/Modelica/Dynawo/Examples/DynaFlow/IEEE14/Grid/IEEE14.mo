within Dynawo.Examples.DynaFlow.IEEE14.Grid;

model IEEE14 "Test case on IEEE 14 buses benchmark"
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
  import Dynawo;
  import Dynawo.Electrical;
  import Dynawo.Types;
  import Modelica.SIunits;
  import Modelica;

  extends Icons.Example;

  Dynawo.Electrical.Machines.SignalN.GeneratorPV Gen1(KGover = 1, PGen0Pu = 2.3239, PMaxPu = 10.9, PMinPu = 0, PNom = 1090, PRef0Pu = -2.3239, QGen0Pu = -0.1655, QMaxPu = 100, QMinPu = -100, QNomAlt = 10000, U0Pu = 1.06, URef0Pu = 1.06, i0Pu = Complex(-2.192358, -0.156132), limUQDown0 = false, limUQUp0 = false, qStatus0 = Dynawo.Electrical.Machines.SignalN.GeneratorPV.QStatus.Standard, u0Pu = Complex(1.06, 0)) annotation(
    Placement(visible = true, transformation(origin = {-116, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV Gen2(KGover = 1, PGen0Pu = 0.4, PMaxPu = 10.08, PMinPu = 0, PNom = 1008, PRef0Pu = -0.4, QGen0Pu = 0.4356, QMaxPu = 100, QMinPu = -100, QNomAlt = 10000, U0Pu = 1.045072, URef0Pu = 1.045072, i0Pu = Complex(-0.345121, 0.448465), limUQDown0 = false, limUQUp0 = false, qStatus0 = Dynawo.Electrical.Machines.SignalN.GeneratorPV.QStatus.Standard, u0Pu = Complex(1.041127, -0.090721)) annotation(
    Placement(visible = true, transformation(origin = {-86, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV Gen3(KGover = 1, PGen0Pu = 0, PMaxPu = 14.85, PMinPu = 0, PNom = 1485, PRef0Pu = 0, QGen0Pu = 0.250700, QMaxPu = 100, QMinPu = -100, QNomAlt = 10000, U0Pu = 1.01, URef0Pu = 1.01, i0Pu = Complex(0.054697, 0.242116), limUQDown0 = false, limUQUp0 = false, qStatus0 = Dynawo.Electrical.Machines.SignalN.GeneratorPV.QStatus.Standard, u0Pu = Complex(0.985173, -0.222561)) annotation(
    Placement(visible = true, transformation(origin = {102, -108}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV Gen6(KGover = 1, PGen0Pu = 0, PMaxPu = 0.744, PMinPu = 0, PNom = 74.4, PRef0Pu = 0, QGen0Pu = 0.1273, QMaxPu = 100, QMinPu = -100, QNomAlt = 10000, U0Pu = 1.070290, URef0Pu = 1.070290, i0Pu = Complex(0.029217, 0.115295), limUQDown0 = false, limUQUp0 = false, qStatus0 = Dynawo.Electrical.Machines.SignalN.GeneratorPV.QStatus.Standard, u0Pu = Complex(1.037496, -0.262912)) annotation(
    Placement(visible = true, transformation(origin = {-30, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV Gen8(KGover = 1, PGen0Pu = 0, PMaxPu = 2.28, PMinPu = 0, PNom = 228, PRef0Pu = 0, QGen0Pu = 0.1762, QMaxPu = 100, QMinPu = -100, QNomAlt = 10000, U0Pu = 1.089855, URef0Pu = 1.089855, i0Pu = Complex(0.037358, 0.157298), limUQDown0 = false, limUQUp0 = false, qStatus0 = Dynawo.Electrical.Machines.SignalN.GeneratorPV.QStatus.Standard, u0Pu = Complex(1.060361, -0.251831)) annotation(
    Placement(visible = true, transformation(origin = {110, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load2(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.196308, -0.139089), s0Pu = Complex(0.217000, 0.127000), tFilter = 10, u0Pu = Complex(1.041127, -0.090721)) annotation(
    Placement(visible = true, transformation(origin = {-86, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load3(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.868294, -0.389016), s0Pu = Complex(0.942000, 0.190000), tFilter = 10, u0Pu = Complex(0.985173, -0.222561)) annotation(
    Placement(visible = true, transformation(origin = {102, -136}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load4(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.468972, -0.046384), s0Pu = Complex(0.478000, -0.039000), tFilter = 10, u0Pu = Complex(1.001230, -0.182187)) annotation(
    Placement(visible = true, transformation(origin = {70, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load5(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.071279, -0.026881), s0Pu = Complex(0.076000, 0.016000), tFilter = 10, u0Pu = Complex(1.007583, -0.155511)) annotation(
    Placement(visible = true, transformation(origin = {-30, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load6(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.084225, -0.093633), s0Pu = Complex(0.112000, 0.075000), tFilter = 10, u0Pu = Complex(1.037496, -0.262912)) annotation(
    Placement(visible = true, transformation(origin = {-42, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load9(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.229406, -0.223911), s0Pu = Complex(0.295000, 0.166000), tFilter = 10, u0Pu = Complex(1.020247, -0.272201)) annotation(
    Placement(visible = true, transformation(origin = {38, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load10(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.068305, -0.075586), s0Pu = Complex(0.090000, 0.058000), tFilter = 10, u0Pu = Complex(1.014711, -0.273737)) annotation(
    Placement(visible = true, transformation(origin = {22, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load11(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.027671, -0.024921), s0Pu = Complex(0.035000, 0.018000), tFilter = 10, u0Pu = Complex(1.021886, -0.269814)) annotation(
    Placement(visible = true, transformation(origin = {-12, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load12(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.051876, -0.029677), s0Pu = Complex(0.061000, 0.016000), tFilter = 10, u0Pu = Complex(1.018873, -0.274446)) annotation(
    Placement(visible = true, transformation(origin = {-88, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load13(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.109617, -0.086901), s0Pu = Complex(0.135000, 0.058000), tFilter = 10, u0Pu = Complex(1.013840, -0.274628)) annotation(
    Placement(visible = true, transformation(origin = {-32, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load14(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.124816, -0.086053), s0Pu = Complex(0.149000, 0.050000), tFilter = 10, u0Pu = Complex(0.996351, -0.286332)) annotation(
    Placement(visible = true, transformation(origin = {24, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Frequency.SignalN ModelSignalN annotation(
    Placement(visible = true, transformation(origin = {-130, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus10 annotation(
    Placement(visible = true, transformation(origin = {22, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus11 annotation(
    Placement(visible = true, transformation(origin = {-12, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus12 annotation(
    Placement(visible = true, transformation(origin = {-88, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus13 annotation(
    Placement(visible = true, transformation(origin = {-32, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus14 annotation(
    Placement(visible = true, transformation(origin = {24, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus2 annotation(
    Placement(visible = true, transformation(origin = {-86, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus3 annotation(
    Placement(visible = true, transformation(origin = {102, -126}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus4 annotation(
    Placement(visible = true, transformation(origin = {70, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus5 annotation(
    Placement(visible = true, transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus6 annotation(
    Placement(visible = true, transformation(origin = {-30, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus7 annotation(
    Placement(visible = true, transformation(origin = {90, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus8 annotation(
    Placement(visible = true, transformation(origin = {110, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus9 annotation(
    Placement(visible = true, transformation(origin = {38, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus1(terminal.V.re(start = 1)) annotation(
    Placement(visible = true, transformation(origin = {-116, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB10B11(BPu = 0, GPu = 0, RPu = 0.156256 / ZBASE2, XPu = 0.365778 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {12, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB12B13(BPu = 0, GPu = 0, RPu = 0.42072 / ZBASE2, XPu = 0.380651 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {-78, 104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB13B14(BPu = 0, GPu = 0, RPu = 0.325519 / ZBASE2, XPu = 0.662769 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {-4, 104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB1B2(BPu = 5.54505E-4 * ZBASE1, GPu = 0, RPu = 0.922682 / ZBASE1, XPu = 2.81708 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {-106, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB1B5(BPu = 5.167E-4 * ZBASE1, GPu = 0, RPu = 2.57237 / ZBASE1, XPu = 10.6189 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {-64, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB2B3(BPu = 4.599875E-4 * ZBASE1, GPu = 0, RPu = 2.23719 / ZBASE1, XPu = 9.42535 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {-2, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB2B4(BPu = 3.57068E-4 * ZBASE1, GPu = 0, RPu = 2.76662 / ZBASE1, XPu = 8.3946 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {0, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB2B5(BPu = 3.63369E-4 * ZBASE1, GPu = 0, RPu = 2.71139 / ZBASE1, XPu = 8.27843 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {-58, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB3B4(BPu = 1.344255E-4 * ZBASE1, GPu = 0, RPu = 3.19035 / ZBASE1, XPu = 8.14274 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {92, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB4B5(BPu = 0, GPu = 0, RPu = 0.635593 / ZBASE1, XPu = 2.00486 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {12, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB6B11(BPu = 0, GPu = 0, RPu = 0.18088 / ZBASE2, XPu = 0.378785 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {-46, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB6B12(BPu = 0, GPu = 0, RPu = 0.23407 / ZBASE2, XPu = 0.487165 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {-74, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB6B13(BPu = 0, GPu = 0, RPu = 0.125976 / ZBASE2, XPu = 0.248086 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {-60, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB7B8(BPu = 0, GPu = 0, RPu = 0, XPu = 0.33546 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {100, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB7B9(BPu = 0, GPu = 0, RPu = 0, XPu = 0.209503 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {54, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB9B10(BPu = 0, GPu = 0, RPu = 0.060579 / ZBASE2, XPu = 0.160922 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {24, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line LineB9B14(BPu = 0, GPu = 0, RPu = 0.242068 / ZBASE2, XPu = 0.514912 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {38, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio Tfo1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.47994804 / ZBASE2, rTfoPu = 1.0729614) annotation(
    Placement(visible = true, transformation(origin = {-30, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio Tfo2(BPu = 0, GPu = 0, RPu = 0, XPu = 1.0591881 / ZBASE2, rTfoPu = 1.0319917) annotation(
    Placement(visible = true, transformation(origin = {70, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio Tfo3(BPu = 0, GPu = 0, RPu = 0, XPu = 0.39824802 / ZBASE2, rTfoPu = 1.0224948) annotation(
    Placement(visible = true, transformation(origin = {90, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Controls.Basics.SetPoint PrefPu_Load2(Value0 = P0Pu_Load2);
  Electrical.Controls.Basics.SetPoint QrefPu_Load2(Value0 = Q0Pu_Load2);
  Electrical.Controls.Basics.SetPoint PrefPu_Load3(Value0 = P0Pu_Load3);
  Electrical.Controls.Basics.SetPoint QrefPu_Load3(Value0 = Q0Pu_Load3);
  Electrical.Controls.Basics.SetPoint PrefPu_Load4(Value0 = P0Pu_Load4);
  Electrical.Controls.Basics.SetPoint QrefPu_Load4(Value0 = Q0Pu_Load4);
  Electrical.Controls.Basics.SetPoint PrefPu_Load5(Value0 = P0Pu_Load5);
  Electrical.Controls.Basics.SetPoint QrefPu_Load5(Value0 = Q0Pu_Load5);
  Electrical.Controls.Basics.SetPoint PrefPu_Load6(Value0 = P0Pu_Load6);
  Electrical.Controls.Basics.SetPoint QrefPu_Load6(Value0 = Q0Pu_Load6);
  Electrical.Controls.Basics.SetPoint PrefPu_Load9(Value0 = P0Pu_Load9);
  Electrical.Controls.Basics.SetPoint QrefPu_Load9(Value0 = Q0Pu_Load9);
  Electrical.Controls.Basics.SetPoint PrefPu_Load10(Value0 = P0Pu_Load10);
  Electrical.Controls.Basics.SetPoint QrefPu_Load10(Value0 = Q0Pu_Load10);
  Electrical.Controls.Basics.SetPoint PrefPu_Load11(Value0 = P0Pu_Load11);
  Electrical.Controls.Basics.SetPoint QrefPu_Load11(Value0 = Q0Pu_Load11);
  Electrical.Controls.Basics.SetPoint PrefPu_Load12(Value0 = P0Pu_Load12);
  Electrical.Controls.Basics.SetPoint QrefPu_Load12(Value0 = Q0Pu_Load12);
  Electrical.Controls.Basics.SetPoint PrefPu_Load13(Value0 = P0Pu_Load13);
  Electrical.Controls.Basics.SetPoint QrefPu_Load13(Value0 = Q0Pu_Load13);
  Electrical.Controls.Basics.SetPoint PrefPu_Load14(Value0 = P0Pu_Load14);
  Electrical.Controls.Basics.SetPoint QrefPu_Load14(Value0 = Q0Pu_Load14);
  Types.Angle Theta_Bus1;
  Electrical.Shunts.ShuntB Bank9(BPu = 0.099769 * ZBASE2, i0Pu = Complex(-0.0455016, -0.186237), s0Pu = Complex(0, 0.193446), u0Pu = Complex(1.020247, -0.272201)) annotation(
    Placement(visible = true, transformation(origin = {16, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Types.ActivePowerPu P0Pu_Load2 = 0.217000;
  parameter Types.ReactivePowerPu Q0Pu_Load2 = 0.127000;
  parameter Types.ActivePowerPu P0Pu_Load3 = 0.942000;
  parameter Types.ReactivePowerPu Q0Pu_Load3 = 0.190000;
  parameter Types.ActivePowerPu P0Pu_Load4 = 0.478000;
  parameter Types.ReactivePowerPu Q0Pu_Load4 = -0.039000;
  parameter Types.ActivePowerPu P0Pu_Load5 = 0.076000;
  parameter Types.ReactivePowerPu Q0Pu_Load5 = 0.016000;
  parameter Types.ActivePowerPu P0Pu_Load6 = 0.112000;
  parameter Types.ReactivePowerPu Q0Pu_Load6 = 0.075000;
  parameter Types.ActivePowerPu P0Pu_Load9 = 0.295000;
  parameter Types.ReactivePowerPu Q0Pu_Load9 = 0.166000;
  parameter Types.ActivePowerPu P0Pu_Load10 = 0.090000;
  parameter Types.ReactivePowerPu Q0Pu_Load10 = 0.058000;
  parameter Types.ActivePowerPu P0Pu_Load11 = 0.035000;
  parameter Types.ReactivePowerPu Q0Pu_Load11 = 0.018000;
  parameter Types.ActivePowerPu P0Pu_Load12 = 0.061000;
  parameter Types.ReactivePowerPu Q0Pu_Load12 = 0.016000;
  parameter Types.ActivePowerPu P0Pu_Load13 = 0.135000;
  parameter Types.ReactivePowerPu Q0Pu_Load13 = 0.058000;
  parameter Types.ActivePowerPu P0Pu_Load14 = 0.149000;
  parameter Types.ReactivePowerPu Q0Pu_Load14 = 0.050000;
  final parameter SIunits.Impedance ZBASE1 = 69 ^ 2 / Electrical.SystemBase.SnRef;
  final parameter SIunits.Impedance ZBASE2 = 13.8 ^ 2 / Electrical.SystemBase.SnRef;

equation
//ModelSignalN
  ModelSignalN.thetaRef = Theta_Bus1;
  Theta_Bus1 = Modelica.ComplexMath.arg(Bus1.terminal.V);
//Generators
  Gen1.N = ModelSignalN.N;
  Gen2.N = ModelSignalN.N;
  Gen3.N = ModelSignalN.N;
  Gen6.N = ModelSignalN.N;
  Gen8.N = ModelSignalN.N;
  Gen1.URefPu = Gen1.URef0Pu;
  Gen1.PRefPu = Gen1.PRef0Pu;
  Gen1.switchOffSignal1.value = false;
  Gen1.switchOffSignal2.value = false;
  Gen1.switchOffSignal3.value = false;
  Gen2.URefPu = Gen2.URef0Pu;
  Gen2.PRefPu = Gen2.PRef0Pu;
  Gen2.switchOffSignal1.value = false;
  Gen2.switchOffSignal2.value = false;
  Gen2.switchOffSignal3.value = false;
  Gen3.URefPu = Gen3.URef0Pu;
  Gen3.PRefPu = Gen3.PRef0Pu;
  Gen3.switchOffSignal1.value = false;
  Gen3.switchOffSignal2.value = false;
  Gen3.switchOffSignal3.value = false;
  Gen6.URefPu = Gen6.URef0Pu;
  Gen6.PRefPu = Gen6.PRef0Pu;
  Gen6.switchOffSignal1.value = false;
  Gen6.switchOffSignal2.value = false;
  Gen6.switchOffSignal3.value = false;
  Gen8.URefPu = Gen8.URef0Pu;
  Gen8.PRefPu = Gen8.PRef0Pu;
  Gen8.switchOffSignal1.value = false;
  Gen8.switchOffSignal2.value = false;
  Gen8.switchOffSignal3.value = false;
//Loads
  Load2.PRefPu = PrefPu_Load2.setPoint.value;
  Load2.QRefPu = QrefPu_Load2.setPoint.value;
  Load3.PRefPu = PrefPu_Load3.setPoint.value;
  Load3.QRefPu = QrefPu_Load3.setPoint.value;
  Load4.PRefPu = PrefPu_Load4.setPoint.value;
  Load4.QRefPu = QrefPu_Load4.setPoint.value;
  Load5.PRefPu = PrefPu_Load5.setPoint.value;
  Load5.QRefPu = QrefPu_Load5.setPoint.value;
  Load6.PRefPu = PrefPu_Load6.setPoint.value;
  Load6.QRefPu = QrefPu_Load6.setPoint.value;
  Load9.PRefPu = PrefPu_Load9.setPoint.value;
  Load9.QRefPu = QrefPu_Load9.setPoint.value;
  Load10.PRefPu = PrefPu_Load10.setPoint.value;
  Load10.QRefPu = QrefPu_Load10.setPoint.value;
  Load11.PRefPu = PrefPu_Load11.setPoint.value;
  Load11.QRefPu = QrefPu_Load11.setPoint.value;
  Load12.PRefPu = PrefPu_Load12.setPoint.value;
  Load12.QRefPu = QrefPu_Load12.setPoint.value;
  Load13.PRefPu = PrefPu_Load13.setPoint.value;
  Load13.QRefPu = QrefPu_Load13.setPoint.value;
  Load14.PRefPu = PrefPu_Load14.setPoint.value;
  Load14.QRefPu = QrefPu_Load14.setPoint.value;
  Load2.deltaP = 0;
  Load2.deltaQ = 0;
  Load3.deltaP = 0;
  Load3.deltaQ = 0;
  Load4.deltaP = 0;
  Load4.deltaQ = 0;
  Load5.deltaP = 0;
  Load5.deltaQ = 0;
  Load6.deltaP = 0;
  Load6.deltaQ = 0;
  Load9.deltaP = 0;
  Load9.deltaQ = 0;
  Load10.deltaP = 0;
  Load10.deltaQ = 0;
  Load11.deltaP = 0;
  Load11.deltaQ = 0;
  Load12.deltaP = 0;
  Load12.deltaQ = 0;
  Load13.deltaP = 0;
  Load13.deltaQ = 0;
  Load14.deltaP = 0;
  Load14.deltaQ = 0;
  Load2.switchOffSignal1.value = false;
  Load2.switchOffSignal2.value = false;
  Load3.switchOffSignal1.value = false;
  Load3.switchOffSignal2.value = false;
  Load4.switchOffSignal1.value = false;
  Load4.switchOffSignal2.value = false;
  Load5.switchOffSignal1.value = false;
  Load5.switchOffSignal2.value = false;
  Load6.switchOffSignal1.value = false;
  Load6.switchOffSignal2.value = false;
  Load9.switchOffSignal1.value = false;
  Load9.switchOffSignal2.value = false;
  Load10.switchOffSignal1.value = false;
  Load10.switchOffSignal2.value = false;
  Load11.switchOffSignal1.value = false;
  Load11.switchOffSignal2.value = false;
  Load12.switchOffSignal1.value = false;
  Load12.switchOffSignal2.value = false;
  Load13.switchOffSignal1.value = false;
  Load13.switchOffSignal2.value = false;
  Load14.switchOffSignal1.value = false;
  Load14.switchOffSignal2.value = false;
//Lines
  LineB10B11.switchOffSignal1.value = false;
  LineB10B11.switchOffSignal2.value = false;
  LineB12B13.switchOffSignal1.value = false;
  LineB12B13.switchOffSignal2.value = false;
  LineB13B14.switchOffSignal1.value = false;
  LineB13B14.switchOffSignal2.value = false;
  LineB1B5.switchOffSignal1.value = false;
  LineB1B5.switchOffSignal2.value = false;
  LineB1B2.switchOffSignal1.value = false;
  LineB1B2.switchOffSignal2.value = false;
  LineB2B3.switchOffSignal1.value = false;
  LineB2B3.switchOffSignal2.value = false;
  LineB2B4.switchOffSignal1.value = false;
  LineB2B4.switchOffSignal2.value = false;
  LineB2B5.switchOffSignal1.value = false;
  LineB2B5.switchOffSignal2.value = false;
  LineB3B4.switchOffSignal1.value = false;
  LineB3B4.switchOffSignal2.value = false;
  LineB4B5.switchOffSignal1.value = false;
  LineB4B5.switchOffSignal2.value = false;
  LineB6B11.switchOffSignal1.value = false;
  LineB6B11.switchOffSignal2.value = false;
  LineB6B12.switchOffSignal1.value = false;
  LineB6B12.switchOffSignal2.value = false;
  LineB6B13.switchOffSignal1.value = false;
  LineB6B13.switchOffSignal2.value = false;
  LineB7B8.switchOffSignal1.value = false;
  LineB7B8.switchOffSignal2.value = false;
  LineB7B9.switchOffSignal1.value = false;
  LineB7B9.switchOffSignal2.value = false;
  LineB9B10.switchOffSignal1.value = false;
  LineB9B10.switchOffSignal2.value = false;
  LineB9B14.switchOffSignal1.value = false;
  LineB9B14.switchOffSignal2.value = false;
//Transformers
  Tfo1.switchOffSignal1.value = false;
  Tfo1.switchOffSignal2.value = false;
  Tfo2.switchOffSignal1.value = false;
  Tfo2.switchOffSignal2.value = false;
  Tfo3.switchOffSignal1.value = false;
  Tfo3.switchOffSignal2.value = false;
//Shunt
  Bank9.switchOffSignal1.value = false;
  Bank9.switchOffSignal2.value = false;
  connect(Bus10.terminal, Load10.terminal) annotation(
    Line(points = {{22, 48}, {22, 38}}, color = {0, 0, 255}));
  connect(Bus11.terminal, Load11.terminal) annotation(
    Line(points = {{-12, 56}, {-11, 56}, {-11, 46}, {-12, 46}}, color = {0, 0, 255}));
  connect(Bus12.terminal, Load12.terminal) annotation(
    Line(points = {{-88, 78}, {-88, 70}}, color = {0, 0, 255}));
  connect(Bus13.terminal, Load13.terminal) annotation(
    Line(points = {{-32, 92}, {-32, 84}}, color = {0, 0, 255}));
  connect(Bus14.terminal, Load14.terminal) annotation(
    Line(points = {{24, 86}, {24, 78}}, color = {0, 0, 255}));
  connect(Bus2.terminal, Load2.terminal) annotation(
    Line(points = {{-86, -98}, {-86, -110}}, color = {0, 0, 255}));
  connect(Bus3.terminal, Load3.terminal) annotation(
    Line(points = {{102, -126}, {102, -136}}, color = {0, 0, 255}));
  connect(Bus4.terminal, Load4.terminal) annotation(
    Line(points = {{70, -78}, {70, -88}}, color = {0, 0, 255}));
  connect(Load5.terminal, Bus5.terminal) annotation(
    Line(points = {{-30, -76}, {-30, -60}}, color = {0, 0, 255}));
  connect(Bus6.terminal, Load6.terminal) annotation(
    Line(points = {{-30, 12}, {-30, 9}, {-42, 9}, {-42, 4}}, color = {0, 0, 255}));
  connect(Bus9.terminal, Load9.terminal) annotation(
    Line(points = {{38, 10}, {38, 2}}, color = {0, 0, 255}));
  connect(Gen1.terminal, Bus1.terminal) annotation(
    Line(points = {{-116, -76}, {-116, -94}}, color = {0, 0, 255}));
  connect(Gen2.terminal, Bus2.terminal) annotation(
    Line(points = {{-86, -82}, {-86, -98}}, color = {0, 0, 255}));
  connect(Gen3.terminal, Bus3.terminal) annotation(
    Line(points = {{102, -108}, {102, -126}}, color = {0, 0, 255}));
  connect(Gen6.terminal, Bus6.terminal) annotation(
    Line(points = {{-30, 38}, {-30, 12}}, color = {0, 0, 255}));
  connect(Bus8.terminal, Gen8.terminal) annotation(
    Line(points = {{110, 42}, {110, 58}}, color = {0, 0, 255}));
  connect(LineB1B5.terminal1, Bus1.terminal) annotation(
    Line(points = {{-74, -60}, {-116, -60}, {-116, -94}}, color = {0, 0, 255}));
  connect(LineB1B5.terminal2, Bus5.terminal) annotation(
    Line(points = {{-54, -60}, {-30, -60}}, color = {0, 0, 255}));
  connect(LineB1B2.terminal1, Bus1.terminal) annotation(
    Line(points = {{-116, -106}, {-116, -94}}, color = {0, 0, 255}));
  connect(LineB1B2.terminal2, Bus2.terminal) annotation(
    Line(points = {{-96, -106}, {-86, -106}, {-86, -98}}, color = {0, 0, 255}));
  connect(LineB12B13.terminal1, Bus12.terminal) annotation(
    Line(points = {{-88, 104}, {-88, 78}}, color = {0, 0, 255}));
  connect(LineB12B13.terminal2, Bus13.terminal) annotation(
    Line(points = {{-68, 104}, {-32, 104}, {-32, 92}}, color = {0, 0, 255}));
  connect(LineB13B14.terminal1, Bus13.terminal) annotation(
    Line(points = {{-14, 104}, {-32, 104}, {-32, 92}}, color = {0, 0, 255}));
  connect(LineB13B14.terminal2, Bus14.terminal) annotation(
    Line(points = {{6, 104}, {24, 104}, {24, 86}}, color = {0, 0, 255}));
  connect(LineB10B11.terminal1, Bus11.terminal) annotation(
    Line(points = {{2, 58}, {-12, 58}, {-12, 56}}, color = {0, 0, 255}));
  connect(LineB10B11.terminal2, Bus10.terminal) annotation(
    Line(points = {{22, 58}, {22, 48}}, color = {0, 0, 255}));
  connect(LineB2B3.terminal1, Bus2.terminal) annotation(
    Line(points = {{-12, -106}, {-86, -106}, {-86, -98}}, color = {0, 0, 255}));
  connect(LineB2B3.terminal2, Bus3.terminal) annotation(
    Line(points = {{8, -106}, {102, -106}, {102, -126}}, color = {0, 0, 255}));
  connect(LineB2B4.terminal1, Bus2.terminal) annotation(
    Line(points = {{-10, -90}, {-86, -90}, {-86, -98}}, color = {0, 0, 255}));
  connect(LineB2B4.terminal2, Bus4.terminal) annotation(
    Line(points = {{10, -90}, {22, -90}, {22, -78}, {70, -78}}, color = {0, 0, 255}));
  connect(LineB2B5.terminal1, Bus2.terminal) annotation(
    Line(points = {{-68, -74}, {-86, -74}, {-86, -98}}, color = {0, 0, 255}));
  connect(LineB2B5.terminal2, Bus5.terminal) annotation(
    Line(points = {{-48, -74}, {-30, -74}, {-30, -60}}, color = {0, 0, 255}));
  connect(LineB3B4.terminal1, Bus4.terminal) annotation(
    Line(points = {{82, -90}, {70, -90}, {70, -78}}, color = {0, 0, 255}));
  connect(LineB3B4.terminal2, Bus3.terminal) annotation(
    Line(points = {{102, -90}, {102, -126}}, color = {0, 0, 255}));
  connect(LineB4B5.terminal1, Bus5.terminal) annotation(
    Line(points = {{2, -60}, {-30, -60}}, color = {0, 0, 255}));
  connect(LineB4B5.terminal2, Bus4.terminal) annotation(
    Line(points = {{22, -60}, {70, -60}, {70, -78}}, color = {0, 0, 255}));
  connect(LineB6B11.terminal1, Bus6.terminal) annotation(
    Line(points = {{-56, 56}, {-60, 56}, {-60, 12}, {-30, 12}}, color = {0, 0, 255}));
  connect(LineB6B11.terminal2, Bus11.terminal) annotation(
    Line(points = {{-36, 56}, {-12, 56}}, color = {0, 0, 255}));
  connect(LineB6B12.terminal1, Bus12.terminal) annotation(
    Line(points = {{-84, 12}, {-88, 12}, {-88, 78}}, color = {0, 0, 255}));
  connect(LineB6B12.terminal2, Bus6.terminal) annotation(
    Line(points = {{-64, 12}, {-30, 12}}, color = {0, 0, 255}));
  connect(LineB6B13.terminal1, Bus13.terminal) annotation(
    Line(points = {{-70, 30}, {-70, 92}, {-32, 92}}, color = {0, 0, 255}));
  connect(LineB6B13.terminal2, Bus6.terminal) annotation(
    Line(points = {{-50, 30}, {-30, 30}, {-30, 12}}, color = {0, 0, 255}));
  connect(LineB7B8.terminal1, Bus7.terminal) annotation(
    Line(points = {{90, 16}, {90, 2}}, color = {0, 0, 255}));
  connect(LineB7B8.terminal2, Bus8.terminal) annotation(
    Line(points = {{110, 16}, {110, 42}}, color = {0, 0, 255}));
  connect(LineB7B9.terminal2, Bus7.terminal) annotation(
    Line(points = {{64, 24}, {72, 24}, {72, 2}, {90, 2}}, color = {0, 0, 255}));
  connect(LineB7B9.terminal1, Bus9.terminal) annotation(
    Line(points = {{44, 24}, {38, 24}, {38, 10}}, color = {0, 0, 255}));
  connect(LineB9B10.terminal2, Bus9.terminal) annotation(
    Line(points = {{34, 18}, {38, 18}, {38, 10}}, color = {0, 0, 255}));
  connect(LineB9B10.terminal1, Bus10.terminal) annotation(
    Line(points = {{14, 18}, {12, 18}, {12, 48}, {22, 48}}, color = {0, 0, 255}));
  connect(LineB9B14.terminal1, Bus14.terminal) annotation(
    Line(points = {{28, 56}, {28, 71}, {24, 71}, {24, 86}}, color = {0, 0, 255}));
  connect(LineB9B14.terminal2, Bus9.terminal) annotation(
    Line(points = {{48, 56}, {48, 31}, {38, 31}, {38, 10}}, color = {0, 0, 255}));
  connect(Tfo1.terminal1, Bus5.terminal) annotation(
    Line(points = {{-30, -46}, {-30, -60}}, color = {0, 0, 255}));
  connect(Tfo1.terminal2, Bus6.terminal) annotation(
    Line(points = {{-30, -26}, {-30, 12}}, color = {0, 0, 255}));
  connect(Tfo2.terminal1, Bus4.terminal) annotation(
    Line(points = {{70, -48}, {70, -78}}, color = {0, 0, 255}));
  connect(Tfo2.terminal2, Bus9.terminal) annotation(
    Line(points = {{70, -28}, {70, 10}, {38, 10}}, color = {0, 0, 255}));
  connect(Tfo3.terminal1, Bus4.terminal) annotation(
    Line(points = {{90, -48}, {70, -48}, {70, -78}}, color = {0, 0, 255}));
  connect(Tfo3.terminal2, Bus7.terminal) annotation(
    Line(points = {{90, -28}, {90, 2}}, color = {0, 0, 255}));
  connect(Bank9.terminal, Bus9.terminal) annotation(
    Line(points = {{16, 2}, {16, 10}, {38, 10}}, color = {0, 0, 255}));

  annotation(
    experiment(StartTime = 0, StopTime = 2000, Tolerance = 1e-06, Interval = 10),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(ls = "klu", lv = "LOG_STATS", nls = "kinsol", s = "euler"),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})));
end IEEE14;
