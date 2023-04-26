within Dynawo.Electrical.Photovoltaics.WECC;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PVCurrentSource "WECC PV model with a current source as interface with the grid"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.WECC.Parameters;

  extends Parameters.Params_PlantControl;
  extends Parameters.Params_ElectricalControl;
  extends Parameters.Params_GeneratorControl;
  extends Parameters.Params_PLL;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {180, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 8.88178e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {120, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.PlantControl wecc_repc(DDn = DDn, DUp = DUp, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = - P0Pu * SystemBase.SnRef / SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QGen0Pu = - Q0Pu * SystemBase.SnRef / SNom, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, U0Pu = U0Pu, UInj0Pu = UInj0Pu, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, Dbd = Dbd, EMax = EMax, EMin = EMin, FDbd1 = FDbd1, FDbd2 = FDbd2, FEMax = FEMax, FEMin = FEMin, iInj0Pu = iInj0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.ElectricalControlPV wecc_reec(Id0Pu = Id0Pu, IMaxPu = IMaxPu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PInj0Pu = PInj0Pu, PPriority = PPriority, PfFlag = PfFlag, PMaxPu = PMaxPu, PMinPu = PMinPu, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, Tiq = Tiq, tP = tP, tPord = tPord, tRv = tRv, UInj0Pu = UInj0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, DPMax = DPMax, DPMin = DPMin, Dbd1 = Dbd1, Dbd2 = Dbd2) annotation(
    Placement(visible = true, transformation(origin = {-8.13151, -18.1384}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.GeneratorControl wecc_regc(IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, RateFlag = RateFlag, tFilterGC = tFilterGC, tG = tG, Rrpwr = Rrpwr, UInj0Pu = UInj0Pu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = - PInj0Pu * (SNom / SystemBase.SnRef), Q0Pu = - QInj0Pu * (SNom / SystemBase.SnRef), SNom = SNom, U0Pu = UInj0Pu, UPhase0 = UPhaseInj0, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, -18}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {150, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit P0Pu "Start value of active power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at regulated bus in rad";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit iInj0Pu "Start value of complex current at injector in pu (base UNom, SNom) (generator convention)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.Angle UPhaseInj0 "Start value of voltage angle at injector";

equation
  line.switchOffSignal1.value = injector.switchOffSignal1.value;
  line.switchOffSignal2.value = injector.switchOffSignal2.value;
  connect(wecc_repc.QInjRefPu, wecc_reec.QInjRefPu) annotation(
    Line(points = {{-29, -24}, {-19, -24}}, color = {0, 0, 127}));
  connect(line.terminal2, injector.terminal) annotation(
    Line(points = {{110, -10}, {91.5, -10}}, color = {0, 0, 255}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{3, -24}, {29, -24}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{3, -18}, {29, -18}}, color = {255, 0, 255}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{3, -12}, {29, -12}}, color = {0, 0, 127}));
  connect(wecc_repc.PInjRefPu, wecc_reec.PInjRefPu) annotation(
    Line(points = {{-29, -12}, {-19, -12}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-99, 30}, {-91, 30}}, color = {0, 0, 127}));
  connect(wecc_regc.idRefPu, injector.idPu) annotation(
    Line(points = {{51, -24}, {68.5, -24}}, color = {0, 0, 127}));
  connect(wecc_regc.iqRefPu, injector.iqPu) annotation(
    Line(points = {{51, -14}, {68.5, -14}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-69, 41}, {-60, 41}, {-60, -10}, {-51, -10}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-110, -20}, {-51, -20}, {-51, -20}, {-51, -20}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_regc.UPu) annotation(
    Line(points = {{92, -26}, {97, -26}, {97, -34}, {34, -34}, {34, -29}, {34, -29}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_reec.UPu) annotation(
    Line(points = {{92, -26}, {97, -26}, {97, -34}, {-2, -34}, {-2, -29}}, color = {0, 0, 127}));
  connect(injector.PInjPuSn, wecc_reec.PInjPu) annotation(
    Line(points = {{92, -22}, {99, -22}, {99, -36}, {-8, -36}, {-8, -29}}, color = {0, 0, 127}));
  connect(injector.QInjPuSn, wecc_reec.QInjPu) annotation(
    Line(points = {{92, -18}, {101, -18}, {101, -38}, {-17, -38}, {-17, -29}}, color = {0, 0, 127}));
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{130, -10}, {140, -10}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{160, -10}, {180, -10}}, color = {0, 0, 255}));
  connect(measurements.PPu, wecc_repc.PRegPu) annotation(
    Line(points = {{144, 1}, {144, 10}, {-32, 10}, {-32, -7}}, color = {0, 0, 127}));
  connect(measurements.QPu, wecc_repc.QRegPu) annotation(
    Line(points = {{148, 1}, {148, 12}, {-37, 12}, {-37, -7}}, color = {0, 0, 127}));
  connect(measurements.uPu, wecc_repc.uPu) annotation(
    Line(points = {{152, 1}, {152, 14}, {-43, 14}, {-43, -7}}, color = {85, 170, 255}));
  connect(measurements.iPu, wecc_repc.iPu) annotation(
    Line(points = {{156, 1}, {156, 16}, {-48, 16}, {-48, -7}}, color = {85, 170, 255}));
  connect(measurements.uPu, pll.uPu) annotation(
    Line(points = {{152, 1}, {152, 49}, {-95, 49}, {-95, 42}, {-91, 42}}, color = {85, 170, 255}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-110, 0}, {-80, 0}, {-80, -14}, {-51, -14}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-110, -40}, {-80, -40}, {-80, -24}, {-51, -24}}, color = {0, 0, 127}));

  annotation(
    Documentation(preferredView = "diagram",
    info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
  Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -50}, {170, 50}})));
end PVCurrentSource;
