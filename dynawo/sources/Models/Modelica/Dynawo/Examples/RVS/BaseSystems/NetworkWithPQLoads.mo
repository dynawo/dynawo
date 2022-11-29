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

model NetworkWithPQLoads "RVS test system network extended with PQ loads"
  import Modelica.ComplexMath;
  import Modelica.SIunits.Conversions.from_deg;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Loads.LoadPQ;
  import Dynawo.Electrical.Controls.Basics.SetPoint;
  
  extends NetworkHalfSusceptance;

  final parameter Types.ActivePowerPu P0Pu_load_1101 = 118.8 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1101 = 24.2 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1101 = Complex(P0Pu_load_1101, Q0Pu_load_1101);
  final parameter Types.ComplexVoltagePu u0Pu_load_1101 = ComplexMath.fromPolar(1.0497, from_deg(-24.5));
  final parameter Types.ComplexCurrentPu i0Pu_load_1101 = ComplexMath.conj(s0Pu_load_1101 / u0Pu_load_1101);
  final parameter Types.ActivePowerPu P0Pu_load_1102 = 106.7 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1102 = 22.0 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1102 = Complex(P0Pu_load_1102, Q0Pu_load_1102);
  final parameter Types.ComplexVoltagePu u0Pu_load_1102 = ComplexMath.fromPolar(1.0496, from_deg(-24.1));
  final parameter Types.ComplexCurrentPu i0Pu_load_1102 = ComplexMath.conj(s0Pu_load_1102 / u0Pu_load_1102);
  final parameter Types.ActivePowerPu P0Pu_load_1103 = 198.0 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1103 = 40.7 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1103 = Complex(P0Pu_load_1103, Q0Pu_load_1103);
  final parameter Types.ComplexVoltagePu u0Pu_load_1103 = ComplexMath.fromPolar(1.0446, from_deg(-22.2));
  final parameter Types.ComplexCurrentPu i0Pu_load_1103 = ComplexMath.conj(s0Pu_load_1103 / u0Pu_load_1103);
  final parameter Types.ActivePowerPu P0Pu_load_1104 = 81.4 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1104 = 16.5 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1104 = Complex(P0Pu_load_1104, Q0Pu_load_1104);
  final parameter Types.ComplexVoltagePu u0Pu_load_1104 = ComplexMath.fromPolar(1.0450, from_deg(-26.5));
  final parameter Types.ComplexCurrentPu i0Pu_load_1104 = ComplexMath.conj(s0Pu_load_1104 / u0Pu_load_1104);
  final parameter Types.ActivePowerPu P0Pu_load_1105 = 78.1 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1105 = 15.4 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1105 = Complex(P0Pu_load_1105, Q0Pu_load_1105);
  final parameter Types.ComplexVoltagePu u0Pu_load_1105 = ComplexMath.fromPolar(1.0488, from_deg(-26.8));
  final parameter Types.ComplexCurrentPu i0Pu_load_1105 = ComplexMath.conj(s0Pu_load_1105 / u0Pu_load_1105);
  final parameter Types.ActivePowerPu P0Pu_load_1106 = 149.6 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1106 = 30.8 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1106 = Complex(P0Pu_load_1106, Q0Pu_load_1106);
  final parameter Types.ComplexVoltagePu u0Pu_load_1106 = ComplexMath.fromPolar(1.035, from_deg(-29.5));
  final parameter Types.ComplexCurrentPu i0Pu_load_1106 = ComplexMath.conj(s0Pu_load_1106 / u0Pu_load_1106);
  final parameter Types.ActivePowerPu P0Pu_load_1107 = 137.5 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1107 = 27.5 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1107 = Complex(P0Pu_load_1107, Q0Pu_load_1107);
  final parameter Types.ComplexVoltagePu u0Pu_load_1107 = ComplexMath.fromPolar(1.0497, from_deg(-27.4));
  final parameter Types.ComplexCurrentPu i0Pu_load_1107 = ComplexMath.conj(s0Pu_load_1107 / u0Pu_load_1107);
  final parameter Types.ActivePowerPu P0Pu_load_1108 = 188.1 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1108 = 38.5 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1108 = Complex(P0Pu_load_1108, Q0Pu_load_1108);
  final parameter Types.ComplexVoltagePu u0Pu_load_1108 = ComplexMath.fromPolar(1.0442, from_deg(-28.6));
  final parameter Types.ComplexCurrentPu i0Pu_load_1108 = ComplexMath.conj(s0Pu_load_1108 / u0Pu_load_1108);
  final parameter Types.ActivePowerPu P0Pu_load_1109 = 192.5 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1109 = 39.6 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1109 = Complex(P0Pu_load_1109, Q0Pu_load_1109);
  final parameter Types.ComplexVoltagePu u0Pu_load_1109 = ComplexMath.fromPolar(1.0477, from_deg(-23.2));
  final parameter Types.ComplexCurrentPu i0Pu_load_1109 = ComplexMath.conj(s0Pu_load_1109 / u0Pu_load_1109);
  final parameter Types.ActivePowerPu P0Pu_load_1110 = 214.5 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1110 = 44.0 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1110 = Complex(P0Pu_load_1110, Q0Pu_load_1110);
  final parameter Types.ComplexVoltagePu u0Pu_load_1110 = ComplexMath.fromPolar(1.0484, from_deg(-26.3));
  final parameter Types.ComplexCurrentPu i0Pu_load_1110 = ComplexMath.conj(s0Pu_load_1110 / u0Pu_load_1110);
  final parameter Types.ActivePowerPu P0Pu_load_1113 = 291.5 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1113 = 59.4 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1113 = Complex(P0Pu_load_1113, Q0Pu_load_1113);
  final parameter Types.ComplexVoltagePu u0Pu_load_1113 = ComplexMath.fromPolar(1.0453, from_deg(-12.5));
  final parameter Types.ComplexCurrentPu i0Pu_load_1113 = ComplexMath.conj(s0Pu_load_1113 / u0Pu_load_1113);
  final parameter Types.ActivePowerPu P0Pu_load_1114 = 213.4 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1114 = 42.9 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1114 = Complex(P0Pu_load_1114, Q0Pu_load_1114);
  final parameter Types.ComplexVoltagePu u0Pu_load_1114 = ComplexMath.fromPolar(1.0433, from_deg(-16.3));
  final parameter Types.ComplexCurrentPu i0Pu_load_1114 = ComplexMath.conj(s0Pu_load_1114 / u0Pu_load_1114);
  final parameter Types.ActivePowerPu P0Pu_load_1115 = 348.7 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1115 = 70.4 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1115 = Complex(P0Pu_load_1115, Q0Pu_load_1115);
  final parameter Types.ComplexVoltagePu u0Pu_load_1115 = ComplexMath.fromPolar(1.0497, from_deg(-5.6));
  final parameter Types.ComplexCurrentPu i0Pu_load_1115 = ComplexMath.conj(s0Pu_load_1115 / u0Pu_load_1115);
  final parameter Types.ActivePowerPu P0Pu_load_1116 = 110.0 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1116 = 22.0 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1116 = Complex(P0Pu_load_1116, Q0Pu_load_1116);
  final parameter Types.ComplexVoltagePu u0Pu_load_1116 = ComplexMath.fromPolar(1.0496, from_deg(-5.2));
  final parameter Types.ComplexCurrentPu i0Pu_load_1116 = ComplexMath.conj(s0Pu_load_1116 / u0Pu_load_1116);
  final parameter Types.ActivePowerPu P0Pu_load_1118 = 366.3 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1118 = 74.8 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1118 = Complex(P0Pu_load_1118, Q0Pu_load_1118);
  final parameter Types.ComplexVoltagePu u0Pu_load_1118 = ComplexMath.fromPolar(1.0492, from_deg(-0.5));
  final parameter Types.ComplexCurrentPu i0Pu_load_1118 = ComplexMath.conj(s0Pu_load_1118 / u0Pu_load_1118);
  final parameter Types.ActivePowerPu P0Pu_load_1119 = 199.1 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1119 = 40.7 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1119 = Complex(P0Pu_load_1119, Q0Pu_load_1119);
  final parameter Types.ComplexVoltagePu u0Pu_load_1119 = ComplexMath.fromPolar(1.0498, from_deg(-6.7));
  final parameter Types.ComplexCurrentPu i0Pu_load_1119 = ComplexMath.conj(s0Pu_load_1119 / u0Pu_load_1119);
  final parameter Types.ActivePowerPu P0Pu_load_1120 = 140.8 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1120 = 28.6 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1120 = Complex(P0Pu_load_1120, Q0Pu_load_1120);
  final parameter Types.ComplexVoltagePu u0Pu_load_1120 = ComplexMath.fromPolar(1.0497, from_deg(-4.9));
  final parameter Types.ComplexCurrentPu i0Pu_load_1120 = ComplexMath.conj(s0Pu_load_1120 / u0Pu_load_1120);
  
  Electrical.Controls.Basics.SetPoint PrefPu_load_1101(Value0 = P0Pu_load_1101);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1101(Value0 = Q0Pu_load_1101);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1102(Value0 = P0Pu_load_1102);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1102(Value0 = Q0Pu_load_1102);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1103(Value0 = P0Pu_load_1103);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1103(Value0 = Q0Pu_load_1103);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1104(Value0 = P0Pu_load_1104);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1104(Value0 = Q0Pu_load_1104);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1105(Value0 = P0Pu_load_1105);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1105(Value0 = Q0Pu_load_1105);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1106(Value0 = P0Pu_load_1106);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1106(Value0 = Q0Pu_load_1106);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1107(Value0 = P0Pu_load_1107);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1107(Value0 = Q0Pu_load_1107);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1108(Value0 = P0Pu_load_1108);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1108(Value0 = Q0Pu_load_1108);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1109(Value0 = P0Pu_load_1109);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1109(Value0 = Q0Pu_load_1109);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1110(Value0 = P0Pu_load_1110);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1110(Value0 = Q0Pu_load_1110);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1113(Value0 = P0Pu_load_1113);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1113(Value0 = Q0Pu_load_1113);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1114(Value0 = P0Pu_load_1114);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1114(Value0 = Q0Pu_load_1114);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1115(Value0 = P0Pu_load_1115);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1115(Value0 = Q0Pu_load_1115);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1116(Value0 = P0Pu_load_1116);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1116(Value0 = Q0Pu_load_1116);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1118(Value0 = P0Pu_load_1118);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1118(Value0 = Q0Pu_load_1118);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1119(Value0 = P0Pu_load_1119);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1119(Value0 = Q0Pu_load_1119);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1120(Value0 = P0Pu_load_1120);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1120(Value0 = Q0Pu_load_1120);
  
  Dynawo.Electrical.Loads.LoadPQ load_1101_ABEL(i0Pu = i0Pu_load_1101, s0Pu = s0Pu_load_1101, u0Pu = u0Pu_load_1101) annotation(
    Placement(visible = true, transformation(origin = {-270, -150}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  LoadPQ load_1102_ADAMS(i0Pu = i0Pu_load_1102, s0Pu = s0Pu_load_1102, u0Pu = u0Pu_load_1102) annotation(
    Placement(visible = true, transformation(origin = {-110, -230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  LoadPQ load_1103_ADLER(i0Pu = i0Pu_load_1103, s0Pu = s0Pu_load_1103, u0Pu = u0Pu_load_1103) annotation(
    Placement(visible = true, transformation(origin = {-230, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  LoadPQ load_1104_AGRICOLA(i0Pu = i0Pu_load_1104, s0Pu = s0Pu_load_1104, u0Pu = u0Pu_load_1104) annotation(
    Placement(visible = true, transformation(origin = {-130, -130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  LoadPQ load_1105_AIKEN(i0Pu = i0Pu_load_1105, s0Pu = s0Pu_load_1105, u0Pu = u0Pu_load_1105) annotation(
    Placement(visible = true, transformation(origin = {-40, -190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  LoadPQ load_1106_ALBER(i0Pu = i0Pu_load_1106, s0Pu = s0Pu_load_1106, u0Pu = u0Pu_load_1106) annotation(
    Placement(visible = true, transformation(origin = {150, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  LoadPQ load_1107_ALDER(i0Pu = i0Pu_load_1107, s0Pu = s0Pu_load_1107, u0Pu = u0Pu_load_1107) annotation(
    Placement(visible = true, transformation(origin = {190, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  LoadPQ load_1108_ALGER(i0Pu = i0Pu_load_1108, s0Pu = s0Pu_load_1108, u0Pu = u0Pu_load_1108) annotation(
    Placement(visible = true, transformation(origin = {190, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  LoadPQ load_1109_ALI(i0Pu = i0Pu_load_1109, s0Pu = s0Pu_load_1109, u0Pu = u0Pu_load_1109) annotation(
    Placement(visible = true, transformation(origin = {-130, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  LoadPQ load_1110_ALLEN(i0Pu = i0Pu_load_1110, s0Pu = s0Pu_load_1110, u0Pu = u0Pu_load_1110) annotation(
    Placement(visible = true, transformation(origin = {90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  LoadPQ load_1113_ARNE(i0Pu = i0Pu_load_1113, s0Pu = s0Pu_load_1113, u0Pu = u0Pu_load_1113) annotation(
    Placement(visible = true, transformation(origin = {110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ load_1114_ARNOLD(i0Pu = i0Pu_load_1114, s0Pu = s0Pu_load_1114, u0Pu = u0Pu_load_1114) annotation(
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  LoadPQ load_1115_ARTHUR(i0Pu = i0Pu_load_1115, s0Pu = s0Pu_load_1115, u0Pu = u0Pu_load_1115) annotation(
    Placement(visible = true, transformation(origin = {-110, 152}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  LoadPQ load_1116_ASSER(i0Pu = i0Pu_load_1116, s0Pu = s0Pu_load_1116, u0Pu = u0Pu_load_1116) annotation(
    Placement(visible = true, transformation(origin = {-150, 82}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  LoadPQ load_1118_ASTOR(i0Pu = i0Pu_load_1118, s0Pu = s0Pu_load_1118, u0Pu = u0Pu_load_1118) annotation(
    Placement(visible = true, transformation(origin = {90, 210}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  LoadPQ load_1119_ATTAR(i0Pu = i0Pu_load_1119, s0Pu = s0Pu_load_1119, u0Pu = u0Pu_load_1119) annotation(
    Placement(visible = true, transformation(origin = {90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  LoadPQ load_1120_ATTILA(i0Pu = i0Pu_load_1120, s0Pu = s0Pu_load_1120, u0Pu = u0Pu_load_1120) annotation(
    Placement(visible = true, transformation(origin = {170, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  connect(load_1101_ABEL.terminal, bus_1101_ABEL.terminal) annotation(
    Line(points = {{-270, -150}, {-250, -150}}, color = {0, 0, 255}));
  connect(load_1102_ADAMS.terminal, bus_1102_ADAMS.terminal) annotation(
    Line(points = {{-110, -230}, {-90, -230}}, color = {0, 0, 255}));
  connect(load_1105_AIKEN.terminal, bus_1105_AIKEN.terminal) annotation(
    Line(points = {{-40, -190}, {-20, -190}}, color = {0, 0, 255}));
  connect(load_1107_ALDER.terminal, bus_1107_ALDER.terminal) annotation(
    Line(points = {{190, -230}, {190, -210}}, color = {0, 0, 255}));
  connect(load_1104_AGRICOLA.terminal, bus_1104_AGRICOLA.terminal) annotation(
    Line(points = {{-130, -130}, {-110, -130}}, color = {0, 0, 255}));
  connect(load_1108_ALGER.terminal, bus_1108_ALGER.terminal) annotation(
    Line(points = {{190, -150}, {170, -150}}, color = {0, 0, 255}));
  connect(load_1106_ALBER.terminal, bus_1106_ALBER.terminal) annotation(
    Line(points = {{150, -230}, {130, -230}}, color = {0, 0, 255}));
  connect(load_1113_ARNE.terminal, bus_1113_ARNE.terminal) annotation(
    Line(points = {{110, -90}, {110, -70}}, color = {0, 0, 255}));
  connect(load_1109_ALI.terminal, bus_1109_ALI.terminal) annotation(
    Line(points = {{-130, -90}, {-110, -90}}, color = {0, 0, 255}));
  connect(load_1103_ADLER.terminal, bus_1103_ADLER.terminal) annotation(
    Line(points = {{-230, -90}, {-210, -90}}, color = {0, 0, 255}));
  connect(load_1110_ALLEN.terminal, bus_1110_ALLEN.terminal) annotation(
    Line(points = {{90, -30}, {70, -30}}, color = {0, 0, 255}));
  connect(load_1114_ARNOLD.terminal, bus_1114_ARNOLD.terminal) annotation(
    Line(points = {{10, 50}, {-10, 50}}, color = {0, 0, 255}));
  connect(load_1120_ATTILA.terminal, bus_1120_ATTILA.terminal) annotation(
    Line(points = {{170, 70}, {150, 70}}, color = {0, 0, 255}));
  connect(load_1119_ATTAR.terminal, bus_1119_ATTAR.terminal) annotation(
    Line(points = {{90, 70}, {70, 70}}, color = {0, 0, 255}));
  connect(load_1116_ASSER.terminal, bus_1116_ASSER.terminal) annotation(
    Line(points = {{-150, 82}, {-130, 82}}, color = {0, 0, 255}));
  connect(load_1118_ASTOR.terminal, bus_1118_ASTOR.terminal) annotation(
    Line(points = {{90, 210}, {70, 210}}, color = {0, 0, 255}));
  connect(load_1115_ARTHUR.terminal, bus_1115_ARTHUR.terminal) annotation(
    Line(points = {{-110, 152}, {-130, 152}}, color = {0, 0, 255}));
    
  load_1101_ABEL.switchOffSignal1.value = false;
  load_1101_ABEL.switchOffSignal2.value = false;
  load_1102_ADAMS.switchOffSignal1.value = false;
  load_1102_ADAMS.switchOffSignal2.value = false;
  load_1103_ADLER.switchOffSignal1.value = false;
  load_1103_ADLER.switchOffSignal2.value = false;
  load_1104_AGRICOLA.switchOffSignal1.value = false;
  load_1104_AGRICOLA.switchOffSignal2.value = false;
  load_1105_AIKEN.switchOffSignal1.value = false;
  load_1105_AIKEN.switchOffSignal2.value = false;
  load_1106_ALBER.switchOffSignal1.value = false;
  load_1106_ALBER.switchOffSignal2.value = false;
  load_1107_ALDER.switchOffSignal1.value = false;
  load_1107_ALDER.switchOffSignal2.value = false;
  load_1108_ALGER.switchOffSignal1.value = false;
  load_1108_ALGER.switchOffSignal2.value = false;
  load_1109_ALI.switchOffSignal1.value = false;
  load_1109_ALI.switchOffSignal2.value = false;
  load_1110_ALLEN.switchOffSignal1.value = false;
  load_1110_ALLEN.switchOffSignal2.value = false;
  load_1113_ARNE.switchOffSignal1.value = false;
  load_1113_ARNE.switchOffSignal2.value = false;
  load_1114_ARNOLD.switchOffSignal1.value = false;
  load_1114_ARNOLD.switchOffSignal2.value = false;
  load_1115_ARTHUR.switchOffSignal1.value = false;
  load_1115_ARTHUR.switchOffSignal2.value = false;
  load_1116_ASSER.switchOffSignal1.value = false;
  load_1116_ASSER.switchOffSignal2.value = false;
  load_1118_ASTOR.switchOffSignal1.value = false;
  load_1118_ASTOR.switchOffSignal2.value = false;
  load_1119_ATTAR.switchOffSignal1.value = false;
  load_1119_ATTAR.switchOffSignal2.value = false;
  load_1120_ATTILA.switchOffSignal1.value = false;
  load_1120_ATTILA.switchOffSignal2.value = false;
  
  PrefPu_load_1101.setPoint.value = load_1101_ABEL.PRefPu;
  QrefPu_load_1101.setPoint.value = load_1101_ABEL.QRefPu;
  PrefPu_load_1102.setPoint.value = load_1102_ADAMS.PRefPu;
  QrefPu_load_1102.setPoint.value = load_1102_ADAMS.QRefPu;
  PrefPu_load_1103.setPoint.value = load_1103_ADLER.PRefPu;
  QrefPu_load_1103.setPoint.value = load_1103_ADLER.QRefPu;
  PrefPu_load_1104.setPoint.value = load_1104_AGRICOLA.PRefPu;
  QrefPu_load_1104.setPoint.value = load_1104_AGRICOLA.QRefPu;
  PrefPu_load_1105.setPoint.value = load_1105_AIKEN.PRefPu;
  QrefPu_load_1105.setPoint.value = load_1105_AIKEN.QRefPu;
  PrefPu_load_1106.setPoint.value = load_1106_ALBER.PRefPu;
  QrefPu_load_1106.setPoint.value = load_1106_ALBER.QRefPu;
  PrefPu_load_1107.setPoint.value = load_1107_ALDER.PRefPu;
  QrefPu_load_1107.setPoint.value = load_1107_ALDER.QRefPu;
  PrefPu_load_1108.setPoint.value = load_1108_ALGER.PRefPu;
  QrefPu_load_1108.setPoint.value = load_1108_ALGER.QRefPu;
  PrefPu_load_1109.setPoint.value = load_1109_ALI.PRefPu;
  QrefPu_load_1109.setPoint.value = load_1109_ALI.QRefPu;
  PrefPu_load_1110.setPoint.value = load_1110_ALLEN.PRefPu;
  QrefPu_load_1110.setPoint.value = load_1110_ALLEN.QRefPu;
  PrefPu_load_1113.setPoint.value = load_1113_ARNE.PRefPu;
  QrefPu_load_1113.setPoint.value = load_1113_ARNE.QRefPu;
  PrefPu_load_1114.setPoint.value = load_1114_ARNOLD.PRefPu;
  QrefPu_load_1114.setPoint.value = load_1114_ARNOLD.QRefPu;
  PrefPu_load_1115.setPoint.value = load_1115_ARTHUR.PRefPu;
  QrefPu_load_1115.setPoint.value = load_1115_ARTHUR.QRefPu;
  PrefPu_load_1116.setPoint.value = load_1116_ASSER.PRefPu;
  QrefPu_load_1116.setPoint.value = load_1116_ASSER.QRefPu;
  PrefPu_load_1118.setPoint.value = load_1118_ASTOR.PRefPu;
  QrefPu_load_1118.setPoint.value = load_1118_ASTOR.QRefPu;
  PrefPu_load_1119.setPoint.value = load_1119_ATTAR.PRefPu;
  QrefPu_load_1119.setPoint.value = load_1119_ATTAR.QRefPu;
  PrefPu_load_1120.setPoint.value = load_1120_ATTILA.PRefPu;
  QrefPu_load_1120.setPoint.value = load_1120_ATTILA.QRefPu;
  
end NetworkWithPQLoads;
