within Dynawo.Electrical.Photovoltaics.WECC;

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

model PVVoltageSourceA "WECC PV model with a voltage source as interface with the grid (REPC-A REEC-A REGC-B)"

/*                uSourcePu                                uInjPu                      uPu
     --------         |                                       |                         |
    | Source |--------+---->>--------RSourcePu+jXSourcePu-----+------RPu+jXPu-----<<----+---- terminal
     --------           iSourcePu                                                 iPu
*/
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsREGC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsREPC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsVSourceRef;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef)";

  // REEC-A parameters
  parameter Types.VoltageComponent VDLIp11 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIp12 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIp21 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIp22 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIp31 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIp32 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIp41 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIp42 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIq11 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIq12 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIq21 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIq22 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIq31 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIq32 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIq41 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIq42 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIpPoints[:, :] = [VDLIp11, VDLIp12; VDLIp21, VDLIp22; VDLIp31, VDLIp32; VDLIp41, VDLIp42] "Pair of points for voltage-dependent active current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageComponent VDLIqPoints[:, :] = [VDLIq11, VDLIq12; VDLIq21, VDLIq22; VDLIq31, VDLIq32; VDLIq41, VDLIq42] "Pair of points for voltage-dependent reactive current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.Time tHoldIpMax "Time delay for which the active current limit (ipMaxPu) is held after voltage dip in s" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.Time tHoldIq "Absolute value of tHoldIq defines seconds to hold current injection after voltage dip ended. tHoldIq > 0 for constant, 0 for no injection after voltage dip, tHoldIq < 0 for voltage-dependent injection (typical: -1 .. 1 s)"  annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit IqFrzPu "Constant reactive current injection value in pu (base UNom, SNom) (typical: -0.1 .. 0.1 pu)" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Boolean PFlag "Power reference flag: const. Pref (0) or consider generator speed (1)" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageModulePu VRef1Pu "User-defined reference/bias on the inner-loop voltage control in pu (base UNom) (typical: 0 pu)" annotation(
    Dialog(tab = "Electrical Control"));

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Inputs
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-79, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = - P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = - Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REPC.REPCa wecc_repc(DDn = DDn, DUp = DUp, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = - P0Pu * SystemBase.SnRef / SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QGen0Pu = - Q0Pu * SystemBase.SnRef / SNom, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, U0Pu = U0Pu, UInj0Pu = UInj0Pu, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, iInj0Pu = - i0Pu * SystemBase.SnRef / SNom, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REEC.REECa wecc_reec(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu,Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqFrzPu = IqFrzPu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PFlag = PFlag, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, UInj0Pu = UInj0Pu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIp31 = VDLIp31, VDLIp32 = VDLIp32, VDLIp41 = VDLIp41, VDLIp42 = VDLIp42, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VDLIq31 = VDLIq31, VDLIq32 = VDLIq32, VDLIq41 = VDLIq41, VDLIq42 = VDLIq42, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, VUpPu = VUpPu, tHoldIpMax = tHoldIpMax, tHoldIq = tHoldIq, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv)  annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REGC.REGCbCS wecc_regc(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, RateFlag = RateFlag, RrpwrPu = RrpwrPu, UInj0Pu = UInj0Pu, tFilterGC = tFilterGC, tG = tG) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-185, 38}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VSourceRef VSourceRef(Id0Pu = Id0Pu, Iq0Pu = -Iq0Pu, RSourcePu = RSourcePu, UdInj0Pu = UdInj0Pu, UqInj0Pu = UqInj0Pu, XSourcePu = XSourcePu, tE = tE, uInj0Pu = uInj0Pu, uSource0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorURI injector(i0Pu = i0Pu, u0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements1(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line source(BPu = 0, GPu = 0, RPu = RSourcePu, XPu = XSourcePu) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ComplexPerUnit i0Pu "Start value of complex current in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit P0Pu "Start value of active power at terminal in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at terminal in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage at injector in pu (base UNom)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage at injector in pu (base UNom)";
  parameter Types.ComplexPerUnit uSource0Pu "Start value of complex voltage at source in pu (base UNom)";

  final parameter Types.PerUnit URef0Pu = if VCompFlag == true then UInj0Pu else (U0Pu + Kc * Q0Pu * SystemBase.SnRef / SNom) "Start value of voltage setpoint for plant level control, calculated depending on VcompFlag, in pu (base UNom)";

equation
  line.switchOffSignal1.value = injector.switchOffSignal1.value;
  source.switchOffSignal1.value = injector.switchOffSignal1.value;
  line.switchOffSignal2.value = injector.switchOffSignal2.value;
  source.switchOffSignal2.value = injector.switchOffSignal2.value;

  connect(wecc_repc.QInjRefPu, wecc_reec.QInjRefPu) annotation(
    Line(points = {{-109, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(wecc_repc.PInjRefPu, wecc_reec.PInjRefPu) annotation(
    Line(points = {{-109, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-180, 38}, {-171, 38}}, color = {0, 0, 127}));
  connect(wecc_regc.idRefPu, VSourceRef.idPu) annotation(
    Line(points = {{-29, -6}, {-11, -6}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-190, 0}, {-160, 0}, {-160, -2}, {-131, -2}}, color = {0, 0, 127}));
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{140, 0}, {150, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{170, 0}, {190, 0}}, color = {0, 0, 255}));
  connect(measurements.PPu, wecc_repc.PRegPu) annotation(
    Line(points = {{154, 11}, {154, 20}, {-112, 20}, {-112, 11}}, color = {0, 0, 127}));
  connect(measurements.QPu, wecc_repc.QRegPu) annotation(
    Line(points = {{158, 11}, {158, 30}, {-117, 30}, {-117, 11}}, color = {0, 0, 127}));
  connect(measurements.uPu, wecc_repc.uPu) annotation(
    Line(points = {{162, 11}, {162, 40}, {-123, 40}, {-123, 11}}, color = {85, 170, 255}));
  connect(measurements.iPu, wecc_repc.iPu) annotation(
    Line(points = {{166, 11}, {166, 50}, {-128, 50}, {-128, 11}}, color = {85, 170, 255}));
  connect(VSourceRef.urSourcePu, injector.urPu) annotation(
    Line(points = {{11, 4}, {29, 4}}, color = {0, 0, 127}));
  connect(VSourceRef.uiSourcePu, injector.uiPu) annotation(
    Line(points = {{11, -4}, {29, -4}}, color = {0, 0, 127}));
  connect(measurements1.terminal2, line.terminal2) annotation(
    Line(points = {{110, 0}, {120, 0}}, color = {0, 0, 255}));
  connect(measurements1.PPu, wecc_reec.PInjPu) annotation(
    Line(points = {{94, -11}, {94, -40}, {-80, -40}, {-80, -11}}, color = {0, 0, 127}));
  connect(measurements1.QPu, wecc_reec.QInjPu) annotation(
    Line(points = {{98, -11}, {98, -50}, {-89, -50}, {-89, -11}}, color = {0, 0, 127}));
  connect(measurements1.UPu, wecc_regc.UPu) annotation(
    Line(points = {{90, -11}, {90, -30}, {-46, -30}, {-46, -11}}, color = {0, 0, 127}));
  connect(measurements1.UPu, wecc_reec.UPu) annotation(
    Line(points = {{90, -11}, {90, -30}, {-74, -30}, {-74, -11}}, color = {0, 0, 127}));
  connect(measurements1.uPu, VSourceRef.uInjPu) annotation(
    Line(points = {{102, -11}, {102, -20}, {0, -20}, {0, -11}}, color = {85, 170, 255}));
  connect(wecc_regc.iqRefPu, VSourceRef.iqPu) annotation(
    Line(points = {{-29, 4}, {-11, 4}}, color = {0, 0, 127}));
  connect(injector.terminal, source.terminal1) annotation(
    Line(points = {{51.5, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(source.terminal2, measurements1.terminal1) annotation(
    Line(points = {{80, 0}, {90, 0}}, color = {0, 0, 255}));
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-149, 49}, {-140, 49}, {-140, 8}, {-131, 8}}, color = {0, 0, 127}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-190, 20}, {-160, 20}, {-160, 4}, {-131, 4}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-131, -6}}, color = {0, 0, 127}));
  connect(measurements.uPu, pll.uPu) annotation(
    Line(points = {{162, 11}, {162, 60}, {-180, 60}, {-180, 50}, {-171, 50}}, color = {85, 170, 255}));
  connect(URefPu, wecc_repc.URefPu) annotation(
    Line(points = {{-190, -40}, {-120, -40}, {-120, -11}}, color = {0, 0, 127}));
  connect(PFaRef, wecc_reec.PFaRef) annotation(
    Line(points = {{-79, 70}, {-79, 11}}, color = {0, 0, 127}));
  connect(OmegaRef.y, wecc_reec.omegaGPu) annotation(
    Line(points = {{-179, 38}, {-175, 38}, {-175, -60}, {-85, -60}, {-85, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {180, 60}})));
end PVVoltageSourceA;
