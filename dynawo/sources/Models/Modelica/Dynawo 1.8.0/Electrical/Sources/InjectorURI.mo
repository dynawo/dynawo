within Dynawo.Electrical.Sources;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model InjectorURI "Injector controlled by real (R) part and imaginary (I) part voltage components urPu and uiPu"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(extent = {{0, -26}, {0, -26}}, rotation = 0), iconTransformation(origin = {115, -3}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  // Input variables
  Modelica.Blocks.Interfaces.RealInput urPu(start = u0Pu.re) "Voltage real part in pu (base UNom)" annotation(
    Placement(visible = true, transformation(extent = {{10, -25}, {10, -25}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uiPu(start = u0Pu.im) "Voltage imaginary part in pu (base UNom)" annotation(
    Placement(visible = true, transformation(extent = {{0, -25}, {0, -25}}, rotation = 0), iconTransformation(origin = {-111, -39}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput PInjPu(start = P0Pu) "Injected active power in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(extent = {{10, -25}, {10, -25}}, rotation = 0), iconTransformation(origin = {110, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QInjPu(start = Q0Pu) "Injected reactive power in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(extent = {{10, -25}, {10, -25}}, rotation = 0), iconTransformation(origin = {110, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ActivePowerPu P0Pu = -ComplexMath.real(u0Pu*ComplexMath.conj(i0Pu)) "Start value of active power in pu (base SnRef) (receptor convention)";
  final parameter Types.ReactivePowerPu Q0Pu = -ComplexMath.imag(u0Pu*ComplexMath.conj(i0Pu)) "Start value of reactive power in pu (base SnRef) (receptor convention)";

equation
  terminal.V.re = urPu;
  terminal.V.im = uiPu;

  PInjPu = -ComplexMath.real(terminal.V * ComplexMath.conj(terminal.i));
  QInjPu = -ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i));

  annotation(preferredView = "text",
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-33, 34}, extent = {{-59, 22}, {129, -88}}, textString = "Injector"), Text(origin = {-104, 52}, extent = {{-32, 12}, {4, -4}}, textString = "urPu"), Text(origin = {-104, -26}, extent = {{-32, 12}, {4, -4}}, textString = "uiPu"), Text(origin = {168, 4}, extent = {{-32, 12}, {4, -4}}, textString = "ACPower"), Text(origin = {117, 81}, extent = {{-17, 13}, {17, -13}}, textString = "PInjPu"), Text(origin = {117, -45}, extent = {{-17, 13}, {17, -13}}, textString = "QInjPu")}));
end InjectorURI;
