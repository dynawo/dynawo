within Dynawo.Electrical.HVDC.HvdcVsc;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model HvdcVsc "HVDC VSC model"
  extends AdditionalIcons.Hvdc;
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsActivePowerControl;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsAcVoltageControl;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsBlockingFunction;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsDcLine;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsDcVoltageControl;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsDeltaP;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsLimitsCalculation;

  parameter Types.CurrentComponentPu IpDeadBandPu "Deadband for the DeltaP function in pu (base SNom, UNom) (DC to AC)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  Dynawo.Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(origin = {-130, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(origin = {130, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput modeU1(start = ModeU10) "Mode of control on side 1 : if true, U mode, if false, Q mode" annotation(
    Placement(visible = true, transformation(origin = {-30, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput modeU2(start = ModeU20) "Mode of control on side 2 : if true, U mode, if false, Q mode" annotation(
    Placement(visible = true, transformation(origin = {30, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = - P10Pu * (SystemBase.SnRef / SNom)) "Active power reference of the HVDC link in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-60, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QRef1Pu(start = - Q10Pu * (SystemBase.SnRef / SNom)) "Reactive power reference for the side 1 of the HVDC link in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-50, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QRef2Pu(start = - Q20Pu * (SystemBase.SnRef / SNom)) "Reactive power reference for the side 2 of the HVDC link in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {50, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UDcRefPu(start = UDcRef0Pu) "DC voltage reference of the HVDC link in pu (base UDcNom)" annotation(
    Placement(visible = true, transformation(origin = {60, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URef1Pu(start = U10Pu - LambdaPu * Q10Pu * (SystemBase.SnRef / SNom)) "Voltage reference for the side 1 of the HVDC link in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URef2Pu(start = U20Pu - LambdaPu * Q20Pu * (SystemBase.SnRef / SNom)) "Voltage reference for the side 2 of the HVDC link in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.DcVoltageControlSide UDcPuSide(InPu = InPu, Ip0Pu = Ip20Pu, IpDeadBandPu = IpDeadBandPu, IpMaxPu = IpMaxPu, Iq0Pu = Iq20Pu, IqModTableName = IqModTableName, KiAc = KiAc, KiDc = KiDc, KpAc = KpAc, KpDc = KpDc, LambdaPu = LambdaPu, P0Pu = - P20Pu * (SystemBase.SnRef / SNom), Q0Pu = - Q20Pu * (SystemBase.SnRef / SNom), QOpMaxPu = QOpMaxPu, QOpMinPu = QOpMinPu, QPMaxTableName = QPMaxTableName, QPMinTableName = QPMinTableName, QUMaxTableName = QUMaxTableName, QUMinTableName = QUMinTableName, RDcPu = RDcPu, SNom = SNom, SlopeQRefPu = SlopeQRefPu, SlopeURefPu = SlopeURefPu, TablesFile = TablesFile, tMeasure = tMeasure, tMeasureU = tMeasureU, tQ = tQ, U0Pu = U20Pu, UDc0Pu = UDc20Pu, UDcRef0Pu = UDcRef0Pu, UDcRefMaxPu = UDcRefMaxPu, UDcRefMinPu = UDcRefMinPu, ModeU0 = ModeU20) "DC voltage control side of the HVDC link" annotation(
    Placement(visible = true, transformation(origin = {45, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.ActivePowerControlSide PPuSide(InPu = InPu, Ip0Pu = Ip10Pu, IpMaxPu = IpMaxPu, Iq0Pu = Iq10Pu, IqModTableName = IqModTableName, KiAc = KiAc, KiDeltaP = KiDeltaP, KiP = KiP, KpAc = KpAc, KpDeltaP = KpDeltaP, KpP = KpP, LambdaPu = LambdaPu, P0Pu = - P10Pu * (SystemBase.SnRef / SNom), POpMaxPu = POpMaxPu, POpMinPu = POpMinPu, Q0Pu = - Q10Pu * (SystemBase.SnRef / SNom), QOpMaxPu = QOpMaxPu, QOpMinPu = QOpMinPu, QPMaxTableName = QPMaxTableName, QPMinTableName = QPMinTableName, QUMaxTableName = QUMaxTableName, QUMinTableName = QUMinTableName, SlopePRefPu = SlopePRefPu, SlopeQRefPu = SlopeQRefPu, SlopeRPFault = SlopeRPFault, SlopeURefPu = SlopeURefPu, TablesFile = TablesFile, tMeasure = tMeasure, tMeasureP = tMeasureP, tQ = tQ, U0Pu = U10Pu, UDc0Pu = UDc10Pu, UDcMaxPu = UDcMaxPu, UDcMinPu = UDcMinPu, ModeU0 = ModeU10) "Active power control side of the HVDC link" annotation(
    Placement(visible = true, transformation(origin = {-45, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.BlockingFunction.BlockingFunction Blocking1(tBlock = tBlock, tBlockUnderV = tBlockUnderV, tMeasureUBlock = tMeasureUBlock, tUnblock = tUnblock, U0Pu = U10Pu, UBlockUnderVPu = UBlockUnderVPu, UMaxDbPu = UMaxDbPu, UMinDbPu = UMinDbPu) "Undervoltage blocking function for side 1" annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.BlockingFunction.BlockingFunction Blocking2(tBlock = tBlock, tBlockUnderV = tBlockUnderV, tMeasureUBlock = tMeasureUBlock, tUnblock = tUnblock, U0Pu = U10Pu, UBlockUnderVPu = UBlockUnderVPu, UMaxDbPu = UMaxDbPu, UMinDbPu = UMinDbPu) "Undervoltage blocking function for side 2" annotation(
    Placement(visible = true, transformation(origin = {90, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.DcLine.DcLine dCLine(CDcPu = CDcPu, P10Pu = - P10Pu * (SystemBase.SnRef / SNom), P20Pu = - P20Pu * (SystemBase.SnRef / SNom), RDcPu = RDcPu, SNom = SNom, UDc10Pu = UDc10Pu, UDc20Pu = UDc20Pu) "DC line model" annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-12, -8}, {12, 8}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ Conv1(Id0Pu = Ip10Pu, Iq0Pu = Iq10Pu, P0Pu = P10Pu, Q0Pu = Q10Pu, SNom = SNom, U0Pu = U10Pu, UPhase0 = UPhase10, i0Pu = i10Pu, s0Pu = s10Pu, u0Pu = u10Pu) "Injector of the active power control side of the HVDC link" annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ Conv2(Id0Pu = Ip20Pu, Iq0Pu = Iq20Pu, P0Pu = P20Pu, Q0Pu = Q20Pu, SNom = SNom, U0Pu = U20Pu, UPhase0 = UPhase20, i0Pu = i20Pu, s0Pu = s20Pu, u0Pu = u20Pu) "Injector of the DC voltage control side of the HVDC link" annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll1(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u10Pu) annotation(
    Placement(visible = true, transformation(origin = {-103, 30}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll2(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u20Pu) annotation(
    Placement(visible = true, transformation(origin = {103, 30}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRef1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-125, 36}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRef2(k = 1) annotation(
    Placement(visible = true, transformation(origin = {125, 36}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));

  Dynawo.Connectors.AngleConnector Theta1(start = UPhase10) "Angle of the voltage at terminal 1 in rad";
  Dynawo.Connectors.AngleConnector Theta2(start = UPhase20) "Angle of the voltage at terminal 2 in rad";

  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base SnRef, UNom) (AC to DC)";
  parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base SnRef, UNom) (AC to DC)";
  parameter Types.CurrentComponentPu Ip10Pu "Start value of active current at terminal 1 in pu (base SNom, UNom) (DC to AC)";
  parameter Types.CurrentComponentPu Ip20Pu "Start value of active current at terminal 2 in pu (base SNom, UNom) (DC to AC)";
  parameter Types.CurrentComponentPu Iq10Pu "Start value of reactive current at terminal 1 in pu (base SNom, UNom) (DC to AC)";
  parameter Types.CurrentComponentPu Iq20Pu "Start value of reactive current at terminal 2 in pu (base SNom, UNom) (DC to AC)";
  parameter Boolean ModeU10 "Initial mode of control on side 1 : if true, U mode, if false, Q mode";
  parameter Boolean ModeU20 "Initial mode of control on side 2 : if true, U mode, if false, Q mode";
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (AC to DC)";
  parameter Types.ActivePowerPu P20Pu "Start value of active power at terminal 2 in pu (base SnRef) (AC to DC)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (AC to DC)";
  parameter Types.ReactivePowerPu Q20Pu "Start value of reactive power at terminal 2 in pu (base SnRef) (AC to DC)";
  parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (AC to DC)";
  parameter Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power at terminal 2 in pu (base SnRef) (AC to DC)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base UNom)";
  parameter Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base UNom)";
  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base UNom)";
  parameter Types.VoltageModulePu UDc10Pu "Start value of DC voltage at terminal 1 in pu (base UDcNom)";
  parameter Types.VoltageModulePu UDc20Pu "Start value of DC voltage at terminal 2 in pu (base UDcNom)";
  parameter Types.VoltageModulePu UDcRef0Pu "Start value of DC voltage reference in pu (base UDcNom)";
  parameter Types.Angle UPhase10 "Start value of voltage angle at terminal 1 (in rad)";
  parameter Types.Angle UPhase20 "Start value of voltage angle at terminal 2 (in rad)";

equation
  Theta1 = pll1.phi;
  Theta2 = pll2.phi;

  connect(modeU1, PPuSide.modeU) annotation(
    Line(points = {{-30, 77}, {-30, 17}}, color = {255, 0, 255}));
  connect(modeU2, UDcPuSide.modeU) annotation(
    Line(points = {{30, 77}, {30, 17}}, color = {255, 0, 255}));
  connect(Conv1.terminal, terminal1) annotation(
    Line(points = {{-101.5, -8}, {-130, -8}}, color = {0, 0, 255}));
  connect(Conv2.terminal, terminal2) annotation(
    Line(points = {{102, -8}, {130, -8}}, color = {0, 0, 255}));
  connect(UDcPuSide.activateDeltaP, PPuSide.activateDeltaP) annotation(
    Line(points = {{29, 13}, {-28, 13}, {-28, 14}, {-28, 14}}, color = {255, 0, 255}));
  connect(dCLine.UDc1Pu, PPuSide.UDcPu) annotation(
    Line(points = {{-9, 0}, {-28, 0}}, color = {0, 0, 127}));
  connect(dCLine.UDc2Pu, UDcPuSide.UDcPu) annotation(
    Line(points = {{9, 0}, {28, 0}}, color = {0, 0, 127}));
  connect(PPuSide.ipRefPu, Conv1.idPu) annotation(
    Line(points = {{-61, 6}, {-78, 6}}, color = {0, 0, 127}));
  connect(PPuSide.iqRefPu, Conv1.iqPu) annotation(
    Line(points = {{-61, -4}, {-78, -4}}, color = {0, 0, 127}));
  connect(URef1Pu, PPuSide.URefPu) annotation(
    Line(points = {{-40, 77}, {-40, 17}}, color = {0, 0, 127}));
  connect(QRef1Pu, PPuSide.QRefPu) annotation(
    Line(points = {{-50, 77}, {-50, 17}}, color = {0, 0, 127}));
  connect(PRefPu, PPuSide.PRefPu) annotation(
    Line(points = {{-60, 77}, {-60, 17}, {-59, 17}}, color = {0, 0, 127}));
  connect(URef2Pu, UDcPuSide.URefPu) annotation(
    Line(points = {{40, 77}, {40, 17}}, color = {0, 0, 127}));
  connect(QRef2Pu, UDcPuSide.QRefPu) annotation(
    Line(points = {{50, 77}, {50, 17}}, color = {0, 0, 127}));
  connect(UDcRefPu, UDcPuSide.UDcRefPu) annotation(
    Line(points = {{60, 77}, {60, 17}}, color = {0, 0, 127}));
  connect(Conv1.UPu, PPuSide.UPu) annotation(
    Line(points = {{-101, 8}, {-110, 8}, {-110, -30}, {-45, -30}, {-45, -16}, {-45, -16}}, color = {0, 0, 127}));
  connect(Conv1.PInjPuSn, PPuSide.PPu) annotation(
    Line(points = {{-101, 4}, {-109, 4}, {-109, -25}, {-52, -25}, {-52, -16}}, color = {0, 0, 127}));
  connect(Conv1.QInjPuSn, PPuSide.QPu) annotation(
    Line(points = {{-101, 1}, {-108, 1}, {-108, -20}, {-59, -20}, {-59, -16}}, color = {0, 0, 127}));
  connect(Conv1.UPu, Blocking1.UPu) annotation(
    Line(points = {{-101, 8}, {-110, 8}, {-110, -50}, {-101, -50}}, color = {0, 0, 127}));
  connect(Conv2.UPu, UDcPuSide.UPu) annotation(
    Line(points = {{102, 8}, {110, 8}, {110, -30}, {45, -30}, {45, -16}, {45, -16}}, color = {0, 0, 127}));
  connect(Conv2.UPu, Blocking2.UPu) annotation(
    Line(points = {{102, 8}, {110, 8}, {110, -50}, {101, -50}}, color = {0, 0, 127}));
  connect(UDcPuSide.ipRefPu, Conv2.idPu) annotation(
    Line(points = {{62, 6}, {79, 6}}, color = {0, 0, 127}));
  connect(UDcPuSide.iqRefPu, Conv2.iqPu) annotation(
    Line(points = {{62, -4}, {79, -4}}, color = {0, 0, 127}));
  connect(Conv2.QInjPuSn, UDcPuSide.QPu) annotation(
    Line(points = {{102, 1}, {108, 1}, {108, -20}, {59, -20}, {59, -16}}, color = {0, 0, 127}));
  connect(PPuSide.iqModPu, UDcPuSide.iqMod1Pu) annotation(
    Line(points = {{-28, 9}, {29, 9}}, color = {0, 0, 127}));
  connect(UDcPuSide.iqModPu, PPuSide.iqMod2Pu) annotation(
    Line(points = {{29, -9}, {-28, -9}, {-28, -9}, {-28, -9}}, color = {0, 0, 127}));
  connect(UDcPuSide.iqRefPu, PPuSide.iqRef2Pu) annotation(
    Line(points = {{62, -4}, {70, -4}, {70, -40}, {-72, -40}, {-72, -10}, {-61, -10}, {-61, -11}}, color = {0, 0, 127}));
  connect(Blocking1.blocked, PPuSide.blocked1) annotation(
    Line(points = {{-79, -50}, {-38, -50}, {-38, -16}}, color = {255, 0, 255}));
  connect(Blocking2.blocked, PPuSide.blocked2) annotation(
    Line(points = {{79, -50}, {-34, -50}, {-34, -16}}, color = {255, 0, 255}));
  connect(Blocking2.blocked, UDcPuSide.blocked) annotation(
    Line(points = {{79, -50}, {38, -50}, {38, -16}}, color = {255, 0, 255}));
  connect(Conv1.PInjPuSn, dCLine.P1Pu) annotation(
    Line(points = {{-102, 4}, {-109, 4}, {-109, -25}, {-20, -25}, {-20, -5}, {-10, -5}}, color = {0, 0, 127}));
  connect(Conv2.PInjPuSn, dCLine.P2Pu) annotation(
    Line(points = {{102, 4}, {109, 4}, {109, -25}, {20, -25}, {20, -5}, {10, -5}}, color = {0, 0, 127}));
  connect(pll1.phi, Conv1.UPhase) annotation(
    Line(points = {{-92, 29}, {-90, 29}, {-90, 12}}, color = {0, 0, 127}));
  connect(pll2.phi, Conv2.UPhase) annotation(
    Line(points = {{92, 29}, {90, 29}, {90, 12}}, color = {0, 0, 127}));
  connect(omegaRef1.y, pll1.omegaRefPu) annotation(
    Line(points = {{-119.5, 36}, {-114, 36}}, color = {0, 0, 127}));
  connect(omegaRef2.y, pll2.omegaRefPu) annotation(
    Line(points = {{119.5, 36}, {114, 36}}, color = {0, 0, 127}));
  connect(Conv1.uPu, pll1.uPu) annotation(
    Line(points = {{-101, -3}, {-118, -3}, {-118, 24}, {-114, 24}}, color = {85, 170, 255}));
  connect(Conv2.uPu, pll2.uPu) annotation(
    Line(points = {{102, -3}, {118, -3}, {118, 24}, {114, 24}}, color = {85, 170, 255}));
  connect(Conv2.PInjPuSn, UDcPuSide.PPu) annotation(
    Line(points = {{102, 4}, {109, 4}, {109, -25}, {33, -25}, {33, -16}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-120, -70}, {120, 70}})));
end HvdcVsc;
