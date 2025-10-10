within Dynawo.Electrical.BESS.WECC.BaseClasses;

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

partial model BaseBESSCurrentSource "Partial base model for WECC BESS with electrical control model type C, generator/converter model type A"
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECc;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGCa;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Configuration parameters to define how the user wants to represent the internal network
  parameter Boolean ConverterLVControl  = true "Boolean parameter to choose whether the converter is controlling at its output (LV side of its transformer) : True ; or after its transformer (MV side): False" annotation(
    Dialog(tab = "LV transformer"));

  //Parameters for LV transformer
  parameter Types.PerUnit RLvTrPu "Serial resistance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));
  parameter Types.PerUnit XLvTrPu "Serial reactance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));

  // In every cases (RPu + j*XPu) is the serial impedance between converter's output and WT terminal
  //Depending on the value of ConverterLVControl we are correctly defining these parameters
  final parameter Types.PerUnit RPu = if ConverterLVControl then 1e-5 else RLvTrPu "Serial resistance between converter output and WT terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit XPu = if ConverterLVControl then 1e-5 else XLvTrPu "Serial reactance between converter output and WT terminal in pu (base UNom, SNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary input in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-90, 130}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-70, 130}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {9.99201e-16, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Dynawo.Electrical.Controls.WECC.REEC.REECc reecC(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PConv0Pu = PConv0Pu, PF0 = PF0, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QConv0Pu = QConv0Pu, QFlag = QFlag, QMaxPu = QMaxPu, QMinPu = QMinPu, SNom = SNom, SOC0Pu = SOC0Pu, SOCMaxPu = SOCMaxPu, SOCMinPu = SOCMinPu, UInj0Pu = UInj0Pu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIp31 = VDLIp31, VDLIp32 = VDLIp32, VDLIp41 = VDLIp41, VDLIp42 = VDLIp42, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VDLIq31 = VDLIq31, VDLIq32 = VDLIq32, VDLIq41 = VDLIq41, VDLIq42 = VDLIq42, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VUpPu = VUpPu, s0Pu = s0Pu, tBattery = tBattery, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv, u0Pu = u0Pu, uConv0Pu = uConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REGC.REGCa regcA(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, Lvplsw = Lvplsw, QConv0Pu = QConv0Pu, RrpwrPu = RrpwrPu, UInj0Pu = UInj0Pu, brkpt = brkpt, lvpl1 = lvpl1, tFilterGC = tFilterGC, tG = tG, u0Pu = u0Pu, uConv0Pu = uConv0Pu, zerox = zerox) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = -PInj0Pu * (SNom / SystemBase.SnRef), Q0Pu = -QInj0Pu * (SNom / SystemBase.SnRef), SNom = SNom, U0Pu = UInj0Pu, UPhase0 = ComplexMath.arg(uConv0Pu), i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-185, 38}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Controls.WECC.Utilities.Measurements WTTerminalMeasurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {65, -8.88178e-16}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Sources.IEC.BaseConverters.ElecSystem LvToMvTfo(BPu = 0, GPu = 0, RPu = RPu, SNom = SNom, XPu = XPu, i20Pu = iConv0Pu, u20Pu = uConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit iConv0Pu "Start value of complex current at converter terminal in pu (base UNom, SNom) (generator convention)";
  parameter Types.ActivePowerPu PConv0Pu "Start value of active power at converter terminal in pu (generator convention) (base SNom)";
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.ReactivePowerPu QConv0Pu "Start value of reactive power at converter terminal in pu (generator convention) (base SNom)";
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.PerUnit SOC0Pu "Initial state of charge in pu (base SNom)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit uConv0Pu "Start value of complex voltage at converter terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at regulated bus in rad";

equation
  connect(reecC.idCmdPu, regcA.idCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(reecC.iqCmdPu, regcA.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(regcA.idRefPu, injector.idPu) annotation(
    Line(points = {{-29, -6}, {-11, -6}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-179, 38}, {-171, 38}}, color = {0, 0, 127}));
  connect(reecC.frtOn, regcA.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(pll.phi, injector.UPhase) annotation(
    Line(points = {{-149, 45}, {-146, 45}, {-146, -50}, {0, -50}, {0, -11}}, color = {0, 0, 127}));
  connect(regcA.iqRefPu, injector.iqPu) annotation(
    Line(points = {{-29, 4}, {-11, 4}}, color = {0, 0, 127}));
  connect(LvToMvTfo.terminal2, WTTerminalMeasurements.terminal1) annotation(
    Line(points = {{51, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(injector.terminal, LvToMvTfo.terminal1) annotation(
    Line(points = {{12, 8}, {24, 8}, {24, 0}, {29, 0}}, color = {0, 0, 255}));
  connect(WTTerminalMeasurements.UPu, regcA.UPu) annotation(
    Line(points = {{60, -6}, {60, -20}, {-46, -20}, {-46, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.UPu, reecC.UPu) annotation(
    Line(points = {{60, -6}, {60, -20}, {-74, -20}, {-74, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.PPu, reecC.PConvPu) annotation(
    Line(points = {{62, -6}, {62, -25}, {-80, -25}, {-80, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.QPu, reecC.QConvPu) annotation(
    Line(points = {{64, -6}, {64, -30}, {-89, -30}, {-89, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.uPu, pll.uPu) annotation(
    Line(points = {{66, -6}, {66, -60}, {-173, -60}, {-173, 50}, {-171, 50}}, color = {85, 170, 255}));
  connect(PAuxPu, reecC.PAuxPu) annotation(
    Line(points = {{-90, 130}, {-90, 20}, {-81, 20}, {-81, 11}}, color = {0, 0, 127}));
  connect(PFaRef, reecC.PFaRef) annotation(
    Line(points = {{-70, 130}, {-70, 20}, {-79, 20}, {-79, 11}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC BESS")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end BaseBESSCurrentSource;
