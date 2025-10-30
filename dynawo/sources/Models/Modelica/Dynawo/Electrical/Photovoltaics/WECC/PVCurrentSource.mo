within Dynawo.Electrical.Photovoltaics.WECC;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PVCurrentSource "WECC PV model with a current source as interface with the grid (REPC-A REEC-B REGC-A)"
  extends Dynawo.Electrical.Photovoltaics.WECC.BaseClasses.BasePVCurrentSource(LvToMvTfo(BPu = 0, GPu = 0, RPu = RPu, XPu = XPu));
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BasePCS;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu*SystemBase.SnRef/SNom) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu*SystemBase.SnRef/SNom) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Controls.WECC.REPC.REPCa wecc_repc(DDn = DDn, DUp = DUp, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PMaxPu = PMaxPu, PMinPu = PMinPu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, PControl0Pu = PControl0Pu, PConv0Pu = PConv0Pu, QControl0Pu = QControl0Pu, QConv0Pu = QConv0Pu, URef0Pu = URef0Pu, iControl0Pu = iControl0Pu, uControl0Pu = uControl0Pu, SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  final parameter Types.PerUnit URef0Pu = if VCompFlag == true then UInj0Pu else (U0Pu - Kc*Q0Pu*SystemBase.SnRef/SNom) "Start value of voltage setpoint for plant level control, calculated depending on VcompFlag, in pu (base UNom)";

equation
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-190, 0}, {-160, 0}, {-160, -2}, {-131, -2}}, color = {0, 0, 127}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-190, 20}, {-160, 20}, {-160, 4}, {-131, 4}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-131, -6}}, color = {0, 0, 127}));
  connect(URefPu, wecc_repc.URefPu) annotation(
    Line(points = {{-190, -40}, {-120, -40}, {-120, -11}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-149, 49}, {-140, 49}, {-140, 8}, {-131, 8}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.terminal2, TfoPCS.terminal2) annotation(
    Line(points = {{70, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(wecc_repc.PConvRefPu, wecc_reec.PConvRefPu) annotation(
    Line(points = {{-109, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(wecc_repc.QConvRefPu, wecc_reec.QConvRefPu) annotation(
    Line(points = {{-109, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(i.y, wecc_repc.iPu) annotation(
    Line(points = {{-20, 93}, {-128, 93}, {-128, 11}}, color = {85, 170, 255}));
  connect(u.y, wecc_repc.uPu) annotation(
    Line(points = {{-20, 63}, {-40, 63}, {-40, 50}, {-123, 50}, {-123, 11}}, color = {85, 170, 255}));
  connect(switch5.y, wecc_repc.QRegPu) annotation(
    Line(points = {{20, 39}, {-117, 39}, {-117, 11}}, color = {0, 0, 127}));
  connect(switch.y, wecc_repc.PRegPu) annotation(
    Line(points = {{20, 23}, {-112, 23}, {-112, 11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end PVCurrentSource;
