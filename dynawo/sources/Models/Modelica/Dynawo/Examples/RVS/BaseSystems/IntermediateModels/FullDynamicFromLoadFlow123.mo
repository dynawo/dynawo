within Dynawo.Examples.RVS.BaseSystems.IntermediateModels;

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

model FullDynamicFromLoadFlow123
  import Modelica.SIunits.Conversions.from_deg;
  import Dynawo;
  import Dynawo.Electrical.SystemBase.SnRef;

  extends NetworkWithAlphaBetaLoads;

  parameter Types.ReactivePowerPu QPu_load_101 = 2.5;

  final parameter Types.VoltageModule UNom_upper = 230;
  final parameter Types.VoltageModule UNom_lower = 138 "Nominal Voltage of the lower part of the network in kV";
  final parameter Types.VoltageModule UNom_gen = 18 "Nominal Voltage of the generator busses in kV";
  final parameter Types.VoltageModule URef0_bus_101 = 1.0342 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_102 = 1.0358 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_106 = 1.0025 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_107 = 1.0286 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_110 = 1.0088 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_113 = 1.02 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_115 = 1.0113 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_116 = 1.0164 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_118 = 1.0432 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_122 = 1.05 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_123 = 1.0499 * UNom_upper;

  final constant Types.ReactivePowerPu P0Pu_shunt_reactor_101 = 0 / SnRef;
  final constant Types.ReactivePowerPu Q0Pu_shunt_reactor_101 = 250 / SnRef;
  final constant Types.VoltageModulePu U0Pu_shunt_reactor_101 = 1.0342;
  final constant Types.Angle UPhase0_shunt_reactor_101 = from_deg(-18.6);
  final constant Types.ComplexApparentPowerPu s0Pu_shunt_reactor_101 = Complex(P0Pu_shunt_reactor_101, Q0Pu_shunt_reactor_101);
  final constant Types.ComplexVoltagePu u0Pu_shunt_reactor_101 = ComplexMath.fromPolar(U0Pu_shunt_reactor_101, UPhase0_shunt_reactor_101);
  final constant Types.ComplexCurrentPu i0Pu_shunt_reactor_101 = ComplexMath.conj(s0Pu_shunt_reactor_101 / u0Pu_shunt_reactor_101);
  final constant Types.PerUnit B0Pu_shunt_reactor_101 = Q0Pu_shunt_reactor_101 / U0Pu_shunt_reactor_101 ^ 2;
  final constant Types.ReactivePowerPu P0Pu_sVarC_10106 = -1.396358584315749e-10 / SnRef;
  final constant Types.ReactivePowerPu Q0Pu_sVarC_10106 = -61.57864880236029 / SnRef;
  final constant Types.VoltageModulePu U0Pu_sVarC_10106 = 1.049999952316433;
  final constant Types.Angle UPhase0_sVarC_10106 = from_deg(-23.89119147504922);
  final constant Types.ComplexApparentPowerPu s0Pu_sVarC_10106 = Complex(P0Pu_sVarC_10106, Q0Pu_sVarC_10106);
  final constant Types.ComplexVoltagePu u0Pu_sVarC_10106 = ComplexMath.fromPolar(U0Pu_sVarC_10106, UPhase0_sVarC_10106);
  final constant Types.ComplexCurrentPu i0Pu_sVarC_10106 = ComplexMath.conj(s0Pu_sVarC_10106 / u0Pu_sVarC_10106);
  final constant Types.PerUnit B0Pu_sVarC_10106 = Q0Pu_sVarC_10106 / ComplexMath.'abs'(u0Pu_sVarC_10106) ^ 2;
  final constant Types.ReactivePowerPu P0Pu_sVarC_10114 = -4.927471763949143e-10 / SnRef;
  final constant Types.ReactivePowerPu Q0Pu_sVarC_10114 = -125.14318403502432 / SnRef;
  final constant Types.VoltageModulePu U0Pu_sVarC_10114 = 1.0499999523163788;
  final constant Types.Angle UPhase0_sVarC_10114 = from_deg(-9.83599303858652);
  final constant Types.ComplexApparentPowerPu s0Pu_sVarC_10114 = Complex(P0Pu_sVarC_10114, Q0Pu_sVarC_10114);
  final constant Types.ComplexVoltagePu u0Pu_sVarC_10114 = ComplexMath.fromPolar(U0Pu_sVarC_10114, UPhase0_sVarC_10114);
  final constant Types.ComplexCurrentPu i0Pu_sVarC_10114 = ComplexMath.conj(s0Pu_sVarC_10114 / u0Pu_sVarC_10114);
  final constant Types.PerUnit B0Pu_sVarC_10114 = Q0Pu_sVarC_10114 / ComplexMath.'abs'(u0Pu_sVarC_10114) ^ 2;
  final constant Types.ActivePowerPu PRef0Pu_gen_10101 = 10.000000000012331 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_10101 = 7.490952884080028 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_10101 = 1.02959;
  final constant Types.Angle UPhase0_gen_10101 = from_deg(-15.1389);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_10101 = Complex(PRef0Pu_gen_10101, QRef0Pu_gen_10101);
  final constant Types.ComplexVoltagePu u0Pu_gen_10101 = ComplexMath.fromPolar(U0Pu_gen_10101, UPhase0_gen_10101);
  final constant Types.ComplexCurrentPu i0Pu_gen_10101 = -1 * ComplexMath.conj(s0Pu_gen_10101 / u0Pu_gen_10101);
  final constant Types.ActivePowerPu PRef0Pu_gen_10102 = 10.000000000001656 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_10102 = 10.3 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_10102 = 1.04728;
  final constant Types.Angle UPhase0_gen_10102 = from_deg(-15.3364);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_10102 = Complex(PRef0Pu_gen_10102, QRef0Pu_gen_10102);
  final constant Types.ComplexVoltagePu u0Pu_gen_10102 = ComplexMath.fromPolar(U0Pu_gen_10102, UPhase0_gen_10102);
  final constant Types.ComplexCurrentPu i0Pu_gen_10102 = -1 * ComplexMath.conj(s0Pu_gen_10102 / u0Pu_gen_10102);
  final constant Types.ActivePowerPu PRef0Pu_gen_10107 = 79.99999999999469 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_10107 = 51.05299544460467 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_10107 = 1.03921;
  final constant Types.Angle UPhase0_gen_10107 = from_deg(-16.6118);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_10107 = Complex(PRef0Pu_gen_10107, QRef0Pu_gen_10107);
  final constant Types.ComplexVoltagePu u0Pu_gen_10107 = ComplexMath.fromPolar(U0Pu_gen_10107, UPhase0_gen_10107);
  final constant Types.ComplexCurrentPu i0Pu_gen_10107 = -1 * ComplexMath.conj(s0Pu_gen_10107 / u0Pu_gen_10107);
  final constant Types.ActivePowerPu PRef0Pu_gen_10113 = 162.50000000182763 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_10113 = 3.6 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_10113 = 0.96997;
  final constant Types.Angle UPhase0_gen_10113 = from_deg(0.2886);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_10113 = Complex(PRef0Pu_gen_10113, QRef0Pu_gen_10113);
  final constant Types.ComplexVoltagePu u0Pu_gen_10113 = ComplexMath.fromPolar(U0Pu_gen_10113, UPhase0_gen_10113);
  final constant Types.ComplexCurrentPu i0Pu_gen_10113 = -1 * ComplexMath.conj(s0Pu_gen_10113 / u0Pu_gen_10113);
  final constant Types.ActivePowerPu PRef0Pu_gen_10115 = 12.000000000000558 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_10115 = 6.3 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_10115 = 1.02378;
  final constant Types.Angle UPhase0_gen_10115 = from_deg(8.3975);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_10115 = Complex(PRef0Pu_gen_10115, QRef0Pu_gen_10115);
  final constant Types.ComplexVoltagePu u0Pu_gen_10115 = ComplexMath.fromPolar(U0Pu_gen_10115, UPhase0_gen_10115);
  final constant Types.ComplexCurrentPu i0Pu_gen_10115 = -1 * ComplexMath.conj(s0Pu_gen_10115 / u0Pu_gen_10115);
  final constant Types.ActivePowerPu PRef0Pu_gen_10116 = 155.00000000057312 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_10116 = 53 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_10116 = 1.00573;
  final constant Types.Angle UPhase0_gen_10116 = from_deg(7.9064);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_10116 = Complex(PRef0Pu_gen_10116, QRef0Pu_gen_10116);
  final constant Types.ComplexVoltagePu u0Pu_gen_10116 = ComplexMath.fromPolar(U0Pu_gen_10116, UPhase0_gen_10116);
  final constant Types.ComplexCurrentPu i0Pu_gen_10116 = -1 * ComplexMath.conj(s0Pu_gen_10116 / u0Pu_gen_10116);
  final constant Types.ActivePowerPu PRef0Pu_gen_10118 = 400.0000000000116 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_10118 = 200.6 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_10118 = 1.04952;
  final constant Types.Angle UPhase0_gen_10118 = from_deg(12.5872);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_10118 = Complex(PRef0Pu_gen_10118, QRef0Pu_gen_10118);
  final constant Types.ComplexVoltagePu u0Pu_gen_10118 = ComplexMath.fromPolar(U0Pu_gen_10118, UPhase0_gen_10118);
  final constant Types.ComplexCurrentPu i0Pu_gen_10118 = -1 * ComplexMath.conj(s0Pu_gen_10118 / u0Pu_gen_10118);
  final constant Types.ActivePowerPu PRef0Pu_gen_10121 = 399.1 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_10121 = 189.7 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_10121 = 1.04969;
  final constant Types.Angle UPhase0_gen_10121 = from_deg(13.4);
  final constant Types.ActivePowerPu PRef0Pu_gen_10122 = 50.00000000000253 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_10122 = 3.5 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_10122 = 1.00262;
  final constant Types.Angle UPhase0_gen_10122 = from_deg(20.3086);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_10122 = Complex(PRef0Pu_gen_10122, QRef0Pu_gen_10122);
  final constant Types.ComplexVoltagePu u0Pu_gen_10122 = ComplexMath.fromPolar(U0Pu_gen_10122, UPhase0_gen_10122);
  final constant Types.ComplexCurrentPu i0Pu_gen_10122 = -1 * ComplexMath.conj(s0Pu_gen_10122 / u0Pu_gen_10122);
  final constant Types.ActivePowerPu PRef0Pu_gen_10123 = 155.00000000002288 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_10123 = 70.70971583990435 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_10123 = 1.05051;
  final constant Types.Angle UPhase0_gen_10123 = from_deg(8.7675);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_10123 = Complex(PRef0Pu_gen_10123, QRef0Pu_gen_10123);
  final constant Types.ComplexVoltagePu u0Pu_gen_10123 = ComplexMath.fromPolar(U0Pu_gen_10123, UPhase0_gen_10123);
  final constant Types.ComplexCurrentPu i0Pu_gen_10123 = -1 * ComplexMath.conj(s0Pu_gen_10123 / u0Pu_gen_10123);
  final constant Types.ActivePowerPu PRef0Pu_gen_20101 = 10.000000000012331 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_20101 = 7.490952884080028 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_20101 = 1.02959;
  final constant Types.Angle UPhase0_gen_20101 = from_deg(-15.1389);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_20101 = Complex(PRef0Pu_gen_20101, QRef0Pu_gen_20101);
  final constant Types.ComplexVoltagePu u0Pu_gen_20101 = ComplexMath.fromPolar(U0Pu_gen_20101, UPhase0_gen_20101);
  final constant Types.ComplexCurrentPu i0Pu_gen_20101 = -1 * ComplexMath.conj(s0Pu_gen_20101 / u0Pu_gen_20101);
  final constant Types.ActivePowerPu PRef0Pu_gen_20102 = 10.000000000001656 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_20102 = 10.3 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_20102 = 1.04728;
  final constant Types.Angle UPhase0_gen_20102 = from_deg(-15.3364);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_20102 = Complex(PRef0Pu_gen_20102, QRef0Pu_gen_20102);
  final constant Types.ComplexVoltagePu u0Pu_gen_20102 = ComplexMath.fromPolar(U0Pu_gen_20102, UPhase0_gen_20102);
  final constant Types.ComplexCurrentPu i0Pu_gen_20102 = -1 * ComplexMath.conj(s0Pu_gen_20102 / u0Pu_gen_20102);
  final constant Types.ActivePowerPu PRef0Pu_gen_20107 = 79.99999999999469 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_20107 = 51.05299544460466 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_20107 = 1.03921;
  final constant Types.Angle UPhase0_gen_20107 = from_deg(-16.6118);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_20107 = Complex(PRef0Pu_gen_20107, QRef0Pu_gen_20107);
  final constant Types.ComplexVoltagePu u0Pu_gen_20107 = ComplexMath.fromPolar(U0Pu_gen_20107, UPhase0_gen_20107);
  final constant Types.ComplexCurrentPu i0Pu_gen_20107 = -1 * ComplexMath.conj(s0Pu_gen_20107 / u0Pu_gen_20107);
  final constant Types.ActivePowerPu PRef0Pu_gen_20113 = 162.5000000000306 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_20113 = 119.9 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_20113 = 1.04273;
  final constant Types.Angle UPhase0_gen_20113 = from_deg(-0.2451);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_20113 = Complex(PRef0Pu_gen_20113, QRef0Pu_gen_20113);
  final constant Types.ComplexVoltagePu u0Pu_gen_20113 = ComplexMath.fromPolar(U0Pu_gen_20113, UPhase0_gen_20113);
  final constant Types.ComplexCurrentPu i0Pu_gen_20113 = -1 * ComplexMath.conj(s0Pu_gen_20113 / u0Pu_gen_20113);
  final constant Types.ActivePowerPu PRef0Pu_gen_20115 = 12.000000000000558 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_20115 = 6.3 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_20115 = 1.02378;
  final constant Types.Angle UPhase0_gen_20115 = from_deg(8.3975);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_20115 = Complex(PRef0Pu_gen_20115, QRef0Pu_gen_20115);
  final constant Types.ComplexVoltagePu u0Pu_gen_20115 = ComplexMath.fromPolar(U0Pu_gen_20115, UPhase0_gen_20115);
  final constant Types.ComplexCurrentPu i0Pu_gen_20115 = -1 * ComplexMath.conj(s0Pu_gen_20115 / u0Pu_gen_20115);
  final constant Types.ActivePowerPu PRef0Pu_gen_20122 = 50.00000000000254 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_20122 = 3.5 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_20122 = 1.00262;
  final constant Types.Angle UPhase0_gen_20122 = from_deg(20.3086);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_20122 = Complex(PRef0Pu_gen_20122, QRef0Pu_gen_20122);
  final constant Types.ComplexVoltagePu u0Pu_gen_20122 = ComplexMath.fromPolar(U0Pu_gen_20122, UPhase0_gen_20122);
  final constant Types.ComplexCurrentPu i0Pu_gen_20122 = -1 * ComplexMath.conj(s0Pu_gen_20122 / u0Pu_gen_20122);
  final constant Types.ActivePowerPu PRef0Pu_gen_20123 = 155.00000000002285 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_20123 = 70.70971583990436 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_20123 = 1.05051;
  final constant Types.Angle UPhase0_gen_20123 = from_deg(8.7675);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_20123 = Complex(PRef0Pu_gen_20123, QRef0Pu_gen_20123);
  final constant Types.ComplexVoltagePu u0Pu_gen_20123 = ComplexMath.fromPolar(U0Pu_gen_20123, UPhase0_gen_20123);
  final constant Types.ComplexCurrentPu i0Pu_gen_20123 = -1 * ComplexMath.conj(s0Pu_gen_20123 / u0Pu_gen_20123);
  final constant Types.ActivePowerPu PRef0Pu_gen_30101 = 76.00000000004553 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_30101 = 22.1 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_30101 = 1.01616;
  final constant Types.Angle UPhase0_gen_30101 = from_deg(-11.3099);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_30101 = Complex(PRef0Pu_gen_30101, QRef0Pu_gen_30101);
  final constant Types.ComplexVoltagePu u0Pu_gen_30101 = ComplexMath.fromPolar(U0Pu_gen_30101, UPhase0_gen_30101);
  final constant Types.ComplexCurrentPu i0Pu_gen_30101 = -1 * ComplexMath.conj(s0Pu_gen_30101 / u0Pu_gen_30101);
  final constant Types.ActivePowerPu PRef0Pu_gen_30102 = 76.00000000000327 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_30102 = 18.6 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_30102 = 1.01191;
  final constant Types.Angle UPhase0_gen_30102 = from_deg(-11.3971);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_30102 = Complex(PRef0Pu_gen_30102, QRef0Pu_gen_30102);
  final constant Types.ComplexVoltagePu u0Pu_gen_30102 = ComplexMath.fromPolar(U0Pu_gen_30102, UPhase0_gen_30102);
  final constant Types.ComplexCurrentPu i0Pu_gen_30102 = -1 * ComplexMath.conj(s0Pu_gen_30102 / u0Pu_gen_30102);
  final constant Types.ActivePowerPu PRef0Pu_gen_30107 = 79.99999999999469 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_30107 = 51.05299544460466 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_30107 = 1.03921;
  final constant Types.Angle UPhase0_gen_30107 = from_deg(-16.6118);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_30107 = Complex(PRef0Pu_gen_30107, QRef0Pu_gen_30107);
  final constant Types.ComplexVoltagePu u0Pu_gen_30107 = ComplexMath.fromPolar(U0Pu_gen_30107, UPhase0_gen_30107);
  final constant Types.ComplexCurrentPu i0Pu_gen_30107 = -1 * ComplexMath.conj(s0Pu_gen_30107 / u0Pu_gen_30107);
  final constant Types.ActivePowerPu PRef0Pu_gen_30113 = 162.5000000000306 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_30113 = 119.9 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_30113 = 1.04273;
  final constant Types.Angle UPhase0_gen_30113 = from_deg(-0.2451);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_30113 = Complex(PRef0Pu_gen_30113, QRef0Pu_gen_30113);
  final constant Types.ComplexVoltagePu u0Pu_gen_30113 = ComplexMath.fromPolar(U0Pu_gen_30113, UPhase0_gen_30113);
  final constant Types.ComplexCurrentPu i0Pu_gen_30113 = -1 * ComplexMath.conj(s0Pu_gen_30113 / u0Pu_gen_30113);
  final constant Types.ActivePowerPu PRef0Pu_gen_30115 = 12.000000000000558 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_30115 = 6.3 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_30115 = 1.02378;
  final constant Types.Angle UPhase0_gen_30115 = from_deg(8.3975);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_30115 = Complex(PRef0Pu_gen_30115, QRef0Pu_gen_30115);
  final constant Types.ComplexVoltagePu u0Pu_gen_30115 = ComplexMath.fromPolar(U0Pu_gen_30115, UPhase0_gen_30115);
  final constant Types.ComplexCurrentPu i0Pu_gen_30115 = -1 * ComplexMath.conj(s0Pu_gen_30115 / u0Pu_gen_30115);
  final constant Types.ActivePowerPu PRef0Pu_gen_30122 = 50.00000000000254 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_30122 = 3.5 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_30122 = 1.00262;
  final constant Types.Angle UPhase0_gen_30122 = from_deg(20.3086);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_30122 = Complex(PRef0Pu_gen_30122, QRef0Pu_gen_30122);
  final constant Types.ComplexVoltagePu u0Pu_gen_30122 = ComplexMath.fromPolar(U0Pu_gen_30122, UPhase0_gen_30122);
  final constant Types.ComplexCurrentPu i0Pu_gen_30122 = -1 * ComplexMath.conj(s0Pu_gen_30122 / u0Pu_gen_30122);
  final constant Types.ActivePowerPu PRef0Pu_gen_30123 = 350.00000000005014 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_30123 = 132.6492343663323 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_30123 = 1.0413279094389931;
  final constant Types.Angle UPhase0_gen_30123 = from_deg(8.8223);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_30123 = Complex(PRef0Pu_gen_30123, QRef0Pu_gen_30123);
  final constant Types.ComplexVoltagePu u0Pu_gen_30123 = ComplexMath.fromPolar(U0Pu_gen_30123, UPhase0_gen_30123);
  final constant Types.ComplexCurrentPu i0Pu_gen_30123 = -1 * ComplexMath.conj(s0Pu_gen_30123 / u0Pu_gen_30123);
  final constant Types.ActivePowerPu PRef0Pu_gen_40101 = 76.00000000004553 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_40101 = 22.1 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_40101 = 1.01616;
  final constant Types.Angle UPhase0_gen_40101 = from_deg(-11.3099);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_40101 = Complex(PRef0Pu_gen_40101, QRef0Pu_gen_40101);
  final constant Types.ComplexVoltagePu u0Pu_gen_40101 = ComplexMath.fromPolar(U0Pu_gen_40101, UPhase0_gen_40101);
  final constant Types.ComplexCurrentPu i0Pu_gen_40101 = -1 * ComplexMath.conj(s0Pu_gen_40101 / u0Pu_gen_40101);
  final constant Types.ActivePowerPu PRef0Pu_gen_40102 = 76.00000000000327 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_40102 = 18.6 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_40102 = 1.01191;
  final constant Types.Angle UPhase0_gen_40102 = from_deg(-11.3971);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_40102 = Complex(PRef0Pu_gen_40102, QRef0Pu_gen_40102);
  final constant Types.ComplexVoltagePu u0Pu_gen_40102 = ComplexMath.fromPolar(U0Pu_gen_40102, UPhase0_gen_40102);
  final constant Types.ComplexCurrentPu i0Pu_gen_40102 = -1 * ComplexMath.conj(s0Pu_gen_40102 / u0Pu_gen_40102);
  final constant Types.ActivePowerPu PRef0Pu_gen_40115 = 12.000000000000558 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_40115 = 6.3 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_40115 = 1.02379;
  final constant Types.Angle UPhase0_gen_40115 = from_deg(8.3975);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_40115 = Complex(PRef0Pu_gen_40115, QRef0Pu_gen_40115);
  final constant Types.ComplexVoltagePu u0Pu_gen_40115 = ComplexMath.fromPolar(U0Pu_gen_40115, UPhase0_gen_40115);
  final constant Types.ComplexCurrentPu i0Pu_gen_40115 = -1 * ComplexMath.conj(s0Pu_gen_40115 / u0Pu_gen_40115);
  final constant Types.ActivePowerPu PRef0Pu_gen_40122 = 50.00000000000254 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_40122 = 3.5 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_40122 = 1.00262;
  final constant Types.Angle UPhase0_gen_40122 = from_deg(20.3086);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_40122 = Complex(PRef0Pu_gen_40122, QRef0Pu_gen_40122);
  final constant Types.ComplexVoltagePu u0Pu_gen_40122 = ComplexMath.fromPolar(U0Pu_gen_40122, UPhase0_gen_40122);
  final constant Types.ComplexCurrentPu i0Pu_gen_40122 = -1 * ComplexMath.conj(s0Pu_gen_40122 / u0Pu_gen_40122);
  final constant Types.ActivePowerPu PRef0Pu_gen_50115 = 12.000000000000558 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_50115 = 6.3 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_50115 = 1.02378;
  final constant Types.Angle UPhase0_gen_50115 = from_deg(8.3975);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_50115 = Complex(PRef0Pu_gen_50115, QRef0Pu_gen_50115);
  final constant Types.ComplexVoltagePu u0Pu_gen_50115 = ComplexMath.fromPolar(U0Pu_gen_50115, UPhase0_gen_50115);
  final constant Types.ComplexCurrentPu i0Pu_gen_50115 = -1 * ComplexMath.conj(s0Pu_gen_50115 / u0Pu_gen_50115);
  final constant Types.ActivePowerPu PRef0Pu_gen_50122 = 50.00000000000254 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_50122 = 3.5 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_50122 = 1.00262;
  final constant Types.Angle UPhase0_gen_50122 = from_deg(20.3086);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_50122 = Complex(PRef0Pu_gen_50122, QRef0Pu_gen_50122);
  final constant Types.ComplexVoltagePu u0Pu_gen_50122 = ComplexMath.fromPolar(U0Pu_gen_50122, UPhase0_gen_50122);
  final constant Types.ComplexCurrentPu i0Pu_gen_50122 = -1 * ComplexMath.conj(s0Pu_gen_50122 / u0Pu_gen_50122);
  final constant Types.ActivePowerPu PRef0Pu_gen_60115 = 155.00000000000716 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_60115 = 85.3 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_60115 = 1.0262;
  final constant Types.Angle UPhase0_gen_60115 = from_deg(8.3289);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_60115 = Complex(PRef0Pu_gen_60115, QRef0Pu_gen_60115);
  final constant Types.ComplexVoltagePu u0Pu_gen_60115 = ComplexMath.fromPolar(U0Pu_gen_60115, UPhase0_gen_60115);
  final constant Types.ComplexCurrentPu i0Pu_gen_60115 = -1 * ComplexMath.conj(s0Pu_gen_60115 / u0Pu_gen_60115);
  final constant Types.ActivePowerPu PRef0Pu_gen_60122 = 50.00000000000254 / SnRef;
  final constant Types.ActivePowerPu QRef0Pu_gen_60122 = 3.5 / SnRef;
  final constant Types.VoltageModulePu U0Pu_gen_60122 = 1.00262;
  final constant Types.Angle UPhase0_gen_60122 = from_deg(20.3086);
  final constant Types.ComplexApparentPowerPu s0Pu_gen_60122 = Complex(PRef0Pu_gen_60122, QRef0Pu_gen_60122);
  final constant Types.ComplexVoltagePu u0Pu_gen_60122 = ComplexMath.fromPolar(U0Pu_gen_60122, UPhase0_gen_60122);
  final constant Types.ComplexCurrentPu i0Pu_gen_60122 = -1 * ComplexMath.conj(s0Pu_gen_60122 / u0Pu_gen_60122);
  /*final constant Types.ReactivePowerPu P0Pu_sVarC_10106 = -1.4741274867446919e-10 / SnRef;
          final constant Types.ReactivePowerPu Q0Pu_sVarC_10106 = -61.57231639473844 / SnRef;
          final constant Types.VoltageModulePu U0Pu_sVarC_10106 = 1.0499999523164407;
          final constant Types.Angle UPhase0_sVarC_10106 = from_deg(-23.83213070343857);
          final constant Types.ComplexApparentPowerPu s0Pu_sVarC_10106 = Complex(P0Pu_sVarC_10106, Q0Pu_sVarC_10106);
          final constant Types.ComplexVoltagePu u0Pu_sVarC_10106 = ComplexMath.fromPolar(U0Pu_sVarC_10106, UPhase0_sVarC_10106);
          final constant Types.ComplexCurrentPu i0Pu_sVarC_10106 = ComplexMath.conj(s0Pu_sVarC_10106 / u0Pu_sVarC_10106);
          final constant Types.PerUnit B0Pu_sVarC_10106 = Q0Pu_sVarC_10106 / ComplexMath.'abs'(u0Pu_sVarC_10106) ^ 2;
          final constant Types.ReactivePowerPu P0Pu_sVarC_10114 = -5.128448776758886e-10 / SnRef;
          final constant Types.ReactivePowerPu Q0Pu_sVarC_10114 = -125.1286992599756 / SnRef;
          final constant Types.VoltageModulePu U0Pu_sVarC_10114 = 1.0499999523163814;
          final constant Types.Angle UPhase0_sVarC_10114 = from_deg(-9.77989867949944);
          final constant Types.ComplexApparentPowerPu s0Pu_sVarC_10114 = Complex(P0Pu_sVarC_10114, Q0Pu_sVarC_10114);
          final constant Types.ComplexVoltagePu u0Pu_sVarC_10114 = ComplexMath.fromPolar(U0Pu_sVarC_10114, UPhase0_sVarC_10114);
          final constant Types.ComplexCurrentPu i0Pu_sVarC_10114 = ComplexMath.conj(s0Pu_sVarC_10114 / u0Pu_sVarC_10114);
          final constant Types.PerUnit B0Pu_sVarC_10114 = Q0Pu_sVarC_10114 / ComplexMath.'abs'(u0Pu_sVarC_10114) ^ 2;
          final constant Types.ActivePowerPu PRef0Pu_gen_10101 = 10.000000000013134 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_10101 = 7.472924576520086 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_10101 = 1.0297081543670863;
          final constant Types.Angle UPhase0_gen_10101 = from_deg(-15.136713683420748);
          final constant Types.ActivePowerPu PRef0Pu_gen_10102 = 10.000000000001876 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_10102 = 10.0000000000016 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_10102 = 1.0456996703380583;
          final constant Types.Angle UPhase0_gen_10102 = from_deg(-15.32639518811591);
          final constant Types.ActivePowerPu PRef0Pu_gen_10107 = 79.99999999999318 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_10107 = 51.0369686546301 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_10107 = 1.0392293846836345;
          final constant Types.Angle UPhase0_gen_10107 = from_deg(-16.607929765986448);
          final constant Types.ActivePowerPu PRef0Pu_gen_10113 = 162.500000001876 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_10113 = 78.10532501609322 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_10113 = 1.017717695706123;
          final constant Types.Angle UPhase0_gen_10113 = from_deg(-0.0608968176817201);
          final constant Types.ActivePowerPu PRef0Pu_gen_10115 = 12.000000000000547 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_10115 = 6.000000000000285 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_10115 = 1.0199901295983258;
          final constant Types.Angle UPhase0_gen_10115 = from_deg(8.445275862974727);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_10115 = Complex(PRef0Pu_gen_10115, QRef0Pu_gen_10115);
          final constant Types.ComplexVoltagePu u0Pu_gen_10115 = ComplexMath.fromPolar(U0Pu_gen_10115, UPhase0_gen_10115);
          final constant Types.ComplexCurrentPu i0Pu_gen_10115 = -1 * ComplexMath.conj(s0Pu_gen_10115 / u0Pu_gen_10115);
          final constant Types.ActivePowerPu PRef0Pu_gen_10116 = 155.0000000005526 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_10116 = 56.995548537262025 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_10116 = 1.0088977415231837;
          final constant Types.Angle UPhase0_gen_10116 = from_deg(7.886212359788583);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_10116 = Complex(PRef0Pu_gen_10116, QRef0Pu_gen_10116);
          final constant Types.ComplexVoltagePu u0Pu_gen_10116 = ComplexMath.fromPolar(U0Pu_gen_10116, UPhase0_gen_10116);
          final constant Types.ComplexCurrentPu i0Pu_gen_10116 = -1 * ComplexMath.conj(s0Pu_gen_10116 / u0Pu_gen_10116);
          final constant Types.ActivePowerPu PRef0Pu_gen_10118 = 400.0000000000115 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_10118 = 200.0000000000052 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_10118 = 1.049310521069751;
          final constant Types.Angle UPhase0_gen_10118 = from_deg(12.59791828910379);
          final constant Types.ActivePowerPu PRef0Pu_gen_10121 = 398.9667714938814 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_10121 = 192.8882441882296 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_10121 = 1.050620483873115;
          final constant Types.Angle UPhase0_gen_10121 = from_deg(13.399999999999457);
          final constant Types.ActivePowerPu PRef0Pu_gen_10122 = 50.00000000000149 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_10122 = 3.47066536610613 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_10122 = 1.002637457718179;
          final constant Types.Angle UPhase0_gen_10122 = from_deg(20.31711144218487);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_10122 = Complex(PRef0Pu_gen_10122, QRef0Pu_gen_10122);
          final constant Types.ComplexVoltagePu u0Pu_gen_10122 = ComplexMath.fromPolar(U0Pu_gen_10122, UPhase0_gen_10122);
          final constant Types.ComplexCurrentPu i0Pu_gen_10122 = -1 * ComplexMath.conj(s0Pu_gen_10122 / u0Pu_gen_10122);
          final constant Types.ActivePowerPu PRef0Pu_gen_10123 = 155.0000000000228 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_10123 = 70.7018261655949 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_10123 = 1.0505187105214768;
          final constant Types.Angle UPhase0_gen_10123 = from_deg(8.774904840389452);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_10123 = Complex(PRef0Pu_gen_10123, QRef0Pu_gen_10123);
          final constant Types.ComplexVoltagePu u0Pu_gen_10123 = ComplexMath.fromPolar(U0Pu_gen_10123, UPhase0_gen_10123);
          final constant Types.ComplexCurrentPu i0Pu_gen_10123 = -1 * ComplexMath.conj(s0Pu_gen_10123 / u0Pu_gen_10123);
          final constant Types.ActivePowerPu PRef0Pu_gen_20101 = 10.000000000013134 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_20101 = 7.472924576520086 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_20101 = 1.0297081543670863;
          final constant Types.Angle UPhase0_gen_20101 = from_deg(-15.136713683420748);
          final constant Types.ActivePowerPu PRef0Pu_gen_20102 = 10.000000000001876 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_20102 = 10.0000000000016 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_20102 = 1.0456996703380586;
          final constant Types.Angle UPhase0_gen_20102 = from_deg(-15.326395188115908);
          final constant Types.ActivePowerPu PRef0Pu_gen_20107 = 79.99999999999318 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_20107 = 51.03696865463012 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_20107 = 1.0392293846836342;
          final constant Types.Angle UPhase0_gen_20107 = from_deg(-16.60792976598645);
          final constant Types.ActivePowerPu PRef0Pu_gen_20113 = 162.5000000000316 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_20113 = 80.0000000000155 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_20113 = 1.0188760820803306;
          final constant Types.Angle UPhase0_gen_20113 = from_deg(-0.0692173513919302);
          final constant Types.ActivePowerPu PRef0Pu_gen_20115 = 12.000000000000547 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_20115 = 6.000000000000285 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_20115 = 1.0199901295983258;
          final constant Types.Angle UPhase0_gen_20115 = from_deg(8.445275862974727);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_20115 = Complex(PRef0Pu_gen_20115, QRef0Pu_gen_20115);
          final constant Types.ComplexVoltagePu u0Pu_gen_20115 = ComplexMath.fromPolar(U0Pu_gen_20115, UPhase0_gen_20115);
          final constant Types.ComplexCurrentPu i0Pu_gen_20115 = -1 * ComplexMath.conj(s0Pu_gen_20115 / u0Pu_gen_20115);
          final constant Types.ActivePowerPu PRef0Pu_gen_20122 = 50.0000000000015 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_20122 = 3.470665366106129 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_20122 = 1.002637457718179;
          final constant Types.Angle UPhase0_gen_20122 = from_deg(20.31711144218487);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_20122 = Complex(PRef0Pu_gen_20122, QRef0Pu_gen_20122);
          final constant Types.ComplexVoltagePu u0Pu_gen_20122 = ComplexMath.fromPolar(U0Pu_gen_20122, UPhase0_gen_20122);
          final constant Types.ComplexCurrentPu i0Pu_gen_20122 = -1 * ComplexMath.conj(s0Pu_gen_20122 / u0Pu_gen_20122);
          final constant Types.ActivePowerPu PRef0Pu_gen_20123 = 155.0000000000228 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_20123 = 70.70182616559488 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_20123 = 1.0505187105214768;
          final constant Types.Angle UPhase0_gen_20123 = from_deg(8.77490484038945);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_20123 = Complex(PRef0Pu_gen_20123, QRef0Pu_gen_20123);
          final constant Types.ComplexVoltagePu u0Pu_gen_20123 = ComplexMath.fromPolar(U0Pu_gen_20123, UPhase0_gen_20123);
          final constant Types.ComplexCurrentPu i0Pu_gen_20123 = -1 * ComplexMath.conj(s0Pu_gen_20123 / u0Pu_gen_20123);
          final constant Types.ActivePowerPu PRef0Pu_gen_30101 = 76.00000000004893 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_30101 = 22.18153802872048 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_30101 = 1.0162565964090082;
          final constant Types.Angle UPhase0_gen_30101 = from_deg(-11.307935828900904);
          final constant Types.ActivePowerPu PRef0Pu_gen_30102 = 76.00000000000328 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_30102 = 18.873816470787677 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_30102 = 1.0123613686642747;
          final constant Types.Angle UPhase0_gen_30102 = from_deg(-11.398125977940808);
          final constant Types.ActivePowerPu PRef0Pu_gen_30107 = 79.99999999999318 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_30107 = 51.03696865463012 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_30107 = 1.0392293846836342;
          final constant Types.Angle UPhase0_gen_30107 = from_deg(-16.60792976598645);
          final constant Types.ActivePowerPu PRef0Pu_gen_30113 = 162.5000000000316 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_30113 = 80.0000000000155 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_30113 = 1.0188760820803306;
          final constant Types.Angle UPhase0_gen_30113 = from_deg(-0.0692173513919302);
          final constant Types.ActivePowerPu PRef0Pu_gen_30115 = 12.000000000000547 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_30115 = 6.000000000000285 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_30115 = 1.0199901295983258;
          final constant Types.Angle UPhase0_gen_30115 = from_deg(8.445275862974727);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_30115 = Complex(PRef0Pu_gen_30115, QRef0Pu_gen_30115);
          final constant Types.ComplexVoltagePu u0Pu_gen_30115 = ComplexMath.fromPolar(U0Pu_gen_30115, UPhase0_gen_30115);
          final constant Types.ComplexCurrentPu i0Pu_gen_30115 = -1 * ComplexMath.conj(s0Pu_gen_30115 / u0Pu_gen_30115);
          final constant Types.ActivePowerPu PRef0Pu_gen_30122 = 50.0000000000015 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_30122 = 3.470665366106129 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_30122 = 1.002637457718179;
          final constant Types.Angle UPhase0_gen_30122 = from_deg(20.31711144218487);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_30122 = Complex(PRef0Pu_gen_30122, QRef0Pu_gen_30122);
          final constant Types.ComplexVoltagePu u0Pu_gen_30122 = ComplexMath.fromPolar(U0Pu_gen_30122, UPhase0_gen_30122);
          final constant Types.ComplexCurrentPu i0Pu_gen_30122 = -1 * ComplexMath.conj(s0Pu_gen_30122 / u0Pu_gen_30122);
          final constant Types.ActivePowerPu PRef0Pu_gen_30123 = 350.0000000000501 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_30123 = 132.63443358196875 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_30123 = 1.0413228858367327;
          final constant Types.Angle UPhase0_gen_30123 = from_deg(8.829652471806773);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_30123 = Complex(PRef0Pu_gen_30123, QRef0Pu_gen_30123);
          final constant Types.ComplexVoltagePu u0Pu_gen_30123 = ComplexMath.fromPolar(U0Pu_gen_30123, UPhase0_gen_30123);
          final constant Types.ComplexCurrentPu i0Pu_gen_30123 = -1 * ComplexMath.conj(s0Pu_gen_30123 / u0Pu_gen_30123);
          final constant Types.ActivePowerPu PRef0Pu_gen_40101 = 76.00000000004893 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_40101 = 22.18153802872048 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_40101 = 1.0162565964090082;
          final constant Types.Angle UPhase0_gen_40101 = from_deg(-11.307935828900904);
          final constant Types.ActivePowerPu PRef0Pu_gen_40102 = 76.00000000000328 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_40102 = 18.873816470787677 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_40102 = 1.0123613686642747;
          final constant Types.Angle UPhase0_gen_40102 = from_deg(-11.398125977940808);
          final constant Types.ActivePowerPu PRef0Pu_gen_40115 = 12.000000000000547 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_40115 = 6.000000000000285 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_40115 = 1.0199901295983258;
          final constant Types.Angle UPhase0_gen_40115 = from_deg(8.445275862974727);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_40115 = Complex(PRef0Pu_gen_40115, QRef0Pu_gen_40115);
          final constant Types.ComplexVoltagePu u0Pu_gen_40115 = ComplexMath.fromPolar(U0Pu_gen_40115, UPhase0_gen_40115);
          final constant Types.ComplexCurrentPu i0Pu_gen_40115 = -1 * ComplexMath.conj(s0Pu_gen_40115 / u0Pu_gen_40115);
          final constant Types.ActivePowerPu PRef0Pu_gen_40122 = 50.0000000000015 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_40122 = 3.470665366106129 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_40122 = 1.002637457718179;
          final constant Types.Angle UPhase0_gen_40122 = from_deg(20.31711144218487);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_40122 = Complex(PRef0Pu_gen_40122, QRef0Pu_gen_40122);
          final constant Types.ComplexVoltagePu u0Pu_gen_40122 = ComplexMath.fromPolar(U0Pu_gen_40122, UPhase0_gen_40122);
          final constant Types.ComplexCurrentPu i0Pu_gen_40122 = -1 * ComplexMath.conj(s0Pu_gen_40122 / u0Pu_gen_40122);
          final constant Types.ActivePowerPu PRef0Pu_gen_50115 = 12.000000000000547 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_50115 = 6.000000000000285 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_50115 = 1.0199901295983258;
          final constant Types.Angle UPhase0_gen_50115 = from_deg(8.445275862974727);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_50115 = Complex(PRef0Pu_gen_50115, QRef0Pu_gen_50115);
          final constant Types.ComplexVoltagePu u0Pu_gen_50115 = ComplexMath.fromPolar(U0Pu_gen_50115, UPhase0_gen_50115);
          final constant Types.ComplexCurrentPu i0Pu_gen_50115 = -1 * ComplexMath.conj(s0Pu_gen_50115 / u0Pu_gen_50115);
          final constant Types.ActivePowerPu PRef0Pu_gen_50122 = 50.0000000000015 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_50122 = 3.470665366106129 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_50122 = 1.002637457718179;
          final constant Types.Angle UPhase0_gen_50122 = from_deg(20.31711144218487);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_50122 = Complex(PRef0Pu_gen_50122, QRef0Pu_gen_50122);
          final constant Types.ComplexVoltagePu u0Pu_gen_50122 = ComplexMath.fromPolar(U0Pu_gen_50122, UPhase0_gen_50122);
          final constant Types.ComplexCurrentPu i0Pu_gen_50122 = -1 * ComplexMath.conj(s0Pu_gen_50122 / u0Pu_gen_50122);
          final constant Types.ActivePowerPu PRef0Pu_gen_60115 = 155.00000000000705 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_60115 = 80.00000000000375 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_60115 = 1.02161813811797;
          final constant Types.Angle UPhase0_gen_60115 = from_deg(8.382976529560553);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_60115 = Complex(PRef0Pu_gen_60115, QRef0Pu_gen_60115);
          final constant Types.ComplexVoltagePu u0Pu_gen_60115 = ComplexMath.fromPolar(U0Pu_gen_60115, UPhase0_gen_60115);
          final constant Types.ComplexCurrentPu i0Pu_gen_60115 = -1 * ComplexMath.conj(s0Pu_gen_60115 / u0Pu_gen_60115);
          final constant Types.ActivePowerPu PRef0Pu_gen_60122 = 50.0000000000015 / SnRef;
          final constant Types.ActivePowerPu QRef0Pu_gen_60122 = 3.470665366106129 / SnRef;
          final constant Types.VoltageModulePu U0Pu_gen_60122 = 1.002637457718179;
          final constant Types.Angle UPhase0_gen_60122 = from_deg(20.31711144218487);
          final constant Types.ComplexApparentPowerPu s0Pu_gen_60122 = Complex(PRef0Pu_gen_60122, QRef0Pu_gen_60122);
          final constant Types.ComplexVoltagePu u0Pu_gen_60122 = ComplexMath.fromPolar(U0Pu_gen_60122, UPhase0_gen_60122);
          final constant Types.ComplexCurrentPu i0Pu_gen_60122 = -1 * ComplexMath.conj(s0Pu_gen_60122 / u0Pu_gen_60122);*/
  // ===================================================================
  Dynawo.Electrical.Controls.Basics.SetPoint N(Value0 = 0);
  /*  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = from_deg(13.4), UPu = 1.04685) annotation(
                        Placement(visible = true, transformation(origin = {-100, 226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
                    */
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10121_121(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 471, XPu = 0.15 * 100 / 471, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-80, 186}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1118_118(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 450, Tap0 = 11, X = 0.15 * 100, rTfo0Pu = 1 + (11 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {60, 164}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10118_118(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 471, XPu = 0.15 * 100 / 471, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {20, 104}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_20115_ARTHUR_G2(KGover = 0, PGen0Pu = PRef0Pu_gen_20115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_20115, QGen0Pu = QRef0Pu_gen_20115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, QRef0Pu = -QRef0Pu_gen_20115, U0Pu = U0Pu_gen_20115, i0Pu = i0Pu_gen_20115, u0Pu = u0Pu_gen_20115) annotation(
    Placement(visible = true, transformation(origin = {-230, 156}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_30115_ARTHUR_G3(KGover = 0, PGen0Pu = PRef0Pu_gen_30115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_30115, QGen0Pu = QRef0Pu_gen_30115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, QRef0Pu = -QRef0Pu_gen_30115, U0Pu = U0Pu_gen_30115, i0Pu = i0Pu_gen_30115, u0Pu = u0Pu_gen_30115) annotation(
    Placement(visible = true, transformation(origin = {-230, 116}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_40115_ARTHUR_G4(KGover = 0, PGen0Pu = PRef0Pu_gen_40115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_40115, QGen0Pu = QRef0Pu_gen_40115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, QRef0Pu = -QRef0Pu_gen_40115, U0Pu = U0Pu_gen_40115, i0Pu = i0Pu_gen_40115, u0Pu = u0Pu_gen_40115) annotation(
    Placement(visible = true, transformation(origin = {-230, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_60115_ARTHUR_G6(KGover = 0, PGen0Pu = PRef0Pu_gen_60115, PMaxPu = 999, PMinPu = 0, PNom = 155, PRef0Pu = -PRef0Pu_gen_60115, QGen0Pu = QRef0Pu_gen_60115, QMaxPu = 0.8, QMinPu = -0.5, QPercent = 0.7294589, QRef0Pu = -QRef0Pu_gen_60115, U0Pu = U0Pu_gen_60115, i0Pu = i0Pu_gen_60115, u0Pu = u0Pu_gen_60115) annotation(
    Placement(visible = true, transformation(origin = {-230, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10115_ARTHUR_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_10115, QGen0Pu = QRef0Pu_gen_10115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, QRef0Pu = -QRef0Pu_gen_10115, U0Pu = U0Pu_gen_10115, i0Pu = i0Pu_gen_10115, u0Pu = u0Pu_gen_10115) annotation(
    Placement(visible = true, transformation(origin = {-230, 196}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_50115_ARTHUR_G5(KGover = 0, PGen0Pu = PRef0Pu_gen_50115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_50115, QGen0Pu = QRef0Pu_gen_50115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, QRef0Pu = -QRef0Pu_gen_50115, U0Pu = U0Pu_gen_50115, i0Pu = i0Pu_gen_50115, u0Pu = u0Pu_gen_50115) annotation(
    Placement(visible = true, transformation(origin = {-230, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-190, 116}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-190, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_60115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-190, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_50115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-190, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-190, 156}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-190, 196}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1115_115(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 400, Tap0 = 6, X = 0.15 * 100, rTfo0Pu = 1 + (6 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-152, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.StaticVarCompensators.SVarCPV sVarC_10114_ARNOLD_SVC(B0Pu = B0Pu_sVarC_10114, BMaxPu = 0.5, BMinPu = -2, BShuntPu = 0, U0Pu = 1.05, UNom = 18, URef0Pu = U0Pu_sVarC_10114, i0Pu = i0Pu_sVarC_10114, u0Pu = u0Pu_sVarC_10114) annotation(
    Placement(visible = true, transformation(origin = {48, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10114_114(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 200, XPu = 0.15 * 100 / 200, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {8, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1114_114(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 250, Tap0 = 6, X = 0.15 * 100, rTfo0Pu = 1 + (6 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {8, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10116_116(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-72, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1116_116(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 150, Tap0 = 8, X = 0.15 * 100, rTfo0Pu = 1 + (8 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-70, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-134, -322}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-94, -322}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1101_101(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 150, Tap0 = 10, X = 0.15 * 100, rTfo0Pu = 1 + (10 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-214, -282}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1103_103(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 250, Tap0 = 5, X = 0.15 * 100, rTfo0Pu = 1 + (5 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-174, -222}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-214, -322}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_103_124(B = 0, G = 0, NbTap = 33, R = 0.008 * 100, SNom = 400, Tap0 = 1, X = 0.336 * 100, rTfo0Pu = 1 + (1 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-134, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-174, -322}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {30, -362}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {70, -362}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-10, -362}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {110, -362}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1102_102(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 150, Tap0 = 11, X = 0.15 * 100, rTfo0Pu = 1 + (11 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-40, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.StaticVarCompensators.SVarCPV sVarC_10106_ALBER_SVC(B0Pu = B0Pu_sVarC_10106, BMaxPu = 0.5, BMinPu = -1, BShuntPu = 0, U0Pu = 1.05, UNom = 18, URef0Pu = U0Pu_sVarC_10106, i0Pu = i0Pu_sVarC_10106, u0Pu = u0Pu_sVarC_10106) annotation(
    Placement(visible = true, transformation(origin = {206, -322}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10106_106(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 120, XPu = 0.15 * 100 / 120, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {166, -322}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1106_106(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 200, Tap0 = 10, X = 0.15 * 100, rTfo0Pu = 1 + (10 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {166, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10122_AUBREY_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_10122, QGen0Pu = QRef0Pu_gen_10122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, QRef0Pu = -QRef0Pu_gen_10122, U0Pu = U0Pu_gen_10122, i0Pu = i0Pu_gen_10122, u0Pu = u0Pu_gen_10122) annotation(
    Placement(visible = true, transformation(origin = {200, 182}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, 212}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {240, 142}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_50122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, 172}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_60122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_20122_AUBREY_G2(KGover = 0, PGen0Pu = PRef0Pu_gen_20122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_20122, QGen0Pu = QRef0Pu_gen_20122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, QRef0Pu = -QRef0Pu_gen_20122, U0Pu = U0Pu_gen_20122, i0Pu = i0Pu_gen_20122, u0Pu = u0Pu_gen_20122) annotation(
    Placement(visible = true, transformation(origin = {200, 142}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {240, 182}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1120_120(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 200, Tap0 = 10, X = 0.15 * 100, rTfo0Pu = 1 + (10 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {180, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1119_119(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 250, Tap0 = 7, X = 0.15 * 100, rTfo0Pu = 1 + (7 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {100, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 412, XPu = 0.15 * 100 / 412, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {180, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {180, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {180, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1113_113(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 350, Tap0 = 7, X = 0.15 * 100, rTfo0Pu = 1 + (7 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {140, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {290, -310}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {290, -270}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {290, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1107_107(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 200, Tap0 = 10, X = 0.15 * 100, rTfo0Pu = 1 + (10 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {250, -310}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1108_108(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 250, Tap0 = 7, X = 0.15 * 100, rTfo0Pu = 1 + (7 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {210, -270}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_109_111(B = 0, G = 0, NbTap = 33, R = 0.008 * 100, SNom = 400, Tap0 = 12, X = 0.336 * 100, rTfo0Pu = 1 + (12 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-40, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1109_109(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 250, Tap0 = 7, X = 0.15 * 100, rTfo0Pu = 1 + (7 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-46, -224}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1104_104(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 100, Tap0 = 4, X = 0.15 * 100, rTfo0Pu = 1 + (4 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-46, -264}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_110_112(B = 0, G = 0, NbTap = 33, R = 0.008 * 100, SNom = 400, Tap0 = 12, X = 0.336 * 100, rTfo0Pu = 1 + (12 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {62, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_110_111(B = 0, G = 0, NbTap = 33, R = 0.008 * 100, SNom = 400, Tap0 = 13, X = 0.336 * 100, rTfo0Pu = 1 + (13 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {10, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_109_112(B = 0, G = 0, NbTap = 33, R = 0.008 * 100, SNom = 400, Tap0 = 0, X = 0.336 * 100, rTfo0Pu = 1 + (0 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {10, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1105_105(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 100, Tap0 = 5, X = 0.15 * 100, rTfo0Pu = 1 + (5 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {42, -320}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1110_110(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 250, Tap0 = 6, X = 0.15 * 100, rTfo0Pu = 1 + (6 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {80, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Components.GeneratorWithControl.SteamEXACFrame gen_40101_ABEL_G4(P0Pu = -PRef0Pu_gen_40101, Q0Pu = -QRef0Pu_gen_40101, U0Pu = U0Pu_gen_40101, UPhase0 = UPhase0_gen_40101, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g40101, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g40101, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g40101, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g40101) annotation(
    Placement(visible = true, transformation(origin = {-94, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_30101_ABEL_G3(P0Pu = -PRef0Pu_gen_30101, Q0Pu = -QRef0Pu_gen_30101, U0Pu = U0Pu_gen_30101, UPhase0 = UPhase0_gen_30101, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g30101, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30101, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30101, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30101) annotation(
    Placement(visible = true, transformation(origin = {-134, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_10101_ABEL_G1(P0Pu = -PRef0Pu_gen_10101, Q0Pu = -QRef0Pu_gen_10101, U0Pu = U0Pu_gen_10101, UPhase0 = UPhase0_gen_10101, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g10101, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10101, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10101, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10101) annotation(
    Placement(visible = true, transformation(origin = {-214, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_20101_ABEL_G2(P0Pu = -PRef0Pu_gen_20101, Q0Pu = -QRef0Pu_gen_20101, U0Pu = U0Pu_gen_20101, UPhase0 = UPhase0_gen_20101, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g20101, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20101, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20101, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20101) annotation(
    Placement(visible = true, transformation(origin = {-174, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Switches.IdealSwitch breaker_line_106_110_bus_106 annotation(
    Placement(visible = true, transformation(origin = {106, -282}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadAlphaBeta load_101(alpha = 1, beta = 2, i0Pu = Complex(0, 0), s0Pu = Complex(0, 0), u0Pu = ComplexMath.fromPolar(1.034, from_deg(-18.6))) annotation(
    Placement(visible = true, transformation(origin = {-166, -280}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamEXACFrame gen_20102_ADAMS_G2(P0Pu = -PRef0Pu_gen_20102, Q0Pu = -QRef0Pu_gen_20102, U0Pu = U0Pu_gen_20102, UPhase0 = UPhase0_gen_20102, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g20102, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20102, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20102, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20102) annotation(
    Placement(visible = true, transformation(origin = {30, -402}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamEXACFrame gen_40102_ADAMS_G4(P0Pu = -PRef0Pu_gen_40102, Q0Pu = -QRef0Pu_gen_40102, U0Pu = U0Pu_gen_40102, UPhase0 = UPhase0_gen_40102, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g40102, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g40102, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g40102, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g40102) annotation(
    Placement(visible = true, transformation(origin = {110, -402}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_10102_ADAMS_G1(P0Pu = -PRef0Pu_gen_10102, Q0Pu = -QRef0Pu_gen_10102, U0Pu = U0Pu_gen_10102, UPhase0 = UPhase0_gen_10102, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g10102, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10102, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10102, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10102) annotation(
    Placement(visible = true, transformation(origin = {-10, -402}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamEXACFrame gen_30102_ADAMS_G3(P0Pu = -PRef0Pu_gen_30102, Q0Pu = -QRef0Pu_gen_30102, U0Pu = U0Pu_gen_30102, UPhase0 = UPhase0_gen_30102, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g30102, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30102, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30102, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30102) annotation(
    Placement(visible = true, transformation(origin = {70, -402}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_30107_ALDER_G3(P0Pu = -PRef0Pu_gen_30107, Q0Pu = -QRef0Pu_gen_30107, U0Pu = U0Pu_gen_30107, UPhase0 = UPhase0_gen_30107, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30107, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30107, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30107, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30107) annotation(
    Placement(visible = true, transformation(origin = {330, -310}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10107_ALDER_G1(P0Pu = -PRef0Pu_gen_10107, Q0Pu = -QRef0Pu_gen_10107, U0Pu = U0Pu_gen_10107, UPhase0 = UPhase0_gen_10107, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10107, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10107, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10107, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10107) annotation(
    Placement(visible = true, transformation(origin = {330, -230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20107_ALDER_G2(P0Pu = -PRef0Pu_gen_20107, Q0Pu = -QRef0Pu_gen_20107, U0Pu = U0Pu_gen_20107, UPhase0 = UPhase0_gen_20107, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20107, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20107, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20107, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20107) annotation(
    Placement(visible = true, transformation(origin = {330, -270}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Machines.SignalN.GeneratorPQProp gen_10118_ASTOR_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10118, PMaxPu = 999, PMinPu = 0, PNom = 400, PRef0Pu = -PRef0Pu_gen_10118, QGen0Pu = QRef0Pu_gen_10118, QMaxPu = 2, QMinPu = -0.5, QPercent = 1, QRef0Pu = -QRef0Pu_gen_10118, U0Pu = U0Pu_gen_10118, i0Pu = i0Pu_gen_10118, u0Pu = u0Pu_gen_10118) annotation(
    Placement(visible = true, transformation(origin = {-20, 104}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Controls.Voltage.VRRemote vRRemote_bus_118(Gain = 1, U0 = URef0_bus_118, URef0 = URef0_bus_118, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {40, 184}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Controls.Voltage.VRRemote vRRemote_bus_116(Gain = 1, U0 = URef0_bus_116, URef0 = URef0_bus_116, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-50, 86}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Machines.SignalN.GeneratorPQProp gen_10116_ASSER_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10116, PMaxPu = 999, PMinPu = 0, PNom = 155, PRef0Pu = -PRef0Pu_gen_10116, QGen0Pu = QRef0Pu_gen_10116, QMaxPu = 0.8, QMinPu = -0.5, QPercent = 1, QRef0Pu = -QRef0Pu_gen_10116, U0Pu = U0Pu_gen_10116, i0Pu = i0Pu_gen_10116, u0Pu = u0Pu_gen_10116) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Buses.InfiniteBus infiniteBus(UPhase = from_deg(13.4), UPu = 1.04685) annotation(
    Placement(visible = true, transformation(origin = {-100, 226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Controls.Voltage.VRRemote vRRemote_bus_115(Gain = 1, U0 = URef0_bus_115, URef0 = URef0_bus_115, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-170, 216}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Controls.Voltage.VRRemote vRRemote_bus_122(Gain = 1, U0 = URef0_bus_122, URef0 = URef0_bus_122, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {260, 232}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20113_ARNE_G2(P0Pu = -PRef0Pu_gen_20113, Q0Pu = -QRef0Pu_gen_20113, U0Pu = U0Pu_gen_20113, UPhase0 = UPhase0_gen_20113, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20113, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20113, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20113, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20113) annotation(
    Placement(visible = true, transformation(origin = {220, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_30113_ARNE_G3(P0Pu = -PRef0Pu_gen_30113, Q0Pu = -QRef0Pu_gen_30113, U0Pu = U0Pu_gen_30113, UPhase0 = UPhase0_gen_30113, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30113, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30113, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30113, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30113) annotation(
    Placement(visible = true, transformation(origin = {220, -130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10113_ARNE_G1(P0Pu = -PRef0Pu_gen_10113, Q0Pu = -QRef0Pu_gen_10113, U0Pu = U0Pu_gen_10113, UPhase0 = UPhase0_gen_10113, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10113, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10113, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10113, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10113) annotation(
    Placement(visible = true, transformation(origin = {220, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20123_AUSTEN_G2(P0Pu = -PRef0Pu_gen_20123, Q0Pu = -QRef0Pu_gen_20123, U0Pu = U0Pu_gen_20123, UPhase0 = UPhase0_gen_20123, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20123, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20123, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20123, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20123) annotation(
    Placement(visible = true, transformation(origin = {330, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10123_AUSTEN_G1(P0Pu = -PRef0Pu_gen_10123, Q0Pu = -QRef0Pu_gen_10123, U0Pu = U0Pu_gen_10123, UPhase0 = UPhase0_gen_10123, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10123, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10123, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10123, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10123) annotation(
    Placement(visible = true, transformation(origin = {330, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_30123_AUSTEN_G3(P0Pu = -PRef0Pu_gen_30123, Q0Pu = -QRef0Pu_gen_30123, U0Pu = U0Pu_gen_30123, UPhase0 = UPhase0_gen_30123, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30123, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30123, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30123, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30123) annotation(
    Placement(visible = true, transformation(origin = {330, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Machines.SignalN.GeneratorPQProp gen_40122_AUBREY_G4(KGover = 0, PGen0Pu = PRef0Pu_gen_40122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_40122, QGen0Pu = QRef0Pu_gen_40122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, QRef0Pu = -QRef0Pu_gen_40122, U0Pu = U0Pu_gen_40122, i0Pu = i0Pu_gen_40122, u0Pu = u0Pu_gen_40122) annotation(
    Placement(visible = true, transformation(origin = {332, 172}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Machines.SignalN.GeneratorPQProp gen_60122_AUBREY_G6(KGover = 0, PGen0Pu = PRef0Pu_gen_60122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_60122, QGen0Pu = QRef0Pu_gen_60122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, QRef0Pu = -QRef0Pu_gen_60122, U0Pu = U0Pu_gen_60122, i0Pu = i0Pu_gen_60122, u0Pu = u0Pu_gen_60122) annotation(
    Placement(visible = true, transformation(origin = {332, 92}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Machines.SignalN.GeneratorPQProp gen_50122_AUBREY_G5(KGover = 0, PGen0Pu = PRef0Pu_gen_50122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_50122, QGen0Pu = QRef0Pu_gen_50122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, QRef0Pu = -QRef0Pu_gen_50122, U0Pu = U0Pu_gen_50122, i0Pu = i0Pu_gen_50122, u0Pu = u0Pu_gen_50122) annotation(
    Placement(visible = true, transformation(origin = {332, 132}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Machines.SignalN.GeneratorPQProp gen_30122_AUBREY_G3(KGover = 0, PGen0Pu = PRef0Pu_gen_30122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_30122, QGen0Pu = QRef0Pu_gen_30122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, QRef0Pu = -QRef0Pu_gen_30122, U0Pu = U0Pu_gen_30122, i0Pu = i0Pu_gen_30122, u0Pu = u0Pu_gen_30122) annotation(
    Placement(visible = true, transformation(origin = {332, 212}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

equation
  when time >= 0 then
    tfo_103_124.tap.value = tfo_103_124.Tap0;
    tfo_109_111.tap.value = tfo_109_111.Tap0;
    tfo_109_112.tap.value = tfo_109_112.Tap0;
    tfo_110_111.tap.value = tfo_110_111.Tap0;
    tfo_110_112.tap.value = tfo_110_112.Tap0;
    tfo_1101_101.tap.value = tfo_1101_101.Tap0;
    tfo_1102_102.tap.value = tfo_1102_102.Tap0;
    tfo_1103_103.tap.value = tfo_1103_103.Tap0;
    tfo_1104_104.tap.value = tfo_1104_104.Tap0;
    tfo_1105_105.tap.value = tfo_1105_105.Tap0;
    tfo_1106_106.tap.value = tfo_1106_106.Tap0;
    tfo_1107_107.tap.value = tfo_1107_107.Tap0;
    tfo_1108_108.tap.value = tfo_1108_108.Tap0;
    tfo_1109_109.tap.value = tfo_1109_109.Tap0;
    tfo_1110_110.tap.value = tfo_1110_110.Tap0;
    tfo_1113_113.tap.value = tfo_1113_113.Tap0;
    tfo_1114_114.tap.value = tfo_1114_114.Tap0;
    tfo_1115_115.tap.value = tfo_1115_115.Tap0;
    tfo_1116_116.tap.value = tfo_1116_116.Tap0;
    tfo_1118_118.tap.value = tfo_1118_118.Tap0;
    tfo_1119_119.tap.value = tfo_1119_119.Tap0;
    tfo_1120_120.tap.value = tfo_1120_120.Tap0;
  end when;

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
  gen_10101_ABEL_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10101_ABEL_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10101_ABEL_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10101_ABEL_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20101_ABEL_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20101_ABEL_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20101_ABEL_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20101_ABEL_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30101_ABEL_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30101_ABEL_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30101_ABEL_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30101_ABEL_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_40101_ABEL_G4.generatorSynchronous.switchOffSignal1.value = false;
  gen_40101_ABEL_G4.generatorSynchronous.switchOffSignal2.value = false;
  gen_40101_ABEL_G4.generatorSynchronous.switchOffSignal3.value = false;
  gen_40101_ABEL_G4.generatorSynchronous.omegaRefPu.value = 1;
  gen_10102_ADAMS_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10102_ADAMS_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10102_ADAMS_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10102_ADAMS_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20102_ADAMS_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20102_ADAMS_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20102_ADAMS_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20102_ADAMS_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30102_ADAMS_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30102_ADAMS_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30102_ADAMS_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30102_ADAMS_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_40102_ADAMS_G4.generatorSynchronous.switchOffSignal1.value = false;
  gen_40102_ADAMS_G4.generatorSynchronous.switchOffSignal2.value = false;
  gen_40102_ADAMS_G4.generatorSynchronous.switchOffSignal3.value = false;
  gen_40102_ADAMS_G4.generatorSynchronous.omegaRefPu.value = 1;
//vRRemote_bus_107.URegulated = ComplexMath.'abs'(bus_107_ALDER.terminal.V) * UNom_lower;
  gen_10107_ALDER_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10107_ALDER_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10107_ALDER_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10107_ALDER_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20107_ALDER_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20107_ALDER_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20107_ALDER_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20107_ALDER_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30107_ALDER_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30107_ALDER_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30107_ALDER_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30107_ALDER_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_10113_ARNE_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10113_ARNE_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10113_ARNE_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10113_ARNE_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20113_ARNE_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20113_ARNE_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20113_ARNE_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20113_ARNE_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30113_ARNE_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30113_ARNE_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30113_ARNE_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30113_ARNE_G3.generatorSynchronous.omegaRefPu.value = 1;
  vRRemote_bus_118.URegulated = ComplexMath.'abs'(bus_118_ASTOR.terminal.V) * UNom_upper;
  gen_10118_ASTOR_G1.switchOffSignal1.value = false;
  gen_10118_ASTOR_G1.switchOffSignal2.value = false;
  gen_10118_ASTOR_G1.switchOffSignal3.value = false;
  gen_10118_ASTOR_G1.N = N.setPoint.value;
  gen_10118_ASTOR_G1.NQ = vRRemote_bus_118.NQ;
  vRRemote_bus_115.URegulated = ComplexMath.'abs'(bus_115_ARTHUR.terminal.V) * UNom_upper;
  gen_10115_ARTHUR_G1.switchOffSignal1.value = false;
  gen_10115_ARTHUR_G1.switchOffSignal2.value = false;
  gen_10115_ARTHUR_G1.switchOffSignal3.value = false;
  gen_10115_ARTHUR_G1.N = N.setPoint.value;
  gen_10115_ARTHUR_G1.NQ = vRRemote_bus_115.NQ;
  gen_20115_ARTHUR_G2.switchOffSignal1.value = false;
  gen_20115_ARTHUR_G2.switchOffSignal2.value = false;
  gen_20115_ARTHUR_G2.switchOffSignal3.value = false;
  gen_20115_ARTHUR_G2.N = N.setPoint.value;
  gen_20115_ARTHUR_G2.NQ = vRRemote_bus_115.NQ;
  gen_30115_ARTHUR_G3.switchOffSignal1.value = false;
  gen_30115_ARTHUR_G3.switchOffSignal2.value = false;
  gen_30115_ARTHUR_G3.switchOffSignal3.value = false;
  gen_30115_ARTHUR_G3.N = N.setPoint.value;
  gen_30115_ARTHUR_G3.NQ = vRRemote_bus_115.NQ;
  gen_40115_ARTHUR_G4.switchOffSignal1.value = false;
  gen_40115_ARTHUR_G4.switchOffSignal2.value = false;
  gen_40115_ARTHUR_G4.switchOffSignal3.value = false;
  gen_40115_ARTHUR_G4.N = N.setPoint.value;
  gen_40115_ARTHUR_G4.NQ = vRRemote_bus_115.NQ;
  gen_50115_ARTHUR_G5.switchOffSignal1.value = false;
  gen_50115_ARTHUR_G5.switchOffSignal2.value = false;
  gen_50115_ARTHUR_G5.switchOffSignal3.value = false;
  gen_50115_ARTHUR_G5.N = N.setPoint.value;
  gen_50115_ARTHUR_G5.NQ = vRRemote_bus_115.NQ;
  gen_60115_ARTHUR_G6.switchOffSignal1.value = false;
  gen_60115_ARTHUR_G6.switchOffSignal2.value = false;
  gen_60115_ARTHUR_G6.switchOffSignal3.value = false;
  gen_60115_ARTHUR_G6.N = N.setPoint.value;
  gen_60115_ARTHUR_G6.NQ = vRRemote_bus_115.NQ;
/*gen_10121_ATTLEE_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10121_ATTLEE_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10121_ATTLEE_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10121_ATTLEE_G1.generatorSynchronous.omegaRefPu.value = 1;
  */
  vRRemote_bus_122.URegulated = ComplexMath.'abs'(bus_122_AUBREY.terminal.V) * UNom_upper;
  gen_10122_AUBREY_G1.switchOffSignal1.value = false;
  gen_10122_AUBREY_G1.switchOffSignal2.value = false;
  gen_10122_AUBREY_G1.switchOffSignal3.value = false;
  gen_10122_AUBREY_G1.N = N.setPoint.value;
  gen_10122_AUBREY_G1.NQ = vRRemote_bus_122.NQ;
  gen_20122_AUBREY_G2.switchOffSignal1.value = false;
  gen_20122_AUBREY_G2.switchOffSignal2.value = false;
  gen_20122_AUBREY_G2.switchOffSignal3.value = false;
  gen_20122_AUBREY_G2.N = N.setPoint.value;
  gen_20122_AUBREY_G2.NQ = vRRemote_bus_122.NQ;
  gen_30122_AUBREY_G3.switchOffSignal1.value = false;
  gen_30122_AUBREY_G3.switchOffSignal2.value = false;
  gen_30122_AUBREY_G3.switchOffSignal3.value = false;
  gen_30122_AUBREY_G3.N = N.setPoint.value;
  gen_30122_AUBREY_G3.NQ = vRRemote_bus_122.NQ;
  gen_40122_AUBREY_G4.switchOffSignal1.value = false;
  gen_40122_AUBREY_G4.switchOffSignal2.value = false;
  gen_40122_AUBREY_G4.switchOffSignal3.value = false;
  gen_40122_AUBREY_G4.N = N.setPoint.value;
  gen_40122_AUBREY_G4.NQ = vRRemote_bus_122.NQ;
  gen_50122_AUBREY_G5.switchOffSignal1.value = false;
  gen_50122_AUBREY_G5.switchOffSignal2.value = false;
  gen_50122_AUBREY_G5.switchOffSignal3.value = false;
  gen_50122_AUBREY_G5.N = N.setPoint.value;
  gen_50122_AUBREY_G5.NQ = vRRemote_bus_122.NQ;
  gen_60122_AUBREY_G6.switchOffSignal1.value = false;
  gen_60122_AUBREY_G6.switchOffSignal2.value = false;
  gen_60122_AUBREY_G6.switchOffSignal3.value = false;
  gen_60122_AUBREY_G6.N = N.setPoint.value;
  gen_60122_AUBREY_G6.NQ = vRRemote_bus_122.NQ;
  vRRemote_bus_116.URegulated = ComplexMath.'abs'(bus_116_ASSER.terminal.V) * UNom_upper;
  gen_10116_ASSER_G1.switchOffSignal1.value = false;
  gen_10116_ASSER_G1.switchOffSignal2.value = false;
  gen_10116_ASSER_G1.switchOffSignal3.value = false;
  gen_10116_ASSER_G1.N = N.setPoint.value;
  gen_10116_ASSER_G1.NQ = vRRemote_bus_116.NQ;
  gen_10123_AUSTEN_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10123_AUSTEN_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10123_AUSTEN_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10123_AUSTEN_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20123_AUSTEN_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20123_AUSTEN_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20123_AUSTEN_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20123_AUSTEN_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30123_AUSTEN_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30123_AUSTEN_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30123_AUSTEN_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30123_AUSTEN_G3.generatorSynchronous.omegaRefPu.value = 1;
  sVarC_10114_ARNOLD_SVC.switchOffSignal1.value = false;
  sVarC_10114_ARNOLD_SVC.switchOffSignal2.value = false;
  sVarC_10114_ARNOLD_SVC.URefPu = U0Pu_sVarC_10114;
  sVarC_10106_ALBER_SVC.switchOffSignal1.value = false;
  sVarC_10106_ALBER_SVC.switchOffSignal2.value = false;
  sVarC_10106_ALBER_SVC.URefPu = U0Pu_sVarC_10106;
  load_101.switchOffSignal1.value = false;
  load_101.switchOffSignal2.value = false;
  load_101.PRefPu = 0;
  load_101.QRefPu = if time < 1 then 0 else QPu_load_101;
// if time < 1 then true else

  connect(sVarC_10114_ARNOLD_SVC.terminal, bus_10114_ARNOLD_SVC.terminal);
  connect(sVarC_10106_ALBER_SVC.terminal, bus_10106_ALBER_SVC.terminal);
  connect(gen_10115_ARTHUR_G1.terminal, bus_10115_ARTHUR_G1.terminal) annotation(
    Line(points = {{-230, 196}, {-210, 196}}, color = {0, 0, 255}));
  connect(gen_20115_ARTHUR_G2.terminal, bus_20115_ARTHUR_G2.terminal) annotation(
    Line(points = {{-230, 156}, {-210, 156}}, color = {0, 0, 255}));
  connect(gen_30115_ARTHUR_G3.terminal, bus_30115_ARTHUR_G3.terminal) annotation(
    Line(points = {{-230, 116}, {-210, 116}}, color = {0, 0, 255}));
  connect(gen_40115_ARTHUR_G4.terminal, bus_40115_ARTHUR_G4.terminal) annotation(
    Line(points = {{-230, 76}, {-210, 76}}, color = {0, 0, 255}));
  connect(gen_50115_ARTHUR_G5.terminal, bus_50115_ARTHUR_G5.terminal) annotation(
    Line(points = {{-230, 36}, {-210, 36}}, color = {0, 0, 255}));
  connect(gen_60115_ARTHUR_G6.terminal, bus_60115_ARTHUR_G6.terminal) annotation(
    Line(points = {{-230, -4}, {-210, -4}}, color = {0, 0, 255}));
  connect(gen_10122_AUBREY_G1.terminal, bus_10122_AUBREY_G1.terminal) annotation(
    Line(points = {{200, 182}, {220, 182}}, color = {0, 0, 255}));
  connect(gen_20122_AUBREY_G2.terminal, bus_20122_AUBREY_G2.terminal) annotation(
    Line(points = {{200, 142}, {220, 142}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal1, bus_1101_ABEL.terminal) annotation(
    Line(points = {{-224, -282}, {-234, -282}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal2, bus_101_ABEL.terminal) annotation(
    Line(points = {{-204, -282}, {-192, -282}, {-192, -302}, {-134, -302}}, color = {0, 0, 255}));
  connect(tfo_1102_102.terminal1, bus_1102_ADAMS.terminal) annotation(
    Line(points = {{-50, -362}, {-60, -362}}, color = {0, 0, 255}));
  connect(tfo_1102_102.terminal2, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-30, -362}, {-20, -362}, {-20, -342}, {30, -342}}, color = {0, 0, 255}));
  connect(tfo_1103_103.terminal1, bus_1103_ADLER.terminal) annotation(
    Line(points = {{-184, -222}, {-194, -222}}, color = {0, 0, 255}));
  connect(tfo_1103_103.terminal2, bus_103_ADLER.terminal) annotation(
    Line(points = {{-164, -222}, {-150, -222}, {-150, -196}, {-130, -196}}, color = {0, 0, 255}));
  connect(tfo_1104_104.terminal1, bus_1104_AGRICOLA.terminal) annotation(
    Line(points = {{-56, -264}, {-70, -264}}, color = {0, 0, 255}));
  connect(tfo_1104_104.terminal2, bus_104_AGRICOLA.terminal) annotation(
    Line(points = {{-36, -264}, {-30, -264}, {-30, -244}, {-20, -244}}, color = {0, 0, 255}));
  connect(tfo_1105_105.terminal1, bus_1105_AIKEN.terminal) annotation(
    Line(points = {{32, -320}, {20, -320}}, color = {0, 0, 255}));
  connect(tfo_1105_105.terminal2, bus_105_AIKEN.terminal) annotation(
    Line(points = {{52, -320}, {60, -320}, {60, -300}, {50, -300}}, color = {0, 0, 255}));
  connect(tfo_1106_106.terminal1, bus_1106_ALBER.terminal) annotation(
    Line(points = {{176, -362}, {186, -362}}, color = {0, 0, 255}));
  connect(tfo_1106_106.terminal2, bus_106_ALBER.terminal) annotation(
    Line(points = {{156, -362}, {140, -362}, {140, -302}, {126, -302}}, color = {0, 0, 255}));
  connect(tfo_1107_107.terminal1, bus_1107_ALDER.terminal) annotation(
    Line(points = {{250, -320}, {250, -330}}, color = {0, 0, 255}));
  connect(tfo_1107_107.terminal2, bus_107_ALDER.terminal) annotation(
    Line(points = {{250, -300}, {250, -288}, {270, -288}, {270, -270}}, color = {0, 0, 255}));
  connect(tfo_1108_108.terminal1, bus_1108_ALGER.terminal) annotation(
    Line(points = {{220, -270}, {230, -270}}, color = {0, 0, 255}));
  connect(tfo_1108_108.terminal2, bus_108_ALGER.terminal) annotation(
    Line(points = {{200, -270}, {190, -270}, {190, -250}}, color = {0, 0, 255}));
  connect(tfo_1109_109.terminal1, bus_1109_ALI.terminal) annotation(
    Line(points = {{-56, -224}, {-70, -224}}, color = {0, 0, 255}));
  connect(tfo_1109_109.terminal2, bus_109_ALI.terminal) annotation(
    Line(points = {{-36, -224}, {-30, -224}, {-30, -198}}, color = {0, 0, 255}));
  connect(tfo_1110_110.terminal1, bus_1110_ALLEN.terminal) annotation(
    Line(points = {{90, -170}, {100, -170}}, color = {0, 0, 255}));
  connect(tfo_1110_110.terminal2, bus_110_ALLEN.terminal) annotation(
    Line(points = {{70, -170}, {66, -170}, {66, -198}, {82, -198}}, color = {0, 0, 255}));
  connect(tfo_1113_113.terminal1, bus_1113_ARNE.terminal) annotation(
    Line(points = {{140, -120}, {140, -130}}, color = {0, 0, 255}));
  connect(tfo_1113_113.terminal2, bus_113_ARNE.terminal) annotation(
    Line(points = {{140, -100}, {140, -80}, {160, -80}}, color = {0, 0, 255}));
  connect(tfo_1114_114.terminal1, bus_1114_ARNOLD.terminal) annotation(
    Line(points = {{18, -12}, {28, -12}}, color = {0, 0, 255}));
  connect(tfo_1114_114.terminal2, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-2, -12}, {-10, -12}, {-10, 14}}, color = {0, 0, 255}));
  connect(tfo_1115_115.terminal1, bus_1115_ARTHUR.terminal) annotation(
    Line(points = {{-142, 68}, {-130, 68}}, color = {0, 0, 255}));
  connect(tfo_1115_115.terminal2, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-162, 68}, {-170, 68}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_1116_116.terminal2, bus_116_ASSER.terminal) annotation(
    Line(points = {{-60, 28}, {-50, 28}, {-50, 38}}, color = {0, 0, 255}));
  connect(tfo_1116_116.terminal1, bus_1116_ASSER.terminal) annotation(
    Line(points = {{-80, 28}, {-90, 28}}, color = {0, 0, 255}));
  connect(tfo_1118_118.terminal1, bus_1118_ASTOR.terminal) annotation(
    Line(points = {{70, 164}, {80, 164}}, color = {0, 0, 255}));
  connect(tfo_1118_118.terminal2, bus_118_ASTOR.terminal) annotation(
    Line(points = {{50, 164}, {40, 164}, {40, 134}}, color = {0, 0, 255}));
  connect(tfo_1119_119.terminal1, bus_1119_ATTAR.terminal) annotation(
    Line(points = {{110, 10}, {120, 10}}, color = {0, 0, 255}));
  connect(tfo_1119_119.terminal2, bus_119_ATTAR.terminal) annotation(
    Line(points = {{90, 10}, {80, 10}, {80, 30}}, color = {0, 0, 255}));
  connect(tfo_1120_120.terminal1, bus_1120_ATTILA.terminal) annotation(
    Line(points = {{190, 10}, {200, 10}}, color = {0, 0, 255}));
  connect(tfo_1120_120.terminal2, bus_120_ATTILA.terminal) annotation(
    Line(points = {{170, 10}, {160, 10}, {160, 30}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-214, -312}, {-214, -302}, {-134, -302}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal2, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-214, -332}, {-214, -342}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-174, -312}, {-174, -302}, {-134, -302}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal2, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-174, -332}, {-174, -342}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-134, -312}, {-134, -302}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal2, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{-134, -332}, {-134, -342}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-94, -312}, {-94, -302}, {-134, -302}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal2, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{-94, -332}, {-94, -342}}, color = {0, 0, 255}));
  connect(tfo_10102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-10, -352}, {-10, -342}, {30, -342}}, color = {0, 0, 255}));
  connect(tfo_10102_102.terminal2, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{-10, -372}, {-10, -382}}, color = {0, 0, 255}));
  connect(tfo_20102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{30, -352}, {30, -342}}, color = {0, 0, 255}));
  connect(tfo_20102_102.terminal2, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{30, -372}, {30, -382}}, color = {0, 0, 255}));
  connect(tfo_30102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{70, -352}, {70, -342}, {30, -342}}, color = {0, 0, 255}));
  connect(tfo_30102_102.terminal2, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{70, -372}, {70, -382}}, color = {0, 0, 255}));
  connect(tfo_40102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{110, -352}, {110, -342}, {30, -342}}, color = {0, 0, 255}));
  connect(tfo_40102_102.terminal2, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{110, -372}, {110, -382}}, color = {0, 0, 255}));
  connect(tfo_10107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{280, -230}, {270, -230}, {270, -270}}, color = {0, 0, 255}));
  connect(tfo_10107_107.terminal2, bus_10107_ALDER_G1.terminal) annotation(
    Line(points = {{300, -230}, {310, -230}}, color = {0, 0, 255}));
  connect(tfo_20107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{280, -270}, {270, -270}}, color = {0, 0, 255}));
  connect(tfo_20107_107.terminal2, bus_20107_ALDER_G2.terminal) annotation(
    Line(points = {{300, -270}, {310, -270}}, color = {0, 0, 255}));
  connect(tfo_30107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{280, -310}, {270, -310}, {270, -270}}, color = {0, 0, 255}));
  connect(tfo_30107_107.terminal2, bus_30107_ALDER_G3.terminal) annotation(
    Line(points = {{300, -310}, {310, -310}}, color = {0, 0, 255}));
  connect(tfo_10113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{170, -50}, {160, -50}, {160, -80}}, color = {0, 0, 255}));
  connect(tfo_10113_113.terminal2, bus_10113_ARNE_G1.terminal) annotation(
    Line(points = {{190, -50}, {200, -50}}, color = {0, 0, 255}));
  connect(tfo_20113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{170, -90}, {160, -90}, {160, -80}}, color = {0, 0, 255}));
  connect(tfo_20113_113.terminal2, bus_20113_ARNE_G2.terminal) annotation(
    Line(points = {{190, -90}, {200, -90}}, color = {0, 0, 255}));
  connect(tfo_30113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{170, -130}, {160, -130}, {160, -80}}, color = {0, 0, 255}));
  connect(tfo_30113_113.terminal2, bus_30113_ARNE_G3.terminal) annotation(
    Line(points = {{190, -130}, {200, -130}}, color = {0, 0, 255}));
  connect(tfo_10115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, 196}, {-170, 196}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_10115_115.terminal2, bus_10115_ARTHUR_G1.terminal) annotation(
    Line(points = {{-200, 196}, {-210, 196}}, color = {0, 0, 255}));
  connect(tfo_20115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, 156}, {-170, 156}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_20115_115.terminal2, bus_20115_ARTHUR_G2.terminal) annotation(
    Line(points = {{-200, 156}, {-210, 156}}, color = {0, 0, 255}));
  connect(tfo_30115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, 116}, {-170, 116}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_30115_115.terminal2, bus_30115_ARTHUR_G3.terminal) annotation(
    Line(points = {{-200, 116}, {-210, 116}}, color = {0, 0, 255}));
  connect(tfo_40115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, 76}, {-170, 76}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_40115_115.terminal2, bus_40115_ARTHUR_G4.terminal) annotation(
    Line(points = {{-200, 76}, {-210, 76}}, color = {0, 0, 255}));
  connect(tfo_50115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, 36}, {-170, 36}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_50115_115.terminal2, bus_50115_ARTHUR_G5.terminal) annotation(
    Line(points = {{-200, 36}, {-210, 36}}, color = {0, 0, 255}));
  connect(tfo_60115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, -4}, {-170, -4}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_60115_115.terminal2, bus_60115_ARTHUR_G6.terminal) annotation(
    Line(points = {{-200, -4}, {-210, -4}}, color = {0, 0, 255}));
  connect(tfo_10116_116.terminal1, bus_116_ASSER.terminal) annotation(
    Line(points = {{-62, 48}, {-50, 48}, {-50, 38}}, color = {0, 0, 255}));
  connect(tfo_10116_116.terminal2, bus_10116_ASSER_G1.terminal) annotation(
    Line(points = {{-82, 48}, {-90, 48}}, color = {0, 0, 255}));
  connect(tfo_10118_118.terminal1, bus_118_ASTOR.terminal) annotation(
    Line(points = {{30, 104}, {40, 104}, {40, 134}}, color = {0, 0, 255}));
  connect(tfo_10118_118.terminal2, bus_10118_ASTOR_G1.terminal) annotation(
    Line(points = {{10, 104}, {0, 104}}, color = {0, 0, 255}));
  connect(tfo_10121_121.terminal1, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-70, 186}, {-60, 186}, {-60, 166}}, color = {0, 0, 255}));
  connect(tfo_10121_121.terminal2, bus_10121_ATTLEE_G1.terminal) annotation(
    Line(points = {{-90, 186}, {-100, 186}}, color = {0, 0, 255}));
  connect(tfo_10122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{250, 182}, {260, 182}, {260, 152}}, color = {0, 0, 255}));
  connect(tfo_10122_122.terminal2, bus_10122_AUBREY_G1.terminal) annotation(
    Line(points = {{230, 182}, {220, 182}}, color = {0, 0, 255}));
  connect(tfo_20122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{250, 142}, {260, 142}, {260, 152}}, color = {0, 0, 255}));
  connect(tfo_20122_122.terminal2, bus_20122_AUBREY_G2.terminal) annotation(
    Line(points = {{230, 142}, {220, 142}}, color = {0, 0, 255}));
  connect(tfo_30122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{270, 212}, {260, 212}, {260, 152}}, color = {0, 0, 255}));
  connect(tfo_30122_122.terminal2, bus_30122_AUBREY_G3.terminal) annotation(
    Line(points = {{290, 212}, {300, 212}}, color = {0, 0, 255}));
  connect(tfo_40122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{270, 172}, {260, 172}, {260, 152}}, color = {0, 0, 255}));
  connect(tfo_40122_122.terminal2, bus_40122_AUBREY_G4.terminal) annotation(
    Line(points = {{290, 172}, {300, 172}}, color = {0, 0, 255}));
  connect(tfo_50122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{270, 132}, {260, 132}, {260, 152}}, color = {0, 0, 255}));
  connect(tfo_50122_122.terminal2, bus_50122_AUBREY_G5.terminal) annotation(
    Line(points = {{290, 132}, {300, 132}}, color = {0, 0, 255}));
  connect(tfo_60122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{270, 92}, {260, 92}, {260, 152}}, color = {0, 0, 255}));
  connect(tfo_60122_122.terminal2, bus_60122_AUBREY_G6.terminal) annotation(
    Line(points = {{290, 92}, {300, 92}}, color = {0, 0, 255}));
  connect(tfo_10123_123.terminal1, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{270, 50}, {260, 50}, {260, 10}}, color = {0, 0, 255}));
  connect(tfo_10123_123.terminal2, bus_10123_AUSTEN_G1.terminal) annotation(
    Line(points = {{290, 50}, {300, 50}}, color = {0, 0, 255}));
  connect(tfo_20123_123.terminal1, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{270, 10}, {260, 10}}, color = {0, 0, 255}));
  connect(tfo_20123_123.terminal2, bus_20123_AUSTEN_G2.terminal) annotation(
    Line(points = {{290, 10}, {300, 10}}, color = {0, 0, 255}));
  connect(tfo_30123_123.terminal1, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{270, -30}, {260, -30}, {260, 10}}, color = {0, 0, 255}));
  connect(tfo_30123_123.terminal2, bus_30123_AUSTEN_G3.terminal) annotation(
    Line(points = {{290, -30}, {300, -30}}, color = {0, 0, 255}));
  connect(tfo_103_124.terminal1, bus_103_ADLER.terminal) annotation(
    Line(points = {{-134, -90}, {-134, -196}, {-130, -196}}, color = {0, 0, 255}));
  connect(tfo_103_124.terminal2, bus_124_AVERY.terminal) annotation(
    Line(points = {{-134, -70}, {-134, -60}}, color = {0, 0, 255}));
  connect(tfo_109_111.terminal1, bus_109_ALI.terminal) annotation(
    Line(points = {{-40, -90}, {-40, -198}, {-30, -198}}, color = {0, 0, 255}));
  connect(tfo_109_111.terminal2, bus_111_ANNA.terminal) annotation(
    Line(points = {{-40, -70}, {-40, -60}}, color = {0, 0, 255}));
  connect(tfo_110_112.terminal1, bus_110_ALLEN.terminal) annotation(
    Line(points = {{62, -90}, {62, -198}, {82, -198}}, color = {0, 0, 255}));
  connect(tfo_110_112.terminal2, bus_112_ARCHER.terminal) annotation(
    Line(points = {{62, -70}, {62, -60}}, color = {0, 0, 255}));
  connect(tfo_109_112.terminal1, bus_109_ALI.terminal) annotation(
    Line(points = {{0, -110}, {-30, -110}, {-30, -198}}, color = {0, 0, 255}));
  connect(tfo_109_112.terminal2, bus_112_ARCHER.terminal) annotation(
    Line(points = {{20, -110}, {46, -110}, {46, -60}, {62, -60}}, color = {0, 0, 255}));
  connect(tfo_110_111.terminal1, bus_110_ALLEN.terminal) annotation(
    Line(points = {{20, -140}, {50, -140}, {50, -198}, {82, -198}}, color = {0, 0, 255}));
  connect(tfo_110_111.terminal2, bus_111_ANNA.terminal) annotation(
    Line(points = {{0, -140}, {-26, -140}, {-26, -60}, {-40, -60}}, color = {0, 0, 255}));
  connect(tfo_10106_106.terminal2, bus_10106_ALBER_SVC.terminal) annotation(
    Line(points = {{176, -322}, {186, -322}}, color = {0, 0, 255}));
  connect(tfo_10106_106.terminal1, bus_106_ALBER.terminal) annotation(
    Line(points = {{156, -322}, {148, -322}, {148, -302}, {126, -302}}, color = {0, 0, 255}));
  connect(tfo_10114_114.terminal2, bus_10114_ARNOLD_SVC.terminal) annotation(
    Line(points = {{18, 28}, {28, 28}}, color = {0, 0, 255}));
  connect(tfo_10114_114.terminal1, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-2, 28}, {-10, 28}, {-10, 14}}, color = {0, 0, 255}));
  connect(gen_10101_ABEL_G1.terminal, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-214, -362}, {-214, -342}}, color = {0, 0, 255}));
  connect(gen_20101_ABEL_G2.terminal, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-174, -362}, {-174, -342}}, color = {0, 0, 255}));
  connect(gen_30101_ABEL_G3.terminal, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{-134, -362}, {-134, -342}}, color = {0, 0, 255}));
  connect(gen_40101_ABEL_G4.terminal, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{-94, -362}, {-94, -342}}, color = {0, 0, 255}));
  connect(load_101.terminal, bus_101_ABEL.terminal) annotation(
    Line(points = {{-166, -280}, {-134, -280}, {-134, -302}}, color = {0, 0, 255}));
  connect(gen_10102_ADAMS_G1.terminal, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{-10, -402}, {-10, -382}}, color = {0, 0, 255}));
  connect(gen_20102_ADAMS_G2.terminal, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{30, -402}, {30, -382}}, color = {0, 0, 255}));
  connect(gen_30102_ADAMS_G3.terminal, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{70, -402}, {70, -382}}, color = {0, 0, 255}));
  connect(gen_40102_ADAMS_G4.terminal, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{110, -402}, {110, -382}}, color = {0, 0, 255}));
  connect(gen_10107_ALDER_G1.terminal, bus_10107_ALDER_G1.terminal) annotation(
    Line(points = {{330, -230}, {310, -230}}, color = {0, 0, 255}));
  connect(gen_20107_ALDER_G2.terminal, bus_20107_ALDER_G2.terminal) annotation(
    Line(points = {{330, -270}, {310, -270}}, color = {0, 0, 255}));
  connect(gen_30107_ALDER_G3.terminal, bus_30107_ALDER_G3.terminal) annotation(
    Line(points = {{330, -310}, {310, -310}}, color = {0, 0, 255}));
  connect(gen_10118_ASTOR_G1.terminal, bus_10118_ASTOR_G1.terminal) annotation(
    Line(points = {{-20, 104}, {0, 104}}, color = {0, 0, 255}));
  connect(gen_10116_ASSER_G1.terminal, bus_10116_ASSER_G1.terminal) annotation(
    Line(points = {{-112, 48}, {-90, 48}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, bus_10121_ATTLEE_G1.terminal) annotation(
    Line(points = {{-100, 226}, {-100, 186}}, color = {0, 0, 255}));
  connect(gen_10113_ARNE_G1.terminal, bus_10113_ARNE_G1.terminal) annotation(
    Line(points = {{220, -50}, {200, -50}}, color = {0, 0, 255}));
  connect(gen_20113_ARNE_G2.terminal, bus_20113_ARNE_G2.terminal) annotation(
    Line(points = {{220, -90}, {200, -90}}, color = {0, 0, 255}));
  connect(gen_30113_ARNE_G3.terminal, bus_30113_ARNE_G3.terminal) annotation(
    Line(points = {{220, -130}, {200, -130}}, color = {0, 0, 255}));
  connect(gen_10123_AUSTEN_G1.terminal, bus_10123_AUSTEN_G1.terminal) annotation(
    Line(points = {{330, 50}, {300, 50}}, color = {0, 0, 255}));
  connect(gen_20123_AUSTEN_G2.terminal, bus_20123_AUSTEN_G2.terminal) annotation(
    Line(points = {{330, 10}, {300, 10}}, color = {0, 0, 255}));
  connect(gen_30123_AUSTEN_G3.terminal, bus_30123_AUSTEN_G3.terminal) annotation(
    Line(points = {{330, -30}, {300, -30}}, color = {0, 0, 255}));
  connect(gen_40122_AUBREY_G4.terminal, bus_40122_AUBREY_G4.terminal) annotation(
    Line(points = {{332, 172}, {300, 172}}, color = {0, 0, 255}));
  connect(gen_60122_AUBREY_G6.terminal, bus_60122_AUBREY_G6.terminal) annotation(
    Line(points = {{332, 92}, {300, 92}}, color = {0, 0, 255}));
  connect(gen_50122_AUBREY_G5.terminal, bus_50122_AUBREY_G5.terminal) annotation(
    Line(points = {{332, 132}, {300, 132}}, color = {0, 0, 255}));
  connect(gen_30122_AUBREY_G3.terminal, bus_30122_AUBREY_G3.terminal) annotation(
    Line(points = {{332, 212}, {300, 212}}, color = {0, 0, 255}));

  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-05, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida"),
    Diagram(coordinateSystem(extent = {{-200, -300}, {200, 300}})),
    Icon(coordinateSystem(extent = {{-200, -300}, {200, 300}})));
end FullDynamicFromLoadFlow123;
