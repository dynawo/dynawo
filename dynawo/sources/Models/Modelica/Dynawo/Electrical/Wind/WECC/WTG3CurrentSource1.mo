within Dynawo.Electrical.Wind.WECC;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model WTG3CurrentSource1 "WECC Wind Turbine model with a current source as interface with the grid and the mechanical controllers"
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECa;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGCa;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGP;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGAa;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGQa;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGT;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(transformation(origin = {140, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) " Reference Mechanical Power at optimal pitch angle in pu (base SNom)" annotation(
    Placement(transformation(origin = {57, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu*SystemBase.SnRef/SNom) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(transformation(origin = {-110, 15}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu*SystemBase.SnRef/SNom) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(transformation(origin = {-110, -2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -24}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Controls.WECC.Mechanical.WTGPa wecc_wtgp(Kiw = Kiw, Kpw = Kpw, Kic = Kic, Kpc = Kpc, Kcc = Kcc, tTheta = tTheta, ThetaMax = ThetaMax, ThetaMin = ThetaMin, ThetaRMax = ThetaRMax, ThetaRMin = ThetaRMin, PInj0Pu = PInj0Pu, Theta0 = Theta0) annotation(
    Placement(transformation(origin = {12, -56}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Mechanical.WTGAa wecc_wtga(Theta0 = Theta0, Ka = Ka, Pm0Pu = Pm0Pu) annotation(
    Placement(transformation(origin = {52, -56}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Mechanical.WTGQa wecc_wtgq(Kip = Kip, Kpp = Kpp, tP = tP, tOmegaRef = tOmegaRef, TeMaxPu = TeMaxPu, TeMinPu = TeMinPu, P1 = P1, Spd1 = Spd1, P2 = P2, Spd2 = Spd2, P3 = P3, Spd3 = Spd3, P4 = P4, Spd4 = Spd4, TFlag = TFlag, PInj0Pu = PInj0Pu) annotation(
    Placement(transformation(origin = {-38, -56}, extent = {{-10, 10}, {10, -10}})));
  Dynawo.Electrical.Controls.WECC.Mechanical.WTGTa wecc_wtgt(Ht = Ht, Hg = Hg, Dshaft = Dshaft, Kshaft = Kshaft, PInj0Pu = PInj0Pu, Pm0Pu = Pm0Pu) annotation(
    Placement(transformation(origin = {113.692, -60.4443}, extent = {{-7.69229, -5.55557}, {7.69229, 5.55557}})));
  Dynawo.Electrical.Controls.WECC.REGC.REGCa wecc_regc(IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, tFilterGC = tFilterGC, tG = tG, RrpwrPu = RrpwrPu, UInj0Pu = UInj0Pu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, QInj0Pu = QInj0Pu, brkpt = brkpt, lvpl1 = lvpl1, Lvplsw = Lvplsw, zerox = zerox) annotation(
    Placement(transformation(origin = {200, -10}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.REPC.REPCa wecc_repc(DDn = DDn, DUp = DUp, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = -P0Pu*SystemBase.SnRef/SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QGen0Pu = -Q0Pu*SystemBase.SnRef/SNom, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, U0Pu = U0Pu, UInj0Pu = UInj0Pu, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, iInj0Pu = iInj0Pu, u0Pu = u0Pu) annotation(
    Placement(transformation(origin = {104, -10}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = -PInj0Pu*(SNom/SystemBase.SnRef), Q0Pu = -QInj0Pu*(SNom/SystemBase.SnRef), SNom = SNom, U0Pu = UInj0Pu, UPhase0 = UPhaseInj0, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = uInj0Pu) annotation(
    Placement(transformation(origin = {236, -10}, extent = {{-10, 10}, {10, -10}}, rotation = -0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(transformation(origin = {52, 52}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(transformation(origin = {274, -10}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(transformation(origin = {302, -10}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Connectors.ACPower terminal(V(im(start = u0Pu.im), re(start = u0Pu.re)), i(im(start = i0Pu.im), re(start = i0Pu.re))) annotation(
    Placement(transformation(origin = {338, -10}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.REEC.REECa wecc_reec(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqFrzPu = IqFrzPu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PFlag = PFlag, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, UInj0Pu = UInj0Pu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIp31 = VDLIp31, VDLIp32 = VDLIp32, VDLIp41 = VDLIp41, VDLIp42 = VDLIp42, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VDLIq31 = VDLIq31, VDLIq32 = VDLIq32, VDLIq41 = VDLIq41, VDLIq42 = VDLIq42, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, VUpPu = VUpPu, tHoldIpMax = tHoldIpMax, tHoldIq = tHoldIq, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv) annotation(
    Placement(transformation(origin = {140, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant OmegRef(k = 1) annotation(
    Placement(transformation(origin = {-18, 46}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexVoltagePu uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.Angle UPhaseInj0 "Start value of voltage angle at injector";
  parameter Types.ComplexCurrentPu iInj0Pu "Start value of complex current at injector in pu (base UNom, SNom) (generator convention)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at regulated bus in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at regulated bus in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  final parameter Types.VoltageModulePu URef0Pu = if VCompFlag == true then UInj0Pu else (U0Pu - Kc*Q0Pu*SystemBase.SnRef/SNom) "Start value of voltage setpoint for plant level control, calculated depending on VcompFlag, in pu (base UNom)";

equation
  line.switchOffSignal1.value = injector.switchOffSignal1.value;
  line.switchOffSignal2.value = injector.switchOffSignal2.value;

  connect(wecc_wtgt.omegaGPu, wecc_wtgq.omegaGPu) annotation(
    Line(points = {{117, -54}, {116.75, -54}, {116.75, -50}, {180, -50}, {180, -86}, {-58, -86}, {-58, -62}, {-49, -62}}, color = {0, 0, 127}));
  connect(wecc_repc.PInjRefPu, wecc_wtgq.PRef0Pu) annotation(
    Line(points = {{115, -6}, {115, 18}, {-52, 18}, {-52, -50}, {-49, -50}}, color = {0, 0, 127}));
  connect(wecc_regc.idRefPu, injector.idPu) annotation(
    Line(points = {{212, -16}, {224, -16}}, color = {0, 0, 127}));
  connect(wecc_regc.iqRefPu, injector.iqPu) annotation(
    Line(points = {{212, -6}, {224, -6}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_regc.UPu) annotation(
    Line(points = {{248, -18}, {255, -18}, {255, -28}, {194, -28}, {194, -20}}, color = {0, 0, 127}));
  connect(injector.PInjPuSn, wecc_wtgt.PePu) annotation(
    Line(points = {{248, -14}, {266, -14}, {266, -60}, {122, -60}}, color = {0, 0, 127}));
  connect(injector.PInjPuSn, wecc_wtgq.PePu) annotation(
    Line(points = {{248, -14}, {265, -14}, {265, 65}, {-56, 65}, {-56, -56}, {-49, -56}}, color = {0, 0, 127}));
  connect(injector.terminal, line.terminal1) annotation(
    Line(points = {{248, -2}, {264, -2}, {264, -10}}, color = {0, 0, 255}));
  connect(line.terminal2, measurements.terminal1) annotation(
    Line(points = {{284, -10}, {292, -10}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{312, -10}, {338, -10}}, color = {0, 0, 255}));
  connect(injector.uPu, pll.uPu) annotation(
    Line(points = {{248, -6}, {253, -6}, {253, 70}, {32, 70}, {32, 58}, {41, 58}}, color = {85, 170, 255}));
  connect(measurements.uPu, wecc_repc.uPu) annotation(
    Line(points = {{304, 2}, {304, 28}, {101, 28}, {101, 1}}, color = {85, 170, 255}));
  connect(measurements.iPu, wecc_repc.iPu) annotation(
    Line(points = {{308, 2}, {308, 30}, {96, 30}, {96, 1}}, color = {85, 170, 255}));
  connect(measurements.QPu, wecc_repc.QRegPu) annotation(
    Line(points = {{300, 2}, {300, 24}, {107, 24}, {107, 1}}, color = {0, 0, 127}));
  connect(measurements.PPu, wecc_repc.PRegPu) annotation(
    Line(points = {{296, 2}, {296, 22}, {112, 22}, {112, 1}}, color = {0, 0, 127}));
  connect(pll.phi, injector.UPhase) annotation(
    Line(points = {{63, 53}, {84, 53}, {84, -46}, {236, -46}, {236, -22}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{63, 57}, {74, 57}, {74, -2}, {93, -2}}, color = {0, 0, 127}));
  connect(wecc_repc.QInjRefPu, wecc_reec.QInjRefPu) annotation(
    Line(points = {{115, -16}, {130, -16}}, color = {0, 0, 127}));
  connect(wecc_wtgq.PRefPu, wecc_reec.PInjRefPu) annotation(
    Line(points = {{-27, -62}, {-27, -63.25}, {-19, -63.25}, {-19, -31}, {-2, -31}, {-2, -32}, {122, -32}, {122, -4}, {129, -4}}, color = {0, 0, 127}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{152, -4}, {190, -4}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{152, -10}, {190, -10}}, color = {255, 0, 255}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{152, -16}, {190, -16}}, color = {0, 0, 127}));
  connect(injector.PInjPuSn, wecc_reec.PInjPu) annotation(
    Line(points = {{248, -14}, {266, -14}, {266, -36}, {140, -36}, {140, -22}, {139, -22}, {139, -20}, {140, -20}}, color = {0, 0, 127}));
  connect(wecc_wtgt.omegaGPu, wecc_reec.omegaGPu) annotation(
    Line(points = {{117, -54}, {117, -50}, {133, -50}, {133, -20}, {134, -20}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_reec.UPu) annotation(
    Line(points = {{248, -18}, {254, -18}, {254, -28}, {146, -28}, {146, -20}}, color = {0, 0, 127}));
  connect(injector.QInjPuSn, wecc_reec.QInjPu) annotation(
    Line(points = {{248, -10}, {262, -10}, {262, -42}, {132, -42}, {132, -20}}, color = {0, 0, 127}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-110, 30}, {66, 30}, {66, -6}, {93, -6}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-110, -2}, {54, -2}, {54, -16}, {93, -16}}, color = {0, 0, 127}));
  connect(URefPu, wecc_repc.URefPu) annotation(
    Line(points = {{-110, -24}, {102, -24}, {102, -21}, {104, -21}}, color = {0, 0, 127}));
  connect(PFaRef, wecc_reec.PFaRef) annotation(
    Line(points = {{140, 90}, {140, 2}}, color = {0, 0, 127}));
  connect(wecc_repc.freeze, wecc_wtgq.freeze) annotation(
    Line(points = {{115, -10}, {120, -10}, {120, -27}, {-36, -27}, {-36, -45}}, color = {255, 0, 255}));
  connect(wecc_wtga.PmPu, wecc_wtgt.PmPu) annotation(
    Line(points = {{63, -56}, {105, -56}}, color = {0, 0, 127}));
  connect(wecc_wtgp.theta, wecc_wtga.theta) annotation(
    Line(points = {{23, -56}, {41, -56}}, color = {0, 0, 127}));
  connect(wecc_reec.POrdPu, wecc_wtgp.POrdPu) annotation(
    Line(points = {{152, -18}, {170, -18}, {170, -91}, {-9.5, -91}, {-9.5, -62}, {1, -62}}, color = {0, 0, 127}));
  connect(wecc_wtgt.omegaTPu, wecc_wtgp.omegaTPu) annotation(
    Line(points = {{110, -54}, {110, -39}, {5, -39}, {5, -45}}, color = {0, 0, 127}));
  connect(PmRefPu, wecc_wtga.PmRefPu) annotation(
    Line(points = {{56, -110}, {56, -108.5}, {57, -108.5}, {57, -67}}, color = {0, 0, 127}));
  connect(wecc_wtgq.omegaRefPu, wecc_wtgp.omegaRefPu) annotation(
    Line(points = {{-27, -50}, {1, -50}}, color = {0, 0, 127}));
  connect(wecc_wtgq.PRefPu, wecc_wtgp.PRefPu) annotation(
    Line(points = {{-27, -62}, {-27, -63}, {-19, -63}, {-19, -76}, {6, -76}, {6, -67}}, color = {0, 0, 127}));
  connect(OmegRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-7, 46}, {42, 46}}, color = {0, 0, 127}));
  connect(OmegRef.y, wecc_wtgt.omegaRefPu) annotation(
    Line(points = {{-6, 46}, {30, 46}, {30, -77}, {85, -77}, {85, -60.5}, {105, -60.5}, {105, -60}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-110, 15}, {60, 15}, {60, -12}, {92, -12}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-100, 80}, {360, -100}})),
    version = "",
    uses(Dynawo(version = "1.8.0"), Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body><p style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">This block contains the generic WECC WTG model according to (in case page cannot be found, copy link in browser):&nbsp;<br><a href=\"https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a></p><p style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">The overall model is structured as follows:</p><ul style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><li>Main model: WECC_Wind with terminal connection and measurement inputs for P/Q/U/I.&nbsp;</li><li>Plant level control.&nbsp;</li><li>Electrical inverter control.</li><li>Generator control.&nbsp;</li><li>Injector (id,iq).</li><li>Torque control.</li><li>Pitch angle control.</li><li>Aero-Dynamic model.</li><li>Drive-train.</li></ul></body></html>"),
    Icon(graphics = {Text(origin = {-26, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC WTG 3 1"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end WTG3CurrentSource1;
