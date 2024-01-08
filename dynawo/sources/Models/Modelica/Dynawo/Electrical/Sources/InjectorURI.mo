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
    Placement(visible = true, transformation(extent = {{0, -26}, {0, -26}}, rotation = 0), iconTransformation(origin = {115, -1}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput urPu(start = u0Pu.re) "Voltage real part in pu (base UNom)" annotation(
    Placement(visible = true, transformation(extent = {{10, -25}, {10, -25}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uiPu(start = u0Pu.im) "Voltage imaginary part in pu (base UNom)" annotation(
    Placement(visible = true, transformation(extent = {{0, -25}, {0, -25}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)";

equation
  terminal.V.re = urPu;
  terminal.V.im = uiPu;

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-33, 34}, extent = {{-59, 22}, {129, -88}}, textString = "Injector"), Text(origin = {-104, 72}, extent = {{-32, 12}, {4, -4}}, textString = "urPu"), Text(origin = {-104, -80}, extent = {{-32, 12}, {4, -4}}, textString = "uiPu"), Text(origin = {168, 4}, extent = {{-32, 12}, {4, -4}}, textString = "terminal")}));
end InjectorURI;
