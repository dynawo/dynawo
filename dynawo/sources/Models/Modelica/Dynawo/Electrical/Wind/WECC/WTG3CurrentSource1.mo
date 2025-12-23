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
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BasePCS;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-190, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(transformation(origin = {-118, 100}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) " Reference Mechanical Power at optimal pitch angle in Pu (base Snom)" annotation(
    Placement(transformation(origin = {6, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu*SystemBase.SnRef/SNom) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(transformation(origin = {-190, 25}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu*SystemBase.SnRef/SNom) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(transformation(origin = {-190, 8}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(transformation(origin = {-190, -14}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Controls.WECC.Mechanical.WTGPa wecc_wtgp(Kiw = Kiw, Kpw = Kpw, Kic = Kic, Kpc = Kpc, Kcc = Kcc, tTheta = tTheta, ThetaMax = ThetaMax, ThetaMin = ThetaMin, ThetaRMax = ThetaRMax, ThetaRMin = ThetaRMin, PInj0Pu = PInj0Pu, Theta0 = Theta0) annotation(
    Placement(transformation(origin = {-39, -46}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Mechanical.WTGAa wecc_wtga(Theta0 = Theta0, Ka = Ka, Pm0Pu = Pm0Pu) annotation(
    Placement(transformation(origin = {1, -46}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Mechanical.WTGQa wecc_wtgq(Kip = Kip, Kpp = Kpp, tP = tP, tOmegaRef = tOmegaRef, TeMaxPu = TeMaxPu, TeMinPu = TeMinPu, P1 = P1, Spd1 = Spd1, P2 = P2, Spd2 = Spd2, P3 = P3, Spd3 = Spd3, P4 = P4, Spd4 = Spd4, TFlag = TFlag, PInj0Pu = PInj0Pu) annotation(
    Placement(transformation(origin = {-89, -46}, extent = {{-10, 10}, {10, -10}})));
  Dynawo.Electrical.Controls.WECC.Mechanical.WTGTa wecc_wtgt(Ht = Ht, Hg = Hg, Dshaft = Dshaft, Kshaft = Kshaft, PInj0Pu = PInj0Pu, Pm0Pu = Pm0Pu) annotation(
    Placement(transformation(origin = {60.692, -50.4443}, extent = {{-7.69229, -5.55557}, {7.69229, 5.55557}})));
  Dynawo.Electrical.Controls.WECC.REGC.REGCa wecc_regc(IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, tFilterGC = tFilterGC, tG = tG, RrpwrPu = RrpwrPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, brkpt = brkpt, lvpl1 = lvpl1, Lvplsw = Lvplsw, zerox = zerox, QConv0Pu = QConv0Pu, UInj0Pu = UInj0Pu, u0Pu = u0Pu, uConv0Pu = uConv0Pu) annotation(
    Placement(transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.REPC.REPCa wecc_repc(DDn = DDn, DUp = DUp, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PMaxPu = PMaxPu, PMinPu = PMinPu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, SNom = SNom, iControl0Pu = iControl0Pu, PControl0Pu = PControl0Pu, PConv0Pu = PConv0Pu, QControl0Pu = QControl0Pu, QConv0Pu = QConv0Pu, uControl0Pu = uControl0Pu, URef0Pu = URef0Pu) annotation(
    Placement(transformation(origin = {-121, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, SNom = SNom, UPhase0 = ComplexMath.arg(uConv0Pu), i0Pu = i0Pu, s0Pu = s0Pu, P0Pu = - PInj0Pu * (SNom / SystemBase.SnRef), Q0Pu = - QInj0Pu * (SNom / SystemBase.SnRef), u0Pu = uInj0Pu, U0Pu = UInj0Pu) annotation(
    Placement(transformation(extent = {{-10, 10}, {10, -10}})));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(transformation(origin = {-160, 64}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.REEC.REECa wecc_reec(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqFrzPu = IqFrzPu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PFlag = PFlag, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QMaxPu = QMaxPu, QMinPu = QMinPu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIp31 = VDLIp31, VDLIp32 = VDLIp32, VDLIp41 = VDLIp41, VDLIp42 = VDLIp42, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VDLIq31 = VDLIq31, VDLIq32 = VDLIq32, VDLIq41 = VDLIq41, VDLIq42 = VDLIq42, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, VUpPu = VUpPu, tHoldIpMax = tHoldIpMax, tHoldIq = tHoldIq, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv, SNom = SNom, PConv0Pu = PConv0Pu, QConv0Pu = QConv0Pu, UInj0Pu = UInj0Pu, s0Pu = s0Pu, u0Pu = u0Pu, uConv0Pu = uConv0Pu) annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant OmegRef(k = 1) annotation(
    Placement(transformation(origin = {-185, 58}, extent = {{-5, -5}, {5, 5}})));
  Dynawo.Electrical.Sources.IEC.BaseConverters.ElecSystem LvToMvTfo(BPu = 0, GPu = 0, RPu = RPu, SNom = SNom, XPu = XPu, i20Pu = iConv0Pu, u20Pu = uConv0Pu) annotation(
    Placement(transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements WTTerminalMeasurements(SNom = SNom) annotation(
    Placement(transformation(origin = {65, 0}, extent = {{-5, 5}, {5, -5}})));

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
  final parameter Types.PerUnit URef0Pu = if VCompFlag == true then UInj0Pu else ComplexMath.'abs'(uControl0Pu) + Kc * QControl0Pu "Start value of voltage setpoint for plant level control, calculated depending on VcompFlag, in pu (base UNom)" annotation(
    Placement(visible = false, transformation(extent = {{0, 0}, {0, 0}})));

equation
  connect(wecc_wtgt.omegaGPu, wecc_wtgq.omegaGPu) annotation(
    Line(points = {{64, -44}, {64.4305, -44}, {64.4305, -43}, {63.861, -43}, {63.861, -40.034}, {129.092, -40.034}, {129.092, -76.034}, {-108.891, -76.034}, {-108.891, -52.034}, {-99.891, -52.034}}, color = {0, 0, 127}));
  connect(wecc_regc.idRefPu, injector.idPu) annotation(
    Line(points = {{-29, -6}, {-11.5, -6}}, color = {0, 0, 127}));
  connect(wecc_regc.iqRefPu, injector.iqPu) annotation(
    Line(points = {{-29, 4}, {-11.5, 4}}, color = {0, 0, 127}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(PFaRef, wecc_reec.PFaRef) annotation(
    Line(points = {{-118, 100}, {-118, 56}, {-79, 56}, {-79, 11}}, color = {0, 0, 127}));
  connect(wecc_wtga.PmPu, wecc_wtgt.PmPu) annotation(
    Line(points = {{12, -46}, {52, -46}}, color = {0, 0, 127}));
  connect(wecc_wtgp.theta, wecc_wtga.theta) annotation(
    Line(points = {{-28, -46}, {-10, -46}}, color = {0, 0, 127}));
  connect(wecc_wtgt.omegaTPu, wecc_wtgp.omegaTPu) annotation(
    Line(points = {{57, -44}, {57, -29.034}, {-45.726, -29.034}, {-45.726, -35.034}}, color = {0, 0, 127}));
  connect(PmRefPu, wecc_wtga.PmRefPu) annotation(
    Line(points = {{6, -110}, {6, -57}}, color = {0, 0, 127}));
  connect(wecc_wtgq.omegaRefPu, wecc_wtgp.omegaRefPu) annotation(
    Line(points = {{-78, -40}, {-50, -40}}, color = {0, 0, 127}));
  connect(wecc_wtgq.PRefPu, wecc_wtgp.PRefPu) annotation(
    Line(points = {{-78, -52}, {-78, -53}, {-70, -53}, {-70, -66}, {-45, -66}, {-45, -57}}, color = {0, 0, 127}));
  connect(switch.y, wecc_repc.PRegPu) annotation(
    Line(points = {{19.5, 23}, {-112.5, 23}, {-112.5, 11}, {-113, 11}}, color = {0, 0, 127}));
  connect(switch5.y, wecc_repc.QRegPu) annotation(
    Line(points = {{19.5, 39}, {-117.5, 39}, {-117.5, 11}, {-118, 11}}, color = {0, 0, 127}));
  connect(u.y, wecc_repc.uPu) annotation(
    Line(points = {{-20.5, 63}, {-123.5, 63}, {-123.5, 11}, {-124, 11}}, color = {85, 170, 255}));
  connect(i.y, wecc_repc.iPu) annotation(
    Line(points = {{-20.5, 93}, {-128.5, 93}, {-128.5, 11}, {-129, 11}}, color = {85, 170, 255}));
  connect(wecc_repc.QConvRefPu, wecc_reec.QConvRefPu) annotation(
    Line(points = {{-110, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(LvToMvTfo.terminal2, WTTerminalMeasurements.terminal1) annotation(
    Line(points = {{51, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(WTTerminalMeasurements.terminal2, TfoPCS.terminal2) annotation(
    Line(points = {{70, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(WTTerminalMeasurements.UPu, wecc_reec.UPu) annotation(
    Line(points = {{60, -5.5}, {60, -18}, {-74, -18}, {-74, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.PPu, wecc_reec.PConvPu) annotation(
    Line(points = {{62, -5.5}, {62, -22}, {-80, -22}, {-80, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.QPu, wecc_reec.QConvPu) annotation(
    Line(points = {{64, -5.5}, {64, -26}, {-89, -26}, {-89, -11}}, color = {0, 0, 127}));
  connect(wecc_wtgt.omegaGPu, wecc_reec.omegaGPu) annotation(
    Line(points = {{64, -44}, {64, -27.5}, {-85, -27.5}, {-85, -11}}, color = {0, 0, 127}));
  connect(OmegRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-179, 58}, {-171, 58}}, color = {0, 0, 127}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-190, 40}, {-150, 40}, {-150, 4}, {-132, 4}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-190, 25}, {-160, 25}, {-160, -2}, {-132, -2}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-190, 8}, {-170, 8}, {-170, -6}, {-132, -6}}, color = {0, 0, 127}));
  connect(wecc_repc.URefPu, URefPu) annotation(
    Line(points = {{-121, -11}, {-121, -14}, {-190, -14}}, color = {0, 0, 127}));
  connect(wecc_repc.freeze, wecc_wtgq.freeze) annotation(
    Line(points = {{-110, 0}, {-100, 0}, {-100, -28}, {-87, -28}, {-87, -35}}, color = {255, 0, 255}));
  connect(OmegRef.y, wecc_wtgt.omegaRefPu) annotation(
    Line(points = {{-179, 58}, {-176, 58}, {-176, -86}, {43, -86}, {43, -50}, {52, -50}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.PPu, wecc_wtgt.PePu) annotation(
    Line(points = {{62, -5}, {62, -22}, {85, -22}, {85, -50}, {69, -50}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.PPu, wecc_wtgq.PePu) annotation(
    Line(points = {{62, -5}, {62, -22}, {85, -22}, {85, -68}, {-105, -68}, {-105, -46}, {-100, -46}}, color = {0, 0, 127}));
  connect(wecc_repc.PConvRefPu, wecc_wtgq.PRef0Pu) annotation(
    Line(points = {{-110, 6}, {-104, 6}, {-104, -40}, {-100, -40}}, color = {0, 0, 127}));
  connect(wecc_wtgq.PRefPu, wecc_reec.PConvRefPu) annotation(
    Line(points = {{-78, -52}, {-71, -52}, {-71, -31}, {-98, -31}, {-98, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(wecc_reec.POrdPu, wecc_wtgp.POrdPu) annotation(
    Line(points = {{-69, -9}, {-60, -9}, {-60, -52}, {-50, -52}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.uPu, pll.uPu) annotation(
    Line(points = {{66, -5}, {66, -93}, {-174, -93}, {-174, 70}, {-171, 70}}, color = {85, 170, 255}));
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-149, 69}, {-140, 69}, {-140, 8}, {-132, 8}}, color = {0, 0, 127}));
  connect(pll.phi, injector.UPhase) annotation(
    Line(points = {{-149, 65}, {-145, 65}, {-145, -80}, {-17, -80}, {-17, -16}, {0, -16}, {0, -11}}, color = {0, 0, 127}));
  connect(injector.terminal, LvToMvTfo.terminal1) annotation(
    Line(points = {{12, 8}, {20, 8}, {20, 0}, {29, 0}}, color = {0, 0, 255}));
  connect(WTTerminalMeasurements.UPu, wecc_regc.UPu) annotation(
    Line(points = {{60, -5}, {60, -18}, {-46, -18}, {-46, -11}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {1, 1})),
    version = "",
    uses(Dynawo(version = "1.8.0"), Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body><p style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">This block contains the generic WECC WTG model according to (in case page cannot be found, copy link in browser):&nbsp;<br><a href=\"https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a></p><p style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">The overall model is structured as follows:</p><ul style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><li>Main model: WECC_Wind with terminal connection and measurement inputs for P/Q/U/I.&nbsp;</li><li>Plant level control.&nbsp;</li><li>Electrical inverter control.</li><li>Generator control.&nbsp;</li><li>Injector (id,iq).</li><li>Torque control.</li><li>Pitch angle control.</li><li>Aero-Dynamic model.</li><li>Drive-train.</li></ul></body></html>"),
    Icon(graphics = {Text(origin = {-26, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC WTG 3 1"), Rectangle(extent = {{-100, 100}, {100, -100}})}, coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {1, 1})));
end WTG3CurrentSource1;
