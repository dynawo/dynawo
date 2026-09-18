within Dynawo.Electrical.Photovoltaics.WECC;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PVCurrentSourceNoPlantControl "WECC PV model with a current source as interface with the grid (REEC-B REGC-A)"
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsLvTfo;
  extends Dynawo.Electrical.Photovoltaics.WECC.BaseClasses.BasePVCurrentSource(LvTfo(RPu = RPu, XPu = XPu));

  // HVRT and LVRT parameters
  parameter String TablesFile "Text file that contains the tables for the functions";
  parameter String TabletUoverUfilt "Disconnection time versus over voltage lookup table for overvoltage";
  parameter String TabletUunderUfilt "Disconnection time versus over voltage lookup table for undervoltage";
  parameter Types.Time tLagAction "Time lag due to the actual tripping action in s";
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s";
  parameter Types.VoltageModulePu UOverPu "Overvoltage protection activation threshold in pu (base UNom)";
  parameter Types.VoltageModulePu UUnderPu "Undervoltage protection activation threshold in pu (base UNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PConvRefPu(start = PConv0Pu) "Active power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QConvRefPu(start = QConv0Pu) "Reactive power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.Machines.Protections.HVRT hvrt(UOverPu = UOverPu, tLagAction = tLagAction, tUFilt = tUFilt, TablesFile = TablesFile, TabletUoverUfilt = TabletUoverUfilt, U0Pu = UConv0Pu) annotation(
    Placement(transformation(origin = {85, -15}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Protections.LVRT lvrt(UUnderPu = UUnderPu, tLagAction = tLagAction, tUFilt = tUFilt, TablesFile = TablesFile, TabletUunderUfilt = TabletUunderUfilt, U0Pu = UConv0Pu) annotation(
    Placement(transformation(origin = {85, -35}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

equation
  injector.switchOffSignal3 = hvrt.fOCB or lvrt.fOCB;

  connect(QConvRefPu, wecc_reec.QConvRefPu) annotation(
    Line(points = {{-190, -20}, {-100, -20}, {-100, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(PConvRefPu, wecc_reec.PConvRefPu) annotation(
    Line(points = {{-190, 20}, {-100, 20}, {-100, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(LvMeasurements.terminal2, terminal) annotation(
    Line(points = {{70, 0}, {130, 0}}, color = {0, 0, 255}));
  connect(LvMeasurements.UPu, hvrt.UMonitoredPu) annotation(
    Line(points = {{60, -6}, {60, -16}, {80, -16}}, color = {0, 0, 127}));
  connect(LvMeasurements.UPu, lvrt.UMonitoredPu) annotation(
    Line(points = {{60, -6}, {60, -36}, {80, -36}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p> This block contains the generic WECC PV model without the plant control REPC.</p></body></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end PVCurrentSourceNoPlantControl;
