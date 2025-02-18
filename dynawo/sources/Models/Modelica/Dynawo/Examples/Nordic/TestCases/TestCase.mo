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

model TestCase "Nordic test system case with variable reference frequency"
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
    P0Pu_g15 = -10.8,
    P0Pu_g16 = -6,
    P0Pu_g17 = -5.3,
    P0Pu_g18 = -10.6,
    P0Pu_g19 = -3,
    P0Pu_g20 = -21.374,
    Q0Pu_g01 = -0.583425,
    Q0Pu_g02 = -0.172375,
    Q0Pu_g03 = -0.209155,
    Q0Pu_g04 = -0.303899,
    Q0Pu_g05 = -0.600891,
    Q0Pu_g06 = -1.38571,
    Q0Pu_g07 = -0.604206,
    Q0Pu_g08 = -2.32593,
    Q0Pu_g09 = -2.01277,
    Q0Pu_g10 = -2.55704,
    Q0Pu_g11 = -0.607278,
    Q0Pu_g12 = -0.983402,
    Q0Pu_g13 = -0.501215,
    Q0Pu_g14 = -2.95855,
    Q0Pu_g15 = -3.77906,
    Q0Pu_g16 = -2.22625,
    Q0Pu_g17 = -0.487272,
    Q0Pu_g18 = -2.93429,
    Q0Pu_g19 = -1.21237,
    Q0Pu_g20 = -3.77386,
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
    UPhase0_g01 = 0.0451188,
    UPhase0_g02 = 0.0892973,
    UPhase0_g03 = 0.179322,
    UPhase0_g04 = 0.140101,
    UPhase0_g05 = -0.215702,
    UPhase0_g06 = -1.03707,
    UPhase0_g07 = -1.20347,
    UPhase0_g08 = -0.29347,
    UPhase0_g09 = -0.0284215,
    UPhase0_g10 = 0.0172384,
    UPhase0_g11 = -0.506861,
    UPhase0_g12 = -0.556425,
    UPhase0_g13 = -0.94764,
    UPhase0_g14 = -0.87093,
    UPhase0_g15 = -0.910925,
    UPhase0_g16 = -1.1188,
    UPhase0_g17 = -0.81777,
    UPhase0_g18 = -0.756141,
    UPhase0_g19 = 0.000481668,
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
    U0Pu_load_01 = 0.998799,
    U0Pu_load_02 = 1.00119,
    U0Pu_load_03 = 0.997421,
    U0Pu_load_04 = 0.999641,
    U0Pu_load_05 = 0.99608,
    U0Pu_load_11 = 1.00257,
    U0Pu_load_12 = 0.997507,
    U0Pu_load_13 = 0.995725,
    U0Pu_load_22 = 0.995227,
    U0Pu_load_31 = 1.00419,
    U0Pu_load_32 = 0.997758,
    U0Pu_load_41 = 0.99674,
    U0Pu_load_42 = 0.995223,
    U0Pu_load_43 = 1.00129,
    U0Pu_load_46 = 0.999032,
    U0Pu_load_47 = 0.994963,
    U0Pu_load_51 = 0.997757,
    U0Pu_load_61 = 0.994882,
    U0Pu_load_62 = 1.00021,
    U0Pu_load_63 = 0.9992,
    U0Pu_load_71 = 1.00276,
    U0Pu_load_72 = 0.997403,
    UPhase0_load_01 = -1.47841,
    UPhase0_load_02 = -1.23025,
    UPhase0_load_03 = -1.39567,
    UPhase0_load_04 = -1.23344,
    UPhase0_load_05 = -1.30184,
    UPhase0_load_11 = -0.164888,
    UPhase0_load_12 = -0.103579,
    UPhase0_load_13 = -0.0275835,
    UPhase0_load_22 = -0.382124,
    UPhase0_load_31 = -0.688814,
    UPhase0_load_32 = -0.467258,
    UPhase0_load_41 = -0.997318,
    UPhase0_load_42 = -1.05096,
    UPhase0_load_43 = -1.15762,
    UPhase0_load_46 = -1.1682,
    UPhase0_load_47 = -1.08867,
    UPhase0_load_51 = -1.28874,
    UPhase0_load_61 = -1.06088,
    UPhase0_load_62 = -0.997938,
    UPhase0_load_63 = -0.933555,
    UPhase0_load_71 = -0.136144,
    UPhase0_load_72 = -0.119138,
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
    U0Pu_shunt_1022 = 1.05125,
    U0Pu_shunt_1041 = 1.0124,
    U0Pu_shunt_1043 = 1.02744,
    U0Pu_shunt_1044 = 1.00659,
    U0Pu_shunt_1045 = 1.01105,
    U0Pu_shunt_4012 = 1.02355,
    U0Pu_shunt_4041 = 1.0506,
    U0Pu_shunt_4043 = 1.03697,
    U0Pu_shunt_4046 = 1.03572,
    U0Pu_shunt_4051 = 1.06593,
    U0Pu_shunt_4071 = 1.04844,
    UPhase0_shunt_1022 = -0.332401,
    UPhase0_shunt_1041 = -1.42894,
    UPhase0_shunt_1043 = -1.33994,
    UPhase0_shunt_1044 = -1.18176,
    UPhase0_shunt_1045 = -1.25075,
    UPhase0_shunt_4012 = -0.0966307,
    UPhase0_shunt_4041 = -0.94764,
    UPhase0_shunt_4043 = -1.10848,
    UPhase0_shunt_4046 = -1.11889,
    UPhase0_shunt_4051 = -1.23936,
    UPhase0_shunt_4071 = -0.0871387);
  extends Icons.Example;

  Types.AngularVelocityPu omegaCOI(start = SystemBase.omega0Pu) "Weighted average of the frequencies of all generators in pu (base omegaNom)";

  Types.VoltageModulePu check_UPu_bus_1041;
  Types.VoltageModulePu check_UPu_bus_1042;
  Types.VoltageModulePu check_UPu_bus_4012;
  Types.VoltageModulePu check_UPu_bus_4062;
  Types.VoltageModulePu check_UtPu_g06;
  Types.VoltageModulePu check_UtPu_g07;
  Types.CurrentModulePu check_IrPu_g06;
  Types.CurrentModulePu check_IrPu_g07;
  Types.CurrentModulePu check_IrPu_g08;
  Types.CurrentModulePu check_IrPu_g09;
  Types.CurrentModulePu check_IrPu_g11;
  Types.CurrentModulePu check_IrPu_g12;
  Types.CurrentModulePu check_IrPu_g14;
  Types.CurrentModulePu check_IrPu_g15;
  Types.CurrentModulePu check_IrPu_g16;
  Types.CurrentModulePu check_IrPu_g18;
  Types.AngularVelocityPu check_f_g06;
  Types.AngularVelocityPu check_f_g07;
  Types.AngularVelocityPu check_f_g17;

  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 40 / 400 ^ 2 * SystemBase.SnRef, XPu = 40 / 400 ^ 2 * SystemBase.SnRef, tBegin = 1, tEnd = 1.1);
  Dynawo.Electrical.Events.Event.SingleBooleanEvent disconnection(stateEvent1 = true, tEvent = 1.1);

equation
  check_UPu_bus_1041 = ComplexMath.abs(bus_1041.terminal.V);
  check_UPu_bus_1042 = ComplexMath.abs(bus_1042.terminal.V);
  check_UPu_bus_4012 = ComplexMath.abs(bus_4012.terminal.V);
  check_UPu_bus_4062 = ComplexMath.abs(bus_4062.terminal.V);
  check_IrPu_g06 = g06.vrNordic.IrPu;
  check_IrPu_g07 = g07.vrNordic.IrPu;
  check_IrPu_g08 = g08.vrNordic.IrPu;
  check_IrPu_g09 = g09.vrNordic.IrPu;
  check_IrPu_g11 = g11.vrNordic.IrPu;
  check_IrPu_g12 = g12.vrNordic.IrPu;
  check_IrPu_g14 = g14.vrNordic.IrPu;
  check_IrPu_g15 = g15.vrNordic.IrPu;
  check_IrPu_g16 = g16.vrNordic.IrPu;
  check_IrPu_g18 = g18.vrNordic.IrPu;
  check_f_g06 = g06.generatorSynchronous.omegaPu;
  check_f_g07 = g07.generatorSynchronous.omegaPu;
  check_f_g17 = g17.generatorSynchronous.omegaPu;
  check_UtPu_g06 = g06.generatorSynchronous.UPu;
  check_UtPu_g07 = g07.generatorSynchronous.UPu;

  omegaCOI = (g01.generatorSynchronous.omegaPu * g01.generatorSynchronous.H * g01.generatorSynchronous.SNom +
              g02.generatorSynchronous.omegaPu * g02.generatorSynchronous.H * g02.generatorSynchronous.SNom +
              g03.generatorSynchronous.omegaPu * g03.generatorSynchronous.H * g03.generatorSynchronous.SNom +
              g04.generatorSynchronous.omegaPu * g04.generatorSynchronous.H * g04.generatorSynchronous.SNom +
              g05.generatorSynchronous.omegaPu * g05.generatorSynchronous.H * g05.generatorSynchronous.SNom +
              g06.generatorSynchronous.omegaPu * g06.generatorSynchronous.H * g06.generatorSynchronous.SNom +
              g07.generatorSynchronous.omegaPu * g07.generatorSynchronous.H * g07.generatorSynchronous.SNom +
              g08.generatorSynchronous.omegaPu * g08.generatorSynchronous.H * g08.generatorSynchronous.SNom +
              g09.generatorSynchronous.omegaPu * g09.generatorSynchronous.H * g09.generatorSynchronous.SNom +
              g10.generatorSynchronous.omegaPu * g10.generatorSynchronous.H * g10.generatorSynchronous.SNom +
              g11.generatorSynchronous.omegaPu * g11.generatorSynchronous.H * g11.generatorSynchronous.SNom +
              g12.generatorSynchronous.omegaPu * g12.generatorSynchronous.H * g12.generatorSynchronous.SNom +
              g13.generatorSynchronous.omegaPu * g13.generatorSynchronous.H * g13.generatorSynchronous.SNom +
              g14.generatorSynchronous.omegaPu * g14.generatorSynchronous.H * g14.generatorSynchronous.SNom +
              g15.generatorSynchronous.omegaPu * g15.generatorSynchronous.H * g15.generatorSynchronous.SNom +
              g16.generatorSynchronous.omegaPu * g16.generatorSynchronous.H * g16.generatorSynchronous.SNom +
              g17.generatorSynchronous.omegaPu * g17.generatorSynchronous.H * g17.generatorSynchronous.SNom +
              g18.generatorSynchronous.omegaPu * g18.generatorSynchronous.H * g18.generatorSynchronous.SNom +
              g19.generatorSynchronous.omegaPu * g19.generatorSynchronous.H * g19.generatorSynchronous.SNom +
              g20.generatorSynchronous.omegaPu * g20.generatorSynchronous.H * g20.generatorSynchronous.SNom
              ) / (
              g01.generatorSynchronous.SNom * g01.generatorSynchronous.H +
              g02.generatorSynchronous.SNom * g02.generatorSynchronous.H +
              g03.generatorSynchronous.SNom * g03.generatorSynchronous.H +
              g04.generatorSynchronous.SNom * g04.generatorSynchronous.H +
              g05.generatorSynchronous.SNom * g05.generatorSynchronous.H +
              g06.generatorSynchronous.SNom * g06.generatorSynchronous.H +
              g07.generatorSynchronous.SNom * g07.generatorSynchronous.H +
              g08.generatorSynchronous.SNom * g08.generatorSynchronous.H +
              g09.generatorSynchronous.SNom * g09.generatorSynchronous.H +
              g10.generatorSynchronous.SNom * g10.generatorSynchronous.H +
              g11.generatorSynchronous.SNom * g11.generatorSynchronous.H +
              g12.generatorSynchronous.SNom * g12.generatorSynchronous.H +
              g13.generatorSynchronous.SNom * g13.generatorSynchronous.H +
              g14.generatorSynchronous.SNom * g14.generatorSynchronous.H +
              g15.generatorSynchronous.SNom * g15.generatorSynchronous.H +
              g16.generatorSynchronous.SNom * g16.generatorSynchronous.H +
              g17.generatorSynchronous.SNom * g17.generatorSynchronous.H +
              g18.generatorSynchronous.SNom * g18.generatorSynchronous.H +
              g19.generatorSynchronous.SNom * g19.generatorSynchronous.H +
              g20.generatorSynchronous.SNom * g20.generatorSynchronous.H);

  g01.generatorSynchronous.omegaRefPu = omegaCOI;
  g02.generatorSynchronous.omegaRefPu = omegaCOI;
  g03.generatorSynchronous.omegaRefPu = omegaCOI;
  g04.generatorSynchronous.omegaRefPu = omegaCOI;
  g05.generatorSynchronous.omegaRefPu = omegaCOI;
  g06.generatorSynchronous.omegaRefPu = omegaCOI;
  g07.generatorSynchronous.omegaRefPu = omegaCOI;
  g08.generatorSynchronous.omegaRefPu = omegaCOI;
  g09.generatorSynchronous.omegaRefPu = omegaCOI;
  g10.generatorSynchronous.omegaRefPu = omegaCOI;
  g11.generatorSynchronous.omegaRefPu = omegaCOI;
  g12.generatorSynchronous.omegaRefPu = omegaCOI;
  g13.generatorSynchronous.omegaRefPu = omegaCOI;
  g14.generatorSynchronous.omegaRefPu = omegaCOI;
  g15.generatorSynchronous.omegaRefPu = omegaCOI;
  g16.generatorSynchronous.omegaRefPu = omegaCOI;
  g17.generatorSynchronous.omegaRefPu = omegaCOI;
  g18.generatorSynchronous.omegaRefPu = omegaCOI;
  g19.generatorSynchronous.omegaRefPu = omegaCOI;
  g20.generatorSynchronous.omegaRefPu = omegaCOI;

  connect(nodeFault.terminal, bus_4032.terminal);
  connect(disconnection.state1, line_4032_4044.switchOffSignal1);

  annotation(preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 166.8, Tolerance = 0.005, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,nonewInst -d=initialization, -d=aliasConflicts, --maxSizeLinearTearing=1040, --maxSizeNonlinearTearing=1040 -d=nonewInst -d= -d=aliasConflicts, --maxSizeLinearTearing=1040, --maxSizeNonlinearTearing=1040 --daemode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "euler", lssMaxDensity = "0.1"),
    Documentation(info = "<html><head></head><body><span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">This test case is meant to investigate the long term dynamic response of the Nordic 32 test system, operating point A, regarding a contingency. This particular test case corresponds to the setup presented in Chapter 3.1 of the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.</span><div><font face=\"MS Shell Dlg 2\"><br></font><div><font face=\"MS Shell Dlg 2\">OmegaRef of the generators is set to the center of inertia of the whole system.</font></div><div><font face=\"MS Shell Dlg 2\"><br></font></div><div><font face=\"MS Shell Dlg 2\">The simulation runs in DAEmode, starts at t = 0 s, ends at t = 166.8 s (just before crashing) and uses the euler solver with a step size of 0.01 s and a tolerance of 0.005.</font></div><div><font face=\"MS Shell Dlg 2\"><br></font><div><font face=\"MS Shell Dlg 2\">At t = 1 s, a node fault occurs at bus 4032, which is cleared by tripping line 4032-4044&nbsp;</font><span style=\"font-family: 'MS Shell Dlg 2';\">after 0.1 s</span>.</div><div><br></div><div><div style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">While voltage remains more or less stable at bus 4012 and 4062, voltage keeps dropping at bus 1041 and 1042, until the voltage collapses ~160 s later.</div></div></div></div></body></html>"));
end TestCase;
