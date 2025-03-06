within Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls;

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

model QLimitation "Reactive power limitation (IEC 63406)"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter String TableFileName "Name given to the general file containing all tables" annotation(
    Dialog(tab = "General"));

  //Parameters
  parameter Boolean QLimFlag "0 to use the defined lookup tables, 1 to use the constant values" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit QMaxPu "Maximum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit QMinPu "Minimum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter String QMaxtoPTableName "Table giving the maximum reactive power depending on the measured active power" annotation(
    Dialog(tab = "QControl"));
  parameter String QMintoPTableName "Table giving the minimum reactive power depending on the measured active power" annotation(
    Dialog(tab = "QControl"));
  parameter String QMaxtoUTableName "Table giving the maximum reactive power depending on the measured voltage" annotation(
    Dialog(tab = "QControl"));
  parameter String QMintoUTableName "Table giving the minimum reactive power depending on the measured voltage" annotation(
    Dialog(tab = "QControl"));

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput FFlag(start = false) "Flag indicating the generating unit operating condition" annotation(
    Placement(visible = true, transformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput pMeasPu(start = -P0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) active power component in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uMeasPu(start = U0Pu) "Measured (and filtered) voltage component in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput qMaxPu(start = QMax0Pu) "Maximum reactive power at converter terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput qMinPu(start = QMin0Pu) "Minimum reactive power at converter terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(fileName = TableFileName, tableName = QMaxtoUTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-40, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch freeze2 annotation(
    Placement(visible = true, transformation(origin = {0, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1 annotation(
    Placement(visible = true, transformation(origin = {-40, 60}, extent = {{-10, -8}, {10, 8}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds1(fileName = TableFileName, tableName = QMaxtoPTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-40, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch freeze3 annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = QMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -8}, {10, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch14 annotation(
    Placement(visible = true, transformation(origin = {80, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression5(y = QLimFlag) annotation(
    Placement(visible = true, transformation(origin = {60, 100}, extent = {{-20, -14}, {20, 14}}, rotation = -90)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds2(fileName = TableFileName, tableName = QMintoUTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds3(fileName = TableFileName, tableName = QMintoPTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-40, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch12 annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch13 annotation(
    Placement(visible = true, transformation(origin = {0, -20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression7(y = QMinPu) annotation(
    Placement(visible = true, transformation(origin = {-40, -80}, extent = {{-10, -8}, {10, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression8 annotation(
    Placement(visible = true, transformation(origin = {-40, -40}, extent = {{-10, -8}, {10, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch15 annotation(
    Placement(visible = true, transformation(origin = {80, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax minMax(nu = 3)  annotation(
    Placement(visible = true, transformation(origin = {40, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax minMax1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {40, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

//Initial parameters
  parameter Types.PerUnit IQMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));

equation
  connect(booleanExpression5.y, switch14.u2) annotation(
    Line(points = {{60, 78}, {60, 60}, {68, 60}}, color = {255, 0, 255}));
  connect(booleanExpression5.y, switch15.u2) annotation(
    Line(points = {{60, 78}, {60, -40}, {68, -40}}, color = {255, 0, 255}));
  connect(realExpression2.y, switch14.u1) annotation(
    Line(points = {{-29, 20}, {68, 20}, {68, 52}}, color = {0, 0, 127}));
  connect(switch14.y, qMaxPu) annotation(
    Line(points = {{91, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(switch15.y, qMinPu) annotation(
    Line(points = {{91, -40}, {110, -40}}, color = {0, 0, 127}));
  connect(realExpression7.y, switch15.u1) annotation(
    Line(points = {{-29, -80}, {68, -80}, {68, -48}}, color = {0, 0, 127}));
  connect(realExpression1.y, freeze2.u1) annotation(
    Line(points = {{-29, 60}, {-25, 60}, {-25, 72}, {-13, 72}}, color = {0, 0, 127}));
  connect(realExpression1.y, freeze3.u1) annotation(
    Line(points = {{-29, 60}, {-25, 60}, {-25, 32}, {-13, 32}}, color = {0, 0, 127}));
  connect(FFlag, freeze2.u2) annotation(
    Line(points = {{-20, 110}, {-20, 80}, {-12, 80}}, color = {255, 0, 255}));
  connect(FFlag, freeze3.u2) annotation(
    Line(points = {{-20, 110}, {-20, 40}, {-12, 40}}, color = {255, 0, 255}));
  connect(FFlag, switch13.u2) annotation(
    Line(points = {{-20, 110}, {-20, -20}, {-12, -20}}, color = {255, 0, 255}));
  connect(realExpression8.y, switch13.u1) annotation(
    Line(points = {{-30, -40}, {-24, -40}, {-24, -28}, {-12, -28}}, color = {0, 0, 127}));
  connect(realExpression8.y, switch12.u1) annotation(
    Line(points = {{-30, -40}, {-24, -40}, {-24, -68}, {-12, -68}}, color = {0, 0, 127}));
  connect(FFlag, switch12.u2) annotation(
    Line(points = {{-20, 110}, {-20, -60}, {-12, -60}}, color = {255, 0, 255}));
  connect(combiTable1Ds.y[1], freeze2.u3) annotation(
    Line(points = {{-28, 80}, {-22, 80}, {-22, 88}, {-12, 88}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], freeze3.u3) annotation(
    Line(points = {{-28, 40}, {-22, 40}, {-22, 48}, {-12, 48}}, color = {0, 0, 127}));
  connect(pMeasPu, combiTable1Ds1.u) annotation(
    Line(points = {{-120, 40}, {-52, 40}}, color = {0, 0, 127}));
  connect(uMeasPu, combiTable1Ds.u) annotation(
    Line(points = {{-120, 80}, {-52, 80}}, color = {0, 0, 127}));
  connect(uMeasPu, combiTable1Ds2.u) annotation(
    Line(points = {{-120, 80}, {-60, 80}, {-60, -20}, {-52, -20}}, color = {0, 0, 127}));
  connect(pMeasPu, combiTable1Ds3.u) annotation(
    Line(points = {{-120, 40}, {-80, 40}, {-80, -60}, {-52, -60}}, color = {0, 0, 127}));
  connect(combiTable1Ds2.y[1], switch13.u3) annotation(
    Line(points = {{-28, -20}, {-22, -20}, {-22, -12}, {-12, -12}}, color = {0, 0, 127}));
  connect(combiTable1Ds3.y[1], switch12.u3) annotation(
    Line(points = {{-28, -60}, {-22, -60}, {-22, -52}, {-12, -52}}, color = {0, 0, 127}));
  connect(switch13.y, minMax.u[1]) annotation(
    Line(points = {{12, -20}, {20, -20}, {20, -40}, {30, -40}}, color = {0, 0, 127}));
  connect(switch12.y, minMax.u[2]) annotation(
    Line(points = {{12, -60}, {20, -60}, {20, -40}, {30, -40}}, color = {0, 0, 127}));
  connect(realExpression7.y, minMax.u[3]) annotation(
    Line(points = {{-28, -80}, {20, -80}, {20, -40}, {30, -40}}, color = {0, 0, 127}));
  connect(minMax.yMax, switch15.u3) annotation(
    Line(points = {{52, -34}, {54, -34}, {54, -32}, {68, -32}}, color = {0, 0, 127}));
  connect(freeze3.y, minMax1.u[1]) annotation(
    Line(points = {{12, 40}, {20, 40}, {20, 60}, {30, 60}}, color = {0, 0, 127}));
  connect(freeze2.y, minMax1.u[2]) annotation(
    Line(points = {{12, 80}, {20, 80}, {20, 60}, {30, 60}}, color = {0, 0, 127}));
  connect(realExpression2.y, minMax1.u[3]) annotation(
    Line(points = {{-28, 20}, {20, 20}, {20, 60}, {30, 60}}, color = {0, 0, 127}));
  connect(minMax1.yMin, switch14.u3) annotation(
    Line(points = {{52, 54}, {56, 54}, {56, 68}, {68, 68}}, color = {0, 0, 127}));
protected

  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(extent = {{-100, 100}, {100, -100}}, textString = "Q
Limitation")}));
end QLimitation;
