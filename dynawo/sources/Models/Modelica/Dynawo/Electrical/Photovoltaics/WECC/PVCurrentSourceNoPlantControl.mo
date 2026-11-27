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
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsOperatingPoint;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECb;
  extends Dynawo.Electrical.Photovoltaics.WECC.BaseClasses.BasePVCurrentSource(LvTfo(RPu = RPu, XPu = XPu));

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PConvRefPu(start = PConv0Pu) "Active power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QConvRefPu(start = QConv0Pu) "Reactive power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Output variable
  Modelica.Blocks.Interfaces.RealOutput UConvPu(start = UConv0Pu) "Voltage amplitude at converter terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {130, -40}, extent = {{10, 10}, {-10, -10}}, rotation = -180), iconTransformation(origin = {80, 110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));

  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.WECC.REEC.REECb wecc_reec(
    DPMaxPu = DPMaxPu,
    DPMinPu = DPMinPu,
    Dbd1Pu = Dbd1Pu,
    Dbd2Pu = Dbd2Pu,
    IMaxPu = IMaxPu,
    Id0Pu = Id0Pu,
    Iq0Pu = Iq0Pu,
    Iqh1Pu = Iqh1Pu,
    Iql1Pu = Iql1Pu,
    Kqi = Kqi,
    Kqp = Kqp,
    Kqv = Kqv,
    Kvi = Kvi,
    Kvp = Kvp,
    PF0 = PF0,
    PMaxREECPu = PMaxREECPu,
    PMinREECPu = PMinREECPu,
    PQFlag = PQFlag,
    PfFlag = PfFlag,
    QFlag = QFlag,
    QMaxREECPu = QMaxREECPu,
    QMinREECPu = QMinREECPu,
    UInj0Pu = UInj0Pu,
    VDipPu = VDipPu,
    VFlag = VFlag,
    VMaxPu = VMaxPu,
    VMinPu = VMinPu,
    VRef0Pu = VRef0Pu,
    VRef1Pu = VRef1Pu,
    VUpPu = VUpPu,
    tIq = tIq,
    tpREEC = tpREEC,
    tPord = tPord,
    tRv = tRv,
    SNom = SNom,
    PConv0Pu = PConv0Pu,
    QConv0Pu = QConv0Pu,
    s0Pu = s0Pu,
    u0Pu = u0Pu,
    uConv0Pu = uConv0Pu,
    UConv0Pu = UConv0Pu) annotation(
    Placement(transformation(origin = {-80.1315, -0.1384}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(QConvRefPu, wecc_reec.QConvRefPu) annotation(
    Line(points = {{-190, -20}, {-100, -20}, {-100, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(PConvRefPu, wecc_reec.PConvRefPu) annotation(
    Line(points = {{-190, 20}, {-100, 20}, {-100, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(LvMeasurements.terminal2, terminal) annotation(
    Line(points = {{70, 0}, {130, 0}}, color = {0, 0, 255}));
  connect(LvMeasurements.UPu, UConvPu) annotation(
    Line(points = {{60, -6}, {60, -40}, {130, -40}}, color = {0, 0, 127}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(PFaRef, wecc_reec.PFaRef) annotation(
    Line(points = {{-190, 60}, {-79, 60}, {-79, 11}}, color = {0, 0, 127}));
  connect(LvMeasurements.UPu, wecc_reec.UPu) annotation(
    Line(points = {{60, -6}, {60, -16}, {-74, -16}, {-74, -11}}, color = {0, 0, 127}));
  connect(LvMeasurements.PPu, wecc_reec.PConvPu) annotation(
    Line(points = {{62, -6}, {62, -20}, {-80, -20}, {-80, -11}}, color = {0, 0, 127}));
  connect(LvMeasurements.QPu, wecc_reec.QConvPu) annotation(
    Line(points = {{64, -6}, {64, -25}, {-89, -25}, {-89, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p> This block contains the generic WECC PV model without the plant control REPC.</p></body></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end PVCurrentSourceNoPlantControl;
