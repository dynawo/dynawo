within Dynawo.Electrical.BESS.WECC;

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

model BESScbCurrentSourceREECd "WECC BESS with electrical control model type D, generator/converter model type B and plant control type A"
  extends Electrical.Controls.PLL.ParamsPLL;
  extends Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;
  extends Electrical.Controls.WECC.Parameters.REEC.ParamsREECd;
  extends Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;
  extends Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary input in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {9.99201e-16, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Electrical.Controls.WECC.REPC.REPCa repcA(DDn = DDn, DUp = DUp, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = -P0Pu * SystemBase.SnRef / SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QGen0Pu = -Q0Pu*SystemBase.SnRef/SNom, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, U0Pu = U0Pu, UInj0Pu = UInj0Pu, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, iInj0Pu = iInj0Pu, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Electrical.Controls.WECC.REEC.REECd reecD(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, UInj0Pu = UInj0Pu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIp31 = VDLIp31, VDLIp32 = VDLIp32, VDLIp41 = VDLIp41, VDLIp42 = VDLIp42, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VDLIq31 = VDLIq31, VDLIq32 = VDLIq32, VDLIq41 = VDLIq41, VDLIq42 = VDLIq42, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VUpPu = VUpPu, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv, PFlag = PFlag, VRef1Pu = VRef1Pu, Kc = Kc, VCompFlag = VCompFlag, tR1 = tR1, Ke = Ke, XcPu = XcPu, RcPu = RcPu, u0Pu = uInj0Pu, i0Pu = i0Pu, VDLIp51 = VDLIp51, VDLIp52 = VDLIp52, VDLIp61 = VDLIp61, VDLIp62 = VDLIp62, VDLIp71 = VDLIp71, VDLIp72 = VDLIp72, VDLIp81 = VDLIp81, VDLIp82 = VDLIp82, VDLIp91 = VDLIp91, VDLIp92 = VDLIp92, VDLIp101 = VDLIp101, VDLIp102 = VDLIp102, VDLIq51 = VDLIq51, VDLIq52 = VDLIq52, VDLIq61 = VDLIq61, VDLIq62 = VDLIq62, VDLIq71 = VDLIq71, VDLIq72 = VDLIq72, VDLIq81 = VDLIq81, VDLIq82 = VDLIq82, VDLIq91 = VDLIq91, VDLIq92 = VDLIq92, VDLIq101 = VDLIq101, VDLIq102 = VDLIq102, tHoldIpMax = tHoldIpMax, tHoldIq = tHoldIq, IqFrzPu = IqFrzPu, UBlkHPu = UBlkHPu, UBlkLPu = UBlkLPu, tBlkDelay = tBlkDelay) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Controls.WECC.REGC.REGCbCS regcBCS(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, RateFlag = RateFlag, RrpwrPu = RrpwrPu, UInj0Pu = UInj0Pu, tFilterGC = tFilterGC, tG = tG) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = -PInj0Pu * (SNom / SystemBase.SnRef), Q0Pu = -QInj0Pu * (SNom / SystemBase.SnRef), SNom = SNom, U0Pu = UInj0Pu, UPhase0 = UPhaseInj0, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-185, 38}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Lines.Line line(BPu = 0, GPu = 0, RPu = RPu, XPu = XPu) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters given by the user
  parameter Types.ActivePowerPu P0Pu "Start value of active power at regulated bus in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at regulated bus in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.ComplexCurrentPu iInj0Pu "Start value of complex current at injector in pu (base UNom, SNom) (generator convention)";

  // Initial parameters calculated by the initialization model
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexVoltagePu uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.Angle UPhaseInj0 "Start value of voltage angle at injector in rad";

  // Initial parameter
  final parameter Types.VoltageModulePu URef0Pu = if VCompFlag == true then UInj0Pu else (U0Pu + Kc * Q0Pu * SystemBase.SnRef / SNom) "Start value of voltage setpoint for plant level control, calculated depending on VCompFlag, in pu (base UNom)" annotation(
    Placement(visible = false, transformation(extent = {{0, 0}, {0, 0}})));

equation
  line.switchOffSignal1.value = injector.switchOffSignal1.value;
  line.switchOffSignal2.value = injector.switchOffSignal2.value;
  injector.terminal.i = reecD.iPu;
  injector.terminal.V = reecD.uPu;

  connect(reecD.idCmdPu, regcBCS.idCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(reecD.iqCmdPu, regcBCS.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(regcBCS.iqRefPu, injector.iqPu) annotation(
    Line(points = {{-29, 4}, {-11, 4}}, color = {0, 0, 127}));
  connect(regcBCS.idRefPu, injector.idPu) annotation(
    Line(points = {{-29, -6}, {-11, -6}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-179, 38}, {-171, 38}}, color = {0, 0, 127}));
  connect(injector.uPu, pll.uPu) annotation(
    Line(points = {{12, 3}, {20, 3}, {20, 60}, {-180, 60}, {-180, 50}, {-171, 50}}, color = {85, 170, 255}));
  connect(injector.terminal, line.terminal2) annotation(
    Line(points = {{12, 8}, {30, 8}, {30, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{60, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{100, 0}, {130, 0}}, color = {0, 0, 255}));
  connect(PFaRef, reecD.PFaRef) annotation(
    Line(points = {{-70, 70}, {-70, 14}, {-79, 14}, {-79, 11}}, color = {0, 0, 127}));
  connect(PAuxPu, reecD.PAuxPu) annotation(
    Line(points = {{-90, 70}, {-90, 14}, {-83, 14}, {-83, 11}}, color = {0, 0, 127}));
  connect(injector.QInjPuSn, reecD.QInjPu) annotation(
    Line(points = {{12, 0}, {30, 0}, {30, -30}, {-89, -30}, {-89, -11}}, color = {0, 0, 127}));
  connect(injector.PInjPuSn, reecD.PInjPu) annotation(
    Line(points = {{12, -4}, {25, -4}, {25, -25}, {-80, -25}, {-80, -11}}, color = {0, 0, 127}));
  connect(injector.UPu, reecD.UPu) annotation(
    Line(points = {{12, -8}, {20, -8}, {20, -20}, {-74, -20}, {-74, -11}}, color = {0, 0, 127}));
  connect(reecD.frtOn, regcBCS.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(pll.phi, injector.UPhase) annotation(
    Line(points = {{-149, 45}, {-146, 45}, {-146, -50}, {0, -50}, {0, -11}}, color = {0, 0, 127}));
  connect(regcBCS.UPu, injector.UPu) annotation(
    Line(points = {{-46, -11}, {-46, -20}, {20, -20}, {20, -8}, {12, -8}}, color = {0, 0, 127}));
  connect(repcA.PInjRefPu, reecD.PInjRefPu) annotation(
    Line(points = {{-109, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(repcA.QInjRefPu, reecD.QInjRefPu) annotation(
    Line(points = {{-109, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(PRefPu, repcA.PRefPu) annotation(
    Line(points = {{-190, 0}, {-160, 0}, {-160, -2}, {-131, -2}}, color = {0, 0, 127}));
  connect(QRefPu, repcA.QRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-131, -6}}, color = {0, 0, 127}));
  connect(measurements.PPu, repcA.PRegPu) annotation(
    Line(points = {{84, 11}, {84, 20}, {-112, 20}, {-112, 11}}, color = {0, 0, 127}));
  connect(measurements.QPu, repcA.QRegPu) annotation(
    Line(points = {{88, 11}, {88, 30}, {-117, 30}, {-117, 11}}, color = {0, 0, 127}));
  connect(measurements.uPu, repcA.uPu) annotation(
    Line(points = {{92, 11}, {92, 40}, {-123, 40}, {-123, 11}}, color = {85, 170, 255}));
  connect(measurements.iPu, repcA.iPu) annotation(
    Line(points = {{96, 11}, {96, 50}, {-128, 50}, {-128, 11}}, color = {85, 170, 255}));
  connect(URefPu, repcA.URefPu) annotation(
    Line(points = {{-190, -40}, {-120, -40}, {-120, -11}}, color = {0, 0, 127}));
  connect(omegaRefPu, repcA.omegaRefPu) annotation(
    Line(points = {{-190, 20}, {-160, 20}, {-160, 4}, {-131, 4}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, repcA.omegaPu) annotation(
    Line(points = {{-149, 49}, {-140, 49}, {-140, 8}, {-131, 8}}, color = {0, 0, 127}));
  connect(OmegaRef.y, reecD.omegaGPu) annotation(
    Line(points = {{-179, 38}, {-175, 38}, {-175, -23}, {-85, -23}, {-85, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC BESS CB")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end BESScbCurrentSourceREECd;
