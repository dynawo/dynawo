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

model PVCurrentSource "WECC PV model with a current source as interface with the grid"

  import Modelica;
  import Modelica.ComplexMath;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.WECC.Parameters;

  extends Parameters.Params_PlantControl;
  extends Parameters.Params_ElectricalControl;
  extends Parameters.Params_GeneratorControl;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in p.u (base SnRef)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in p.u (base SnRef)";

  parameter Types.PerUnit P0Pu "Start value of active power at regulated bus in p.u (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at regulated bus in p.u (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in p.u.";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at regulated bus in rad";

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {180, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 8.88178e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PGen0Pu) "Active power reference in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QGen0Pu) "Reactive power reference in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput OmegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in p.u (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.PerUnit PGenPu "Active power at regulated bus in p.u (generator convention) (base SnRef)";
  Types.PerUnit QGenPu "Reactive power at regulated bus in p.u (generator convention) (base SnRef)";

  Dynawo.Electrical.Buses.Bus bus annotation(
    Placement(visible = true, transformation(origin = {150, -10}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {120, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.PlantControl wecc_repc(Ddn = Ddn, Dup = Dup, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = PGen0Pu, PInj0Pu = PInj0Pu, PMax = PMax, PMin = PMin, QGen0Pu = QGen0Pu, QInj0Pu = QInj0Pu, QMax = QMax, QMin = QMin, Rc = RPu * SNom / SystemBase.SnRef, RefFlag = RefFlag, TFltr = TFltr, Tft = Tft, Tfv = Tfv, Tlag = Tlag, Tp = Tp, U0Pu = U0Pu, UInj0Pu = UInj0Pu, VcompFlag = VcompFlag, Vfrz = Vfrz, Xc = XPu * SNom / SystemBase.SnRef, dbd = dbd, eMax = eMax, eMin = eMin, fdbd1 = fdbd1, fdbd2 = fdbd2, feMax = feMax, feMin = feMin, iInj0Pu = iInj0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.ElectricalControl wecc_reec(Id0Pu = Id0Pu,Imax = Imax, Iq0Pu = Iq0Pu, Iqh1 = Iqh1, Iql1 = Iql1, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PInj0Pu = PInj0Pu, PPriority = PPriority, PfFlag = PfFlag, Pmax = Pmax, Pmin = Pmin, QFlag = QFlag, QInj0Pu = QInj0Pu, Qmax = Qmax, Qmin = Qmin, Tiq = Tiq, Tp = Tp, Tpord = Tpord, Trv = Trv, UInj0Pu = UInj0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, VFlag = VFlag, Vmax = Vmax, Vmin = Vmin, Vref0 = Vref0, dPmax = dPmax, dPmin = dPmin, dbd1 = dbd1, dbd2 = dbd2) annotation(
    Placement(visible = true, transformation(origin = {0, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.GeneratorControl wecc_regc(Iqrmax = Iqrmax, Iqrmin = Iqrmin, RateFlag = RateFlag, Tfltr = Tfltr, Tg = Tg, rrpwr = rrpwr, UInj0Pu = UInj0Pu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = -Iq0Pu, P0Pu = - PInj0Pu * (SNom / SystemBase.SnRef), Q0Pu = - QInj0Pu * (SNom / SystemBase.SnRef), SNom = SNom, U0Pu = UInj0Pu, UPhase0 = UPhaseInj0, i0Pu = -iInj0Pu * (SNom / SystemBase.SnRef), s0Pu = s0Pu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, -18}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = 20, Kp = 3, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

//protected
  final parameter Types.ComplexPerUnit u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  final parameter Types.ComplexPerUnit s0Pu = Complex(P0Pu, Q0Pu);
  final parameter Types.ComplexPerUnit i0Pu = ComplexMath.conj(s0Pu / u0Pu);
  final parameter Types.ComplexPerUnit ZPu = Complex(RPu, XPu);
  final parameter Types.PerUnit PGen0Pu = - P0Pu * SystemBase.SnRef / SNom;
  final parameter Types.PerUnit QGen0Pu = - Q0Pu * SystemBase.SnRef / SNom;
  final parameter Types.ComplexPerUnit iInj0Pu = -i0Pu * SystemBase.SnRef / SNom;
  final parameter Types.ComplexPerUnit uInj0Pu = u0Pu -  ZPu * i0Pu;
  final parameter Types.ComplexPerUnit sInj0Pu = uInj0Pu * ComplexMath.conj(iInj0Pu);
  final parameter Types.PerUnit UInj0Pu = ComplexMath.'abs'(uInj0Pu);
  final parameter Types.Angle UPhaseInj0 = ComplexMath.arg(uInj0Pu);
  final parameter Types.PerUnit PInj0Pu = ComplexMath.real(sInj0Pu);
  final parameter Types.PerUnit QInj0Pu = ComplexMath.imag(sInj0Pu);
  final parameter Types.PerUnit PF0 = PInj0Pu / max(ComplexMath.'abs'(sInj0Pu), 0.001);
  final parameter Types.PerUnit Id0Pu = cos(UPhaseInj0) * iInj0Pu.re + sin(UPhaseInj0) * iInj0Pu.im;
  final parameter Types.PerUnit Iq0Pu = sin(UPhaseInj0) * iInj0Pu.re - cos(UPhaseInj0) * iInj0Pu.im;

equation
  connect(wecc_repc.QInjRefPu, wecc_reec.QInjRefPu) annotation(
    Line(points = {{-29, -24}, {-11, -24}}, color = {0, 0, 127}));
  connect(bus.terminal, line.terminal1) annotation(
    Line(points = {{150, -10}, {130, -10}}, color = {0, 0, 255}));
  connect(line.terminal2, injector.terminal) annotation(
    Line(points = {{110, -10}, {91.5, -10}}, color = {0, 0, 255}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{11, -24}, {29, -24}}, color = {0, 0, 127}));
  connect(wecc_reec.FRTon, wecc_regc.FRTon) annotation(
    Line(points = {{11, -18}, {29, -18}}, color = {255, 0, 255}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{11, -12}, {29, -12}}, color = {0, 0, 127}));
  connect(wecc_repc.PInjRefPu, wecc_reec.PInjRefPu) annotation(
    Line(points = {{-29, -12}, {-11, -12}}, color = {0, 0, 127}));
  connect(terminal, bus.terminal) annotation(
    Line(points = {{180, -10}, {150, -10}}, color = {0, 0, 255}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-99, 30}, {-91, 30}}, color = {0, 0, 127}));
  PGenPu = -ComplexMath.real(line.terminal1.V * ComplexMath.conj(line.terminal1.i));
  QGenPu = -ComplexMath.imag(line.terminal1.V * ComplexMath.conj(line.terminal1.i));
  pll.uPu = line.terminal1.V;
  wecc_repc.uPu = line.terminal1.V;
  wecc_repc.iPu = - line.terminal1.i * SystemBase.SnRef / SNom;
  wecc_repc.PRegPu = PGenPu * SystemBase.SnRef / SNom;
  wecc_repc.QRegPu = QGenPu * SystemBase.SnRef / SNom;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  injector.switchOffSignal1.value = false;
  injector.switchOffSignal2.value = false;
  injector.switchOffSignal3.value = false;
  connect(wecc_regc.idRefPu, injector.idPu) annotation(
    Line(points = {{51, -24}, {68.5, -24}}, color = {0, 0, 127}));
  connect(wecc_regc.iqRefPu, injector.iqPu) annotation(
    Line(points = {{51, -14}, {68.5, -14}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.OmegaPu) annotation(
    Line(points = {{-69, 41}, {-60, 41}, {-60, -10}, {-51, -10}}, color = {0, 0, 127}));
  connect(OmegaRefPu, wecc_repc.OmegaRefPu) annotation(
    Line(points = {{-110, 0}, {-70, 0}, {-70, -14}, {-51, -14}, {-51, -14}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu_PC) annotation(
    Line(points = {{-110, -20}, {-51, -20}, {-51, -20}, {-51, -20}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu_PC) annotation(
    Line(points = {{-110, -40}, {-60, -40}, {-60, -24}, {-51, -24}, {-51, -24}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_regc.UPu) annotation(
    Line(points = {{92, -26}, {97, -26}, {97, -34}, {34, -34}, {34, -29}, {34, -29}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_reec.UPu) annotation(
    Line(points = {{92, -26}, {97, -26}, {97, -34}, {6, -34}, {6, -29}, {6, -29}}, color = {0, 0, 127}));
  connect(injector.PInjPuSn, wecc_reec.PInjPu) annotation(
    Line(points = {{92, -22}, {99, -22}, {99, -36}, {0, -36}, {0, -29}, {0, -29}}, color = {0, 0, 127}));
  connect(injector.QInjPuSn, wecc_reec.QInjPu) annotation(
    Line(points = {{92, -18}, {101, -18}, {101, -38}, {-6, -38}, {-6, -29}, {-6, -29}}, color = {0, 0, 127}));

  annotation(
    Documentation(preferredView = "diagram",
    info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
  Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -50}, {170, 50}})));
end PVCurrentSource;
