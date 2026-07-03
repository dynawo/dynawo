within Dynawo.Electrical.Wind.IEC.WPP;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model WPP4CurrentSource2015_INIT "Wind Power Plant Type 4 model from IEC 61400-27-1:2015 standard : initialization model"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QControlParameters2015;
  extends Dynawo.Electrical.Wind.IEC.WPP.WPP4CurrentSource_INIT;

  //QControl parameters
  parameter Types.PerUnit Kwpqu "Voltage controller cross coupling gain in pu (base SNom)";
  parameter Integer MwpqMode "Control mode (0 : reactive power reference, 1 : power factor reference, 2 : UQ static, 3 : voltage control)";

  Types.VoltageModulePu UWpp0DroppedPu "Initial voltage module at the output of the voltage drop block (which is controlled in WPPQControl) in pu (base UNom)";
  Types.PerUnit X0Pu;

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds6Init(table = TableQwpUErr) annotation(
    Placement(transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpressionInit(y = QControl0Pu) annotation(
    Placement(transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  UWpp0DroppedPu = Modelica.ComplexMath.'abs'(uControl0Pu);
  X0Pu = if MwpqMode == 0 then QControl0Pu else if MwpqMode == 1 then QControl0Pu / PControl0Pu else if MwpqMode == 2 then UWpp0DroppedPu + combiTable1Ds6Init.y[1] else if MwpqMode == 3 then UWpp0DroppedPu + Kwpqu * QControl0Pu else 0;

  connect(realExpressionInit.y, combiTable1Ds6Init.u) annotation(
    Line(points = {{-178, 0}, {-162, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})));
end WPP4CurrentSource2015_INIT;
