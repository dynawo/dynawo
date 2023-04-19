within Dynawo.Electrical.Buses;

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

model InfiniteBusWithImpedance "Infinite bus connected to an impedance"
  extends AdditionalIcons.Bus;

  //Impedance parameters
  parameter Types.PerUnit RPu "Resistance in pu (base UNom, SnRef)";
  parameter Types.PerUnit XPu "Reactance in pu (base UNom, SnRef)";

  //Interface
  Dynawo.Connectors.ACPower terminal(
    V(re(start = uTerminal0Pu.re), im(start = uTerminal0Pu.im)),
    i(re(start = iTerminal0Pu.re), im(start = iTerminal0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = UPhaseBus0, UPu = UBus0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line impedance(BPu = 0, GPu = 0, RPu = RPu, XPu = XPu) annotation(
    Placement(visible = true, transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  //Initial parameters
  parameter Types.ComplexCurrentPu iTerminal0Pu "Initial complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.VoltageModulePu UBus0Pu "Infinite bus constant voltage module in pu (base UNom)";
  parameter Types.Angle UPhaseBus0 "Infinite bus constant voltage angle in rad";
  parameter Types.ComplexVoltagePu uTerminal0Pu "Initial complex voltage at terminal in pu (base UNom)";

equation
  impedance.switchOffSignal1.value = false;
  impedance.switchOffSignal2.value = false;
  connect(infiniteBus.terminal, impedance.terminal2) annotation(
    Line(points = {{0, -80}, {0, -40}}, color = {0, 0, 255}));
  connect(impedance.terminal1, terminal) annotation(
    Line(points = {{0, -20}, {0, 98}}, color = {0, 0, 255}));

  annotation(
    preferredView = "text");
end InfiniteBusWithImpedance;
