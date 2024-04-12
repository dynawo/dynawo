within Dynawo.Examples.Nordic.Grid;

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

model FullDynamicModel "Nordic test grid with buses, lines, shunts, loads, transformers and generators, with events"
  import Dynawo.Examples.Nordic.Components.GeneratorWithControl;
  import Dynawo.Examples.Nordic.Components.TransformerWithControl;

  extends Dynawo.Examples.Nordic.Grid.BaseClasses.NetworkWithAlphaBetaLoads;
//  extends Dynawo.Examples.Nordic.Grid.BaseClasses.NetworkWithPQLoads;

  Types.AngularVelocityPu omegaCOI(start = SystemBase.omega0Pu) "Weighted average of the frequencies of all generators in pu (base omegaNom)";
  Types.PerUnit omegaCOIDen "Sum of inertia times nominal apparent power for all generators";
  Types.PerUnit omegaCOINum "Sum of the frequencies of all generators, weighted by inertia times nominal apparent power";

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

  TransformerWithControl.TransformerWithControl trafo_1_1041(P10Pu = -P0Pu_load_01, Q10Pu = -Q0Pu_load_01, U10Pu = U0Pu_load_01, U1Phase0 = UPhase0_load_01, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_1_1041) annotation(
    Placement(visible = true, transformation(origin = {-55, -97}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_2_1042(P10Pu = -P0Pu_load_02, Q10Pu = -Q0Pu_load_02, U10Pu = U0Pu_load_02, U1Phase0 = UPhase0_load_02, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_2_1042) annotation(
    Placement(visible = true, transformation(origin = {35, -87}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_3_1043(P10Pu = -P0Pu_load_03, Q10Pu = -Q0Pu_load_03, U10Pu = U0Pu_load_03, U1Phase0 = UPhase0_load_03, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_3_1043) annotation(
    Placement(visible = true, transformation(origin = {-65, -53}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  TransformerWithControl.TransformerWithControl trafo_4_1044(P10Pu = -P0Pu_load_04, Q10Pu = -Q0Pu_load_04, U10Pu = U0Pu_load_04, U1Phase0 = UPhase0_load_04, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_4_1044) annotation(
    Placement(visible = true, transformation(origin = {-25, -53}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  TransformerWithControl.TransformerWithControl trafo_5_1045(P10Pu = -P0Pu_load_05, Q10Pu = -Q0Pu_load_05, U10Pu = U0Pu_load_05, U1Phase0 = UPhase0_load_05, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_5_1045) annotation(
    Placement(visible = true, transformation(origin = {-25, -97}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_11_1011(P10Pu = -P0Pu_load_11, Q10Pu = -Q0Pu_load_11, U10Pu = U0Pu_load_11, U1Phase0 = UPhase0_load_11, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_11_1011) annotation(
    Placement(visible = true, transformation(origin = {21, 123}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_12_1012(P10Pu = -P0Pu_load_12, Q10Pu = -Q0Pu_load_12, U10Pu = U0Pu_load_12, U1Phase0 = UPhase0_load_12, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_12_1012) annotation(
    Placement(visible = true, transformation(origin = {39, 108}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  TransformerWithControl.TransformerWithControl trafo_13_1013(P10Pu = -P0Pu_load_13, Q10Pu = -Q0Pu_load_13, U10Pu = U0Pu_load_13, U1Phase0 = UPhase0_load_13, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_13_1013) annotation(
    Placement(visible = true, transformation(origin = {85, 123}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_22_1022(P10Pu = -P0Pu_load_22, Q10Pu = -Q0Pu_load_22, U10Pu = U0Pu_load_22, U1Phase0 = UPhase0_load_22, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_22_1022) annotation(
    Placement(visible = true, transformation(origin = {-40, 43}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_31_2031(P10Pu = -P0Pu_load_31, Q10Pu = -Q0Pu_load_31, U10Pu = U0Pu_load_31, U1Phase0 = UPhase0_load_31, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_31_2031) annotation(
    Placement(visible = true, transformation(origin = {-35, 12}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_32_2032(P10Pu = -P0Pu_load_32, Q10Pu = -Q0Pu_load_32, U10Pu = U0Pu_load_32, U1Phase0 = UPhase0_load_32, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_32_2032) annotation(
    Placement(visible = true, transformation(origin = {-89, 13}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_41_4041(P10Pu = -P0Pu_load_41, Q10Pu = -Q0Pu_load_41, U10Pu = U0Pu_load_41, U1Phase0 = UPhase0_load_41, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_41_4041) annotation(
    Placement(visible = true, transformation(origin = {-81, -17}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_42_4042(P10Pu = -P0Pu_load_42, Q10Pu = -Q0Pu_load_42, U10Pu = U0Pu_load_42, U1Phase0 = UPhase0_load_42, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_42_4042) annotation(
    Placement(visible = true, transformation(origin = {55, -2}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  TransformerWithControl.TransformerWithControl trafo_43_4043(P10Pu = -P0Pu_load_43, Q10Pu = -Q0Pu_load_43, U10Pu = U0Pu_load_43, U1Phase0 = UPhase0_load_43, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_43_4043) annotation(
    Placement(visible = true, transformation(origin = {25, -37}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_46_4046(P10Pu = -P0Pu_load_46, Q10Pu = -Q0Pu_load_46, U10Pu = U0Pu_load_46, U1Phase0 = UPhase0_load_46, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_46_4046) annotation(
    Placement(visible = true, transformation(origin = {71, -38}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_47_4047(P10Pu = -P0Pu_load_47, Q10Pu = -Q0Pu_load_47, U10Pu = U0Pu_load_47, U1Phase0 = UPhase0_load_47, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_47_4047) annotation(
    Placement(visible = true, transformation(origin = {61, -103}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  TransformerWithControl.TransformerWithControl trafo_51_4051(P10Pu = -P0Pu_load_51, Q10Pu = -Q0Pu_load_51, U10Pu = U0Pu_load_51, U1Phase0 = UPhase0_load_51, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_51_4051) annotation(
    Placement(visible = true, transformation(origin = {35, -123}, extent = {{-5, -5}, {5, 5}}, rotation = 270)));
  TransformerWithControl.TransformerWithControl trafo_61_4061(P10Pu = -P0Pu_load_61, Q10Pu = -Q0Pu_load_61, U10Pu = U0Pu_load_61, U1Phase0 = UPhase0_load_61, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_61_4061) annotation(
    Placement(visible = true, transformation(origin = {-95, -58}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_62_4062(P10Pu = -P0Pu_load_62, Q10Pu = -Q0Pu_load_62, U10Pu = U0Pu_load_62, U1Phase0 = UPhase0_load_62, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_62_4062) annotation(
    Placement(visible = true, transformation(origin = {-100, -102}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  TransformerWithControl.TransformerWithControl trafo_63_4063(P10Pu = -P0Pu_load_63, Q10Pu = -Q0Pu_load_63, U10Pu = U0Pu_load_63, U1Phase0 = UPhase0_load_63, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_63_4063) annotation(
    Placement(visible = true, transformation(origin = {-80, -137}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_71_4071(P10Pu = -P0Pu_load_71, Q10Pu = -Q0Pu_load_71, U10Pu = U0Pu_load_71, U1Phase0 = UPhase0_load_71, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_71_4071) annotation(
    Placement(visible = true, transformation(origin = {-95, 123}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  TransformerWithControl.TransformerWithControl trafo_72_4072(P10Pu = -P0Pu_load_72, Q10Pu = -Q0Pu_load_72, U10Pu = U0Pu_load_72, U1Phase0 = UPhase0_load_72, tfo = TransformerWithControl.TransformerParameters.tfoPreset.trafo_72_4072) annotation(
    Placement(visible = true, transformation(origin = {-88, 73}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_1011_4011(BPu = 0, GPu = 0, RPu = 0, XPu = 0.10 * 0.95 ^ 2 * (100 / 1250.0), rTfoPu = 0.95) annotation(
    Placement(visible = true, transformation(origin = {0, 125}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_1012_4012(BPu = 0, GPu = 0, RPu = 0, XPu = 0.10 * 0.95 ^ 2 * (100 / 1250.0), rTfoPu = 0.95) annotation(
    Placement(visible = true, transformation(origin = {-2, 96}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_1022_4022(BPu = 0, GPu = 0, RPu = 0, XPu = 0.10 * 0.93 ^ 2 * (100 / 833.3), rTfoPu = 0.93) annotation(
    Placement(visible = true, transformation(origin = {-25, 43}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_1044_4044a(BPu = 0, GPu = 0, RPu = 0, XPu = 0.10 * 1.03 ^ 2 * (100 / 1000.0), rTfoPu = 1.03) annotation(
    Placement(visible = true, transformation(origin = {-15, -45}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_1044_4044b(BPu = 0, GPu = 0, RPu = 0, XPu = 0.10 * 1.03 ^ 2 * (100 / 1000.0), rTfoPu = 1.03) annotation(
    Placement(visible = true, transformation(origin = {-8, -45}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_1045_4045a(BPu = 0, GPu = 0, RPu = 0, XPu = 0.10 * 1.04 ^ 2 * (100 / 1000.0), rTfoPu = 1.04) annotation(
    Placement(visible = true, transformation(origin = {-14, -100}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_1045_4045b(BPu = 0, GPu = 0, RPu = 0, XPu = 0.10 * 1.04 ^ 2 * (100 / 1000.0), rTfoPu = 1.04) annotation(
    Placement(visible = true, transformation(origin = {-8, -100}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_2031_4031(BPu = 0, GPu = 0, RPu = 0, XPu = 0.10 * 1.0 ^ 2 * (100 / 833.3), rTfoPu = 1.0) annotation(
    Placement(visible = true, transformation(origin = {-26, 28}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g1_1012(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.0 ^ 2 * (100 / 800.0), rTfoPu = 1.0) annotation(
    Placement(visible = true, transformation(origin = {25, 93}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g2_1013(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.0 ^ 2 * (100 / 600.0), rTfoPu = 1.0) annotation(
    Placement(visible = true, transformation(origin = {75, 138}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g3_1014(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.0 ^ 2 * (100 / 700.0), rTfoPu = 1.0) annotation(
    Placement(visible = true, transformation(origin = {85, 93}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g4_1021(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.0 ^ 2 * (100 / 600.0), rTfoPu = 1.0) annotation(
    Placement(visible = true, transformation(origin = {-85, 43}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g5_1022(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 250.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-45, 57}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g6_1042(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 400.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {35, -72}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g7_1043(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 200.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-53, -53}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g8_2032(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 850.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-77, 13}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g9_4011(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 1000.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-25, 138}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g10_4012(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 800.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-35, 93}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g11_4021(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 300.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {35, 58}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g12_4031(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 350.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-4, 28}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g13_4041(BPu = 0, GPu = 0, RPu = 0, XPu = 0.10 * 1.05 ^ 2 * (100 / 300.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-70, -17}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g14_4042(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 700.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {50, -17}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g15_4047(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 1200.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {80, -103}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g16_4051(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 700.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {20, -123}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g17_4062(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 600.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-78, -102}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g18_4063(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 1200.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-95, -137}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g19_4071(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 500.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-75, 137}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafo_g20_4072(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 4500.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-75, 73}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));

  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g01(P0Pu = P0Pu_g01, Q0Pu = Q0Pu_g01, U0Pu = U0Pu_g01, UPhase0 = UPhase0_g01, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g01) annotation(
    Placement(visible = true, transformation(origin = {25, 79}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g02(P0Pu = P0Pu_g02, Q0Pu = Q0Pu_g02, U0Pu = U0Pu_g02, UPhase0 = UPhase0_g02, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g02) annotation(
    Placement(visible = true, transformation(origin = {75, 151}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g03(P0Pu = P0Pu_g03, Q0Pu = Q0Pu_g03, U0Pu = U0Pu_g03, UPhase0 = UPhase0_g03, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g03) annotation(
    Placement(visible = true, transformation(origin = {85, 79}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g04(P0Pu = P0Pu_g04, Q0Pu = Q0Pu_g04, U0Pu = U0Pu_g04, UPhase0 = UPhase0_g04, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g04) annotation(
    Placement(visible = true, transformation(origin = {-85, 30}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g05(P0Pu = P0Pu_g05, Q0Pu = Q0Pu_g05, U0Pu = U0Pu_g05, UPhase0 = UPhase0_g05, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g05) annotation(
    Placement(visible = true, transformation(origin = {-45, 71}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g06(P0Pu = P0Pu_g06, Q0Pu = Q0Pu_g06, U0Pu = U0Pu_g06, UPhase0 = UPhase0_g06, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g06) annotation(
    Placement(visible = true, transformation(origin = {35, -60}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g07(P0Pu = P0Pu_g07, Q0Pu = Q0Pu_g07, U0Pu = U0Pu_g07, UPhase0 = UPhase0_g07, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g07) annotation(
    Placement(visible = true, transformation(origin = {-53, -39}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g08(P0Pu = P0Pu_g08, Q0Pu = Q0Pu_g08, U0Pu = U0Pu_g08, UPhase0 = UPhase0_g08, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g08) annotation(
    Placement(visible = true, transformation(origin = {-77, 0}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g09(P0Pu = P0Pu_g09, Q0Pu = Q0Pu_g09, U0Pu = U0Pu_g09, UPhase0 = UPhase0_g09, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g09) annotation(
    Placement(visible = true, transformation(origin = {-25, 151}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g10(P0Pu = P0Pu_g10, Q0Pu = Q0Pu_g10, U0Pu = U0Pu_g10, UPhase0 = UPhase0_g10, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g10) annotation(
    Placement(visible = true, transformation(origin = {-35, 79}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g11(P0Pu = P0Pu_g11, Q0Pu = Q0Pu_g11, U0Pu = U0Pu_g11, UPhase0 = UPhase0_g11, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g11) annotation(
    Placement(visible = true, transformation(origin = {35, 72}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g12(P0Pu = P0Pu_g12, Q0Pu = Q0Pu_g12, U0Pu = U0Pu_g12, UPhase0 = UPhase0_g12, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g12) annotation(
    Placement(visible = true, transformation(origin = {-4, 41}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g13(P0Pu = P0Pu_g13, Q0Pu = Q0Pu_g13, U0Pu = U0Pu_g13, UPhase0 = UPhase0_g13, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g13) annotation(
    Placement(visible = true, transformation(origin = {-70, -29}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g14(P0Pu = P0Pu_g14, Q0Pu = Q0Pu_g14, U0Pu = U0Pu_g14, UPhase0 = UPhase0_g14, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g14) annotation(
    Placement(visible = true, transformation(origin = {50, -30}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g15(P0Pu = P0Pu_g15, Q0Pu = Q0Pu_g15, U0Pu = U0Pu_g15, UPhase0 = UPhase0_g15, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g15) annotation(
    Placement(visible = true, transformation(origin = {80, -89}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g16(P0Pu = P0Pu_g16, Q0Pu = Q0Pu_g16, U0Pu = U0Pu_g16, UPhase0 = UPhase0_g16, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g16) annotation(
    Placement(visible = true, transformation(origin = {20, -109}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g17(P0Pu = P0Pu_g17, Q0Pu = Q0Pu_g17, U0Pu = U0Pu_g17, UPhase0 = UPhase0_g17, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g17) annotation(
    Placement(visible = true, transformation(origin = {-78, -88}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g18(P0Pu = P0Pu_g18, Q0Pu = Q0Pu_g18, U0Pu = U0Pu_g18, UPhase0 = UPhase0_g18, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g18) annotation(
    Placement(visible = true, transformation(origin = {-95, -151}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g19(P0Pu = P0Pu_g19, Q0Pu = Q0Pu_g19, U0Pu = U0Pu_g19, UPhase0 = UPhase0_g19, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g19) annotation(
    Placement(visible = true, transformation(origin = {-75, 151}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  GeneratorWithControl.GeneratorSynchronousThreeWindingsWithControl g20(P0Pu = P0Pu_g20, Q0Pu = Q0Pu_g20, U0Pu = U0Pu_g20, UPhase0 = UPhase0_g20, gen = GeneratorWithControl.GeneratorParameters.genFramePreset.g20) annotation(
    Placement(visible = true, transformation(origin = {-75, 60}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));

  // Generator initial parameters
  // P0Pu, Q0Pu in pu (base SnRef) (receptor convention)

  // g01
  parameter Types.ActivePowerPu P0Pu_g01;
  parameter Types.ReactivePowerPu Q0Pu_g01;
  parameter Types.VoltageModulePu U0Pu_g01;
  parameter Types.Angle UPhase0_g01;

  // g02
  parameter Types.ActivePowerPu P0Pu_g02;
  parameter Types.ReactivePowerPu Q0Pu_g02;
  parameter Types.VoltageModulePu U0Pu_g02;
  parameter Types.Angle UPhase0_g02;

  // g03
  parameter Types.ActivePowerPu P0Pu_g03;
  parameter Types.ReactivePowerPu Q0Pu_g03;
  parameter Types.VoltageModulePu U0Pu_g03;
  parameter Types.Angle UPhase0_g03;

  // g04
  parameter Types.ActivePowerPu P0Pu_g04;
  parameter Types.ReactivePowerPu Q0Pu_g04;
  parameter Types.VoltageModulePu U0Pu_g04;
  parameter Types.Angle UPhase0_g04;

  // g05
  parameter Types.ActivePowerPu P0Pu_g05;
  parameter Types.ReactivePowerPu Q0Pu_g05;
  parameter Types.VoltageModulePu U0Pu_g05;
  parameter Types.Angle UPhase0_g05;

  // g06
  parameter Types.ActivePowerPu P0Pu_g06;
  parameter Types.ReactivePowerPu Q0Pu_g06;
  parameter Types.VoltageModulePu U0Pu_g06;
  parameter Types.Angle UPhase0_g06;

  // g07
  parameter Types.ActivePowerPu P0Pu_g07;
  parameter Types.ReactivePowerPu Q0Pu_g07;
  parameter Types.VoltageModulePu U0Pu_g07;
  parameter Types.Angle UPhase0_g07;

  // g08
  parameter Types.ActivePowerPu P0Pu_g08;
  parameter Types.ReactivePowerPu Q0Pu_g08;
  parameter Types.VoltageModulePu U0Pu_g08;
  parameter Types.Angle UPhase0_g08;

  // g09
  parameter Types.ActivePowerPu P0Pu_g09;
  parameter Types.ReactivePowerPu Q0Pu_g09;
  parameter Types.VoltageModulePu U0Pu_g09;
  parameter Types.Angle UPhase0_g09;

  // g10
  parameter Types.ActivePowerPu P0Pu_g10;
  parameter Types.ReactivePowerPu Q0Pu_g10;
  parameter Types.VoltageModulePu U0Pu_g10;
  parameter Types.Angle UPhase0_g10;

  // g11
  parameter Types.ActivePowerPu P0Pu_g11;
  parameter Types.ReactivePowerPu Q0Pu_g11;
  parameter Types.VoltageModulePu U0Pu_g11;
  parameter Types.Angle UPhase0_g11;

  // g12
  parameter Types.ActivePowerPu P0Pu_g12;
  parameter Types.ReactivePowerPu Q0Pu_g12;
  parameter Types.VoltageModulePu U0Pu_g12;
  parameter Types.Angle UPhase0_g12;

  // g13
  parameter Types.ActivePowerPu P0Pu_g13;
  parameter Types.ReactivePowerPu Q0Pu_g13;
  parameter Types.VoltageModulePu U0Pu_g13;
  parameter Types.Angle UPhase0_g13;

  // g14
  parameter Types.ActivePowerPu P0Pu_g14;
  parameter Types.ReactivePowerPu Q0Pu_g14;
  parameter Types.VoltageModulePu U0Pu_g14;
  parameter Types.Angle UPhase0_g14;

  // g15
  parameter Types.ActivePowerPu P0Pu_g15;
  parameter Types.ReactivePowerPu Q0Pu_g15;
  parameter Types.VoltageModulePu U0Pu_g15;
  parameter Types.Angle UPhase0_g15;

  // g16
  parameter Types.ActivePowerPu P0Pu_g16;
  parameter Types.ReactivePowerPu Q0Pu_g16;
  parameter Types.VoltageModulePu U0Pu_g16;
  parameter Types.Angle UPhase0_g16;

  // g17
  parameter Types.ActivePowerPu P0Pu_g17;
  parameter Types.ReactivePowerPu Q0Pu_g17;
  parameter Types.VoltageModulePu U0Pu_g17;
  parameter Types.Angle UPhase0_g17;

  // g18
  parameter Types.ActivePowerPu P0Pu_g18;
  parameter Types.ReactivePowerPu Q0Pu_g18;
  parameter Types.VoltageModulePu U0Pu_g18;
  parameter Types.Angle UPhase0_g18;

  // g19
  parameter Types.ActivePowerPu P0Pu_g19;
  parameter Types.ReactivePowerPu Q0Pu_g19;
  parameter Types.VoltageModulePu U0Pu_g19;
  parameter Types.Angle UPhase0_g19;

  // g20
  parameter Types.ActivePowerPu P0Pu_g20;
  parameter Types.ReactivePowerPu Q0Pu_g20;
  parameter Types.VoltageModulePu U0Pu_g20;
  parameter Types.Angle UPhase0_g20;

equation
  connect(trafo_1_1041.terminal20, load_01_INIT.terminal0);
  connect(trafo_2_1042.terminal20, load_02_INIT.terminal0);
  connect(trafo_3_1043.terminal20, load_03_INIT.terminal0);
  connect(trafo_4_1044.terminal20, load_04_INIT.terminal0);
  connect(trafo_5_1045.terminal20, load_05_INIT.terminal0);
  connect(trafo_11_1011.terminal20, load_11_INIT.terminal0);
  connect(trafo_12_1012.terminal20, load_12_INIT.terminal0);
  connect(trafo_13_1013.terminal20, load_13_INIT.terminal0);
  connect(trafo_22_1022.terminal20, load_22_INIT.terminal0);
  connect(trafo_31_2031.terminal20, load_31_INIT.terminal0);
  connect(trafo_32_2032.terminal20, load_32_INIT.terminal0);
  connect(trafo_41_4041.terminal20, load_41_INIT.terminal0);
  connect(trafo_42_4042.terminal20, load_42_INIT.terminal0);
  connect(trafo_43_4043.terminal20, load_43_INIT.terminal0);
  connect(trafo_46_4046.terminal20, load_46_INIT.terminal0);
  connect(trafo_47_4047.terminal20, load_47_INIT.terminal0);
  connect(trafo_51_4051.terminal20, load_51_INIT.terminal0);
  connect(trafo_61_4061.terminal20, load_61_INIT.terminal0);
  connect(trafo_62_4062.terminal20, load_62_INIT.terminal0);
  connect(trafo_63_4063.terminal20, load_63_INIT.terminal0);
  connect(trafo_71_4071.terminal20, load_71_INIT.terminal0);
  connect(trafo_72_4072.terminal20, load_72_INIT.terminal0);

  trafo_g1_1012.switchOffSignal1.value = false;
  trafo_g1_1012.switchOffSignal2.value = false;
  trafo_g2_1013.switchOffSignal1.value = false;
  trafo_g2_1013.switchOffSignal2.value = false;
  trafo_g3_1014.switchOffSignal1.value = false;
  trafo_g3_1014.switchOffSignal2.value = false;
  trafo_g4_1021.switchOffSignal1.value = false;
  trafo_g4_1021.switchOffSignal2.value = false;
  trafo_g5_1022.switchOffSignal1.value = false;
  trafo_g5_1022.switchOffSignal2.value = false;
  trafo_g6_1042.switchOffSignal1.value = false;
  trafo_g6_1042.switchOffSignal2.value = false;
  trafo_g7_1043.switchOffSignal1.value = false;
  trafo_g7_1043.switchOffSignal2.value = false;
  trafo_g8_2032.switchOffSignal1.value = false;
  trafo_g8_2032.switchOffSignal2.value = false;
  trafo_g9_4011.switchOffSignal1.value = false;
  trafo_g9_4011.switchOffSignal2.value = false;
  trafo_g10_4012.switchOffSignal1.value = false;
  trafo_g10_4012.switchOffSignal2.value = false;
  trafo_g11_4021.switchOffSignal1.value = false;
  trafo_g11_4021.switchOffSignal2.value = false;
  trafo_g12_4031.switchOffSignal1.value = false;
  trafo_g12_4031.switchOffSignal2.value = false;
  trafo_g13_4041.switchOffSignal1.value = false;
  trafo_g13_4041.switchOffSignal2.value = false;
  trafo_g14_4042.switchOffSignal1.value = false;
  trafo_g14_4042.switchOffSignal2.value = false;
  trafo_g15_4047.switchOffSignal1.value = false;
  trafo_g15_4047.switchOffSignal2.value = false;
  trafo_g16_4051.switchOffSignal1.value = false;
  trafo_g16_4051.switchOffSignal2.value = false;
  trafo_g17_4062.switchOffSignal1.value = false;
  trafo_g17_4062.switchOffSignal2.value = false;
  trafo_g18_4063.switchOffSignal1.value = false;
  trafo_g18_4063.switchOffSignal2.value = false;
  trafo_g19_4071.switchOffSignal1.value = false;
  trafo_g19_4071.switchOffSignal2.value = false;
  trafo_g20_4072.switchOffSignal1.value = false;
  trafo_g20_4072.switchOffSignal2.value = false;
  trafo_1011_4011.switchOffSignal1.value = false;
  trafo_1011_4011.switchOffSignal2.value = false;
  trafo_1012_4012.switchOffSignal1.value = false;
  trafo_1012_4012.switchOffSignal2.value = false;
  trafo_1022_4022.switchOffSignal1.value = false;
  trafo_1022_4022.switchOffSignal2.value = false;
  trafo_1044_4044a.switchOffSignal1.value = false;
  trafo_1044_4044a.switchOffSignal2.value = false;
  trafo_1044_4044b.switchOffSignal1.value = false;
  trafo_1044_4044b.switchOffSignal2.value = false;
  trafo_1045_4045a.switchOffSignal1.value = false;
  trafo_1045_4045a.switchOffSignal2.value = false;
  trafo_1045_4045b.switchOffSignal1.value = false;
  trafo_1045_4045b.switchOffSignal2.value = false;
  trafo_2031_4031.switchOffSignal1.value = false;
  trafo_2031_4031.switchOffSignal2.value = false;

  omegaCOINum = g01.generatorSynchronous.omegaPu.value * g01.generatorSynchronous.H * g01.generatorSynchronous.SNom +
                g02.generatorSynchronous.omegaPu.value * g02.generatorSynchronous.H * g02.generatorSynchronous.SNom +
                g03.generatorSynchronous.omegaPu.value * g03.generatorSynchronous.H * g03.generatorSynchronous.SNom +
                g04.generatorSynchronous.omegaPu.value * g04.generatorSynchronous.H * g04.generatorSynchronous.SNom +
                g05.generatorSynchronous.omegaPu.value * g05.generatorSynchronous.H * g05.generatorSynchronous.SNom +
                g06.generatorSynchronous.omegaPu.value * g06.generatorSynchronous.H * g06.generatorSynchronous.SNom +
                g07.generatorSynchronous.omegaPu.value * g07.generatorSynchronous.H * g07.generatorSynchronous.SNom +
                g08.generatorSynchronous.omegaPu.value * g08.generatorSynchronous.H * g08.generatorSynchronous.SNom +
                g09.generatorSynchronous.omegaPu.value * g09.generatorSynchronous.H * g09.generatorSynchronous.SNom +
                g10.generatorSynchronous.omegaPu.value * g10.generatorSynchronous.H * g10.generatorSynchronous.SNom +
                g11.generatorSynchronous.omegaPu.value * g11.generatorSynchronous.H * g11.generatorSynchronous.SNom +
                g12.generatorSynchronous.omegaPu.value * g12.generatorSynchronous.H * g12.generatorSynchronous.SNom +
                g13.generatorSynchronous.omegaPu.value * g13.generatorSynchronous.H * g13.generatorSynchronous.SNom +
                g14.generatorSynchronous.omegaPu.value * g14.generatorSynchronous.H * g14.generatorSynchronous.SNom +
                g15.generatorSynchronous.omegaPu.value * g15.generatorSynchronous.H * g15.generatorSynchronous.SNom +
                g16.generatorSynchronous.omegaPu.value * g16.generatorSynchronous.H * g16.generatorSynchronous.SNom +
                g17.generatorSynchronous.omegaPu.value * g17.generatorSynchronous.H * g17.generatorSynchronous.SNom +
                g18.generatorSynchronous.omegaPu.value * g18.generatorSynchronous.H * g18.generatorSynchronous.SNom +
                g19.generatorSynchronous.omegaPu.value * g19.generatorSynchronous.H * g19.generatorSynchronous.SNom +
                g20.generatorSynchronous.omegaPu.value * g20.generatorSynchronous.H * g20.generatorSynchronous.SNom;

  omegaCOIDen = g01.generatorSynchronous.H * g01.generatorSynchronous.SNom +
                g02.generatorSynchronous.H * g02.generatorSynchronous.SNom +
                g03.generatorSynchronous.H * g03.generatorSynchronous.SNom +
                g04.generatorSynchronous.H * g04.generatorSynchronous.SNom +
                g05.generatorSynchronous.H * g05.generatorSynchronous.SNom +
                g06.generatorSynchronous.H * g06.generatorSynchronous.SNom +
                g07.generatorSynchronous.H * g07.generatorSynchronous.SNom +
                g08.generatorSynchronous.H * g08.generatorSynchronous.SNom +
                g09.generatorSynchronous.H * g09.generatorSynchronous.SNom +
                g10.generatorSynchronous.H * g10.generatorSynchronous.SNom +
                g11.generatorSynchronous.H * g11.generatorSynchronous.SNom +
                g12.generatorSynchronous.H * g12.generatorSynchronous.SNom +
                g13.generatorSynchronous.H * g13.generatorSynchronous.SNom +
                g14.generatorSynchronous.H * g14.generatorSynchronous.SNom +
                g15.generatorSynchronous.H * g15.generatorSynchronous.SNom +
                g16.generatorSynchronous.H * g16.generatorSynchronous.SNom +
                g17.generatorSynchronous.H * g17.generatorSynchronous.SNom +
                g18.generatorSynchronous.H * g18.generatorSynchronous.SNom +
                g19.generatorSynchronous.H * g19.generatorSynchronous.SNom +
                g20.generatorSynchronous.H * g20.generatorSynchronous.SNom;

  g01.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g02.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g03.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g04.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g05.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g06.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g07.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g08.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g09.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g10.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g11.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g12.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g13.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g14.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g15.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g16.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g17.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g18.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g19.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g20.generatorSynchronous.omegaRefPu.value = omegaCOI;

  check_UPu_bus_1041 = ComplexMath.'abs'(bus_1041.terminal.V);
  check_UPu_bus_1042 = ComplexMath.'abs'(bus_1042.terminal.V);
  check_UPu_bus_4012 = ComplexMath.'abs'(bus_4012.terminal.V);
  check_UPu_bus_4062 = ComplexMath.'abs'(bus_4062.terminal.V);
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
  check_f_g06 = g06.generatorSynchronous.omegaPu.value;
  check_f_g07 = g07.generatorSynchronous.omegaPu.value;
  check_f_g17 = g17.generatorSynchronous.omegaPu.value;
  check_UtPu_g06 = g06.generatorSynchronous.UPu;
  check_UtPu_g07 = g07.generatorSynchronous.UPu;

  connect(nodeFault.terminal, bus_4032.terminal);
  connect(disconnection.state1, line_4032_4044.switchOffSignal1);

  connect(g20.terminal, bus_BG20.terminal) annotation(
    Line(points = {{-75, 60}, {-75, 65}}, color = {0, 0, 255}));
  connect(trafo_1_1041.terminal2, bus_1041.terminal) annotation(
    Line(points = {{-55, -92}, {-55, -90}, {-60, -90}}, color = {0, 0, 255}));
  connect(trafo_1_1041.terminal1, bus_B01.terminal) annotation(
    Line(points = {{-55, -102}, {-55, -105}}, color = {0, 0, 255}));
  connect(trafo_2_1042.terminal2, bus_1042.terminal) annotation(
    Line(points = {{35, -82}, {35, -80}, {30, -80}}, color = {0, 0, 255}));
  connect(trafo_2_1042.terminal1, bus_B02.terminal) annotation(
    Line(points = {{35, -92}, {35, -95}}, color = {0, 0, 255}));
  connect(trafo_3_1043.terminal1, bus_B03.terminal) annotation(
    Line(points = {{-65, -48}, {-65, -45}}, color = {0, 0, 255}));
  connect(trafo_3_1043.terminal2, bus_1043.terminal) annotation(
    Line(points = {{-65, -58}, {-65, -60}, {-60, -60}}, color = {0, 0, 255}));
  connect(trafo_4_1044.terminal1, bus_B04.terminal) annotation(
    Line(points = {{-25, -48}, {-25, -45}}, color = {0, 0, 255}));
  connect(trafo_4_1044.terminal2, bus_1044.terminal) annotation(
    Line(points = {{-25, -58}, {-25, -60}, {-20, -60}}, color = {0, 0, 255}));
  connect(trafo_5_1045.terminal1, bus_B05.terminal) annotation(
    Line(points = {{-25, -102}, {-25, -105}}, color = {0, 0, 255}));
  connect(trafo_5_1045.terminal2, bus_1045.terminal) annotation(
    Line(points = {{-25, -92}, {-25, -90}, {-17, -90}}, color = {0, 0, 255}));
  connect(trafo_11_1011.terminal1, bus_B11.terminal) annotation(
    Line(points = {{21, 118}, {21, 115}}, color = {0, 0, 255}));
  connect(trafo_11_1011.terminal2, bus_1011.terminal) annotation(
    Line(points = {{21, 128}, {21, 130}, {30, 130}}, color = {0, 0, 255}));
  connect(trafo_12_1012.terminal1, bus_B12.terminal) annotation(
    Line(points = {{39, 113}, {39, 115}}, color = {0, 0, 255}));
  connect(trafo_12_1012.terminal2, bus_1012.terminal) annotation(
    Line(points = {{39, 103}, {39, 100}, {30, 100}}, color = {0, 0, 255}));
  connect(trafo_13_1013.terminal1, bus_B13.terminal) annotation(
    Line(points = {{85, 118}, {85, 115}}, color = {0, 0, 255}));
  connect(trafo_13_1013.terminal2, bus_1013.terminal) annotation(
    Line(points = {{85, 128}, {85, 130}, {80, 130}}, color = {0, 0, 255}));
  connect(trafo_22_1022.terminal2, bus_1022.terminal) annotation(
    Line(points = {{-40, 48}, {-40, 50}}, color = {0, 0, 255}));
  connect(trafo_22_1022.terminal1, bus_B22.terminal) annotation(
    Line(points = {{-40, 38}, {-40, 35}}, color = {0, 0, 255}));
  connect(trafo_31_2031.terminal1, bus_B31.terminal) annotation(
    Line(points = {{-35, 7}, {-35, 5}}, color = {0, 0, 255}));
  connect(trafo_31_2031.terminal2, bus_2031.terminal) annotation(
    Line(points = {{-35, 17}, {-35, 20}, {-40, 20}}, color = {0, 0, 255}));
  connect(trafo_32_2032.terminal1, bus_B32.terminal) annotation(
    Line(points = {{-89, 8}, {-89, 5}}, color = {0, 0, 255}));
  connect(trafo_32_2032.terminal2, bus_2032.terminal) annotation(
    Line(points = {{-89, 18}, {-89, 21}, {-80, 21}}, color = {0, 0, 255}));
  connect(trafo_41_4041.terminal2, bus_4041.terminal) annotation(
    Line(points = {{-81, -12}, {-81, -10}, {-78, -10}}, color = {0, 0, 255}));
  connect(trafo_41_4041.terminal1, bus_B41.terminal) annotation(
    Line(points = {{-81, -22}, {-81, -25}}, color = {0, 0, 255}));
  connect(trafo_42_4042.terminal1, bus_B42.terminal) annotation(
    Line(points = {{55, 3}, {55, 5}}, color = {0, 0, 255}));
  connect(trafo_42_4042.terminal2, bus_4042.terminal) annotation(
    Line(points = {{55, -7}, {55, -10}, {50, -10}}, color = {0, 0, 255}));
  connect(trafo_43_4043.terminal1, bus_B43.terminal) annotation(
    Line(points = {{25, -42}, {25, -45}}, color = {0, 0, 255}));
  connect(trafo_43_4043.terminal2, bus_4043.terminal) annotation(
    Line(points = {{25, -32}, {25, -30}, {30, -30}}, color = {0, 0, 255}));
  connect(trafo_46_4046.terminal1, bus_B46.terminal) annotation(
    Line(points = {{71, -43}, {71, -45}}, color = {0, 0, 255}));
  connect(trafo_46_4046.terminal2, bus_4046.terminal) annotation(
    Line(points = {{71, -33}, {71, -30}, {70, -30}}, color = {0, 0, 255}));
  connect(trafo_47_4047.terminal1, bus_B47.terminal) annotation(
    Line(points = {{61, -98}, {61, -95}}, color = {0, 0, 255}));
  connect(trafo_47_4047.terminal2, bus_4047.terminal) annotation(
    Line(points = {{61, -108}, {61, -110}, {70, -110}}, color = {0, 0, 255}));
  connect(trafo_51_4051.terminal1, bus_B51.terminal) annotation(
    Line(points = {{35, -118}, {35, -115}}, color = {0, 0, 255}));
  connect(trafo_51_4051.terminal2, bus_4051.terminal) annotation(
    Line(points = {{35, -128}, {35, -130}, {14, -130}}, color = {0, 0, 255}));
  connect(trafo_61_4061.terminal2, bus_4061.terminal) annotation(
    Line(points = {{-95, -53}, {-95, -50}, {-92, -50}}, color = {0, 0, 255}));
  connect(trafo_61_4061.terminal1, bus_B61.terminal) annotation(
    Line(points = {{-95, -63}, {-95, -65}}, color = {0, 0, 255}));
  connect(trafo_62_4062.terminal1, bus_B62.terminal) annotation(
    Line(points = {{-100, -97}, {-100, -95}}, color = {0, 0, 255}));
  connect(trafo_62_4062.terminal2, bus_4062.terminal) annotation(
    Line(points = {{-100, -107}, {-100, -110}, {-87, -110}}, color = {0, 0, 255}));
  connect(trafo_63_4063.terminal1, bus_B63.terminal) annotation(
    Line(points = {{-80, -142}, {-80, -145}}, color = {0, 0, 255}));
  connect(trafo_63_4063.terminal2, bus_4063.terminal) annotation(
    Line(points = {{-80, -132}, {-80, -130}, {-87, -130}}, color = {0, 0, 255}));
  connect(trafo_71_4071.terminal2, bus_4071.terminal) annotation(
    Line(points = {{-95, 128}, {-95, 130}, {-80, 130}}, color = {0, 0, 255}));
  connect(trafo_71_4071.terminal1, bus_B71.terminal) annotation(
    Line(points = {{-95, 118}, {-95, 115}}, color = {0, 0, 255}));
  connect(trafo_72_4072.terminal1, bus_B72.terminal) annotation(
    Line(points = {{-88, 68}, {-88, 65}}, color = {0, 0, 255}));
  connect(trafo_72_4072.terminal2, bus_4072.terminal) annotation(
    Line(points = {{-88, 78}, {-88, 81}, {-82, 81}}, color = {0, 0, 255}));
  connect(trafo_1011_4011.terminal1, bus_1011.terminal) annotation(
    Line(points = {{5, 125}, {16, 125}, {16, 130}, {30, 130}}, color = {0, 0, 255}));
  connect(trafo_1011_4011.terminal2, bus_4011.terminal) annotation(
    Line(points = {{-5, 125}, {-17, 125}, {-17, 130}, {-30, 130}}, color = {0, 0, 255}));
  connect(trafo_1012_4012.terminal1, bus_1012.terminal) annotation(
    Line(points = {{3, 96}, {17, 96}, {17, 100}, {30, 100}}, color = {0, 0, 255}));
  connect(trafo_1012_4012.terminal2, bus_4012.terminal) annotation(
    Line(points = {{-7, 96}, {-13, 96}, {-13, 100}, {-30, 100}}, color = {0, 0, 255}));
  connect(trafo_1022_4022.terminal1, bus_1022.terminal) annotation(
    Line(points = {{-30, 43}, {-30, 50}, {-40, 50}}, color = {0, 0, 255}));
  connect(trafo_1022_4022.terminal2, bus_4022.terminal) annotation(
    Line(points = {{-20, 43}, {-20, 49}, {-10, 49}}, color = {0, 0, 255}));
  connect(trafo_1044_4044b.terminal1, bus_1044.terminal) annotation(
    Line(points = {{-8, -50}, {-8, -60}, {-20, -60}}, color = {0, 0, 255}));
  connect(trafo_1044_4044a.terminal1, bus_1044.terminal) annotation(
    Line(points = {{-15, -50}, {-14, -50}, {-14, -60}, {-20, -60}}, color = {0, 0, 255}));
  connect(trafo_1044_4044b.terminal2, bus_4044.terminal) annotation(
    Line(points = {{-8, -40}, {-8, -30}, {-6, -30}}, color = {0, 0, 255}));
  connect(trafo_1044_4044a.terminal2, bus_4044.terminal) annotation(
    Line(points = {{-15, -40}, {-15, -30}, {-6, -30}}, color = {0, 0, 255}));
  connect(trafo_1045_4045b.terminal1, bus_1045.terminal) annotation(
    Line(points = {{-8, -95}, {-8, -90}, {-17, -90}}, color = {0, 0, 255}));
  connect(trafo_1045_4045a.terminal1, bus_1045.terminal) annotation(
    Line(points = {{-14, -95}, {-14, -90}, {-17, -90}}, color = {0, 0, 255}));
  connect(trafo_1045_4045b.terminal2, bus_4045.terminal) annotation(
    Line(points = {{-8, -105}, {-8, -110}, {0, -110}}, color = {0, 0, 255}));
  connect(trafo_1045_4045a.terminal2, bus_4045.terminal) annotation(
    Line(points = {{-14, -105}, {-14, -110}, {0, -110}}, color = {0, 0, 255}));
  connect(trafo_2031_4031.terminal1, bus_2031.terminal) annotation(
    Line(points = {{-31, 28}, {-31, 20}, {-40, 20}}, color = {0, 0, 255}));
  connect(trafo_2031_4031.terminal2, bus_4031.terminal) annotation(
    Line(points = {{-21, 28}, {-21, 21}, {-13, 21}}, color = {0, 0, 255}));
  connect(trafo_g1_1012.terminal2, bus_1012.terminal) annotation(
    Line(points = {{25, 98}, {25, 100}, {30, 100}}, color = {0, 0, 255}));
  connect(trafo_g1_1012.terminal1, bus_BG01.terminal) annotation(
    Line(points = {{25, 88}, {25, 85}}, color = {0, 0, 255}));
  connect(trafo_g2_1013.terminal2, bus_1013.terminal) annotation(
    Line(points = {{75, 133}, {75, 130}, {80, 130}}, color = {0, 0, 255}));
  connect(trafo_g2_1013.terminal1, bus_BG02.terminal) annotation(
    Line(points = {{75, 143}, {75, 145}}, color = {0, 0, 255}));
  connect(trafo_g3_1014.terminal1, bus_BG03.terminal) annotation(
    Line(points = {{85, 88}, {85, 85}}, color = {0, 0, 255}));
  connect(trafo_g3_1014.terminal2, bus_1014.terminal) annotation(
    Line(points = {{85, 98}, {85, 100}, {80, 100}}, color = {0, 0, 255}));
  connect(trafo_g4_1021.terminal1, bus_BG04.terminal) annotation(
    Line(points = {{-85, 38}, {-85, 35}}, color = {0, 0, 255}));
  connect(trafo_g4_1021.terminal2, bus_1021.terminal) annotation(
    Line(points = {{-85, 48}, {-85, 50}, {-80, 50}}, color = {0, 0, 255}));
  connect(trafo_g5_1022.terminal1, bus_BG05.terminal) annotation(
    Line(points = {{-45, 62}, {-45, 65}}, color = {0, 0, 255}));
  connect(trafo_g5_1022.terminal2, bus_1022.terminal) annotation(
    Line(points = {{-45, 52}, {-45, 50}, {-40, 50}}, color = {0, 0, 255}));
  connect(trafo_g6_1042.terminal1, bus_BG06.terminal) annotation(
    Line(points = {{35, -67}, {35, -65}}, color = {0, 0, 255}));
  connect(trafo_g6_1042.terminal2, bus_1042.terminal) annotation(
    Line(points = {{35, -77}, {35, -80}, {30, -80}}, color = {0, 0, 255}));
  connect(trafo_g7_1043.terminal1, bus_BG07.terminal) annotation(
    Line(points = {{-53, -48}, {-53, -45}}, color = {0, 0, 255}));
  connect(trafo_g7_1043.terminal2, bus_1043.terminal) annotation(
    Line(points = {{-53, -58}, {-53, -60}, {-60, -60}}, color = {0, 0, 255}));
  connect(trafo_g8_2032.terminal1, bus_BG08.terminal) annotation(
    Line(points = {{-77, 8}, {-77, 5}}, color = {0, 0, 255}));
  connect(trafo_g8_2032.terminal2, bus_2032.terminal) annotation(
    Line(points = {{-77, 18}, {-77, 21}, {-80, 21}}, color = {0, 0, 255}));
  connect(trafo_g9_4011.terminal1, bus_BG09.terminal) annotation(
    Line(points = {{-25, 143}, {-25, 145}}, color = {0, 0, 255}));
  connect(trafo_g9_4011.terminal2, bus_4011.terminal) annotation(
    Line(points = {{-25, 133}, {-25, 130}, {-30, 130}}, color = {0, 0, 255}));
  connect(trafo_g10_4012.terminal1, bus_BG10.terminal) annotation(
    Line(points = {{-35, 88}, {-35, 85}}, color = {0, 0, 255}));
  connect(trafo_g10_4012.terminal2, bus_4012.terminal) annotation(
    Line(points = {{-35, 98}, {-35, 100}, {-30, 100}}, color = {0, 0, 255}));
  connect(trafo_g11_4021.terminal1, bus_BG11.terminal) annotation(
    Line(points = {{35, 65}, {35, 63}}, color = {0, 0, 255}));
  connect(trafo_g11_4021.terminal2, bus_4021.terminal) annotation(
    Line(points = {{35, 53}, {35, 50}, {30, 50}}, color = {0, 0, 255}));
  connect(trafo_g12_4031.terminal1, bus_BG12.terminal) annotation(
    Line(points = {{-4, 33}, {-4, 35}}, color = {0, 0, 255}));
  connect(trafo_g12_4031.terminal2, bus_4031.terminal) annotation(
    Line(points = {{-4, 23}, {-4, 21}, {-13, 21}}, color = {0, 0, 255}));
  connect(trafo_g13_4041.terminal2, bus_4041.terminal) annotation(
    Line(points = {{-70, -12}, {-70, -10}, {-78, -10}}, color = {0, 0, 255}));
  connect(trafo_g13_4041.terminal1, bus_BG13.terminal) annotation(
    Line(points = {{-70, -22}, {-70, -25}}, color = {0, 0, 255}));
  connect(trafo_g15_4047.terminal1, bus_BG15.terminal) annotation(
    Line(points = {{80, -98}, {80, -95}}, color = {0, 0, 255}));
  connect(trafo_g15_4047.terminal2, bus_4047.terminal) annotation(
    Line(points = {{80, -108}, {80, -110}, {70, -110}}, color = {0, 0, 255}));
  connect(trafo_g16_4051.terminal1, bus_BG16.terminal) annotation(
    Line(points = {{20, -118}, {20, -115}}, color = {0, 0, 255}));
  connect(trafo_g16_4051.terminal2, bus_4051.terminal) annotation(
    Line(points = {{20, -128}, {20, -130}, {14, -130}}, color = {0, 0, 255}));
  connect(trafo_g14_4042.terminal1, bus_BG14.terminal) annotation(
    Line(points = {{50, -22}, {50, -25}}, color = {0, 0, 255}));
  connect(trafo_g14_4042.terminal2, bus_4042.terminal) annotation(
    Line(points = {{50, -12}, {50, -10}}, color = {0, 0, 255}));
  connect(trafo_g17_4062.terminal1, bus_BG17.terminal) annotation(
    Line(points = {{-78, -97}, {-78, -95}}, color = {0, 0, 255}));
  connect(trafo_g17_4062.terminal2, bus_4062.terminal) annotation(
    Line(points = {{-78, -107}, {-78, -110}, {-87, -110}}, color = {0, 0, 255}));
  connect(trafo_g18_4063.terminal1, bus_BG18.terminal) annotation(
    Line(points = {{-95, -142}, {-95, -145}}, color = {0, 0, 255}));
  connect(trafo_g18_4063.terminal2, bus_4063.terminal) annotation(
    Line(points = {{-95, -132}, {-95, -130}, {-87, -130}}, color = {0, 0, 255}));
  connect(trafo_g19_4071.terminal1, bus_BG19.terminal) annotation(
    Line(points = {{-75, 142}, {-75, 145}}, color = {0, 0, 255}));
  connect(trafo_g19_4071.terminal2, bus_4071.terminal) annotation(
    Line(points = {{-75, 132}, {-75, 130}, {-80, 130}}, color = {0, 0, 255}));
  connect(trafo_g20_4072.terminal1, bus_BG20.terminal) annotation(
    Line(points = {{-75, 68}, {-75, 65}}, color = {0, 0, 255}));
  connect(trafo_g20_4072.terminal2, bus_4072.terminal) annotation(
    Line(points = {{-75, 78}, {-75, 81}, {-82, 81}}, color = {0, 0, 255}));
  connect(g01.terminal, bus_BG01.terminal) annotation(
    Line(points = {{25, 79}, {25, 85}}, color = {0, 0, 255}));
  connect(g02.terminal, bus_BG02.terminal) annotation(
    Line(points = {{75, 151}, {75, 145}}, color = {0, 0, 255}));
  connect(g03.terminal, bus_BG03.terminal) annotation(
    Line(points = {{85, 79}, {85, 85}}, color = {0, 0, 255}));
  connect(g04.terminal, bus_BG04.terminal) annotation(
    Line(points = {{-85, 30}, {-85, 35}}, color = {0, 0, 255}));
  connect(g05.terminal, bus_BG05.terminal) annotation(
    Line(points = {{-45, 71}, {-45, 65}}, color = {0, 0, 255}));
  connect(g06.terminal, bus_BG06.terminal) annotation(
    Line(points = {{35, -60}, {35, -65}}, color = {0, 0, 255}));
  connect(g07.terminal, bus_BG07.terminal) annotation(
    Line(points = {{-53, -39}, {-53, -45}}, color = {0, 0, 255}));
  connect(g08.terminal, bus_BG08.terminal) annotation(
    Line(points = {{-77, 0}, {-77, 5}}, color = {0, 0, 255}));
  connect(g09.terminal, bus_BG09.terminal) annotation(
    Line(points = {{-25, 151}, {-25, 145}}, color = {0, 0, 255}));
  connect(g10.terminal, bus_BG10.terminal) annotation(
    Line(points = {{-35, 85}, {-35, 79}}, color = {0, 0, 255}));
  connect(g11.terminal, bus_BG11.terminal) annotation(
    Line(points = {{35, 72}, {35, 65}}, color = {0, 0, 255}));
  connect(g12.terminal, bus_BG12.terminal) annotation(
    Line(points = {{-4, 41}, {-4, 35}}, color = {0, 0, 255}));
  connect(g13.terminal, bus_BG13.terminal) annotation(
    Line(points = {{-70, -29}, {-70, -25}}, color = {0, 0, 255}));
  connect(g14.terminal, bus_BG14.terminal) annotation(
    Line(points = {{50, -30}, {50, -25}}, color = {0, 0, 255}));
  connect(g15.terminal, bus_BG15.terminal) annotation(
    Line(points = {{80, -89}, {80, -95}}, color = {0, 0, 255}));
  connect(g16.terminal, bus_BG16.terminal) annotation(
    Line(points = {{20, -109}, {20, -115}}, color = {0, 0, 255}));
  connect(g17.terminal, bus_BG17.terminal) annotation(
    Line(points = {{-78, -88}, {-78, -95}}, color = {0, 0, 255}));
  connect(g18.terminal, bus_BG18.terminal) annotation(
    Line(points = {{-95, -151}, {-95, -145}}, color = {0, 0, 255}));
  connect(g19.terminal, bus_BG19.terminal) annotation(
    Line(points = {{-75, 151}, {-75, 145}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(graphics = {Line(origin = {1.18, 21.94}, points = {{-103.176, -26.9412}, {19.8235, -26.9412}, {103.824, 42.0588}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {-58.3, -98.4}, points = {{-44.7012, 54.3963}, {-25.7012, 54.3963}, {-13.7012, 42.3963}, {-13.7012, -9.60369}, {31.2988, -54.6037}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {-80.5, 104}, points = {{-22.5, -48}, {22.5, -48}, {22.5, 48}}, pattern = LinePattern.Dash, thickness = 0.5), Text(origin = {-55, -145}, extent = {{-15, 5}, {15, -5}}, textString = "SOUTH", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {-35, -25}, extent = {{-15, 5}, {15, -5}}, textString = "CENTRAL", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {5, 145}, extent = {{-15, 5}, {15, -5}}, textString = "NORTH", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {-100, 150}, extent = {{-15, 5}, {15, -5}}, textString = "EQUIV.", textStyle = {TextStyle.Bold, TextStyle.Italic})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body><div>This model extends the network with alpha-beta loads model, it could also extend the network with PQ loads model.</div><div><br><div>This model implements the Nordic 32 test system presented in the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015. It is a modified version of the so-called Nordic32 test system, which was first proposed by K. Walve.</div><div><br><div>The system consists of 74 buses, 32 at transmission, 22 at distribution and 20 at generator level. Synchronous generators and distribution transformers are regulated. The initial values have been taken from the report.</div><div><br></div><div>Its main purpose is to simulate and study long-term voltage instabilities.</div></div></div></body></html>"));
end FullDynamicModel;
