within Dynawo.Electrical.Photovoltaics.WECC;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PVVoltageSource "WECC PV model with a voltage source as interface with the grid"
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
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in p.u (base SnRef)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in p.u (base SnRef)";

  parameter Types.PerUnit P0Pu "Start value of active power at regulated bus in p.u (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at regulated bus in p.u (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in p.u.";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at regulated bus in rad";

  parameter Types.Time Te "Emulated delay in converter controls in seconds (Cannot be zero, typical: 0.02..0.05)";
  parameter Types.PerUnit RSourcePu "Source resistance in per unit (typically set to zero, typical: 0..0.01)";
  parameter Types.PerUnit XSourcePu "Source reactance in per unit (typical: 0.05..0.2)";

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {186, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 8.88178e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = - P0Pu * SystemBase.SnRef / SNom) "Active power reference in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = - Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput OmegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in p.u (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {137, -13}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.PlantControl wecc_repc(Ddn = Ddn, Dup = Dup, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = - P0Pu * SystemBase.SnRef / SNom, PInj0Pu = PInj0Pu, PMax = PMax, PMin = PMin, QGen0Pu = - Q0Pu * SystemBase.SnRef / SNom, QInj0Pu = QInj0Pu, QMax = QMax, QMin = QMin, Rc = RPu * SNom / SystemBase.SnRef, RefFlag = RefFlag, TFltr = TFltr, Tft = Tft, Tfv = Tfv, Tlag = Tlag, Tp = Tp, U0Pu = U0Pu, UInj0Pu = UInj0Pu, VcompFlag = VcompFlag, Vfrz = Vfrz, Xc = XPu * SNom / SystemBase.SnRef, dbd = dbd, eMax = eMax, eMin = eMin, fdbd1 = fdbd1, fdbd2 = fdbd2, feMax = feMax, feMin = feMin, iInj0Pu = iInj0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.ElectricalControl wecc_reec(Id0Pu = Id0Pu, IMax = IMax, Iq0Pu = Iq0Pu, Iqh1 = Iqh1, Iql1 = Iql1, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PInj0Pu = PInj0Pu, PPriority = PPriority, PfFlag = PfFlag, Pmax = Pmax, Pmin = Pmin, QFlag = QFlag, QInj0Pu = QInj0Pu, Qmax = Qmax, Qmin = Qmin, Tiq = Tiq, Tp = Tp, Tpord = Tpord, Trv = Trv, UInj0Pu = UInj0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, VFlag = VFlag, Vmax = Vmax, Vmin = Vmin, Vref0 = Vref0, dPmax = dPmax, dPmin = dPmin, dbd1 = dbd1, dbd2 = dbd2) annotation(
    Placement(visible = true, transformation(origin = {0, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.GeneratorControl wecc_regc(Iqrmax = Iqrmax, Iqrmin = Iqrmin, RateFlag = RateFlag, Tfltr = Tfltr, Tg = Tg, rrpwr = rrpwr, UInj0Pu = UInj0Pu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom)  annotation(
    Placement(visible = true, transformation(origin = {160, -13}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VSourceRef VSourceRef(R = RSourcePu, Te = 0.005, Ui0Pu = Ui0Pu, Ur0Pu = Ur0Pu, X= XSourcePu, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {73, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorURI injector(P0Pu = -PInj0Pu * (SNom / SystemBase.SnRef), Q0Pu = -QInj0Pu * (SNom / SystemBase.SnRef), SNom = SNom, U0Pu = UInj0Pu, UPhase0 = UPhaseInj0, Ui0Pu = Ui0Pu, Ur0Pu = Ur0Pu, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = uInj0Pu, RSourcePu = RSourcePu, XSourcePu = XSourcePu) annotation(
    Placement(visible = true, transformation(origin = {105, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in p.u (base UNom)";
  parameter Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in p.u (base SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in p.u (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit iInj0Pu "Start value of complex current at injector in p.u (base UNom, SNom) (generator convention)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in p.u (base UNom)";
  parameter Types.ComplexPerUnit sInj0Pu "Start value of complex apparent power at injector in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit QInj0Pu "Start value of reactive power at injector in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit UInj0Pu "Start value of voltage module at injector in p.u (base UNom)";
  parameter Types.Angle UPhaseInj0 "Start value of voltage angle at injector in p.u (base UNom)";
  parameter Types.PerUnit PF0 "Start value of power factor";
  parameter Types.PerUnit Id0Pu "Start value of d-axs current at injector in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of q-axis current at injector in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Ur0Pu "Start value of real part of voltage at injector in p.u (base UNom) ";
  parameter Types.PerUnit Ui0Pu "Start value of imaginary part of voltage at injector in p.u (base UNom) ";

equation
  connect(wecc_repc.QInjRefPu, wecc_reec.QInjRefPu) annotation(
    Line(points = {{-29, -24}, {-11, -24}}, color = {0, 0, 127}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{11, -24}, {29, -24}}, color = {0, 0, 127}));
  connect(wecc_reec.FRTon, wecc_regc.FRTon) annotation(
    Line(points = {{11, -18}, {29, -18}}, color = {255, 0, 255}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{11, -12}, {29, -12}}, color = {0, 0, 127}));
  connect(wecc_repc.PInjRefPu, wecc_reec.PInjRefPu) annotation(
    Line(points = {{-29, -12}, {-11, -12}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-99, 30}, {-91, 30}}, color = {0, 0, 127}));
  connect(wecc_regc.idRefPu, VSourceRef.idPu) annotation(
    Line(points = {{51, -24}, {62, -24}}, color = {0, 0, 127}));
  connect(wecc_regc.iqRefPu, VSourceRef.iqPu) annotation(
    Line(points = {{51, -14}, {54.5, -14}, {54.5, -18}, {62, -18}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.OmegaPu) annotation(
    Line(points = {{-69, 41}, {-60, 41}, {-60, -10}, {-51, -10}}, color = {0, 0, 127}));
  connect(OmegaRefPu, wecc_repc.OmegaRefPu) annotation(
    Line(points = {{-110, 0}, {-70, 0}, {-70, -14}, {-51, -14}, {-51, -14}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu_PC) annotation(
    Line(points = {{-110, -20}, {-51, -20}, {-51, -20}, {-51, -20}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu_PC) annotation(
    Line(points = {{-110, -40}, {-60, -40}, {-60, -24}, {-51, -24}, {-51, -24}}, color = {0, 0, 127}));
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{147, -13}, {150, -13}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{170, -13}, {178, -13}, {178, -10}, {186, -10}}, color = {0, 0, 255}));
  connect(measurements.PPu, wecc_repc.PRegPu) annotation(
    Line(points = {{154, -2}, {154, 10}, {-32, 10}, {-32, -7}}, color = {0, 0, 127}));
  connect(measurements.QPu, wecc_repc.QRegPu) annotation(
    Line(points = {{158, -2}, {158, 12}, {-37, 12}, {-37, -7}}, color = {0, 0, 127}));
  connect(measurements.uPu, wecc_repc.uPu) annotation(
    Line(points = {{162, -2}, {162, 14}, {-43, 14}, {-43, -7}}, color = {85, 170, 255}));
  connect(measurements.iPu, wecc_repc.iPu) annotation(
    Line(points = {{166, -2}, {166, 16}, {-48, 16}, {-48, -7}}, color = {85, 170, 255}));
  connect(measurements.uPu, pll.uPu) annotation(
    Line(points = {{162, -2}, {162, 49}, {-95, 49}, {-95, 42}, {-91, 42}}, color = {85, 170, 255}));
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  connect(VSourceRef.UReSource, injector.urPu) annotation(
    Line(points = {{83, -14}, {94, -14}}, color = {0, 0, 127}));
  connect(VSourceRef.UImSource, injector.uiPu) annotation(
    Line(points = {{83, -22}, {94, -22}}, color = {0, 0, 127}));
  connect(injector.uPu, VSourceRef.uPu) annotation(
    Line(points = {{115, -10},{120, -10},{120, -4},  {114.5, -4}, {59, -4}, {59, -12},  {63, -12}}, color = {0, 0, 127}));
  connect(injector.terminal, line.terminal2) annotation(
    Line(points = {{117, -13}, {127, -13}}, color = {0, 0, 255}));
  connect(injector.PInjPuSn, wecc_reec.PInjPu) annotation(
    Line(points = {{117, -22}, {122, -22}, {122, -40}, {0, -40}, {0, -29}}, color = {0, 0, 127}));
  connect(injector.QInjPuSn, wecc_reec.QInjPu) annotation(
    Line(points = {{117, -17}, {125, -17}, {125, -43}, {-6, -43}, {-6, -29}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_reec.UPu) annotation(
    Line(points = {{115, -26},{120, -26},{120, -38}, {6, -38}, {6, -29}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_regc.UPu) annotation(
    Line(points = {{117, -26}, {120, -26}, {120, -38}, {34, -38}, {34, -29}}, color = {0, 0, 127}));
  annotation(
    Documentation(preferredView = "diagram",
    info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
  Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -50}, {170, 50}})));
end PVVoltageSource;
