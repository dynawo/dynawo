within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WPP;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model LinearCommunication "Linear communication module (IEC N°61400-27-1)"

  parameter Integer nu(min = 1) = 1 "Number of input connections" annotation(
    Dialog(connectorSizing = true),
    HideResult = true);

  //Linear communication parameters
  parameter Types.Time tLag "Communication lag time constant in s" annotation(
    Dialog(tab = "LinearCommunication"));
  parameter Types.Time tLead "Communication lead time constant in s" annotation(
    Dialog(tab = "LinearCommunication"));

  //Input variables
  Modelica.Blocks.Interfaces.RealVectorInput u[nu] "Connector of Real vector input signal" annotation(
    Placement(transformation(extent={{-120,70},{-80,-70}})));

  //Output variables
  Modelica.Blocks.Interfaces.RealVectorOutput y[nu] "Connector of Real vector input signal" annotation(
    Placement(visible = true, transformation(extent = {{80, 70}, {120, -70}}, rotation = 0), iconTransformation(extent = {{80, 70}, {120, -70}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction leadLag[nu](each a = {tLag, 1}, each b = {tLead, 1}, each initType = Modelica.Blocks.Types.Init.SteadyState, u_start = X0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Initial parameter
  parameter Types.ActivePowerPu X0Pu[nu] "Initial vector of parameters" annotation(
    Dialog(tab = "Operating point"));

equation
  for i in 1:nu loop
    connect(u[i], leadLag[i].u);
    connect(leadLag[i].y, y[i]);
  end for;

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {72, -144}, extent = {{-112, 184}, {-32, 46}}, textString = "Module"), Text(origin = {28, -30}, extent = {{-112, 184}, {56, -66}}, textString = "Communication")}));
end LinearCommunication;
