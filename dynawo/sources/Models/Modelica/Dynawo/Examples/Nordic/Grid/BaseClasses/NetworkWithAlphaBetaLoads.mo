within Dynawo.Examples.Nordic.Grid.BaseClasses;

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

model NetworkWithAlphaBetaLoads "Nordic test grid with buses, lines, shunts and voltage-dependent loads"
  import Modelica.ComplexMath;
  import Modelica.SIunits;
  import Dynawo;
  import Dynawo.Electrical;
  import Dynawo.Types;

  extends Dynawo.Examples.Nordic.Grid.BaseClasses.Network;

  Electrical.Loads.LoadAlphaBeta load_01(alpha = 1, beta = 2, s0Pu = s0Pu_Load_01, u0Pu = u0Pu_Load_01, i0Pu = i0Pu_Load_01) annotation(
    Placement(visible = true, transformation(origin = {-55, -107}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_01(Value0 = P0Pu_Load_01);
  Electrical.Controls.Basics.SetPoint QrefPu_load_01(Value0 = Q0Pu_Load_01);
  Electrical.Loads.LoadAlphaBeta load_02(alpha = 1, beta = 2, s0Pu = s0Pu_Load_02, u0Pu = u0Pu_Load_02, i0Pu = i0Pu_Load_02) annotation(
    Placement(visible = true, transformation(origin = {35, -97}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_02(Value0 = P0Pu_Load_02);
  Electrical.Controls.Basics.SetPoint QrefPu_load_02(Value0 = Q0Pu_Load_02);
  Electrical.Loads.LoadAlphaBeta load_03(alpha = 1, beta = 2, s0Pu = s0Pu_Load_03, u0Pu = u0Pu_Load_03, i0Pu = i0Pu_Load_03) annotation(
    Placement(visible = true, transformation(origin = {-65, -43}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_03(Value0 = P0Pu_Load_03);
  Electrical.Controls.Basics.SetPoint QrefPu_load_03(Value0 = Q0Pu_Load_03);
  Electrical.Loads.LoadAlphaBeta load_04(alpha = 1, beta = 2, s0Pu = s0Pu_Load_04, u0Pu = u0Pu_Load_04, i0Pu = i0Pu_Load_04) annotation(
    Placement(visible = true, transformation(origin = {-25, -43}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_04(Value0 = P0Pu_Load_04);
  Electrical.Controls.Basics.SetPoint QrefPu_load_04(Value0 = Q0Pu_Load_04);
  Electrical.Loads.LoadAlphaBeta load_05(alpha = 1, beta = 2, s0Pu = s0Pu_Load_05, u0Pu = u0Pu_Load_05, i0Pu = i0Pu_Load_05) annotation(
    Placement(visible = true, transformation(origin = {-25, -107}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_05(Value0 = P0Pu_Load_05);
  Electrical.Controls.Basics.SetPoint QrefPu_load_05(Value0 = Q0Pu_Load_05);
  Electrical.Loads.LoadAlphaBeta load_11(alpha = 1, beta = 2, s0Pu = s0Pu_Load_11, u0Pu = u0Pu_Load_11, i0Pu = i0Pu_Load_11) annotation(
    Placement(visible = true, transformation(origin = {21, 113}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_11(Value0 = P0Pu_Load_11);
  Electrical.Controls.Basics.SetPoint QrefPu_load_11(Value0 = Q0Pu_Load_11);
  Electrical.Loads.LoadAlphaBeta load_12(alpha = 1, beta = 2, s0Pu = s0Pu_Load_12, u0Pu = u0Pu_Load_12, i0Pu = i0Pu_Load_12) annotation(
    Placement(visible = true, transformation(origin = {39, 118}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_12(Value0 = P0Pu_Load_12);
  Electrical.Controls.Basics.SetPoint QrefPu_load_12(Value0 = Q0Pu_Load_12);
  Electrical.Loads.LoadAlphaBeta load_13(alpha = 1, beta = 2, s0Pu = s0Pu_Load_13, u0Pu = u0Pu_Load_13, i0Pu = i0Pu_Load_13) annotation(
    Placement(visible = true, transformation(origin = {85, 113}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_13(Value0 = P0Pu_Load_13);
  Electrical.Controls.Basics.SetPoint QrefPu_load_13(Value0 = Q0Pu_Load_13);
  Electrical.Loads.LoadAlphaBeta load_22(alpha = 1, beta = 2, s0Pu = s0Pu_Load_22, u0Pu = u0Pu_Load_22, i0Pu = i0Pu_Load_22) annotation(
    Placement(visible = true, transformation(origin = {-40, 33}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_22(Value0 = P0Pu_Load_22);
  Electrical.Controls.Basics.SetPoint QrefPu_load_22(Value0 = Q0Pu_Load_22);
  Electrical.Loads.LoadAlphaBeta load_31(alpha = 1, beta = 2, s0Pu = s0Pu_Load_31, u0Pu = u0Pu_Load_31, i0Pu = i0Pu_Load_31) annotation(
    Placement(visible = true, transformation(origin = {-35, 3}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_31(Value0 = P0Pu_Load_31);
  Electrical.Controls.Basics.SetPoint QrefPu_load_31(Value0 = Q0Pu_Load_31);
  Electrical.Loads.LoadAlphaBeta load_32(alpha = 1, beta = 2, s0Pu = s0Pu_Load_32, u0Pu = u0Pu_Load_32, i0Pu = i0Pu_Load_32) annotation(
    Placement(visible = true, transformation(origin = {-89, 3}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_32(Value0 = P0Pu_Load_32);
  Electrical.Controls.Basics.SetPoint QrefPu_load_32(Value0 = Q0Pu_Load_32);
  Electrical.Loads.LoadAlphaBeta load_41(alpha = 1, beta = 2, s0Pu = s0Pu_Load_41, u0Pu = u0Pu_Load_41, i0Pu = i0Pu_Load_41) annotation(
    Placement(visible = true, transformation(origin = {-81, -27}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_41(Value0 = P0Pu_Load_41);
  Electrical.Controls.Basics.SetPoint QrefPu_load_41(Value0 = Q0Pu_Load_41);
  Electrical.Loads.LoadAlphaBeta load_42(alpha = 1, beta = 2, s0Pu = s0Pu_Load_42, u0Pu = u0Pu_Load_42, i0Pu = i0Pu_Load_42) annotation(
    Placement(visible = true, transformation(origin = {55, 7}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_42(Value0 = P0Pu_Load_42);
  Electrical.Controls.Basics.SetPoint QrefPu_load_42(Value0 = Q0Pu_Load_42);
  Electrical.Loads.LoadAlphaBeta load_43(alpha = 1, beta = 2, s0Pu = s0Pu_Load_43, u0Pu = u0Pu_Load_43, i0Pu = i0Pu_Load_43) annotation(
    Placement(visible = true, transformation(origin = {25, -47}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_43(Value0 = P0Pu_Load_43);
  Electrical.Controls.Basics.SetPoint QrefPu_load_43(Value0 = Q0Pu_Load_43);
  Electrical.Loads.LoadAlphaBeta load_46(alpha = 1, beta = 2, s0Pu = s0Pu_Load_46, u0Pu = u0Pu_Load_46, i0Pu = i0Pu_Load_46) annotation(
    Placement(visible = true, transformation(origin = {71, -47}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_46(Value0 = P0Pu_Load_46);
  Electrical.Controls.Basics.SetPoint QrefPu_load_46(Value0 = Q0Pu_Load_46);
  Electrical.Loads.LoadAlphaBeta load_47(alpha = 1, beta = 2, s0Pu = s0Pu_Load_47, u0Pu = u0Pu_Load_47, i0Pu = i0Pu_Load_47) annotation(
    Placement(visible = true, transformation(origin = {61, -93}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_47(Value0 = P0Pu_Load_47);
  Electrical.Controls.Basics.SetPoint QrefPu_load_47(Value0 = Q0Pu_Load_47);
  Electrical.Loads.LoadAlphaBeta load_51(alpha = 1, beta = 2, s0Pu = s0Pu_Load_51, u0Pu = u0Pu_Load_51, i0Pu = i0Pu_Load_51) annotation(
    Placement(visible = true, transformation(origin = {35, -113}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_51(Value0 = P0Pu_Load_51);
  Electrical.Controls.Basics.SetPoint QrefPu_load_51(Value0 = Q0Pu_Load_51);
  Electrical.Loads.LoadAlphaBeta load_61(alpha = 1, beta = 2, s0Pu = s0Pu_Load_61, u0Pu = u0Pu_Load_61, i0Pu = i0Pu_Load_61) annotation(
    Placement(visible = true, transformation(origin = {-95, -67}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_61(Value0 = P0Pu_Load_61);
  Electrical.Controls.Basics.SetPoint QrefPu_load_61(Value0 = Q0Pu_Load_61);
  Electrical.Loads.LoadAlphaBeta load_62(alpha = 1, beta = 2, s0Pu = s0Pu_Load_62, u0Pu = u0Pu_Load_62, i0Pu = i0Pu_Load_62) annotation(
    Placement(visible = true, transformation(origin = {-100, -93}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_62(Value0 = P0Pu_Load_62);
  Electrical.Controls.Basics.SetPoint QrefPu_load_62(Value0 = Q0Pu_Load_62);
  Electrical.Loads.LoadAlphaBeta load_63(alpha = 1, beta = 2, s0Pu = s0Pu_Load_63, u0Pu = u0Pu_Load_63, i0Pu = i0Pu_Load_63) annotation(
    Placement(visible = true, transformation(origin = {-80, -147}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_63(Value0 = P0Pu_Load_63);
  Electrical.Controls.Basics.SetPoint QrefPu_load_63(Value0 = Q0Pu_Load_63);
  Electrical.Loads.LoadAlphaBeta load_71(alpha = 1, beta = 2, s0Pu = s0Pu_Load_71, u0Pu = u0Pu_Load_71, i0Pu = i0Pu_Load_71) annotation(
    Placement(visible = true, transformation(origin = {-95, 113}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_71(Value0 = P0Pu_Load_71);
  Electrical.Controls.Basics.SetPoint QrefPu_load_71(Value0 = Q0Pu_Load_71);
  Electrical.Loads.LoadAlphaBeta load_72(alpha = 1, beta = 2, s0Pu = s0Pu_Load_72, u0Pu = u0Pu_Load_72, i0Pu = i0Pu_Load_72) annotation(
    Placement(visible = true, transformation(origin = {-88, 63}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.Basics.SetPoint PrefPu_load_72(Value0 = P0Pu_Load_72);
  Electrical.Controls.Basics.SetPoint QrefPu_load_72(Value0 = Q0Pu_Load_72);

  Electrical.Shunts.ShuntB shunt_1022(BPu = BPu_shunt_1022, u0Pu = u0Pu_shunt_1022, s0Pu = s0Pu_shunt_1022, i0Pu = i0Pu_shunt_1022) annotation(
    Placement(visible = true, transformation(origin = {-33.5, 56.5}, extent = {{-2.5, 2.5}, {2.5, -2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_1041(BPu = BPu_shunt_1041, u0Pu = u0Pu_shunt_1041, s0Pu = s0Pu_shunt_1041, i0Pu = i0Pu_shunt_1041) annotation(
    Placement(visible = true, transformation(origin = {-66.5, -94.5}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_1043(BPu = BPu_shunt_1043, u0Pu = u0Pu_shunt_1043, s0Pu = s0Pu_shunt_1043, i0Pu = i0Pu_shunt_1043) annotation(
    Placement(visible = true, transformation(origin = {-55.5, -67.5}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_1044(BPu = BPu_shunt_1044, u0Pu = u0Pu_shunt_1044, s0Pu = s0Pu_shunt_1044, i0Pu = i0Pu_shunt_1044) annotation(
    Placement(visible = true, transformation(origin = {-15.5, -67.5}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_1045(BPu = BPu_shunt_1045, u0Pu = u0Pu_shunt_1045, s0Pu = s0Pu_shunt_1045, i0Pu = i0Pu_shunt_1045) annotation(
    Placement(visible = true, transformation(origin = {-12.5, -83.5}, extent = {{-2.5, 2.5}, {2.5, -2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_4012(BPu = BPu_shunt_4012, u0Pu = u0Pu_shunt_4012, s0Pu = s0Pu_shunt_4012, i0Pu = i0Pu_shunt_4012) annotation(
    Placement(visible = true, transformation(origin = {-22.5, 106.5}, extent = {{-2.5, 2.5}, {2.5, -2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_4041(BPu = BPu_shunt_4041, u0Pu = u0Pu_shunt_4041, s0Pu = s0Pu_shunt_4041, i0Pu = i0Pu_shunt_4041) annotation(
    Placement(visible = true, transformation(origin = {-94.5, -14.5}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_4043(BPu = BPu_shunt_4043, u0Pu = u0Pu_shunt_4043, s0Pu = s0Pu_shunt_4043, i0Pu = i0Pu_shunt_4043) annotation(
    Placement(visible = true, transformation(origin = {24.5, -23.5}, extent = {{-2.5, 2.5}, {2.5, -2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_4046(BPu = BPu_shunt_4046, u0Pu = u0Pu_shunt_4046, s0Pu = s0Pu_shunt_4046, i0Pu = i0Pu_shunt_4046) annotation(
    Placement(visible = true, transformation(origin = {76.5, -22.5}, extent = {{-2.5, 2.5}, {2.5, -2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_4051(BPu = BPu_shunt_4051, u0Pu = u0Pu_shunt_4051, s0Pu = s0Pu_shunt_4051, i0Pu = i0Pu_shunt_4051) annotation(
    Placement(visible = true, transformation(origin = {21.5, -134.5}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_4071(BPu = BPu_shunt_4071, u0Pu = u0Pu_shunt_4071, s0Pu = s0Pu_shunt_4071, i0Pu = i0Pu_shunt_4071) annotation(
    Placement(visible = true, transformation(origin = {-85.5, 136.5}, extent = {{2.5, 2.5}, {-2.5, -2.5}}, rotation = 0)));

protected
  // Load_01 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_01 = 600.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_01 = 148.2 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_01 = Complex(P0Pu_Load_01, Q0Pu_Load_01);
  final parameter Types.Angle UPhase0_Load_01 = SIunits.Conversions.from_deg(-84.71);
  final parameter Types.VoltageModule U0Pu_Load_01 = 0.9988;
  final parameter Types.ComplexPerUnit u0Pu_Load_01 = ComplexMath.fromPolar(U0Pu_Load_01, UPhase0_Load_01);
  final parameter Types.ComplexPerUnit i0Pu_Load_01 = ComplexMath.conj(s0Pu_Load_01 / u0Pu_Load_01);
  // Load_02 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_02 = 330.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_02 = 71 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_02 = Complex(P0Pu_Load_02, Q0Pu_Load_02);
  final parameter Types.Angle UPhase0_Load_02 = SIunits.Conversions.from_deg(-70.49);
  final parameter Types.VoltageModule U0Pu_Load_02 = 1.0012;
  final parameter Types.ComplexPerUnit u0Pu_Load_02 = ComplexMath.fromPolar(U0Pu_Load_02, UPhase0_Load_02);
  final parameter Types.ComplexPerUnit i0Pu_Load_02 = ComplexMath.conj(s0Pu_Load_02 / u0Pu_Load_02);
  // Load_03 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_03 = 260.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_03 = 83.8 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_03 = Complex(P0Pu_Load_03, Q0Pu_Load_03);
  final parameter Types.Angle UPhase0_Load_03 = SIunits.Conversions.from_deg(-79.97);
  final parameter Types.VoltageModule U0Pu_Load_03 = 0.9974;
  final parameter Types.ComplexPerUnit u0Pu_Load_03 = ComplexMath.fromPolar(U0Pu_Load_03, UPhase0_Load_03);
  final parameter Types.ComplexPerUnit i0Pu_Load_03 = ComplexMath.conj(s0Pu_Load_03 / u0Pu_Load_03);
  // Load_04 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_04 = 840.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_04 = 252.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_04 = Complex(P0Pu_Load_04, Q0Pu_Load_04);
  final parameter Types.Angle UPhase0_Load_04 = SIunits.Conversions.from_deg(-70.67);
  final parameter Types.VoltageModule U0Pu_Load_04 = 0.9996;
  final parameter Types.ComplexPerUnit u0Pu_Load_04 = ComplexMath.fromPolar(U0Pu_Load_04, UPhase0_Load_04);
  final parameter Types.ComplexPerUnit i0Pu_Load_04 = ComplexMath.conj(s0Pu_Load_04 / u0Pu_Load_04);
  // Load_05 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_05 = 720.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_05 = 190.4 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_05 = Complex(P0Pu_Load_05, Q0Pu_Load_05);
  final parameter Types.Angle UPhase0_Load_05 = SIunits.Conversions.from_deg(-74.59);
  final parameter Types.VoltageModule U0Pu_Load_05 = 0.9961;
  final parameter Types.ComplexPerUnit u0Pu_Load_05 = ComplexMath.fromPolar(U0Pu_Load_05, UPhase0_Load_05);
  final parameter Types.ComplexPerUnit i0Pu_Load_05 = ComplexMath.conj(s0Pu_Load_05 / u0Pu_Load_05);
  // Load_11 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_11 = 200.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_11 = 68.8 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_11 = Complex(P0Pu_Load_11, Q0Pu_Load_11);
  final parameter Types.Angle UPhase0_Load_11 = SIunits.Conversions.from_deg(-9.45);
  final parameter Types.VoltageModule U0Pu_Load_11 = 1.0026;
  final parameter Types.ComplexPerUnit u0Pu_Load_11 = ComplexMath.fromPolar(U0Pu_Load_11, UPhase0_Load_11);
  final parameter Types.ComplexPerUnit i0Pu_Load_11 = ComplexMath.conj(s0Pu_Load_11 / u0Pu_Load_11);
  // Load_12 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_12 = 300.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_12 = 83.8 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_12 = Complex(P0Pu_Load_12, Q0Pu_Load_12);
  final parameter Types.Angle UPhase0_Load_12 = SIunits.Conversions.from_deg(-5.93);
  final parameter Types.VoltageModule U0Pu_Load_12 = 0.9975;
  final parameter Types.ComplexPerUnit u0Pu_Load_12 = ComplexMath.fromPolar(U0Pu_Load_12, UPhase0_Load_12);
  final parameter Types.ComplexPerUnit i0Pu_Load_12 = ComplexMath.conj(s0Pu_Load_12 / u0Pu_Load_12);
  // Load_13 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_13 = 100.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_13 = 34.4 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_13 = Complex(P0Pu_Load_13, Q0Pu_Load_13);
  final parameter Types.Angle UPhase0_Load_13 = SIunits.Conversions.from_deg(-1.58);
  final parameter Types.VoltageModule U0Pu_Load_13 = 0.9957;
  final parameter Types.ComplexPerUnit u0Pu_Load_13 = ComplexMath.fromPolar(U0Pu_Load_13, UPhase0_Load_13);
  final parameter Types.ComplexPerUnit i0Pu_Load_13 = ComplexMath.conj(s0Pu_Load_13 / u0Pu_Load_13);
  // Load_22 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_22 = 280.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_22 = 79.9 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_22 = Complex(P0Pu_Load_22, Q0Pu_Load_22);
  final parameter Types.Angle UPhase0_Load_22 = SIunits.Conversions.from_deg(-21.89);
  final parameter Types.VoltageModule U0Pu_Load_22 = 0.9952;
  final parameter Types.ComplexPerUnit u0Pu_Load_22 = ComplexMath.fromPolar(U0Pu_Load_22, UPhase0_Load_22);
  final parameter Types.ComplexPerUnit i0Pu_Load_22 = ComplexMath.conj(s0Pu_Load_22 / u0Pu_Load_22);
  // Load_31 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_31 = 100.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_31 = 24.7 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_31 = Complex(P0Pu_Load_31, Q0Pu_Load_31);
  final parameter Types.Angle UPhase0_Load_31 = SIunits.Conversions.from_deg(-39.47);
  final parameter Types.VoltageModule U0Pu_Load_31 = 1.0042;
  final parameter Types.ComplexPerUnit u0Pu_Load_31 = ComplexMath.fromPolar(U0Pu_Load_31, UPhase0_Load_31);
  final parameter Types.ComplexPerUnit i0Pu_Load_31 = ComplexMath.conj(s0Pu_Load_31 / u0Pu_Load_31);
  // Load_32 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_32 = 200.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_32 = 39.6 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_32 = Complex(P0Pu_Load_32, Q0Pu_Load_32);
  final parameter Types.Angle UPhase0_Load_32 = SIunits.Conversions.from_deg(-26.77);
  final parameter Types.VoltageModule U0Pu_Load_32 = 0.9978;
  final parameter Types.ComplexPerUnit u0Pu_Load_32 = ComplexMath.fromPolar(U0Pu_Load_32, UPhase0_Load_32);
  final parameter Types.ComplexPerUnit i0Pu_Load_32 = ComplexMath.conj(s0Pu_Load_32 / u0Pu_Load_32);
  // Load_41 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_41 = 540.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_41 = 131.4 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_41 = Complex(P0Pu_Load_41, Q0Pu_Load_41);
  final parameter Types.Angle UPhase0_Load_41 = SIunits.Conversions.from_deg(-57.14);
  final parameter Types.VoltageModule U0Pu_Load_41 = 0.9967;
  final parameter Types.ComplexPerUnit u0Pu_Load_41 = ComplexMath.fromPolar(U0Pu_Load_41, UPhase0_Load_41);
  final parameter Types.ComplexPerUnit i0Pu_Load_41 = ComplexMath.conj(s0Pu_Load_41 / u0Pu_Load_41);
  // Load_42 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_42 = 400.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_42 = 127.4 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_42 = Complex(P0Pu_Load_42, Q0Pu_Load_42);
  final parameter Types.Angle UPhase0_Load_42 = SIunits.Conversions.from_deg(-60.22);
  final parameter Types.VoltageModule U0Pu_Load_42 = 0.9952;
  final parameter Types.ComplexPerUnit u0Pu_Load_42 = ComplexMath.fromPolar(U0Pu_Load_42, UPhase0_Load_42);
  final parameter Types.ComplexPerUnit i0Pu_Load_42 = ComplexMath.conj(s0Pu_Load_42 / u0Pu_Load_42);
  // Load_43 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_43 = 900.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_43 = 254.6 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_43 = Complex(P0Pu_Load_43, Q0Pu_Load_43);
  final parameter Types.Angle UPhase0_Load_43 = SIunits.Conversions.from_deg(-66.33);
  final parameter Types.VoltageModule U0Pu_Load_43 = 1.0013;
  final parameter Types.ComplexPerUnit u0Pu_Load_43 = ComplexMath.fromPolar(U0Pu_Load_43, UPhase0_Load_43);
  final parameter Types.ComplexPerUnit i0Pu_Load_43 = ComplexMath.conj(s0Pu_Load_43 / u0Pu_Load_43);
  // Load_46 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_46 = 700.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_46 = 211.8 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_46 = Complex(P0Pu_Load_46, Q0Pu_Load_46);
  final parameter Types.Angle UPhase0_Load_46 = SIunits.Conversions.from_deg(-66.93);
  final parameter Types.VoltageModule U0Pu_Load_46 = 0.999;
  final parameter Types.ComplexPerUnit u0Pu_Load_46 = ComplexMath.fromPolar(U0Pu_Load_46, UPhase0_Load_46);
  final parameter Types.ComplexPerUnit i0Pu_Load_46 = ComplexMath.conj(s0Pu_Load_46 / u0Pu_Load_46);
  // Load_47 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_47 = 100.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_47 = 44.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_47 = Complex(P0Pu_Load_47, Q0Pu_Load_47);
  final parameter Types.Angle UPhase0_Load_47 = SIunits.Conversions.from_deg(-62.38);
  final parameter Types.VoltageModule U0Pu_Load_47 = 0.995;
  final parameter Types.ComplexPerUnit u0Pu_Load_47 = ComplexMath.fromPolar(U0Pu_Load_47, UPhase0_Load_47);
  final parameter Types.ComplexPerUnit i0Pu_Load_47 = ComplexMath.conj(s0Pu_Load_47 / u0Pu_Load_47);
  // Load_51 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_51 = 800.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_51 = 258.2 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_51 = Complex(P0Pu_Load_51, Q0Pu_Load_51);
  final parameter Types.Angle UPhase0_Load_51 = SIunits.Conversions.from_deg(-73.84);
  final parameter Types.VoltageModule U0Pu_Load_51 = 0.9978;
  final parameter Types.ComplexPerUnit u0Pu_Load_51 = ComplexMath.fromPolar(U0Pu_Load_51, UPhase0_Load_51);
  final parameter Types.ComplexPerUnit i0Pu_Load_51 = ComplexMath.conj(s0Pu_Load_51 / u0Pu_Load_51);
  // Load_61 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_61 = 500.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_61 = 122.5 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_61 = Complex(P0Pu_Load_61, Q0Pu_Load_61);
  final parameter Types.Angle UPhase0_Load_61 = SIunits.Conversions.from_deg(-60.78);
  final parameter Types.VoltageModule U0Pu_Load_61 = 0.9949;
  final parameter Types.ComplexPerUnit u0Pu_Load_61 = ComplexMath.fromPolar(U0Pu_Load_61, UPhase0_Load_61);
  final parameter Types.ComplexPerUnit i0Pu_Load_61 = ComplexMath.conj(s0Pu_Load_61 / u0Pu_Load_61);
  // Load_62 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_62 = 300.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_62 = 83.8 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_62 = Complex(P0Pu_Load_62, Q0Pu_Load_62);
  final parameter Types.Angle UPhase0_Load_62 = SIunits.Conversions.from_deg(-57.18);
  final parameter Types.VoltageModule U0Pu_Load_62 = 1.0002;
  final parameter Types.ComplexPerUnit u0Pu_Load_62 = ComplexMath.fromPolar(U0Pu_Load_62, UPhase0_Load_62);
  final parameter Types.ComplexPerUnit i0Pu_Load_62 = ComplexMath.conj(s0Pu_Load_62 / u0Pu_Load_62);
  // Load_63 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_63 = 590.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_63 = 264.6 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_63 = Complex(P0Pu_Load_63, Q0Pu_Load_63);
  final parameter Types.Angle UPhase0_Load_63 = SIunits.Conversions.from_deg(-53.49);
  final parameter Types.VoltageModule U0Pu_Load_63 = 0.9992;
  final parameter Types.ComplexPerUnit u0Pu_Load_63 = ComplexMath.fromPolar(U0Pu_Load_63, UPhase0_Load_63);
  final parameter Types.ComplexPerUnit i0Pu_Load_63 = ComplexMath.conj(s0Pu_Load_63 / u0Pu_Load_63);
  // Load_71 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_71 = 300.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_71 = 83.8 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_71 = Complex(P0Pu_Load_71, Q0Pu_Load_71);
  final parameter Types.Angle UPhase0_Load_71 = SIunits.Conversions.from_deg(-7.8);
  final parameter Types.VoltageModule U0Pu_Load_71 = 1.0028;
  final parameter Types.ComplexPerUnit u0Pu_Load_71 = ComplexMath.fromPolar(U0Pu_Load_71, UPhase0_Load_71);
  final parameter Types.ComplexPerUnit i0Pu_Load_71 = ComplexMath.conj(s0Pu_Load_71 / u0Pu_Load_71);
  // Load_72 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.PerUnit P0Pu_Load_72 = 2000.0 / Electrical.SystemBase.SnRef;
  final parameter Types.PerUnit Q0Pu_Load_72 = 396.1 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit s0Pu_Load_72 = Complex(P0Pu_Load_72, Q0Pu_Load_72);
  final parameter Types.Angle UPhase0_Load_72 = SIunits.Conversions.from_deg(-6.83);
  final parameter Types.VoltageModule U0Pu_Load_72 = 0.9974;
  final parameter Types.ComplexPerUnit u0Pu_Load_72 = ComplexMath.fromPolar(U0Pu_Load_72, UPhase0_Load_72);
  final parameter Types.ComplexPerUnit i0Pu_Load_72 = ComplexMath.conj(s0Pu_Load_72 / u0Pu_Load_72);
  final parameter SIunits.Impedance XBase_130 = 130 ^ 2 / Electrical.SystemBase.SnRef;
  final parameter SIunits.Impedance XBase_220 = 220 ^ 2 / Electrical.SystemBase.SnRef;
  final parameter SIunits.Impedance XBase_400 = 400 ^ 2 / Electrical.SystemBase.SnRef;

  // shunt_1022 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_1022 = -50.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit u0Pu_shunt_1022 = ComplexMath.fromPolar(1.0512, SIunits.Conversions.from_deg(-19.05));
  final parameter Types.PerUnit U0Pu_shunt_1022 = ComplexMath.'abs'(u0Pu_shunt_1022);
  final parameter Types.PerUnit Q0Pu_shunt_1022 = BPu_shunt_1022 * U0Pu_shunt_1022 ^ 2;
  final parameter Types.ComplexPerUnit s0Pu_shunt_1022 = Complex(0, Q0Pu_shunt_1022);
  final parameter Types.ComplexPerUnit i0Pu_shunt_1022 = ComplexMath.conj(s0Pu_shunt_1022 / u0Pu_shunt_1022);
  // shunt_1041 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_1041 = -250.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit u0Pu_shunt_1041 = ComplexMath.fromPolar(1.0124, SIunits.Conversions.from_deg(-81.87));
  final parameter Types.PerUnit U0Pu_shunt_1041 = ComplexMath.'abs'(u0Pu_shunt_1041);
  final parameter Types.PerUnit Q0Pu_shunt_1041 = BPu_shunt_1041 * U0Pu_shunt_1041 ^ 2;
  final parameter Types.ComplexPerUnit s0Pu_shunt_1041 = Complex(0, Q0Pu_shunt_1041);
  final parameter Types.ComplexPerUnit i0Pu_shunt_1041 = ComplexMath.conj(s0Pu_shunt_1041 / u0Pu_shunt_1041);
  // shunt_1043 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_1043 = -200.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit u0Pu_shunt_1043 = ComplexMath.fromPolar(1.0274, SIunits.Conversions.from_deg(-76.77));
  final parameter Types.PerUnit U0Pu_shunt_1043 = ComplexMath.'abs'(u0Pu_shunt_1043);
  final parameter Types.PerUnit Q0Pu_shunt_1043 = BPu_shunt_1043 * U0Pu_shunt_1043 ^ 2;
  final parameter Types.ComplexPerUnit s0Pu_shunt_1043 = Complex(0, Q0Pu_shunt_1043);
  final parameter Types.ComplexPerUnit i0Pu_shunt_1043 = ComplexMath.conj(s0Pu_shunt_1043 / u0Pu_shunt_1043);
  // shunt_1044 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_1044 = -200.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit u0Pu_shunt_1044 = ComplexMath.fromPolar(1.0066, SIunits.Conversions.from_deg(-67.71));
  final parameter Types.PerUnit U0Pu_shunt_1044 = ComplexMath.'abs'(u0Pu_shunt_1044);
  final parameter Types.PerUnit Q0Pu_shunt_1044 = BPu_shunt_1044 * U0Pu_shunt_1044 ^ 2;
  final parameter Types.ComplexPerUnit s0Pu_shunt_1044 = Complex(0, Q0Pu_shunt_1044);
  final parameter Types.ComplexPerUnit i0Pu_shunt_1044 = ComplexMath.conj(s0Pu_shunt_1044 / u0Pu_shunt_1044);
  // shunt_1045 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_1045 = -200.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit u0Pu_shunt_1045 = ComplexMath.fromPolar(1.0111, SIunits.Conversions.from_deg(-71.66));
  final parameter Types.PerUnit U0Pu_shunt_1045 = ComplexMath.'abs'(u0Pu_shunt_1045);
  final parameter Types.PerUnit Q0Pu_shunt_1045 = BPu_shunt_1045 * U0Pu_shunt_1045 ^ 2;
  final parameter Types.ComplexPerUnit s0Pu_shunt_1045 = Complex(0, Q0Pu_shunt_1045);
  final parameter Types.ComplexPerUnit i0Pu_shunt_1045 = ComplexMath.conj(s0Pu_shunt_1045 / u0Pu_shunt_1045);
  // shunt_4012 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_4012 = 100.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit u0Pu_shunt_4012 = ComplexMath.fromPolar(1.0235, SIunits.Conversions.from_deg(-5.54));
  final parameter Types.PerUnit U0Pu_shunt_4012 = ComplexMath.'abs'(u0Pu_shunt_4012);
  final parameter Types.PerUnit Q0Pu_shunt_4012 = BPu_shunt_4012 * U0Pu_shunt_4012 ^ 2;
  final parameter Types.ComplexPerUnit s0Pu_shunt_4012 = Complex(0, Q0Pu_shunt_4012);
  final parameter Types.ComplexPerUnit i0Pu_shunt_4012 = ComplexMath.conj(s0Pu_shunt_4012 / u0Pu_shunt_4012);
  // shunt_4041 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_4041 = -200.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit u0Pu_shunt_4041 = ComplexMath.fromPolar(1.0506, SIunits.Conversions.from_deg(-54.30));
  final parameter Types.PerUnit U0Pu_shunt_4041 = ComplexMath.'abs'(u0Pu_shunt_4041);
  final parameter Types.PerUnit Q0Pu_shunt_4041 = BPu_shunt_4041 * U0Pu_shunt_4041 ^ 2;
  final parameter Types.ComplexPerUnit s0Pu_shunt_4041 = Complex(0, Q0Pu_shunt_4041);
  final parameter Types.ComplexPerUnit i0Pu_shunt_4041 = ComplexMath.conj(s0Pu_shunt_4041 / u0Pu_shunt_4041);
  // shunt_4043 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_4043 = -200.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit u0Pu_shunt_4043 = ComplexMath.fromPolar(1.0370, SIunits.Conversions.from_deg(-63.51));
  final parameter Types.PerUnit U0Pu_shunt_4043 = ComplexMath.'abs'(u0Pu_shunt_4043);
  final parameter Types.PerUnit Q0Pu_shunt_4043 = BPu_shunt_4043 * U0Pu_shunt_4043 ^ 2;
  final parameter Types.ComplexPerUnit s0Pu_shunt_4043 = Complex(0, Q0Pu_shunt_4043);
  final parameter Types.ComplexPerUnit i0Pu_shunt_4043 = ComplexMath.conj(s0Pu_shunt_4043 / u0Pu_shunt_4043);
  // shunt_4046 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_4046 = -100.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit u0Pu_shunt_4046 = ComplexMath.fromPolar(1.0357, SIunits.Conversions.from_deg(-64.11));
  final parameter Types.PerUnit U0Pu_shunt_4046 = ComplexMath.'abs'(u0Pu_shunt_4046);
  final parameter Types.PerUnit Q0Pu_shunt_4046 = BPu_shunt_4046 * U0Pu_shunt_4046 ^ 2;
  final parameter Types.ComplexPerUnit s0Pu_shunt_4046 = Complex(0, Q0Pu_shunt_4046);
  final parameter Types.ComplexPerUnit i0Pu_shunt_4046 = ComplexMath.conj(s0Pu_shunt_4046 / u0Pu_shunt_4046);
  // shunt_4051 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_4051 = -100.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit u0Pu_shunt_4051 = ComplexMath.fromPolar(1.0659, SIunits.Conversions.from_deg(-71.01));
  final parameter Types.PerUnit U0Pu_shunt_4051 = ComplexMath.'abs'(u0Pu_shunt_4051);
  final parameter Types.PerUnit Q0Pu_shunt_4051 = BPu_shunt_4051 * U0Pu_shunt_4051 ^ 2;
  final parameter Types.ComplexPerUnit s0Pu_shunt_4051 = Complex(0, Q0Pu_shunt_4051);
  final parameter Types.ComplexPerUnit i0Pu_shunt_4051 = ComplexMath.conj(s0Pu_shunt_4051 / u0Pu_shunt_4051);
  // shunt_4071 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_4071 = 400.0 / Electrical.SystemBase.SnRef;
  final parameter Types.ComplexPerUnit u0Pu_shunt_4071 = ComplexMath.fromPolar(1.0484, SIunits.Conversions.from_deg(-4.99));
  final parameter Types.PerUnit U0Pu_shunt_4071 = ComplexMath.'abs'(u0Pu_shunt_4071);
  final parameter Types.PerUnit Q0Pu_shunt_4071 = BPu_shunt_4071 * U0Pu_shunt_4071 ^ 2;
  final parameter Types.ComplexPerUnit s0Pu_shunt_4071 = Complex(0, Q0Pu_shunt_4071);
  final parameter Types.ComplexPerUnit i0Pu_shunt_4071 = ComplexMath.conj(s0Pu_shunt_4071 / u0Pu_shunt_4071);

equation
  load_11.deltaP = 0;
  load_11.deltaQ = 0;
  load_12.deltaP = 0;
  load_12.deltaQ = 0;
  load_13.deltaP = 0;
  load_13.deltaQ = 0;
  load_22.deltaP = 0;
  load_22.deltaQ = 0;
  load_01.deltaP = 0;
  load_01.deltaQ = 0;
  load_02.deltaP = 0;
  load_02.deltaQ = 0;
  load_03.deltaP = 0;
  load_03.deltaQ = 0;
  load_04.deltaP = 0;
  load_04.deltaQ = 0;
  load_05.deltaP = 0;
  load_05.deltaQ = 0;
  load_31.deltaP = 0;
  load_31.deltaQ = 0;
  load_32.deltaP = 0;
  load_32.deltaQ = 0;
  load_41.deltaP = 0;
  load_41.deltaQ = 0;
  load_42.deltaP = 0;
  load_42.deltaQ = 0;
  load_43.deltaP = 0;
  load_43.deltaQ = 0;
  load_46.deltaP = 0;
  load_46.deltaQ = 0;
  load_47.deltaP = 0;
  load_47.deltaQ = 0;
  load_51.deltaP = 0;
  load_51.deltaQ = 0;
  load_61.deltaP = 0;
  load_61.deltaQ = 0;
  load_62.deltaP = 0;
  load_62.deltaQ = 0;
  load_63.deltaP = 0;
  load_63.deltaQ = 0;
  load_71.deltaP = 0;
  load_71.deltaQ = 0;
  load_72.deltaP = 0;
  load_72.deltaQ = 0;
  load_11.switchOffSignal1.value = false;
  load_11.switchOffSignal2.value = false;
  load_12.switchOffSignal1.value = false;
  load_12.switchOffSignal2.value = false;
  load_13.switchOffSignal1.value = false;
  load_13.switchOffSignal2.value = false;
  load_22.switchOffSignal1.value = false;
  load_22.switchOffSignal2.value = false;
  load_01.switchOffSignal1.value = false;
  load_01.switchOffSignal2.value = false;
  load_02.switchOffSignal1.value = false;
  load_02.switchOffSignal2.value = false;
  load_03.switchOffSignal1.value = false;
  load_03.switchOffSignal2.value = false;
  load_04.switchOffSignal1.value = false;
  load_04.switchOffSignal2.value = false;
  load_05.switchOffSignal1.value = false;
  load_05.switchOffSignal2.value = false;
  load_31.switchOffSignal1.value = false;
  load_31.switchOffSignal2.value = false;
  load_32.switchOffSignal1.value = false;
  load_32.switchOffSignal2.value = false;
  load_41.switchOffSignal1.value = false;
  load_41.switchOffSignal2.value = false;
  load_42.switchOffSignal1.value = false;
  load_42.switchOffSignal2.value = false;
  load_43.switchOffSignal1.value = false;
  load_43.switchOffSignal2.value = false;
  load_46.switchOffSignal1.value = false;
  load_46.switchOffSignal2.value = false;
  load_47.switchOffSignal1.value = false;
  load_47.switchOffSignal2.value = false;
  load_51.switchOffSignal1.value = false;
  load_51.switchOffSignal2.value = false;
  load_61.switchOffSignal1.value = false;
  load_61.switchOffSignal2.value = false;
  load_62.switchOffSignal1.value = false;
  load_62.switchOffSignal2.value = false;
  load_63.switchOffSignal1.value = false;
  load_63.switchOffSignal2.value = false;
  load_71.switchOffSignal1.value = false;
  load_71.switchOffSignal2.value = false;
  load_72.switchOffSignal1.value = false;
  load_72.switchOffSignal2.value = false;
  shunt_1022.switchOffSignal1.value = false;
  shunt_1022.switchOffSignal2.value = false;
  shunt_1041.switchOffSignal1.value = false;
  shunt_1041.switchOffSignal2.value = false;
  shunt_1043.switchOffSignal1.value = false;
  shunt_1043.switchOffSignal2.value = false;
  shunt_1044.switchOffSignal1.value = false;
  shunt_1044.switchOffSignal2.value = false;
  shunt_1045.switchOffSignal1.value = false;
  shunt_1045.switchOffSignal2.value = false;
  shunt_4012.switchOffSignal1.value = false;
  shunt_4012.switchOffSignal2.value = false;
  shunt_4041.switchOffSignal1.value = false;
  shunt_4041.switchOffSignal2.value = false;
  shunt_4043.switchOffSignal1.value = false;
  shunt_4043.switchOffSignal2.value = false;
  shunt_4046.switchOffSignal1.value = false;
  shunt_4046.switchOffSignal2.value = false;
  shunt_4051.switchOffSignal1.value = false;
  shunt_4051.switchOffSignal2.value = false;
  shunt_4071.switchOffSignal1.value = false;
  shunt_4071.switchOffSignal2.value = false;
  PrefPu_load_01.setPoint.value = load_01.PRefPu;
  QrefPu_load_01.setPoint.value = load_01.QRefPu;
  PrefPu_load_02.setPoint.value = load_02.PRefPu;
  QrefPu_load_02.setPoint.value = load_02.QRefPu;
  QrefPu_load_03.setPoint.value = load_03.QRefPu;
  PrefPu_load_03.setPoint.value = load_03.PRefPu;
  PrefPu_load_04.setPoint.value = load_04.PRefPu;
  QrefPu_load_04.setPoint.value = load_04.QRefPu;
  PrefPu_load_05.setPoint.value = load_05.PRefPu;
  QrefPu_load_05.setPoint.value = load_05.QRefPu;
  PrefPu_load_11.setPoint.value = load_11.PRefPu;
  QrefPu_load_11.setPoint.value = load_11.QRefPu;
  PrefPu_load_12.setPoint.value = load_12.PRefPu;
  QrefPu_load_12.setPoint.value = load_12.QRefPu;
  PrefPu_load_13.setPoint.value = load_13.PRefPu;
  QrefPu_load_13.setPoint.value = load_13.QRefPu;
  QrefPu_load_22.setPoint.value = load_22.QRefPu;
  PrefPu_load_22.setPoint.value = load_22.PRefPu;
  PrefPu_load_31.setPoint.value = load_31.PRefPu;
  QrefPu_load_31.setPoint.value = load_31.QRefPu;
  PrefPu_load_32.setPoint.value = load_32.PRefPu;
  QrefPu_load_32.setPoint.value = load_32.QRefPu;
  PrefPu_load_41.setPoint.value = load_41.PRefPu;
  QrefPu_load_41.setPoint.value = load_41.QRefPu;
  PrefPu_load_42.setPoint.value = load_42.PRefPu;
  QrefPu_load_42.setPoint.value = load_42.QRefPu;
  PrefPu_load_43.setPoint.value = load_43.PRefPu;
  QrefPu_load_43.setPoint.value = load_43.QRefPu;
  PrefPu_load_46.setPoint.value = load_46.PRefPu;
  QrefPu_load_46.setPoint.value = load_46.QRefPu;
  PrefPu_load_47.setPoint.value = load_47.PRefPu;
  QrefPu_load_47.setPoint.value = load_47.QRefPu;
  PrefPu_load_51.setPoint.value = load_51.PRefPu;
  QrefPu_load_51.setPoint.value = load_51.QRefPu;
  QrefPu_load_61.setPoint.value = load_61.QRefPu;
  PrefPu_load_61.setPoint.value = load_61.PRefPu;
  PrefPu_load_62.setPoint.value = load_62.PRefPu;
  QrefPu_load_62.setPoint.value = load_62.QRefPu;
  PrefPu_load_63.setPoint.value = load_63.PRefPu;
  QrefPu_load_63.setPoint.value = load_63.QRefPu;
  QrefPu_load_71.setPoint.value = load_71.QRefPu;
  PrefPu_load_71.setPoint.value = load_71.PRefPu;
  PrefPu_load_72.setPoint.value = load_72.PRefPu;
  QrefPu_load_72.setPoint.value = load_72.QRefPu;

  connect(shunt_4012.terminal, bus_4012.terminal) annotation(
    Line(points = {{-22.5, 106.5}, {-22.5, 100}, {-30, 100}}, color = {0, 0, 255}));
  connect(shunt_4071.terminal, bus_4071.terminal) annotation(
    Line(points = {{-85.5, 136.5}, {-85.5, 130}, {-80, 130}}, color = {0, 0, 255}));
  connect(shunt_1022.terminal, bus_1022.terminal) annotation(
    Line(points = {{-33.5, 56.5}, {-33.5, 50}, {-40, 50}}, color = {0, 0, 255}));
  connect(shunt_4043.terminal, bus_4043.terminal) annotation(
    Line(points = {{24.5, -23.5}, {24.5, -29}, {30, -29}, {30, -30}}, color = {0, 0, 255}));
  connect(shunt_4046.terminal, bus_4046.terminal) annotation(
    Line(points = {{76.5, -22.5}, {76, -22.5}, {76, -30}, {70, -30}}, color = {0, 0, 255}));
  connect(shunt_4051.terminal, bus_4051.terminal) annotation(
    Line(points = {{21.5, -134.5}, {21.5, -130}, {14, -130}}, color = {0, 0, 255}));
  connect(shunt_1044.terminal, bus_1044.terminal) annotation(
    Line(points = {{-15.5, -67.5}, {-15.5, -60}, {-20, -60}}, color = {0, 0, 255}));
  connect(shunt_1043.terminal, bus_1043.terminal) annotation(
    Line(points = {{-55.5, -67.5}, {-55.5, -60}, {-60, -60}}, color = {0, 0, 255}));
  connect(shunt_1041.terminal, bus_1041.terminal) annotation(
    Line(points = {{-66.5, -94.5}, {-66.5, -90}, {-60, -90}}, color = {0, 0, 255}));
  connect(shunt_1045.terminal, bus_1045.terminal) annotation(
    Line(points = {{-12.5, -83.5}, {-12.5, -90}, {-17, -90}}, color = {0, 0, 255}));
  connect(shunt_4041.terminal, bus_4041.terminal) annotation(
    Line(points = {{-94.5, -14.5}, {-94.5, -10}, {-78, -10}}, color = {0, 0, 255}));
  connect(load_01.terminal, bus_B01.terminal) annotation(
    Line(points = {{-55, -107}, {-55, -107}, {-55, -105}, {-55, -105}}, color = {0, 0, 255}));
  connect(load_02.terminal, bus_B02.terminal) annotation(
    Line(points = {{35, -97}, {35, -95}}, color = {0, 0, 255}));
  connect(load_03.terminal, bus_B03.terminal) annotation(
    Line(points = {{-65, -43}, {-65, -45}}, color = {0, 0, 255}));
  connect(load_04.terminal, bus_B04.terminal) annotation(
    Line(points = {{-25, -43}, {-25, -43}, {-25, -45}, {-25, -45}}, color = {0, 0, 255}));
  connect(load_05.terminal, bus_B05.terminal) annotation(
    Line(points = {{-25, -107}, {-25, -105}}, color = {0, 0, 255}));
  connect(load_11.terminal, bus_B11.terminal) annotation(
    Line(points = {{21, 113}, {21, 115}}, color = {0, 0, 255}));
  connect(load_12.terminal, bus_B12.terminal) annotation(
    Line(points = {{39, 118}, {39, 115}}, color = {0, 0, 255}));
  connect(load_13.terminal, bus_B13.terminal) annotation(
    Line(points = {{85, 113}, {85, 113}, {85, 115}, {85, 115}}, color = {0, 0, 255}));
  connect(load_22.terminal, bus_B22.terminal) annotation(
    Line(points = {{-40, 33}, {-40, 33}, {-40, 35}, {-40, 35}}, color = {0, 0, 255}));
  connect(load_31.terminal, bus_B31.terminal) annotation(
    Line(points = {{-35, 3}, {-35, 5}}, color = {0, 0, 255}));
  connect(load_32.terminal, bus_B32.terminal) annotation(
    Line(points = {{-89, 3}, {-89, 3}, {-89, 3}, {-88, 3}, {-88, 5}, {-89, 5}, {-89, 5}, {-89, 5}}, color = {0, 0, 255}));
  connect(load_41.terminal, bus_B41.terminal) annotation(
    Line(points = {{-81, -27}, {-81, -25}}, color = {0, 0, 255}));
  connect(load_42.terminal, bus_B42.terminal) annotation(
    Line(points = {{55, 7}, {55, 5}}, color = {0, 0, 255}));
  connect(load_43.terminal, bus_B43.terminal) annotation(
    Line(points = {{25, -47}, {25, -47}, {25, -45}, {25, -45}}, color = {0, 0, 255}));
  connect(load_46.terminal, bus_B46.terminal) annotation(
    Line(points = {{71, -47}, {71, -47}, {71, -45}, {71, -45}, {71, -45}, {71, -45}}, color = {0, 0, 255}));
  connect(load_47.terminal, bus_B47.terminal) annotation(
    Line(points = {{61, -93}, {61, -95}}, color = {0, 0, 255}));
  connect(load_51.terminal, bus_B51.terminal) annotation(
    Line(points = {{35, -113}, {35, -115}}, color = {0, 0, 255}));
  connect(load_61.terminal, bus_B61.terminal) annotation(
    Line(points = {{-95, -67}, {-95, -67}, {-95, -65}, {-95, -65}}, color = {0, 0, 255}));
  connect(load_62.terminal, bus_B62.terminal) annotation(
    Line(points = {{-100, -93}, {-100, -95}}, color = {0, 0, 255}));
  connect(load_63.terminal, bus_B63.terminal) annotation(
    Line(points = {{-80, -147}, {-80, -147}, {-80, -145}, {-80, -145}}, color = {0, 0, 255}));
  connect(load_71.terminal, bus_B71.terminal) annotation(
    Line(points = {{-95, 113}, {-95, 115}}, color = {0, 0, 255}));
  connect(load_72.terminal, bus_B72.terminal) annotation(
    Line(points = {{-88, 63}, {-88, 65}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-100, -150}, {100, 150}}, grid = {1, 1}, preserveAspectRatio = false, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-100, -150}, {100, 150}}, grid = {1, 1}, preserveAspectRatio = false)),
    version = "",
    uses(Dynawo(version = "1.0.1")),
    __OpenModelica_commandLineOptions = "",
    Documentation(info = "<html><head></head><body>This network model extends the base network. It adds AlphaBetaLoads with alpha = 1 and beta = 2 as well as shunts, as described in&nbsp;the&nbsp;<span style=\"font-size: 12px; font-family: 'MS Shell Dlg 2';\">IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015</span>. The initial values have been taken from the report.</body></html>"));
end NetworkWithAlphaBetaLoads;
