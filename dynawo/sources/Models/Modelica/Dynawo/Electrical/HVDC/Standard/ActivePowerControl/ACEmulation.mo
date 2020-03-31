within Dynawo.Electrical.HVDC.Standard.ActivePowerControl;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model ACEmulation "AC Emulation for HVDC"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends Parameters.Params_ACEmulation;

  Modelica.ComplexBlocks.Interfaces.ComplexInput u1Pu(re(start = u10Pu.re), im(start = u10Pu.im)) "Complex voltage at terminal 1 in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput u2Pu(re(start = u20Pu.re), im(start = u20Pu.im)) "Complex voltage at terminal 2 in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefSetPu(start = PRefSet0Pu) "Raw reference active power in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput PRefPu(start = P0Pu) "Reference active power in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToPolar annotation(
    Placement(visible = true, transformation(origin = {-76, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToPolar1 annotation(
    Placement(visible = true, transformation(origin = {-76, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFilter)  annotation(
    Placement(visible = true, transformation(origin = {-36, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tFilter)  annotation(
    Placement(visible = true, transformation(origin = {-36, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {14, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = KACEmulation)  annotation(
    Placement(visible = true, transformation(origin = {43, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.ComplexVoltagePu u10Pu;
  parameter Types.ComplexVoltagePu u20Pu;
  parameter Types.ActivePowerPu P0Pu;
  parameter Types.ActivePowerPu PRefSet0Pu;

equation

  connect(u1Pu, complexToPolar.u) annotation(
    Line(points = {{-110, 56}, {-88, 56}}, color = {85, 170, 255}));
  connect(u2Pu, complexToPolar1.u) annotation(
    Line(points = {{-110, -14}, {-88, -14}}, color = {85, 170, 255}));
  connect(complexToPolar.phi, firstOrder.u) annotation(
    Line(points = {{-64, 50}, {-48, 50}}, color = {0, 0, 127}));
  connect(complexToPolar1.phi, firstOrder1.u) annotation(
    Line(points = {{-64, -20}, {-48, -20}}, color = {0, 0, 127}));
  connect(firstOrder.y, feedback.u1) annotation(
    Line(points = {{-25, 50}, {0, 50}, {0, 6}, {6, 6}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback.u2) annotation(
    Line(points = {{-25, -20}, {14, -20}, {14, -2}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{23, 6}, {31, 6}}, color = {0, 0, 127}));
  connect(gain.y, add.u1) annotation(
    Line(points = {{54, 6}, {66, 6}, {66, 6}, {68, 6}}, color = {0, 0, 127}));
  connect(PRefSetPu, add.u2) annotation(
    Line(points = {{-110, -70}, {62, -70}, {62, -6}, {68, -6}}, color = {0, 0, 127}));
  connect(add.y, PRefPu) annotation(
    Line(points = {{91, 0}, {101, 0}, {101, 0}, {110, 0}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));

end ACEmulation;
