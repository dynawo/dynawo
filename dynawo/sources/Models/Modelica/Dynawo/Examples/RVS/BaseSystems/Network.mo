within Dynawo.Examples.RVS.BaseSystems;

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

model Network
  import Modelica.SIunits.Conversions.from_deg;
  import Dynawo;
  import Dynawo.Electrical.SystemBase.SnRef;

  parameter Types.ReactivePowerPu Q0Pu_line_reactor_106 = 0.75;
  parameter Types.VoltageModulePu U0Pu_line_reactor_106 = 1;
  parameter Types.Angle UPhase0_line_reactor_106 = 0;
  parameter Types.ReactivePowerPu Q0Pu_line_reactor_110 = 0.75;
  parameter Types.VoltageModulePu U0Pu_line_reactor_110 = 1;
  parameter Types.Angle UPhase0_line_reactor_110 = 0;

  Dynawo.Electrical.Lines.Line line_101_103(BPu = 0.057 / 2, GPu = 0, RPu = 0.055, XPu = 0.211) annotation(
    Placement(visible = true, transformation(origin = {-168, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line line_101_102(BPu = 0.461 / 2, GPu = 0, RPu = 0.003, XPu = 0.014) annotation(
    Placement(visible = true, transformation(origin = {-88, -226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line_101_105(BPu = 0.023 / 2, GPu = 0, RPu = 0.022, XPu = 0.085) annotation(
    Placement(visible = true, transformation(origin = {-24, -184}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_102_106(BPu = 0.052 / 2, GPu = 0, RPu = 0.05, XPu = 0.192) annotation(
    Placement(visible = true, transformation(origin = {72, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line line_102_104(BPu = 0.034 / 2, GPu = 0, RPu = 0.033, XPu = 0.127) annotation(
    Placement(visible = true, transformation(origin = {-54, -214}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line line_103_109(BPu = 0.032 / 2, GPu = 0, RPu = 0.031, XPu = 0.119) annotation(
    Placement(visible = true, transformation(origin = {-114, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_104_109(BPu = 0.028 / 2, GPu = 0, RPu = 0.027, XPu = 0.104) annotation(
    Placement(visible = true, transformation(origin = {-54, -128}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line line_105_110(BPu = 0.024 / 2, GPu = 0, RPu = 0.023, XPu = 0.088) annotation(
    Placement(visible = true, transformation(origin = {16, -154}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line line_106_110(BPu = 2.459 / 2, GPu = 0, RPu = 0.014, XPu = 0.061) annotation(
    Placement(visible = true, transformation(origin = {72, -152}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line line_107_108b(BPu = 0.0085 / 2, GPu = 0, RPu = 0.008, XPu = 0.03) annotation(
    Placement(visible = true, transformation(origin = {196, -154}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line line_107_108a(BPu = 0.0085 / 2, GPu = 0, RPu = 0.008, XPu = 0.03) annotation(
    Placement(visible = true, transformation(origin = {196, -134}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line line_108_109(BPu = 0.045 / 2, GPu = 0, RPu = 0.043, XPu = 0.165) annotation(
    Placement(visible = true, transformation(origin = {36, -154}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line line_108_110(BPu = 0.045 / 2, GPu = 0, RPu = 0.043, XPu = 0.165) annotation(
    Placement(visible = true, transformation(origin = {116, -134}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line line_111_113(BPu = 0.1 / 2, GPu = 0, RPu = 0.006, XPu = 0.048) annotation(
    Placement(visible = true, transformation(origin = {76, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_111_114(BPu = 0.088 / 2, GPu = 0, RPu = 0.005, XPu = 0.042) annotation(
    Placement(visible = true, transformation(origin = {-64, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_112_113(BPu = 0.1 / 2, GPu = 0, RPu = 0.006, XPu = 0.048) annotation(
    Placement(visible = true, transformation(origin = {78, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_112_123(BPu = 0.203 / 2, GPu = 0, RPu = 0.012, XPu = 0.097) annotation(
    Placement(visible = true, transformation(origin = {78, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_113_123(BPu = 0.182 / 2, GPu = 0, RPu = 0.011, XPu = 0.087) annotation(
    Placement(visible = true, transformation(origin = {166, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_114_116(BPu = 0.082 / 2, GPu = 0, RPu = 0.005, XPu = 0.059) annotation(
    Placement(visible = true, transformation(origin = {-64, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line line_115_116(BPu = 0.036 / 2, GPu = 0, RPu = 0.002, XPu = 0.017) annotation(
    Placement(visible = true, transformation(origin = {-134, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_115_121a(BPu = 0.103 / 2, GPu = 0, RPu = 0.006, XPu = 0.049) annotation(
    Placement(visible = true, transformation(origin = {-144, 252}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_115_121b(BPu = 0.103 / 2, GPu = 0, RPu = 0.006, XPu = 0.049) annotation(
    Placement(visible = true, transformation(origin = {-144, 232}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_115_124(BPu = 0.109 / 2, GPu = 0, RPu = 0.007, XPu = 0.052) annotation(
    Placement(visible = true, transformation(origin = {-178, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_116_117(BPu = 0.055 / 2, GPu = 0, RPu = 0.003, XPu = 0.026) annotation(
    Placement(visible = true, transformation(origin = {-6, 172}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_116_119(BPu = 0.049 / 2, GPu = 0, RPu = 0.003, XPu = 0.023) annotation(
    Placement(visible = true, transformation(origin = {-6, 152}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_117_118(BPu = 0.03 / 2, GPu = 0, RPu = 0.002, XPu = 0.014) annotation(
    Placement(visible = true, transformation(origin = {64, 222}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line line_117_122(BPu = 0.221 / 2, GPu = 0, RPu = 0.014, XPu = 0.105) annotation(
    Placement(visible = true, transformation(origin = {176, 188}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_118_121a(BPu = 0.055 / 2, GPu = 0, RPu = 0.003, XPu = 0.026) annotation(
    Placement(visible = true, transformation(origin = {-34, 252}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line line_118_121b(BPu = 0.055 / 2, GPu = 0, RPu = 0.003, XPu = 0.026) annotation(
    Placement(visible = true, transformation(origin = {-34, 232}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line line_119_120a(BPu = 0.083 / 2, GPu = 0, RPu = 0.005, XPu = 0.04) annotation(
    Placement(visible = true, transformation(origin = {86, 152}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_119_120b(BPu = 0.083 / 2, GPu = 0, RPu = 0.005, XPu = 0.04) annotation(
    Placement(visible = true, transformation(origin = {86, 136}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_120_123a(BPu = 0.046 / 2, GPu = 0, RPu = 0.003, XPu = 0.022) annotation(
    Placement(visible = true, transformation(origin = {176, 152}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_120_123b(BPu = 0.046 / 2, GPu = 0, RPu = 0.003, XPu = 0.022) annotation(
    Placement(visible = true, transformation(origin = {176, 136}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_121_122(BPu = 0.142 / 2, GPu = 0, RPu = 0.009, XPu = 0.068) annotation(
    Placement(visible = true, transformation(origin = {72, 298}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_10121_ATTLEE_G1 annotation(
    Placement(visible = true, transformation(origin = {-134, 282}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_121_ATTLEE annotation(
    Placement(visible = true, transformation(origin = {-94, 262}, extent = {{-40, -10}, {40, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_118_ASTOR annotation(
    Placement(visible = true, transformation(origin = {6, 230}, extent = {{-40, -10}, {40, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_1118_ASTOR annotation(
    Placement(visible = true, transformation(origin = {46, 260}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_10118_ASTOR_G1 annotation(
    Placement(visible = true, transformation(origin = {-34, 200}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_115_ARTHUR annotation(
    Placement(visible = true, transformation(origin = {-204, 192}, extent = {{-110, -10}, {110, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_50115_ARTHUR_G5 annotation(
    Placement(visible = true, transformation(origin = {-244, 132}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_10115_ARTHUR_G1 annotation(
    Placement(visible = true, transformation(origin = {-244, 292}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_40115_ARTHUR_G4 annotation(
    Placement(visible = true, transformation(origin = {-244, 172}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_20115_ARTHUR_G2 annotation(
    Placement(visible = true, transformation(origin = {-244, 252}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_60115_ARTHUR_G6 annotation(
    Placement(visible = true, transformation(origin = {-244, 92}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_30115_ARTHUR_G3 annotation(
    Placement(visible = true, transformation(origin = {-244, 212}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_1115_ARTHUR annotation(
    Placement(visible = true, transformation(origin = {-164, 164}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_114_ARNOLD annotation(
    Placement(visible = true, transformation(origin = {-44, 110}, extent = {{-30, -10}, {30, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_116_ASSER annotation(
    Placement(visible = true, transformation(origin = {-84, 134}, extent = {{-40, -10}, {40, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_10114_ARNOLD_SVC annotation(
    Placement(visible = true, transformation(origin = {-6, 124}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_117_ASTON annotation(
    Placement(visible = true, transformation(origin = {84, 198}, extent = {{-30, -10}, {30, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_1116_ASSER annotation(
    Placement(visible = true, transformation(origin = {-124, 124}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_1114_ARNOLD annotation(
    Placement(visible = true, transformation(origin = {-6, 84}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_10116_ASSER_G1 annotation(
    Placement(visible = true, transformation(origin = {-124, 144}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_124_AVERY annotation(
    Placement(visible = true, transformation(origin = {-168, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_10101_ABEL_G1 annotation(
    Placement(visible = true, transformation(origin = {-248, -246}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_1101_ABEL annotation(
    Placement(visible = true, transformation(origin = {-268, -186}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_1103_ADLER annotation(
    Placement(visible = true, transformation(origin = {-228, -126}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_103_ADLER annotation(
    Placement(visible = true, transformation(origin = {-164, -100}, extent = {{-30, -10}, {30, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_30101_ABEL_G3 annotation(
    Placement(visible = true, transformation(origin = {-168, -246}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_40101_ABEL_G4 annotation(
    Placement(visible = true, transformation(origin = {-128, -246}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_101_ABEL annotation(
    Placement(visible = true, transformation(origin = {-168, -206}, extent = {{-90, -10}, {90, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.Bus bus_20101_ABEL_G2 annotation(
    Placement(visible = true, transformation(origin = {-208, -246}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_1102_ADAMS annotation(
    Placement(visible = true, transformation(origin = {-94, -266}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_40102_ADAMS_G4 annotation(
    Placement(visible = true, transformation(origin = {76, -286}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_10102_ADAMS_G1 annotation(
    Placement(visible = true, transformation(origin = {-44, -286}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_20102_ADAMS_G2 annotation(
    Placement(visible = true, transformation(origin = {-4, -286}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_102_ADAMS annotation(
    Placement(visible = true, transformation(origin = {-4, -246}, extent = {{-90, -10}, {90, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.Bus bus_30102_ADAMS_G3 annotation(
    Placement(visible = true, transformation(origin = {36, -286}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_106_ALBER annotation(
    Placement(visible = true, transformation(origin = {92, -206}, extent = {{-30, -10}, {30, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_1106_ALBER annotation(
    Placement(visible = true, transformation(origin = {152, -266}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_10106_ALBER_SVC annotation(
    Placement(visible = true, transformation(origin = {152, -226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus1 annotation(
    Placement(visible = true, transformation(origin = {72, -172}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus annotation(
    Placement(visible = true, transformation(origin = {72, -132}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_110_ALLEN annotation(
    Placement(visible = true, transformation(origin = {48, -102}, extent = {{-40, -10}, {40, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_30122_AUBREY_G3 annotation(
    Placement(visible = true, transformation(origin = {266, 308}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_10122_AUBREY_G1 annotation(
    Placement(visible = true, transformation(origin = {186, 278}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_122_AUBREY annotation(
    Placement(visible = true, transformation(origin = {226, 248}, extent = {{-70, -10}, {70, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_40122_AUBREY_G4 annotation(
    Placement(visible = true, transformation(origin = {266, 268}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_60122_AUBREY_G6 annotation(
    Placement(visible = true, transformation(origin = {266, 188}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_20122_AUBREY_G2 annotation(
    Placement(visible = true, transformation(origin = {186, 238}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_50122_AUBREY_G5 annotation(
    Placement(visible = true, transformation(origin = {266, 228}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_10123_AUSTEN_G1 annotation(
    Placement(visible = true, transformation(origin = {266, 146}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_123_AUSTEN annotation(
    Placement(visible = true, transformation(origin = {226, 106}, extent = {{-50, -10}, {50, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_1119_ATTAR annotation(
    Placement(visible = true, transformation(origin = {86, 106}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_120_ATTILA annotation(
    Placement(visible = true, transformation(origin = {126, 126}, extent = {{-30, -10}, {30, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_119_ATTAR annotation(
    Placement(visible = true, transformation(origin = {46, 126}, extent = {{-30, -10}, {30, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_30123_AUSTEN_G3 annotation(
    Placement(visible = true, transformation(origin = {266, 66}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_1120_ATTILA annotation(
    Placement(visible = true, transformation(origin = {166, 106}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_20123_AUSTEN_G2 annotation(
    Placement(visible = true, transformation(origin = {266, 106}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_10113_ARNE_G1 annotation(
    Placement(visible = true, transformation(origin = {166, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_113_ARNE annotation(
    Placement(visible = true, transformation(origin = {126, 16}, extent = {{-60, -10}, {60, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_30113_ARNE_G3 annotation(
    Placement(visible = true, transformation(origin = {166, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_20113_ARNE_G2 annotation(
    Placement(visible = true, transformation(origin = {166, 6}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_1113_ARNE annotation(
    Placement(visible = true, transformation(origin = {106, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_30107_ALDER_G3 annotation(
    Placement(visible = true, transformation(origin = {276, -214}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_1108_ALGER annotation(
    Placement(visible = true, transformation(origin = {196, -174}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_107_ALDER annotation(
    Placement(visible = true, transformation(origin = {236, -174}, extent = {{-50, -10}, {50, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_10107_ALDER_G1 annotation(
    Placement(visible = true, transformation(origin = {276, -134}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_1107_ALDER annotation(
    Placement(visible = true, transformation(origin = {216, -234}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_20107_ALDER_G2 annotation(
    Placement(visible = true, transformation(origin = {276, -174}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_108_ALGER annotation(
    Placement(visible = true, transformation(origin = {156, -154}, extent = {{-30, -10}, {30, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_109_ALI annotation(
    Placement(visible = true, transformation(origin = {-64, -102}, extent = {{-30, -10}, {30, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_1109_ALI annotation(
    Placement(visible = true, transformation(origin = {-104, -128}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_104_AGRICOLA annotation(
    Placement(visible = true, transformation(origin = {-54, -148}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_1104_AGRICOLA annotation(
    Placement(visible = true, transformation(origin = {-104, -168}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_111_ANNA annotation(
    Placement(visible = true, transformation(origin = {-74, 36}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_105_AIKEN annotation(
    Placement(visible = true, transformation(origin = {16, -204}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_1105_AIKEN annotation(
    Placement(visible = true, transformation(origin = {-14, -224}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_112_ARCHER annotation(
    Placement(visible = true, transformation(origin = {28, 36}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_1110_ALLEN annotation(
    Placement(visible = true, transformation(origin = {66, -74}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Shunts.ShuntB line_reactor_106(BPu = 0.75, i0Pu = i0Pu_line_reactor_106, s0Pu = s0Pu_line_reactor_106, u0Pu = u0Pu_line_reactor_106) annotation(
    Placement(visible = true, transformation(origin = {48, -172}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Dynawo.Electrical.Shunts.ShuntB line_reactor_110(BPu = 0.75, i0Pu = i0Pu_line_reactor_110, s0Pu = s0Pu_line_reactor_110, u0Pu = u0Pu_line_reactor_110) annotation(
    Placement(visible = true, transformation(origin = {48, -132}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));

protected
  final parameter Types.ComplexApparentPowerPu s0Pu_line_reactor_106 = Complex(0, Q0Pu_line_reactor_106);
  final parameter Types.ComplexVoltagePu u0Pu_line_reactor_106 = ComplexMath.fromPolar(U0Pu_line_reactor_106, UPhase0_line_reactor_106);
  final parameter Types.ComplexCurrentPu i0Pu_line_reactor_106 = ComplexMath.conj(s0Pu_line_reactor_106 / u0Pu_line_reactor_106);
  final parameter Types.ComplexApparentPowerPu s0Pu_line_reactor_110 = Complex(0, Q0Pu_line_reactor_110);
  final parameter Types.ComplexVoltagePu u0Pu_line_reactor_110 = ComplexMath.fromPolar(U0Pu_line_reactor_110, UPhase0_line_reactor_110);
  final parameter Types.ComplexCurrentPu i0Pu_line_reactor_110 = ComplexMath.conj(s0Pu_line_reactor_110 / u0Pu_line_reactor_110);

equation
  line_101_102.switchOffSignal1.value = false;
  line_101_102.switchOffSignal2.value = false;
  line_101_103.switchOffSignal1.value = false;
  line_101_103.switchOffSignal2.value = false;
  line_101_105.switchOffSignal1.value = false;
  line_101_105.switchOffSignal2.value = false;
  line_102_104.switchOffSignal1.value = false;
  line_102_104.switchOffSignal2.value = false;
  line_102_106.switchOffSignal1.value = false;
  line_102_106.switchOffSignal2.value = false;
  line_103_109.switchOffSignal1.value = false;
  line_103_109.switchOffSignal2.value = false;
  line_104_109.switchOffSignal1.value = false;
  line_104_109.switchOffSignal2.value = false;
  line_105_110.switchOffSignal1.value = false;
  line_105_110.switchOffSignal2.value = false;
  line_107_108a.switchOffSignal1.value = false;
  line_107_108a.switchOffSignal2.value = false;
  line_107_108b.switchOffSignal1.value = false;
  line_107_108b.switchOffSignal2.value = false;
  line_108_109.switchOffSignal1.value = false;
  line_108_109.switchOffSignal2.value = false;
  line_108_110.switchOffSignal1.value = false;
  line_108_110.switchOffSignal2.value = false;
  line_111_113.switchOffSignal1.value = false;
  line_111_113.switchOffSignal2.value = false;
  line_111_114.switchOffSignal1.value = false;
  line_111_114.switchOffSignal2.value = false;
  line_112_113.switchOffSignal1.value = false;
  line_112_113.switchOffSignal2.value = false;
  line_112_123.switchOffSignal1.value = false;
  line_112_123.switchOffSignal2.value = false;
  line_113_123.switchOffSignal1.value = false;
  line_113_123.switchOffSignal2.value = false;
  line_114_116.switchOffSignal1.value = false;
  line_114_116.switchOffSignal2.value = false;
  line_115_116.switchOffSignal1.value = false;
  line_115_116.switchOffSignal2.value = false;
  line_115_121a.switchOffSignal1.value = false;
  line_115_121a.switchOffSignal2.value = false;
  line_115_121b.switchOffSignal1.value = false;
  line_115_121b.switchOffSignal2.value = false;
  line_115_124.switchOffSignal1.value = false;
  line_115_124.switchOffSignal2.value = false;
  line_116_117.switchOffSignal1.value = false;
  line_116_117.switchOffSignal2.value = false;
  line_116_119.switchOffSignal1.value = false;
  line_116_119.switchOffSignal2.value = false;
  line_117_118.switchOffSignal1.value = false;
  line_117_118.switchOffSignal2.value = false;
  line_117_122.switchOffSignal1.value = false;
  line_117_122.switchOffSignal2.value = false;
  line_118_121a.switchOffSignal1.value = false;
  line_118_121a.switchOffSignal2.value = false;
  line_118_121b.switchOffSignal1.value = false;
  line_118_121b.switchOffSignal2.value = false;
  line_119_120a.switchOffSignal1.value = false;
  line_119_120a.switchOffSignal2.value = false;
  line_119_120b.switchOffSignal1.value = false;
  line_119_120b.switchOffSignal2.value = false;
  line_120_123a.switchOffSignal1.value = false;
  line_120_123a.switchOffSignal2.value = false;
  line_120_123b.switchOffSignal1.value = false;
  line_120_123b.switchOffSignal2.value = false;
  line_121_122.switchOffSignal1.value = false;
  line_121_122.switchOffSignal2.value = false;
  connect(line_118_121b.terminal1, bus_118_ASTOR.terminal) annotation(
    Line(points = {{-24, 232}, {6, 232}, {6, 230}}, color = {0, 0, 255}));
  connect(line_118_121a.terminal1, bus_118_ASTOR.terminal) annotation(
    Line(points = {{-24, 252}, {6, 252}, {6, 230}}, color = {0, 0, 255}));
  connect(line_115_121b.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-154, 232}, {-204, 232}, {-204, 192}}, color = {0, 0, 255}));
  connect(line_115_121a.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-154, 252}, {-204, 252}, {-204, 192}}, color = {0, 0, 255}));
  connect(line_115_121b.terminal2, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-134, 232}, {-94, 232}, {-94, 262}}, color = {0, 0, 255}));
  connect(line_115_116.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-144, 100}, {-204, 100}, {-204, 192}}, color = {0, 0, 255}));
  connect(line_115_116.terminal2, bus_116_ASSER.terminal) annotation(
    Line(points = {{-124, 100}, {-84, 100}, {-84, 134}}, color = {0, 0, 255}));
  connect(line_114_116.terminal2, bus_116_ASSER.terminal) annotation(
    Line(points = {{-74, 100}, {-84, 100}, {-84, 134}}, color = {0, 0, 255}));
  connect(line_114_116.terminal1, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-54, 100}, {-44, 100}, {-44, 110}}, color = {0, 0, 255}));
  connect(line_117_118.terminal1, bus_117_ASTON.terminal) annotation(
    Line(points = {{74, 222}, {84, 222}, {84, 198}}, color = {0, 0, 255}));
  connect(line_116_117.terminal2, bus_117_ASTON.terminal) annotation(
    Line(points = {{4, 172}, {84, 172}, {84, 198}}, color = {0, 0, 255}));
  connect(line_116_117.terminal1, bus_116_ASSER.terminal) annotation(
    Line(points = {{-16, 172}, {-84, 172}, {-84, 134}}, color = {0, 0, 255}));
  connect(line_117_118.terminal2, bus_118_ASTOR.terminal) annotation(
    Line(points = {{54, 222}, {6, 222}, {6, 230}}, color = {0, 0, 255}));
  connect(line_115_124.terminal2, bus_124_AVERY.terminal) annotation(
    Line(points = {{-168, 88}, {-168, 36}}, color = {0, 0, 255}));
  connect(line_115_124.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-188, 88}, {-204, 88}, {-204, 192}}, color = {0, 0, 255}));
  connect(line_101_103.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-168, -170}, {-168, -206}}, color = {0, 0, 255}));
  connect(line_101_102.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-88, -216}, {-88, -206}, {-168, -206}}, color = {0, 0, 255}));
  connect(line_101_102.terminal2, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-88, -236}, {-88, -246}, {-4, -246}}, color = {0, 0, 255}));
  connect(line_102_106.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{72, -236}, {72, -246}, {-4, -246}}, color = {0, 0, 255}));
  connect(line_102_106.terminal2, bus_106_ALBER.terminal) annotation(
    Line(points = {{72, -216}, {72, -206}, {92, -206}}, color = {0, 0, 255}));
  connect(line_106_110.terminal1, bus1.terminal) annotation(
    Line(points = {{72, -162}, {72, -172}}, color = {0, 0, 255}));
  connect(line_106_110.terminal2, bus.terminal) annotation(
    Line(points = {{72, -142}, {72, -132}}, color = {0, 0, 255}));
  connect(line_reactor_110.terminal, bus.terminal) annotation(
    Line(points = {{48, -132}, {72, -132}}, color = {0, 0, 255}));
  connect(line_reactor_106.terminal, bus1.terminal) annotation(
    Line(points = {{48, -172}, {72, -172}}, color = {0, 0, 255}));
  connect(line_117_122.terminal2, bus_122_AUBREY.terminal) annotation(
    Line(points = {{186, 188}, {226, 188}, {226, 248}}, color = {0, 0, 255}));
  connect(line_121_122.terminal2, bus_122_AUBREY.terminal) annotation(
    Line(points = {{82, 298}, {226, 298}, {226, 248}}, color = {0, 0, 255}));
  connect(line_118_121b.terminal2, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-44, 232}, {-94, 232}, {-94, 262}}, color = {0, 0, 255}));
  connect(line_115_121a.terminal2, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-134, 252}, {-94, 252}, {-94, 262}}, color = {0, 0, 255}));
  connect(line_118_121a.terminal2, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-44, 252}, {-94, 252}, {-94, 262}}, color = {0, 0, 255}));
  connect(line_121_122.terminal1, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{62, 298}, {-94, 298}, {-94, 262}}, color = {0, 0, 255}));
  connect(line_117_122.terminal1, bus_117_ASTON.terminal) annotation(
    Line(points = {{166, 188}, {84, 188}, {84, 198}}, color = {0, 0, 255}));
  connect(line_119_120b.terminal1, bus_119_ATTAR.terminal) annotation(
    Line(points = {{76, 136}, {46, 136}, {46, 126}}, color = {0, 0, 255}));
  connect(line_120_123b.terminal1, bus_120_ATTILA.terminal) annotation(
    Line(points = {{166, 136}, {126, 136}, {126, 126}}, color = {0, 0, 255}));
  connect(line_119_120a.terminal2, bus_120_ATTILA.terminal) annotation(
    Line(points = {{96, 152}, {126, 152}, {126, 126}}, color = {0, 0, 255}));
  connect(line_119_120a.terminal1, bus_119_ATTAR.terminal) annotation(
    Line(points = {{76, 152}, {46, 152}, {46, 126}}, color = {0, 0, 255}));
  connect(line_119_120b.terminal2, bus_120_ATTILA.terminal) annotation(
    Line(points = {{96, 136}, {126, 136}, {126, 126}}, color = {0, 0, 255}));
  connect(line_120_123a.terminal1, bus_120_ATTILA.terminal) annotation(
    Line(points = {{166, 152}, {126, 152}, {126, 126}}, color = {0, 0, 255}));
  connect(line_120_123b.terminal2, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{186, 136}, {226, 136}, {226, 106}}, color = {0, 0, 255}));
  connect(line_116_119.terminal2, bus_119_ATTAR.terminal) annotation(
    Line(points = {{4, 152}, {46, 152}, {46, 126}}, color = {0, 0, 255}));
  connect(line_116_119.terminal1, bus_116_ASSER.terminal) annotation(
    Line(points = {{-16, 152}, {-84, 152}, {-84, 134}}, color = {0, 0, 255}));
  connect(line_120_123a.terminal2, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{186, 152}, {226, 152}, {226, 106}}, color = {0, 0, 255}));
  connect(line_113_123.terminal2, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{176, 66}, {226, 66}, {226, 106}}, color = {0, 0, 255}));
  connect(line_113_123.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{156, 66}, {126, 66}, {126, 16}}, color = {0, 0, 255}));
  connect(line_107_108a.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{206, -134}, {236, -134}, {236, -174}}, color = {0, 0, 255}));
  connect(line_108_110.terminal1, bus_108_ALGER.terminal) annotation(
    Line(points = {{126, -134}, {156, -134}, {156, -154}}, color = {0, 0, 255}));
  connect(line_107_108a.terminal2, bus_108_ALGER.terminal) annotation(
    Line(points = {{186, -134}, {156, -134}, {156, -154}}, color = {0, 0, 255}));
  connect(line_107_108b.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{206, -154}, {236, -154}, {236, -174}}, color = {0, 0, 255}));
  connect(line_108_110.terminal2, bus_110_ALLEN.terminal) annotation(
    Line(points = {{106, -134}, {86, -134}, {86, -102}, {48, -102}}, color = {0, 0, 255}));
  connect(line_107_108b.terminal2, bus_108_ALGER.terminal) annotation(
    Line(points = {{186, -154}, {156, -154}}, color = {0, 0, 255}));
  connect(line_111_113.terminal1, bus_111_ANNA.terminal) annotation(
    Line(points = {{66, 66}, {-68, 66}, {-68, 36}, {-74, 36}}, color = {0, 0, 255}));
  connect(line_104_109.terminal2, bus_109_ALI.terminal) annotation(
    Line(points = {{-54, -118}, {-54, -102}, {-64, -102}}, color = {0, 0, 255}));
  connect(line_104_109.terminal1, bus_104_AGRICOLA.terminal) annotation(
    Line(points = {{-54, -138}, {-54, -148}}, color = {0, 0, 255}));
  connect(line_103_109.terminal2, bus_109_ALI.terminal) annotation(
    Line(points = {{-104, -88}, {-88, -88}, {-88, -102}, {-64, -102}}, color = {0, 0, 255}));
  connect(line_111_114.terminal1, bus_111_ANNA.terminal) annotation(
    Line(points = {{-74, 84}, {-86, 84}, {-86, 36}, {-74, 36}}, color = {0, 0, 255}));
  connect(line_111_114.terminal2, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-54, 84}, {-44, 84}, {-44, 110}}, color = {0, 0, 255}));
  connect(line_111_113.terminal2, bus_113_ARNE.terminal) annotation(
    Line(points = {{86, 66}, {126, 66}, {126, 16}}, color = {0, 0, 255}));
  connect(line_103_109.terminal1, bus_103_ADLER.terminal) annotation(
    Line(points = {{-124, -88}, {-146, -88}, {-146, -100}, {-164, -100}}, color = {0, 0, 255}));
  connect(line_102_104.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-54, -224}, {-54, -246}, {-4, -246}}, color = {0, 0, 255}));
  connect(line_108_109.terminal1, bus_108_ALGER.terminal) annotation(
    Line(points = {{46, -154}, {156, -154}}, color = {0, 0, 255}));
  connect(line_108_109.terminal2, bus_109_ALI.terminal) annotation(
    Line(points = {{26, -154}, {6, -154}, {6, -116}, {-38, -116}, {-38, -102}, {-64, -102}}, color = {0, 0, 255}));
  connect(line_101_103.terminal2, bus_103_ADLER.terminal) annotation(
    Line(points = {{-168, -150}, {-168, -100}, {-164, -100}}, color = {0, 0, 255}));
  connect(line_102_104.terminal2, bus_104_AGRICOLA.terminal) annotation(
    Line(points = {{-54, -204}, {-54, -148}}, color = {0, 0, 255}));
  connect(line_101_105.terminal2, bus_105_AIKEN.terminal) annotation(
    Line(points = {{-14, -184}, {6, -184}, {6, -204}, {16, -204}}, color = {0, 0, 255}));
  connect(line_105_110.terminal1, bus_105_AIKEN.terminal) annotation(
    Line(points = {{16, -164}, {16, -204}}, color = {0, 0, 255}));
  connect(line_105_110.terminal2, bus_110_ALLEN.terminal) annotation(
    Line(points = {{16, -144}, {16, -102}, {48, -102}}, color = {0, 0, 255}));
  connect(line_101_105.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-34, -184}, {-88, -184}, {-88, -206}, {-168, -206}}, color = {0, 0, 255}));
  connect(line_112_113.terminal1, bus_112_ARCHER.terminal) annotation(
    Line(points = {{68, 48}, {40, 48}, {40, 36}, {28, 36}}, color = {0, 0, 255}));
  connect(line_112_123.terminal1, bus_112_ARCHER.terminal) annotation(
    Line(points = {{68, 86}, {34, 86}, {34, 36}, {28, 36}}, color = {0, 0, 255}));
  connect(line_112_123.terminal2, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{88, 86}, {226, 86}, {226, 106}}, color = {0, 0, 255}));
  connect(line_112_113.terminal2, bus_113_ARNE.terminal) annotation(
    Line(points = {{88, 48}, {126, 48}, {126, 16}}, color = {0, 0, 255}));
  connect(bus1.terminal, bus_106_ALBER.terminal) annotation(
    Line(points = {{72, -172}, {72, -206}, {92, -206}}, color = {0, 0, 255}));
  connect(bus.terminal, bus_110_ALLEN.terminal) annotation(
    Line(points = {{72, -132}, {72, -102}, {48, -102}}, color = {0, 0, 255}));

  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida"),
    Diagram(coordinateSystem(extent = {{-300, -340}, {300, 340}})),
    Icon(coordinateSystem(extent = {{-200, -300}, {200, 300}})));
end Network;
