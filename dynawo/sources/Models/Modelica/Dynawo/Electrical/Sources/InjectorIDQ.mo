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

model InjectorIDQ "Injector controlled by d and q current components idPu and iqPu"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Terminal connection
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {115, -79}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  // Inputs: d-q axis pu variables (base UNom, SNom) and rotor angle
  Modelica.Blocks.Interfaces.RealInput idPu(start = Id0Pu) "Injected d-axis current in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {-115, 61}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPu(start = Iq0Pu) "Injected q-axis current in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {-115, -41}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPhase(start = UPhase0) "Rotor angle: angle between machine rotor frame and port phasor frame in rad" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {0, 115}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));

  // Outputs:
  Modelica.Blocks.Interfaces.RealOutput PInjPu(start = -P0Pu) "Injected active power in pu (base SnRef) (generator convention)";
  Modelica.Blocks.Interfaces.RealOutput PInjPuSn(start = -P0Pu * SystemBase.SnRef / SNom) "Injected active power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {115, 43}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QInjPu(start = -Q0Pu) "Injected reactive power in pu (base SnRef) (generator convention)";
  Modelica.Blocks.Interfaces.RealOutput QInjPuSn(start = -Q0Pu * SystemBase.SnRef / SNom) "Injected reactive power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {115, 5}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UPu(start = U0Pu) "Magnitude voltage at inverter terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {115, 81}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex inverter terminal voltage, used as complex connector instead of terminal connector, terminal only used for physical connection, in pu (base UNom)" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {115, -33}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit Id0Pu "Start value of idPu in pu (base SNom, UNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of iqPu in pu (base SNom, UNom) (generator convention)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of apparent power at injector terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at injector terminal in rad";

equation
  uPu = terminal.V;

  // Active and reactive power in generator convention and SNom base from terminal in receptor base in SnRef
  QInjPuSn = -ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i)) * SystemBase.SnRef / SNom;
  PInjPuSn = -ComplexMath.real(terminal.V * ComplexMath.conj(terminal.i)) * SystemBase.SnRef / SNom;
  QInjPu = -ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i));
  PInjPu = -ComplexMath.real(terminal.V * ComplexMath.conj(terminal.i));

  if running.value then
    UPu = ComplexMath.'abs'(terminal.V);
    // Park's transformations dq-currents in generator convention, -> receptor convention for terminal
    terminal.i.re = -(cos(UPhase) * idPu - sin(UPhase) * iqPu) * SNom / SystemBase.SnRef;
    terminal.i.im = -(sin(UPhase) * idPu + cos(UPhase) * iqPu) * SNom / SystemBase.SnRef;
  else
    UPu = 0;
    terminal.i = Complex(0,0);
  end if;

  annotation(
    preferredView = "text",
    Documentation(info="<html> <p> This block calculates the current references for terminal connection based on d-q-frame setpoints from generator control  </p> </html>"),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-33, 34}, extent = {{-59, 22}, {129, -88}}, textString = "Injector"), Text(origin = {-148, 82}, extent = {{-32, 12}, {4, -4}}, textString = "idPu"), Text(origin = {-148, -18}, extent = {{-32, 12}, {4, -4}}, textString = "iqPu"), Text(origin = {170, -70}, extent = {{-32, 12}, {4, -4}}, textString = "ACPower"), Text(origin = {158, 92}, extent = {{-32, 12}, {4, -4}}, textString = "UPu"), Text(origin = {158, 54}, extent = {{-32, 12}, {24, -8}}, textString = "PInjPuSn"), Text(origin = {158, 24}, extent = {{-32, 12}, {24, -20}}, textString = "QInjPuSn"), Text(origin = {164, -20}, extent = {{-32, 12}, {4, -4}}, textString = "uPu"), Text(origin = {58, 132}, extent = {{-32, 12}, {4, -4}}, textString = "UPhase")}));
end InjectorIDQ;
