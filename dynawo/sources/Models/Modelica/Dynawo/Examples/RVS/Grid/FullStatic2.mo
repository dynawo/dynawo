within Dynawo.Examples.RVS.Grid;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

model FullStatic2 "RVS test grid with buses, lines, shunts, PQ loads and transformers, used for load flow calculation (OpenModelica 1.24.4)"
  import Modelica.SIunits.Conversions.from_deg;

  extends BaseClasses.NetworkWithPQLoads;

  parameter Types.VoltageModule UNom_lower = 138;
  parameter Types.VoltageModule UNom_upper = 230;

  Dynawo.Electrical.Controls.Basics.SetPoint N(Value0 = 0);
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = from_deg(13.4), UPu = 1.04685) annotation(
    Placement(visible = true, transformation(origin = {-134, 322}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_10121_121(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 471, XPu = 0.15 * 100 / 471, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-114, 282}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1118_118(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 450, XPu = 0.15 * 100 / 450, rTfoPu = 1 - 0.1 * (16 - 11) / 16) annotation(
    Placement(visible = true, transformation(origin = {26, 260}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_10118_118(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 471, XPu = 0.15 * 100 / 471, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-14, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_10118_ASTOR_G1(PGen0Pu = PGen0Pu_gen_10118, U0Pu = U0Pu_gen_10118) annotation(
    Placement(visible = true, transformation(origin = {-54, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_20115_ARTHUR_G2(PGen0Pu = PGen0Pu_gen_20115, U0Pu = U0Pu_gen_20115) annotation(
    Placement(visible = true, transformation(origin = {-264, 252}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_30115_ARTHUR_G3(PGen0Pu = PGen0Pu_gen_30115, U0Pu = U0Pu_gen_30115) annotation(
    Placement(visible = true, transformation(origin = {-264, 212}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_40115_ARTHUR_G4(PGen0Pu = PGen0Pu_gen_40115, U0Pu = U0Pu_gen_40115) annotation(
    Placement(visible = true, transformation(origin = {-264, 172}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_60115_ARTHUR_G6(PGen0Pu = PGen0Pu_gen_60115, U0Pu = U0Pu_gen_60115) annotation(
    Placement(visible = true, transformation(origin = {-264, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_10115_ARTHUR_G1(PGen0Pu = PGen0Pu_gen_10115, U0Pu = U0Pu_gen_10115) annotation(
    Placement(visible = true, transformation(origin = {-264, 292}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_50115_ARTHUR_G5(PGen0Pu = PGen0Pu_gen_50115, U0Pu = U0Pu_gen_50115) annotation(
    Placement(visible = true, transformation(origin = {-264, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_115(Gain = 1, NbGenMax = 6, U0Pu = URef0Pu_bus_115 * UNom_upper, URef0Pu = URef0Pu_bus_115 * UNom_upper, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-204, 312}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_30115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-224, 212}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_40115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-224, 172}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_60115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-224, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_50115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-224, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_20115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-224, 252}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_10115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-224, 292}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 400, XPu = 0.15 * 100 / 400, rTfoPu = 1 - 0.1 * (16 - 6) / 16) annotation(
    Placement(visible = true, transformation(origin = {-186, 164}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.StaticVarCompensators.SVarCPV sVarC_10114_ARNOLD_SVC(B0Pu = Q0Pu_sVarC_10114 / 1.05 ^ 2, BMaxPu = 0.5, BMinPu = -2, BShuntPu = 0, U0Pu = 1.05, URef0Pu = 1.05, i0Pu = Complex(0, Q0Pu_sVarC_10114), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {14, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_10114_114(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 200, XPu = 0.15 * 100 / 200, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-26, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1114_114(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 250, XPu = 0.15 * 100 / 250, rTfoPu = 1 - 0.1 * (16 - 6) / 16) annotation(
    Placement(visible = true, transformation(origin = {-26, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_10116_116(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-106, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1116_116(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 150, XPu = 0.15 * 100 / 150, rTfoPu = 1 - 0.1 * (16 - 8) / 16) annotation(
    Placement(visible = true, transformation(origin = {-104, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_116(Gain = 1, NbGenMax = 1, U0Pu = URef0Pu_bus_116 * UNom_upper, URef0Pu = URef0Pu_bus_116 * UNom_upper, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-84, 182}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_10116_ASSER_G1(PGen0Pu = PGen0Pu_gen_10116, U0Pu = U0Pu_gen_10116) annotation(
    Placement(visible = true, transformation(origin = {-146, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_118(Gain = 1, NbGenMax = 1, U0Pu = URef0Pu_bus_118 * UNom_upper, URef0Pu = URef0Pu_bus_118 * UNom_upper, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {6, 280}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_20101_ABEL_G2(PGen0Pu = PGen0Pu_gen_20101, U0Pu = U0Pu_gen_20101) annotation(
    Placement(visible = true, transformation(origin = {-208, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_40101_ABEL_G4(PGen0Pu = PGen0Pu_gen_40101, U0Pu = U0Pu_gen_40101) annotation(
    Placement(visible = true, transformation(origin = {-128, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_10101_ABEL_G1(PGen0Pu = PGen0Pu_gen_10101, U0Pu = U0Pu_gen_10101) annotation(
    Placement(visible = true, transformation(origin = {-248, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_30101_ABEL_G3(PGen0Pu = PGen0Pu_gen_30101, U0Pu = U0Pu_gen_30101) annotation(
    Placement(visible = true, transformation(origin = {-168, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_30101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-168, -226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_40101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-128, -226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 150, XPu = 0.15 * 100 / 150, rTfoPu = 1 - 0.1 * (16 - 10) / 16) annotation(
    Placement(visible = true, transformation(origin = {-248, -186}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1103_103(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 250, XPu = 0.15 * 100 / 250, rTfoPu = 1 - 0.1 * (16 - 5) / 16) annotation(
    Placement(visible = true, transformation(origin = {-208, -126}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_10101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-248, -226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_103_124(BPu = 0, GPu = 0, RPu = 0.008 * 100 / 400, XPu = 0.336 * 100 / 400, rTfoPu = 1 - 0.1 * (16 - 1) / 16) annotation(
    Placement(visible = true, transformation(origin = {-168, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_20101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-208, -226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_101(Gain = 1, NbGenMax = 4, U0Pu = URef0Pu_bus_101 * UNom_lower, URef0Pu = URef0Pu_bus_101 * UNom_lower, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-268, -206}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_20102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-4, -266}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_30102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {36, -266}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_40102_ADAMS_G4(PGen0Pu = PGen0Pu_gen_40102, U0Pu = U0Pu_gen_40102) annotation(
    Placement(visible = true, transformation(origin = {76, -306}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_30102_ADAMS_G3(PGen0Pu = PGen0Pu_gen_30102, U0Pu = U0Pu_gen_30102) annotation(
    Placement(visible = true, transformation(origin = {36, -306}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_10102_ADAMS_G1(PGen0Pu = PGen0Pu_gen_10102, U0Pu = U0Pu_gen_10102) annotation(
    Placement(visible = true, transformation(origin = {-44, -306}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_20102_ADAMS_G2(PGen0Pu = PGen0Pu_gen_20102, U0Pu = U0Pu_gen_20102) annotation(
    Placement(visible = true, transformation(origin = {-4, -306}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_10102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-44, -266}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_40102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {76, -266}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 150, XPu = 0.15 * 100 / 150, rTfoPu = 1 - 0.1 * (16 - 11) / 16) annotation(
    Placement(visible = true, transformation(origin = {-74, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_102(Gain = 1, NbGenMax = 4, U0Pu = URef0Pu_bus_102 * UNom_lower, URef0Pu = URef0Pu_bus_102 * UNom_lower, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-104, -246}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.StaticVarCompensators.SVarCPV sVarC_10106_ALBER_SVC(B0Pu = Q0Pu_sVarC_10106 / 1.05 ^ 2, BMaxPu = 0.5, BMinPu = -1, BShuntPu = 0, U0Pu = 1.05, URef0Pu = 1.05, i0Pu = Complex(0, Q0Pu_sVarC_10106), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {172, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_10106_106(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 120, XPu = 0.15 * 100 / 120, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {132, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1106_106(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 200, XPu = 0.15 * 100 / 200, rTfoPu = 1 - 0.1 * (16 - 10) / 16) annotation(
    Placement(visible = true, transformation(origin = {132, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_10122_AUBREY_G1(PGen0Pu = PGen0Pu_gen_10122, U0Pu = U0Pu_gen_10122) annotation(
    Placement(visible = true, transformation(origin = {166, 278}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_40122_AUBREY_G4(PGen0Pu = PGen0Pu_gen_40122, U0Pu = U0Pu_gen_40122) annotation(
    Placement(visible = true, transformation(origin = {298, 268}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_30122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 308}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_60122_AUBREY_G6(PGen0Pu = PGen0Pu_gen_60122, U0Pu = U0Pu_gen_60122) annotation(
    Placement(visible = true, transformation(origin = {298, 188}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_20122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {206, 238}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_50122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 228}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_50122_AUBREY_G5(PGen0Pu = PGen0Pu_gen_50122, U0Pu = U0Pu_gen_50122) annotation(
    Placement(visible = true, transformation(origin = {298, 228}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_40122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 268}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_60122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 188}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_20122_AUBREY_G2(PGen0Pu = PGen0Pu_gen_20122, U0Pu = U0Pu_gen_20122) annotation(
    Placement(visible = true, transformation(origin = {166, 238}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_10122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {206, 278}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_30122_AUBREY_G3(PGen0Pu = PGen0Pu_gen_30122, U0Pu = U0Pu_gen_30122) annotation(
    Placement(visible = true, transformation(origin = {298, 308}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_122(Gain = 1, NbGenMax = 6, U0Pu = URef0Pu_bus_122 * UNom_upper, URef0Pu = URef0Pu_bus_122 * UNom_upper, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {226, 328}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1120_120(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 200, XPu = 0.15 * 100 / 200, rTfoPu = 1 - 0.1 * (16 - 10) / 16) annotation(
    Placement(visible = true, transformation(origin = {146, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1119_119(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 250, XPu = 0.15 * 100 / 250, rTfoPu = 1 - 0.1 * (16 - 7) / 16) annotation(
    Placement(visible = true, transformation(origin = {66, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_20123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_30123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 412, XPu = 0.15 * 100 / 412, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_10123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {246, 146}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_10123_AUSTEN_G1(PGen0Pu = PGen0Pu_gen_10123, U0Pu = U0Pu_gen_10123) annotation(
    Placement(visible = true, transformation(origin = {296, 146}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_20123_AUSTEN_G2(PGen0Pu = PGen0Pu_gen_20123, U0Pu = U0Pu_gen_20123) annotation(
    Placement(visible = true, transformation(origin = {296, 106}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_123(Gain = 1, NbGenMax = 3, U0Pu = URef0Pu_bus_123 * UNom_upper, URef0Pu = URef0Pu_bus_123 * UNom_upper, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {226, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_30123_AUSTEN_G3(PGen0Pu = PGen0Pu_gen_30123, U0Pu = U0Pu_gen_30123) annotation(
    Placement(visible = true, transformation(origin = {296, 66}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_10113_ARNE_G1(PGen0Pu = PGen0Pu_gen_10113, U0Pu = U0Pu_gen_10113) annotation(
    Placement(visible = true, transformation(origin = {186, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_30113_ARNE_G3(PGen0Pu = PGen0Pu_gen_30113, U0Pu = U0Pu_gen_30113) annotation(
    Placement(visible = true, transformation(origin = {186, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_10113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {146, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_113(Gain = 1, NbGenMax = 3, U0Pu = URef0Pu_bus_113 * UNom_upper, URef0Pu = URef0Pu_bus_113 * UNom_upper, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {126, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_30113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {146, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_20113_ARNE_G2(PGen0Pu = PGen0Pu_gen_20113, U0Pu = U0Pu_gen_20113) annotation(
    Placement(visible = true, transformation(origin = {186, 6}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_20113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {146, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 350, XPu = 0.15 * 100 / 350, rTfoPu = 1 - 0.1 * (16 - 7) / 16) annotation(
    Placement(visible = true, transformation(origin = {106, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_30107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {256, -214}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_20107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {256, -174}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_10107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {256, -134}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_10107_ALDER_G1(PGen0Pu = PGen0Pu_gen_10107, U0Pu = U0Pu_gen_10107) annotation(
    Placement(visible = true, transformation(origin = {296, -134}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_107(Gain = 1, NbGenMax = 3, U0Pu = URef0Pu_bus_107 * UNom_lower, URef0Pu = URef0Pu_bus_107 * UNom_lower, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {236, -114}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_30107_ALDER_G3(PGen0Pu = PGen0Pu_gen_30107, U0Pu = U0Pu_gen_30107) annotation(
    Placement(visible = true, transformation(origin = {296, -214}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen_20107_ALDER_G2(PGen0Pu = PGen0Pu_gen_20107, U0Pu = U0Pu_gen_20107) annotation(
    Placement(visible = true, transformation(origin = {296, -174}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 200, XPu = 0.15 * 100 / 200, rTfoPu = 1 - 0.1 * (16 - 10) / 16) annotation(
    Placement(visible = true, transformation(origin = {216, -214}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1108_108(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 250, XPu = 0.15 * 100 / 250, rTfoPu = 1 - 0.1 * (16 - 7) / 16) annotation(
    Placement(visible = true, transformation(origin = {176, -174}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_109_111(BPu = 0, GPu = 0, RPu = 0.008 * 100 / 400, XPu = 0.336 * 100 / 400, rTfoPu = 1 - 0.1 * (16 - 12) / 16) annotation(
    Placement(visible = true, transformation(origin = {-74, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1109_109(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 250, XPu = 0.15 * 100 / 250, rTfoPu = 1 - 0.1 * (16 - 7) / 16) annotation(
    Placement(visible = true, transformation(origin = {-80, -128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1104_104(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 100, XPu = 0.15 * 100 / 100, rTfoPu = 1 - 0.1 * (16 - 4) / 16) annotation(
    Placement(visible = true, transformation(origin = {-80, -168}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_110_112(BPu = 0, GPu = 0, RPu = 0.008 * 100 / 400, XPu = 0.336 * 100 / 400, rTfoPu = 1 - 0.1 * (16 - 12) / 16) annotation(
    Placement(visible = true, transformation(origin = {28, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_110_111(BPu = 0, GPu = 0, RPu = 0.008 * 100 / 400, XPu = 0.336 * 100 / 400, rTfoPu = 1 - 0.1 * (16 - 13) / 16) annotation(
    Placement(visible = true, transformation(origin = {-24, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_109_112(BPu = 0, GPu = 0, RPu = 0.008 * 100 / 400, XPu = 0.336 * 100 / 400, rTfoPu = 1 - 0.1 * (16 - 0) / 16) annotation(
    Placement(visible = true, transformation(origin = {-24, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1105_105(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 100, XPu = 0.15 * 100 / 100, rTfoPu = 1 - 0.1 * (16 - 5) / 16) annotation(
    Placement(visible = true, transformation(origin = {8, -224}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio tfo_1110_110(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 250, XPu = 0.15 * 100 / 250, rTfoPu = 1 - 0.1 * (16 - 6) / 16) annotation(
    Placement(visible = true, transformation(origin = {46, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  //Buses
  parameter Types.VoltageModulePu URef0Pu_bus_101;
  parameter Types.VoltageModulePu URef0Pu_bus_102;
  parameter Types.VoltageModulePu URef0Pu_bus_107;
  parameter Types.VoltageModulePu URef0Pu_bus_113;
  parameter Types.VoltageModulePu URef0Pu_bus_115;
  parameter Types.VoltageModulePu URef0Pu_bus_116;
  parameter Types.VoltageModulePu URef0Pu_bus_118;
  parameter Types.VoltageModulePu URef0Pu_bus_122;
  parameter Types.VoltageModulePu URef0Pu_bus_123;

  //Generators
  parameter Types.ActivePowerPu PGen0Pu_gen_10101;
  parameter Types.ActivePowerPu PGen0Pu_gen_10102;
  parameter Types.ActivePowerPu PGen0Pu_gen_10107;
  parameter Types.ActivePowerPu PGen0Pu_gen_10113;
  parameter Types.ActivePowerPu PGen0Pu_gen_10115;
  parameter Types.ActivePowerPu PGen0Pu_gen_10116;
  parameter Types.ActivePowerPu PGen0Pu_gen_10118;
  parameter Types.ActivePowerPu PGen0Pu_gen_10122;
  parameter Types.ActivePowerPu PGen0Pu_gen_10123;
  parameter Types.ActivePowerPu PGen0Pu_gen_20101;
  parameter Types.ActivePowerPu PGen0Pu_gen_20102;
  parameter Types.ActivePowerPu PGen0Pu_gen_20107;
  parameter Types.ActivePowerPu PGen0Pu_gen_20113;
  parameter Types.ActivePowerPu PGen0Pu_gen_20115;
  parameter Types.ActivePowerPu PGen0Pu_gen_20122;
  parameter Types.ActivePowerPu PGen0Pu_gen_20123;
  parameter Types.ActivePowerPu PGen0Pu_gen_30101;
  parameter Types.ActivePowerPu PGen0Pu_gen_30102;
  parameter Types.ActivePowerPu PGen0Pu_gen_30107;
  parameter Types.ActivePowerPu PGen0Pu_gen_30113;
  parameter Types.ActivePowerPu PGen0Pu_gen_30115;
  parameter Types.ActivePowerPu PGen0Pu_gen_30122;
  parameter Types.ActivePowerPu PGen0Pu_gen_30123;
  parameter Types.ActivePowerPu PGen0Pu_gen_40101;
  parameter Types.ActivePowerPu PGen0Pu_gen_40102;
  parameter Types.ActivePowerPu PGen0Pu_gen_40115;
  parameter Types.ActivePowerPu PGen0Pu_gen_40122;
  parameter Types.ActivePowerPu PGen0Pu_gen_50115;
  parameter Types.ActivePowerPu PGen0Pu_gen_50122;
  parameter Types.ActivePowerPu PGen0Pu_gen_60115;
  parameter Types.ActivePowerPu PGen0Pu_gen_60122;
  parameter Types.VoltageModulePu U0Pu_gen_10101;
  parameter Types.VoltageModulePu U0Pu_gen_10102;
  parameter Types.VoltageModulePu U0Pu_gen_10107;
  parameter Types.VoltageModulePu U0Pu_gen_10113;
  parameter Types.VoltageModulePu U0Pu_gen_10115;
  parameter Types.VoltageModulePu U0Pu_gen_10116;
  parameter Types.VoltageModulePu U0Pu_gen_10118;
  parameter Types.VoltageModulePu U0Pu_gen_10122;
  parameter Types.VoltageModulePu U0Pu_gen_10123;
  parameter Types.VoltageModulePu U0Pu_gen_20101;
  parameter Types.VoltageModulePu U0Pu_gen_20102;
  parameter Types.VoltageModulePu U0Pu_gen_20107;
  parameter Types.VoltageModulePu U0Pu_gen_20113;
  parameter Types.VoltageModulePu U0Pu_gen_20115;
  parameter Types.VoltageModulePu U0Pu_gen_20122;
  parameter Types.VoltageModulePu U0Pu_gen_20123;
  parameter Types.VoltageModulePu U0Pu_gen_30101;
  parameter Types.VoltageModulePu U0Pu_gen_30102;
  parameter Types.VoltageModulePu U0Pu_gen_30107;
  parameter Types.VoltageModulePu U0Pu_gen_30113;
  parameter Types.VoltageModulePu U0Pu_gen_30115;
  parameter Types.VoltageModulePu U0Pu_gen_30122;
  parameter Types.VoltageModulePu U0Pu_gen_30123;
  parameter Types.VoltageModulePu U0Pu_gen_40101;
  parameter Types.VoltageModulePu U0Pu_gen_40102;
  parameter Types.VoltageModulePu U0Pu_gen_40115;
  parameter Types.VoltageModulePu U0Pu_gen_40122;
  parameter Types.VoltageModulePu U0Pu_gen_50115;
  parameter Types.VoltageModulePu U0Pu_gen_50122;
  parameter Types.VoltageModulePu U0Pu_gen_60115;
  parameter Types.VoltageModulePu U0Pu_gen_60122;

  //SVarC
  parameter Types.ReactivePowerPu Q0Pu_sVarC_10106;
  parameter Types.ReactivePowerPu Q0Pu_sVarC_10114;

equation
  tfo_1101_101.switchOffSignal1.value = false;
  tfo_1101_101.switchOffSignal2.value = false;
  tfo_10101_101.switchOffSignal1.value = false;
  tfo_10101_101.switchOffSignal2.value = false;
  tfo_20101_101.switchOffSignal1.value = false;
  tfo_20101_101.switchOffSignal2.value = false;
  tfo_30101_101.switchOffSignal1.value = false;
  tfo_30101_101.switchOffSignal2.value = false;
  tfo_40101_101.switchOffSignal1.value = false;
  tfo_40101_101.switchOffSignal2.value = false;
  tfo_1102_102.switchOffSignal1.value = false;
  tfo_1102_102.switchOffSignal2.value = false;
  tfo_10102_102.switchOffSignal1.value = false;
  tfo_10102_102.switchOffSignal2.value = false;
  tfo_20102_102.switchOffSignal1.value = false;
  tfo_20102_102.switchOffSignal2.value = false;
  tfo_30102_102.switchOffSignal1.value = false;
  tfo_30102_102.switchOffSignal2.value = false;
  tfo_40102_102.switchOffSignal1.value = false;
  tfo_40102_102.switchOffSignal2.value = false;
  tfo_1103_103.switchOffSignal1.value = false;
  tfo_1103_103.switchOffSignal2.value = false;
  tfo_103_124.switchOffSignal1.value = false;
  tfo_103_124.switchOffSignal2.value = false;
  tfo_1104_104.switchOffSignal1.value = false;
  tfo_1104_104.switchOffSignal2.value = false;
  tfo_1105_105.switchOffSignal1.value = false;
  tfo_1105_105.switchOffSignal2.value = false;
  tfo_1106_106.switchOffSignal1.value = false;
  tfo_1106_106.switchOffSignal2.value = false;
  tfo_10106_106.switchOffSignal1.value = false;
  tfo_10106_106.switchOffSignal2.value = false;
  tfo_1107_107.switchOffSignal1.value = false;
  tfo_1107_107.switchOffSignal2.value = false;
  tfo_10107_107.switchOffSignal1.value = false;
  tfo_10107_107.switchOffSignal2.value = false;
  tfo_20107_107.switchOffSignal1.value = false;
  tfo_20107_107.switchOffSignal2.value = false;
  tfo_30107_107.switchOffSignal1.value = false;
  tfo_30107_107.switchOffSignal2.value = false;
  tfo_1108_108.switchOffSignal1.value = false;
  tfo_1108_108.switchOffSignal2.value = false;
  tfo_1109_109.switchOffSignal1.value = false;
  tfo_1109_109.switchOffSignal2.value = false;
  tfo_109_111.switchOffSignal1.value = false;
  tfo_109_111.switchOffSignal2.value = false;
  tfo_109_112.switchOffSignal1.value = false;
  tfo_109_112.switchOffSignal2.value = false;
  tfo_110_111.switchOffSignal1.value = false;
  tfo_110_111.switchOffSignal2.value = false;
  tfo_110_112.switchOffSignal1.value = false;
  tfo_110_112.switchOffSignal2.value = false;
  tfo_1110_110.switchOffSignal1.value = false;
  tfo_1110_110.switchOffSignal2.value = false;
  tfo_1113_113.switchOffSignal1.value = false;
  tfo_1113_113.switchOffSignal2.value = false;
  tfo_10113_113.switchOffSignal1.value = false;
  tfo_10113_113.switchOffSignal2.value = false;
  tfo_20113_113.switchOffSignal1.value = false;
  tfo_20113_113.switchOffSignal2.value = false;
  tfo_30113_113.switchOffSignal1.value = false;
  tfo_30113_113.switchOffSignal2.value = false;
  tfo_1114_114.switchOffSignal1.value = false;
  tfo_1114_114.switchOffSignal2.value = false;
  tfo_10114_114.switchOffSignal1.value = false;
  tfo_10114_114.switchOffSignal2.value = false;
  tfo_1115_115.switchOffSignal1.value = false;
  tfo_1115_115.switchOffSignal2.value = false;
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
  tfo_1116_116.switchOffSignal1.value = false;
  tfo_1116_116.switchOffSignal2.value = false;
  tfo_10116_116.switchOffSignal1.value = false;
  tfo_10116_116.switchOffSignal2.value = false;
  tfo_1118_118.switchOffSignal1.value = false;
  tfo_1118_118.switchOffSignal2.value = false;
  tfo_10118_118.switchOffSignal1.value = false;
  tfo_10118_118.switchOffSignal2.value = false;
  tfo_1119_119.switchOffSignal1.value = false;
  tfo_1119_119.switchOffSignal2.value = false;
  tfo_1120_120.switchOffSignal1.value = false;
  tfo_1120_120.switchOffSignal2.value = false;
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
  vRRemote_bus_101.URegulatedPu = ComplexMath.'abs'(bus_101_ABEL.terminal.V) * UNom_lower;
  vRRemote_bus_101.URefPu = URef0Pu_bus_101 * UNom_lower;
  vRRemote_bus_101.limUQUp[1] = false;// gen_10101_ABEL_G1.limUQUp;
  vRRemote_bus_101.limUQUp[2] = false;// gen_20101_ABEL_G2.limUQUp;
  vRRemote_bus_101.limUQUp[3] = false;// gen_30101_ABEL_G3.limUQUp;
  vRRemote_bus_101.limUQUp[4] = false;// gen_40101_ABEL_G4.limUQUp;
  vRRemote_bus_101.limUQDown[1] = false;// gen_10101_ABEL_G1.limUQDown;
  vRRemote_bus_101.limUQDown[2] = false;// gen_20101_ABEL_G2.limUQDown;
  vRRemote_bus_101.limUQDown[3] = false;// gen_30101_ABEL_G3.limUQDown;
  vRRemote_bus_101.limUQDown[4] = false;// gen_40101_ABEL_G4.limUQDown;
  gen_10101_ABEL_G1.switchOffSignal1.value = false;
  gen_10101_ABEL_G1.switchOffSignal2.value = false;
  gen_10101_ABEL_G1.switchOffSignal3.value = false;
  gen_20101_ABEL_G2.switchOffSignal1.value = false;
  gen_20101_ABEL_G2.switchOffSignal2.value = false;
  gen_20101_ABEL_G2.switchOffSignal3.value = false;
  gen_30101_ABEL_G3.switchOffSignal1.value = false;
  gen_30101_ABEL_G3.switchOffSignal2.value = false;
  gen_30101_ABEL_G3.switchOffSignal3.value = false;
  gen_40101_ABEL_G4.switchOffSignal1.value = false;
  gen_40101_ABEL_G4.switchOffSignal2.value = false;
  gen_40101_ABEL_G4.switchOffSignal3.value = false;
  vRRemote_bus_102.URegulatedPu = ComplexMath.'abs'(bus_102_ADAMS.terminal.V) * UNom_lower;
  vRRemote_bus_102.URefPu = URef0Pu_bus_102 * UNom_lower;
  vRRemote_bus_102.limUQUp[1] = false;// gen_10102_ADAMS_G1.limUQUp;
  vRRemote_bus_102.limUQUp[2] = false;// gen_20102_ADAMS_G2.limUQUp;
  vRRemote_bus_102.limUQUp[3] = false;// gen_30102_ADAMS_G3.limUQUp;
  vRRemote_bus_102.limUQUp[4] = false;// gen_40102_ADAMS_G4.limUQUp;
  vRRemote_bus_102.limUQDown[1] = false;// gen_10102_ADAMS_G1.limUQDown;
  vRRemote_bus_102.limUQDown[2] = false;// gen_20102_ADAMS_G2.limUQDown;
  vRRemote_bus_102.limUQDown[3] = false;// gen_30102_ADAMS_G3.limUQDown;
  vRRemote_bus_102.limUQDown[4] = false;// gen_40102_ADAMS_G4.limUQDown;
  gen_10102_ADAMS_G1.switchOffSignal1.value = false;
  gen_10102_ADAMS_G1.switchOffSignal2.value = false;
  gen_10102_ADAMS_G1.switchOffSignal3.value = false;
  gen_20102_ADAMS_G2.switchOffSignal1.value = false;
  gen_20102_ADAMS_G2.switchOffSignal2.value = false;
  gen_20102_ADAMS_G2.switchOffSignal3.value = false;
  gen_30102_ADAMS_G3.switchOffSignal1.value = false;
  gen_30102_ADAMS_G3.switchOffSignal2.value = false;
  gen_30102_ADAMS_G3.switchOffSignal3.value = false;
  gen_40102_ADAMS_G4.switchOffSignal1.value = false;
  gen_40102_ADAMS_G4.switchOffSignal2.value = false;
  gen_40102_ADAMS_G4.switchOffSignal3.value = false;
  vRRemote_bus_107.URegulatedPu = ComplexMath.'abs'(bus_107_ALDER.terminal.V) * UNom_lower;
  vRRemote_bus_107.URefPu = URef0Pu_bus_107 * UNom_lower;
  vRRemote_bus_107.limUQUp[1] = false;// gen_10107_ALDER_G1.limUQUp;
  vRRemote_bus_107.limUQUp[2] = false;// gen_20107_ALDER_G2.limUQUp;
  vRRemote_bus_107.limUQUp[3] = false;// gen_30107_ALDER_G3.limUQUp;
  vRRemote_bus_107.limUQDown[1] = false;// gen_10107_ALDER_G1.limUQDown;
  vRRemote_bus_107.limUQDown[2] = false;// gen_20107_ALDER_G2.limUQDown;
  vRRemote_bus_107.limUQDown[3] = false;// gen_30107_ALDER_G3.limUQDown;
  gen_10107_ALDER_G1.switchOffSignal1.value = false;
  gen_10107_ALDER_G1.switchOffSignal2.value = false;
  gen_10107_ALDER_G1.switchOffSignal3.value = false;
  gen_20107_ALDER_G2.switchOffSignal1.value = false;
  gen_20107_ALDER_G2.switchOffSignal2.value = false;
  gen_20107_ALDER_G2.switchOffSignal3.value = false;
  gen_30107_ALDER_G3.switchOffSignal1.value = false;
  gen_30107_ALDER_G3.switchOffSignal2.value = false;
  gen_30107_ALDER_G3.switchOffSignal3.value = false;
  vRRemote_bus_113.URegulatedPu = ComplexMath.'abs'(bus_113_ARNE.terminal.V) * UNom_upper;
  vRRemote_bus_113.URefPu = URef0Pu_bus_113 * UNom_upper;
  vRRemote_bus_113.limUQUp[1] = false;// gen_10113_ARNE_G1.limUQUp;
  vRRemote_bus_113.limUQUp[2] = false;// gen_20113_ARNE_G2.limUQUp;
  vRRemote_bus_113.limUQUp[3] = false;// gen_30113_ARNE_G3.limUQUp;
  vRRemote_bus_113.limUQDown[1] = false;// gen_10113_ARNE_G1.limUQDown;
  vRRemote_bus_113.limUQDown[2] = false;// gen_20113_ARNE_G2.limUQDown;
  vRRemote_bus_113.limUQDown[3] = false;// gen_30113_ARNE_G3.limUQDown;
  gen_10113_ARNE_G1.switchOffSignal1.value = false;
  gen_10113_ARNE_G1.switchOffSignal2.value = false;
  gen_10113_ARNE_G1.switchOffSignal3.value = false;
  gen_20113_ARNE_G2.switchOffSignal1.value = false;
  gen_20113_ARNE_G2.switchOffSignal2.value = false;
  gen_20113_ARNE_G2.switchOffSignal3.value = false;
  gen_30113_ARNE_G3.switchOffSignal1.value = false;
  gen_30113_ARNE_G3.switchOffSignal2.value = false;
  gen_30113_ARNE_G3.switchOffSignal3.value = false;
  vRRemote_bus_118.URegulatedPu = ComplexMath.'abs'(bus_118_ASTOR.terminal.V) * UNom_upper;
  vRRemote_bus_118.URefPu = URef0Pu_bus_118 * UNom_upper;
  vRRemote_bus_118.limUQUp[1] = false;// gen_10118_ASTOR_G1.limUQUp;
  vRRemote_bus_118.limUQDown[1] = false;// gen_10118_ASTOR_G1.limUQDown;
  gen_10118_ASTOR_G1.switchOffSignal1.value = false;
  gen_10118_ASTOR_G1.switchOffSignal2.value = false;
  gen_10118_ASTOR_G1.switchOffSignal3.value = false;
  vRRemote_bus_115.URegulatedPu = ComplexMath.'abs'(bus_115_ARTHUR.terminal.V) * UNom_upper;
  vRRemote_bus_115.URefPu = URef0Pu_bus_115 * UNom_upper;
  vRRemote_bus_115.limUQUp[1] = false;// gen_10115_ARTHUR_G1.limUQUp;
  vRRemote_bus_115.limUQUp[2] = false;// gen_20115_ARTHUR_G2.limUQUp;
  vRRemote_bus_115.limUQUp[3] = false;// gen_30115_ARTHUR_G3.limUQUp;
  vRRemote_bus_115.limUQUp[4] = false;// gen_40115_ARTHUR_G4.limUQUp;
  vRRemote_bus_115.limUQUp[5] = false;// gen_50115_ARTHUR_G5.limUQUp;
  vRRemote_bus_115.limUQUp[6] = false;// gen_60115_ARTHUR_G6.limUQUp;
  vRRemote_bus_115.limUQDown[1] = false;// gen_10115_ARTHUR_G1.limUQDown;
  vRRemote_bus_115.limUQDown[2] = false;// gen_20115_ARTHUR_G2.limUQDown;
  vRRemote_bus_115.limUQDown[3] = false;// gen_30115_ARTHUR_G3.limUQDown;
  vRRemote_bus_115.limUQDown[4] = false;// gen_40115_ARTHUR_G4.limUQDown;
  vRRemote_bus_115.limUQDown[5] = false;// gen_50115_ARTHUR_G5.limUQDown;
  vRRemote_bus_115.limUQDown[6] = false;// gen_60115_ARTHUR_G6.limUQDown;
  gen_10115_ARTHUR_G1.switchOffSignal1.value = false;
  gen_10115_ARTHUR_G1.switchOffSignal2.value = false;
  gen_10115_ARTHUR_G1.switchOffSignal3.value = false;
  gen_20115_ARTHUR_G2.switchOffSignal1.value = false;
  gen_20115_ARTHUR_G2.switchOffSignal2.value = false;
  gen_20115_ARTHUR_G2.switchOffSignal3.value = false;
  gen_30115_ARTHUR_G3.switchOffSignal1.value = false;
  gen_30115_ARTHUR_G3.switchOffSignal2.value = false;
  gen_30115_ARTHUR_G3.switchOffSignal3.value = false;
  gen_40115_ARTHUR_G4.switchOffSignal1.value = false;
  gen_40115_ARTHUR_G4.switchOffSignal2.value = false;
  gen_40115_ARTHUR_G4.switchOffSignal3.value = false;
  gen_50115_ARTHUR_G5.switchOffSignal1.value = false;
  gen_50115_ARTHUR_G5.switchOffSignal2.value = false;
  gen_50115_ARTHUR_G5.switchOffSignal3.value = false;
  gen_60115_ARTHUR_G6.switchOffSignal1.value = false;
  gen_60115_ARTHUR_G6.switchOffSignal2.value = false;
  gen_60115_ARTHUR_G6.switchOffSignal3.value = false;
  vRRemote_bus_122.URegulatedPu = ComplexMath.'abs'(bus_122_AUBREY.terminal.V) * UNom_upper;
  vRRemote_bus_122.URefPu = URef0Pu_bus_122 * UNom_upper;
  vRRemote_bus_122.limUQUp[1] = false;// gen_10122_AUBREY_G1.limUQUp;
  vRRemote_bus_122.limUQUp[2] = false;// gen_20122_AUBREY_G2.limUQUp;
  vRRemote_bus_122.limUQUp[3] = false;// gen_30122_AUBREY_G3.limUQUp;
  vRRemote_bus_122.limUQUp[4] = false;// gen_40122_AUBREY_G4.limUQUp;
  vRRemote_bus_122.limUQUp[5] = false;// gen_50122_AUBREY_G5.limUQUp;
  vRRemote_bus_122.limUQUp[6] = false;// gen_60122_AUBREY_G6.limUQUp;
  vRRemote_bus_122.limUQDown[1] = false;// gen_10122_AUBREY_G1.limUQDown;
  vRRemote_bus_122.limUQDown[2] = false;// gen_20122_AUBREY_G2.limUQDown;
  vRRemote_bus_122.limUQDown[3] = false;// gen_30122_AUBREY_G3.limUQDown;
  vRRemote_bus_122.limUQDown[4] = false;// gen_40122_AUBREY_G4.limUQDown;
  vRRemote_bus_122.limUQDown[5] = false;// gen_50122_AUBREY_G5.limUQDown;
  vRRemote_bus_122.limUQDown[6] = false;// gen_60122_AUBREY_G6.limUQDown;
  gen_10122_AUBREY_G1.switchOffSignal1.value = false;
  gen_10122_AUBREY_G1.switchOffSignal2.value = false;
  gen_10122_AUBREY_G1.switchOffSignal3.value = false;
  gen_20122_AUBREY_G2.switchOffSignal1.value = false;
  gen_20122_AUBREY_G2.switchOffSignal2.value = false;
  gen_20122_AUBREY_G2.switchOffSignal3.value = false;
  gen_30122_AUBREY_G3.switchOffSignal1.value = false;
  gen_30122_AUBREY_G3.switchOffSignal2.value = false;
  gen_30122_AUBREY_G3.switchOffSignal3.value = false;
  gen_40122_AUBREY_G4.switchOffSignal1.value = false;
  gen_40122_AUBREY_G4.switchOffSignal2.value = false;
  gen_40122_AUBREY_G4.switchOffSignal3.value = false;
  gen_50122_AUBREY_G5.switchOffSignal1.value = false;
  gen_50122_AUBREY_G5.switchOffSignal2.value = false;
  gen_50122_AUBREY_G5.switchOffSignal3.value = false;
  gen_60122_AUBREY_G6.switchOffSignal1.value = false;
  gen_60122_AUBREY_G6.switchOffSignal2.value = false;
  gen_60122_AUBREY_G6.switchOffSignal3.value = false;
  vRRemote_bus_116.URegulatedPu = ComplexMath.'abs'(bus_116_ASSER.terminal.V) * UNom_upper;
  vRRemote_bus_116.URefPu = URef0Pu_bus_116 * UNom_upper;
  vRRemote_bus_116.limUQUp[1] = false;// gen_10116_ASSER_G1.limUQUp;
  vRRemote_bus_116.limUQDown[1] = false;// gen_10116_ASSER_G1.limUQDown;
  gen_10116_ASSER_G1.switchOffSignal1.value = false;
  gen_10116_ASSER_G1.switchOffSignal2.value = false;
  gen_10116_ASSER_G1.switchOffSignal3.value = false;
  vRRemote_bus_123.URegulatedPu = ComplexMath.'abs'(bus_123_AUSTEN.terminal.V) * UNom_upper;
  vRRemote_bus_123.URefPu = URef0Pu_bus_123 * UNom_upper;
  vRRemote_bus_123.limUQUp[1] = false;// gen_10123_AUSTEN_G1.limUQUp;
  vRRemote_bus_123.limUQUp[2] = false;// gen_20123_AUSTEN_G2.limUQUp;
  vRRemote_bus_123.limUQUp[3] = false;// gen_30123_AUSTEN_G3.limUQUp;
  vRRemote_bus_123.limUQDown[1] = false;// gen_10123_AUSTEN_G1.limUQDown;
  vRRemote_bus_123.limUQDown[2] = false;// gen_20123_AUSTEN_G2.limUQDown;
  vRRemote_bus_123.limUQDown[3] = false;// gen_30123_AUSTEN_G3.limUQDown;
  gen_10123_AUSTEN_G1.switchOffSignal1.value = false;
  gen_10123_AUSTEN_G1.switchOffSignal2.value = false;
  gen_10123_AUSTEN_G1.switchOffSignal3.value = false;
  gen_20123_AUSTEN_G2.switchOffSignal1.value = false;
  gen_20123_AUSTEN_G2.switchOffSignal2.value = false;
  gen_20123_AUSTEN_G2.switchOffSignal3.value = false;
  gen_30123_AUSTEN_G3.switchOffSignal1.value = false;
  gen_30123_AUSTEN_G3.switchOffSignal2.value = false;
  gen_30123_AUSTEN_G3.switchOffSignal3.value = false;
  sVarC_10114_ARNOLD_SVC.switchOffSignal1.value = false;
  sVarC_10114_ARNOLD_SVC.switchOffSignal2.value = false;
  sVarC_10114_ARNOLD_SVC.URefPu = 1.05;
  sVarC_10106_ALBER_SVC.switchOffSignal1.value = false;
  sVarC_10106_ALBER_SVC.switchOffSignal2.value = false;
  sVarC_10106_ALBER_SVC.URefPu = 1.05;

  connect(sVarC_10114_ARNOLD_SVC.terminal, bus_10114_ARNOLD_SVC.terminal);
  connect(sVarC_10106_ALBER_SVC.terminal, bus_10106_ALBER_SVC.terminal);
  connect(gen_10101_ABEL_G1.terminal, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-248, -266}, {-248, -246}}, color = {0, 0, 255}));
  connect(gen_20101_ABEL_G2.terminal, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-208, -266}, {-208, -246}}, color = {0, 0, 255}));
  connect(gen_30101_ABEL_G3.terminal, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{-168, -266}, {-168, -246}}, color = {0, 0, 255}));
  connect(gen_40101_ABEL_G4.terminal, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{-128, -266}, {-128, -246}}, color = {0, 0, 255}));
  connect(gen_10102_ADAMS_G1.terminal, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{-44, -306}, {-44, -286}}, color = {0, 0, 255}));
  connect(gen_20102_ADAMS_G2.terminal, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{-4, -306}, {-4, -286}}, color = {0, 0, 255}));
  connect(gen_30102_ADAMS_G3.terminal, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{36, -306}, {36, -286}}, color = {0, 0, 255}));
  connect(gen_40102_ADAMS_G4.terminal, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{76, -306}, {76, -286}}, color = {0, 0, 255}));
  connect(gen_10107_ALDER_G1.terminal, bus_10107_ALDER_G1.terminal) annotation(
    Line(points = {{296, -134}, {276, -134}}, color = {0, 0, 255}));
  connect(gen_20107_ALDER_G2.terminal, bus_20107_ALDER_G2.terminal) annotation(
    Line(points = {{296, -174}, {276, -174}}, color = {0, 0, 255}));
  connect(gen_30107_ALDER_G3.terminal, bus_30107_ALDER_G3.terminal) annotation(
    Line(points = {{296, -214}, {276, -214}}, color = {0, 0, 255}));
  connect(gen_10113_ARNE_G1.terminal, bus_10113_ARNE_G1.terminal) annotation(
    Line(points = {{186, 46}, {166, 46}}, color = {0, 0, 255}));
  connect(gen_20113_ARNE_G2.terminal, bus_20113_ARNE_G2.terminal) annotation(
    Line(points = {{186, 6}, {166, 6}}, color = {0, 0, 255}));
  connect(gen_30113_ARNE_G3.terminal, bus_30113_ARNE_G3.terminal) annotation(
    Line(points = {{186, -34}, {166, -34}}, color = {0, 0, 255}));
  connect(gen_10115_ARTHUR_G1.terminal, bus_10115_ARTHUR_G1.terminal) annotation(
    Line(points = {{-264, 292}, {-244, 292}}, color = {0, 0, 255}));
  connect(gen_20115_ARTHUR_G2.terminal, bus_20115_ARTHUR_G2.terminal) annotation(
    Line(points = {{-264, 252}, {-244, 252}}, color = {0, 0, 255}));
  connect(gen_30115_ARTHUR_G3.terminal, bus_30115_ARTHUR_G3.terminal) annotation(
    Line(points = {{-264, 212}, {-244, 212}}, color = {0, 0, 255}));
  connect(gen_40115_ARTHUR_G4.terminal, bus_40115_ARTHUR_G4.terminal) annotation(
    Line(points = {{-264, 172}, {-244, 172}}, color = {0, 0, 255}));
  connect(gen_50115_ARTHUR_G5.terminal, bus_50115_ARTHUR_G5.terminal) annotation(
    Line(points = {{-264, 132}, {-244, 132}}, color = {0, 0, 255}));
  connect(gen_60115_ARTHUR_G6.terminal, bus_60115_ARTHUR_G6.terminal) annotation(
    Line(points = {{-264, 92}, {-244, 92}}, color = {0, 0, 255}));
  connect(gen_10116_ASSER_G1.terminal, bus_10116_ASSER_G1.terminal) annotation(
    Line(points = {{-146, 144}, {-124, 144}}, color = {0, 0, 255}));
  connect(gen_10118_ASTOR_G1.terminal, bus_10118_ASTOR_G1.terminal) annotation(
    Line(points = {{-54, 200}, {-34, 200}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, bus_10121_ATTLEE_G1.terminal) annotation(
    Line(points = {{-134, 322}, {-134, 282}}, color = {0, 0, 255}));
  connect(gen_10122_AUBREY_G1.terminal, bus_10122_AUBREY_G1.terminal) annotation(
    Line(points = {{166, 278}, {186, 278}}, color = {0, 0, 255}));
  connect(gen_20122_AUBREY_G2.terminal, bus_20122_AUBREY_G2.terminal) annotation(
    Line(points = {{166, 238}, {186, 238}}, color = {0, 0, 255}));
  connect(gen_30122_AUBREY_G3.terminal, bus_30122_AUBREY_G3.terminal) annotation(
    Line(points = {{298, 308}, {266, 308}}, color = {0, 0, 255}));
  connect(gen_40122_AUBREY_G4.terminal, bus_40122_AUBREY_G4.terminal) annotation(
    Line(points = {{298, 268}, {266, 268}}, color = {0, 0, 255}));
  connect(gen_50122_AUBREY_G5.terminal, bus_50122_AUBREY_G5.terminal) annotation(
    Line(points = {{298, 228}, {266, 228}}, color = {0, 0, 255}));
  connect(gen_60122_AUBREY_G6.terminal, bus_60122_AUBREY_G6.terminal) annotation(
    Line(points = {{298, 188}, {266, 188}}, color = {0, 0, 255}));
  connect(gen_10123_AUSTEN_G1.terminal, bus_10123_AUSTEN_G1.terminal) annotation(
    Line(points = {{296, 146}, {266, 146}}, color = {0, 0, 255}));
  connect(gen_20123_AUSTEN_G2.terminal, bus_20123_AUSTEN_G2.terminal) annotation(
    Line(points = {{296, 106}, {266, 106}}, color = {0, 0, 255}));
  connect(gen_30123_AUSTEN_G3.terminal, bus_30123_AUSTEN_G3.terminal) annotation(
    Line(points = {{296, 66}, {266, 66}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal1, bus_1101_ABEL.terminal) annotation(
    Line(points = {{-258, -186}, {-268, -186}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal2, bus_101_ABEL.terminal) annotation(
    Line(points = {{-238, -186}, {-226, -186}, {-226, -206}, {-168, -206}}, color = {0, 0, 255}));
  connect(tfo_1102_102.terminal1, bus_1102_ADAMS.terminal) annotation(
    Line(points = {{-84, -266}, {-94, -266}}, color = {0, 0, 255}));
  connect(tfo_1102_102.terminal2, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-64, -266}, {-54, -266}, {-54, -246}, {-4, -246}}, color = {0, 0, 255}));
  connect(tfo_1103_103.terminal1, bus_1103_ADLER.terminal) annotation(
    Line(points = {{-218, -126}, {-228, -126}}, color = {0, 0, 255}));
  connect(tfo_1103_103.terminal2, bus_103_ADLER.terminal) annotation(
    Line(points = {{-198, -126}, {-184, -126}, {-184, -100}, {-164, -100}}, color = {0, 0, 255}));
  connect(tfo_1104_104.terminal1, bus_1104_AGRICOLA.terminal) annotation(
    Line(points = {{-90, -168}, {-104, -168}}, color = {0, 0, 255}));
  connect(tfo_1104_104.terminal2, bus_104_AGRICOLA.terminal) annotation(
    Line(points = {{-70, -168}, {-64, -168}, {-64, -148}, {-54, -148}}, color = {0, 0, 255}));
  connect(tfo_1105_105.terminal1, bus_1105_AIKEN.terminal) annotation(
    Line(points = {{-2, -224}, {-14, -224}}, color = {0, 0, 255}));
  connect(tfo_1105_105.terminal2, bus_105_AIKEN.terminal) annotation(
    Line(points = {{18, -224}, {26, -224}, {26, -204}, {16, -204}}, color = {0, 0, 255}));
  connect(tfo_1106_106.terminal1, bus_1106_ALBER.terminal) annotation(
    Line(points = {{142, -266}, {152, -266}}, color = {0, 0, 255}));
  connect(tfo_1106_106.terminal2, bus_106_ALBER.terminal) annotation(
    Line(points = {{122, -266}, {106, -266}, {106, -206}, {92, -206}}, color = {0, 0, 255}));
  connect(tfo_1107_107.terminal1, bus_1107_ALDER.terminal) annotation(
    Line(points = {{216, -224}, {216, -234}}, color = {0, 0, 255}));
  connect(tfo_1107_107.terminal2, bus_107_ALDER.terminal) annotation(
    Line(points = {{216, -204}, {216, -192}, {236, -192}, {236, -174}}, color = {0, 0, 255}));
  connect(tfo_1108_108.terminal1, bus_1108_ALGER.terminal) annotation(
    Line(points = {{186, -174}, {196, -174}}, color = {0, 0, 255}));
  connect(tfo_1108_108.terminal2, bus_108_ALGER.terminal) annotation(
    Line(points = {{166, -174}, {156, -174}, {156, -154}}, color = {0, 0, 255}));
  connect(tfo_1109_109.terminal1, bus_1109_ALI.terminal) annotation(
    Line(points = {{-90, -128}, {-104, -128}}, color = {0, 0, 255}));
  connect(tfo_1109_109.terminal2, bus_109_ALI.terminal) annotation(
    Line(points = {{-70, -128}, {-64, -128}, {-64, -102}}, color = {0, 0, 255}));
  connect(tfo_1110_110.terminal1, bus_1110_ALLEN.terminal) annotation(
    Line(points = {{56, -74}, {66, -74}}, color = {0, 0, 255}));
  connect(tfo_1110_110.terminal2, bus_110_ALLEN.terminal) annotation(
    Line(points = {{36, -74}, {32, -74}, {32, -102}, {48, -102}}, color = {0, 0, 255}));
  connect(tfo_1113_113.terminal1, bus_1113_ARNE.terminal) annotation(
    Line(points = {{106, -24}, {106, -34}}, color = {0, 0, 255}));
  connect(tfo_1113_113.terminal2, bus_113_ARNE.terminal) annotation(
    Line(points = {{106, -4}, {106, 16}, {126, 16}}, color = {0, 0, 255}));
  connect(tfo_1114_114.terminal1, bus_1114_ARNOLD.terminal) annotation(
    Line(points = {{-16, 84}, {-6, 84}}, color = {0, 0, 255}));
  connect(tfo_1114_114.terminal2, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-36, 84}, {-44, 84}, {-44, 110}}, color = {0, 0, 255}));
  connect(tfo_1115_115.terminal1, bus_1115_ARTHUR.terminal) annotation(
    Line(points = {{-176, 164}, {-164, 164}}, color = {0, 0, 255}));
  connect(tfo_1115_115.terminal2, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-196, 164}, {-204, 164}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_1116_116.terminal2, bus_116_ASSER.terminal) annotation(
    Line(points = {{-94, 124}, {-84, 124}, {-84, 134}}, color = {0, 0, 255}));
  connect(tfo_1116_116.terminal1, bus_1116_ASSER.terminal) annotation(
    Line(points = {{-114, 124}, {-124, 124}}, color = {0, 0, 255}));
  connect(tfo_1118_118.terminal1, bus_1118_ASTOR.terminal) annotation(
    Line(points = {{36, 260}, {46, 260}}, color = {0, 0, 255}));
  connect(tfo_1118_118.terminal2, bus_118_ASTOR.terminal) annotation(
    Line(points = {{16, 260}, {6, 260}, {6, 230}}, color = {0, 0, 255}));
  connect(tfo_1119_119.terminal1, bus_1119_ATTAR.terminal) annotation(
    Line(points = {{76, 106}, {86, 106}}, color = {0, 0, 255}));
  connect(tfo_1119_119.terminal2, bus_119_ATTAR.terminal) annotation(
    Line(points = {{56, 106}, {46, 106}, {46, 126}}, color = {0, 0, 255}));
  connect(tfo_1120_120.terminal1, bus_1120_ATTILA.terminal) annotation(
    Line(points = {{156, 106}, {166, 106}}, color = {0, 0, 255}));
  connect(tfo_1120_120.terminal2, bus_120_ATTILA.terminal) annotation(
    Line(points = {{136, 106}, {126, 106}, {126, 126}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-248, -216}, {-248, -206}, {-168, -206}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal2, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-248, -236}, {-248, -246}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-208, -216}, {-208, -206}, {-168, -206}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal2, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-208, -236}, {-208, -246}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-168, -216}, {-168, -206}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal2, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{-168, -236}, {-168, -246}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-128, -216}, {-128, -206}, {-168, -206}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal2, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{-128, -236}, {-128, -246}}, color = {0, 0, 255}));
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
  connect(tfo_10115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-214, 292}, {-204, 292}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_10115_115.terminal2, bus_10115_ARTHUR_G1.terminal) annotation(
    Line(points = {{-234, 292}, {-244, 292}}, color = {0, 0, 255}));
  connect(tfo_20115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-214, 252}, {-204, 252}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_20115_115.terminal2, bus_20115_ARTHUR_G2.terminal) annotation(
    Line(points = {{-234, 252}, {-244, 252}}, color = {0, 0, 255}));
  connect(tfo_30115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-214, 212}, {-204, 212}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_30115_115.terminal2, bus_30115_ARTHUR_G3.terminal) annotation(
    Line(points = {{-234, 212}, {-244, 212}}, color = {0, 0, 255}));
  connect(tfo_40115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-214, 172}, {-204, 172}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_40115_115.terminal2, bus_40115_ARTHUR_G4.terminal) annotation(
    Line(points = {{-234, 172}, {-244, 172}}, color = {0, 0, 255}));
  connect(tfo_50115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-214, 132}, {-204, 132}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_50115_115.terminal2, bus_50115_ARTHUR_G5.terminal) annotation(
    Line(points = {{-234, 132}, {-244, 132}}, color = {0, 0, 255}));
  connect(tfo_60115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-214, 92}, {-204, 92}, {-204, 192}}, color = {0, 0, 255}));
  connect(tfo_60115_115.terminal2, bus_60115_ARTHUR_G6.terminal) annotation(
    Line(points = {{-234, 92}, {-244, 92}}, color = {0, 0, 255}));
  connect(tfo_10116_116.terminal1, bus_116_ASSER.terminal) annotation(
    Line(points = {{-96, 144}, {-84, 144}, {-84, 134}}, color = {0, 0, 255}));
  connect(tfo_10116_116.terminal2, bus_10116_ASSER_G1.terminal) annotation(
    Line(points = {{-116, 144}, {-124, 144}}, color = {0, 0, 255}));
  connect(tfo_10118_118.terminal1, bus_118_ASTOR.terminal) annotation(
    Line(points = {{-4, 200}, {6, 200}, {6, 230}}, color = {0, 0, 255}));
  connect(tfo_10118_118.terminal2, bus_10118_ASTOR_G1.terminal) annotation(
    Line(points = {{-24, 200}, {-34, 200}}, color = {0, 0, 255}));
  connect(tfo_10121_121.terminal1, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-104, 282}, {-94, 282}, {-94, 262}}, color = {0, 0, 255}));
  connect(tfo_10121_121.terminal2, bus_10121_ATTLEE_G1.terminal) annotation(
    Line(points = {{-124, 282}, {-134, 282}}, color = {0, 0, 255}));
  connect(tfo_10122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{216, 278}, {226, 278}, {226, 248}}, color = {0, 0, 255}));
  connect(tfo_10122_122.terminal2, bus_10122_AUBREY_G1.terminal) annotation(
    Line(points = {{196, 278}, {186, 278}}, color = {0, 0, 255}));
  connect(tfo_20122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{216, 238}, {226, 238}, {226, 248}}, color = {0, 0, 255}));
  connect(tfo_20122_122.terminal2, bus_20122_AUBREY_G2.terminal) annotation(
    Line(points = {{196, 238}, {186, 238}}, color = {0, 0, 255}));
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
  connect(tfo_103_124.terminal1, bus_103_ADLER.terminal) annotation(
    Line(points = {{-168, 6}, {-168, -100}, {-164, -100}}, color = {0, 0, 255}));
  connect(tfo_103_124.terminal2, bus_124_AVERY.terminal) annotation(
    Line(points = {{-168, 26}, {-168, 36}}, color = {0, 0, 255}));
  connect(tfo_109_111.terminal1, bus_109_ALI.terminal) annotation(
    Line(points = {{-74, 6}, {-74, -102}, {-64, -102}}, color = {0, 0, 255}));
  connect(tfo_109_111.terminal2, bus_111_ANNA.terminal) annotation(
    Line(points = {{-74, 26}, {-74, 36}}, color = {0, 0, 255}));
  connect(tfo_110_112.terminal1, bus_110_ALLEN.terminal) annotation(
    Line(points = {{28, 6}, {28, -102}, {48, -102}}, color = {0, 0, 255}));
  connect(tfo_110_112.terminal2, bus_112_ARCHER.terminal) annotation(
    Line(points = {{28, 26}, {28, 36}}, color = {0, 0, 255}));
  connect(tfo_109_112.terminal1, bus_109_ALI.terminal) annotation(
    Line(points = {{-34, -14}, {-64, -14}, {-64, -102}}, color = {0, 0, 255}));
  connect(tfo_109_112.terminal2, bus_112_ARCHER.terminal) annotation(
    Line(points = {{-14, -14}, {12, -14}, {12, 36}, {28, 36}}, color = {0, 0, 255}));
  connect(tfo_110_111.terminal1, bus_110_ALLEN.terminal) annotation(
    Line(points = {{-14, -44}, {16, -44}, {16, -102}, {48, -102}}, color = {0, 0, 255}));
  connect(tfo_110_111.terminal2, bus_111_ANNA.terminal) annotation(
    Line(points = {{-34, -44}, {-60, -44}, {-60, 36}, {-74, 36}}, color = {0, 0, 255}));
  connect(tfo_10106_106.terminal2, bus_10106_ALBER_SVC.terminal) annotation(
    Line(points = {{142, -226}, {152, -226}}, color = {0, 0, 255}));
  connect(tfo_10106_106.terminal1, bus_106_ALBER.terminal) annotation(
    Line(points = {{122, -226}, {114, -226}, {114, -206}, {92, -206}}, color = {0, 0, 255}));
  connect(tfo_10114_114.terminal2, bus_10114_ARNOLD_SVC.terminal) annotation(
    Line(points = {{-16, 124}, {-6, 124}}, color = {0, 0, 255}));
  connect(tfo_10114_114.terminal1, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-36, 124}, {-44, 124}, {-44, 110}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -340}, {300, 340}})));
end FullStatic2;
