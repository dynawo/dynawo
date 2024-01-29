within Dynawo.Examples.KundurTwoArea.TestCases;

model LoadFlow "Model of load flow calculation for the Nordic 32 test system used for voltage stability studies"
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
  extends Dynawo.Examples.Nordic.Grid.FullStaticModel(P0Pu_g01 = 6, P0Pu_g02 = 3, P0Pu_g03 = 5.5, P0Pu_g04 = 4, P0Pu_g05 = 2, P0Pu_g06 = 3.6, P0Pu_g07 = 1.8, P0Pu_g08 = 7.5, P0Pu_g09 = 6.685, P0Pu_g10 = 6, P0Pu_g11 = 2.5, P0Pu_g12 = 3.1, P0Pu_g13 = 0, P0Pu_g14 = 6.3, P0Pu_g15 = 10.8, P0Pu_g16 = 6, P0Pu_g17 = 5.3, P0Pu_g18 = 10.6, P0Pu_g19 = 3, U0Pu_g01 = 1.0684, U0Pu_g02 = 1.0565, U0Pu_g03 = 1.0595, U0Pu_g04 = 1.0339, U0Pu_g05 = 1.0294, U0Pu_g06 = 1.0084, U0Pu_g07 = 1.0141, U0Pu_g08 = 1.0498, U0Pu_g09 = 0.9988, U0Pu_g10 = 1.0157, U0Pu_g11 = 1.0211, U0Pu_g12 = 1.02, U0Pu_g13 = 1.017, U0Pu_g14 = 1.0454, U0Pu_g15 = 1.0455, U0Pu_g16 = 1.0531, U0Pu_g17 = 1.0092, U0Pu_g18 = 1.0307, U0Pu_g19 = 1.03, U0Pu_g20 = 1.0185, P0Pu_load_01 = 6, P0Pu_load_02 = 3.3, P0Pu_load_03 = 2.6, P0Pu_load_04 = 8.4, P0Pu_load_05 = 7.2, P0Pu_load_11 = 2, P0Pu_load_12 = 3, P0Pu_load_13 = 1, P0Pu_load_22 = 2.8, P0Pu_load_31 = 1, P0Pu_load_32 = 2, P0Pu_load_41 = 5.4, P0Pu_load_42 = 4, P0Pu_load_43 = 9, P0Pu_load_46 = 7, P0Pu_load_47 = 1, P0Pu_load_51 = 8, P0Pu_load_61 = 5, P0Pu_load_62 = 3, P0Pu_load_63 = 5.9, P0Pu_load_71 = 3, P0Pu_load_72 = 20, Q0Pu_load_01 = 1.482, Q0Pu_load_02 = 0.71, Q0Pu_load_03 = 0.838, Q0Pu_load_04 = 2.52, Q0Pu_load_05 = 1.904, Q0Pu_load_11 = 0.688, Q0Pu_load_12 = 0.838, Q0Pu_load_13 = 0.344, Q0Pu_load_22 = 0.799, Q0Pu_load_31 = 0.247, Q0Pu_load_32 = 0.396, Q0Pu_load_41 = 1.314, Q0Pu_load_42 = 1.274, Q0Pu_load_43 = 2.546, Q0Pu_load_46 = 2.118, Q0Pu_load_47 = 0.44, Q0Pu_load_51 = 2.582, Q0Pu_load_61 = 1.225, Q0Pu_load_62 = 0.838, Q0Pu_load_63 = 2.646, Q0Pu_load_71 = 0.838, Q0Pu_load_72 = 3.961, BPu_shunt_1022 = -0.5, BPu_shunt_1041 = -2.5, BPu_shunt_1043 = -2, BPu_shunt_1044 = -2, BPu_shunt_1045 = -2, BPu_shunt_4012 = 1, BPu_shunt_4041 = -2, BPu_shunt_4043 = -2, BPu_shunt_4046 = -1, BPu_shunt_4051 = -1, BPu_shunt_4071 = 4);
  extends Icons.Example;
  Types.ActivePower check_g20_P;
  Types.ReactivePower check_g20_Q;
equation
  check_g20_P = SystemBase.SnRef*ComplexMath.real(slackbus_g20.terminal.V*ComplexMath.conj(slackbus_g20.terminal.i));
  check_g20_Q = SystemBase.SnRef*ComplexMath.imag(slackbus_g20.terminal.V*ComplexMath.conj(slackbus_g20.terminal.i));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
    __OpenModelica_commandLineOptions = "--daemode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", noEquidistantTimeGrid = "()", s = "ida"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body>The LoadFlow model extends the network with PQ loads model and adds nonregulated transformers and PQ generators. It could also extend the network with alpha-beta loads model.<div><br></div><div>The initial power values have been taken from the&nbsp;<span style=\"font-size: 12px; font-family: 'MS Shell Dlg 2';\">IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015. The initial voltage values are taken from the report, operating point A.</span><div><font face=\"MS Shell Dlg 2\"><br></font><div>The initial power and voltage values should produce steady state.</div></div></div></body></html>"));
end LoadFlow;
