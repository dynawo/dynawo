within Dynawo.Electrical.Wind.WECC.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

partial model BaseWT4 "Partial base model for the WECC Wind Turbine models including the electrical control, the generator control, the injector, the measurements and the equivalent branch connection to the grid"
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECa;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

  // Input variable
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-79, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REEC.REECa wecc_reec(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu,Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqFrzPu = IqFrzPu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PFlag = PFlag, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, UInj0Pu = UInj0Pu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIp31 = VDLIp31, VDLIp32 = VDLIp32, VDLIp41 = VDLIp41, VDLIp42 = VDLIp42, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VDLIq31 = VDLIq31, VDLIq32 = VDLIq32, VDLIq41 = VDLIq41, VDLIq42 = VDLIq42, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, VUpPu = VUpPu, tHoldIpMax = tHoldIpMax, tHoldIq = tHoldIq, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv) annotation(
    Placement(visible = true, transformation(origin = {-80.1315, -0.1384}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REGC.REGCbCS wecc_regc(IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, RateFlag = RateFlag, tFilterGC = tFilterGC, tG = tG, RrpwrPu = RrpwrPu, UInj0Pu = UInj0Pu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = - PInj0Pu * (SNom / SystemBase.SnRef), Q0Pu = - QInj0Pu * (SNom / SystemBase.SnRef), SNom = SNom, U0Pu = UInj0Pu, UPhase0 = UPhaseInj0, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-185, 38}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  // Initial parameters
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.Angle UPhaseInj0 "Start value of voltage angle at injector";

equation
  line.switchOffSignal1.value = injector.switchOffSignal1.value;
  line.switchOffSignal2.value = injector.switchOffSignal2.value;

  connect(PFaRef, wecc_reec.PFaRef) annotation(
    Line(points = {{-79, 70}, {-79, 11}}, color = {0, 0, 127}));
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
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{60, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{100, 0}, {130, 0}}, color = {0, 0, 255}));
  connect(injector.terminal, line.terminal2) annotation(
    Line(points = {{12, 8}, {30, 8}, {30, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-179, 38}, {-171, 38}}, color = {0, 0, 127}));
  connect(injector.uPu, pll.uPu) annotation(
    Line(points = {{12, 3}, {20, 3}, {20, 60}, {-180, 60}, {-180, 50}, {-171, 50}}, color = {85, 170, 255}));
  connect(pll.phi, injector.UPhase) annotation(
    Line(points = {{-149, 45}, {-145, 45}, {-145, -50}, {0, -50}, {0, -11}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_regc.UPu) annotation(
    Line(points = {{12, -8}, {20, -8}, {20, -20}, {-46, -20}, {-46, -11}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_reec.UPu) annotation(
    Line(points = {{12, -8}, {20, -8}, {20, -20}, {-74, -20}, {-74, -11}}, color = {0, 0, 127}));
  connect(injector.PInjPuSn, wecc_reec.PInjPu) annotation(
    Line(points = {{12, -4}, {25, -4}, {25, -25}, {-80, -25}, {-80, -11}}, color = {0, 0, 127}));
  connect(injector.QInjPuSn, wecc_reec.QInjPu) annotation(
    Line(points = {{11.5, -0.5}, {30, -0.5}, {30, -30}, {-89, -30}, {-89, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p><br></p><ul>
</ul> <p></p></body></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end BaseWT4;
