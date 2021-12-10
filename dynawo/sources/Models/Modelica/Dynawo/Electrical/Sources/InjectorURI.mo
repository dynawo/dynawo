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

model InjectorURI "Injector controlled by real (R) part and imaginary (I) part voltage components urPu and uiPu"

  import Modelica;
  import Modelica.ComplexMath;

  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends SwitchOff.SwitchOffInjector;

  // Terminal connection
  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the injector to the grid"  annotation(
    Placement(visible = true, transformation(extent = {{0, -26}, {0, -26}}, rotation = 0), iconTransformation(origin = {115, 47}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.PerUnit RSourcePu "Source resistance in p.u (typically set to zero, typical: 0..0.01)";
  parameter Types.PerUnit XSourcePu "Source reactance in p.u (typical: 0.05..0.2)";

  // Inputs: real-imaginary part voltage p.u. variables (base UNom)
  Modelica.Blocks.Interfaces.RealInput urPu (start = u0Pu.re) "Real part voltage (pu base Unom)" annotation(
    Placement(visible = true, transformation(extent = {{10, -26}, {10, -26}}, rotation = 0), iconTransformation(origin = {-106, 38}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uiPu (start = u0Pu.im) "Imaginary part voltage (pu base Unom)" annotation(
    Placement(visible = true, transformation(extent = {{0, -26}, {0, -26}}, rotation = 0), iconTransformation(origin = {-107, -43}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  // Outputs:
  Modelica.Blocks.Interfaces.RealOutput UPu (start = U0Pu) "Magnitude voltage at inverter terminal (pu base UNom)" annotation(
    Placement(visible = true, transformation(extent = {{0, -26}, {0, -26}}, rotation = 0), iconTransformation(origin = {115, -79}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QInjPuSn (start = -Q0Pu*SystemBase.SnRef/SNom) "Injected reactive power (pu base SNom)" annotation(
    Placement(visible = true, transformation(extent = {{0, -26}, {0, -26}}, rotation = 0), iconTransformation(origin = {115, 6}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PInjPuSn (start = -P0Pu*SystemBase.SnRef/SNom) "Injected active power (pu base SNom)" annotation(
    Placement(visible = true, transformation(extent = {{10, -26}, {10, -26}}, rotation = 0), iconTransformation(origin = {115, -39}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QInjPu (start = -Q0Pu) "Injected reactive power (pu base SnRef)";
  Modelica.Blocks.Interfaces.RealOutput PInjPu (start = -P0Pu) "Injected active power (pu base SnRef)";
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uPu (re(start = u0Pu.re), im(start=u0Pu.im)) "Complex inverter terminal voltage, used as complex conector instead of terminal connector, terminal only used for physical connection" annotation(
    Placement(visible = true, transformation(extent = {{0, -26}, {0, -26}}, rotation = 0), iconTransformation(origin = {115, 82}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

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

equation

  UPhase = ComplexMath.arg(terminal.V);
  UPu = ComplexMath.'abs'(terminal.V);
  uPu = terminal.V + terminal.i * SystemBase.SnRef / SNom * Complex(RSourcePu, XSourcePu);
  terminal.V.re = urPu;
  terminal.V.im = uiPu;

  if running.value then
    // Active and reactive power in generator convention and SNom base from terminal in receptor base in SnRef
    QInjPuSn = QInjPu * SystemBase.SnRef/SNom;
    PInjPuSn = PInjPu * SystemBase.SnRef/SNom;
    //QInjPu = -1 * ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i));
    //PInjPu = -1 * ComplexMath.real(terminal.V * ComplexMath.conj(terminal.i));

    QInjPu = -1 * ComplexMath.imag(uPu * ComplexMath.conj(terminal.i)) * SystemBase.SnRef / SNom;
    PInjPu = -1 * ComplexMath.real(uPu * ComplexMath.conj(terminal.i)) * SystemBase.SnRef / SNom;
  else
    QInjPuSn = 0;
    PInjPuSn = 0;
    QInjPu = 0;
    PInjPu = 0;
  end if;

annotation(preferredView = "text",
Documentation(info="<html> <p> This block calculates the P,Q,u,i values for terminal connection based on real and imaginary parts of voltage setpoints from generator control  </p> </html>"),
    Diagram,
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-33, 34}, extent = {{-59, 22}, {129, -88}}, textString = "Injector"), Text(origin = {-134, 64}, extent = {{-32, 12}, {4, -4}}, textString = "urPu"), Text(origin = {-134, -14}, extent = {{-32, 12}, {4, -4}}, textString = "uiPu"), Text(origin = {168, 44}, extent = {{-32, 12}, {4, -4}}, textString = "ACPower"), Text(origin = {164, -80}, extent = {{-32, 12}, {4, -4}}, textString = "UPu"), Text(origin = {170, -40}, extent = {{-32, 12}, {24, -8}}, textString = "PInjPuSn"), Text(origin = {166, 12}, extent = {{-32, 12}, {24, -20}}, textString = "QInjPuSn"), Text(origin = {168, 76}, extent = {{-32, 12}, {4, -4}}, textString = "uPu")}));


end InjectorURI;
