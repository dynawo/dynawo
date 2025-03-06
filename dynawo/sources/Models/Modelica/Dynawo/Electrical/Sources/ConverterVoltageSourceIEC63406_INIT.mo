within Dynawo.Electrical.Sources;

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

model ConverterVoltageSourceIEC63406_INIT "Converter model from IEC63406 standard : initialization model"

  extends AdditionalIcons.Init;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //General parameters
  parameter String TableFileName "Name given to the general file containing all tables" annotation(
    Dialog(tab = "General"));

  //Circuit parameters
  parameter Types.PerUnit ResPu "Serial resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XesPu "Serial reactance in pu (base UNom, SNom)";

  //Current limiter parameters
  parameter Boolean QLimFlag "0 to use the defined lookup tables, 1 to use the constant values" annotation(
    Dialog(tab = "QControl"));
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter String QMaxtoPTableName "Table giving the maximum reactive power depending on the measured active power" annotation(
    Dialog(tab = "QControl"));
  parameter String QMintoPTableName "Table giving the minimum reactive power depending on the measured active power" annotation(
    Dialog(tab = "QControl"));
  parameter String QMaxtoUTableName "Table giving the maximum reactive power depending on the measured voltage" annotation(
    Dialog(tab = "QControl"));
  parameter String QMintoUTableName "Table giving the minimum reactive power depending on the measured voltage" annotation(
    Dialog(tab = "QControl"));

  //Init variables
  Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.PerUnit Id0Pu "Initial direct component of current imposed in the contol in pu (base UNom, SnRef) (generator convention)";
  Types.PerUnit Iq0Pu "Initial quadratic component of current imposed in the contol in pu (base UNom, SnRef) (generator convention)";
  Types.PerUnit IsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.ReactivePowerPu QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom)";
  Types.ReactivePowerPu QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom)";
  Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)";
  Types.PerUnit  Ued0Pu "Initial direct component of the voltage at converter terminal in pu (base UNom)";
  Types.PerUnit Ueq0Pu "Initial quadratic component of the voltage at converter terminal in pu (base UNom)";
  Types.PerUnit UeIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)";
  Types.PerUnit UeRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)";
  Types.PerUnit Ud0Pu "Initial direct component of the voltage at converter terminal in pu (base UNom)";
  Types.PerUnit Uq0Pu "Initial quadratic component of the voltage at converter terminal in pu (base UNom)";

  //Load flow parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad";

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds2(fileName = TableFileName, tableName = QMaxtoPTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds1(fileName = TableFileName, tableName = QMintoUTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(fileName = TableFileName, tableName = QMaxtoUTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds3(fileName = TableFileName, tableName = QMintoPTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-60, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-60, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max0 annotation(
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  QMax0Pu = if QLimFlag then QMaxPu else max0.y;
  QMin0Pu = if QLimFlag then QMinPu else min.y;
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  Complex(P0Pu, Q0Pu) = u0Pu * ComplexMath.conj(i0Pu);
  UeRe0Pu = Ued0Pu * cos(UPhase0) - Ueq0Pu * sin(UPhase0);
  UeIm0Pu = Ued0Pu * sin(UPhase0) + Ueq0Pu * cos(UPhase0);
  Id0Pu = -P0Pu * SystemBase.SnRef / (SNom * U0Pu);
  Iq0Pu = Q0Pu * SystemBase.SnRef / (SNom * U0Pu);
  Ud0Pu = u0Pu.re * cos(UPhase0) + u0Pu.im * sin(UPhase0);
  Uq0Pu = (-u0Pu.re * sin(UPhase0)) + u0Pu.im * cos(UPhase0);
  Complex(IsRe0Pu, IsIm0Pu) = -i0Pu * (SystemBase.SnRef / SNom); //Node law
  Complex(UeRe0Pu, UeIm0Pu) = u0Pu + Complex(ResPu, XesPu) * (-i0Pu) * (SystemBase.SnRef / SNom); //Voltage law

  connect(const1.y, combiTable1Ds.u) annotation(
    Line(points = {{-49, 60}, {-31, 60}, {-31, 80}, {-13, 80}}, color = {0, 0, 127}));
  connect(const1.y, combiTable1Ds1.u) annotation(
    Line(points = {{-49, 60}, {-31, 60}, {-31, 40}, {-13, 40}}, color = {0, 0, 127}));
  connect(const2.y, combiTable1Ds2.u) annotation(
    Line(points = {{-49, -60}, {-31, -60}, {-31, -40}, {-13, -40}}, color = {0, 0, 127}));
  connect(const2.y, combiTable1Ds3.u) annotation(
    Line(points = {{-49, -60}, {-31, -60}, {-31, -80}, {-13, -80}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], min.u1) annotation(
    Line(points = {{11, 80}, {29, 80}, {29, 86}, {67, 86}}, color = {0, 0, 127}));
  connect(combiTable1Ds2.y[1], min.u2) annotation(
    Line(points = {{11, -40}, {49, -40}, {49, 74}, {67, 74}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], max0.u1) annotation(
    Line(points = {{11, 40}, {29, 40}, {29, -74}, {67, -74}}, color = {0, 0, 127}));
  connect(combiTable1Ds3.y[1], max0.u2) annotation(
    Line(points = {{11, -80}, {29, -80}, {29, -86}, {67, -86}}, color = {0, 0, 127}));
  annotation(
    preferredView = "text",
  Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
  Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end ConverterVoltageSourceIEC63406_INIT;
