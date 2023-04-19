within Dynawo.Electrical.HVDC.HvdcVsc;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model HvdcVscDanglingP "HVDC VSC model with terminal2 connected to a switched-off bus (P control on terminal 1)"
  import Dynawo.Electrical.Constants;

  extends AdditionalIcons.Hvdc;
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsActivePowerControl;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsAcVoltageControl;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsBlockingFunction;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsLimitsCalculation;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  Dynawo.Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(origin = {-130, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2 "Connector used to connect the injector to the grid (switched off side)" annotation(
    Placement(visible = true, transformation(origin = {130, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput modeU1(start = ModeU10) "Mode of control on side 1 : if true, U mode, if false, Q mode" annotation(
    Placement(visible = true, transformation(origin = {-30, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = - P10Pu * (SystemBase.SnRef / SNom)) "Active power reference of the HVDC link in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-60, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QRef1Pu(start = - Q10Pu * (SystemBase.SnRef / SNom)) "Reactive power reference for the side 1 of the HVDC link in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-50, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URef1Pu(start = U10Pu - LambdaPu * Q10Pu * (SystemBase.SnRef / SNom)) "Voltage reference for the side 1 of the HVDC link in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput Conv2_PInjPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Conv2_QInjPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.ActivePowerControlSideDangling PPuSide(InPu = InPu, Ip0Pu = Ip10Pu, IpMaxPu = IpMaxPu, Iq0Pu = Iq10Pu, IqModTableName = IqModTableName, KiAc = KiAc, KiP = KiP, KpAc = KpAc, KpP = KpP, LambdaPu = LambdaPu, P0Pu = - P10Pu * (SystemBase.SnRef / SNom), POpMaxPu = POpMaxPu, POpMinPu = POpMinPu, Q0Pu = - Q10Pu * (SystemBase.SnRef / SNom), QOpMaxPu = QOpMaxPu, QOpMinPu = QOpMinPu, QPMaxTableName = QPMaxTableName, QPMinTableName = QPMinTableName, QUMaxTableName = QUMaxTableName, QUMinTableName = QUMinTableName, SlopePRefPu = SlopePRefPu, SlopeQRefPu = SlopeQRefPu, SlopeRPFault = SlopeRPFault, SlopeURefPu = SlopeURefPu, TablesFile = TablesFile, tMeasure = tMeasure, tMeasureP = tMeasureP, tQ = tQ, U0Pu = U10Pu, ModeU0 = ModeU10) "Active power control side of the HVDC link" annotation(
    Placement(visible = true, transformation(origin = {-45, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.BlockingFunction.BlockingFunction Blocking(tBlock = tBlock, tBlockUnderV = tBlockUnderV, tMeasureUBlock = tMeasureUBlock, tUnblock = tUnblock, UBlockUnderVPu = UBlockUnderVPu, UMaxDbPu = UMaxDbPu, UMinDbPu = UMinDbPu, U0Pu = U10Pu) "Undervoltage blocking function for the two sides of an HVDC Link" annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ Conv1(Id0Pu = Ip10Pu, Iq0Pu = Iq10Pu, P0Pu = P10Pu, Q0Pu = Q10Pu, SNom = SNom, U0Pu = U10Pu, UPhase0 = UPhase10, i0Pu = i10Pu, s0Pu = s10Pu, u0Pu = u10Pu) "Injector of the active power control side of the HVDC link" annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PQDanglingTerminal(k = 0) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = false) annotation(
    Placement(visible = true, transformation(origin = {-15, -50}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRef1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-125, 36}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll1(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u10Pu) annotation(
    Placement(visible = true, transformation(origin = {-103, 30}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Constants.state Conv2_state(start = Conv2_State0) "Converter 2 connection state";

  parameter Constants.state Conv2_State0 = Constants.state.Closed "Start value of converter 2 connection state";
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base SnRef, UNom) (AC to DC)";
  parameter Types.PerUnit Ip10Pu "Start value of active current at terminal 1 in pu (base SNom, UNom) (DC to AC)";
  parameter Types.PerUnit Iq10Pu "Start value of reactive current at terminal 1 in pu (base SNom, UNom) (DC to AC)";
  parameter Boolean ModeU10 "Initial mode of control on side 1 : if true, U mode, if false, Q mode";
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (AC to DC)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (AC to DC)";
  parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (AC to DC)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base UNom)";
  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  parameter Types.Angle UPhase10 "Start value of voltage angle at terminal 1 (in rad)";

equation
  terminal2.i = Complex(0, 0);
  Conv2_state = Conv1.state;

  connect(Conv1.terminal, terminal1) annotation(
    Line(points = {{-101.5, -8}, {-130, -8}}, color = {0, 0, 255}));
  connect(PPuSide.ipRefPu, Conv1.idPu) annotation(
    Line(points = {{-61, 6}, {-79, 6}, {-79, 6}, {-78, 6}}, color = {0, 0, 127}));
  connect(PPuSide.iqRefPu, Conv1.iqPu) annotation(
    Line(points = {{-61, -4}, {-79, -4}, {-79, -4}, {-78, -4}}, color = {0, 0, 127}));
  connect(URef1Pu, PPuSide.URefPu) annotation(
    Line(points = {{-40, 77}, {-40, 17}}, color = {0, 0, 127}));
  connect(QRef1Pu, PPuSide.QRefPu) annotation(
    Line(points = {{-50, 77}, {-50, 17}}, color = {0, 0, 127}));
  connect(PRefPu, PPuSide.PRefPu) annotation(
    Line(points = {{-60, 77}, {-60, 17}, {-59, 17}}, color = {0, 0, 127}));
  connect(Conv1.UPu, PPuSide.UPu) annotation(
    Line(points = {{-101, 8}, {-110, 8}, {-110, -30}, {-45, -30}, {-45, -16}, {-45, -16}}, color = {0, 0, 127}));
  connect(Conv1.PInjPuSn, PPuSide.PPu) annotation(
    Line(points = {{-101, 4}, {-109, 4}, {-109, -25}, {-52, -25}, {-52, -16}}, color = {0, 0, 127}));
  connect(Conv1.QInjPuSn, PPuSide.QPu) annotation(
    Line(points = {{-101, 1}, {-108, 1}, {-108, -20}, {-59, -20}, {-59, -16}}, color = {0, 0, 127}));
  connect(modeU1, PPuSide.modeU) annotation(
    Line(points = {{-30, 77}, {-30, 53}, {-30, 17}, {-30, 17}}, color = {255, 0, 255}));
  connect(Blocking.blocked, PPuSide.blocked1) annotation(
    Line(points = {{-79, -50}, {-37.5, -50}, {-37.5, -16}}, color = {255, 0, 255}));
  connect(booleanConstant.y, PPuSide.blocked2) annotation(
    Line(points = {{-20, -50}, {-34.5, -50}, {-34.5, -16}}, color = {255, 0, 255}));
  connect(Conv1.UPu, Blocking.UPu) annotation(
    Line(points = {{-101, 8}, {-110, 8}, {-110, -50}, {-102, -50}}, color = {0, 0, 127}));
  connect(PQDanglingTerminal.y, Conv2_PInjPu) annotation(
    Line(points = {{91, 40}, {100, 40}, {100, 50}, {130, 50}, {130, 50}}, color = {0, 0, 127}));
  connect(PQDanglingTerminal.y, Conv2_QInjPu) annotation(
    Line(points = {{91, 40}, {100, 40}, {100, 30}, {130, 30}, {130, 30}}, color = {0, 0, 127}));
  connect(omegaRef1.y, pll1.omegaRefPu) annotation(
    Line(points = {{-119.5, 36}, {-114, 36}}, color = {0, 0, 127}));
  connect(pll1.phi, Conv1.UPhase) annotation(
    Line(points = {{-92, 29}, {-90, 29}, {-90, 12}}, color = {0, 0, 127}));
  connect(Conv1.uPu, pll1.uPu) annotation(
    Line(points = {{-101, -3}, {-118, -3}, {-118, 24}, {-114, 24}}, color = {85, 170, 255}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-120, -70}, {120, 70}})));
end HvdcVscDanglingP;
