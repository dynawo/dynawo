within Dynawo.Electrical.PEIR.Plant.Simplified.BaseControls;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model InjectorInterface "Injector interface"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput PInjPu(start = PInj0Pu) "Active power in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QInjPu(start = QInj0Pu) "Active power in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));

  // Terminal connection
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(transformation(extent = {{0, 0}, {0, 0}}), iconTransformation(origin = {100, 2}, extent = {{-10, -10}, {10, 10}})));

  Types.VoltageModulePu UPu(start = U0Pu) "Magnitude voltage at inverter terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {115, 81}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  // Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.PerUnit QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)";

equation
  if running.value then
    UPu = ComplexMath.'abs'(terminal.V);
    QInjPu = -ComplexMath.imag(terminal.V*ComplexMath.conj(terminal.i))*SystemBase.SnRef/SNom;
    PInjPu = -ComplexMath.real(terminal.V*ComplexMath.conj(terminal.i))*SystemBase.SnRef/SNom;
  else
    UPu = 0;
    terminal.i = Complex(0, 0);
  end if;

  annotation(
    Diagram,
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 11}, extent = {{-41, 19}, {97, -41}}, textString = "Injector interface")}),
  Documentation(info = "<html><head></head><body>Interface between active and reactive power real variables and AC Power connector&nbsp;</body></html>"));
end InjectorInterface;
