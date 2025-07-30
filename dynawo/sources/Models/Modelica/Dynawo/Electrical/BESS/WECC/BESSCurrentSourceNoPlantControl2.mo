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

model BESSCurrentSourceNoPlantControl2 "WECC BESS with electrical control model type D, generator/converter model type B (without plant control)"
  extends Dynawo.Electrical.BESS.WECC.BaseClasses.BaseBESSCurrentSource;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECd;
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PInjRefPu(start = PInj0Pu) "Active power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QInjRefPu(start = QInj0Pu) "Reactive power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.WECC.REEC.REECd reecD(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, UInj0Pu = UInj0Pu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIp31 = VDLIp31, VDLIp32 = VDLIp32, VDLIp41 = VDLIp41, VDLIp42 = VDLIp42, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VDLIq31 = VDLIq31, VDLIq32 = VDLIq32, VDLIq41 = VDLIq41, VDLIq42 = VDLIq42, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VUpPu = VUpPu, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv, PFlag = PFlag, VRef1Pu = VRef1Pu, Kc = Kc, VCompFlag = VCompFlag, tR1 = tR1, Ke = Ke, XcPu = XcPu, RcPu = RcPu, u0Pu = uInj0Pu, i0Pu = i0Pu, VDLIp51 = VDLIp51, VDLIp52 = VDLIp52, VDLIp61 = VDLIp61, VDLIp62 = VDLIp62, VDLIp71 = VDLIp71, VDLIp72 = VDLIp72, VDLIp81 = VDLIp81, VDLIp82 = VDLIp82, VDLIp91 = VDLIp91, VDLIp92 = VDLIp92, VDLIp101 = VDLIp101, VDLIp102 = VDLIp102, VDLIq51 = VDLIq51, VDLIq52 = VDLIq52, VDLIq61 = VDLIq61, VDLIq62 = VDLIq62, VDLIq71 = VDLIq71, VDLIq72 = VDLIq72, VDLIq81 = VDLIq81, VDLIq82 = VDLIq82, VDLIq91 = VDLIq91, VDLIq92 = VDLIq92, VDLIq101 = VDLIq101, VDLIq102 = VDLIq102, tHoldIpMax = tHoldIpMax, tHoldIq = tHoldIq, IqFrzPu = IqFrzPu, UBlkHPu = UBlkHPu, UBlkLPu = UBlkLPu, tBlkDelay = tBlkDelay) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
  final parameter Types.VoltageModulePu URef0Pu = if VCompFlag == true then UInj0Pu else (U0Pu + Kc*Q0Pu*SystemBase.SnRef/SNom) "Start value of voltage setpoint for plant level control, calculated depending on VCompFlag, in pu (base UNom)" annotation(
    Placement(visible = false, transformation(extent = {{0, 0}, {0, 0}})));

equation
  injector.terminal.i = reecD.iPu;
  injector.terminal.V = reecD.uPu;

  connect(PInjRefPu, reecD.PInjRefPu) annotation(
    Line(points = {{-190, 20}, {-160, 20}, {-160, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(QInjRefPu, reecD.QInjRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(reecD.idCmdPu, regcA.idCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(reecD.iqCmdPu, regcA.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
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
  connect(reecD.frtOn, regcA.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(OmegaRef.y, reecD.omegaGPu) annotation(
    Line(points = {{-179, 38}, {-175, 38}, {-175, -23}, {-85, -23}, {-85, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end BESSCurrentSourceNoPlantControl2;
