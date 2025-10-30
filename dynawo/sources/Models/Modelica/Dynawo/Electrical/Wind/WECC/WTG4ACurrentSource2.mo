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

model WTG4ACurrentSource2 "WECC Wind Turbine model with a simplified drive train model WTGTB (dual-mass model) and with a current source as interface with the grid"
  extends Electrical.Controls.PLL.ParamsPLL;
  extends Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
  extends Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGT;
  extends Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGTb;
  extends Electrical.Wind.WECC.BaseClasses.BaseWT4(LvToMvTfo(BPu = 0, GPu = 0, RPu = RPu, XPu = XPu));
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BasePCS;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Controls.WECC.REPC.REPCa wecc_repc(DDn = DDn, DUp = DUp, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PMaxPu = PMaxPu, PMinPu = PMinPu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, PControl0Pu = PControl0Pu, PConv0Pu = PConv0Pu, QControl0Pu = QControl0Pu, QConv0Pu = QConv0Pu, URef0Pu = URef0Pu, iControl0Pu = iControl0Pu, uControl0Pu = uControl0Pu, SNom = SNom) annotation(
    Placement(transformation(origin = {-118, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Mechanical.WTGTb wecc_wtgt(Dshaft = Dshaft, Hg = Hg, Ht = Ht, Kshaft = Kshaft, tp = tp, PInj0Pu = PInj0Pu, PePu(start = PInj0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-91, -41}, extent = {{-10, -5}, {10, 5}}, rotation = 0)));

  // Initial parameters
  final parameter Types.VoltageModulePu URef0Pu = if VCompFlag == true then UInj0Pu else (U0Pu - Kc * Q0Pu * SystemBase.SnRef / SNom) "Start value of voltage setpoint for plant level control, calculated depending on VcompFlag, in pu (base UNom)";

equation
  connect(URefPu, wecc_repc.URefPu) annotation(
    Line(points = {{-190, -40}, {-120, -40}, {-120, -11}, {-118, -11}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-149, 49}, {-140, 49}, {-140, 8}, {-129, 8}}, color = {0, 0, 127}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-190, 20}, {-160, 20}, {-160, 4}, {-129, 4}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-190, 0}, {-160, 0}, {-160, -2}, {-129, -2}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-129, -6}}, color = {0, 0, 127}));
  connect(injector.PInjPuSn, wecc_wtgt.PePu) annotation(
    Line(points = {{12, -4}, {25, -4}, {25, -41}, {-80, -41}}, color = {0, 0, 127}));
  connect(wecc_wtgt.omegaGPu, wecc_reec.omegaGPu) annotation(
    Line(points = {{-87, -35}, {-85, -35}, {-85, -11}}, color = {0, 0, 127}));
  connect(OmegaRef.y, wecc_wtgt.omegaRefPu) annotation(
    Line(points = {{-179, 38}, {-176, 38}, {-176, -58}, {-113, -58}, {-113, -41}, {-102, -41}}, color = {0, 0, 127}));
  connect(switch.y, wecc_repc.PRegPu) annotation(
    Line(points = {{20, 23}, {-112, 23}, {-112, 11}}, color = {0, 0, 127}));
  connect(switch5.y, wecc_repc.QRegPu) annotation(
    Line(points = {{20, 39}, {-117, 39}, {-117, 11}}, color = {0, 0, 127}));
  connect(u.y, wecc_repc.uPu) annotation(
    Line(points = {{-20, 63}, {-123, 63}, {-123, 11}}, color = {85, 170, 255}));
  connect(i.y, wecc_repc.iPu) annotation(
    Line(points = {{-20, 93}, {-128, 93}, {-128, 11}}, color = {85, 170, 255}));
  connect(wecc_repc.PConvRefPu, wecc_reec.PConvRefPu) annotation(
    Line(points = {{-109, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(wecc_repc.QConvRefPu, wecc_reec.QConvRefPu) annotation(
    Line(points = {{-109, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(WTTerminalMeasurements.terminal2, TfoPCS.terminal2) annotation(
    Line(points = {{70, 0}, {80, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC WTG model according to (in case page cannot be found, copy link in browser): <br><a href=\"https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a> </p>
<p> The overall model is structured as follows:
<ul>
<li> Main model: WECC_Wind with terminal connection and measurement inputs for P/Q/U/I. </li>
<li> Plant level control. </li>
<li> Electrical inverter control.</li>
<li> Simplified drive train model, dual-mass model. </li>
<li> Generator control. </li>
<li> Injector (id,iq). </li>
</ul> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC WTG 4A")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end WTG4ACurrentSource2;
