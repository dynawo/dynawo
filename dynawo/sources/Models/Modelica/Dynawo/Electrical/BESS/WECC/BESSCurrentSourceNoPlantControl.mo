within Dynawo.Electrical.BESS.WECC;

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

model BESSCurrentSourceNoPlantControl "WECC BESS with electrical control model type C and generator/converter model type A (without plant control)"
  extends Dynawo.Electrical.BESS.WECC.BaseClasses.BaseBESSCurrentSource(LvToMvTfo(BPu = 0, GPu = 0, RPu = RPu, XPu = XPu));

  //Configuration parameters to define how the user wants to represent the internal network
  parameter Boolean ConverterLVControl = true "Boolean parameter to choose whether the converter is controlling at its output (LV side of its transformer) : True ; or after its transformer (MV side): False" annotation(
    Dialog(tab = "LV transformer"));

  //Parameters for LV transformer
  parameter Types.PerUnit RLvTrPu "Serial resistance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));
  parameter Types.PerUnit XLvTrPu "Serial reactance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));

  // In every cases (RPu + j*XPu) is the serial impedance between converter's output and WT terminal
  //Depending on the value of ConverterLVControl we are correctly defining these parameters
  final parameter Types.PerUnit RPu = if ConverterLVControl then 1e-5 else RLvTrPu "Serial resistance between converter output and WT terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit XPu = if ConverterLVControl then 1e-5 else XLvTrPu "Serial reactance between converter output and WT terminal in pu (base UNom, SNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PConvRefPu(start = PConv0Pu) "Active power setpoint at converter terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QConvRefPu(start = QConv0Pu) "Reactive power setpoint at converter terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  connect(PConvRefPu, reecC.PConvRefPu) annotation(
    Line(points = {{-190, 20}, {-160, 20}, {-160, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(QConvRefPu, reecC.QConvRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.terminal2, terminal) annotation(
    Line(points = {{70, 0}, {130, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end BESSCurrentSourceNoPlantControl;
