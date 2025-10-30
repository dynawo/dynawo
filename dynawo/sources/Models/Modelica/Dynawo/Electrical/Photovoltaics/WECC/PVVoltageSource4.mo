within Dynawo.Electrical.Photovoltaics.WECC;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/
/*                uSourcePu                                uInjPu                      uPu
--------         |                                       |                         |
| Source |--------+---->>--------RSourcePu+jXSourcePu-----+------RPu+jXPu-----<<----+---- terminal
--------           iSourcePu                                                 iPu
*/

model PVVoltageSource4 "WECC PV model with a voltage source as interface with the grid (REPC-A REEC-B REGC-C)"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECb;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
  extends Dynawo.Electrical.Photovoltaics.WECC.BaseClasses.BasePVVoltageSourceC(LvToMvTfo(BPu = 0, GPu = 0, RPu = RPu, XPu = XPu));
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BasePCS;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QInj0Pu) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Controls.WECC.REPC.REPCa wecc_repc(DDn = DDn, DUp = DUp, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PMaxPu = PMaxPu, PMinPu = PMinPu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, PControl0Pu = PControl0Pu, PConv0Pu = PConv0Pu, QControl0Pu = QControl0Pu, QConv0Pu = QConv0Pu, URef0Pu = URef0Pu, iControl0Pu = iControl0Pu, uControl0Pu = uControl0Pu, SNom = SNom) annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.REEC.REECb wecc_reec(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QMaxPu = QMaxPu, QMinPu = QMinPu, UInj0Pu = UInj0Pu, VDipPu = VDipPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, VUpPu = VUpPu, tIq = tIq, tP = tP, tPord = tPord, tRv = tRv, SNom = SNom, PConv0Pu = PConv0Pu, QConv0Pu = QConv0Pu, s0Pu = s0Pu, u0Pu = u0Pu, uConv0Pu = uConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  final parameter Types.PerUnit URef0Pu = if VCompFlag == true then UInj0Pu else U0Pu - Kc*Q0Pu*SystemBase.SnRef/SNom "Start value of voltage setpoint for plant level control, calculated depending on VcompFlag, in pu (base UNom)";

equation
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-190, 0}, {-160, 0}, {-160, -2}, {-131, -2}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-149, 49}, {-140, 49}, {-140, 8}, {-131, 8}}, color = {0, 0, 127}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-190, 20}, {-160, 20}, {-160, 4}, {-131, 4}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-131, -6}}, color = {0, 0, 127}));
  connect(URefPu, wecc_repc.URefPu) annotation(
    Line(points = {{-190, -40}, {-120, -40}, {-120, -11}}, color = {0, 0, 127}));
  connect(PFaRef, wecc_reec.PFaRef) annotation(
    Line(points = {{-79, 70}, {-79, 11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.terminal2, TfoPCS.terminal2) annotation(
    Line(points = {{70, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(wecc_repc.PConvRefPu, wecc_reec.PConvRefPu) annotation(
    Line(points = {{-109, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(wecc_repc.QConvRefPu, wecc_reec.QConvRefPu) annotation(
    Line(points = {{-109, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{-69, 6}, {-61, 6}}, color = {0, 0, 127}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-61, -6}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{-69, 0}, {-61, 0}}, color = {255, 0, 255}));
  connect(i.y, wecc_repc.iPu) annotation(
    Line(points = {{-20, 93}, {-128, 93}, {-128, 11}}, color = {85, 170, 255}));
  connect(u.y, wecc_repc.uPu) annotation(
    Line(points = {{-20, 63}, {-30, 63}, {-30, 50}, {-123, 50}, {-123, 11}}, color = {85, 170, 255}));
  connect(switch5.y, wecc_repc.QRegPu) annotation(
    Line(points = {{20, 39}, {-117, 39}, {-117, 11}}, color = {0, 0, 127}));
  connect(switch.y, wecc_repc.PRegPu) annotation(
    Line(points = {{20, 23}, {-112, 23}, {-112, 11}}, color = {0, 0, 127}));
  connect(wecc_reec.iqMinPu, wecc_regc.iqMinPu) annotation(
    Line(points = {{-72, 11}, {-72, 14}, {-56, 14}, {-56, 11}}, color = {0, 0, 127}));
  connect(wecc_reec.iqMaxPu, wecc_regc.iqMaxPu) annotation(
    Line(points = {{-75, 11}, {-75, 15}, {-52, 15}, {-52, 11}}, color = {0, 0, 127}));
  connect(wecc_reec.ipMinPu, wecc_regc.ipMinPu) annotation(
    Line(points = {{-84, 11}, {-84, 16}, {-48, 16}, {-48, 11}}, color = {0, 0, 127}));
  connect(wecc_reec.ipMaxPu, wecc_regc.ipMaxPu) annotation(
    Line(points = {{-88, 11}, {-88, 18}, {-44, 18}, {-44, 11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.UPu, wecc_regc.UPu) annotation(
    Line(points = {{60, -6}, {60, -17}, {-56, -17}, {-56, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.UPu, wecc_reec.UPu) annotation(
    Line(points = {{60, -6}, {60, -17}, {-74, -17}, {-74, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.PPu, wecc_reec.PConvPu) annotation(
    Line(points = {{62, -6}, {62, -20}, {-80, -20}, {-80, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.QPu, wecc_reec.QConvPu) annotation(
    Line(points = {{64, -6}, {64, -24}, {-89, -24}, {-89, -11}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.uPu, wecc_regc.uInjPu) annotation(
    Line(points = {{66, -6}, {66, -28}, {-42, -28}, {-42, -11}}, color = {85, 170, 255}));
  connect(WTTerminalMeasurements.iPu, wecc_regc.iInjPu) annotation(
    Line(points = {{68, -6}, {68, -32}, {-50, -32}, {-50, -11}}, color = {85, 170, 255}));
  connect(WTTerminalMeasurements.uPu, pll.uPu) annotation(
    Line(points = {{66, -6}, {66, -28}, {-178, -28}, {-178, 50}, {-171, 50}}, color = {85, 170, 255}));
  connect(pll.phi, wecc_regc.phi) annotation(
    Line(points = {{-149, 45}, {-66, 45}, {-66, 9}, {-61, 9}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(extent = {{-180, -60}, {130, 60}}, grid = {1, 1})),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {130, 60}})));
end PVVoltageSource4;
