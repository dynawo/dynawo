within Dynawo.Electrical.Controls.Protections;

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

  parameter String TabletUoverUfilt "Disconnection time versus over voltage lookup table for over-voltage";
  parameter String TabletUunderUfilt "Disconnection time versus over voltage lookup table for under-voltage";

  // Input variable
  Modelica.Blocks.Interfaces.RealInput UMonitoredPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-108, -20}, extent = {{-20, -20}, {20, 20}})));

  // Output variable
  Modelica.Blocks.Interfaces.BooleanOutput fOCB(start = false) "Open Circuit Breaker flag" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the machine";
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D(tableName = TabletUoverUfilt, tableOnFile = true, fileName = TablesFile) annotation(
    Placement(transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation(
    Placement(transformation(origin = {-30, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = UOverPu) annotation(
    Placement(transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tUFilt, y_start = U0Pu) annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D1(tableName = TabletUunderUfilt, tableOnFile = true) annotation(
    Placement(transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(transformation(origin = {70, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LessEqual lessEqual1 annotation(
    Placement(transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = UUnderPu) annotation(
    Placement(transformation(origin = {-90, -68}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer1 annotation(
    Placement(transformation(origin = {10, -60}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameter
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)";

equation
  when fOCB then
    switchOffSignal.value = true;
  end when;

  connect(const.y, lessEqual.u1) annotation(
    Line(points = {{-79, 60}, {-42, 60}}, color = {0, 0, 127}));
  connect(lessEqual.y, timer.u) annotation(
    Line(points = {{-19, 60}, {-3, 60}}, color = {255, 0, 255}));
  connect(timer.y, greater.u1) annotation(
    Line(points = {{21, 60}, {39, 60}, {39, 40}, {57, 40}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], greater.u2) annotation(
    Line(points = {{21, 20}, {39, 20}, {39, 32}, {57, 32}}, color = {0, 0, 127}));
  connect(UPu, firstOrder1.u) annotation(
    Line(points = {{-120, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, lessEqual.u2) annotation(
    Line(points = {{-59, 0}, {-50.5, 0}, {-50.5, 52}, {-42, 52}}, color = {0, 0, 127}));
  connect(lessEqual1.y, timer1.u) annotation(
    Line(points = {{-19, -60}, {-2, -60}}, color = {255, 0, 255}));
  connect(combiTable1D1.y[1], less.u1) annotation(
    Line(points = {{21, -20}, {39, -20}, {39, -40}, {58, -40}}, color = {0, 0, 127}));
  connect(timer1.y, less.u2) annotation(
    Line(points = {{21, -60}, {39, -60}, {39, -48}, {58, -48}}, color = {0, 0, 127}));
  connect(const1.y, lessEqual1.u2) annotation(
    Line(points = {{-79, -68}, {-42, -68}}, color = {0, 0, 127}));
  connect(firstOrder1.y, combiTable1D1.u) annotation(
    Line(points = {{-58, 0}, {-20, 0}, {-20, -20}, {-2, -20}}, color = {0, 0, 127}));
  connect(firstOrder1.y, combiTable1D.u) annotation(
    Line(points = {{-58, 0}, {-20, 0}, {-20, 20}, {-2, 20}}, color = {0, 0, 127}));
  connect(firstOrder1.y, lessEqual1.u1) annotation(
    Line(points = {{-58, 0}, {-50, 0}, {-50, -60}, {-42, -60}}, color = {0, 0, 127}));
  connect(less.y, fOCB) annotation(
    Line(points = {{82, -40}, {90, -40}, {90, 0}, {110, 0}}, color = {255, 0, 255}));
  connect(greater.y, fOCB) annotation(
    Line(points = {{82, 40}, {90, 40}, {90, 0}, {110, 0}}, color = {255, 0, 255}));

end LHVRT;
