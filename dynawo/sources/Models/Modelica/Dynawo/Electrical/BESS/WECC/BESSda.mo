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

model BESSda "WECC BESS model with a generator converter model type A"
  extends Dynawo.Electrical.BESS.WECC.BaseClasses.BaseBESSd;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.REGCaParameters;

  Dynawo.Electrical.Controls.WECC.REGC.REGCa regc(Brkpt = Brkpt, Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, Lvpl1 = Lvpl1, LvplSw = LvplSw, PInj0Pu = PInj0Pu, QInj0Pu = QInj0Pu, RateFlag = RateFlag, RrpwrPu = RrpwrPu, SNom = SNom, UInj0Pu = UInj0Pu, UPhaseInj0 = UPhaseInj0, Zerox = Zerox, i0Pu = i0Pu, s0Pu = s0Pu, tFilterGC = tFilterGC, tG = tG, uInj0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression complexExpr(y = regc.terminal.i)  annotation(
    Placement(visible = true, transformation(origin = {-57, 13}, extent = {{3, -2}, {-3, 2}}, rotation = 0)));

equation
  line.switchOffSignal1.value = regc.injectorIDQ.switchOffSignal1.value;
  line.switchOffSignal2.value = regc.injectorIDQ.switchOffSignal2.value;

  connect(reec.iqCmdPu, regc.iqCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(reec.frtOn, regc.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(reec.ipCmdPu, regc.ipCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(pll.phi, regc.UPhaseInj) annotation(
    Line(points = {{-149, 46}, {-40, 46}, {-40, 11}}, color = {0, 0, 127}));
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
  connect(regc.uInjPu, reec.uInjPu) annotation(
    Line(points = {{-29, -8}, {0, -8}, {0, 15}, {-76, 15}, {-76, 11}}, color = {85, 170, 255}));
  connect(complexExpr.y, reec.iInjPu) annotation(
    Line(points = {{-60, 13}, {-72, 13}, {-72, 11}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "BESS"));
end BESSda;
