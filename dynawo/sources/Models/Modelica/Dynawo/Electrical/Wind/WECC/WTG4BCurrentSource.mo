within Dynawo.Electrical.Wind.WECC;

model WTG4BCurrentSource "WECC Wind Turbine model with a current source as interface with the grid"
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
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BaseWT4B;
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BasePCS;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110},extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QControl0Pu) "Reactive power setpoint at regulated bus in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-120, -10}, {-100, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PControl0Pu) "Active power setpoint at regulated bus in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-120, 50}, {-100, 70}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-120, -70}, {-100, -50}}, rotation = 0)));

    Dynawo.Electrical.Controls.WECC.REPC.REPCa wecc_repc(DDn = DDn, DUp = DUp, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PControl0Pu = PControl0Pu, PConv0Pu = PConv0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QControl0Pu = QControl0Pu, QConv0Pu = QConv0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, SNom = SNom, URef0Pu = URef0Pu, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, iControl0Pu = iControl0Pu, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, uControl0Pu = uControl0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.BaseConverters.ElecSystem LvToMvTfo(BPu = 0, GPu = 0, RPu = RPu, SNom = SNom, XPu = XPu, i20Pu = iConv0Pu, u20Pu = uConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  final parameter Types.PerUnit URef0Pu = if VCompFlag == true then UInj0Pu else UPcc0Pu + Kc * QControl0Pu "Start value of voltage setpoint for plant level control, calculated depending on VcompFlag, in pu (base UNom)";

equation
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-149, 49}, {-140, 49}, {-140, 8}, {-131, 8}}, color = {0, 0, 127}));
  connect(wecc_repc.PConvRefPu, wecc_reec.PConvRefPu) annotation(
    Line(points = {{-109, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(wecc_repc.QConvRefPu, wecc_reec.QConvRefPu) annotation(
    Line(points = {{-109, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(URefPu, wecc_repc.URefPu) annotation(
    Line(points = {{-190, -40}, {-120, -40}, {-120, -11}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-190, -20}, {-150, -20}, {-150, -6}, {-131, -6}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-190, 0}, {-150, 0}, {-150, -2}, {-131, -2}}, color = {0, 0, 127}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-190, 20}, {-150, 20}, {-150, 4}, {-131, 4}}, color = {0, 0, 127}));
  connect(switch.y, wecc_repc.PRegPu) annotation(
    Line(points = {{20, 23}, {-112, 23}, {-112, 11}}, color = {0, 0, 127}));
  connect(switch5.y, wecc_repc.QRegPu) annotation(
    Line(points = {{20, 39}, {-117, 39}, {-117, 11}}, color = {0, 0, 127}));
  connect(u.y, wecc_repc.uPu) annotation(
    Line(points = {{-20, 63}, {-123, 63}, {-123, 11}}, color = {85, 170, 255}));
  connect(i.y, wecc_repc.iPu) annotation(
    Line(points = {{-20, 93}, {-128, 93}, {-128, 11}}, color = {85, 170, 255}));
  connect(WTTerminalMeasurements.terminal2, TfoPCS.terminal2) annotation(
    Line(points = {{70, 0}, {80, 0}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p> This block contains the generic WECC WTG model according to (in case page cannot be found, copy link in browser): <br><a href=\"https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a> </p>
<p>This model could also be used for Photovoltaics current source modeling.</p><p> The overall model is structured as follows:
</p><ul>
<li> Main model: WECC_Wind with terminal connection and measurement inputs for P/Q/U/I. </li>
<li> Plant level control. </li>
<li> Electrical inverter control.</li>
<li> Constant speed of drive train represented by constant block (no drive train).</li>
<li> Generator control. </li>
<li> Injector (id,iq). </li>
</ul> <p></p></body></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC WTG 4B")}, coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {1, 1})),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -100}, {100, 100}})));
end WTG4BCurrentSource;
