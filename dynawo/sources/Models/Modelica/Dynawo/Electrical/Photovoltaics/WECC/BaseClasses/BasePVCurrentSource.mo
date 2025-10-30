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

partial model BasePVCurrentSource "Base for WECC PV with a current source as interface with the grid"
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECb;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGCa;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-79, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));

  Dynawo.Electrical.Controls.WECC.REEC.REECb wecc_reec(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QMaxPu = QMaxPu, QMinPu = QMinPu, UInj0Pu = UInj0Pu, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, VUpPu = VUpPu, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv, SNom = SNom, PConv0Pu = PConv0Pu, QConv0Pu = QConv0Pu, s0Pu = s0Pu, u0Pu = u0Pu, uConv0Pu = uConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80.1315, -0.1384}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REGC.REGCa wecc_regc(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, Lvplsw = Lvplsw, QConv0Pu = QConv0Pu, RrpwrPu = RrpwrPu, UInj0Pu = UInj0Pu, brkpt = brkpt, lvpl1 = lvpl1, tFilterGC = tFilterGC, tG = tG, u0Pu = u0Pu, uConv0Pu = uConv0Pu, zerox = zerox) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = -PInj0Pu*(SNom/SystemBase.SnRef), Q0Pu = -QInj0Pu*(SNom/SystemBase.SnRef), SNom = SNom, U0Pu = UInj0Pu, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = uInj0Pu, UPhase0 = ComplexMath.arg(uConv0Pu)) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-185, 38}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements WTTerminalMeasurements(SNom = SNom)  annotation(
    Placement(transformation(origin = {65, -8.88178e-16}, extent = {{-5, 5}, {5, -5}})));
  Dynawo.Electrical.Sources.IEC.BaseConverters.ElecSystem LvToMvTfo(SNom = SNom, i20Pu = iConv0Pu, u20Pu = uConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit iConv0Pu "Start value of complex current at converter terminal in pu (base UNom, SNom) (generator convention)";
  parameter Types.ActivePowerPu PConv0Pu "Start value of active power at converter terminal in pu (generator convention) (base SNom)";
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.ReactivePowerPu QConv0Pu "Start value of reactive power at converter terminal in pu (generator convention) (base SNom)";
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit uConv0Pu "Start value of complex voltage at converter terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at regulated bus in rad";

equation
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(wecc_regc.idRefPu, injector.idPu) annotation(
    Line(points = {{-29, -6}, {-11.5, -6}}, color = {0, 0, 127}));
  connect(wecc_regc.iqRefPu, injector.iqPu) annotation(
    Line(points = {{-29, 4}, {-11.5, 4}}, color = {0, 0, 127}));
  connect(pll.phi, injector.UPhase) annotation(
    Line(points = {{-149, 45}, {-145, 45}, {-145, -50}, {0, -50}, {0, -11.5}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-179.5, 38}, {-171, 38}}, color = {0, 0, 127}));
  connect(PFaRef, wecc_reec.PFaRef) annotation(
    Line(points = {{-79, 70}, {-79, 11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.UPu, wecc_regc.UPu) annotation(
    Line(points = {{60, -6}, {60, -16}, {-46, -16}, {-46, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.UPu, wecc_reec.UPu) annotation(
    Line(points = {{60, -6}, {60, -16}, {-74, -16}, {-74, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.PPu, wecc_reec.PConvPu) annotation(
    Line(points = {{62, -6}, {62, -20}, {-80, -20}, {-80, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.QPu, wecc_reec.QConvPu) annotation(
    Line(points = {{64, -6}, {64, -25}, {-89, -25}, {-89, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.uPu, pll.uPu) annotation(
    Line(points = {{66, -6}, {66, -60}, {-177, -60}, {-177, 50}, {-171, 50}}, color = {85, 170, 255}));
  connect(injector.terminal, LvToMvTfo.terminal1) annotation(
    Line(points = {{12, 8}, {24, 8}, {24, 0}, {29, 0}}, color = {0, 0, 255}));
  connect(LvToMvTfo.terminal2, WTTerminalMeasurements.terminal1) annotation(
    Line(points = {{51, 0}, {60, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end BasePVCurrentSource;
