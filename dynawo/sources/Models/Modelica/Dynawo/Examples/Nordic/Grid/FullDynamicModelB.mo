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

model FullDynamicModelB "Nordic test grid with buses, lines, shunts, voltage-dependent loads, transformers and generators (operating point B)"
  import Modelica.SIunits;
  import Dynawo;
  import Dynawo.Examples.Nordic.Data;
  import Dynawo.Types;

  extends Dynawo.Examples.Nordic.Grid.FullDynamicModelA(
    g01(Q0Pu = Q0Pu_g01b, UPhase0 = UPhase0_g01b),
    g02(Q0Pu = Q0Pu_g02b, UPhase0 = UPhase0_g02b),
    g03(Q0Pu = Q0Pu_g03b, UPhase0 = UPhase0_g03b),
    g04(Q0Pu = Q0Pu_g04b, UPhase0 = UPhase0_g04b),
    g05(Q0Pu = Q0Pu_g05b, UPhase0 = UPhase0_g05b),
    g06(Q0Pu = Q0Pu_g06b, UPhase0 = UPhase0_g06b),
    g07(Q0Pu = Q0Pu_g07b, UPhase0 = UPhase0_g07b),
    g08(Q0Pu = Q0Pu_g08b, UPhase0 = UPhase0_g08b),
    g09(Q0Pu = Q0Pu_g09b, UPhase0 = UPhase0_g09b),
    g10(Q0Pu = Q0Pu_g10b, UPhase0 = UPhase0_g10b),
    g11(Q0Pu = Q0Pu_g11b, UPhase0 = UPhase0_g11b),
    g12(Q0Pu = Q0Pu_g12b, UPhase0 = UPhase0_g12b),
    g13(Q0Pu = Q0Pu_g13b, UPhase0 = UPhase0_g13b),
    g14(Q0Pu = Q0Pu_g14b, UPhase0 = UPhase0_g14b),
    g15(Q0Pu = Q0Pu_g15b, UPhase0 = UPhase0_g15b),
    g16(Q0Pu = Q0Pu_g16b, UPhase0 = UPhase0_g16b),
    g17(Q0Pu = Q0Pu_g17b, UPhase0 = UPhase0_g17b),
    g18(Q0Pu = Q0Pu_g18b, UPhase0 = UPhase0_g18b),
    g19(Q0Pu = Q0Pu_g19b, UPhase0 = UPhase0_g19b),
    g20(P0Pu = P0Pu_g20b, Q0Pu = Q0Pu_g20b, UPhase0 = UPhase0_g20b),
    load_01(s0Pu = s0Pu_load_01b, u0Pu = u0Pu_load_01b, i0Pu = i0Pu_load_01b),
    load_02(s0Pu = s0Pu_load_02b, u0Pu = u0Pu_load_02b, i0Pu = i0Pu_load_02b),
    load_03(s0Pu = s0Pu_load_03b, u0Pu = u0Pu_load_03b, i0Pu = i0Pu_load_03b),
    load_04(s0Pu = s0Pu_load_04b, u0Pu = u0Pu_load_04b, i0Pu = i0Pu_load_04b),
    load_05(s0Pu = s0Pu_load_05b, u0Pu = u0Pu_load_05b, i0Pu = i0Pu_load_05b),
    load_11(s0Pu = s0Pu_load_11b, u0Pu = u0Pu_load_11b, i0Pu = i0Pu_load_11b),
    load_12(s0Pu = s0Pu_load_12b, u0Pu = u0Pu_load_12b, i0Pu = i0Pu_load_12b),
    load_13(s0Pu = s0Pu_load_13b, u0Pu = u0Pu_load_13b, i0Pu = i0Pu_load_13b),
    load_22(s0Pu = s0Pu_load_22b, u0Pu = u0Pu_load_22b, i0Pu = i0Pu_load_22b),
    load_31(s0Pu = s0Pu_load_31b, u0Pu = u0Pu_load_31b, i0Pu = i0Pu_load_31b),
    load_32(s0Pu = s0Pu_load_32b, u0Pu = u0Pu_load_32b, i0Pu = i0Pu_load_32b),
    load_41(s0Pu = s0Pu_load_41b, u0Pu = u0Pu_load_41b, i0Pu = i0Pu_load_41b),
    load_42(s0Pu = s0Pu_load_42b, u0Pu = u0Pu_load_42b, i0Pu = i0Pu_load_42b),
    load_43(s0Pu = s0Pu_load_43b, u0Pu = u0Pu_load_43b, i0Pu = i0Pu_load_43b),
    load_46(s0Pu = s0Pu_load_46b, u0Pu = u0Pu_load_46b, i0Pu = i0Pu_load_46b),
    load_47(s0Pu = s0Pu_load_47b, u0Pu = u0Pu_load_47b, i0Pu = i0Pu_load_47b),
    load_51(s0Pu = s0Pu_load_51b, u0Pu = u0Pu_load_51b, i0Pu = i0Pu_load_51b),
    load_61(s0Pu = s0Pu_load_61b, u0Pu = u0Pu_load_61b, i0Pu = i0Pu_load_61b),
    load_62(s0Pu = s0Pu_load_62b, u0Pu = u0Pu_load_62b, i0Pu = i0Pu_load_62b),
    load_63(s0Pu = s0Pu_load_63b, u0Pu = u0Pu_load_63b, i0Pu = i0Pu_load_63b),
    load_71(s0Pu = s0Pu_load_71b, u0Pu = u0Pu_load_71b, i0Pu = i0Pu_load_71b),
    load_72(s0Pu = s0Pu_load_72b, u0Pu = u0Pu_load_72b, i0Pu = i0Pu_load_72b),
    shunt_1022(s0Pu = s0Pu_shunt_1022b, u0Pu = u0Pu_shunt_1022b, i0Pu = i0Pu_shunt_1022b),
    shunt_1041(s0Pu = s0Pu_shunt_1041b, u0Pu = u0Pu_shunt_1041b, i0Pu = i0Pu_shunt_1041b),
    shunt_1043(s0Pu = s0Pu_shunt_1043b, u0Pu = u0Pu_shunt_1043b, i0Pu = i0Pu_shunt_1043b),
    shunt_1044(s0Pu = s0Pu_shunt_1044b, u0Pu = u0Pu_shunt_1044b, i0Pu = i0Pu_shunt_1044b),
    shunt_1045(s0Pu = s0Pu_shunt_1045b, u0Pu = u0Pu_shunt_1045b, i0Pu = i0Pu_shunt_1045b),
    shunt_4012(s0Pu = s0Pu_shunt_4012b, u0Pu = u0Pu_shunt_4012b, i0Pu = i0Pu_shunt_4012b),
    shunt_4041(s0Pu = s0Pu_shunt_4041b, u0Pu = u0Pu_shunt_4041b, i0Pu = i0Pu_shunt_4041b),
    shunt_4043(s0Pu = s0Pu_shunt_4043b, u0Pu = u0Pu_shunt_4043b, i0Pu = i0Pu_shunt_4043b),
    shunt_4046(s0Pu = s0Pu_shunt_4046b, u0Pu = u0Pu_shunt_4046b, i0Pu = i0Pu_shunt_4046b),
    shunt_4051(s0Pu = s0Pu_shunt_4051b, u0Pu = u0Pu_shunt_4051b, i0Pu = i0Pu_shunt_4051b),
    shunt_4071(s0Pu = s0Pu_shunt_4071b, u0Pu = u0Pu_shunt_4071b, i0Pu = i0Pu_shunt_4071b));

  Dynawo.Electrical.Buses.Bus bus_BG16b annotation(
    Placement(visible = true, transformation(origin = {5, -145}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Dynawo.Electrical.Transformers.TransformerFixedRatio trafo_g16_4051b(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 700.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {5, -137}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));

  Dynawo.Examples.Nordic.Components.GeneratorWithControl.GeneratorSynchronousFourWindingsWithControl g16b(P0Pu = P0Pu_g16, Q0Pu = Q0Pu_g16b, U0Pu = U0Pu_g16, UPhase0 = UPhase0_g16b, gen = Data.GeneratorParameters.genFramePreset.g16) annotation(
    Placement(visible = true, transformation(origin = {5, -151}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));

protected
  // Generator g01 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g01b = 14.92 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g01b = SIunits.Conversions.from_deg(-6.17);
  // Generator g02 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g02b = 17.1 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g02b = SIunits.Conversions.from_deg(-3.56);
  // Generator g03 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g03b = 7.43 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g03b = SIunits.Conversions.from_deg(1.51);
  // Generator g04 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g04b = 12.22 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g04b = SIunits.Conversions.from_deg(3.13);
  // Generator g05 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g05b = 17.77 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g05b = SIunits.Conversions.from_deg(-16.40);
  // Generator g06 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g06b = -97.15 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g06b = SIunits.Conversions.from_deg(-48.58);
  // Generator g07 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g07b = 1.94 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g07b = SIunits.Conversions.from_deg(-57.72);
  // Generator g08 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g08b = -137.99 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g08b = SIunits.Conversions.from_deg(-15.33);
  // Generator g09 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g09b = -47.92 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g09b = SIunits.Conversions.from_deg(-10.01);
  // Generator g10 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g10b = -158.78 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g10b = SIunits.Conversions.from_deg(-7.72);
  // Generator g11 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g11b = 62.7 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g11b = SIunits.Conversions.from_deg(-27.95);
  // Generator g12 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g12b = 42.02 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g12b = SIunits.Conversions.from_deg(-29.66);
  // Generator g13 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g13b = 99.01 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g13b = SIunits.Conversions.from_deg(-47.90);
  // Generator g14 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g14b = -59.77 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g14b = SIunits.Conversions.from_deg(-42.42);
  // Generator g15 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g15b = -169.01 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g15b = SIunits.Conversions.from_deg(-43.40);
  // Generator g16 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g16b = -67.06 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g16b = SIunits.Conversions.from_deg(-46.02);
  // Generator g17 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g17b = 15.49 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g17b = SIunits.Conversions.from_deg(-38.02);
  // Generator g18 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g18b = -228.07 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g18b = SIunits.Conversions.from_deg(-34.46);
  // Generator g19 init values:
  // Q0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_g19b = -110.34 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g19b = SIunits.Conversions.from_deg(-16.12);
  // Generator g20 init values:
  // P0Pu, Q0Pu in SnRef, receptor convention
  final parameter Types.ActivePowerPu P0Pu_g20b = -1537.4 / Electrical.SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_g20b = -354.67 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_g20b = SIunits.Conversions.from_deg(-22.06);

  // load_01 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_01b = 149.2 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_01b = SIunits.Conversions.from_deg(-72.22);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_01b = Complex(P0Pu_load_01, Q0Pu_load_01b);
  final parameter Types.ComplexVoltagePu u0Pu_load_01b = ComplexMath.fromPolar(U0Pu_load_01, UPhase0_load_01b);
  final parameter Types.ComplexCurrentPu i0Pu_load_01b = ComplexMath.conj(s0Pu_load_01b / u0Pu_load_01b);
  // load_02 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_02b = 71.8 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_02b = SIunits.Conversions.from_deg(-59.51);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_02b = Complex(P0Pu_load_02, Q0Pu_load_02b);
  final parameter Types.ComplexVoltagePu u0Pu_load_02b = ComplexMath.fromPolar(U0Pu_load_02, UPhase0_load_02b);
  final parameter Types.ComplexCurrentPu i0Pu_load_02b = ComplexMath.conj(s0Pu_load_02b / u0Pu_load_02b);
  // load_03 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_03b = 84.9 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_03b = SIunits.Conversions.from_deg(-68.36);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_03b = Complex(P0Pu_load_03, Q0Pu_load_03b);
  final parameter Types.ComplexVoltagePu u0Pu_load_03b = ComplexMath.fromPolar(U0Pu_load_03, UPhase0_load_03b);
  final parameter Types.ComplexCurrentPu i0Pu_load_03b = ComplexMath.conj(s0Pu_load_03b / u0Pu_load_03b);
  // load_04 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_04b = 253.1 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_04b = SIunits.Conversions.from_deg(-60.57);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_04b = Complex(P0Pu_load_04, Q0Pu_load_04b);
  final parameter Types.ComplexVoltagePu u0Pu_load_04b = ComplexMath.fromPolar(U0Pu_load_04, UPhase0_load_04b);
  final parameter Types.ComplexCurrentPu i0Pu_load_04b = ComplexMath.conj(s0Pu_load_04b / u0Pu_load_04b);
  // load_05 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_05b = 193.4 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_05b = SIunits.Conversions.from_deg(-62.03);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_05b = Complex(P0Pu_load_05, Q0Pu_load_05b);
  final parameter Types.ComplexVoltagePu u0Pu_load_05b = ComplexMath.fromPolar(U0Pu_load_05, UPhase0_load_05b);
  final parameter Types.ComplexCurrentPu i0Pu_load_05b = ComplexMath.conj(s0Pu_load_05b / u0Pu_load_05b);
  // load_11 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_11b = 71.7 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_11b = SIunits.Conversions.from_deg(-17.67);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_11b = Complex(P0Pu_load_11, Q0Pu_load_11b);
  final parameter Types.ComplexVoltagePu u0Pu_load_11b = ComplexMath.fromPolar(U0Pu_load_11, UPhase0_load_11b);
  final parameter Types.ComplexCurrentPu i0Pu_load_11b = ComplexMath.conj(s0Pu_load_11b / u0Pu_load_11b);
  // load_12 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_12b = 84.2 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_12b = SIunits.Conversions.from_deg(-14.56);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_12b = Complex(P0Pu_load_12, Q0Pu_load_12b);
  final parameter Types.ComplexVoltagePu u0Pu_load_12b = ComplexMath.fromPolar(U0Pu_load_12, UPhase0_load_12b);
  final parameter Types.ComplexCurrentPu i0Pu_load_12b = ComplexMath.conj(s0Pu_load_12b / u0Pu_load_12b);
  // load_13 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_13b = 34.9 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_13b = SIunits.Conversions.from_deg(-10.15);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_13b = Complex(P0Pu_load_13, Q0Pu_load_13b);
  final parameter Types.ComplexVoltagePu u0Pu_load_13b = ComplexMath.fromPolar(U0Pu_load_13, UPhase0_load_13b);
  final parameter Types.ComplexCurrentPu i0Pu_load_13b = ComplexMath.conj(s0Pu_load_13b / u0Pu_load_13b);
  // load_22 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_22b = 87.2 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_22b = SIunits.Conversions.from_deg(-25.47);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_22b = Complex(P0Pu_load_22, Q0Pu_load_22b);
  final parameter Types.ComplexVoltagePu u0Pu_load_22b = ComplexMath.fromPolar(U0Pu_load_22, UPhase0_load_22b);
  final parameter Types.ComplexCurrentPu i0Pu_load_22b = ComplexMath.conj(s0Pu_load_22b / u0Pu_load_22b);
  // load_31 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_31b = 27.3 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_31b = SIunits.Conversions.from_deg(-36.98);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_31b = Complex(P0Pu_load_31, Q0Pu_load_31b);
  final parameter Types.ComplexVoltagePu u0Pu_load_31b = ComplexMath.fromPolar(U0Pu_load_31, UPhase0_load_31b);
  final parameter Types.ComplexCurrentPu i0Pu_load_31b = ComplexMath.conj(s0Pu_load_31b / u0Pu_load_31b);
  // load_32 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_32b = 40.1 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_32b = SIunits.Conversions.from_deg(-25.11);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_32b = Complex(P0Pu_load_32, Q0Pu_load_32b);
  final parameter Types.ComplexVoltagePu u0Pu_load_32b = ComplexMath.fromPolar(U0Pu_load_32, UPhase0_load_32b);
  final parameter Types.ComplexCurrentPu i0Pu_load_32b = ComplexMath.conj(s0Pu_load_32b / u0Pu_load_32b);
  // load_41 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_41b = 144.7 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_41b = SIunits.Conversions.from_deg(-50.61);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_41b = Complex(P0Pu_load_41, Q0Pu_load_41b);
  final parameter Types.ComplexVoltagePu u0Pu_load_41b = ComplexMath.fromPolar(U0Pu_load_41, UPhase0_load_41b);
  final parameter Types.ComplexCurrentPu i0Pu_load_41b = ComplexMath.conj(s0Pu_load_41b / u0Pu_load_41b);
  // load_42 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_42b = 129.7 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_42b = SIunits.Conversions.from_deg(-52.36);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_42b = Complex(P0Pu_load_42, Q0Pu_load_42b);
  final parameter Types.ComplexVoltagePu u0Pu_load_42b = ComplexMath.fromPolar(U0Pu_load_42, UPhase0_load_42b);
  final parameter Types.ComplexCurrentPu i0Pu_load_42b = ComplexMath.conj(s0Pu_load_42b / u0Pu_load_42b);
  // load_43 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_43b = 256.9 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_43b = SIunits.Conversions.from_deg(-57.19);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_43b = Complex(P0Pu_load_43, Q0Pu_load_43b);
  final parameter Types.ComplexVoltagePu u0Pu_load_43b = ComplexMath.fromPolar(U0Pu_load_43, UPhase0_load_43b);
  final parameter Types.ComplexCurrentPu i0Pu_load_43b = ComplexMath.conj(s0Pu_load_43b / u0Pu_load_43b);
  // load_46 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_46b = 215 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_46b = SIunits.Conversions.from_deg(-57.73);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_46b = Complex(P0Pu_load_46, Q0Pu_load_46b);
  final parameter Types.ComplexVoltagePu u0Pu_load_46b = ComplexMath.fromPolar(U0Pu_load_46, UPhase0_load_46b);
  final parameter Types.ComplexCurrentPu i0Pu_load_46b = ComplexMath.conj(s0Pu_load_46b / u0Pu_load_46b);
  // load_47 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_47b = 44.4 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_47b = SIunits.Conversions.from_deg(-53.40);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_47b = Complex(P0Pu_load_47, Q0Pu_load_47b);
  final parameter Types.ComplexVoltagePu u0Pu_load_47b = ComplexMath.fromPolar(U0Pu_load_47, UPhase0_load_47b);
  final parameter Types.ComplexCurrentPu i0Pu_load_47b = ComplexMath.conj(s0Pu_load_47b / u0Pu_load_47b);
  // load_51 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_51b = 264.2 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_51b = SIunits.Conversions.from_deg(-55.52);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_51b = Complex(P0Pu_load_51, Q0Pu_load_51b);
  final parameter Types.ComplexVoltagePu u0Pu_load_51b = ComplexMath.fromPolar(U0Pu_load_51, UPhase0_load_51b);
  final parameter Types.ComplexCurrentPu i0Pu_load_51b = ComplexMath.conj(s0Pu_load_51b / u0Pu_load_51b);
  // load_61 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_61b = 124.4 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_61b = SIunits.Conversions.from_deg(-52.44);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_61b = Complex(P0Pu_load_61, Q0Pu_load_61b);
  final parameter Types.ComplexVoltagePu u0Pu_load_61b = ComplexMath.fromPolar(U0Pu_load_61, UPhase0_load_61b);
  final parameter Types.ComplexCurrentPu i0Pu_load_61b = ComplexMath.conj(s0Pu_load_61b / u0Pu_load_61b);
  // load_62 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_62b = 84.8 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_62b = SIunits.Conversions.from_deg(-48.21);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_62b = Complex(P0Pu_load_62, Q0Pu_load_62b);
  final parameter Types.ComplexVoltagePu u0Pu_load_62b = ComplexMath.fromPolar(U0Pu_load_62, UPhase0_load_62b);
  final parameter Types.ComplexCurrentPu i0Pu_load_62b = ComplexMath.conj(s0Pu_load_62b / u0Pu_load_62b);
  // load_63 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_63b = 263.6 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_63b = SIunits.Conversions.from_deg(-44.57);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_63b = Complex(P0Pu_load_63, Q0Pu_load_63b);
  final parameter Types.ComplexVoltagePu u0Pu_load_63b = ComplexMath.fromPolar(U0Pu_load_63, UPhase0_load_63b);
  final parameter Types.ComplexCurrentPu i0Pu_load_63b = ComplexMath.conj(s0Pu_load_63b / u0Pu_load_63b);
  // load_71 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_71b = 84.3 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_71b = SIunits.Conversions.from_deg(-23.90);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_71b = Complex(P0Pu_load_71, Q0Pu_load_71b);
  final parameter Types.ComplexVoltagePu u0Pu_load_71b = ComplexMath.fromPolar(U0Pu_load_71, UPhase0_load_71b);
  final parameter Types.ComplexCurrentPu i0Pu_load_71b = ComplexMath.conj(s0Pu_load_71b / u0Pu_load_71b);
  // load_72 init values:
  //s0Pu, i0Pu in SnRef, receptor convention
  final parameter Types.ReactivePowerPu Q0Pu_load_72b = 395.8 / Electrical.SystemBase.SnRef;
  final parameter Types.Angle UPhase0_load_72b = SIunits.Conversions.from_deg(-27.74);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_72b = Complex(P0Pu_load_72, Q0Pu_load_72b);
  final parameter Types.ComplexVoltagePu u0Pu_load_72b = ComplexMath.fromPolar(U0Pu_load_72, UPhase0_load_72b);
  final parameter Types.ComplexCurrentPu i0Pu_load_72b = ComplexMath.conj(s0Pu_load_72b / u0Pu_load_72b);

  // shunt_1022 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.Angle UPhase0_shunt_1022b = SIunits.Conversions.from_deg(-22.74);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_1022b = BPu_shunt_1022 * U0Pu_shunt_1022 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_1022b = Complex(0, Q0Pu_shunt_1022b);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_1022b = ComplexMath.fromPolar(U0Pu_shunt_1022, UPhase0_shunt_1022b);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_1022b = ComplexMath.conj(s0Pu_shunt_1022b / u0Pu_shunt_1022b);
  // shunt_1041 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.Angle UPhase0_shunt_1041b = SIunits.Conversions.from_deg(-69.40);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_1041b = BPu_shunt_1041 * U0Pu_shunt_1041 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_1041b = Complex(0, Q0Pu_shunt_1041b);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_1041b = ComplexMath.fromPolar(U0Pu_shunt_1041, UPhase0_shunt_1041b);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_1041b = ComplexMath.conj(s0Pu_shunt_1041b / u0Pu_shunt_1041b);
  // shunt_1043 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.Angle UPhase0_shunt_1043b = SIunits.Conversions.from_deg(-65.19);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_1043b = BPu_shunt_1043 * U0Pu_shunt_1043 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_1043b = Complex(0, Q0Pu_shunt_1043b);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_1043b = ComplexMath.fromPolar(U0Pu_shunt_1043, UPhase0_shunt_1043b);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_1043b = ComplexMath.conj(s0Pu_shunt_1043b / u0Pu_shunt_1043b);
  // shunt_1044 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.Angle UPhase0_shunt_1044b = SIunits.Conversions.from_deg(-57.61);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_1044b = BPu_shunt_1044 * U0Pu_shunt_1044 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_1044b = Complex(0, Q0Pu_shunt_1044b);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_1044b = ComplexMath.fromPolar(U0Pu_shunt_1044, UPhase0_shunt_1044b);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_1044b = ComplexMath.conj(s0Pu_shunt_1044b / u0Pu_shunt_1044b);
  // shunt_1045 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.Angle UPhase0_shunt_1045b = SIunits.Conversions.from_deg(-59.13);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_1045b = BPu_shunt_1045 * U0Pu_shunt_1045 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_1045b = Complex(0, Q0Pu_shunt_1045b);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_1045b = ComplexMath.fromPolar(U0Pu_shunt_1045, UPhase0_shunt_1045b);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_1045b = ComplexMath.conj(s0Pu_shunt_1045b / u0Pu_shunt_1045b);
  // shunt_4012 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.Angle UPhase0_shunt_4012b = SIunits.Conversions.from_deg(-14.07);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_4012b = BPu_shunt_4012 * U0Pu_shunt_4012 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_4012b = Complex(0, Q0Pu_shunt_4012b);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_4012b = ComplexMath.fromPolar(U0Pu_shunt_4012, UPhase0_shunt_4012b);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_4012b = ComplexMath.conj(s0Pu_shunt_4012b / u0Pu_shunt_4012b);
  // shunt_4041 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.Angle UPhase0_shunt_4041b = SIunits.Conversions.from_deg(-47.90);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_4041b = BPu_shunt_4041 * U0Pu_shunt_4041 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_4041b = Complex(0, Q0Pu_shunt_4041b);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_4041b = ComplexMath.fromPolar(U0Pu_shunt_4041, UPhase0_shunt_4041b);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_4041b = ComplexMath.conj(s0Pu_shunt_4041b / u0Pu_shunt_4041b);
  // shunt_4043 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.Angle UPhase0_shunt_4043b = SIunits.Conversions.from_deg(-54.38);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_4043b = BPu_shunt_4043 * U0Pu_shunt_4043 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_4043b = Complex(0, Q0Pu_shunt_4043b);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_4043b = ComplexMath.fromPolar(U0Pu_shunt_4043, UPhase0_shunt_4043b);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_4043b = ComplexMath.conj(s0Pu_shunt_4043b / u0Pu_shunt_4043b);
  // shunt_4046 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.Angle UPhase0_shunt_4046b = SIunits.Conversions.from_deg(-54.92);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_4046b = BPu_shunt_4046 * U0Pu_shunt_4046 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_4046b = Complex(0, Q0Pu_shunt_4046b);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_4046b = ComplexMath.fromPolar(U0Pu_shunt_4046, UPhase0_shunt_4046b);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_4046b = ComplexMath.conj(s0Pu_shunt_4046b / u0Pu_shunt_4046b);
  // shunt_4051 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.Angle UPhase0_shunt_4051b = SIunits.Conversions.from_deg(-52.72);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_4051b = BPu_shunt_4051 * U0Pu_shunt_4051 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_4051b = Complex(0, Q0Pu_shunt_4051b);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_4051b = ComplexMath.fromPolar(U0Pu_shunt_4051, UPhase0_shunt_4051b);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_4051b = ComplexMath.conj(s0Pu_shunt_4051b / u0Pu_shunt_4051b);
  // shunt_4071 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.Angle UPhase0_shunt_4071b = SIunits.Conversions.from_deg(-21.10);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_4071b = BPu_shunt_4071 * U0Pu_shunt_4071 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_4071b = Complex(0, Q0Pu_shunt_4071b);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_4071b = ComplexMath.fromPolar(U0Pu_shunt_4071, UPhase0_shunt_4071b);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_4071b = ComplexMath.conj(s0Pu_shunt_4071b / u0Pu_shunt_4071b);

equation
  trafo_g16_4051b.switchOffSignal1.value = false;
  trafo_g16_4051b.switchOffSignal2.value = false;

  connect(trafo_g16_4051b.terminal1, bus_BG16b.terminal) annotation(
    Line(points = {{5, -142}, {5, -145}}, color = {0, 0, 255}));
  connect(trafo_g16_4051b.terminal2, bus_4051.terminal) annotation(
    Line(points = {{5, -132}, {5, -130}, {14, -130}}, color = {0, 0, 255}));
  connect(g16b.terminal, bus_BG16b.terminal) annotation(
    Line(points = {{5, -151}, {5, -145}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram",
    Diagram(graphics = {Line(origin = {1.18, 21.94}, points = {{-103.176, -26.9412}, {19.8235, -26.9412}, {103.824, 42.0588}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {-58.3, -98.4}, points = {{-44.7012, 54.3963}, {-25.7012, 54.3963}, {-13.7012, 42.3963}, {-13.7012, -9.60369}, {31.2988, -54.6037}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {-80.5, 104}, points = {{-22.5, -48}, {22.5, -48}, {22.5, 48}}, pattern = LinePattern.Dash, thickness = 0.5), Text(origin = {-55, -145}, extent = {{-15, 5}, {15, -5}}, textString = "SOUTH", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {-35, -25}, extent = {{-15, 5}, {15, -5}}, textString = "CENTRAL", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {5, 145}, extent = {{-15, 5}, {15, -5}}, textString = "NORTH", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {-100, 150}, extent = {{-15, 5}, {15, -5}}, textString = "EQUIV.", textStyle = {TextStyle.Bold, TextStyle.Italic})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body>This model extends the full dynamic model.<div><br><div>This model implements the Nordic 32 test system, operating point B, presented in the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.<br></div><div><br></div><div>In this modified version, a generator g16b is added and the active power provided by generator g20 is decreased accordingly.</div></div></body></html>"));
end FullDynamicModelB;
