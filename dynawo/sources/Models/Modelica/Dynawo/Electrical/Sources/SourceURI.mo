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


model SourceURI
  import Modelica.Blocks;
  import Modelica.ComplexBlocks;

  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.PerUnit Rsource "Source resistance (typically set to zero, typical: 0..0.01)";
  parameter Types.PerUnit Xsource "Source reactance (typical: 0.05..0.2)";

  // Terminal connection
  Connectors.ACPower terminal(V(re(start = uSource0Pu.re), im(start = uSource0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im)))annotation(
    Placement(visible = true, transformation(origin = {101, -61}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {101, -59}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  // Inputs: real imaginary p.u. variables
  Blocks.Interfaces.RealInput urSourcePu(start = UrSource0Pu) "Real part inner voltage setpoint" annotation(
  Placement(visible = true, transformation(origin = {-108, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-97, 1}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Blocks.Interfaces.RealInput uiSourcePu(start = UiSource0Pu) "Imaginary part inner voltage setpoint" annotation(
  Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-97, -59}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  // Outputs, measurement signals, voltage behind impedance:
  Blocks.Interfaces.RealOutput UPu(start = U0Pu) "Magnitude voltage at inverter terminal (pu base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 91}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin =  {102, 80}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Interfaces.RealOutput QInjPu(start = -Q0Pu) "Reactive power at inverter terminal, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {110, 21}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin =  {102, 20}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Interfaces.RealOutput PInjPu(start = -P0Pu) "Active power at inverter terminal, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {110, -19}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin =  {102, -20}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  ComplexBlocks.Interfaces.ComplexOutput uPu(re(start = u0Pu.re), im(start=u0Pu.im)) "complex inverter terminal voltage" annotation(
    Placement(visible = true, transformation(origin = {110, 59}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin =  {102, 50}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu U0Pu  "Start value of voltage amplitude at inverter terminal in p.u";
  parameter Types.ActivePowerPu P0Pu  "Start value of active power at inverter terminal in p.u (base SnRef, receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu  "Start value of reactive power at inverter terminal in p.u (base SnRef, receptor convention)";

  parameter Types.ComplexVoltagePu u0Pu  "Start value of complex voltage at inverter terminal in p.u";
  parameter Types.ComplexVoltagePu uSource0Pu  "Start value of complex voltage at injector terminal (inner source voltage) in p.u";

  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at inverter terminal in p.u. (base SnRef, receptor convention)";

  parameter Types.VoltageModulePu UrSource0Pu "Start value of setpoint for ur in p.u";
  parameter Types.VoltageModulePu UiSource0Pu "Start value of setpoint for ui in p.u";

equation

  // Measurement values behind impedance (add current*Zsource in receptor convention)
  UPu = ComplexMath.'abs'(uPu);
  uPu = terminal.V + terminal.i * SystemBase.SnRef / SNom * Complex(Rsource,Xsource);

  // Setpoints innver voltage source
  terminal.V.re = urSourcePu;
  terminal.V.im = uiSourcePu;

  // Active and reactive power injector convention and SNom base
  QInjPu = -1 * ComplexMath.imag(uPu * ComplexMath.conj(terminal.i)) * SystemBase.SnRef / SNom;
  PInjPu = -1 * ComplexMath.real(uPu * ComplexMath.conj(terminal.i)) * SystemBase.SnRef / SNom;

annotation(
Documentation(info="<html> <p> This block connects the real and imaginary voltage setpoints from the inverter control to the inner voltage source and delivers measurement values after the source impedance. Source impedance element needs to be placed between injector and inverter terminal, source impedance values need to be equal in injector and impedance element!</p> </html>"),Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {43, -12}, extent = {{-83, 72}, {-9, -44}}, textString = "Inj")}));

end SourceURI;
