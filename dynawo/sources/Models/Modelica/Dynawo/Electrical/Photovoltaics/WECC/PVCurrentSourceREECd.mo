within Dynawo.Electrical.Photovoltaics.WECC;

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

model PVCurrentSourceREECd "WECC PV model with a current source as interface with the grid"
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.REECdParameters;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.REGCaParameters;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.REPCaParameters;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)" annotation(
    Dialog(tab = "Line"));
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)" annotation(
    Dialog(tab = "Line"));

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary power at injector terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-100, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-80, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REPC.REPCa repc(DDnPu = DDnPu, DUpPu = DUpPu, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = -P0Pu * SystemBase.SnRef / SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QGen0Pu = -Q0Pu * SystemBase.SnRef / SNom, QInj0Pu = QInj0Pu, QInjRef0Pu = if not PfFlag and not UFlag and QFlag then UInj0Pu else QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, U0Pu = U0Pu, UCompFlag = UCompFlag, UFrzPu = UFrzPu, UInj0Pu = UInj0Pu, XcPu = XPu, iInj0Pu = -i0Pu * SystemBase.SnRef / SNom, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REEC.REECd reec(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, IqFrzPu = IqFrzPu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kc = Kc, Ke = Ke, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PFlag = false, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QInj0Pu = QInj0Pu, QUMaxPu = QUMaxPu, QUMinPu = QUMinPu, RcPu = RcPu, UBlkHPu = UBlkHPu, UBlkLPu = UBlkLPu, UCmpFlag = UCmpFlag, UDipPu = UDipPu, UFlag = UFlag, UInj0Pu = UInj0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UUpPu = UUpPu, VDLIp101 = VDLIp101, VDLIp102 = VDLIp102, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIp31 = VDLIp31, VDLIp32 = VDLIp32, VDLIp41 = VDLIp41, VDLIp42 = VDLIp42, VDLIp51 = VDLIp51, VDLIp52 = VDLIp52, VDLIp61 = VDLIp61, VDLIp62 = VDLIp62, VDLIp71 = VDLIp71, VDLIp72 = VDLIp72, VDLIp81 = VDLIp81, VDLIp82 = VDLIp82, VDLIp91 = VDLIp91, VDLIp92 = VDLIp92, VDLIq101 = VDLIq101, VDLIq102 = VDLIq102, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VDLIq31 = VDLIq31, VDLIq32 = VDLIq32, VDLIq41 = VDLIq41, VDLIq42 = VDLIq42, VDLIq51 = VDLIq51, VDLIq52 = VDLIq52, VDLIq61 = VDLIq61, VDLIq62 = VDLIq62, VDLIq71 = VDLIq71, VDLIq72 = VDLIq72, VDLIq81 = VDLIq81, VDLIq82 = VDLIq82, VDLIq91 = VDLIq91, VDLIq92 = VDLIq92, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, XcPu = XcPu, iInj0Pu = -i0Pu * SystemBase.SnRef / SNom, tBlkDelay = tBlkDelay, tHld = tHld, tHld2 = tHld2, tIq = tIq, tP = tP, tPOrd = tPOrd, tR1 = tR1, tRv = tRv, uInj0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REGC.REGCa regc(Brkpt = Brkpt, Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, Lvpl1 = Lvpl1, LvplSw = LvplSw, PInj0Pu = PInj0Pu, QInj0Pu = QInj0Pu, RateFlag = RateFlag, RrpwrPu = RrpwrPu, SNom = SNom, UInj0Pu = UInj0Pu, UPhaseInj0 = UPhaseInj0, Zerox = Zerox, i0Pu = i0Pu, s0Pu = s0Pu, tFilterGC = tFilterGC, tG = tG, uInj0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-185, 34}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression complexExpr(y = regc.terminal.i)  annotation(
    Placement(visible = true, transformation(origin = {-57, 13}, extent = {{3, -2}, {-3, 2}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit Ip0Pu "Start value of active current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit Iq0Pu "Start value of reactive current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Real PF0 "Start value of cosinus of power factor angle" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu U0Pu "Start value of voltage module at terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu UInj0Pu "Start value of voltage module at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexVoltagePu uInj0Pu "Start value of complex voltage at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.Angle UPhaseInj0 "Start value of rotor angle in rad" annotation(
    Dialog(group = "Initialization"));

  final parameter Types.VoltageModulePu URef0Pu = if UCompFlag then UInj0Pu else (U0Pu - Kc * Q0Pu * SystemBase.SnRef / SNom) "Start value of voltage setpoint for plant level control, calculated depending on UCompFlag, in pu (base UNom)";

equation
  line.switchOffSignal1.value = regc.injectorIDQ.switchOffSignal1.value;
  line.switchOffSignal2.value = regc.injectorIDQ.switchOffSignal2.value;

  connect(repc.QInjRefPu, reec.QInjRefPu) annotation(
    Line(points = {{-109, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(reec.iqCmdPu, regc.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(reec.frtOn, regc.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(reec.ipCmdPu, regc.ipCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(repc.PInjRefPu, reec.PInjRefPu) annotation(
    Line(points = {{-109, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{30, 0}, {50, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{70, 0}, {110, 0}}, color = {0, 0, 255}));
  connect(measurements.PPu, repc.PRegPu) annotation(
    Line(points = {{54, 11}, {54, 20}, {-112, 20}, {-112, 11}}, color = {0, 0, 127}));
  connect(measurements.QPu, repc.QRegPu) annotation(
    Line(points = {{58, 11}, {58, 30}, {-116, 30}, {-116, 11}}, color = {0, 0, 127}));
  connect(measurements.uPu, repc.uPu) annotation(
    Line(points = {{62, 11}, {62, 40}, {-124, 40}, {-124, 11}}, color = {85, 170, 255}));
  connect(measurements.iPu, repc.iPu) annotation(
    Line(points = {{66, 11}, {66, 50}, {-128, 50}, {-128, 11}}, color = {85, 170, 255}));
  connect(omegaRefPu, repc.omegaRefPu) annotation(
    Line(points = {{-190, 20}, {-160, 20}, {-160, 4}, {-131, 4}}, color = {0, 0, 127}));
  connect(QRefPu, repc.QRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-131, -6}}, color = {0, 0, 127}));
  connect(URefPu, repc.URefPu) annotation(
    Line(points = {{-190, -40}, {-120, -40}, {-120, -11}}, color = {0, 0, 127}));
  connect(PFaRef, reec.PFaRef) annotation(
    Line(points = {{-80, 70}, {-80, 11}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-179, 34}, {-171, 34}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, repc.omegaPu) annotation(
    Line(points = {{-149, 34}, {-140, 34}, {-140, 8}, {-131, 8}}, color = {0, 0, 127}));
  connect(regc.terminal, line.terminal2) annotation(
    Line(points = {{-29, 0}, {10, 0}}, color = {0, 0, 255}));
  connect(regc.uInjPu, pll.uPu) annotation(
    Line(points = {{-29, -8}, {0, -8}, {0, 60}, {-180, 60}, {-180, 46}, {-171, 46}}, color = {85, 170, 255}));
  connect(regc.PInjPu, reec.PInjPu) annotation(
    Line(points = {{-29, 8}, {-10, 8}, {-10, -30}, {-80, -30}, {-80, -11}}, color = {0, 0, 127}));
  connect(regc.UInjPu, reec.UInjPu) annotation(
    Line(points = {{-29, -4}, {-20, -4}, {-20, -20}, {-74, -20}, {-74, -11}}, color = {0, 0, 127}));
  connect(regc.QInjPu, reec.QInjPu) annotation(
    Line(points = {{-29, 4}, {-15, 4}, {-15, -25}, {-88, -25}, {-88, -11}}, color = {0, 0, 127}));
  connect(pll.phi, regc.UPhaseInj) annotation(
    Line(points = {{-149, 46}, {-40, 46}, {-40, 11}}, color = {0, 0, 127}));
  connect(PRefPu, repc.PRefPu) annotation(
    Line(points = {{-190, 0}, {-131, 0}}, color = {0, 0, 127}));
  connect(PAuxPu, reec.PAuxPu) annotation(
    Line(points = {{-100, 70}, {-100, 55}, {-86, 55}, {-86, 11}}, color = {0, 0, 127}));
  connect(regc.uInjPu, reec.uInjPu) annotation(
    Line(points = {{-29, -8}, {0, -8}, {0, 15}, {-76, 15}, {-76, 11}}, color = {85, 170, 255}));
  connect(complexExpr.y, reec.iInjPu) annotation(
    Line(points = {{-60, 13}, {-72, 13}, {-72, 11}}, color = {85, 170, 255}));
  connect(OmegaRef.y, reec.omegaGPu) annotation(
    Line(points = {{-179, 34}, {-175, 34}, {-175, -60}, {-84, -60}, {-84, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-180, -60}, {100, 60}}, grid = {1, 1})));
end PVCurrentSourceREECd;
