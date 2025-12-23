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
/*                uSourcePu                                uInjPu                      uPu
--------         |                                       |                         |
| Source |--------+---->>--------RSourcePu+jXSourcePu-----+------RPu+jXPu-----<<----+---- terminal
--------           iSourcePu                                                 iPu
*/

model PVVoltageSource2NoPlantControl "WECC PV model with a voltage source as interface with the grid (REEC-B REGC-B)"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECb;
  extends Dynawo.Electrical.Photovoltaics.WECC.BaseClasses.BasePVVoltageSourceB(LvToMvTfo(BPu = 0, GPu = 0, RPu = RPu, XPu = XPu));

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
  Modelica.Blocks.Interfaces.RealInput PConvRefPu(start = PConv0Pu) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QConvRefPu(start = QConv0Pu) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Controls.WECC.REEC.REECb wecc_reec(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QMaxPu = QMaxPu, QMinPu = QMinPu, UInj0Pu = UInj0Pu, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, VUpPu = VUpPu, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv, SNom = SNom, PConv0Pu = PConv0Pu, QConv0Pu = QConv0Pu, s0Pu = s0Pu, u0Pu = u0Pu, uConv0Pu = uConv0Pu) annotation(
    Placement(transformation(origin = {-83, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  connect(PFaRef, wecc_reec.PFaRef) annotation(
    Line(points = {{-79, 70}, {-79, 40.5}, {-82, 40.5}, {-82, 11}}, color = {0, 0, 127}));
  connect(PConvRefPu, wecc_reec.PConvRefPu) annotation(
    Line(points = {{-130, 20}, {-100, 20}, {-100, 6}, {-94, 6}}, color = {0, 0, 127}));
  connect(QConvRefPu, wecc_reec.QConvRefPu) annotation(
    Line(points = {{-130, -20}, {-100, -20}, {-100, -6}, {-94, -6}}, color = {0, 0, 127}));
  connect(pll.phi, wecc_regc.phi) annotation(
    Line(points = {{-149, 45}, {-65, 45}, {-65, 9}, {-61, 9}}, color = {0, 0, 127}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{-72, 6}, {-61, 6}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{-72, 0}, {-61, 0}}, color = {255, 0, 255}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{-72, -6}, {-61, -6}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.UPu, wecc_regc.UPu) annotation(
    Line(points = {{60, -6}, {60, -16}, {-56, -16}, {-56, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.UPu, wecc_reec.UPu) annotation(
    Line(points = {{60, -6}, {60, -16}, {-77, -16}, {-77, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.PPu, wecc_reec.PConvPu) annotation(
    Line(points = {{62, -6}, {62, -20}, {-83, -20}, {-83, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.QPu, wecc_reec.QConvPu) annotation(
    Line(points = {{64, -6}, {64, -25}, {-92, -25}, {-92, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.terminal2, terminal) annotation(
    Line(points = {{70, 0}, {130, 0}}, color = {0, 0, 255}));
  connect(WTTerminalMeasurements.uPu, wecc_regc.uInjPu) annotation(
    Line(points = {{66, -6}, {66, -30}, {-46, -30}, {-46, -11}}, color = {85, 170, 255}));
  connect(WTTerminalMeasurements.uPu, pll.uPu) annotation(
    Line(points = {{66, -6}, {66, -30}, {-177, -30}, {-177, 50}, {-171, 50}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(extent = {{-120, -60}, {120, 60}}, grid = {1, 1})),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-120, -60}, {120, 60}})));
end PVVoltageSource2NoPlantControl;
