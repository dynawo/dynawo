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
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model NetworkWithPQLoads
  import Modelica.SIunits.Conversions.from_deg;
  import Dynawo;
  import Dynawo.Electrical.SystemBase.SnRef;
  
  extends Network;
  // ===================================================================
 
   parameter  Types.ActivePowerPu P0Pu_load_1101_ABEL;
  parameter  Types.ReactivePowerPu Q0Pu_load_1101_ABEL;
  parameter  Types.VoltageModulePu U0Pu_load_1101_ABEL;
  parameter  Types.Angle UPhase0_load_1101_ABEL;

  parameter  Types.ActivePowerPu P0Pu_load_1102_ADAMS;
  parameter  Types.ReactivePowerPu Q0Pu_load_1102_ADAMS;
  parameter  Types.VoltageModulePu U0Pu_load_1102_ADAMS;
  parameter  Types.Angle UPhase0_load_1102_ADAMS;

  parameter  Types.ActivePowerPu P0Pu_load_1103_ADLER;
  parameter  Types.ReactivePowerPu Q0Pu_load_1103_ADLER;
  parameter  Types.VoltageModulePu U0Pu_load_1103_ADLER;
  parameter  Types.Angle UPhase0_load_1103_ADLER;

  parameter  Types.ActivePowerPu P0Pu_load_1104_AGRICOLA;
  parameter  Types.ReactivePowerPu Q0Pu_load_1104_AGRICOLA;
  parameter  Types.VoltageModulePu U0Pu_load_1104_AGRICOLA;
  parameter  Types.Angle UPhase0_load_1104_AGRICOLA;

  parameter  Types.ActivePowerPu P0Pu_load_1105_AIKEN;
  parameter  Types.ReactivePowerPu Q0Pu_load_1105_AIKEN;
  parameter  Types.VoltageModulePu U0Pu_load_1105_AIKEN;
  parameter  Types.Angle UPhase0_load_1105_AIKEN;

  parameter  Types.ActivePowerPu P0Pu_load_1106_ALBER;
  parameter  Types.ReactivePowerPu Q0Pu_load_1106_ALBER;
  parameter  Types.VoltageModulePu U0Pu_load_1106_ALBER;
  parameter  Types.Angle UPhase0_load_1106_ALBER;

  parameter  Types.ActivePowerPu P0Pu_load_1107_ALDER;
  parameter  Types.ReactivePowerPu Q0Pu_load_1107_ALDER;
  parameter  Types.VoltageModulePu U0Pu_load_1107_ALDER;
  parameter  Types.Angle UPhase0_load_1107_ALDER;

  parameter  Types.ActivePowerPu P0Pu_load_1108_ALGER;
  parameter  Types.ReactivePowerPu Q0Pu_load_1108_ALGER;
  parameter  Types.VoltageModulePu U0Pu_load_1108_ALGER;
  parameter  Types.Angle UPhase0_load_1108_ALGER;

  parameter  Types.ActivePowerPu P0Pu_load_1109_ALI;
  parameter  Types.ReactivePowerPu Q0Pu_load_1109_ALI;
  parameter  Types.VoltageModulePu U0Pu_load_1109_ALI;
  parameter  Types.Angle UPhase0_load_1109_ALI;

  parameter  Types.ActivePowerPu P0Pu_load_1110_ALLEN;
  parameter  Types.ReactivePowerPu Q0Pu_load_1110_ALLEN;
  parameter  Types.VoltageModulePu U0Pu_load_1110_ALLEN;
  parameter  Types.Angle UPhase0_load_1110_ALLEN;

  parameter  Types.ActivePowerPu P0Pu_load_1113_ARNE;
  parameter  Types.ReactivePowerPu Q0Pu_load_1113_ARNE;
  parameter  Types.VoltageModulePu U0Pu_load_1113_ARNE;
  parameter  Types.Angle UPhase0_load_1113_ARNE;

  parameter  Types.ActivePowerPu P0Pu_load_1114_ARNOLD;
  parameter  Types.ReactivePowerPu Q0Pu_load_1114_ARNOLD;
  parameter  Types.VoltageModulePu U0Pu_load_1114_ARNOLD;
  parameter  Types.Angle UPhase0_load_1114_ARNOLD;

  parameter  Types.ActivePowerPu P0Pu_load_1115_ARTHUR;
  parameter  Types.ReactivePowerPu Q0Pu_load_1115_ARTHUR;
  parameter  Types.VoltageModulePu U0Pu_load_1115_ARTHUR;
  parameter  Types.Angle UPhase0_load_1115_ARTHUR;

  parameter  Types.ActivePowerPu P0Pu_load_1116_ASSER;
  parameter  Types.ReactivePowerPu Q0Pu_load_1116_ASSER;
  parameter  Types.VoltageModulePu U0Pu_load_1116_ASSER;
  parameter  Types.Angle UPhase0_load_1116_ASSER;

  parameter  Types.ActivePowerPu P0Pu_load_1118_ASTOR;
  parameter  Types.ReactivePowerPu Q0Pu_load_1118_ASTOR;
  parameter  Types.VoltageModulePu U0Pu_load_1118_ASTOR;
  parameter  Types.Angle UPhase0_load_1118_ASTOR;

  parameter  Types.ActivePowerPu P0Pu_load_1119_ATTAR;
  parameter  Types.ReactivePowerPu Q0Pu_load_1119_ATTAR;
  parameter  Types.VoltageModulePu U0Pu_load_1119_ATTAR;
  parameter  Types.Angle UPhase0_load_1119_ATTAR;

  parameter  Types.ActivePowerPu P0Pu_load_1120_ATTILA;
  parameter  Types.ReactivePowerPu Q0Pu_load_1120_ATTILA;
  parameter  Types.VoltageModulePu U0Pu_load_1120_ATTILA;
  parameter  Types.Angle UPhase0_load_1120_ATTILA;

  Dynawo.Electrical.Loads.LoadPQ load_1118_ASTOR(i0Pu = i0Pu_load_1118_ASTOR, s0Pu = s0Pu_load_1118_ASTOR, u0Pu = u0Pu_load_1118_ASTOR) annotation(
    Placement(visible = true, transformation(origin = {66, 260}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1115_ARTHUR(i0Pu = i0Pu_load_1115_ARTHUR, s0Pu = s0Pu_load_1115_ARTHUR, u0Pu = u0Pu_load_1115_ARTHUR) annotation(
    Placement(visible = true, transformation(origin = {-146, 164}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1116_ASSER(i0Pu = i0Pu_load_1116_ASSER, s0Pu = s0Pu_load_1116_ASSER, u0Pu = u0Pu_load_1116_ASSER) annotation(
    Placement(visible = true, transformation(origin = {-146, 124}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1114_ARNOLD(i0Pu = i0Pu_load_1114_ARNOLD, s0Pu = s0Pu_load_1114_ARNOLD, u0Pu = u0Pu_load_1114_ARNOLD) annotation(
    Placement(visible = true, transformation(origin = {14, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1101_ABEL(i0Pu = i0Pu_load_1101_ABEL, s0Pu = s0Pu_load_1101_ABEL, u0Pu = u0Pu_load_1101_ABEL) annotation(
    Placement(visible = true, transformation(origin = {-288, -186}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1103_ADLER(i0Pu = i0Pu_load_1103_ADLER, s0Pu = s0Pu_load_1103_ADLER, u0Pu = u0Pu_load_1103_ADLER) annotation(
    Placement(visible = true, transformation(origin = {-248, -126}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1102_ADAMS(i0Pu = i0Pu_load_1102_ADAMS, s0Pu = s0Pu_load_1102_ADAMS, u0Pu = u0Pu_load_1102_ADAMS) annotation(
    Placement(visible = true, transformation(origin = {-108, -266}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1106_ALBER(i0Pu = i0Pu_load_1106_ALBER, s0Pu = s0Pu_load_1106_ALBER, u0Pu = u0Pu_load_1106_ALBER) annotation(
    Placement(visible = true, transformation(origin = {182, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1119_ATTAR(i0Pu = i0Pu_load_1119_ATTAR, s0Pu = s0Pu_load_1119_ATTAR, u0Pu = u0Pu_load_1119_ATTAR) annotation(
    Placement(visible = true, transformation(origin = {106, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1120_ATTILA(i0Pu = i0Pu_load_1120_ATTILA, s0Pu = s0Pu_load_1120_ATTILA, u0Pu = u0Pu_load_1120_ATTILA) annotation(
    Placement(visible = true, transformation(origin = {186, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1113_ARNE(i0Pu = i0Pu_load_1113_ARNE, s0Pu = s0Pu_load_1113_ARNE, u0Pu = u0Pu_load_1113_ARNE) annotation(
    Placement(visible = true, transformation(origin = {106, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ load_1107_ALDER(i0Pu = i0Pu_load_1107_ALDER, s0Pu = s0Pu_load_1107_ALDER, u0Pu = u0Pu_load_1107_ALDER) annotation(
    Placement(visible = true, transformation(origin = {216, -254}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ load_1108_ALGER(i0Pu = i0Pu_load_1108_ALGER, s0Pu = s0Pu_load_1108_ALGER, u0Pu = u0Pu_load_1108_ALGER) annotation(
    Placement(visible = true, transformation(origin = {216, -174}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1109_ALI(i0Pu = i0Pu_load_1109_ALI, s0Pu = s0Pu_load_1109_ALI, u0Pu = u0Pu_load_1109_ALI) annotation(
    Placement(visible = true, transformation(origin = {-124, -128}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1104_AGRICOLA(i0Pu = i0Pu_load_1104_AGRICOLA, s0Pu = s0Pu_load_1104_AGRICOLA, u0Pu = u0Pu_load_1104_AGRICOLA) annotation(
    Placement(visible = true, transformation(origin = {-124, -168}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1105_AIKEN(i0Pu = i0Pu_load_1105_AIKEN, s0Pu = s0Pu_load_1105_AIKEN, u0Pu = u0Pu_load_1105_AIKEN) annotation(
    Placement(visible = true, transformation(origin = {-34, -224}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1110_ALLEN(i0Pu = i0Pu_load_1110_ALLEN, s0Pu = s0Pu_load_1110_ALLEN, u0Pu = u0Pu_load_1110_ALLEN) annotation(
    Placement(visible = true, transformation(origin = {86, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  load_1101_ABEL.switchOffSignal1.value = false;
  load_1101_ABEL.switchOffSignal2.value = false;
  load_1101_ABEL.PRefPu = P0Pu_load_1101_ABEL;
  load_1101_ABEL.QRefPu = Q0Pu_load_1101_ABEL;
  load_1102_ADAMS.switchOffSignal1.value = false;
  load_1102_ADAMS.switchOffSignal2.value = false;
  load_1102_ADAMS.PRefPu = P0Pu_load_1102_ADAMS;
  load_1102_ADAMS.QRefPu = Q0Pu_load_1102_ADAMS;
  load_1103_ADLER.switchOffSignal1.value = false;
  load_1103_ADLER.switchOffSignal2.value = false;
  load_1103_ADLER.PRefPu = P0Pu_load_1103_ADLER;
  load_1103_ADLER.QRefPu = Q0Pu_load_1103_ADLER;
  load_1104_AGRICOLA.switchOffSignal1.value = false;
  load_1104_AGRICOLA.switchOffSignal2.value = false;
  load_1104_AGRICOLA.PRefPu = P0Pu_load_1104_AGRICOLA;
  load_1104_AGRICOLA.QRefPu = Q0Pu_load_1104_AGRICOLA;
  load_1105_AIKEN.switchOffSignal1.value = false;
  load_1105_AIKEN.switchOffSignal2.value = false;
  load_1105_AIKEN.PRefPu = P0Pu_load_1105_AIKEN;
  load_1105_AIKEN.QRefPu = Q0Pu_load_1105_AIKEN;
  load_1106_ALBER.switchOffSignal1.value = false;
  load_1106_ALBER.switchOffSignal2.value = false;
  load_1106_ALBER.PRefPu = P0Pu_load_1106_ALBER;
  load_1106_ALBER.QRefPu = Q0Pu_load_1106_ALBER;
  load_1107_ALDER.switchOffSignal1.value = false;
  load_1107_ALDER.switchOffSignal2.value = false;
  load_1107_ALDER.PRefPu = P0Pu_load_1107_ALDER;
  load_1107_ALDER.QRefPu = Q0Pu_load_1107_ALDER;
  load_1108_ALGER.switchOffSignal1.value = false;
  load_1108_ALGER.switchOffSignal2.value = false;
  load_1108_ALGER.PRefPu = P0Pu_load_1108_ALGER;
  load_1108_ALGER.QRefPu = Q0Pu_load_1108_ALGER;
  load_1109_ALI.switchOffSignal1.value = false;
  load_1109_ALI.switchOffSignal2.value = false;
  load_1109_ALI.PRefPu = P0Pu_load_1109_ALI;
  load_1109_ALI.QRefPu = Q0Pu_load_1109_ALI;
  load_1110_ALLEN.switchOffSignal1.value = false;
  load_1110_ALLEN.switchOffSignal2.value = false;
  load_1110_ALLEN.PRefPu = P0Pu_load_1110_ALLEN;
  load_1110_ALLEN.QRefPu = Q0Pu_load_1110_ALLEN;
  load_1113_ARNE.switchOffSignal1.value = false;
  load_1113_ARNE.switchOffSignal2.value = false;
  load_1113_ARNE.PRefPu = P0Pu_load_1113_ARNE;
  load_1113_ARNE.QRefPu = Q0Pu_load_1113_ARNE;
  load_1118_ASTOR.switchOffSignal1.value = false;
  load_1118_ASTOR.switchOffSignal2.value = false;
  load_1118_ASTOR.PRefPu = P0Pu_load_1118_ASTOR;
  load_1118_ASTOR.QRefPu = Q0Pu_load_1118_ASTOR;
  load_1114_ARNOLD.switchOffSignal1.value = false;
  load_1114_ARNOLD.switchOffSignal2.value = false;
  load_1114_ARNOLD.PRefPu = P0Pu_load_1114_ARNOLD;
  load_1114_ARNOLD.QRefPu = Q0Pu_load_1114_ARNOLD;
  load_1115_ARTHUR.switchOffSignal1.value = false;
  load_1115_ARTHUR.switchOffSignal2.value = false;
  load_1115_ARTHUR.PRefPu = P0Pu_load_1115_ARTHUR;
  load_1115_ARTHUR.QRefPu = Q0Pu_load_1115_ARTHUR;
  load_1116_ASSER.switchOffSignal1.value = false;
  load_1116_ASSER.switchOffSignal2.value = false;
  load_1116_ASSER.PRefPu = P0Pu_load_1116_ASSER;
  load_1116_ASSER.QRefPu = Q0Pu_load_1116_ASSER;
  load_1119_ATTAR.switchOffSignal1.value = false;
  load_1119_ATTAR.switchOffSignal2.value = false;
  load_1119_ATTAR.PRefPu = P0Pu_load_1119_ATTAR;
  load_1119_ATTAR.QRefPu = Q0Pu_load_1119_ATTAR;
  load_1120_ATTILA.switchOffSignal1.value = false;
  load_1120_ATTILA.switchOffSignal2.value = false;
  load_1120_ATTILA.PRefPu = P0Pu_load_1120_ATTILA;
  load_1120_ATTILA.QRefPu = Q0Pu_load_1120_ATTILA;
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
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida"),
    Diagram(coordinateSystem(extent = {{-200, -300}, {200, 300}})),
    Icon(coordinateSystem(extent = {{-200, -300}, {200, 300}})));
end NetworkWithPQLoads;
