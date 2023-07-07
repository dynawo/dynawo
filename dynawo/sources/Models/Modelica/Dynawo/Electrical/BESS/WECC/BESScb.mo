within Dynawo.Electrical.BESS.WECC;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model BESScb "WECC BESS model with a generator converter model type B"
  extends Dynawo.Electrical.BESS.WECC.BaseClasses.BaseBESSc;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.REGCbParameters;

  Dynawo.Electrical.Controls.WECC.REGC.REGCb regc(Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, PInj0Pu = PInj0Pu, QInj0Pu = QInj0Pu, RSourcePu = RSourcePu, RateFlag = RateFlag, RrpwrPu = RrpwrPu, SNom = SNom, UInj0Pu = UInj0Pu, UdInj0Pu = UdInj0Pu, UqInj0Pu = UqInj0Pu, XSourcePu = XSourcePu, i0Pu = i0Pu, tE = tE, tFilterGC = tFilterGC, tG = tG, uInj0Pu = uInj0Pu, uSource0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexVoltagePu uSource0Pu "Start value of complex voltage at source in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));

equation
  line.switchOffSignal1.value = regc.voltageSource.injectorURI.switchOffSignal1.value;
  line.switchOffSignal2.value = regc.voltageSource.injectorURI.switchOffSignal2.value;

  connect(reec.iqCmdPu, regc.iqCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(reec.frtOn, regc.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(reec.ipCmdPu, regc.ipCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(regc.terminal, line.terminal2) annotation(
    Line(points = {{-29, 0}, {10, 0}}, color = {0, 0, 255}));
  connect(regc.uInjPu, pll.uPu) annotation(
    Line(points = {{-29, -8}, {0, -8}, {0, 60}, {-180, 60}, {-180, 46}, {-171, 46}}, color = {85, 170, 255}));
  connect(regc.UInjPu, reec.UInjPu) annotation(
    Line(points = {{-29, -4}, {-20, -4}, {-20, -20}, {-74, -20}, {-74, -11}}, color = {0, 0, 127}));
  connect(regc.QInjPu, reec.QInjPu) annotation(
    Line(points = {{-29, 4}, {-15, 4}, {-15, -25}, {-88, -25}, {-88, -11}}, color = {0, 0, 127}));
  connect(regc.PInjPu, reec.PInjPu) annotation(
    Line(points = {{-29, 8}, {-10, 8}, {-10, -30}, {-80, -30}, {-80, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "BESS"));
end BESScb;
