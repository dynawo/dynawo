within Dynawo.Examples.RVS.Grid.BaseClasses;

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

model NetworkWithTrfRestorative "RVS test grid with buses, lines, shunts, restorative loads and transformers"
  import Dynawo.Examples.RVS.Components.TransformerWithControl.BaseClasses.TransformerParameters;

  extends NetworkWithRestorativeLoads;

  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10121_121(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 471, XPu = 0.15 * 100 / 471, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-114, 282}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10118_118(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 471, XPu = 0.15 * 100 / 471, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-14, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-224, 212}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-224, 172}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_60115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-224, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_50115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-224, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-224, 252}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-224, 292}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10114_114(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 200, XPu = 0.15 * 100 / 200, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-26, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10116_116(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-106, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-168, -226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-128, -226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-248, -226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-208, -226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-4, -266}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {36, -266}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-44, -266}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {76, -266}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10106_106(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 120, XPu = 0.15 * 100 / 120, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {132, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 308}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {206, 238}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_50122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 228}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 268}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_60122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 188}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {206, 278}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 412, XPu = 0.15 * 100 / 412, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 146}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {146, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {146, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {146, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {256, -214}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {256, -174}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {256, -134}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1101_101(P10Pu = -P0Pu_load_1101_ABEL, Q10Pu = -Q0Pu_load_1101_ABEL, U10Pu = U0Pu_load_1101_ABEL, U1Phase0 = UPhase0_load_1101_ABEL, tfo = TransformerParameters.tfoPreset.trafo_1101_101) annotation(
    Placement(visible = true, transformation(origin = {-248, -186}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1102_102(P10Pu = -P0Pu_load_1102_ADAMS, Q10Pu = -Q0Pu_load_1102_ADAMS, U10Pu = U0Pu_load_1102_ADAMS, U1Phase0 = UPhase0_load_1102_ADAMS, tfo = TransformerParameters.tfoPreset.trafo_1102_102) annotation(
    Placement(visible = true, transformation(origin = {-74, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1103_103(P10Pu = -P0Pu_load_1103_ADLER, Q10Pu = -Q0Pu_load_1103_ADLER, U10Pu = U0Pu_load_1103_ADLER, U1Phase0 = UPhase0_load_1103_ADLER, tfo = TransformerParameters.tfoPreset.trafo_1103_103) annotation(
    Placement(visible = true, transformation(origin = {-208, -126}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1104_104(P10Pu = -P0Pu_load_1104_AGRICOLA, Q10Pu = -Q0Pu_load_1104_AGRICOLA, U10Pu = U0Pu_load_1104_AGRICOLA, U1Phase0 = UPhase0_load_1104_AGRICOLA, tfo = TransformerParameters.tfoPreset.trafo_1104_104) annotation(
    Placement(visible = true, transformation(origin = {-80, -168}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1105_105(P10Pu = -P0Pu_load_1105_AIKEN, Q10Pu = -Q0Pu_load_1105_AIKEN, U10Pu = U0Pu_load_1105_AIKEN, U1Phase0 = UPhase0_load_1105_AIKEN, tfo = TransformerParameters.tfoPreset.trafo_1105_105) annotation(
    Placement(visible = true, transformation(origin = {8, -224}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1106_106(P10Pu = -P0Pu_load_1106_ALBER, Q10Pu = -Q0Pu_load_1106_ALBER, U10Pu = U0Pu_load_1106_ALBER, U1Phase0 = UPhase0_load_1106_ALBER, tfo = TransformerParameters.tfoPreset.trafo_1106_106) annotation(
    Placement(visible = true, transformation(origin = {132, -266}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1107_107(P10Pu = -P0Pu_load_1107_ALDER, Q10Pu = -Q0Pu_load_1107_ALDER, U10Pu = U0Pu_load_1107_ALDER, U1Phase0 = UPhase0_load_1107_ALDER, tfo = TransformerParameters.tfoPreset.trafo_1107_107) annotation(
    Placement(visible = true, transformation(origin = {216, -214}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1108_108(P10Pu = -P0Pu_load_1108_ALGER, Q10Pu = -Q0Pu_load_1108_ALGER, U10Pu = U0Pu_load_1108_ALGER, U1Phase0 = UPhase0_load_1108_ALGER, tfo = TransformerParameters.tfoPreset.trafo_1108_108) annotation(
    Placement(visible = true, transformation(origin = {176, -174}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1109_109(P10Pu = -P0Pu_load_1109_ALI, Q10Pu = -Q0Pu_load_1109_ALI, U10Pu = U0Pu_load_1109_ALI, U1Phase0 = UPhase0_load_1109_ALI, tfo = TransformerParameters.tfoPreset.trafo_1109_109) annotation(
    Placement(visible = true, transformation(origin = {-80, -128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1110_110(P10Pu = -P0Pu_load_1110_ALLEN, Q10Pu = -Q0Pu_load_1110_ALLEN, U10Pu = U0Pu_load_1110_ALLEN, U1Phase0 = UPhase0_load_1110_ALLEN, tfo = TransformerParameters.tfoPreset.trafo_1110_110) annotation(
    Placement(visible = true, transformation(origin = {46, -74}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1113_113(P10Pu = -P0Pu_load_1113_ARNE, Q10Pu = -Q0Pu_load_1113_ARNE, U10Pu = U0Pu_load_1113_ARNE, U1Phase0 = UPhase0_load_1113_ARNE, tfo = TransformerParameters.tfoPreset.trafo_1113_113) annotation(
    Placement(visible = true, transformation(origin = {106, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1114_114(P10Pu = -P0Pu_load_1114_ARNOLD, Q10Pu = -Q0Pu_load_1114_ARNOLD, U10Pu = U0Pu_load_1114_ARNOLD, U1Phase0 = UPhase0_load_1114_ARNOLD, tfo = TransformerParameters.tfoPreset.trafo_1114_114) annotation(
    Placement(visible = true, transformation(origin = {-26, 84}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1115_115(P10Pu = -P0Pu_load_1115_ARTHUR, Q10Pu = -Q0Pu_load_1115_ARTHUR, U10Pu = U0Pu_load_1115_ARTHUR, U1Phase0 = UPhase0_load_1115_ARTHUR, tfo = TransformerParameters.tfoPreset.trafo_1115_115) annotation(
    Placement(visible = true, transformation(origin = {-184, 164}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1116_116(P10Pu = -P0Pu_load_1116_ASSER, Q10Pu = -Q0Pu_load_1116_ASSER, U10Pu = U0Pu_load_1116_ASSER, U1Phase0 = UPhase0_load_1116_ASSER, tfo = TransformerParameters.tfoPreset.trafo_1116_116) annotation(
    Placement(visible = true, transformation(origin = {-104, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1118_118(P10Pu = -P0Pu_load_1118_ASTOR, Q10Pu = -Q0Pu_load_1118_ASTOR, U10Pu = U0Pu_load_1118_ASTOR, U1Phase0 = UPhase0_load_1118_ASTOR, tfo = TransformerParameters.tfoPreset.trafo_1118_118) annotation(
    Placement(visible = true, transformation(origin = {26, 260}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1119_119(P10Pu = -P0Pu_load_1119_ATTAR, Q10Pu = -Q0Pu_load_1119_ATTAR, U10Pu = U0Pu_load_1119_ATTAR, U1Phase0 = UPhase0_load_1119_ATTAR, tfo = TransformerParameters.tfoPreset.trafo_1119_119) annotation(
    Placement(visible = true, transformation(origin = {66, 106}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.TransformerWithControl.TransformerWithControl tfo_1120_120(P10Pu = -P0Pu_load_1120_ATTILA, Q10Pu = -Q0Pu_load_1120_ATTILA, U10Pu = U0Pu_load_1120_ATTILA, U1Phase0 = UPhase0_load_1120_ATTILA, tfo = TransformerParameters.tfoPreset.trafo_1120_120) annotation(
    Placement(visible = true, transformation(origin = {146, 106}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap tfo_103_124(B = 0, G = 0, NbTap = 33, R = 0.008 * 100 * 0.8212890625, SNom = 400, Tap0 = 1, X = 0.336 * 100 * 0.8212890625, rTfo0Pu = 1 - 0.1 * (16 - 1) / 16, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-168, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap tfo_109_111(B = 0, G = 0, NbTap = 33, R = 0.008 * 100 * 0.950625, SNom = 400, Tap0 = 12, X = 0.336 * 100 * 0.950625, rTfo0Pu = 1 - 0.1 * (16 - 12) / 16, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-74, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap tfo_109_112(B = 0, G = 0, NbTap = 33, R = 0.008 * 100 * 0.81, SNom = 400, Tap0 = 0, X = 0.336 * 100 * 0.81, rTfo0Pu = 1 - 0.1 * (16 - 0) / 16, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-24, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap tfo_110_111(B = 0, G = 0, NbTap = 33, R = 0.008 * 100 * 0.9628515625, SNom = 400, Tap0 = 13, X = 0.336 * 100 * 0.9628515625, rTfo0Pu = 1 - 0.1 * (16 - 13) / 16, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-24, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap tfo_110_112(B = 0, G = 0, NbTap = 33, R = 0.008 * 100 * 0.950625, SNom = 400, Tap0 = 12, X = 0.336 * 100 * 0.950625, rTfo0Pu = 1 - 0.1 * (16 - 12) / 16, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {28, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  when time >= 0 then
    tfo_103_124.tap.value = tfo_103_124.Tap0;
    tfo_109_111.tap.value = tfo_109_111.Tap0;
    tfo_109_112.tap.value = tfo_109_112.Tap0;
    tfo_110_111.tap.value = tfo_110_111.Tap0;
    tfo_110_112.tap.value = tfo_110_112.Tap0;
  end when;

  tfo_1101_101.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1101_101.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1101_101.tapChanger.switchOffSignal1.value = false;
  tfo_1101_101.tapChanger.switchOffSignal2.value = false;
  tfo_10101_101.switchOffSignal1.value = false;
  tfo_10101_101.switchOffSignal2.value = false;
  tfo_20101_101.switchOffSignal1.value = false;
  tfo_20101_101.switchOffSignal2.value = false;
  tfo_30101_101.switchOffSignal1.value = false;
  tfo_30101_101.switchOffSignal2.value = false;
  tfo_40101_101.switchOffSignal1.value = false;
  tfo_40101_101.switchOffSignal2.value = false;
  tfo_1102_102.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1102_102.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1102_102.tapChanger.switchOffSignal1.value = false;
  tfo_1102_102.tapChanger.switchOffSignal2.value = false;
  tfo_10102_102.switchOffSignal1.value = false;
  tfo_10102_102.switchOffSignal2.value = false;
  tfo_20102_102.switchOffSignal1.value = false;
  tfo_20102_102.switchOffSignal2.value = false;
  tfo_30102_102.switchOffSignal1.value = false;
  tfo_30102_102.switchOffSignal2.value = false;
  tfo_40102_102.switchOffSignal1.value = false;
  tfo_40102_102.switchOffSignal2.value = false;
  tfo_1103_103.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1103_103.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1103_103.tapChanger.switchOffSignal1.value = false;
  tfo_1103_103.tapChanger.switchOffSignal2.value = false;
  tfo_103_124.switchOffSignal1.value = false;
  tfo_103_124.switchOffSignal2.value = false;
  tfo_1104_104.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1104_104.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1104_104.tapChanger.switchOffSignal1.value = false;
  tfo_1104_104.tapChanger.switchOffSignal2.value = false;
  tfo_1105_105.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1105_105.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1105_105.tapChanger.switchOffSignal1.value = false;
  tfo_1105_105.tapChanger.switchOffSignal2.value = false;
  tfo_1106_106.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1106_106.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1106_106.tapChanger.switchOffSignal1.value = false;
  tfo_1106_106.tapChanger.switchOffSignal2.value = false;
  tfo_10106_106.switchOffSignal1.value = false;
  tfo_10106_106.switchOffSignal2.value = false;
  tfo_1107_107.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1107_107.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1107_107.tapChanger.switchOffSignal1.value = false;
  tfo_1107_107.tapChanger.switchOffSignal2.value = false;
  tfo_10107_107.switchOffSignal1.value = false;
  tfo_10107_107.switchOffSignal2.value = false;
  tfo_20107_107.switchOffSignal1.value = false;
  tfo_20107_107.switchOffSignal2.value = false;
  tfo_30107_107.switchOffSignal1.value = false;
  tfo_30107_107.switchOffSignal2.value = false;
  tfo_1108_108.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1108_108.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1108_108.tapChanger.switchOffSignal1.value = false;
  tfo_1108_108.tapChanger.switchOffSignal2.value = false;
  tfo_1109_109.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1109_109.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1109_109.tapChanger.switchOffSignal1.value = false;
  tfo_1109_109.tapChanger.switchOffSignal2.value = false;
  tfo_109_111.switchOffSignal1.value = false;
  tfo_109_111.switchOffSignal2.value = false;
  tfo_109_112.switchOffSignal1.value = false;
  tfo_109_112.switchOffSignal2.value = false;
  tfo_110_111.switchOffSignal1.value = false;
  tfo_110_111.switchOffSignal2.value = false;
  tfo_110_112.switchOffSignal1.value = false;
  tfo_110_112.switchOffSignal2.value = false;
  tfo_1110_110.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1110_110.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1110_110.tapChanger.switchOffSignal1.value = false;
  tfo_1110_110.tapChanger.switchOffSignal2.value = false;
  tfo_1113_113.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1113_113.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1113_113.tapChanger.switchOffSignal1.value = false;
  tfo_1113_113.tapChanger.switchOffSignal2.value = false;
  tfo_10113_113.switchOffSignal1.value = false;
  tfo_10113_113.switchOffSignal2.value = false;
  tfo_20113_113.switchOffSignal1.value = false;
  tfo_20113_113.switchOffSignal2.value = false;
  tfo_30113_113.switchOffSignal1.value = false;
  tfo_30113_113.switchOffSignal2.value = false;
  tfo_1114_114.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1114_114.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1114_114.tapChanger.switchOffSignal1.value = false;
  tfo_1114_114.tapChanger.switchOffSignal2.value = false;
  tfo_10114_114.switchOffSignal1.value = false;
  tfo_10114_114.switchOffSignal2.value = false;
  tfo_1115_115.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1115_115.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1115_115.tapChanger.switchOffSignal1.value = false;
  tfo_1115_115.tapChanger.switchOffSignal2.value = false;
  tfo_10115_115.switchOffSignal1.value = false;
  tfo_10115_115.switchOffSignal2.value = false;
  tfo_20115_115.switchOffSignal1.value = false;
  tfo_20115_115.switchOffSignal2.value = false;
  tfo_30115_115.switchOffSignal1.value = false;
  tfo_30115_115.switchOffSignal2.value = false;
  tfo_40115_115.switchOffSignal1.value = false;
  tfo_40115_115.switchOffSignal2.value = false;
  tfo_50115_115.switchOffSignal1.value = false;
  tfo_50115_115.switchOffSignal2.value = false;
  tfo_60115_115.switchOffSignal1.value = false;
  tfo_60115_115.switchOffSignal2.value = false;
  tfo_1116_116.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1116_116.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1116_116.tapChanger.switchOffSignal1.value = false;
  tfo_1116_116.tapChanger.switchOffSignal2.value = false;
  tfo_10116_116.switchOffSignal1.value = false;
  tfo_10116_116.switchOffSignal2.value = false;
  tfo_1118_118.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1118_118.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1118_118.tapChanger.switchOffSignal1.value = false;
  tfo_1118_118.tapChanger.switchOffSignal2.value = false;
  tfo_10118_118.switchOffSignal1.value = false;
  tfo_10118_118.switchOffSignal2.value = false;
  tfo_1119_119.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1119_119.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1119_119.tapChanger.switchOffSignal1.value = false;
  tfo_1119_119.tapChanger.switchOffSignal2.value = false;
  tfo_1120_120.tfoVariableTap.switchOffSignal1.value = false;
  tfo_1120_120.tfoVariableTap.switchOffSignal2.value = false;
  tfo_1120_120.tapChanger.switchOffSignal1.value = false;
  tfo_1120_120.tapChanger.switchOffSignal2.value = false;
  tfo_10121_121.switchOffSignal1.value = false;
  tfo_10121_121.switchOffSignal2.value = false;
  tfo_10122_122.switchOffSignal1.value = false;
  tfo_10122_122.switchOffSignal2.value = false;
  tfo_20122_122.switchOffSignal1.value = false;
  tfo_20122_122.switchOffSignal2.value = false;
  tfo_30122_122.switchOffSignal1.value = false;
  tfo_30122_122.switchOffSignal2.value = false;
  tfo_40122_122.switchOffSignal1.value = false;
  tfo_40122_122.switchOffSignal2.value = false;
  tfo_50122_122.switchOffSignal1.value = false;
  tfo_50122_122.switchOffSignal2.value = false;
  tfo_60122_122.switchOffSignal1.value = false;
  tfo_60122_122.switchOffSignal2.value = false;
  tfo_10123_123.switchOffSignal1.value = false;
  tfo_10123_123.switchOffSignal2.value = false;
  tfo_20123_123.switchOffSignal1.value = false;
  tfo_20123_123.switchOffSignal2.value = false;
  tfo_30123_123.switchOffSignal1.value = false;
  tfo_30123_123.switchOffSignal2.value = false;

  connect(tfo_10121_121.terminal1, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-104, 282}, {-94, 282}, {-94, 262}}, color = {0, 0, 255}));
  connect(tfo_10121_121.terminal2, bus_10121_ATTLEE_G1.terminal) annotation(
    Line(points = {{-124, 282}, {-134, 282}}, color = {0, 0, 255}));
  connect(tfo_1118_118.terminal1, bus_1118_ASTOR.terminal) annotation(
    Line(points = {{36, 260}, {46, 260}}, color = {0, 0, 255}));
  connect(tfo_1118_118.terminal2, bus_118_ASTOR.terminal) annotation(
    Line(points = {{16, 260}, {6, 260}, {6, 230}}, color = {0, 0, 255}));
  connect(tfo_10118_118.terminal1, bus_118_ASTOR.terminal) annotation(
    Line(points = {{-4, 200}, {6, 200}, {6, 230}}, color = {0, 0, 255}));
  connect(tfo_10118_118.terminal2, bus_10118_ASTOR_G1.terminal) annotation(
    Line(points = {{-24, 200}, {-34, 200}}, color = {0, 0, 255}));
  connect(tfo_10115_115.terminal2, bus_10115_ARTHUR_G1.terminal) annotation(
    Line(points = {{-234, 292}, {-244, 292}}, color = {0, 0, 255}));
  connect(tfo_10115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-214, 292}, {-204, 292}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_20115_115.terminal2, bus_20115_ARTHUR_G2.terminal) annotation(
    Line(points = {{-234, 252}, {-244, 252}}, color = {0, 0, 255}));
  connect(tfo_20115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-214, 252}, {-204, 252}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_30115_115.terminal2, bus_30115_ARTHUR_G3.terminal) annotation(
    Line(points = {{-234, 212}, {-244, 212}}, color = {0, 0, 255}));
  connect(tfo_30115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-214, 212}, {-204, 212}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_40115_115.terminal2, bus_40115_ARTHUR_G4.terminal) annotation(
    Line(points = {{-234, 172}, {-244, 172}}, color = {0, 0, 255}));
  connect(tfo_40115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-214, 172}, {-204, 172}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_1115_115.terminal1, bus_1115_ARTHUR.terminal) annotation(
    Line(points = {{-176, 164}, {-164, 164}}, color = {0, 0, 255}));
  connect(tfo_1115_115.terminal2, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-196, 164}, {-204, 164}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_10114_114.terminal1, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-36, 124}, {-44, 124}, {-44, 110}}, color = {0, 0, 255}));
  connect(tfo_10114_114.terminal2, bus_10114_ARNOLD_SVC.terminal) annotation(
    Line(points = {{-16, 124}, {-6, 124}}, color = {0, 0, 255}));
  connect(tfo_10116_116.terminal2, bus_10116_ASSER_G1.terminal) annotation(
    Line(points = {{-116, 144}, {-124, 144}}, color = {0, 0, 255}));
  connect(tfo_1116_116.terminal1, bus_1116_ASSER.terminal) annotation(
    Line(points = {{-114, 124}, {-124, 124}}, color = {0, 0, 255}));
  connect(tfo_10116_116.terminal1, bus_116_ASSER.terminal) annotation(
    Line(points = {{-96, 144}, {-84, 144}, {-84, 134}}, color = {0, 0, 255}));
  connect(tfo_1116_116.terminal2, bus_116_ASSER.terminal) annotation(
    Line(points = {{-94, 124}, {-94, 134}, {-84, 134}}, color = {0, 0, 255}));
  connect(tfo_1114_114.terminal2, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-36, 84}, {-44, 84}, {-44, 110}}, color = {0, 0, 255}));
  connect(tfo_1114_114.terminal1, bus_1114_ARNOLD.terminal) annotation(
    Line(points = {{-16, 84}, {-6, 84}}, color = {0, 0, 255}));
  connect(tfo_103_124.terminal2, bus_124_AVERY.terminal) annotation(
    Line(points = {{-168, 26}, {-168, 36}}, color = {0, 0, 255}));
  connect(tfo_1103_103.terminal1, bus_1103_ADLER.terminal) annotation(
    Line(points = {{-218, -126}, {-228, -126}}, color = {0, 0, 255}));
  connect(tfo_1103_103.terminal2, bus_103_ADLER.terminal) annotation(
    Line(points = {{-198, -126}, {-190, -126}, {-190, -100}, {-164, -100}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal1, bus_1101_ABEL.terminal) annotation(
    Line(points = {{-258, -186}, {-268, -186}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal2, bus_101_ABEL.terminal) annotation(
    Line(points = {{-238, -186}, {-228, -186}, {-228, -206}, {-168, -206}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal2, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-248, -236}, {-248, -246}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-248, -216}, {-248, -206}, {-168, -206}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-208, -216}, {-208, -206}, {-168, -206}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal2, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-208, -236}, {-208, -246}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal2, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{-168, -236}, {-168, -246}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-168, -216}, {-168, -206}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal2, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{-128, -236}, {-128, -246}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-128, -216}, {-128, -206}, {-168, -206}}, color = {0, 0, 255}));
  connect(tfo_10102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-44, -256}, {-44, -246}, {-4, -246}}, color = {0, 0, 255}));
  connect(tfo_10102_102.terminal2, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{-44, -276}, {-44, -286}}, color = {0, 0, 255}));
  connect(tfo_20102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-4, -256}, {-4, -246}}, color = {0, 0, 255}));
  connect(tfo_20102_102.terminal2, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{-4, -276}, {-4, -286}}, color = {0, 0, 255}));
  connect(tfo_30102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{36, -256}, {36, -246}, {-4, -246}}, color = {0, 0, 255}));
  connect(tfo_30102_102.terminal2, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{36, -276}, {36, -286}}, color = {0, 0, 255}));
  connect(tfo_40102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{76, -256}, {76, -246}, {-4, -246}}, color = {0, 0, 255}));
  connect(tfo_40102_102.terminal2, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{76, -276}, {76, -286}}, color = {0, 0, 255}));
  connect(tfo_1102_102.terminal2, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-64, -266}, {-58, -266}, {-58, -246}, {-4, -246}}, color = {0, 0, 255}));
  connect(tfo_1102_102.terminal1, bus_1102_ADAMS.terminal) annotation(
    Line(points = {{-84, -266}, {-94, -266}}, color = {0, 0, 255}));
  connect(tfo_60115_115.terminal2, bus_60115_ARTHUR_G6.terminal) annotation(
    Line(points = {{-234, 92}, {-244, 92}}, color = {0, 0, 255}));
  connect(tfo_60115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-214, 92}, {-204, 92}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_50115_115.terminal2, bus_50115_ARTHUR_G5.terminal) annotation(
    Line(points = {{-234, 132}, {-244, 132}}, color = {0, 0, 255}));
  connect(tfo_50115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-214, 132}, {-204, 132}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_10106_106.terminal2, bus_10106_ALBER_SVC.terminal) annotation(
    Line(points = {{142, -226}, {152, -226}}, color = {0, 0, 255}));
  connect(tfo_10106_106.terminal1, bus_106_ALBER.terminal) annotation(
    Line(points = {{122, -226}, {112, -226}, {112, -206}, {92, -206}}, color = {0, 0, 255}));
  connect(tfo_1106_106.terminal1, bus_1106_ALBER.terminal) annotation(
    Line(points = {{142, -266}, {152, -266}}, color = {0, 0, 255}));
  connect(tfo_1106_106.terminal2, bus_106_ALBER.terminal) annotation(
    Line(points = {{122, -266}, {102, -266}, {102, -206}, {92, -206}}, color = {0, 0, 255}));
  connect(tfo_10122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{216, 278}, {226, 278}, {226, 248}}, color = {0, 0, 255}));
  connect(tfo_10122_122.terminal2, bus_10122_AUBREY_G1.terminal) annotation(
    Line(points = {{196, 278}, {186, 278}}, color = {0, 0, 255}));
  connect(tfo_30122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{236, 308}, {226, 308}, {226, 248}}, color = {0, 0, 255}));
  connect(tfo_30122_122.terminal2, bus_30122_AUBREY_G3.terminal) annotation(
    Line(points = {{256, 308}, {266, 308}}, color = {0, 0, 255}));
  connect(tfo_40122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{236, 268}, {226, 268}, {226, 248}}, color = {0, 0, 255}));
  connect(tfo_40122_122.terminal2, bus_40122_AUBREY_G4.terminal) annotation(
    Line(points = {{256, 268}, {266, 268}}, color = {0, 0, 255}));
  connect(tfo_50122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{236, 228}, {226, 228}, {226, 248}}, color = {0, 0, 255}));
  connect(tfo_50122_122.terminal2, bus_50122_AUBREY_G5.terminal) annotation(
    Line(points = {{256, 228}, {266, 228}}, color = {0, 0, 255}));
  connect(tfo_60122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{236, 188}, {226, 188}, {226, 248}}, color = {0, 0, 255}));
  connect(tfo_60122_122.terminal2, bus_60122_AUBREY_G6.terminal) annotation(
    Line(points = {{256, 188}, {266, 188}}, color = {0, 0, 255}));
  connect(tfo_20122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{216, 238}, {216, 248}, {226, 248}}, color = {0, 0, 255}));
  connect(tfo_20122_122.terminal2, bus_20122_AUBREY_G2.terminal) annotation(
    Line(points = {{196, 238}, {186, 238}}, color = {0, 0, 255}));
  connect(tfo_1119_119.terminal2, bus_119_ATTAR.terminal) annotation(
    Line(points = {{56, 106}, {46, 106}, {46, 126}}, color = {0, 0, 255}));
  connect(tfo_1119_119.terminal1, bus_1119_ATTAR.terminal) annotation(
    Line(points = {{76, 106}, {86, 106}}, color = {0, 0, 255}));
  connect(tfo_1120_120.terminal2, bus_120_ATTILA.terminal) annotation(
    Line(points = {{136, 106}, {126, 106}, {126, 126}}, color = {0, 0, 255}));
  connect(tfo_1120_120.terminal1, bus_1120_ATTILA.terminal) annotation(
    Line(points = {{156, 106}, {166, 106}}, color = {0, 0, 255}));
  connect(tfo_10123_123.terminal1, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{236, 146}, {226, 146}, {226, 106}}, color = {0, 0, 255}));
  connect(tfo_10123_123.terminal2, bus_10123_AUSTEN_G1.terminal) annotation(
    Line(points = {{256, 146}, {266, 146}}, color = {0, 0, 255}));
  connect(tfo_20123_123.terminal1, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{236, 106}, {226, 106}}, color = {0, 0, 255}));
  connect(tfo_20123_123.terminal2, bus_20123_AUSTEN_G2.terminal) annotation(
    Line(points = {{256, 106}, {266, 106}}, color = {0, 0, 255}));
  connect(tfo_30123_123.terminal1, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{236, 66}, {226, 66}, {226, 106}}, color = {0, 0, 255}));
  connect(tfo_30123_123.terminal2, bus_30123_AUSTEN_G3.terminal) annotation(
    Line(points = {{256, 66}, {266, 66}}, color = {0, 0, 255}));
  connect(tfo_10113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{136, 46}, {126, 46}, {126, 16}}, color = {0, 0, 255}));
  connect(tfo_10113_113.terminal2, bus_10113_ARNE_G1.terminal) annotation(
    Line(points = {{156, 46}, {166, 46}}, color = {0, 0, 255}));
  connect(tfo_20113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{136, 6}, {126, 6}, {126, 16}}, color = {0, 0, 255}));
  connect(tfo_20113_113.terminal2, bus_20113_ARNE_G2.terminal) annotation(
    Line(points = {{156, 6}, {166, 6}}, color = {0, 0, 255}));
  connect(tfo_30113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{136, -34}, {126, -34}, {126, 16}}, color = {0, 0, 255}));
  connect(tfo_30113_113.terminal2, bus_30113_ARNE_G3.terminal) annotation(
    Line(points = {{156, -34}, {166, -34}}, color = {0, 0, 255}));
  connect(tfo_1113_113.terminal1, bus_1113_ARNE.terminal) annotation(
    Line(points = {{106, -24}, {106, -34}}, color = {0, 0, 255}));
  connect(tfo_1113_113.terminal2, bus_113_ARNE.terminal) annotation(
    Line(points = {{106, -4}, {106, 6}, {126, 6}, {126, 16}}, color = {0, 0, 255}));
  connect(tfo_10107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{246, -134}, {236, -134}, {236, -174}}, color = {0, 0, 255}));
  connect(tfo_10107_107.terminal2, bus_10107_ALDER_G1.terminal) annotation(
    Line(points = {{266, -134}, {276, -134}}, color = {0, 0, 255}));
  connect(tfo_20107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{246, -174}, {236, -174}}, color = {0, 0, 255}));
  connect(tfo_20107_107.terminal2, bus_20107_ALDER_G2.terminal) annotation(
    Line(points = {{266, -174}, {276, -174}}, color = {0, 0, 255}));
  connect(tfo_30107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{246, -214}, {236, -214}, {236, -174}}, color = {0, 0, 255}));
  connect(tfo_30107_107.terminal2, bus_30107_ALDER_G3.terminal) annotation(
    Line(points = {{266, -214}, {276, -214}}, color = {0, 0, 255}));
  connect(tfo_109_111.terminal2, bus_111_ANNA.terminal) annotation(
    Line(points = {{-74, 26}, {-74, 36}}, color = {0, 0, 255}));
  connect(tfo_109_111.terminal1, bus_109_ALI.terminal) annotation(
    Line(points = {{-74, 6}, {-74, -102}, {-64, -102}}, color = {0, 0, 255}));
  connect(tfo_1109_109.terminal2, bus_109_ALI.terminal) annotation(
    Line(points = {{-70, -128}, {-64, -128}, {-64, -102}}, color = {0, 0, 255}));
  connect(tfo_1109_109.terminal1, bus_1109_ALI.terminal) annotation(
    Line(points = {{-90, -128}, {-104, -128}}, color = {0, 0, 255}));
  connect(tfo_1104_104.terminal2, bus_104_AGRICOLA.terminal) annotation(
    Line(points = {{-70, -168}, {-62, -168}, {-62, -148}, {-54, -148}}, color = {0, 0, 255}));
  connect(tfo_1104_104.terminal1, bus_1104_AGRICOLA.terminal) annotation(
    Line(points = {{-90, -168}, {-104, -168}}, color = {0, 0, 255}));
  connect(tfo_103_124.terminal1, bus_103_ADLER.terminal) annotation(
    Line(points = {{-168, 6}, {-168, -100}, {-164, -100}}, color = {0, 0, 255}));
  connect(tfo_110_112.terminal2, bus_112_ARCHER.terminal) annotation(
    Line(points = {{28, 26}, {28, 36}}, color = {0, 0, 255}));
  connect(tfo_110_112.terminal1, bus_110_ALLEN.terminal) annotation(
    Line(points = {{28, 6}, {30, 6}, {30, -102}, {48, -102}}, color = {0, 0, 255}));
  connect(tfo_110_111.terminal1, bus_110_ALLEN.terminal) annotation(
    Line(points = {{-14, -44}, {12, -44}, {12, -102}, {48, -102}}, color = {0, 0, 255}));
  connect(tfo_110_111.terminal2, bus_111_ANNA.terminal) annotation(
    Line(points = {{-34, -44}, {-58, -44}, {-58, 36}, {-74, 36}}, color = {0, 0, 255}));
  connect(tfo_109_112.terminal2, bus_112_ARCHER.terminal) annotation(
    Line(points = {{-14, -14}, {10, -14}, {10, 36}, {28, 36}}, color = {0, 0, 255}));
  connect(tfo_109_112.terminal1, bus_109_ALI.terminal) annotation(
    Line(points = {{-34, -14}, {-46, -14}, {-46, -102}, {-64, -102}}, color = {0, 0, 255}));
  connect(tfo_1105_105.terminal1, bus_1105_AIKEN.terminal) annotation(
    Line(points = {{-2, -224}, {-14, -224}}, color = {0, 0, 255}));
  connect(tfo_1105_105.terminal2, bus_105_AIKEN.terminal) annotation(
    Line(points = {{18, -224}, {26, -224}, {26, -204}, {16, -204}}, color = {0, 0, 255}));
  connect(tfo_1110_110.terminal1, bus_1110_ALLEN.terminal) annotation(
    Line(points = {{56, -74}, {66, -74}}, color = {0, 0, 255}));
  connect(tfo_1110_110.terminal2, bus_110_ALLEN.terminal) annotation(
    Line(points = {{36, -74}, {34, -74}, {34, -102}, {48, -102}}, color = {0, 0, 255}));
  connect(tfo_1108_108.terminal2, bus_108_ALGER.terminal) annotation(
    Line(points = {{166, -174}, {156, -174}, {156, -154}}, color = {0, 0, 255}));
  connect(tfo_1108_108.terminal1, bus_1108_ALGER.terminal) annotation(
    Line(points = {{186, -174}, {196, -174}}, color = {0, 0, 255}));
  connect(tfo_1107_107.terminal1, bus_1107_ALDER.terminal) annotation(
    Line(points = {{216, -224}, {216, -234}}, color = {0, 0, 255}));
  connect(tfo_1107_107.terminal2, bus_107_ALDER.terminal) annotation(
    Line(points = {{216, -204}, {216, -194}, {236, -194}, {236, -174}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida"),
    Diagram(coordinateSystem(extent = {{-300, -340}, {300, 340}})));
end NetworkWithTrfRestorative;
