within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.ACVoltageControl;

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

model QRefLim "Function that applies the limitations to QRef"

  import Modelica;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_QRefLim;

  Modelica.Blocks.Interfaces.RealInput QRefUQPu(start = Q0Pu) "Reference reactive power in U mode in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 75}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -75}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput QRefLimPu(start = Q0Pu) "Reference reactive power in p.u (base SNom) after applying the diagrams" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = QMaxOPPu, uMin = QMinOPPu)  annotation(
    Placement(visible = true, transformation(origin = {-41, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {-4, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D QMaxPPu(table = tableQMaxPPu) annotation(
    Placement(visible = true, transformation(origin = {-66, 95}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D QMinPPu(table = tableQMinPPu) annotation(
    Placement(visible = true, transformation(origin = {-66, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D QMinUPu(table = tableQMinUPu) annotation(
    Placement(visible = true, transformation(origin = {-66, -55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D QMaxUPu(table = tableQMaxUPu) annotation(
    Placement(visible = true, transformation(origin = {-66, -95}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.ReactivePowerPu Q0Pu  "Start value of reactive power in p.u (base SNom) (generator convention)";
  parameter Types.VoltageModulePu U0Pu  "Start value of voltage amplitude in p.u (base UNom)";
  parameter Types.ActivePowerPu P0Pu  "Start value of active power in p.u (base SNom) (generator convention)";

equation

  connect(variableLimiter.y, variableLimiter1.u) annotation(
    Line(points = {{7, 0}, {17, 0}, {17, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, QRefLimPu) annotation(
    Line(points = {{41, 0}, {101, 0}, {101, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, variableLimiter1.u) annotation(
    Line(points = {{7, 0}, {18, 0}, {18, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(limiter.y, variableLimiter.u) annotation(
    Line(points = {{-30, 0}, {-17, 0}, {-17, 0}, {-16, 0}}, color = {0, 0, 127}));
  connect(PPu, QMaxPPu.u[1]) annotation(
    Line(points = {{-120, 75}, {-90, 75}, {-90, 95}, {-78, 95}}, color = {0, 0, 127}));
  connect(PPu, QMinPPu.u[1]) annotation(
    Line(points = {{-120, 75}, {-90, 75}, {-90, 55}, {-78, 55}}, color = {0, 0, 127}));
  connect(UPu, QMinUPu.u[1]) annotation(
    Line(points = {{-120, -75}, {-90, -75}, {-90, -55}, {-78, -55}}, color = {0, 0, 127}));
  connect(UPu, QMaxUPu.u[1]) annotation(
    Line(points = {{-120, -75}, {-90, -75}, {-90, -95}, {-78, -95}}, color = {0, 0, 127}));
  connect(QMinUPu.y[1], variableLimiter1.limit2) annotation(
    Line(points = {{-55, -55}, {10, -55}, {10, -8}, {18, -8}}, color = {0, 0, 127}));
  connect(QMaxPPu.y[1], variableLimiter.limit1) annotation(
    Line(points = {{-55, 95}, {-24, 95}, {-24, 8}, {-16, 8}}, color = {0, 0, 127}));
  connect(QMaxUPu.y[1], variableLimiter1.limit1) annotation(
    Line(points = {{-55, -95}, {13, -95}, {13, 8}, {18, 8}}, color = {0, 0, 127}));
  connect(QMinPPu.y[1], variableLimiter.limit2) annotation(
    Line(points = {{-55, 55}, {-26, 55}, {-26, -8}, {-16, -8}}, color = {0, 0, 127}));
  connect(QRefUQPu, limiter.u) annotation(
    Line(points = {{-120, 0}, {-54, 0}, {-54, 0}, {-53, 0}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));

end QRefLim;
