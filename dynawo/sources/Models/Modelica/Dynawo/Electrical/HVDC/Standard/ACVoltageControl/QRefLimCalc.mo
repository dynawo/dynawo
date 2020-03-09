within Dynawo.Electrical.HVDC.Standard.ACVoltageControl;

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

model QRefLimCalc

  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.ReactivePowerPu QMinOP;
  parameter Types.ReactivePowerPu QMaxOP;

  Modelica.Blocks.Interfaces.RealInput qRefUPu(start = Q0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qRefQPu(start = Q0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qMaxP(start = QMaxOP) annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qMinP(start = QMinOP) annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qMaxU(start = QMaxOP) annotation(
    Placement(visible = true, transformation(origin = {-120, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qMinU(start = QMinOP) annotation(
    Placement(visible = true, transformation(origin = {-120, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput modeU(start = true) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput qRefLimPu(start = Q0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = QMaxOP, uMin = QMinOP)  annotation(
    Placement(visible = true, transformation(origin = {-41, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {-4, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

parameter Types.ReactivePowerPu Q0Pu;

equation
  connect(modeU, switch1.u2) annotation(
    Line(points = {{-120, 0}, {-84, 0}, {-84, 0}, {-82, 0}}, color = {255, 0, 255}));
  connect(qRefUPu, switch1.u1) annotation(
    Line(points = {{-120, 30}, {-90, 30}, {-90, 8}, {-82, 8}}, color = {0, 0, 127}));
  connect(qRefQPu, switch1.u3) annotation(
    Line(points = {{-120, -30}, {-90, -30}, {-90, -8}, {-82, -8}}, color = {0, 0, 127}));
  connect(switch1.y, limiter.u) annotation(
    Line(points = {{-59, 0}, {-54, 0}, {-54, 0}, {-53, 0}}, color = {0, 0, 127}));
  connect(qMaxP, variableLimiter.limit1) annotation(
    Line(points = {{-16, 8}, {-20, 8}, {-20, 60}, {-120, 60}}, color = {0, 0, 127}));
  connect(variableLimiter.limit1, qMaxP) annotation(
    Line(points = {{-16, 8}, {-20, 8}, {-20, 60}, {-120, 60}}, color = {0, 0, 127}));
  connect(qMinP, variableLimiter.limit2) annotation(
    Line(points = {{-120, -60}, {-19, -60}, {-19, -8}, {-16, -8}, {-16, -8}}, color = {0, 0, 127}));
  connect(variableLimiter.y, variableLimiter1.u) annotation(
    Line(points = {{7, 0}, {17, 0}, {17, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(qMaxU, variableLimiter1.limit1) annotation(
    Line(points = {{-120, 90}, {12, 90}, {12, 8}, {18, 8}, {18, 8}}, color = {0, 0, 127}));
  connect(qMinU, variableLimiter1.limit2) annotation(
    Line(points = {{-120, -90}, {12, -90}, {12, -8}, {18, -8}, {18, -8}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, qRefLimPu) annotation(
    Line(points = {{41, 0}, {101, 0}, {101, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, variableLimiter1.u) annotation(
    Line(points = {{7, 0}, {18, 0}, {18, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(limiter.y, variableLimiter.u) annotation(
    Line(points = {{-30, 0}, {-17, 0}, {-17, 0}, {-16, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));

end QRefLimCalc;
