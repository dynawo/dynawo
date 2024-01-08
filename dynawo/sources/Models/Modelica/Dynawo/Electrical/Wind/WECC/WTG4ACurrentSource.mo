within Dynawo.Electrical.Wind.WECC;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model WTG4ACurrentSource "WECC Wind Turbine model with a simplified drive train model (dual-mass model) and with a current source as interface with the grid"
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BaseWT4A;
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.REPCaParameters;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Controls.WECC.REPC.REPCa repc(DDnPu = DDnPu, DUpPu = DUpPu, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = -P0Pu * SystemBase.SnRef / SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QGen0Pu = -Q0Pu * SystemBase.SnRef / SNom, QInj0Pu = QInj0Pu, QInjRef0Pu = if not PfFlag and not UFlag and QFlag then UInj0Pu else QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, U0Pu = U0Pu, UCompFlag = UCompFlag, UFrzPu = UFrzPu, UInj0Pu = UInj0Pu, XcPu = XPu, iInj0Pu = -i0Pu * SystemBase.SnRef / SNom, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Start value of voltage module at terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));

  final parameter Types.VoltageModulePu URef0Pu = if UCompFlag then UInj0Pu else (U0Pu - Kc * Q0Pu * SystemBase.SnRef / SNom) "Start value of voltage setpoint for plant level control, calculated depending on UCompFlag, in pu (base UNom)";

equation
  connect(URefPu, repc.URefPu) annotation(
    Line(points = {{-190, -40}, {-120, -40}, {-120, -11}}, color = {0, 0, 127}));
  connect(omegaRefPu, repc.omegaRefPu) annotation(
    Line(points = {{-190, 20}, {-160, 20}, {-160, 4}, {-131, 4}}, color = {0, 0, 127}));
  connect(QRefPu, repc.QRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-131, -6}}, color = {0, 0, 127}));
  connect(measurements.iPu, repc.iPu) annotation(
    Line(points = {{66, 11}, {66, 50}, {-128, 50}, {-128, 11}}, color = {85, 170, 255}));
  connect(measurements.uPu, repc.uPu) annotation(
    Line(points = {{62, 11}, {62, 40}, {-124, 40}, {-124, 11}}, color = {85, 170, 255}));
  connect(measurements.QPu, repc.QRegPu) annotation(
    Line(points = {{58, 11}, {58, 30}, {-116, 30}, {-116, 11}}, color = {0, 0, 127}));
  connect(measurements.PPu, repc.PRegPu) annotation(
    Line(points = {{54, 11}, {54, 20}, {-112, 20}, {-112, 11}}, color = {0, 0, 127}));
  connect(repc.PInjRefPu, reec.PInjRefPu) annotation(
    Line(points = {{-109, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, repc.omegaPu) annotation(
    Line(points = {{-149, 34}, {-140, 34}, {-140, 8}, {-131, 8}}, color = {0, 0, 127}));
  connect(PRefPu, repc.PRefPu) annotation(
    Line(points = {{-190, 0}, {-131, 0}}, color = {0, 0, 127}));
  connect(repc.QInjRefPu, reec.QInjRefPu) annotation(
    Line(points = {{-109, -6}, {-91, -6}}, color = {0, 0, 127}));

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
<li> Generator converter. </li>
<li> Injector (id,iq). </li>
</ul> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC WTG 4A")}, coordinateSystem(initialScale = 0.1)));
end WTG4ACurrentSource;
