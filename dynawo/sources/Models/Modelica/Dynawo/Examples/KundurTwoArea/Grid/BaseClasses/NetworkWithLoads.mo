within Dynawo.Examples.KundurTwoArea.Grid.BaseClasses;

model NetworkWithLoads "Kundur two-area system with buses, lines and transformers, loads, shunts and generators."
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
  extends Dynawo.Examples.KundurTwoArea.Grid.BaseClasses.Network;
  Dynawo.Electrical.Loads.LoadZIP load09(Ip = 1, Iq = 0, Pp = 0, Pq = 0, Zp = 0, Zq = 1, s0Pu = s0PuLoad09, u0Pu = Complex(1, 0), i0Pu = s0PuLoad09) annotation(
    Placement(visible = true, transformation(origin = {72, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadZIP shunt09(Ip = 1, Iq = 0, Pp = 0, Pq = 0, Zp = 0, Zq = 1, i0Pu = s0PuShunt09, s0Pu = s0PuShunt09, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {51, 37}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Electrical.Loads.LoadZIP load07(Ip = 1, Iq = 0, Pp = 0, Pq = 0, Zp = 0, Zq = 1, i0Pu = s0PuLoad07, s0Pu = s0PuLoad07, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-72, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Loads.LoadZIP shunt07(Ip = 1, Iq = 0, Pp = 0, Pq = 0, Zp = 0, Zq = 1, i0Pu = s0PuShunt07, s0Pu = s0PuShunt07, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-51, 35}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
 
  // loads
  parameter Types.ActivePowerPu P0PuLoad07;
  parameter Types.ReactivePowerPu Q0PuLoad07;
  final parameter Types.ComplexApparentPowerPu s0PuLoad07 = Complex(P0PuLoad07, Q0PuLoad07);

  parameter Types.ActivePowerPu P0PuLoad09;
  parameter Types.ReactivePowerPu Q0PuLoad09;
  final parameter Types.ComplexApparentPowerPu s0PuLoad09 = Complex(P0PuLoad09, Q0PuLoad09)/Electrical.SystemBase.SnRef;
  // shunt capacitors
  parameter Types.ReactivePowerPu Q0PuShunt07;
  final parameter Types.ComplexApparentPowerPu s0PuShunt07= Complex(0, Q0PuShunt07);

  parameter Types.ReactivePowerPu Q0PuShunt09;
  final parameter Types.ComplexApparentPowerPu s0PuShunt09 = Complex(0, Q0PuShunt09);

equation
  load07.PRefPu = load07.s0Pu.re;
  load07.QRefPu = load07.s0Pu.im;
  load07.deltaP = 0;
  load07.deltaQ = 0;
  load07.switchOffSignal1.value = false;
  load07.switchOffSignal2.value = false;
  load09.PRefPu = load09.s0Pu.re;
  load09.QRefPu = load09.s0Pu.im;
  load09.deltaP = 0;
  load09.deltaQ = 0;
  load09.switchOffSignal1.value = false;
  load09.switchOffSignal2.value = false;
  shunt07.PRefPu = shunt07.s0Pu.re;
  shunt07.QRefPu = shunt07.s0Pu.im;
  shunt07.deltaP = 0;
  shunt07.deltaQ = 0;
  shunt07.switchOffSignal1.value = false;
  shunt07.switchOffSignal2.value = false;
  shunt09.PRefPu = shunt09.s0Pu.re;
  shunt09.QRefPu = shunt09.s0Pu.im;
  shunt09.deltaP = 0;
  shunt09.deltaQ = 0;
  shunt09.switchOffSignal1.value = false;
  shunt09.switchOffSignal2.value = false;
  
  connect(load09.terminal, bus09.terminal) annotation(
    Line(points = {{72, 36}, {72, 64}, {60, 64}, {60, 70}}, color = {0, 0, 255}));
  connect(shunt09.terminal, bus09.terminal) annotation(
    Line(points = {{51, 37}, {51, 64}, {60, 64}, {60, 70}}, color = {0, 0, 255}));
  connect(load07.terminal, bus07.terminal) annotation(
    Line(points = {{-72, 36}, {-72, 64}, {-60, 64}, {-60, 70}}, color = {0, 0, 255}));
  connect(shunt07.terminal, bus07.terminal) annotation(
    Line(points = {{-51, 35}, {-51, 35}, {-51, 64}, {-60, 64}, {-60, 70}}, color = {0, 0, 255}));
end NetworkWithLoads;
