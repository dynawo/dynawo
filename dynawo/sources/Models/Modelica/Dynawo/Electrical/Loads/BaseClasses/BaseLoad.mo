within Dynawo.Electrical.Loads.BaseClasses;

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

partial model BaseLoad "Base model for loads"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffLoad;

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the load to the grid" annotation(
    Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // in order to change the load set-point, connect an event to PRefPu or QRefPu
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = s0Pu.re) "Active power request" annotation(
    Placement(visible = true, transformation(origin = {-50, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-61, -85}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = s0Pu.im) "Reactive power request" annotation(
    Placement(visible = true, transformation(origin = {50, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {60, -84}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput deltaP(start = 0) "Delta to apply on PRef in %" annotation(
    Placement(visible = true, transformation(origin = {-75, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-61, -85}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput deltaQ(start = 0) "Delta to apply on QRef in %" annotation(
    Placement(visible = true, transformation(origin = {75, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {60, -84}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));

  Dynawo.Connectors.ImPin UPu(value(start = ComplexMath.'abs'(u0Pu))) "Voltage amplitude at load terminal in pu (base UNom)";

  Types.ActivePowerPu PPu(start = s0Pu.re) "Active power at load terminal in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu QPu(start = s0Pu.im) "Reactive power at load terminal in pu (base SnRef) (receptor convention)";
  Types.ComplexApparentPowerPu SPu(re(start = s0Pu.re), im(start = s0Pu.im)) "Apparent power at load terminal in pu (base SnRef) (receptor convention)";
  Types.Angle UPhase(start = ComplexMath.arg(u0Pu)) "Voltage angle at terminal in rad";

  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at load terminal in pu (base UNom)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of apparent power at load terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";

equation
  SPu = Complex(PPu, QPu);
  SPu = terminal.V * ComplexMath.conj(terminal.i);

  if running.value then
    UPu.value = ComplexMath.'abs'(terminal.V);
    UPhase = ComplexMath.arg(terminal.V);
  else
    UPu.value = 0;
    UPhase = 0;
  end if;

  annotation(
    preferredView = "text");
end BaseLoad;
