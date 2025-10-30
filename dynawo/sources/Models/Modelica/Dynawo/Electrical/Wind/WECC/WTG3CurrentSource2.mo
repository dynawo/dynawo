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

model WTG3CurrentSource2 "WECC Wind Turbine model with a current source as interface with the grid and the mechanical controllers"
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECa;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGCa;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGP;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGPb;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGAa;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGQa;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGT;
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BasePCS;
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-188, 28}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(transformation(origin = {-79, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) "Reference mechanical power at optimal pitch angle in pu (base SNom)" annotation(
    Placement(transformation(origin = {18, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu*SystemBase.SnRef/SNom) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(transformation(origin = {-188, 11}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu*SystemBase.SnRef/SNom) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(transformation(origin = {-188, -6}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(transformation(origin = {-188, -22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Controls.WECC.Mechanical.WTGQa wecc_wtgq(Kip = Kip, Kpp = Kpp, tP = tP, tOmegaRef = tOmegaRef, TeMaxPu = TeMaxPu, TeMinPu = TeMinPu, P1 = P1, Spd1 = Spd1, P2 = P2, Spd2 = Spd2, P3 = P3, Spd3 = Spd3, P4 = P4, Spd4 = Spd4, TFlag = TFlag, PInj0Pu = PInj0Pu) annotation(
    Placement(transformation(origin = {-81, -56}, extent = {{-10, 10}, {10, -10}})));
  Dynawo.Electrical.Controls.WECC.Mechanical.WTGTa wecc_wtgt(Ht = Ht, Hg = Hg, Dshaft = Dshaft, Kshaft = Kshaft, PInj0Pu = PInj0Pu, Pm0Pu = Pm0Pu) annotation(
    Placement(transformation(origin = {67.307, -63.7777}, extent = {{-12.3077, -8.88892}, {12.3077, 8.88892}})));
  Dynawo.Electrical.Controls.WECC.REGC.REGCa wecc_regc(IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, tFilterGC = tFilterGC, tG = tG, RrpwrPu = RrpwrPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, brkpt = brkpt, lvpl1 = lvpl1, Lvplsw = Lvplsw, zerox = zerox, QConv0Pu = QConv0Pu, UInj0Pu = UInj0Pu, u0Pu = u0Pu, uConv0Pu = uConv0Pu) annotation(
    Placement(transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.REPC.REPCa wecc_repc(DDn = DDn, DUp = DUp, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PMaxPu = PMaxPu, PMinPu = PMinPu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, SNom = SNom, iControl0Pu = iControl0Pu, PControl0Pu = PControl0Pu, PConv0Pu = PConv0Pu, QControl0Pu = QControl0Pu, QConv0Pu = QConv0Pu, uControl0Pu = uControl0Pu, URef0Pu = URef0Pu) annotation(
    Placement(transformation(origin = {-121, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, SNom = SNom, UPhase0 = ComplexMath.arg(uConv0Pu), i0Pu = i0Pu, s0Pu = s0Pu, P0Pu = -PInj0Pu*(SNom/SystemBase.SnRef), Q0Pu = -QInj0Pu*(SNom/SystemBase.SnRef), u0Pu = uInj0Pu, U0Pu = UInj0Pu) annotation(
    Placement(transformation(extent = {{-10, 10}, {10, -10}})));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(transformation(origin = {-160, 64}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.REEC.REECa wecc_reec(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqFrzPu = IqFrzPu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PFlag = PFlag, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QMaxPu = QMaxPu, QMinPu = QMinPu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIp31 = VDLIp31, VDLIp32 = VDLIp32, VDLIp41 = VDLIp41, VDLIp42 = VDLIp42, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VDLIq31 = VDLIq31, VDLIq32 = VDLIq32, VDLIq41 = VDLIq41, VDLIq42 = VDLIq42, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, VUpPu = VUpPu, tHoldIpMax = tHoldIpMax, tHoldIq = tHoldIq, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv, SNom = SNom, PConv0Pu = PConv0Pu, QConv0Pu = QConv0Pu, UInj0Pu = UInj0Pu, s0Pu = s0Pu, u0Pu = u0Pu, uConv0Pu = uConv0Pu) annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}})));
  Controls.WECC.Mechanical.WTGPb wecc_wtgp(Kiw = Kiw, Kpw = Kpw, Kic = Kic, Kpc = Kpc, Kcc = Kcc, tTheta = tTheta, ThetaMax = ThetaMax, ThetaMin = ThetaMin, ThetaRMax = ThetaRMax, ThetaRMin = ThetaRMin, ThetaWMax = ThetaWMax, ThetaCMax = ThetaCMax, ThetaCMin = ThetaCMin, ThetaWMin = ThetaWMin, PInj0Pu = PInj0Pu, Theta0 = Theta0) annotation(
    Placement(transformation(origin = {-27, -56}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Mechanical.WTGAa wecc_wtga(Theta0 = Theta0, Ka = Ka, Pm0Pu = Pm0Pu) annotation(
    Placement(transformation(origin = {13, -56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(transformation(origin = {-185.5, 45.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}})));
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
  final parameter Types.PerUnit URef0Pu = if VCompFlag == true then UInj0Pu else ComplexMath.'abs'(uControl0Pu) + Kc*QControl0Pu "Start value of voltage setpoint for plant level control, calculated depending on VcompFlag, in pu (base UNom)" annotation(
    Placement(visible = false, transformation(extent = {{0, 0}, {0, 0}})));

equation
  connect(wecc_wtga.PmPu, wecc_wtgt.PmPu) annotation(
    Line(points = {{24, -56}, {54, -56}}, color = {0, 0, 127}));
  connect(wecc_wtgp.theta, wecc_wtga.theta) annotation(
    Line(points = {{-16, -56}, {2, -56}}, color = {0, 0, 127}));
  connect(wecc_wtgq.omegaRefPu, wecc_wtgp.omegaRefPu) annotation(
    Line(points = {{-70, -50}, {-38, -50}}, color = {0, 0, 127}));
  connect(wecc_wtgq.PRefPu, wecc_wtgp.PRefPu) annotation(
    Line(points = {{-70, -62}, {-65, -62}, {-65, -72}, {-33, -72}, {-33, -67}}, color = {0, 0, 127}));
  connect(URefPu, wecc_repc.URefPu) annotation(
    Line(points = {{-188, -22}, {-121, -22}, {-121, -11}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-188, -6}, {-132, -6}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-188, 11}, {-170, 11}, {-170, -2}, {-132, -2}}, color = {0, 0, 127}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-188, 28}, {-160, 28}, {-160, 4}, {-132, 4}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-149, 69}, {-140, 69}, {-140, 8}, {-132, 8}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-179, 46}, {-176, 46}, {-176, 58}, {-171, 58}}, color = {0, 0, 127}));
  connect(wecc_repc.freeze, wecc_wtgq.freeze) annotation(
    Line(points = {{-110, 0}, {-103, 0}, {-103, -40}, {-79, -40}, {-79, -45}}, color = {255, 0, 255}));
  connect(wecc_repc.QConvRefPu, wecc_reec.QConvRefPu) annotation(
    Line(points = {{-110, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(wecc_repc.PConvRefPu, wecc_wtgq.PRef0Pu) annotation(
    Line(points = {{-110, 6}, {-100, 6}, {-100, -50}, {-92, -50}}, color = {0, 0, 127}));
  connect(wecc_wtgq.PRefPu, wecc_reec.PConvRefPu) annotation(
    Line(points = {{-70, -62}, {-65, -62}, {-65, -30}, {-98, -30}, {-98, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(wecc_wtgt.omegaGPu, wecc_wtgq.omegaGPu) annotation(
    Line(points = {{73, -54}, {73, -50}, {90, -50}, {90, -80}, {-97, -80}, {-97, -62}, {-92, -62}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.PPu, wecc_wtgq.PePu) annotation(
    Line(points = {{62, -5}, {62, -40}, {95, -40}, {95, -84}, {-100, -84}, {-100, -56}, {-92, -56}}, color = {0, 0, 127}));
  connect(wecc_wtgp.omegaTPu, wecc_wtgt.omegaTPu) annotation(
    Line(points = {{-34, -45}, {-34, -40}, {30, -40}, {30, -50}, {62, -50}, {62, -54}}, color = {0, 0, 127}));
  connect(PmRefPu, wecc_wtga.PmRefPu) annotation(
    Line(points = {{18, -110}, {18, -67}}, color = {0, 0, 127}));
  connect(wecc_regc.iqRefPu, injector.iqPu) annotation(
    Line(points = {{-29, 4}, {-11, 4}}, color = {0, 0, 127}));
  connect(wecc_regc.idRefPu, injector.idPu) annotation(
    Line(points = {{-29, -6}, {-11, -6}}, color = {0, 0, 127}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(injector.terminal, LvToMvTfo.terminal1) annotation(
    Line(points = {{12, 8}, {20, 8}, {20, 0}, {29, 0}}, color = {0, 0, 255}));
  connect(LvToMvTfo.terminal2, WTTerminalMeasurements.terminal1) annotation(
    Line(points = {{51, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(WTTerminalMeasurements.terminal2, TfoPCS.terminal2) annotation(
    Line(points = {{70, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(PFaRef, wecc_reec.PFaRef) annotation(
    Line(points = {{-79, 110}, {-79, 11}}, color = {0, 0, 127}));
  connect(wecc_repc.iPu, i.y) annotation(
    Line(points = {{-129, 11}, {-129, 93}, {-20, 93}}, color = {85, 170, 255}));
  connect(wecc_repc.uPu, u.y) annotation(
    Line(points = {{-124, 11}, {-124, 63}, {-20, 63}}, color = {85, 170, 255}));
  connect(switch5.y, wecc_repc.QRegPu) annotation(
    Line(points = {{20, 39}, {-118, 39}, {-118, 11}}, color = {0, 0, 127}));
  connect(switch.y, wecc_repc.PRegPu) annotation(
    Line(points = {{20, 23}, {-113, 23}, {-113, 11}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(pll.phi, injector.UPhase) annotation(
    Line(points = {{-149, 65}, {-145, 65}, {-145, -17}, {0, -17}, {0, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.uPu, pll.uPu) annotation(
    Line(points = {{66, -5}, {66, -36}, {100, -36}, {100, -90}, {-174, -90}, {-174, 70}, {-171, 70}}, color = {85, 170, 255}));
  connect(WTTerminalMeasurements.UPu, wecc_regc.UPu) annotation(
    Line(points = {{60, -5}, {60, -20}, {-46, -20}, {-46, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.PPu, wecc_reec.PConvPu) annotation(
    Line(points = {{62, -5}, {62, -24}, {-80, -24}, {-80, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.UPu, wecc_reec.UPu) annotation(
    Line(points = {{60, -5}, {60, -20}, {-74, -20}, {-74, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.QPu, wecc_reec.QConvPu) annotation(
    Line(points = {{64, -5}, {64, -27}, {-89, -27}, {-89, -11}}, color = {0, 0, 127}));
  connect(wecc_wtgt.omegaGPu, wecc_reec.omegaGPu) annotation(
    Line(points = {{73, -54}, {73, -44}, {58, -44}, {58, -34}, {-85, -34}, {-85, -11}}, color = {0, 0, 127}));
  connect(OmegaRef.y, wecc_wtgt.omegaRefPu) annotation(
    Line(points = {{-179, 46}, {-176, 46}, {-176, -76}, {40, -76}, {40, -63}, {54, -63}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.PPu, wecc_wtgt.PePu) annotation(
    Line(points = {{62, -5}, {62, -24}, {86, -24}, {86, -63}, {81, -63}}, color = {0, 0, 127}));
  connect(wecc_reec.POrdPu, wecc_wtgp.POrdPu) annotation(
    Line(points = {{-69, -9}, {-60, -9}, {-60, -62}, {-38, -62}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {1, 1})),
    version = "",
    uses(Dynawo(version = "1.8.0"), Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body><p style=\"font-size: 12px; font-family: 'MS Shell Dlg 2';\">This block contains the generic WECC WTG model according to (in case page cannot be found, copy link in browser):&nbsp;<br><a href=\"https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a></p><p style=\"font-size: 12px; font-family: 'MS Shell Dlg 2';\">The overall model is structured as follows:</p><ul style=\"font-size: 12px; font-family: 'MS Shell Dlg 2';\"><li>Main model: WECC_Wind with terminal connection and measurement inputs for P/Q/U/I.&nbsp;</li><li>Plant level control.&nbsp;</li><li>Electrical inverter control.</li><li>Generator control.&nbsp;</li><li>Injector (id,iq).</li><li>Torque control.</li><li>Pitch angle control.</li><li>Aero-Dynamic model.</li><li>Drive-train.</li></ul><div><font face=\"MS Shell Dlg 2\">The only difference with the model Wtg3CurrentSource1 is the change of the pitch controller model, this one offers mor flexibility with the limits of the integrators.</font></div></body></html>"),
    Icon(graphics = {Text(origin = {-26, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC WTG 3 2"), Rectangle(extent = {{-100, 100}, {100, -100}})}, coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {1, 1})));
end WTG3CurrentSource2;
