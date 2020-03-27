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

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.ReactivePowerPu QMinOPPu;
  parameter Types.ReactivePowerPu QMaxOPPu;
  parameter Real tableQMaxPPu[:,:]=[-1.049009,0;-1.049,0;-1.018,0.301;0,0.4;1.018,0.301;1.049,0;1.049009,0] "PQ diagram for Q>0";
  parameter Real tableQMaxUPu[:,:]=[0,0.401;1.105263,0.401;1.131579,0;2,0] "UQ diagram for Q>0";
  parameter Real tableQMinPPu[:,:]=[-1.049009,0;-1.049,0;-1.018,-0.288;-0.911,-0.6;0,-0.6;0.911,-0.6;1.018,-0.288;1.049,0;1.049009,0] "PQ diagram for Q<0";
  parameter Real tableQMinUPu[:,:]=[0,0;0.986842,0;1.052632,-0.601;2,-0.601] "UQ diagram for Q<0";

  Modelica.Blocks.Interfaces.RealInput QRefUQPu(start = Q0Pu) "Reference reactive power in U mode in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 75}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -75}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput QRefLimPu(start = Q0Pu) "Reference reactive power in p.u (base SNom) after applying the diagrams" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = QMaxOPPu, uMin = QMinOPPu)  annotation(
    Placement(visible = true, transformation(origin = {-41, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {-4, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D QMaxPPuCalc(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, table = tableQMaxPPu) annotation(
    Placement(visible = true, transformation(origin = {-66, 95}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D QMinPPuCalc(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, table = tableQMinPPu) annotation(
    Placement(visible = true, transformation(origin = {-66, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D QMinUPuCalc(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, table = tableQMinUPu) annotation(
    Placement(visible = true, transformation(origin = {-66, -55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D QMaxUPuCalc(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, table = tableQMaxUPu) annotation(
    Placement(visible = true, transformation(origin = {-66, -95}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.ReactivePowerPu Q0Pu;
  parameter Types.VoltageModulePu U0Pu;
  parameter Types.ActivePowerPu P0Pu;

equation

  connect(variableLimiter.y, variableLimiter1.u) annotation(
    Line(points = {{7, 0}, {17, 0}, {17, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, QRefLimPu) annotation(
    Line(points = {{41, 0}, {101, 0}, {101, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, variableLimiter1.u) annotation(
    Line(points = {{7, 0}, {18, 0}, {18, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(limiter.y, variableLimiter.u) annotation(
    Line(points = {{-30, 0}, {-17, 0}, {-17, 0}, {-16, 0}}, color = {0, 0, 127}));
  connect(PPu, QMaxPPuCalc.u[1]) annotation(
    Line(points = {{-120, 75}, {-90, 75}, {-90, 95}, {-78, 95}}, color = {0, 0, 127}));
  connect(PPu, QMinPPuCalc.u[1]) annotation(
    Line(points = {{-120, 75}, {-90, 75}, {-90, 55}, {-78, 55}}, color = {0, 0, 127}));
  connect(UPu, QMinUPuCalc.u[1]) annotation(
    Line(points = {{-120, -75}, {-90, -75}, {-90, -55}, {-78, -55}}, color = {0, 0, 127}));
  connect(UPu, QMaxUPuCalc.u[1]) annotation(
    Line(points = {{-120, -75}, {-90, -75}, {-90, -95}, {-78, -95}}, color = {0, 0, 127}));
  connect(QMinUPuCalc.y[1], variableLimiter1.limit2) annotation(
    Line(points = {{-55, -55}, {10, -55}, {10, -8}, {18, -8}}, color = {0, 0, 127}));
  connect(QMaxPPuCalc.y[1], variableLimiter.limit1) annotation(
    Line(points = {{-55, 95}, {-24, 95}, {-24, 8}, {-16, 8}}, color = {0, 0, 127}));
  connect(QMaxUPuCalc.y[1], variableLimiter1.limit1) annotation(
    Line(points = {{-55, -95}, {13, -95}, {13, 8}, {18, 8}}, color = {0, 0, 127}));
  connect(QMinPPuCalc.y[1], variableLimiter.limit2) annotation(
    Line(points = {{-55, 55}, {-26, 55}, {-26, -8}, {-16, -8}}, color = {0, 0, 127}));
  connect(QRefUQPu, limiter.u) annotation(
    Line(points = {{-120, 0}, {-54, 0}, {-54, 0}, {-53, 0}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));

end QRefLimCalc;
