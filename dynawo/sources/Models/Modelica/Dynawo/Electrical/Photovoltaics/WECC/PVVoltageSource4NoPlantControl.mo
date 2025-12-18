within Dynawo.Electrical.Photovoltaics.WECC;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PVVoltageSource4NoPlantControl "WECC PV model with a voltage source as interface with the grid (REEC-B REGC-C)"

  /*                uSourcePu                                uInjPu                      uPu
       --------         |                                       |                         |
      | Source |--------+---->>--------RSourcePu+jXSourcePu-----+------RPu+jXPu-----<<----+---- terminal
       --------           iSourcePu                                                 iPu
  */
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECb;
  extends Dynawo.Electrical.Photovoltaics.WECC.BaseClasses.BasePVVoltageSourceC;

  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PInjRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QInjRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REEC.REECb wecc_reec(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, UInj0Pu = UInj0Pu, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, VUpPu = VUpPu, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(measurements1.PPu, wecc_reec.PInjPu) annotation(
    Line(points = {{94, -11}, {94, -40}, {-80, -40}, {-80, -11}}, color = {0, 0, 127}));
  connect(measurements1.QPu, wecc_reec.QInjPu) annotation(
    Line(points = {{98, -11}, {98, -50}, {-89, -50}, {-89, -11}}, color = {0, 0, 127}));
  connect(measurements1.UPu, wecc_regc.UPu) annotation(
    Line(points = {{90, -11}, {90, -30}, {-46, -30}, {-46, -11}}, color = {0, 0, 127}));
  connect(measurements1.UPu, wecc_reec.UPu) annotation(
    Line(points = {{90, -11}, {90, -30}, {-74, -30}, {-74, -11}}, color = {0, 0, 127}));
  connect(PFaRef, wecc_reec.PFaRef) annotation(
    Line(points = {{-79, 70}, {-79, 11}}, color = {0, 0, 127}));
  connect(PInjRefPu, wecc_reec.PInjRefPu) annotation(
    Line(points = {{-190, 20}, {-150, 20}, {-150, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(QInjRefPu, wecc_reec.QInjRefPu) annotation(
    Line(points = {{-190, -20}, {-150, -20}, {-150, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(wecc_reec.ipMaxPu, wecc_regc.ipMaxPu) annotation(
    Line(points = {{-88, 11}, {-88, 30}, {-34, 30}, {-34, 11}}, color = {0, 0, 127}));
  connect(wecc_reec.ipMinPu, wecc_regc.ipMinPu) annotation(
    Line(points = {{-84, 11}, {-84, 26}, {-38, 26}, {-38, 11}}, color = {0, 0, 127}));
  connect(wecc_reec.iqMaxPu, wecc_regc.iqMaxPu) annotation(
    Line(points = {{-75, 11}, {-75, 21}, {-42, 21}, {-42, 11}}, color = {0, 0, 127}));
  connect(wecc_reec.iqMinPu, wecc_regc.iqMinPu) annotation(
    Line(points = {{-72, 11}, {-72, 16}, {-46, 16}, {-46, 11}}, color = {0, 0, 127}));
  connect(pll.phi, wecc_regc.phi) annotation(
    Line(points = {{-149, 45}, {-60, 45}, {-60, 9}, {-51, 9}}, color = {0, 0, 127}, pattern = LinePattern.Dash));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {180, 60}})));
end PVVoltageSource4NoPlantControl;
