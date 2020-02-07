within Dynawo.Electrical.Injectors;

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

  import Modelica.Blocks;
  import Modelica.ComplexBlocks;
  import Modelica.ComplexMath;
  import Modelica.SIunits;

  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;

  // Terminal connection
  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(origin = {101, -61}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {101, -59}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Inputs: d-q axis p.u. variables (base UNom, SNom)
  Blocks.Interfaces.RealInput idPu (start = Id0Pu) "Injected d-axis current (pu base SNom)" annotation(
  Placement(visible = true, transformation(origin = {-108, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-97,-61}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Blocks.Interfaces.RealInput iqPu (start = Iq0Pu) "Injected q-axis current (pu base SNom)" annotation(
  Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-97, -1}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  // Outputs:
  Blocks.Interfaces.RealOutput UPu (start = U0Pu) "Magnitude voltage at inverter terminal (pu base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 89}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin =  {102, 80}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Interfaces.RealOutput QInjPu (start = -Q0Pu) "Injected reactive power (pu base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 21}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin =  {102, 20}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Interfaces.RealOutput PInjPu (start = -P0Pu) "Injected active power (pu base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -19}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin =  {102, -20}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  ComplexBlocks.Interfaces.ComplexOutput uPu (re(start = u0Pu.re), im(start=u0Pu.im)) "Complex inverter terminal voltage, used as complex conector instead of terminal connector, terminal only used for physical connection" annotation(
    Placement(visible = true, transformation(origin = {110, 59}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin =  {102, 50}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));

  // Internal variables:
  Types.Angle UPhase (start = UPhase0) "Rotor angle: angle between machine rotor frame and port phasor frame";

protected

  parameter Types.VoltageModulePu U0Pu  "Start value of voltage amplitude at injector terminal in p.u (base UNom)";
  parameter Types.Angle UPhase0  "Start value of voltage angle at injector terminal (in rad)";
  parameter Types.ActivePowerPu P0Pu  "Start value of active power in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu  "Start value of reactive power in p.u (base SnRef) (receptor convention)";

  parameter Types.ComplexVoltagePu u0Pu  "Start value of complex voltage at injector terminal in p.u (base UNom)";
  parameter Types.ComplexApparentPowerPu s0Pu  "Start value of apparent power at injector terminal in p.u (base SnRef) (receptor convention)";
  parameter Types.ComplexCurrentPu i0Pu  "Start value of complex current at injector terminal in p.u (base UNom, SnRef) (receptor convention)";

  parameter Types.CurrentModulePu Id0Pu "Start value of id in p.u (base SNom)";
  parameter Types.CurrentModulePu Iq0Pu "Start value of iq in p.u (base SNom)";

equation

  UPhase = ComplexMath.arg(terminal.V);
  UPu = ComplexMath.'abs'(terminal.V);
  uPu = terminal.V;

  // Park's transformations dq-currents in injector convention, -> receptor convention for terminal
  terminal.i.re = -1 * (cos(UPhase) * idPu - sin(UPhase) * iqPu) * (SNom/SystemBase.SnRef);
  terminal.i.im = -1 * (sin(UPhase) * idPu + cos(UPhase) * iqPu) * (SNom/SystemBase.SnRef);

  // Active and reactive power in generator convention and SNom base from terminal in receptor base in SnRef
  QInjPu = -1 * ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i))*SystemBase.SnRef/SNom; //
  PInjPu = -1 * ComplexMath.real(terminal.V * ComplexMath.conj(terminal.i))*SystemBase.SnRef/SNom; //

annotation(preferredView = "text",
Documentation(info="<html> <p> This block calculates the current references for terminal connection based on d-q-frame setpoints from generator control  </p> </html>"),Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {43, -12}, extent = {{-83, 72}, {-9, -44}}, textString = "Inj")}));

end InjectorIDQ;
