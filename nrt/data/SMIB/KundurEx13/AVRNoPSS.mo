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

model AVRNoPSS "Simple Proportional Voltage Regulator"
  import Modelica.Blocks;
  import Modelica.SIunits;
  import Dynawo.Connectors;

  // AVR parameters
  parameter SIunits.PerUnit KA "Exciter gain";
  parameter SIunits.Time TR "Transducer time constant";
  parameter SIunits.PerUnit EfdMin "Minimum excitation voltage";
  parameter SIunits.PerUnit EfdMax "Maximum excitation voltage";

  // AVR
  Blocks.Sources.Constant URefPu(k = URef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-58, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput UStatorPu(start = UStator0Pu) annotation(
    Placement(visible = true, transformation(origin = {-104, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-56, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Continuous.FirstOrder Transducer(T = TR, k = 1, y_start = UStator0Pu) annotation(
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add error(k1 = 1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain Exciter(k = KA) annotation(
    Placement(visible = true, transformation(origin = {36, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter LimiterAVR(limitsAtInit = true, uMax = EfdMax, uMin = EfdMin) annotation(
    Placement(visible = true, transformation(origin = {72, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealOutput efdPu(start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ImPin efdPuPin(value(start = Efd0Pu)) "Exciter field voltage Pin";

protected
  parameter SIunits.PerUnit UStator0Pu "Initial stator voltage";
  parameter SIunits.PerUnit Efd0Pu "Initial excitation voltage";
  final parameter SIunits.PerUnit URef0Pu = Efd0Pu / KA + UStator0Pu "Initial reference stator voltage";

equation
  connect(URefPu.y, error.u1) annotation(
    Line(points = {{-46, 38}, {-28, 38}, {-28, 6}, {-12, 6}}, color = {0, 0, 127}));
  connect(LimiterAVR.y, efdPu) annotation(
    Line(points = {{83, 0}, {102, 0}}, color = {0, 0, 127}));
  connect(Exciter.y, LimiterAVR.u) annotation(
    Line(points = {{47, 0}, {60, 0}}, color = {0, 0, 127}));
  connect(error.y, Exciter.u) annotation(
    Line(points = {{11, 0}, {24, 0}}, color = {0, 0, 127}));
  connect(Transducer.y, error.u2) annotation(
    Line(points = {{-47, 0}, {-31, 0}, {-31, 0}, {-15, 0}, {-15, 0}, {-13, 0}}, color = {0, 0, 127}));
  connect(UStatorPu, Transducer.u) annotation(
    Line(points = {{-104, 0}, {-72, 0}, {-72, 0}, {-71, 0}, {-71, 0}, {-70.5, 0}, {-70.5, 0}, {-70, 0}}, color = {0, 0, 127}));
  connect(efdPuPin.value, efdPu);
  annotation(
    uses(Modelica(version = "3.2.2")),
    Diagram);
end AVRNoPSS;
