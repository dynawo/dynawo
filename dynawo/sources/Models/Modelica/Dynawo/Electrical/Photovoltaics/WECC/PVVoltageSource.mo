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

model PVVoltageSource "WECC PV model with a voltage source as interface with the grid"

/*                uSourcePu                                uInjPu                      uPu
     --------         |                                       |                         |
    | Source |--------+---->>--------RSourcePu+jXSourcePu-----+------RPu+jXPu-----<<----+---- terminal
     --------           iSourcePu                                                 iPu
*/

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.WECC.Parameters;

  extends Parameters.Params_PlantControl;
  extends Parameters.Params_ElectricalControl;
  extends Parameters.Params_GeneratorControl;
  extends Parameters.Params_PLL;
  extends Parameters.Params_VSourceRef;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef)";

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {190, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 8.88178e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = - P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = - Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Lines.Line line(RPu = RPu , XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {130, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.PlantControl wecc_repc(DDn = DDn, DUp = DUp, Dbd = Dbd, EMax = EMax, EMin = EMin, FDbd1 = FDbd1, FDbd2 = FDbd2, FEMax = FEMax, FEMin = FEMin, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = - P0Pu * SystemBase.SnRef / SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QGen0Pu = - Q0Pu * SystemBase.SnRef / SNom, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, U0Pu = U0Pu, UInj0Pu = UInj0Pu, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, iInj0Pu = - i0Pu * SystemBase.SnRef / SNom, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.ElectricalControl wecc_reec(DPMax = DPMax, DPMin = DPMin, Dbd1 = Dbd1, Dbd2 = Dbd2, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PPriority = PPriority, PfFlag = PfFlag, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, Tiq = Tiq, UInj0Pu = UInj0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, tP = tP, tPord = tPord, tRv = tRv) annotation(
    Placement(visible = true, transformation(origin = {-80, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.GeneratorControl wecc_regc(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, RateFlag = RateFlag, Rrpwr = Rrpwr, UInj0Pu = UInj0Pu, tFilterGC = tFilterGC, tG = tG) annotation(
    Placement(visible = true, transformation(origin = {-40, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-190, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom)  annotation(
    Placement(visible = true, transformation(origin = {160, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VSourceRef VSourceRef(Id0Pu = Id0Pu, Iq0Pu = -Iq0Pu, RSourcePu = RSourcePu, UdInj0Pu = UdInj0Pu, UqInj0Pu = UqInj0Pu, XSourcePu = XSourcePu, tE = tE, uInj0Pu = uInj0Pu, uSource0Pu = uSource0Pu)  annotation(
    Placement(visible = true, transformation(origin = {0, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorURI injector(i0Pu = i0Pu, u0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements1(SNom = SNom)  annotation(
    Placement(visible = true, transformation(origin = {100, -10}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line source(BPu = 0, GPu = 0, RPu = RSourcePu, XPu = XSourcePu)  annotation(
    Placement(visible = true, transformation(origin = {70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ComplexPerUnit uSource0Pu "Start value of complex voltage at source in pu (base UNom)";
  parameter Types.PerUnit P0Pu "Start value of active power at terminal in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at terminal in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector in pu (base SNom) (generator convention)";
  parameter Types.PerUnit QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)";
  parameter Types.PerUnit UInj0Pu "Start value of voltage module at injector in pu (base UNom)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage at injector in pu (base UNom)";
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage at injector in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit Id0Pu "Start value of d-axis current in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of q-axis current in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit PF0 "Start value of power factor";

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  source.switchOffSignal1.value = false;
  source.switchOffSignal2.value = false;
  injector.switchOffSignal1.value = false;
  injector.switchOffSignal2.value = false;
  injector.switchOffSignal3.value = false;
  connect(wecc_repc.QInjRefPu, wecc_reec.QInjRefPu) annotation(
    Line(points = {{-109, -16}, {-91, -16}}, color = {0, 0, 127}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{-69, -16}, {-51, -16}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{-69, -10}, {-51, -10}}, color = {255, 0, 255}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{-69, -4}, {-51, -4}}, color = {0, 0, 127}));
  connect(wecc_repc.PInjRefPu, wecc_reec.PInjRefPu) annotation(
    Line(points = {{-109, -4}, {-91, -4}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-179, 38}, {-171, 38}}, color = {0, 0, 127}));
  connect(wecc_regc.idRefPu, VSourceRef.idPu) annotation(
    Line(points = {{-29, -16}, {-11, -16}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-190, -12}, {-131, -12}}, color = {0, 0, 127}));
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{140, -10}, {150, -10}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{170, -10}, {190, -10}}, color = {0, 0, 255}));
  connect(measurements.PPu, wecc_repc.PRegPu) annotation(
    Line(points = {{154, 1}, {154, 10}, {-112, 10}, {-112, 1}}, color = {0, 0, 127}));
  connect(measurements.QPu, wecc_repc.QRegPu) annotation(
    Line(points = {{158, 1}, {158, 12}, {-117, 12}, {-117, 1}}, color = {0, 0, 127}));
  connect(measurements.uPu, wecc_repc.uPu) annotation(
    Line(points = {{162, 1}, {162, 14}, {-123, 14}, {-123, 1}}, color = {85, 170, 255}));
  connect(measurements.iPu, wecc_repc.iPu) annotation(
    Line(points = {{166, 1}, {166, 16}, {-128, 16}, {-128, 1}}, color = {85, 170, 255}));
  connect(VSourceRef.urSourcePu, injector.urPu) annotation(
    Line(points = {{11, -6}, {29, -6}}, color = {0, 0, 127}));
  connect(VSourceRef.uiSourcePu, injector.uiPu) annotation(
    Line(points = {{11, -14}, {29, -14}}, color = {0, 0, 127}));
  connect(measurements1.terminal2, line.terminal2) annotation(
    Line(points = {{110, -10}, {120, -10}}, color = {0, 0, 255}));
  connect(measurements1.PPu, wecc_reec.PInjPu) annotation(
    Line(points = {{94, -21}, {93.875, -21}, {93.875, -47}, {-80, -47}, {-80, -21}}, color = {0, 0, 127}));
  connect(measurements1.QPu, wecc_reec.QInjPu) annotation(
    Line(points = {{98, -21}, {98, -49}, {-86, -49}, {-86, -21}}, color = {0, 0, 127}));
  connect(measurements1.UPu, wecc_regc.UPu) annotation(
    Line(points = {{90, -21}, {90, -45}, {-46, -45}, {-46, -21}}, color = {0, 0, 127}));
  connect(measurements1.UPu, wecc_reec.UPu) annotation(
    Line(points = {{90, -21}, {90, -45}, {-74, -45}, {-74, -21}}, color = {0, 0, 127}));
  connect(measurements1.uPu, VSourceRef.uInjPu) annotation(
    Line(points = {{102, -21}, {102, -40}, {0, -40}, {0, -21}}, color = {85, 170, 255}));
  connect(wecc_regc.iqRefPu, VSourceRef.iqPu) annotation(
    Line(points = {{-29, -6}, {-11, -6}}, color = {0, 0, 127}));
  connect(injector.terminal, source.terminal1) annotation(
    Line(points = {{51.5, -10}, {60, -10}}, color = {0, 0, 255}));
  connect(source.terminal2, measurements1.terminal1) annotation(
    Line(points = {{80, -10}, {90, -10}}, color = {0, 0, 255}));
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-149, 49}, {-140, 49}, {-140, -2}, {-131, -2}}, color = {0, 0, 127}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-190, 8}, {-160, 8}, {-160, -6}, {-131, -6}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-190, -32}, {-160, -32}, {-160, -16}, {-131, -16}}, color = {0, 0, 127}));
  connect(measurements.uPu, pll.uPu) annotation(
    Line(points = {{162, 1}, {162, 58}, {-177, 58}, {-177, 50}, {-171, 50}}, color = {85, 170, 255}));

  annotation(
    Documentation(preferredView = "diagram",
    info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
  Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {180, 60}})));
end PVVoltageSource;
