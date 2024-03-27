within Dynawo.Electrical.Controls.IEC.BaseControls.Auxiliaries;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model UfMeasurement
  //Uf measurement parameters
  parameter Types.AngularVelocityPu DfMaxPu "Maximum frequency ramp rate in pu/s (base omegaNom)" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tfFilt "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));

  //Initial parameters
  parameter Dynawo.Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Dynawo.Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Dynawo.Electrical.SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-142, -790}, extent = {{-42, -42}, {42, 42}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uWTPu(re(start = u0Pu.re), im(start = u0Pu.im)) annotation(
    Placement(visible = true, transformation(origin = {-120, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-142, 814}, extent = {{-42, -42}, {42, 42}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaGenPu(start = Dynawo.Electrical.SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {160, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {142, -790}, extent = {{-42, -42}, {42, 42}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UWTPu(start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {160, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {143, 811}, extent = {{-43, -43}, {43, 43}}, rotation = 0)));

  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToPolar annotation(
    Placement(visible = true, transformation(origin = {-72, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(k = 1 / (2 * Modelica.Constants.pi * Electrical.SystemBase.fNom), x_start = UPhase0, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-18, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = DfMaxPu, uMin = -DfMaxPu) annotation(
    Placement(visible = true, transformation(origin = {18, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {134, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tfFilt, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {56, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tUFilt, y_start = U0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-18, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(uWTPu, complexToPolar.u) annotation(
    Line(points = {{-120, 48}, {-102, 48}, {-102, 46}, {-84, 46}}, color = {85, 170, 255}));
  connect(derivative.y, limiter.u) annotation(
    Line(points = {{-7, 40}, {6, 40}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u2) annotation(
    Line(points = {{-120, 0}, {116, 0}, {116, 28}, {122, 28}}, color = {0, 0, 127}));
  connect(add.y, omegaGenPu) annotation(
    Line(points = {{146, 34}, {160, 34}}, color = {0, 0, 127}));
  connect(complexToPolar.phi, derivative.u) annotation(
    Line(points = {{-60, 40}, {-30, 40}}, color = {0, 0, 127}));
  connect(limiter.y, firstOrder.u) annotation(
    Line(points = {{29, 40}, {43, 40}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u1) annotation(
    Line(points = {{67, 40}, {122, 40}}, color = {0, 0, 127}));
  connect(firstOrder1.y, UWTPu) annotation(
    Line(points = {{-6, 74}, {160, 74}}, color = {0, 0, 127}));
  connect(complexToPolar.len, firstOrder1.u) annotation(
    Line(points = {{-60, 52}, {-40, 52}, {-40, 74}, {-30, 74}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-100, -100}, {150, 100}})),
    Icon(coordinateSystem(extent = {{-100, -900}, {100, 900}}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 900}, {100, -900}}), Text(origin = {-1, 24}, rotation = -90, extent = {{-441, 82}, {441, -82}}, textString = "Uf measurement")}));
end UfMeasurement;
