within Dynawo.Electrical.Sources;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model InjectorBG "Injector controlled by a the susceptance B and the conductance G"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {115, -61}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  parameter Types.ApparentPowerModule SNom "Injector nominal apparent power in MVA";

  Modelica.Blocks.Interfaces.RealInput GPu(start = G0Pu) "Conductance in pu (base SNom)" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {-115, -41}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput BPu(start = B0Pu) "Susceptance in pu (base SNom)" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {-115, 61}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UPu(start = U0Pu) "Voltage amplitude in pu (base UNom)" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {115, 81}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PInjPu(start = -P0Pu) "Active power in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {115, 39}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QInjPu(start = -Q0Pu) "Reactive power in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {115, -5}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of apparent power at injector terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit G0Pu "Start value of conductance in pu (base SNom)";
  parameter Types.PerUnit B0Pu "Start value of susceptance in pu (base SNom)";

protected
  Types.PerUnit GPuSnRef = GPu * SNom / SystemBase.SnRef "Conductance in pu (base SnRef)";
  Types.PerUnit BPuSnRef = BPu * SNom / SystemBase.SnRef "Susceptance in pu (base SnRef)";
  Types.ComplexAdmittancePu YPuSnRef(re = GPuSnRef, im = BPuSnRef) "Admittance in pu (base SnRef)";

equation
  UPu = ComplexMath.abs(terminal.V);
  PInjPu = -ComplexMath.real(terminal.V * ComplexMath.conj(terminal.i));
  QInjPu = -ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i));

  if running.value then
    terminal.i = terminal.V * YPuSnRef;
  else
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text",
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-33, 34}, extent = {{-59, 22}, {129, -88}}, textString = "Injector"), Text(origin = {-148, 82}, extent = {{-32, 12}, {4, -4}}, textString = "BPu"), Text(origin = {-148, -18}, extent = {{-32, 12}, {4, -4}}, textString = "GPu"), Text(origin = {160, -38}, extent = {{-32, 12}, {4, -4}}, textString = "ACPower"), Text(origin = {158, 92}, extent = {{-32, 12}, {4, -4}}, textString = "UPu"), Text(origin = {158, 52}, extent = {{-32, 12}, {4, -4}}, textString = "PInjPu"), Text(origin = {158, 10}, extent = {{-32, 12}, {4, -4}}, textString = "QInjPu")}));
end InjectorBG;
