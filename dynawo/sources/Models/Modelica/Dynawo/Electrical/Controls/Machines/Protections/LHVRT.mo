within Dynawo.Electrical.Controls.Machines.Protections;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model LHVRT "High and low voltage ride-through"
  parameter Types.VoltageModulePu UOverPu "Over voltage protection activation threshold in pu (base UNom)";
  parameter Types.VoltageModulePu UUnderPu "Under voltage protection activation threshold in pu (base UNom)";
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s";

  // Tables parameter
  parameter String TablesFile "Disconnection time versus over voltage lookup table for under-voltage";
  parameter String TabletUoverUfilt "Disconnection time versus over voltage lookup table for over-voltage";
  parameter String TabletUunderUfilt "Disconnection time versus over voltage lookup table for under-voltage";

  // Input variable
  Modelica.Blocks.Interfaces.RealInput UMonitoredPu "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-108, -20}, extent = {{-20, -20}, {20, 20}})));

  // Output variable
  Modelica.Blocks.Interfaces.BooleanOutput fOCB(start = false) "Open Circuit Breaker flag" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the machine";
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D(tableName = TabletUoverUfilt, tableOnFile = true, fileName = TablesFile, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
    Placement(transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation(
    Placement(transformation(origin = {-30, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = UOverPu) annotation(
    Placement(transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D1(tableName = TabletUunderUfilt, tableOnFile = true, fileName = TablesFile, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
    Placement(transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(transformation(origin = {70, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LessEqual lessEqual1 annotation(
    Placement(transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = UUnderPu) annotation(
    Placement(transformation(origin = {-90, -68}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer1 annotation(
    Placement(transformation(origin = {10, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.MathBoolean.Or or1(nu = 2) annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  when fOCB then
    switchOffSignal.value = true;
  end when;

  connect(const.y, lessEqual.u1) annotation(
    Line(points = {{-78, 60}, {-42, 60}}, color = {0, 0, 127}));
  connect(const1.y, lessEqual1.u2) annotation(
    Line(points = {{-78, -68}, {-42, -68}}, color = {0, 0, 127}));
  connect(lessEqual1.y, timer1.u) annotation(
    Line(points = {{-18, -60}, {-2, -60}}, color = {255, 0, 255}));
  connect(lessEqual.y, timer.u) annotation(
    Line(points = {{-18, 60}, {-2, 60}}, color = {255, 0, 255}));
  connect(timer.y, greater.u1) annotation(
    Line(points = {{22, 60}, {40, 60}, {40, 40}, {58, 40}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], greater.u2) annotation(
    Line(points = {{22, 20}, {40, 20}, {40, 32}, {58, 32}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], less.u1) annotation(
    Line(points = {{22, -20}, {40, -20}, {40, -40}, {58, -40}}, color = {0, 0, 127}));
  connect(timer1.y, less.u2) annotation(
    Line(points = {{22, -60}, {40, -60}, {40, -48}, {58, -48}}, color = {0, 0, 127}));
  connect(or1.y, fOCB) annotation(
    Line(points = {{82, 0}, {110, 0}}, color = {255, 0, 255}));
  connect(greater.y, or1.u[1]) annotation(
    Line(points = {{82, 40}, {90, 40}, {90, 20}, {52, 20}, {52, 0}, {60, 0}}, color = {255, 0, 255}));
  connect(less.y, or1.u[2]) annotation(
    Line(points = {{82, -40}, {92, -40}, {92, -20}, {52, -20}, {52, 0}, {60, 0}}, color = {255, 0, 255}));
  connect(UMonitoredPu, lessEqual.u2) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, 52}, {-42, 52}}, color = {0, 0, 127}));
  connect(UMonitoredPu, combiTable1D.u) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, 20}, {-2, 20}}, color = {0, 0, 127}));
  connect(UMonitoredPu, combiTable1D1.u) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, -20}, {-2, -20}}, color = {0, 0, 127}));
  connect(UMonitoredPu, lessEqual1.u1) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, -60}, {-42, -60}}, color = {0, 0, 127}));

end LHVRT;
