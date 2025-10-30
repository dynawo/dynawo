within Dynawo.Electrical.Photovoltaics.WECC.BaseClasses;

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


partial model BasePVVoltageSourceB "Base model for WECC PV with a voltage source as interface with the grid (REGC-B)"
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGCb;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsVSourceRef;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(transformation(origin = {-80, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));

  Dynawo.Electrical.Controls.WECC.REGC.REGCb wecc_regc(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, RSourcePu = RSourcePu, RateFlag = RateFlag, RrpwrPu = RrpwrPu, UInj0Pu = UInj0Pu, UdInj0Pu = UdInj0Pu, UqInj0Pu = UqInj0Pu, XSourcePu = XSourcePu, tE = tE, tFilterGC = tFilterGC, tG = tG, uInj0Pu = uInj0Pu, uSource0Pu = uSource0Pu, QConv0Pu = QConv0Pu, u0Pu = u0Pu, uConv0Pu = uConv0Pu) annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(transformation(origin = {-185, 38}, extent = {{-5, -5}, {5, 5}})));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(transformation(origin = {-160, 44}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Sources.InjectorURI injector(i0Pu = i0Pu, u0Pu = uSource0Pu) annotation(
    Placement(transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.Line source(BPu = 0, GPu = 0, RPu = RSourcePu*SystemBase.SnRef/SNom, XPu = XSourcePu*SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Sources.IEC.BaseConverters.ElecSystem LvToMvTfo(SNom = SNom, i20Pu = iConv0Pu, u20Pu = uConv0Pu) annotation(
    Placement(transformation(origin = {41, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements WTTerminalMeasurements(SNom = SNom) annotation(
    Placement(transformation(origin = {65, -8.88178e-16}, extent = {{-5, 5}, {5, -5}})));

  // Initial parameters
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit iConv0Pu "Start value of complex current at converter terminal in pu (base UNom, SNom) (generator convention)";
  parameter Types.ActivePowerPu PConv0Pu "Start value of active power at converter terminal in pu (generator convention) (base SNom)";
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.ReactivePowerPu QConv0Pu "Start value of reactive power at converter terminal in pu (generator convention) (base SNom)";
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit uConv0Pu "Start value of complex voltage at converter terminal in pu (base UNom)";
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage at injector in pu (base UNom)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at regulated bus in rad";
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage at injector in pu (base UNom)";
  parameter Types.ComplexPerUnit uSource0Pu "Start value of complex voltage at source in pu (base UNom)";

equation
  source.switchOffSignal1.value = injector.switchOffSignal1.value;
  source.switchOffSignal2.value = injector.switchOffSignal2.value;

  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-179.5, 38}, {-170.5, 38}}, color = {0, 0, 127}));
  connect(injector.terminal, source.terminal1) annotation(
    Line(points = {{-8.5, -0.3}, {0, -0.3}}, color = {0, 0, 255}));
  connect(source.terminal2, LvToMvTfo.terminal1) annotation(
    Line(points = {{20, 0}, {30, 0}}, color = {0, 0, 255}));
  connect(LvToMvTfo.terminal2, WTTerminalMeasurements.terminal1) annotation(
    Line(points = {{52, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(wecc_regc.urSource, injector.urPu) annotation(
    Line(points = {{-39, 4}, {-31, 4}}, color = {0, 0, 127}));
  connect(wecc_regc.uiSource, injector.uiPu) annotation(
    Line(points = {{-39, -4}, {-31, -4}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(extent = {{-100, -100}, {130, 100}}, grid = {1, 1})),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -100}, {130, 100}})));
end BasePVVoltageSourceB;
