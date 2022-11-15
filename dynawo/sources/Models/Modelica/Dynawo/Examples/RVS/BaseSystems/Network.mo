within Dynawo.Examples.RVS.BaseSystems;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model Network
  import Modelica.SIunits.Conversions.from_deg;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.Buses.Bus;
  import Dynawo.Electrical.Lines.Line;
  
  Bus bus_101_ABEL annotation(
    Placement(visible = true, transformation(origin = {-170, -170}, extent = {{-90, -10}, {90, 10}}, rotation = 180)));
  Bus bus_1101_ABEL annotation(
    Placement(visible = true, transformation(origin = {-250, -150}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_10101_ABEL_G1 annotation(
    Placement(visible = true, transformation(origin = {-250, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Bus bus_20101_ABEL_G2 annotation(
    Placement(visible = true, transformation(origin = {-210, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Bus bus_30101_ABEL_G3 annotation(
    Placement(visible = true, transformation(origin = {-170, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Bus bus_40101_ABEL_G4 annotation(
    Placement(visible = true, transformation(origin = {-130, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Bus bus_102_ADAMS annotation(
    Placement(visible = true, transformation(origin = {0, -210}, extent = {{-90, -10}, {90, 10}}, rotation = 180)));
  Bus bus_1102_ADAMS annotation(
    Placement(visible = true, transformation(origin = {-90, -230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_10102_ADAMS_G1 annotation(
    Placement(visible = true, transformation(origin = {-40, -250}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Bus bus_20102_ADAMS_G2 annotation(
    Placement(visible = true, transformation(origin = {0, -250}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Bus bus_30102_ADAMS_G3 annotation(
    Placement(visible = true, transformation(origin = {40, -250}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Bus bus_40102_ADAMS_G4 annotation(
    Placement(visible = true, transformation(origin = {80, -250}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Bus bus_103_ADLER annotation(
    Placement(visible = true, transformation(origin = {-160, -70}, extent = {{-30, -10}, {30, 10}}, rotation = 0)));
  Bus bus_1103_ADLER annotation(
    Placement(visible = true, transformation(origin = {-210, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_104_AGRICOLA annotation(
    Placement(visible = true, transformation(origin = {-60, -110}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
  Bus bus_1104_AGRICOLA annotation(
    Placement(visible = true, transformation(origin = {-110, -130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_105_AIKEN annotation(
    Placement(visible = true, transformation(origin = {10, -170}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_1105_AIKEN annotation(
    Placement(visible = true, transformation(origin = {-20, -190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_106_ALBER annotation(
    Placement(visible = true, transformation(origin = {80, -170}, extent = {{-30, -10}, {30, 10}}, rotation = 0)));
  Bus bus_1106_ALBER annotation(
    Placement(visible = true, transformation(origin = {130, -230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_10106_ALBER_SVC annotation(
    Placement(visible = true, transformation(origin = {130, -190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_107_ALDER annotation(
    Placement(visible = true, transformation(origin = {210, -150}, extent = {{-50, -10}, {50, 10}}, rotation = -90)));
  Bus bus_1107_ALDER annotation(
    Placement(visible = true, transformation(origin = {190, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Bus bus_10107_ALDER_G1 annotation(
    Placement(visible = true, transformation(origin = {250, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_20107_ALDER_G2 annotation(
    Placement(visible = true, transformation(origin = {250, -150}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_30107_ALDER_G3 annotation(
    Placement(visible = true, transformation(origin = {250, -190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_108_ALGER annotation(
    Placement(visible = true, transformation(origin = {130, -130}, extent = {{-30, -10}, {30, 10}}, rotation = -90)));
  Bus bus_1108_ALGER annotation(
    Placement(visible = true, transformation(origin = {170, -150}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_109_ALI annotation(
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-30, -10}, {30, 10}}, rotation = 0)));
  Bus bus_1109_ALI annotation(
    Placement(visible = true, transformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_110_ALLEN annotation(
    Placement(visible = true, transformation(origin = {30, -70}, extent = {{-40, -10}, {40, 10}}, rotation = 0)));
  Bus bus_1110_ALLEN annotation(
    Placement(visible = true, transformation(origin = {70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_111_ANNA annotation(
    Placement(visible = true, transformation(origin = {-80, -10}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
  Bus bus_112_ARCHER annotation(
    Placement(visible = true, transformation(origin = {20, -8}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
  Bus bus_113_ARNE annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{-60, -10}, {60, 10}}, rotation = -90)));
  Bus bus_1113_ARNE annotation(
    Placement(visible = true, transformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Bus bus_10113_ARNE_G1 annotation(
    Placement(visible = true, transformation(origin = {170, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_20113_ARNE_G2 annotation(
    Placement(visible = true, transformation(origin = {170, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_30113_ARNE_G3 annotation(
    Placement(visible = true, transformation(origin = {170, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_114_ARNOLD annotation(
    Placement(visible = true, transformation(origin = {-50, 70}, extent = {{-30, -10}, {30, 10}}, rotation = -90)));
  Bus bus_1114_ARNOLD annotation(
    Placement(visible = true, transformation(origin = {-10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_10114_ARNOLD_SVC annotation(
    Placement(visible = true, transformation(origin = {-10, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_115_ARTHUR annotation(
    Placement(visible = true, transformation(origin = {-190, 150}, extent = {{-110, -10}, {110, 10}}, rotation = -90)));
  Bus bus_1115_ARTHUR annotation(
    Placement(visible = true, transformation(origin = {-130, 152}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_10115_ARTHUR_G1 annotation(
    Placement(visible = true, transformation(origin = {-230, 250}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_20115_ARTHUR_G2 annotation(
    Placement(visible = true, transformation(origin = {-230, 210}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_30115_ARTHUR_G3 annotation(
    Placement(visible = true, transformation(origin = {-230, 170}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_40115_ARTHUR_G4 annotation(
    Placement(visible = true, transformation(origin = {-230, 130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_50115_ARTHUR_G5 annotation(
    Placement(visible = true, transformation(origin = {-230, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_60115_ARTHUR_G6 annotation(
    Placement(visible = true, transformation(origin = {-230, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_116_ASSER annotation(
    Placement(visible = true, transformation(origin = {-90, 94}, extent = {{-40, -10}, {40, 10}}, rotation = -90)));
  Bus bus_1116_ASSER annotation(
    Placement(visible = true, transformation(origin = {-130, 82}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_10116_ASSER_G1 annotation(
    Placement(visible = true, transformation(origin = {-130, 122}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_117_ASTON annotation(
    Placement(visible = true, transformation(origin = {70, 154}, extent = {{-30, -10}, {30, 10}}, rotation = -90)));
  Bus bus_118_ASTOR annotation(
    Placement(visible = true, transformation(origin = {28, 180}, extent = {{-40, -10}, {40, 10}}, rotation = -90)));
  Bus bus_1118_ASTOR annotation(
    Placement(visible = true, transformation(origin = {70, 210}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_10118_ASTOR_G1 annotation(
    Placement(visible = true, transformation(origin = {-10, 150}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_119_ATTAR annotation(
    Placement(visible = true, transformation(origin = {30, 90}, extent = {{-30, -10}, {30, 10}}, rotation = -90)));
  Bus bus_1119_ATTAR annotation(
    Placement(visible = true, transformation(origin = {70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_120_ATTILA annotation(
    Placement(visible = true, transformation(origin = {110, 90}, extent = {{-30, -10}, {30, 10}}, rotation = -90)));
  Bus bus_1120_ATTILA annotation(
    Placement(visible = true, transformation(origin = {150, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_121_ATTLEE annotation(
    Placement(visible = true, transformation(origin = {-70, 220}, extent = {{-40, -10}, {40, 10}}, rotation = -90)));
  Bus bus_10121_ATTLEE_G1 annotation(
    Placement(visible = true, transformation(origin = {-110, 250}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_122_AUBREY annotation(
    Placement(visible = true, transformation(origin = {170, 200}, extent = {{-70, -10}, {70, 10}}, rotation = -90)));
  Bus bus_10122_AUBREY_G1 annotation(
    Placement(visible = true, transformation(origin = {130, 230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_20122_AUBREY_G2 annotation(
    Placement(visible = true, transformation(origin = {130, 190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_30122_AUBREY_G3 annotation(
    Placement(visible = true, transformation(origin = {210, 260}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_40122_AUBREY_G4 annotation(
    Placement(visible = true, transformation(origin = {210, 220}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_50122_AUBREY_G5 annotation(
    Placement(visible = true, transformation(origin = {210, 180}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_60122_AUBREY_G6 annotation(
    Placement(visible = true, transformation(origin = {210, 140}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_123_AUSTEN annotation(
    Placement(visible = true, transformation(origin = {210, 70}, extent = {{-50, -10}, {50, 10}}, rotation = -90)));
  Bus bus_10123_AUSTEN_G1 annotation(
    Placement(visible = true, transformation(origin = {250, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_20123_AUSTEN_G2 annotation(
    Placement(visible = true, transformation(origin = {250, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_30123_AUSTEN_G3 annotation(
    Placement(visible = true, transformation(origin = {250, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Bus bus_124_AVERY annotation(
    Placement(visible = true, transformation(origin = {-150, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Line line_101_102( BPu=0.461 / 2, GPu = 0,RPu=0.003, XPu=0.014) annotation(
    Placement(visible = true, transformation(origin = {-84, -190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Line line_101_103( BPu=0.057 / 2, GPu = 0,RPu=0.055, XPu= 0.211) annotation(
    Placement(visible = true, transformation(origin = {-160, -122}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Line line_101_105( BPu=0.023 / 2, GPu = 0,RPu=0.022, XPu=0.085) annotation(
    Placement(visible = true, transformation(origin = {-30, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_102_104( BPu=0.034 / 2, GPu = 0,RPu=0.033, XPu=0.127) annotation(
    Placement(visible = true, transformation(origin = {-60, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Line line_102_106( BPu=0.052 / 2, GPu = 0,RPu=0.05, XPu=0.192) annotation(
    Placement(visible = true, transformation(origin = {80, -190}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Line line_103_109( BPu=0.032 / 2, GPu = 0,RPu=0.031, XPu=0.119) annotation(
    Placement(visible = true, transformation(origin = {-120, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_104_109( BPu=0.028 / 2, GPu = 0,RPu=0.027, XPu=0.104) annotation(
    Placement(visible = true, transformation(origin = {-60, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Line line_105_110( BPu=0.024 / 2, GPu = 0,RPu=0.023, XPu=0.088) annotation(
    Placement(visible = true, transformation(origin = {10, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Line line_106_110( BPu=2.459 / 2, GPu = 0,RPu=0.014, XPu=0.061) annotation(
    Placement(visible = true, transformation(origin = {54, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Line line_107_108a( BPu=0.0085 / 2, GPu = 0,RPu=0.008, XPu=0.03) annotation(
    Placement(visible = true, transformation(origin = {170, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Line line_107_108b( BPu=0.0085 / 2, GPu = 0,RPu=0.008, XPu=0.03) annotation(
    Placement(visible = true, transformation(origin = {170, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Line line_108_109( BPu=0.045 / 2, GPu = 0,RPu=0.043, XPu=0.165) annotation(
    Placement(visible = true, transformation(origin = {30, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Line line_108_110( BPu=0.045 / 2, GPu = 0,RPu=0.043, XPu=0.165) annotation(
    Placement(visible = true, transformation(origin = {90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Line line_111_113( BPu=0.1 / 2, GPu = 0,RPu=0.006, XPu=0.048) annotation(
    Placement(visible = true, transformation(origin = {70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_111_114( BPu=0.088 / 2, GPu = 0,RPu=0.005, XPu=0.042) annotation(
    Placement(visible = true, transformation(origin = {-70, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_112_113( BPu=0.1 / 2, GPu = 0,RPu=0.006, XPu=0.048) annotation(
    Placement(visible = true, transformation(origin = {70, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_112_123( BPu=0.203 / 2, GPu = 0,RPu=0.012, XPu=0.097) annotation(
    Placement(visible = true, transformation(origin = {70, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_113_123( BPu=0.182 / 2, GPu = 0,RPu=0.011, XPu=0.087) annotation(
    Placement(visible = true, transformation(origin = {170, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_114_116( BPu=0.082 / 2, GPu = 0,RPu=0.005, XPu=0.059) annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Line line_115_116( BPu=0.036 / 2, GPu = 0,RPu=0.002, XPu=0.017) annotation(
    Placement(visible = true, transformation(origin = {-140, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_115_121a( BPu=0.103 / 2, GPu = 0,RPu=0.006, XPu=0.049) annotation(
    Placement(visible = true, transformation(origin = {-130, 210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_115_121b( BPu=0.103 / 2, GPu = 0,RPu=0.006, XPu=0.049) annotation(
    Placement(visible = true, transformation(origin = {-130, 190}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_115_124( BPu=0.109 / 2, GPu = 0,RPu=0.007, XPu=0.052) annotation(
    Placement(visible = true, transformation(origin = {-170, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_116_117( BPu=0.055 / 2, GPu = 0,RPu=0.003, XPu=0.026) annotation(
    Placement(visible = true, transformation(origin = {-20, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_116_119( BPu=0.049 / 2, GPu = 0,RPu=0.003, XPu=0.023) annotation(
    Placement(visible = true, transformation(origin = {-20, 116}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_117_118( BPu=0.03 / 2, GPu = 0,RPu=0.002, XPu=0.014) annotation(
    Placement(visible = true, transformation(origin = {50, 164}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Line line_117_122( BPu=0.221 / 2, GPu = 0,RPu=0.014, XPu=0.105) annotation(
    Placement(visible = true, transformation(origin = {120, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_118_121a( BPu=0.055 / 2, GPu = 0,RPu=0.003, XPu=0.026) annotation(
    Placement(visible = true, transformation(origin = {-20, 210}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Line line_118_121b( BPu=0.055 / 2, GPu = 0,RPu=0.003, XPu=0.026) annotation(
    Placement(visible = true, transformation(origin = {-20, 190}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Line line_119_120a( BPu=0.083 / 2, GPu = 0,RPu=0.005, XPu=0.04) annotation(
    Placement(visible = true, transformation(origin = {70, 116}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_119_120b( BPu=0.083 / 2, GPu = 0,RPu=0.005, XPu=0.04) annotation(
    Placement(visible = true, transformation(origin = {70, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_120_123a( BPu=0.046 / 2, GPu = 0,RPu=0.003, XPu=0.022) annotation(
    Placement(visible = true, transformation(origin = {160, 116}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_120_123b( BPu=0.046 / 2, GPu = 0,RPu=0.003, XPu=0.022) annotation(
    Placement(visible = true, transformation(origin = {160, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Line line_121_122( BPu=0.142 / 2, GPu = 0,RPu=0.009, XPu=0.068) annotation(
    Placement(visible = true, transformation(origin = {50, 250}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(line_101_102.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-84, -180}, {-84, -170}, {-170, -170}}, color = {0, 0, 255}));
  connect(line_101_102.terminal2, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-84, -200}, {-84, -210}, {0, -210}}, color = {0, 0, 255}));
  connect(line_101_103.terminal2, bus_103_ADLER.terminal) annotation(
    Line(points = {{-160, -112}, {-160, -70}}, color = {0, 0, 255}));
  connect(line_101_103.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-160, -132}, {-160, -170}, {-170, -170}}, color = {0, 0, 255}));
  connect(line_101_105.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-40, -150}, {-84, -150}, {-84, -170}, {-170, -170}}, color = {0, 0, 255}));
  connect(line_101_105.terminal2, bus_105_AIKEN.terminal) annotation(
    Line(points = {{-20, -150}, {0, -150}, {0, -170}, {10, -170}}, color = {0, 0, 255}));
  connect(line_102_104.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-60, -180}, {-60, -210}, {0, -210}}, color = {0, 0, 255}));
  connect(line_102_104.terminal2, bus_104_AGRICOLA.terminal) annotation(
    Line(points = {{-60, -160}, {-60, -110}}, color = {0, 0, 255}));
  connect(line_102_106.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{80, -200}, {80, -210}, {0, -210}}, color = {0, 0, 255}));
  connect(line_102_106.terminal2, bus_106_ALBER.terminal) annotation(
    Line(points = {{80, -180}, {80, -170}}, color = {0, 0, 255}));
  connect(line_103_109.terminal1, bus_103_ADLER.terminal) annotation(
    Line(points = {{-130, -50}, {-140, -50}, {-140, -70}, {-160, -70}}, color = {0, 0, 255}));
  connect(line_103_109.terminal2, bus_109_ALI.terminal) annotation(
    Line(points = {{-110, -50}, {-94, -50}, {-94, -70}, {-70, -70}}, color = {0, 0, 255}));
  connect(line_104_109.terminal1, bus_104_AGRICOLA.terminal) annotation(
    Line(points = {{-60, -100}, {-60, -110}}, color = {0, 0, 255}));
  connect(line_104_109.terminal2, bus_109_ALI.terminal) annotation(
    Line(points = {{-60, -80}, {-60, -70}, {-70, -70}}, color = {0, 0, 255}));
  connect(line_105_110.terminal1, bus_105_AIKEN.terminal) annotation(
    Line(points = {{10, -120}, {10, -170}}, color = {0, 0, 255}));
  connect(line_105_110.terminal2, bus_110_ALLEN.terminal) annotation(
    Line(points = {{10, -100}, {10, -70}, {30, -70}}, color = {0, 0, 255}));
  connect(line_106_110.terminal1, bus_106_ALBER.terminal) annotation(
    Line(points = {{54, -120}, {54, -170}, {80, -170}}, color = {0, 0, 255}));
  connect(line_106_110.terminal2, bus_110_ALLEN.terminal) annotation(
    Line(points = {{54, -100}, {54, -70}, {30, -70}}, color = {0, 0, 255}));
  connect(line_107_108a.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{180, -110}, {210, -110}, {210, -150}}, color = {0, 0, 255}));
  connect(line_107_108a.terminal2, bus_108_ALGER.terminal) annotation(
    Line(points = {{160, -110}, {130, -110}, {130, -130}}, color = {0, 0, 255}));
  connect(line_107_108b.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{180, -130}, {210, -130}, {210, -150}}, color = {0, 0, 255}));
  connect(line_107_108b.terminal2, bus_108_ALGER.terminal) annotation(
    Line(points = {{160, -130}, {130, -130}}, color = {0, 0, 255}));
  connect(line_108_109.terminal1, bus_108_ALGER.terminal) annotation(
    Line(points = {{40, -130}, {130, -130}}, color = {0, 0, 255}));
  connect(line_108_109.terminal2, bus_109_ALI.terminal) annotation(
    Line(points = {{20, -130}, {-20, -130}, {-20, -90}, {-50, -90}, {-50, -70}, {-70, -70}}, color = {0, 0, 255}));
  connect(line_108_110.terminal1, bus_108_ALGER.terminal) annotation(
    Line(points = {{100, -110}, {130, -110}, {130, -130}}, color = {0, 0, 255}));
  connect(line_111_113.terminal1, bus_111_ANNA.terminal) annotation(
    Line(points = {{60, 30}, {-74, 30}, {-74, -10}, {-80, -10}}, color = {0, 0, 255}));
  connect(line_111_113.terminal2, bus_113_ARNE.terminal) annotation(
    Line(points = {{80, 30}, {130, 30}, {130, -20}}, color = {0, 0, 255}));
  connect(line_111_114.terminal1, bus_111_ANNA.terminal) annotation(
    Line(points = {{-80, 44}, {-92, 44}, {-92, -10}, {-80, -10}}, color = {0, 0, 255}));
  connect(line_111_114.terminal2, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-60, 44}, {-50, 44}, {-50, 70}}, color = {0, 0, 255}));
  connect(line_112_113.terminal1, bus_112_ARCHER.terminal) annotation(
    Line(points = {{60, 10}, {32, 10}, {32, -8}, {20, -8}}, color = {0, 0, 255}));
  connect(line_112_113.terminal2, bus_113_ARNE.terminal) annotation(
    Line(points = {{80, 10}, {130, 10}, {130, -20}}, color = {0, 0, 255}));
  connect(line_112_123.terminal1, bus_112_ARCHER.terminal) annotation(
    Line(points = {{60, 48}, {12, 48}, {12, -8}, {20, -8}}, color = {0, 0, 255}));
  connect(line_112_123.terminal2, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{80, 48}, {210, 48}, {210, 70}}, color = {0, 0, 255}));
  connect(line_113_123.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{160, 30}, {130, 30}, {130, -20}}, color = {0, 0, 255}));
  connect(line_113_123.terminal2, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{180, 30}, {210, 30}, {210, 70}}, color = {0, 0, 255}));
  connect(line_108_110.terminal2, bus_110_ALLEN.terminal) annotation(
    Line(points = {{80, -110}, {66, -110}, {66, -70}, {30, -70}}, color = {0, 0, 255}));
  connect(line_114_116.terminal1, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-60, 60}, {-50, 60}, {-50, 70}}, color = {0, 0, 255}));
  connect(line_114_116.terminal2, bus_116_ASSER.terminal) annotation(
    Line(points = {{-80, 60}, {-90, 60}, {-90, 94}}, color = {0, 0, 255}));
  connect(line_115_121a.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-140, 210}, {-190, 210}, {-190, 150}}, color = {0, 0, 255}));
  connect(line_115_121a.terminal2, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-120, 210}, {-70, 210}, {-70, 220}}, color = {0, 0, 255}));
  connect(line_115_121b.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-140, 190}, {-190, 190}, {-190, 150}}, color = {0, 0, 255}));
  connect(line_115_121b.terminal2, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-120, 190}, {-70, 190}, {-70, 220}}, color = {0, 0, 255}));
  connect(line_115_116.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-150, 60}, {-190, 60}, {-190, 150}}, color = {0, 0, 255}));
  connect(line_115_116.terminal2, bus_116_ASSER.terminal) annotation(
    Line(points = {{-130, 60}, {-90, 60}, {-90, 94}}, color = {0, 0, 255}));
  connect(line_115_124.terminal2, bus_124_AVERY.terminal) annotation(
    Line(points = {{-160, 50}, {-150, 50}, {-150, -10}}, color = {0, 0, 255}));
  connect(line_115_124.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, 50}, {-190, 50}, {-190, 150}}, color = {0, 0, 255}));
  connect(line_116_117.terminal1, bus_116_ASSER.terminal) annotation(
    Line(points = {{-30, 130}, {-90, 130}, {-90, 94}}, color = {0, 0, 255}));
  connect(line_116_117.terminal2, bus_117_ASTON.terminal) annotation(
    Line(points = {{-10, 130}, {70, 130}, {70, 154}}, color = {0, 0, 255}));
  connect(line_116_119.terminal1, bus_116_ASSER.terminal) annotation(
    Line(points = {{-30, 116}, {-90, 116}, {-90, 94}}, color = {0, 0, 255}));
  connect(line_116_119.terminal2, bus_119_ATTAR.terminal) annotation(
    Line(points = {{-10, 116}, {30, 116}, {30, 90}}, color = {0, 0, 255}));
  connect(line_117_118.terminal1, bus_117_ASTON.terminal) annotation(
    Line(points = {{60, 164}, {70, 164}, {70, 154}}, color = {0, 0, 255}));
  connect(line_117_118.terminal2, bus_118_ASTOR.terminal) annotation(
    Line(points = {{40, 164}, {28, 164}, {28, 180}}, color = {0, 0, 255}));
  connect(line_117_122.terminal1, bus_117_ASTON.terminal) annotation(
    Line(points = {{110, 140}, {70, 140}, {70, 154}}, color = {0, 0, 255}));
  connect(line_117_122.terminal2, bus_122_AUBREY.terminal) annotation(
    Line(points = {{130, 140}, {170, 140}, {170, 200}}, color = {0, 0, 255}));
  connect(line_118_121a.terminal1, bus_118_ASTOR.terminal) annotation(
    Line(points = {{-10, 210}, {28, 210}, {28, 180}}, color = {0, 0, 255}));
  connect(line_118_121a.terminal2, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-30, 210}, {-70, 210}, {-70, 220}}, color = {0, 0, 255}));
  connect(line_118_121b.terminal1, bus_118_ASTOR.terminal) annotation(
    Line(points = {{-10, 190}, {28, 190}, {28, 180}}, color = {0, 0, 255}));
  connect(line_118_121b.terminal2, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-30, 190}, {-70, 190}, {-70, 220}}, color = {0, 0, 255}));
  connect(line_119_120a.terminal1, bus_119_ATTAR.terminal) annotation(
    Line(points = {{60, 116}, {30, 116}, {30, 90}}, color = {0, 0, 255}));
  connect(line_119_120b.terminal1, bus_119_ATTAR.terminal) annotation(
    Line(points = {{60, 100}, {30, 100}, {30, 90}}, color = {0, 0, 255}));
  connect(line_119_120a.terminal2, bus_120_ATTILA.terminal) annotation(
    Line(points = {{80, 116}, {110, 116}, {110, 90}}, color = {0, 0, 255}));
  connect(line_119_120b.terminal2, bus_120_ATTILA.terminal) annotation(
    Line(points = {{80, 100}, {110, 100}, {110, 90}}, color = {0, 0, 255}));
  connect(line_120_123a.terminal1, bus_120_ATTILA.terminal) annotation(
    Line(points = {{150, 116}, {110, 116}, {110, 90}}, color = {0, 0, 255}));
  connect(line_120_123b.terminal1, bus_120_ATTILA.terminal) annotation(
    Line(points = {{150, 100}, {110, 100}, {110, 90}}, color = {0, 0, 255}));
  connect(line_120_123a.terminal2, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{170, 116}, {210, 116}, {210, 70}}, color = {0, 0, 255}));
  connect(line_120_123b.terminal2, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{170, 100}, {210, 100}, {210, 70}}, color = {0, 0, 255}));
  connect(line_121_122.terminal1, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{40, 250}, {-70, 250}, {-70, 220}}, color = {0, 0, 255}));
  connect(line_121_122.terminal2, bus_122_AUBREY.terminal) annotation(
    Line(points = {{60, 250}, {170, 250}, {170, 200}}, color = {0, 0, 255}));
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
  line_106_110.switchOffSignal1.value = false;
  line_106_110.switchOffSignal2.value = false;
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
  
  annotation(
    Diagram(coordinateSystem(extent = {{-300, -300}, {300, 300}})),
    Icon(coordinateSystem(extent = {{-300, -300}, {300, 300}})));
end Network;
