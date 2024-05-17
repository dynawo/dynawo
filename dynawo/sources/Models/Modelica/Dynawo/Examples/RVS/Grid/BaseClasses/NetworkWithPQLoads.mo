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

model NetworkWithPQLoads "RVS test grid with buses, lines, shunts and PQ loads"
  extends Network;

  Dynawo.Electrical.Loads.LoadPQ load_1101_ABEL(i0Pu = i0Pu_load_1101_ABEL, s0Pu = s0Pu_load_1101_ABEL, u0Pu = u0Pu_load_1101_ABEL) annotation(
    Placement(visible = true, transformation(origin = {-288, -186}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1102_ADAMS(i0Pu = i0Pu_load_1102_ADAMS, s0Pu = s0Pu_load_1102_ADAMS, u0Pu = u0Pu_load_1102_ADAMS) annotation(
    Placement(visible = true, transformation(origin = {-108, -266}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1103_ADLER(i0Pu = i0Pu_load_1103_ADLER, s0Pu = s0Pu_load_1103_ADLER, u0Pu = u0Pu_load_1103_ADLER) annotation(
    Placement(visible = true, transformation(origin = {-248, -126}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1104_AGRICOLA(i0Pu = i0Pu_load_1104_AGRICOLA, s0Pu = s0Pu_load_1104_AGRICOLA, u0Pu = u0Pu_load_1104_AGRICOLA) annotation(
    Placement(visible = true, transformation(origin = {-124, -168}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1105_AIKEN(i0Pu = i0Pu_load_1105_AIKEN, s0Pu = s0Pu_load_1105_AIKEN, u0Pu = u0Pu_load_1105_AIKEN) annotation(
    Placement(visible = true, transformation(origin = {-34, -224}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1106_ALBER(i0Pu = i0Pu_load_1106_ALBER, s0Pu = s0Pu_load_1106_ALBER, u0Pu = u0Pu_load_1106_ALBER) annotation(
    Placement(visible = true, transformation(origin = {182, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1107_ALDER(i0Pu = i0Pu_load_1107_ALDER, s0Pu = s0Pu_load_1107_ALDER, u0Pu = u0Pu_load_1107_ALDER) annotation(
    Placement(visible = true, transformation(origin = {216, -254}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ load_1108_ALGER(i0Pu = i0Pu_load_1108_ALGER, s0Pu = s0Pu_load_1108_ALGER, u0Pu = u0Pu_load_1108_ALGER) annotation(
    Placement(visible = true, transformation(origin = {216, -174}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1109_ALI(i0Pu = i0Pu_load_1109_ALI, s0Pu = s0Pu_load_1109_ALI, u0Pu = u0Pu_load_1109_ALI) annotation(
    Placement(visible = true, transformation(origin = {-124, -128}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1110_ALLEN(i0Pu = i0Pu_load_1110_ALLEN, s0Pu = s0Pu_load_1110_ALLEN, u0Pu = u0Pu_load_1110_ALLEN) annotation(
    Placement(visible = true, transformation(origin = {86, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1113_ARNE(i0Pu = i0Pu_load_1113_ARNE, s0Pu = s0Pu_load_1113_ARNE, u0Pu = u0Pu_load_1113_ARNE) annotation(
    Placement(visible = true, transformation(origin = {106, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ load_1114_ARNOLD(i0Pu = i0Pu_load_1114_ARNOLD, s0Pu = s0Pu_load_1114_ARNOLD, u0Pu = u0Pu_load_1114_ARNOLD) annotation(
    Placement(visible = true, transformation(origin = {14, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1115_ARTHUR(i0Pu = i0Pu_load_1115_ARTHUR, s0Pu = s0Pu_load_1115_ARTHUR, u0Pu = u0Pu_load_1115_ARTHUR) annotation(
    Placement(visible = true, transformation(origin = {-146, 164}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1116_ASSER(i0Pu = i0Pu_load_1116_ASSER, s0Pu = s0Pu_load_1116_ASSER, u0Pu = u0Pu_load_1116_ASSER) annotation(
    Placement(visible = true, transformation(origin = {-146, 124}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1118_ASTOR(i0Pu = i0Pu_load_1118_ASTOR, s0Pu = s0Pu_load_1118_ASTOR, u0Pu = u0Pu_load_1118_ASTOR) annotation(
    Placement(visible = true, transformation(origin = {66, 260}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1119_ATTAR(i0Pu = i0Pu_load_1119_ATTAR, s0Pu = s0Pu_load_1119_ATTAR, u0Pu = u0Pu_load_1119_ATTAR) annotation(
    Placement(visible = true, transformation(origin = {106, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1120_ATTILA(i0Pu = i0Pu_load_1120_ATTILA, s0Pu = s0Pu_load_1120_ATTILA, u0Pu = u0Pu_load_1120_ATTILA) annotation(
    Placement(visible = true, transformation(origin = {186, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  parameter Types.ActivePowerPu P0Pu_load_1101_ABEL;
  parameter Types.ReactivePowerPu Q0Pu_load_1101_ABEL;
  parameter Types.VoltageModulePu U0Pu_load_1101_ABEL;
  parameter Types.Angle UPhase0_load_1101_ABEL;

  parameter Types.ActivePowerPu P0Pu_load_1102_ADAMS;
  parameter Types.ReactivePowerPu Q0Pu_load_1102_ADAMS;
  parameter Types.VoltageModulePu U0Pu_load_1102_ADAMS;
  parameter Types.Angle UPhase0_load_1102_ADAMS;

  parameter Types.ActivePowerPu P0Pu_load_1103_ADLER;
  parameter Types.ReactivePowerPu Q0Pu_load_1103_ADLER;
  parameter Types.VoltageModulePu U0Pu_load_1103_ADLER;
  parameter Types.Angle UPhase0_load_1103_ADLER;

  parameter Types.ActivePowerPu P0Pu_load_1104_AGRICOLA;
  parameter Types.ReactivePowerPu Q0Pu_load_1104_AGRICOLA;
  parameter Types.VoltageModulePu U0Pu_load_1104_AGRICOLA;
  parameter Types.Angle UPhase0_load_1104_AGRICOLA;

  parameter Types.ActivePowerPu P0Pu_load_1105_AIKEN;
  parameter Types.ReactivePowerPu Q0Pu_load_1105_AIKEN;
  parameter Types.VoltageModulePu U0Pu_load_1105_AIKEN;
  parameter Types.Angle UPhase0_load_1105_AIKEN;

  parameter Types.ActivePowerPu P0Pu_load_1106_ALBER;
  parameter Types.ReactivePowerPu Q0Pu_load_1106_ALBER;
  parameter Types.VoltageModulePu U0Pu_load_1106_ALBER;
  parameter Types.Angle UPhase0_load_1106_ALBER;

  parameter Types.ActivePowerPu P0Pu_load_1107_ALDER;
  parameter Types.ReactivePowerPu Q0Pu_load_1107_ALDER;
  parameter Types.VoltageModulePu U0Pu_load_1107_ALDER;
  parameter Types.Angle UPhase0_load_1107_ALDER;

  parameter Types.ActivePowerPu P0Pu_load_1108_ALGER;
  parameter Types.ReactivePowerPu Q0Pu_load_1108_ALGER;
  parameter Types.VoltageModulePu U0Pu_load_1108_ALGER;
  parameter Types.Angle UPhase0_load_1108_ALGER;

  parameter Types.ActivePowerPu P0Pu_load_1109_ALI;
  parameter Types.ReactivePowerPu Q0Pu_load_1109_ALI;
  parameter Types.VoltageModulePu U0Pu_load_1109_ALI;
  parameter Types.Angle UPhase0_load_1109_ALI;

  parameter Types.ActivePowerPu P0Pu_load_1110_ALLEN;
  parameter Types.ReactivePowerPu Q0Pu_load_1110_ALLEN;
  parameter Types.VoltageModulePu U0Pu_load_1110_ALLEN;
  parameter Types.Angle UPhase0_load_1110_ALLEN;

  parameter Types.ActivePowerPu P0Pu_load_1113_ARNE;
  parameter Types.ReactivePowerPu Q0Pu_load_1113_ARNE;
  parameter Types.VoltageModulePu U0Pu_load_1113_ARNE;
  parameter Types.Angle UPhase0_load_1113_ARNE;

  parameter Types.ActivePowerPu P0Pu_load_1114_ARNOLD;
  parameter Types.ReactivePowerPu Q0Pu_load_1114_ARNOLD;
  parameter Types.VoltageModulePu U0Pu_load_1114_ARNOLD;
  parameter Types.Angle UPhase0_load_1114_ARNOLD;

  parameter Types.ActivePowerPu P0Pu_load_1115_ARTHUR;
  parameter Types.ReactivePowerPu Q0Pu_load_1115_ARTHUR;
  parameter Types.VoltageModulePu U0Pu_load_1115_ARTHUR;
  parameter Types.Angle UPhase0_load_1115_ARTHUR;

  parameter Types.ActivePowerPu P0Pu_load_1116_ASSER;
  parameter Types.ReactivePowerPu Q0Pu_load_1116_ASSER;
  parameter Types.VoltageModulePu U0Pu_load_1116_ASSER;
  parameter Types.Angle UPhase0_load_1116_ASSER;

  parameter Types.ActivePowerPu P0Pu_load_1118_ASTOR;
  parameter Types.ReactivePowerPu Q0Pu_load_1118_ASTOR;
  parameter Types.VoltageModulePu U0Pu_load_1118_ASTOR;
  parameter Types.Angle UPhase0_load_1118_ASTOR;

  parameter Types.ActivePowerPu P0Pu_load_1119_ATTAR;
  parameter Types.ReactivePowerPu Q0Pu_load_1119_ATTAR;
  parameter Types.VoltageModulePu U0Pu_load_1119_ATTAR;
  parameter Types.Angle UPhase0_load_1119_ATTAR;

  parameter Types.ActivePowerPu P0Pu_load_1120_ATTILA;
  parameter Types.ReactivePowerPu Q0Pu_load_1120_ATTILA;
  parameter Types.VoltageModulePu U0Pu_load_1120_ATTILA;
  parameter Types.Angle UPhase0_load_1120_ATTILA;

  final parameter Types.ComplexCurrentPu i0Pu_load_1101_ABEL = ComplexMath.conj(s0Pu_load_1101_ABEL / u0Pu_load_1101_ABEL);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1101_ABEL = Complex(P0Pu_load_1101_ABEL, Q0Pu_load_1101_ABEL);
  final parameter Types.ComplexVoltagePu u0Pu_load_1101_ABEL = ComplexMath.fromPolar(U0Pu_load_1101_ABEL, UPhase0_load_1101_ABEL);

  final parameter Types.ComplexCurrentPu i0Pu_load_1102_ADAMS = ComplexMath.conj(s0Pu_load_1102_ADAMS / u0Pu_load_1102_ADAMS);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1102_ADAMS = Complex(P0Pu_load_1102_ADAMS, Q0Pu_load_1102_ADAMS);
  final parameter Types.ComplexVoltagePu u0Pu_load_1102_ADAMS = ComplexMath.fromPolar(U0Pu_load_1102_ADAMS, UPhase0_load_1102_ADAMS);

  final parameter Types.ComplexCurrentPu i0Pu_load_1103_ADLER = ComplexMath.conj(s0Pu_load_1103_ADLER / u0Pu_load_1103_ADLER);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1103_ADLER = Complex(P0Pu_load_1103_ADLER, Q0Pu_load_1103_ADLER);
  final parameter Types.ComplexVoltagePu u0Pu_load_1103_ADLER = ComplexMath.fromPolar(U0Pu_load_1103_ADLER, UPhase0_load_1103_ADLER);

  final parameter Types.ComplexCurrentPu i0Pu_load_1104_AGRICOLA = ComplexMath.conj(s0Pu_load_1104_AGRICOLA / u0Pu_load_1104_AGRICOLA);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1104_AGRICOLA = Complex(P0Pu_load_1104_AGRICOLA, Q0Pu_load_1104_AGRICOLA);
  final parameter Types.ComplexVoltagePu u0Pu_load_1104_AGRICOLA = ComplexMath.fromPolar(U0Pu_load_1104_AGRICOLA, UPhase0_load_1104_AGRICOLA);

  final parameter Types.ComplexCurrentPu i0Pu_load_1105_AIKEN = ComplexMath.conj(s0Pu_load_1105_AIKEN / u0Pu_load_1105_AIKEN);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1105_AIKEN = Complex(P0Pu_load_1105_AIKEN, Q0Pu_load_1105_AIKEN);
  final parameter Types.ComplexVoltagePu u0Pu_load_1105_AIKEN = ComplexMath.fromPolar(U0Pu_load_1105_AIKEN, UPhase0_load_1105_AIKEN);

  final parameter Types.ComplexCurrentPu i0Pu_load_1106_ALBER = ComplexMath.conj(s0Pu_load_1106_ALBER / u0Pu_load_1106_ALBER);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1106_ALBER = Complex(P0Pu_load_1106_ALBER, Q0Pu_load_1106_ALBER);
  final parameter Types.ComplexVoltagePu u0Pu_load_1106_ALBER = ComplexMath.fromPolar(U0Pu_load_1106_ALBER, UPhase0_load_1106_ALBER);

  final parameter Types.ComplexCurrentPu i0Pu_load_1107_ALDER = ComplexMath.conj(s0Pu_load_1107_ALDER / u0Pu_load_1107_ALDER);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1107_ALDER = Complex(P0Pu_load_1107_ALDER, Q0Pu_load_1107_ALDER);
  final parameter Types.ComplexVoltagePu u0Pu_load_1107_ALDER = ComplexMath.fromPolar(U0Pu_load_1107_ALDER, UPhase0_load_1107_ALDER);

  final parameter Types.ComplexCurrentPu i0Pu_load_1108_ALGER = ComplexMath.conj(s0Pu_load_1108_ALGER / u0Pu_load_1108_ALGER);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1108_ALGER = Complex(P0Pu_load_1108_ALGER, Q0Pu_load_1108_ALGER);
  final parameter Types.ComplexVoltagePu u0Pu_load_1108_ALGER = ComplexMath.fromPolar(U0Pu_load_1108_ALGER, UPhase0_load_1108_ALGER);

  final parameter Types.ComplexCurrentPu i0Pu_load_1109_ALI = ComplexMath.conj(s0Pu_load_1109_ALI / u0Pu_load_1109_ALI);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1109_ALI = Complex(P0Pu_load_1109_ALI, Q0Pu_load_1109_ALI);
  final parameter Types.ComplexVoltagePu u0Pu_load_1109_ALI = ComplexMath.fromPolar(U0Pu_load_1109_ALI, UPhase0_load_1109_ALI);

  final parameter Types.ComplexCurrentPu i0Pu_load_1110_ALLEN = ComplexMath.conj(s0Pu_load_1110_ALLEN / u0Pu_load_1110_ALLEN);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1110_ALLEN = Complex(P0Pu_load_1110_ALLEN, Q0Pu_load_1110_ALLEN);
  final parameter Types.ComplexVoltagePu u0Pu_load_1110_ALLEN = ComplexMath.fromPolar(U0Pu_load_1110_ALLEN, UPhase0_load_1110_ALLEN);

  final parameter Types.ComplexCurrentPu i0Pu_load_1113_ARNE = ComplexMath.conj(s0Pu_load_1113_ARNE / u0Pu_load_1113_ARNE);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1113_ARNE = Complex(P0Pu_load_1113_ARNE, Q0Pu_load_1113_ARNE);
  final parameter Types.ComplexVoltagePu u0Pu_load_1113_ARNE = ComplexMath.fromPolar(U0Pu_load_1113_ARNE, UPhase0_load_1113_ARNE);

  final parameter Types.ComplexCurrentPu i0Pu_load_1114_ARNOLD = ComplexMath.conj(s0Pu_load_1114_ARNOLD / u0Pu_load_1114_ARNOLD);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1114_ARNOLD = Complex(P0Pu_load_1114_ARNOLD, Q0Pu_load_1114_ARNOLD);
  final parameter Types.ComplexVoltagePu u0Pu_load_1114_ARNOLD = ComplexMath.fromPolar(U0Pu_load_1114_ARNOLD, UPhase0_load_1114_ARNOLD);

  final parameter Types.ComplexCurrentPu i0Pu_load_1115_ARTHUR = ComplexMath.conj(s0Pu_load_1115_ARTHUR / u0Pu_load_1115_ARTHUR);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1115_ARTHUR = Complex(P0Pu_load_1115_ARTHUR, Q0Pu_load_1115_ARTHUR);
  final parameter Types.ComplexVoltagePu u0Pu_load_1115_ARTHUR = ComplexMath.fromPolar(U0Pu_load_1115_ARTHUR, UPhase0_load_1115_ARTHUR);

  final parameter Types.ComplexCurrentPu i0Pu_load_1116_ASSER = ComplexMath.conj(s0Pu_load_1116_ASSER / u0Pu_load_1116_ASSER);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1116_ASSER = Complex(P0Pu_load_1116_ASSER, Q0Pu_load_1116_ASSER);
  final parameter Types.ComplexVoltagePu u0Pu_load_1116_ASSER = ComplexMath.fromPolar(U0Pu_load_1116_ASSER, UPhase0_load_1116_ASSER);

  final parameter Types.ComplexCurrentPu i0Pu_load_1118_ASTOR = ComplexMath.conj(s0Pu_load_1118_ASTOR / u0Pu_load_1118_ASTOR);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1118_ASTOR = Complex(P0Pu_load_1118_ASTOR, Q0Pu_load_1118_ASTOR);
  final parameter Types.ComplexVoltagePu u0Pu_load_1118_ASTOR = ComplexMath.fromPolar(U0Pu_load_1118_ASTOR, UPhase0_load_1118_ASTOR);

  final parameter Types.ComplexCurrentPu i0Pu_load_1119_ATTAR = ComplexMath.conj(s0Pu_load_1119_ATTAR / u0Pu_load_1119_ATTAR);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1119_ATTAR = Complex(P0Pu_load_1119_ATTAR, Q0Pu_load_1119_ATTAR);
  final parameter Types.ComplexVoltagePu u0Pu_load_1119_ATTAR = ComplexMath.fromPolar(U0Pu_load_1119_ATTAR, UPhase0_load_1119_ATTAR);

  final parameter Types.ComplexCurrentPu i0Pu_load_1120_ATTILA = ComplexMath.conj(s0Pu_load_1120_ATTILA / u0Pu_load_1120_ATTILA);
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1120_ATTILA = Complex(P0Pu_load_1120_ATTILA, Q0Pu_load_1120_ATTILA);
  final parameter Types.ComplexVoltagePu u0Pu_load_1120_ATTILA = ComplexMath.fromPolar(U0Pu_load_1120_ATTILA, UPhase0_load_1120_ATTILA);

equation
  load_1101_ABEL.switchOffSignal1.value = false;
  load_1101_ABEL.switchOffSignal2.value = false;
  load_1101_ABEL.PRefPu = P0Pu_load_1101_ABEL;
  load_1101_ABEL.QRefPu = Q0Pu_load_1101_ABEL;
  load_1101_ABEL.deltaP = 0;
  load_1101_ABEL.deltaQ = 0;
  load_1102_ADAMS.switchOffSignal1.value = false;
  load_1102_ADAMS.switchOffSignal2.value = false;
  load_1102_ADAMS.PRefPu = P0Pu_load_1102_ADAMS;
  load_1102_ADAMS.QRefPu = Q0Pu_load_1102_ADAMS;
  load_1102_ADAMS.deltaP = 0;
  load_1102_ADAMS.deltaQ = 0;
  load_1103_ADLER.switchOffSignal1.value = false;
  load_1103_ADLER.switchOffSignal2.value = false;
  load_1103_ADLER.PRefPu = P0Pu_load_1103_ADLER;
  load_1103_ADLER.QRefPu = Q0Pu_load_1103_ADLER;
  load_1103_ADLER.deltaP = 0;
  load_1103_ADLER.deltaQ = 0;
  load_1104_AGRICOLA.switchOffSignal1.value = false;
  load_1104_AGRICOLA.switchOffSignal2.value = false;
  load_1104_AGRICOLA.PRefPu = P0Pu_load_1104_AGRICOLA;
  load_1104_AGRICOLA.QRefPu = Q0Pu_load_1104_AGRICOLA;
  load_1104_AGRICOLA.deltaP = 0;
  load_1104_AGRICOLA.deltaQ = 0;
  load_1105_AIKEN.switchOffSignal1.value = false;
  load_1105_AIKEN.switchOffSignal2.value = false;
  load_1105_AIKEN.PRefPu = P0Pu_load_1105_AIKEN;
  load_1105_AIKEN.QRefPu = Q0Pu_load_1105_AIKEN;
  load_1105_AIKEN.deltaP = 0;
  load_1105_AIKEN.deltaQ = 0;
  load_1106_ALBER.switchOffSignal1.value = false;
  load_1106_ALBER.switchOffSignal2.value = false;
  load_1106_ALBER.PRefPu = P0Pu_load_1106_ALBER;
  load_1106_ALBER.QRefPu = Q0Pu_load_1106_ALBER;
  load_1106_ALBER.deltaP = 0;
  load_1106_ALBER.deltaQ = 0;
  load_1107_ALDER.switchOffSignal1.value = false;
  load_1107_ALDER.switchOffSignal2.value = false;
  load_1107_ALDER.PRefPu = P0Pu_load_1107_ALDER;
  load_1107_ALDER.QRefPu = Q0Pu_load_1107_ALDER;
  load_1107_ALDER.deltaP = 0;
  load_1107_ALDER.deltaQ = 0;
  load_1108_ALGER.switchOffSignal1.value = false;
  load_1108_ALGER.switchOffSignal2.value = false;
  load_1108_ALGER.PRefPu = P0Pu_load_1108_ALGER;
  load_1108_ALGER.QRefPu = Q0Pu_load_1108_ALGER;
  load_1108_ALGER.deltaP = 0;
  load_1108_ALGER.deltaQ = 0;
  load_1109_ALI.switchOffSignal1.value = false;
  load_1109_ALI.switchOffSignal2.value = false;
  load_1109_ALI.PRefPu = P0Pu_load_1109_ALI;
  load_1109_ALI.QRefPu = Q0Pu_load_1109_ALI;
  load_1109_ALI.deltaP = 0;
  load_1109_ALI.deltaQ = 0;
  load_1110_ALLEN.switchOffSignal1.value = false;
  load_1110_ALLEN.switchOffSignal2.value = false;
  load_1110_ALLEN.PRefPu = P0Pu_load_1110_ALLEN;
  load_1110_ALLEN.QRefPu = Q0Pu_load_1110_ALLEN;
  load_1110_ALLEN.deltaP = 0;
  load_1110_ALLEN.deltaQ = 0;
  load_1113_ARNE.switchOffSignal1.value = false;
  load_1113_ARNE.switchOffSignal2.value = false;
  load_1113_ARNE.PRefPu = P0Pu_load_1113_ARNE;
  load_1113_ARNE.QRefPu = Q0Pu_load_1113_ARNE;
  load_1113_ARNE.deltaP = 0;
  load_1113_ARNE.deltaQ = 0;
  load_1114_ARNOLD.switchOffSignal1.value = false;
  load_1114_ARNOLD.switchOffSignal2.value = false;
  load_1114_ARNOLD.PRefPu = P0Pu_load_1114_ARNOLD;
  load_1114_ARNOLD.QRefPu = Q0Pu_load_1114_ARNOLD;
  load_1114_ARNOLD.deltaP = 0;
  load_1114_ARNOLD.deltaQ = 0;
  load_1115_ARTHUR.switchOffSignal1.value = false;
  load_1115_ARTHUR.switchOffSignal2.value = false;
  load_1115_ARTHUR.PRefPu = P0Pu_load_1115_ARTHUR;
  load_1115_ARTHUR.QRefPu = Q0Pu_load_1115_ARTHUR;
  load_1115_ARTHUR.deltaP = 0;
  load_1115_ARTHUR.deltaQ = 0;
  load_1116_ASSER.switchOffSignal1.value = false;
  load_1116_ASSER.switchOffSignal2.value = false;
  load_1116_ASSER.PRefPu = P0Pu_load_1116_ASSER;
  load_1116_ASSER.QRefPu = Q0Pu_load_1116_ASSER;
  load_1116_ASSER.deltaP = 0;
  load_1116_ASSER.deltaQ = 0;
  load_1118_ASTOR.switchOffSignal1.value = false;
  load_1118_ASTOR.switchOffSignal2.value = false;
  load_1118_ASTOR.PRefPu = P0Pu_load_1118_ASTOR;
  load_1118_ASTOR.QRefPu = Q0Pu_load_1118_ASTOR;
  load_1118_ASTOR.deltaP = 0;
  load_1118_ASTOR.deltaQ = 0;
  load_1119_ATTAR.switchOffSignal1.value = false;
  load_1119_ATTAR.switchOffSignal2.value = false;
  load_1119_ATTAR.PRefPu = P0Pu_load_1119_ATTAR;
  load_1119_ATTAR.QRefPu = Q0Pu_load_1119_ATTAR;
  load_1119_ATTAR.deltaP = 0;
  load_1119_ATTAR.deltaQ = 0;
  load_1120_ATTILA.switchOffSignal1.value = false;
  load_1120_ATTILA.switchOffSignal2.value = false;
  load_1120_ATTILA.PRefPu = P0Pu_load_1120_ATTILA;
  load_1120_ATTILA.QRefPu = Q0Pu_load_1120_ATTILA;
  load_1120_ATTILA.deltaP = 0;
  load_1120_ATTILA.deltaQ = 0;

  connect(load_1101_ABEL.terminal, bus_1101_ABEL.terminal) annotation(
    Line(points = {{-288, -186}, {-268, -186}}, color = {0, 0, 255}));
  connect(load_1102_ADAMS.terminal, bus_1102_ADAMS.terminal) annotation(
    Line(points = {{-108, -266}, {-94, -266}}, color = {0, 0, 255}));
  connect(load_1103_ADLER.terminal, bus_1103_ADLER.terminal) annotation(
    Line(points = {{-248, -126}, {-228, -126}}, color = {0, 0, 255}));
  connect(load_1104_AGRICOLA.terminal, bus_1104_AGRICOLA.terminal) annotation(
    Line(points = {{-124, -168}, {-104, -168}}, color = {0, 0, 255}));
  connect(load_1105_AIKEN.terminal, bus_1105_AIKEN.terminal) annotation(
    Line(points = {{-34, -224}, {-14, -224}}, color = {0, 0, 255}));
  connect(load_1106_ALBER.terminal, bus_1106_ALBER.terminal) annotation(
    Line(points = {{182, -266}, {152, -266}}, color = {0, 0, 255}));
  connect(load_1107_ALDER.terminal, bus_1107_ALDER.terminal) annotation(
    Line(points = {{216, -254}, {216, -234}}, color = {0, 0, 255}));
  connect(load_1108_ALGER.terminal, bus_1108_ALGER.terminal) annotation(
    Line(points = {{216, -174}, {196, -174}}, color = {0, 0, 255}));
  connect(load_1109_ALI.terminal, bus_1109_ALI.terminal) annotation(
    Line(points = {{-124, -128}, {-104, -128}}, color = {0, 0, 255}));
  connect(load_1110_ALLEN.terminal, bus_1110_ALLEN.terminal) annotation(
    Line(points = {{86, -74}, {66, -74}}, color = {0, 0, 255}));
  connect(load_1113_ARNE.terminal, bus_1113_ARNE.terminal) annotation(
    Line(points = {{106, -54}, {106, -34}}, color = {0, 0, 255}));
  connect(load_1114_ARNOLD.terminal, bus_1114_ARNOLD.terminal) annotation(
    Line(points = {{14, 84}, {-6, 84}}, color = {0, 0, 255}));
  connect(load_1115_ARTHUR.terminal, bus_1115_ARTHUR.terminal) annotation(
    Line(points = {{-146, 164}, {-164, 164}}, color = {0, 0, 255}));
  connect(load_1116_ASSER.terminal, bus_1116_ASSER.terminal) annotation(
    Line(points = {{-146, 124}, {-124, 124}}, color = {0, 0, 255}));
  connect(load_1118_ASTOR.terminal, bus_1118_ASTOR.terminal) annotation(
    Line(points = {{66, 260}, {46, 260}}, color = {0, 0, 255}));
  connect(load_1119_ATTAR.terminal, bus_1119_ATTAR.terminal) annotation(
    Line(points = {{106, 106}, {86, 106}}, color = {0, 0, 255}));
  connect(load_1120_ATTILA.terminal, bus_1120_ATTILA.terminal) annotation(
    Line(points = {{186, 106}, {166, 106}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -340}, {300, 340}})));
end NetworkWithPQLoads;
