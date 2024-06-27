within Dynawo.Examples.Nordic.TestCases;

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

model TestCaseB "Nordic test system case with variable reference frequency (operating point B)"
  extends Dynawo.Examples.Nordic.Grid.FullDynamicModel(
    Alpha = 1,
    Beta = 2,
    P0Pu_g01 = -6,
    P0Pu_g02 = -3,
    P0Pu_g03 = -5.5,
    P0Pu_g04 = -4,
    P0Pu_g05 = -2,
    P0Pu_g06 = -3.6,
    P0Pu_g07 = -1.8,
    P0Pu_g08 = -7.5,
    P0Pu_g09 = -6.685,
    P0Pu_g10 = -6,
    P0Pu_g11 = -2.5,
    P0Pu_g12 = -3.1,
    P0Pu_g13 = 0,
    P0Pu_g14 = -6.3,
    P0Pu_g15 = -5.4,
    P0Pu_g16 = -6,
    P0Pu_g17 = -5.3,
    P0Pu_g18 = -5.3,
    P0Pu_g19 = -3,
    P0Pu_g20 = -13.7212,
    Q0Pu_g01 = 0.214541,
    Q0Pu_g02 = 0.201235,
    Q0Pu_g03 = 0.0919925,
    Q0Pu_g04 = 0.167163,
    Q0Pu_g05 = 0.286655,
    Q0Pu_g06 = -0.873456,
    Q0Pu_g07 = 0.164872,
    Q0Pu_g08 = -1.25314,
    Q0Pu_g09 = -0.343686,
    Q0Pu_g10 = -1.51521,
    Q0Pu_g11 = 0.785776,
    Q0Pu_g12 = 0.619594,
    Q0Pu_g13 = 1.29607,
    Q0Pu_g14 = -0.179147,
    Q0Pu_g15 = -0.541578,
    Q0Pu_g16 = -0.46293,
    Q0Pu_g17 = 0.423894,
    Q0Pu_g18 = -1.14446,
    Q0Pu_g19 = -1.17074,
    Q0Pu_g20 = -3.7625,
    U0Pu_g01 = 1.0684,
    U0Pu_g02 = 1.0565,
    U0Pu_g03 = 1.0595,
    U0Pu_g04 = 1.0339,
    U0Pu_g05 = 1.0294,
    U0Pu_g06 = 1.0084,
    U0Pu_g07 = 1.0141,
    U0Pu_g08 = 1.0498,
    U0Pu_g09 = 0.9988,
    U0Pu_g10 = 1.0157,
    U0Pu_g11 = 1.0211,
    U0Pu_g12 = 1.02,
    U0Pu_g13 = 1.017,
    U0Pu_g14 = 1.0454,
    U0Pu_g15 = 1.0455,
    U0Pu_g16 = 1.0531,
    U0Pu_g17 = 1.0092,
    U0Pu_g18 = 1.0307,
    U0Pu_g19 = 1.03,
    U0Pu_g20 = 1.0185,
    UPhase0_g01 = 0.336643,
    UPhase0_g02 = 0.384343,
    UPhase0_g03 = 0.472637,
    UPhase0_g04 = 0.516555,
    UPhase0_g05 = 0.172967,
    UPhase0_g06 = -0.362506,
    UPhase0_g07 = -0.521655,
    UPhase0_g08 = 0.205781,
    UPhase0_g09 = 0.269663,
    UPhase0_g10 = 0.308828,
    UPhase0_g11 = -0.0217134,
    UPhase0_g12 = -0.0468905,
    UPhase0_g13 = -0.356323,
    UPhase0_g14 = -0.262466,
    UPhase0_g15 = -0.339711,
    UPhase0_g16 = -0.318706,
    UPhase0_g17 = -0.183065,
    UPhase0_g18 = -0.185583,
    UPhase0_g19 = 0.129835,
    UPhase0_g20 = 0,
    P0Pu_load_01 = 6,
    P0Pu_load_02 = 3.3,
    P0Pu_load_03 = 2.6,
    P0Pu_load_04 = 8.4,
    P0Pu_load_05 = 7.2,
    P0Pu_load_11 = 2,
    P0Pu_load_12 = 3,
    P0Pu_load_13 = 1,
    P0Pu_load_22 = 2.8,
    P0Pu_load_31 = 1,
    P0Pu_load_32 = 2,
    P0Pu_load_41 = 5.4,
    P0Pu_load_42 = 4,
    P0Pu_load_43 = 9,
    P0Pu_load_46 = 7,
    P0Pu_load_47 = 1,
    P0Pu_load_51 = 8,
    P0Pu_load_61 = 5,
    P0Pu_load_62 = 3,
    P0Pu_load_63 = 5.9,
    P0Pu_load_71 = 3,
    P0Pu_load_72 = 20,
    Q0Pu_load_01 = 1.482,
    Q0Pu_load_02 = 0.71,
    Q0Pu_load_03 = 0.838,
    Q0Pu_load_04 = 2.52,
    Q0Pu_load_05 = 1.904,
    Q0Pu_load_11 = 0.688,
    Q0Pu_load_12 = 0.838,
    Q0Pu_load_13 = 0.344,
    Q0Pu_load_22 = 0.799,
    Q0Pu_load_31 = 0.247,
    Q0Pu_load_32 = 0.396,
    Q0Pu_load_41 = 1.314,
    Q0Pu_load_42 = 1.274,
    Q0Pu_load_43 = 2.546,
    Q0Pu_load_46 = 2.118,
    Q0Pu_load_47 = 0.44,
    Q0Pu_load_51 = 2.582,
    Q0Pu_load_61 = 1.225,
    Q0Pu_load_62 = 0.838,
    Q0Pu_load_63 = 2.646,
    Q0Pu_load_71 = 0.838,
    Q0Pu_load_72 = 3.961,
    U0Pu_load_01 = 1.06737,
    U0Pu_load_02 = 1.02132,
    U0Pu_load_03 = 1.05732,
    U0Pu_load_04 = 1.06525,
    U0Pu_load_05 = 1.05604,
    U0Pu_load_11 = 1.02656,
    U0Pu_load_12 = 1.01102,
    U0Pu_load_13 = 1.00439,
    U0Pu_load_22 = 1.04802,
    U0Pu_load_31 = 1.06499,
    U0Pu_load_32 = 1.01573,
    U0Pu_load_41 = 1.05711,
    U0Pu_load_42 = 1.05392,
    U0Pu_load_43 = 1.05698,
    U0Pu_load_46 = 1.04759,
    U0Pu_load_47 = 1.02852,
    U0Pu_load_51 = 1.03408,
    U0Pu_load_61 = 1.03162,
    U0Pu_load_62 = 1.0232,
    U0Pu_load_63 = 1.01538,
    U0Pu_load_71 = 1.00401,
    U0Pu_load_72 = 0.995994,
    UPhase0_load_01 = -0.765732,
    UPhase0_load_02 = -0.550923,
    UPhase0_load_03 = -0.700355,
    UPhase0_load_04 = -0.56785,
    UPhase0_load_05 = -0.592483,
    UPhase0_load_11 = 0.136882,
    UPhase0_load_12 = 0.190527,
    UPhase0_load_13 = 0.268856,
    UPhase0_load_22 = 0.0170809,
    UPhase0_load_31 = -0.171041,
    UPhase0_load_32 = 0.03587,
    UPhase0_load_41 = -0.400555,
    UPhase0_load_42 = -0.43015,
    UPhase0_load_43 = -0.511574,
    UPhase0_load_46 = -0.521113,
    UPhase0_load_47 = -0.448037,
    UPhase0_load_51 = -0.481187,
    UPhase0_load_61 = -0.430086,
    UPhase0_load_62 = -0.35821,
    UPhase0_load_63 = -0.296141,
    UPhase0_load_71 = -0.00656391,
    UPhase0_load_72 = -0.0944643,
    BPu_shunt_1022 = -0.5,
    BPu_shunt_1041 = -2.5,
    BPu_shunt_1043 = -2,
    BPu_shunt_1044 = -2,
    BPu_shunt_1045 = -2,
    BPu_shunt_4012 = 1,
    BPu_shunt_4041 = -2,
    BPu_shunt_4043 = -2,
    BPu_shunt_4046 = -1,
    BPu_shunt_4051 = -1,
    BPu_shunt_4071 = 4,
    U0Pu_shunt_1022 = 1.10521,
    U0Pu_shunt_1041 = 1.07995,
    U0Pu_shunt_1043 = 1.08664,
    U0Pu_shunt_1044 = 1.07035,
    U0Pu_shunt_1045 = 1.07003,
    U0Pu_shunt_4012 = 1.04362,
    U0Pu_shunt_4041 = 1.11245,
    U0Pu_shunt_4043 = 1.09283,
    U0Pu_shunt_4046 = 1.08437,
    U0Pu_shunt_4051 = 1.10334,
    U0Pu_shunt_4071 = 1.04971,
    UPhase0_shunt_1022 = 0.06199,
    UPhase0_shunt_1041 = -0.722343,
    UPhase0_shunt_1043 = -0.650647,
    UPhase0_shunt_1044 = -0.52225,
    UPhase0_shunt_1045 = -0.546955,
    UPhase0_shunt_4012 = 0.197157,
    UPhase0_shunt_4041 = -0.356323,
    UPhase0_shunt_4043 = -0.467408,
    UPhase0_shunt_4046 = -0.476203,
    UPhase0_shunt_4051 = -0.435156,
    UPhase0_shunt_4071 = 0.0423206,
    g15.gen = Dynawo.Examples.Nordic.Components.GeneratorWithControl.GeneratorParameters.genFramePreset.g15b,
    g18.gen = Dynawo.Examples.Nordic.Components.GeneratorWithControl.GeneratorParameters.genFramePreset.g18b);
  extends Icons.Example;

  Dynawo.Electrical.Buses.Bus bus_BG15b annotation(
    Placement(visible = true, transformation(origin = {80, -130}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_BG16b annotation(
    Placement(visible = true, transformation(origin = {5, -145}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_BG18b annotation(
    Placement(visible = true, transformation(origin = {-60, -130}, extent = {{-5, 5}, {5, -5}}, rotation = -90)));

  Dynawo.Electrical.Transformers.TransformerFixedRatio trafo_g15b_4047(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 600.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {80, -120}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio trafo_g16b_4051(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 700.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {5, -137}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio trafo_g18b_4063(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 600.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-70, -130}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));

  Dynawo.Examples.Nordic.Components.GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g15b(P0Pu = P0Pu_g15, Q0Pu = -0.523179, U0Pu = U0Pu_g15, UPhase0 = -0.277412, gen = Dynawo.Examples.Nordic.Components.GeneratorWithControl.GeneratorParameters.genFramePreset.g15b) annotation(
    Placement(visible = true, transformation(origin = {5, -151}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Dynawo.Examples.Nordic.Components.GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g16b(P0Pu = P0Pu_g16, Q0Pu = Q0Pu_g16, U0Pu = U0Pu_g16, UPhase0 = UPhase0_g16, gen = Dynawo.Examples.Nordic.Components.GeneratorWithControl.GeneratorParameters.genFramePreset.g16) annotation(
    Placement(visible = true, transformation(origin = {5, -151}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Dynawo.Examples.Nordic.Components.GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g18b(P0Pu = P0Pu_g18, Q0Pu = -0.82426, U0Pu = U0Pu_g18, UPhase0 = -0.1222, gen = Dynawo.Examples.Nordic.Components.GeneratorWithControl.GeneratorParameters.genFramePreset.g18b) annotation(
    Placement(visible = true, transformation(origin = {5, -151}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));

equation
  trafo_g15b_4047.switchOffSignal1.value = false;
  trafo_g15b_4047.switchOffSignal2.value = false;
  trafo_g16b_4051.switchOffSignal1.value = false;
  trafo_g16b_4051.switchOffSignal2.value = false;
  trafo_g18b_4063.switchOffSignal1.value = false;
  trafo_g18b_4063.switchOffSignal2.value = false;

  connect(trafo_g15b_4047.terminal1, bus_BG15b.terminal) annotation(
    Line(points = {{80, -125}, {80, -130}}, color = {0, 0, 255}));
  connect(trafo_g15b_4047.terminal2, bus_4047.terminal) annotation(
    Line(points = {{80, -115}, {80, -110}, {70, -110}}, color = {0, 0, 255}));
  connect(trafo_g16b_4051.terminal1, bus_BG16b.terminal) annotation(
    Line(points = {{5, -142}, {5, -145}}, color = {0, 0, 255}));
  connect(trafo_g16b_4051.terminal2, bus_4051.terminal) annotation(
    Line(points = {{5, -132}, {5, -130}, {14, -130}}, color = {0, 0, 255}));
  connect(trafo_g18b_4063.terminal1, bus_BG18b.terminal) annotation(
    Line(points = {{-65, -130}, {-60, -130}}, color = {0, 0, 255}));
  connect(trafo_g18b_4063.terminal2, bus_4063.terminal) annotation(
    Line(points = {{-75, -130}, {-87, -130}}, color = {0, 0, 255}));
  connect(g15b.terminal, bus_BG15b.terminal) annotation(
    Line(points = {{80, -140}, {80, -130}}, color = {0, 0, 255}));
  connect(g16b.terminal, bus_BG16b.terminal) annotation(
    Line(points = {{5, -151}, {5, -145}}, color = {0, 0, 255}));
  connect(g18b.terminal, bus_BG18b.terminal) annotation(
    Line(points = {{-56, -130}, {-60, -130}}, color = {0, 0, 255}));

  omegaCOI = (omegaCOINum +
              g15b.generatorSynchronous.omegaPu.value * g15b.generatorSynchronous.H * g15b.generatorSynchronous.SNom +
              g16b.generatorSynchronous.omegaPu.value * g16b.generatorSynchronous.H * g16b.generatorSynchronous.SNom +
              g18b.generatorSynchronous.omegaPu.value * g18b.generatorSynchronous.H * g18b.generatorSynchronous.SNom
              ) / (
              omegaCOIDen +
              g15b.generatorSynchronous.H * g15b.generatorSynchronous.SNom +
              g16b.generatorSynchronous.H * g16b.generatorSynchronous.SNom +
              g18b.generatorSynchronous.H * g18b.generatorSynchronous.SNom);

  g15b.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g16b.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g18b.generatorSynchronous.omegaRefPu.value = omegaCOI;

  annotation(
    preferredView = "diagram",
    experiment(StartTime = -300, StopTime = 200, Tolerance = 0.005, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,nonewInst -d=initialization, -d=aliasConflicts, --maxSizeLinearTearing=1040, --maxSizeNonlinearTearing=1040 -d=nonewInst -d= -d=aliasConflicts, --maxSizeLinearTearing=1040, --maxSizeNonlinearTearing=1040 --daemode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "euler", lssMaxDensity = "0.1"),
    Documentation(info = "<html><head></head><body><span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">This test case is meant to investigate the long term dynamic response of the Nordic 32 test system, operating point B, regarding a contingency. This particular test case corresponds to the setup presented in Chapter 3.1 of the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.<br></span><div><font face=\"MS Shell Dlg 2\"><br></font><div><font face=\"MS Shell Dlg 2\">OmegaRef of the generators is set to the center of inertia of the whole system.</font></div><div><font face=\"MS Shell Dlg 2\"><br></font></div><div><font face=\"MS Shell Dlg 2\">The simulation runs in DAEmode, starts at t = -300 s (thus allowing the variables to settle), ends at t = 200 s and uses the euler solver with a step size of 0.01 s and a tolerance of 0.005.</font></div><div><font face=\"MS Shell Dlg 2\"><br></font><div><font face=\"MS Shell Dlg 2\">At t = 1 s, a node fault occurs at bus 4032, which is cleared by tripping line 4032-4044&nbsp;</font><span style=\"font-family: 'MS Shell Dlg 2';\">after 0.1 s</span>.</div><br style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">A generator g16b, identical to g16, has been added to the system of operating point A. The associated transformer and bus have also been added.</span><div><br></div><div><div style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">In contrast to operating point A, the voltages stabilize after the fault is cleared, thus avoiding a simulation crash.</div></div></div></div></body></html>"));
end TestCaseB;
