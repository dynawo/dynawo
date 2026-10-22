within Dynawo.Electrical.Photovoltaics.WECC;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

model PVCurrentSource2 "WECC PV model with a current source as interface with the grid (REPC-C REEC-A REGC-A)"
  extends Dynawo.Electrical.Photovoltaics.WECC.BaseClasses.BasePVCurrentSource(LvTfo(RPu = RPu, XPu = XPu));
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPCc;
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BasePCS;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary power in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-125, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UAuxPu(start = 0) "Auxiliary voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {-155, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Controls.WECC.REPC.REPCc wecc_repc(DDn = DDn, DUp = DUp, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PControl0Pu = PControl0Pu, PConv0Pu = PConv0Pu, PMaxREPCPu = PMaxREPCPu, PMinREPCPu = PMinREPCPu, QControl0Pu = QControl0Pu, QConv0Pu = QConv0Pu, QMaxREPCPu = QMaxREPCPu, QMinREPCPu = QMinREPCPu, RcPu = RPu, RefFlag = RefFlag, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, iControl0Pu = iControl0Pu, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tpREPC = tpREPC, uControl0Pu = uControl0Pu, tC = tC, tFrz = tFrz, PiMaxPu = PiMaxPu, PiMinPu = PiMinPu, PrMaxPu = PrMaxPu, PrMinPu = PrMinPu, DPrMaxPu = DPrMaxPu, DPrMinPu = DPrMinPu, URefMaxPu = URefMaxPu, URefMinPu = URefMinPu, QRefMaxPu = QRefMaxPu, QRefMinPu = QRefMinPu, DQRefMaxPu = DQRefMaxPu, DQRefMinPu = DQRefMinPu, QvrMaxPu = QvrMaxPu, QvrMinPu = QvrMinPu, PfMax = PfMax, PfMin = PfMin, tFrq = tFrq, FfwrdFlag = FfwrdFlag, PefdFlag = PefdFlag, UFreqPu = UFreqPu, QVFlag = QVFlag, DfMaxPu = DfMaxPu, DfMinPu = DfMinPu, SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ActivePowerPu P0Pu "Start value of active power at regulated bus in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at regulated bus in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";

  final parameter Types.VoltageModulePu URef0Pu = if VCompFlag == true then UInj0Pu else U0Pu - Kc * Q0Pu * SystemBase.SnRef / SNom "Start value of voltage setpoint for plant level control, calculated depending on VCompFlag, in pu (base UNom)";

equation
  connect(HvTfo.switchOffSignal1, injector.switchOffSignal1);
  connect(HvTfo.switchOffSignal2, injector.switchOffSignal2);
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-190, 0}, {-160, 0}, {-160, -2}, {-131, -2}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-131, -6}}, color = {0, 0, 127}));
  connect(URefPu, wecc_repc.URefPu) annotation(
    Line(points = {{-190, -40}, {-120, -40}, {-120, -11}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-149, 49}, {-140, 49}, {-140, 8}, {-131, 8}}, color = {0, 0, 127}));
  connect(LvMeasurements.terminal2, HvTfo.terminal2) annotation(
    Line(points = {{70, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(wecc_repc.PConvRefPu, wecc_reec.PConvRefPu) annotation(
    Line(points = {{-109, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(wecc_repc.QConvRefPu, wecc_reec.QConvRefPu) annotation(
    Line(points = {{-109, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(i.y, wecc_repc.iPu) annotation(
    Line(points = {{-20, 93}, {-128, 93}, {-128, 11}}, color = {85, 170, 255}));
  connect(u.y, wecc_repc.uPu) annotation(
    Line(points = {{-20, 63}, {-123, 63}, {-123, 11}}, color = {85, 170, 255}));
  connect(switch5.y, wecc_repc.QRegPu) annotation(
    Line(points = {{20, 39}, {-117, 39}, {-117, 11}}, color = {0, 0, 127}));
  connect(switch.y, wecc_repc.PRegPu) annotation(
    Line(points = {{20, 23}, {-112, 23}, {-112, 11}}, color = {0, 0, 127}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-190, 38}, {-177, 38}, {-177, 4}, {-132, 4}}, color = {0, 0, 127}));
  connect(PAuxPu, wecc_repc.PAuxPu) annotation(
    Line(points = {{-125, -70}, {-125, -11}}, color = {0, 0, 127}));
  connect(UAuxPu, wecc_repc.UAuxPu) annotation(
    Line(points = {{-155, -70}, {-155, -20}, {-128, -20}, {-128, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-180, -60}, {130, 120}})));
end PVCurrentSource2;
