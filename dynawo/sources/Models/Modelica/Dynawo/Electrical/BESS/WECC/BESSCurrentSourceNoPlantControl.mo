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
  extends Dynawo.Electrical.BESS.WECC.BaseClasses.BaseBESSCurrentSource;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECc;


  // Input variables
  Modelica.Blocks.Interfaces.RealInput PInjRefPu(start = PInj0Pu) "Active power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QInjRefPu(start = QInj0Pu) "Reactive power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

Dynawo.Electrical.Controls.WECC.REEC.REECc reecC(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, SOC0Pu = SOC0Pu, SOCMaxPu = SOCMaxPu, SOCMinPu = SOCMinPu, UInj0Pu = UInj0Pu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIp31 = VDLIp31, VDLIp32 = VDLIp32, VDLIp41 = VDLIp41, VDLIp42 = VDLIp42, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VDLIq31 = VDLIq31, VDLIq32 = VDLIq32, VDLIq41 = VDLIq41, VDLIq42 = VDLIq42, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VUpPu = VUpPu, tBattery = tBattery, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(PInjRefPu, reecC.PInjRefPu) annotation(
    Line(points = {{-190, 20}, {-160, 20}, {-160, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(QInjRefPu, reecC.QInjRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(injector.QInjPuSn, reecC.QInjPu) annotation(
    Line(points = {{12, 0}, {30, 0}, {30, -30}, {-89, -30}, {-89, -11}}, color = {0, 0, 127}));
  connect(injector.PInjPuSn, reecC.PInjPu) annotation(
    Line(points = {{12, -4}, {25, -4}, {25, -25}, {-80, -25}, {-80, -11}}, color = {0, 0, 127}));
  connect(injector.UPu, reecC.UPu) annotation(
    Line(points = {{12, -8}, {20, -8}, {20, -20}, {-74, -20}, {-74, -11}}, color = {0, 0, 127}));
  connect(reecC.frtOn, regcA.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(reecC.idCmdPu, regcA.idCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(reecC.iqCmdPu, regcA.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(PFaRef, reecC.PFaRef) annotation(
    Line(points = {{-70, 70}, {-70, 14}, {-79, 14}, {-79, 11}}, color = {0, 0, 127}));
  connect(PAuxPu, reecC.PAuxPu) annotation(
    Line(points = {{-90, 70}, {-90, 14}, {-83, 14}, {-83, 11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end BESSCurrentSourceNoPlantControl;
