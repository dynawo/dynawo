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

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_QRefLim;

  Modelica.Blocks.Interfaces.RealInput QRefUQPu(start = Q0Pu) "Raw reference reactive power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 75}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -75}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput QRefLimPu(start = Q0Pu) "Limited reference reactive power in pu (base SNom) after applying the diagrams" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = QMaxOPPu, uMin = QMinOPPu) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D QMaxPPu(table = tableQMaxPPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D QMinPPu(table = tableQMinPPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D QMinUPu(table = tableQMinUPu) annotation(
    Placement(visible = true, transformation(origin = {-70, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D QMaxUPu(table = tableQMaxUPu) annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrderQMaxPPu(T = tFilterLim, y_start = tableQMaxPPu12 + DeadBand0) annotation(
    Placement(visible = true, transformation(origin = {-40, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrderQMinPPu(T = tFilterLim, y_start = tableQMinPPu12 - DeadBand0) annotation(
    Placement(visible = true, transformation(origin = {-40, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrderQMaxUPu(T = tFilterLim, y_start = tableQMaxUPu12 + DeadBand0) annotation(
    Placement(visible = true, transformation(origin = {-40, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrderQMinUPu(T = tFilterLim, y_start = tableQMinUPu32 - DeadBand0) annotation(
    Placement(visible = true, transformation(origin = {-40, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SNom) (generator convention)";

equation
  connect(variableLimiter.y, variableLimiter1.u) annotation(
    Line(points = {{21, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, QRefLimPu) annotation(
    Line(points = {{81, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, variableLimiter1.u) annotation(
    Line(points = {{7, 0}, {18, 0}, {18, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(limiter.y, variableLimiter.u) annotation(
    Line(points = {{-39, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(PPu, QMaxPPu.u[1]) annotation(
    Line(points = {{-120, 75}, {-90, 75}, {-90, 90}, {-82, 90}}, color = {0, 0, 127}));
  connect(PPu, QMinPPu.u[1]) annotation(
    Line(points = {{-120, 75}, {-90, 75}, {-90, 60}, {-82, 60}}, color = {0, 0, 127}));
  connect(QRefUQPu, limiter.u) annotation(
    Line(points = {{-120, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(QMaxPPu.y[1], firstOrderQMaxPPu.u) annotation(
    Line(points = {{-59, 90}, {-52, 90}}, color = {0, 0, 127}));
  connect(QMinPPu.y[1], firstOrderQMinPPu.u) annotation(
    Line(points = {{-59, 60}, {-52, 60}}, color = {0, 0, 127}));
  connect(QMinUPu.y[1], firstOrderQMinUPu.u) annotation(
    Line(points = {{-59, -90}, {-52, -90}}, color = {0, 0, 127}));
  connect(QMaxUPu.y[1], firstOrderQMaxUPu.u) annotation(
    Line(points = {{-59, -60}, {-52, -60}}, color = {0, 0, 127}));
  connect(firstOrderQMaxUPu.y, variableLimiter1.limit1) annotation(
    Line(points = {{-29, -60}, {40, -60}, {40, 8}, {58, 8}}, color = {0, 0, 127}));
  connect(firstOrderQMinUPu.y, variableLimiter1.limit2) annotation(
    Line(points = {{-29, -90}, {50, -90}, {50, -8}, {58, -8}}, color = {0, 0, 127}));
  connect(UPu, QMinUPu.u[1]) annotation(
    Line(points = {{-120, -75}, {-90, -75}, {-90, -90}, {-82, -90}}, color = {0, 0, 127}));
  connect(UPu, QMaxUPu.u[1]) annotation(
    Line(points = {{-120, -75}, {-90, -75}, {-90, -60}, {-82, -60}}, color = {0, 0, 127}));
  connect(firstOrderQMaxPPu.y, variableLimiter.limit1) annotation(
    Line(points = {{-29, 90}, {-10, 90}, {-10, 8}, {-2, 8}}, color = {0, 0, 127}));
  connect(firstOrderQMinPPu.y, variableLimiter.limit2) annotation(
    Line(points = {{-29, 60}, {-20, 60}, {-20, -8}, {-2, -8}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end QRefLim;
