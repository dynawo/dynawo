within Dynawo.Electrical.BESS.WECC.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

partial model BaseBESS "Partial base model for the WECC BESS models including the plant controller"
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.REPCaParameters;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)" annotation(
    Dialog(tab = "Line"));
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)" annotation(
    Dialog(tab = "Line"));

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 8.88178e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary power at injector terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-100, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-80, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-185, 34}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REPC.REPCa repc(DDnPu = DDnPu, DUpPu = DUpPu, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = -P0Pu * SystemBase.SnRef / SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QGen0Pu = -Q0Pu * SystemBase.SnRef / SNom, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, U0Pu = U0Pu, UCompFlag = UCompFlag, UFrzPu = UFrzPu, UInj0Pu = UInj0Pu, XcPu = XPu, iInj0Pu = -i0Pu * SystemBase.SnRef / SNom, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit Ip0Pu "Start value of active current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit Iq0Pu "Start value of reactive current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Real PF0 "Start value of cosinus of power factor angle" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu U0Pu "Start value of voltage module at terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu UInj0Pu "Start value of voltage module at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.Angle UPhaseInj0 "Start value of rotor angle in rad" annotation(
    Dialog(group = "Initialization"));

  final parameter Types.VoltageModulePu URef0Pu = if UCompFlag then UInj0Pu else (U0Pu - Kc * Q0Pu * SystemBase.SnRef / SNom) "Start value of voltage setpoint for plant level control, calculated depending on UCompFlag, in pu (base UNom)";

equation
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{30, 0}, {50, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{70, 0}, {110, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu, repc.omegaRefPu) annotation(
    Line(points = {{-190, 20}, {-160, 20}, {-160, 4}, {-131, 4}}, color = {0, 0, 127}));
  connect(QRefPu, repc.QRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-131, -6}}, color = {0, 0, 127}));
  connect(URefPu, repc.URefPu) annotation(
    Line(points = {{-190, -40}, {-120, -40}, {-120, -11}}, color = {0, 0, 127}));
  connect(measurements.PPu, repc.PRegPu) annotation(
    Line(points = {{54, 11}, {54, 20}, {-112, 20}, {-112, 11}}, color = {0, 0, 127}));
  connect(measurements.QPu, repc.QRegPu) annotation(
    Line(points = {{58, 11}, {58, 30}, {-116, 30}, {-116, 11}}, color = {0, 0, 127}));
  connect(measurements.uPu, repc.uPu) annotation(
    Line(points = {{62, 11}, {62, 40}, {-124, 40}, {-124, 11}}, color = {85, 170, 255}));
  connect(measurements.iPu, repc.iPu) annotation(
    Line(points = {{66, 11}, {66, 50}, {-128, 50}, {-128, 11}}, color = {85, 170, 255}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-179, 34}, {-171, 34}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, repc.omegaPu) annotation(
    Line(points = {{-149, 34}, {-140, 34}, {-140, 8}, {-131, 8}}, color = {0, 0, 127}));
  connect(PRefPu, repc.PRefPu) annotation(
    Line(points = {{-190, 0}, {-131, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC BESS")}),
    Diagram(coordinateSystem(extent = {{-180, -60}, {100, 60}}, grid = {1, 1})));
end BaseBESS;
