within Dynawo.Electrical.BESS.WECC;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model BESSPlantCurrentSource "WECC BESS with electrical control model type C, generator/converter model type A and plant control type A "
  extends Dynawo.Electrical.BESS.WECC.BaseClasses.BaseBESSCurrentSource(LvTfo(RPu = RPu, XPu = XPu));
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BasePCS;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PControl0Pu) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QControl0Pu) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = repcA.URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Controls.WECC.REPC.REPCa repcA(DDn = DDn, DUp = DUp, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PControl0Pu = PControl0Pu, PConv0Pu = PConv0Pu, PMaxREPCPu = PMaxREPCPu, PMinREPCPu = PMinREPCPu, QControl0Pu = QControl0Pu, QConv0Pu = QConv0Pu, QMaxREPCPu = QMaxREPCPu, QMinREPCPu = QMinREPCPu, RcPu = RPu, RefFlag = RefFlag, SNom = SNom, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, iControl0Pu = iControl0Pu, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tpREPC = tpREPC, uControl0Pu = uControl0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(HvTfo.switchOffSignal1, injector.switchOffSignal1);
  connect(HvTfo.switchOffSignal2, injector.switchOffSignal2);
  connect(PRefPu, repcA.PRefPu) annotation(
    Line(points = {{-190, 0}, {-160, 0}, {-160, -2}, {-131, -2}}, color = {0, 0, 127}));
  connect(QRefPu, repcA.QRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-131, -6}}, color = {0, 0, 127}));
  connect(URefPu, repcA.URefPu) annotation(
    Line(points = {{-190, -40}, {-120, -40}, {-120, -11}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, repcA.omegaPu) annotation(
    Line(points = {{-149, 49}, {-140, 49}, {-140, 8}, {-131, 8}}, color = {0, 0, 127}));
  connect(repcA.PConvRefPu, reecC.PConvRefPu) annotation(
    Line(points = {{-109, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(repcA.QConvRefPu, reecC.QConvRefPu) annotation(
    Line(points = {{-109, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(LvMeasurements.terminal2, HvTfo.terminal2) annotation(
    Line(points = {{70, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(switch.y, repcA.PRegPu) annotation(
    Line(points = {{20, 23}, {-112, 23}, {-112, 11}}, color = {0, 0, 127}));
  connect(switch5.y, repcA.QRegPu) annotation(
    Line(points = {{20, 39}, {-117, 39}, {-117, 11}}, color = {0, 0, 127}));
  connect(u.y, repcA.uPu) annotation(
    Line(points = {{-20, 63}, {-123, 63}, {-123, 11}}, color = {85, 170, 255}));
  connect(i.y, repcA.iPu) annotation(
    Line(points = {{-20, 93}, {-128, 93}, {-128, 11}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-180, -60}, {130, 120}})),
    Documentation(info = "<html><head></head><body><div><br>The <b>power collection system</b> and measurement nodes are not specified in the WECC standard. Thus, we decided to make it flexible in the model.&nbsp;</div><div><br></div><div>With ConverterLVControl switch, you decide whether the inverter is controlling P,Q,U in low voltage or medium voltage.&nbsp;</div><div><br></div><div>With PPCLocal switch, you decide whether the plant controller is controlling P, Q, U at the model terminal or at a node outside the model.</div><div><br></div><div>Depending on PPCLocal and ConverterLVControl's values, the impedances of the group transformer (<span style=\"font-family: Arial, sans-serif;\">RLvTrPu, XLvTrPu) and of the main transformer (</span><span style=\"font-family: Arial, sans-serif;\">BMvHvPu ,GMvHvPu, RMvHvPu, XMvHvPu) won't be applied to the same block model. The following diagram explains it :
    <figure>
    <img width=\"800\" src=\"modelica://Dynawo/Electrical/Wind/WECC/Resources/PCSFlexibilityDiagram.png\">
    </figure>
    &nbsp;</span></div> </body></html>"));
end BESSPlantCurrentSource;
