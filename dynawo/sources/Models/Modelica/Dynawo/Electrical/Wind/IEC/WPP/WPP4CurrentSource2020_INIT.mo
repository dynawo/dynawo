within Dynawo.Electrical.Wind.IEC.WPP;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WPP4CurrentSource2020_INIT "Wind Power Plant Type 4 model from IEC 61400-27-1 standard : initialization model"
  extends Dynawo.Electrical.Wind.IEC.WT.WT4CurrentSource_INIT;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QControlParameters2020;

  //WPP Qcontrol parameters
  parameter Types.PerUnit Kwpqu "Voltage controller cross coupling gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Integer MwpqMode "Control mode (0 : reactive power reference, 1 : power factor reference, 2 : UQ static, 3 : voltage control)";
  parameter Types.PerUnit RwpDropPu "Resistive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XwpDropPu "Inductive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControlWP"));

  final parameter Dynawo.Types.PerUnit TableUErrQwp[size(TableQwpUErr,1), size(TableQwpUErr,2)] = [TableQwpUErr[:,2], TableQwpUErr[:,1]];
  Dynawo.Types.PerUnit UWpp0DroppedPu "Initial voltage module at the output of the voltage drop block (This voltage is the one that is controlled in WPPQControl)";
  Dynawo.Types.PerUnit X0Pu "Initial reactive power or voltage reference in pu (base SNom or UNom) (generator convention)";

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds6(table = TableUErrQwp)  annotation(
    Placement(visible = true, transformation(origin = {-96, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const6(k = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-138, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  UWpp0DroppedPu = ((U0Pu + RwpDropPu * P0Pu * SystemBase.SnRef / (SNom * U0Pu) + XwpDropPu * Q0Pu * SystemBase.SnRef / (SNom * U0Pu))^2 + (-XwpDropPu * P0Pu * SystemBase.SnRef / (SNom * U0Pu) + RwpDropPu * Q0Pu * SystemBase.SnRef / (SNom * U0Pu))^2)^0.5;
  X0Pu = if MwpqMode == 0 then -Q0Pu * SystemBase.SnRef / SNom else if MwpqMode == 1 then Q0Pu / P0Pu else if MwpqMode == 2 then UWpp0DroppedPu + combiTable1Ds6.y[1] else if MwpqMode == 3 then UWpp0DroppedPu - Kwpqu * Q0Pu * SystemBase.SnRef / SNom else 0;
  connect(const6.y, combiTable1Ds6.u) annotation(
    Line(points = {{-126, 34}, {-108, 34}}, color = {0, 0, 127}));

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})));
end WPP4CurrentSource2020_INIT;
