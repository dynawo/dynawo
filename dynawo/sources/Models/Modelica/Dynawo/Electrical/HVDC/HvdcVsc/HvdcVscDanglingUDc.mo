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

model HvdcVscDanglingUDc "HVDC VSC model with terminal2 connected to a switched-off bus (UDc control on terminal 1)"
  import Modelica;
  import Dynawo;
  import Dynawo.Electrical.Constants;
  import Dynawo.Electrical.Sources;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;

  extends AdditionalIcons.Hvdc;
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsAcVoltageControl;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsBlockingFunction;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsDcLine;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsDcVoltageControl;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsLimitsCalculation;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  Dynawo.Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(origin = {-130, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2 "Connector used to connect the injector to the grid (switched off side)" annotation(
    Placement(visible = true, transformation(origin = {130, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput modeU1(start = ModeU10) "Mode of control on side 1 : if true, U mode, if false, Q mode" annotation(
    Placement(visible = true, transformation(origin = {-30, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QRef1Pu(start = - Q10Pu * (SystemBase.SnRef / SNom)) "Reactive power reference for the side 1 of the HVDC link in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-50, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UDcRefPu(start = UDcRef0Pu) "DC voltage reference of the HVDC link in pu (base UDcNom)" annotation(
    Placement(visible = true, transformation(origin = {-60, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URef1Pu(start = U10Pu - LambdaPu * Q10Pu * (SystemBase.SnRef / SNom)) "Voltage reference for the side 1 of the HVDC link in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput Conv2_PInjPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Conv2_QInjPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.DcVoltageControlSideDangling UDcPuSide(InPu = InPu, Ip0Pu = Ip10Pu, IpMaxPu = IpMaxPu, Iq0Pu = Iq10Pu, IqModTableName = IqModTableName, KiAc = KiAc, KiDc = KiDc, KpAc = KpAc, KpDc = KpDc, LambdaPu = LambdaPu, P0Pu = - P10Pu * (SystemBase.SnRef / SNom), Q0Pu = - Q10Pu * (SystemBase.SnRef / SNom), QOpMaxPu = QOpMaxPu, QOpMinPu = QOpMinPu, QPMaxTableName = QPMaxTableName, QPMinTableName = QPMinTableName, QUMaxTableName = QUMaxTableName, QUMinTableName = QUMinTableName, RDcPu = RDcPu, SNom = SNom, SlopeQRefPu = SlopeQRefPu, SlopeURefPu = SlopeURefPu, TablesFile = TablesFile, tMeasure = tMeasure, tMeasureU = tMeasureU, tQ = tQ, U0Pu = U10Pu, UDc0Pu = UDc10Pu, UDcRef0Pu = UDcRef0Pu, UDcRefMaxPu = UDcRefMaxPu, UDcRefMinPu = UDcRefMinPu, ModeU0 = ModeU10) "DC voltage control side of the HVDC link" annotation(
    Placement(visible = true, transformation(origin = {-45, 0}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.DcLine.DcLine dCLine(CDcPu = CDcPu, P10Pu = - P10Pu * (SystemBase.SnRef / SNom), P20Pu = - P20Pu * (SystemBase.SnRef / SNom), RDcPu = RDcPu, SNom = SNom, UDc10Pu = UDc10Pu, UDc20Pu = UDc20Pu) "DC line model" annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-12, -8}, {12, 8}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ Conv1(Id0Pu = Ip10Pu, Iq0Pu = Iq10Pu, P0Pu = P10Pu, Q0Pu = Q10Pu, SNom = SNom, U0Pu = U10Pu, UPhase0 = UPhase10, i0Pu = i10Pu, s0Pu = s10Pu, u0Pu = u10Pu) "Injector of the DC voltage control side of the HVDC link" annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.BlockingFunction.BlockingFunction Blocking(tBlock = tBlock, tBlockUnderV = tBlockUnderV, tMeasureUBlock = tMeasureUBlock, tUnblock = tUnblock, U0Pu = U10Pu, UBlockUnderVPu = UBlockUnderVPu, UMaxDbPu = UMaxDbPu, UMinDbPu = UMinDbPu) annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant ConstantPdcDanglingTerminal(k = -P20Pu * (SystemBase.SnRef / SNom)) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PQDanglingTerminal(k = 0) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll1(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u10Pu) annotation(
    Placement(visible = true, transformation(origin = {-103, 30}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRef1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-125, 36}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Constants.state Conv2_state(start = Conv2_State0) "Converter 2 connection state";

  parameter Constants.state Conv2_State0 = Constants.state.Closed "Start value of converter 2 connection state";
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base SnRef, UNom) (AC to DC)";
  parameter Types.PerUnit Ip10Pu "Start value of active current at terminal 1 in pu (base SNom, UNom) (DC to AC)";
  parameter Types.PerUnit Iq10Pu "Start value of reactive current at terminal 1 in pu (base SNom, UNom) (DC to AC)";
  parameter Boolean ModeU10 "Initial mode of control on side 1 : if true, U mode, if false, Q mode";
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (AC to DC)";
  parameter Types.ActivePowerPu P20Pu "Start value of active power at terminal 2 in pu (base SnRef) (AC to DC)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (AC to DC)";
  parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (AC to DC)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base UNom)";
  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  parameter Types.VoltageModulePu UDc10Pu "Start value of DC voltage at terminal 1 in pu (base UDcNom)";
  parameter Types.VoltageModulePu UDc20Pu "Start value of DC voltage at terminal 2 in pu (base UDcNom)";
  parameter Types.VoltageModulePu UDcRef0Pu "Start value of DC voltage reference in pu (base UDcNom)";
  parameter Types.Angle UPhase10 "Start value of voltage angle at terminal 1 (in rad)";

equation
  terminal2.i = Complex(0, 0);
  Conv2_state = Conv1.state;

  connect(PQDanglingTerminal.y, Conv2_PInjPu) annotation(
    Line(points = {{91, 40}, {100, 40}, {100, 50}, {130, 50}, {130, 50}}, color = {0, 0, 127}));
  connect(PQDanglingTerminal.y, Conv2_QInjPu) annotation(
    Line(points = {{91, 40}, {100, 40}, {100, 30}, {130, 30}, {130, 30}}, color = {0, 0, 127}));
  connect(UDcPuSide.ipRefPu, Conv1.idPu) annotation(
    Line(points = {{-61, 6}, {-77, 6}, {-77, 6}, {-78, 6}}, color = {0, 0, 127}));
  connect(UDcPuSide.iqRefPu, Conv1.iqPu) annotation(
    Line(points = {{-61, -4}, {-78, -4}, {-78, -4}, {-78, -4}}, color = {0, 0, 127}));
  connect(UDcRefPu, UDcPuSide.UDcRefPu) annotation(
    Line(points = {{-60, 77}, {-60, 77}, {-60, 17}, {-60, 17}}, color = {0, 0, 127}));
  connect(QRef1Pu, UDcPuSide.QRefPu) annotation(
    Line(points = {{-50, 77}, {-50, 77}, {-50, 17}, {-50, 17}}, color = {0, 0, 127}));
  connect(URef1Pu, UDcPuSide.URefPu) annotation(
    Line(points = {{-40, 77}, {-40, 77}, {-40, 17}, {-40, 17}}, color = {0, 0, 127}));
  connect(modeU1, UDcPuSide.modeU) annotation(
    Line(points = {{-30, 77}, {-30, 53}, {-30, 17}, {-30, 17}}, color = {255, 0, 255}));
  connect(Conv1.PInjPuSn, dCLine.P1Pu) annotation(
    Line(points = {{-102, 4}, {-109, 4}, {-109, -25}, {-20, -25}, {-20, -5}, {-10, -5}}, color = {0, 0, 127}));
  connect(ConstantPdcDanglingTerminal.y, dCLine.P2Pu) annotation(
    Line(points = {{29, 0}, {20, 0}, {20, -5}, {13, -5}}, color = {0, 0, 127}));
  connect(Conv1.terminal, terminal1) annotation(
    Line(points = {{-101, -8}, {-122, -8}, {-122, -8}, {-130, -8}}, color = {0, 0, 255}));
  connect(Conv1.UPu, Blocking.UPu) annotation(
    Line(points = {{-101, 8}, {-110, 8}, {-110, -50}, {-102, -50}}, color = {0, 0, 127}));
  connect(Blocking.blocked, UDcPuSide.blocked) annotation(
    Line(points = {{-79, -50}, {-38, -50}, {-38, -16}}, color = {255, 0, 255}));
  connect(dCLine.UDc1Pu, UDcPuSide.UDcPu) annotation(
    Line(points = {{-13, 0}, {-28, 0}}, color = {0, 0, 127}));
  connect(Conv1.UPu, UDcPuSide.UPu) annotation(
    Line(points = {{-101, 8}, {-110, 8}, {-110, -30}, {-45, -30}, {-45, -16}, {-45, -16}}, color = {0, 0, 127}));
  connect(Conv1.QInjPuSn, UDcPuSide.QPu) annotation(
    Line(points = {{-101, 1}, {-108, 1}, {-108, -20}, {-59, -20}, {-59, -16}}, color = {0, 0, 127}));
  connect(omegaRef1.y, pll1.omegaRefPu) annotation(
    Line(points = {{-119.5, 36}, {-114, 36}}, color = {0, 0, 127}));
  connect(pll1.phi, Conv1.UPhase) annotation(
    Line(points = {{-92, 29}, {-90, 29}, {-90, 12}}, color = {0, 0, 127}));
  connect(Conv1.uPu, pll1.uPu) annotation(
    Line(points = {{-101, -3}, {-118, -3}, {-118, 24}, {-114, 24}}, color = {85, 170, 255}));
  connect(Conv1.PInjPuSn, UDcPuSide.PPu) annotation(
    Line(points = {{-102, 4}, {-109, 4}, {-109, -25}, {-33, -25}, {-33, -16}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-120, -70}, {120, 70}})));
end HvdcVscDanglingUDc;
