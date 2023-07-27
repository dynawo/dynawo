within Dynawo.Electrical.HVDC.HvdcVSC;

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

model HvdcVSCDanglingUdc "HVDC VSC model with terminal2 connected to a switched-off bus (Udc control on terminal 1)"
  import Modelica;
  import Dynawo;
  import Dynawo.Electrical.Constants;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;

  extends AdditionalIcons.Hvdc;
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends HVDC.HvdcVSC.BaseControls.Parameters.ParamsACVoltageControl;
  extends HVDC.HvdcVSC.BaseControls.Parameters.ParamsBaseDCVoltageControl;
  extends HVDC.HvdcVSC.BaseControls.Parameters.ParamsBlockingFunction;
  extends HVDC.HvdcVSC.BaseControls.Parameters.ParamsDCLine;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  parameter Types.CurrentModulePu InPu "Nominal current in pu (base SNom, UNom)";
  parameter Types.PerUnit IpMaxCstPu "Maximum value of the active current in pu (base SNom, UNom)";

  Dynawo.Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(origin = {-130, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2 "Connector used to connect the injector to the grid (switched off side)" annotation(
    Placement(visible = true, transformation(origin = {130, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput modeU1(start = modeU10) "Boolean assessing the mode of the control: 1 if U mode, 0 if Q mode" annotation(
    Placement(visible = true, transformation(origin = {-30, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QRef1Pu(start = - Q10Pu * (SystemBase.SnRef/SNom)) "Reactive power reference for the side 1 of the HVDC link in pu (base SNom) and in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-50, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = UdcRef0Pu) "DC voltage reference of the HVDC link in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-60, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URef1Pu(start = U10Pu - Lambda * Q10Pu * (SystemBase.SnRef/SNom)) "Voltage reference for the side 1 of the HVDC link in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput Conv2_PInjPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Conv2_QInjPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  HVDC.HvdcVSC.BaseControls.DCVoltageControlSideDangling UdcPu_Side(DeadBandU = DeadBandU, InPu = InPu, Ip0Pu = Ip10Pu, IpMaxCstPu = IpMaxCstPu, Iq0Pu = Iq10Pu, KiACVoltageControl = KiACVoltageControl, Kidc = Kidc, KpACVoltageControl = KpACVoltageControl, Kpdc = Kpdc, Lambda = Lambda, P0Pu = - P10Pu * (SystemBase.SnRef/SNom), Q0Pu = - Q10Pu * (SystemBase.SnRef/SNom), QMaxCombPu = QMaxCombPu, QMaxOPPu = QMaxOPPu, QMinCombPu = QMinCombPu, QMinOPPu = QMinOPPu, RdcPu = RdcPu, SNom = SNom, SlopeQRefPu = SlopeQRefPu, SlopeURefPu = SlopeURefPu, TQ = TQ, U0Pu = U10Pu, Udc0Pu = Udc10Pu, UdcRef0Pu = UdcRef0Pu, UdcRefMaxPu = UdcRefMaxPu, UdcRefMinPu = UdcRefMinPu, modeU0 = if modeU10 > 0.5 then true else false, tableQMaxPPu = tableQMaxPPu, tableQMaxUPu = tableQMaxUPu, tableQMinPPu = tableQMinPPu, tableQMinUPu = tableQMinUPu, tableiqMod = tableiqMod) "DC Voltage Control Side of the HVDC link" annotation(
    Placement(visible = true, transformation(origin = {-45, 0}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  HVDC.HvdcVSC.BaseControls.DCLine.DCLine dCLine(CdcPu = CdcPu, P10Pu = - P10Pu * (SystemBase.SnRef/SNom), P20Pu = - P20Pu * (SystemBase.SnRef/SNom), RdcPu = RdcPu, SNom = SNom, U1dc0Pu = Udc10Pu, U2dc0Pu = Udc20Pu) "DC line model" annotation(
    Placement(visible = true, transformation(origin = {5, 0}, extent = {{-20, -10}, {10, 10}}, rotation = 0)));
  Sources.InjectorIDQ Conv1(Id0Pu = Ip10Pu, Iq0Pu = Iq10Pu, P0Pu = P10Pu, Q0Pu = Q10Pu, SNom = SNom, U0Pu = U10Pu, UPhase0 = UPhase10, i0Pu = i10Pu, s0Pu = s10Pu, u0Pu = u10Pu) "Injector of the DC Voltage Control Side of the HVDC link" annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.RealToBoolean realToBoolean1 annotation(
    Placement(visible = true, transformation(origin = {-30, 58}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  HVDC.HvdcVSC.BaseControls.BlockingFunction.BlockingFunction Blocking(TBlock = TBlock, TBlockUV = TBlockUV, TDeblockU = TDeblockU, U0Pu = U10Pu, UBlockUVPu = UBlockUVPu, UMaxdbPu = UMaxdbPu, UMindbPu = UMindbPu) annotation(
    Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant ConstantPdcDanglingTerminal(k = -P20Pu * (SystemBase.SnRef / SNom)) annotation(
    Placement(visible = true, transformation(origin = {43, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PQDanglingTerminal(k = 0) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll1(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u10Pu) annotation(
    Placement(visible = true, transformation(origin = {-103, 30}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRef1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-125, 36}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Constants.state Conv2_state(start = Conv2_State0) "Converter 2 connection state";

  parameter Constants.state Conv2_State0 = Constants.state.Closed "Start value of converter 2 connection state";
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit Ip10Pu "Start value of active current at terminal 1 in pu (base SNom)";
  parameter Types.PerUnit Iq10Pu "Start value of reactive current at terminal 1 in pu (base SNom)";
  parameter Real modeU10 "Start value of the real assessing the mode of the control at terminal 1: 1 if U mode, 0 if Q mode";
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ActivePowerPu P20Pu "Start value of active power at terminal 2 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base UNom)";
  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  parameter Types.VoltageModulePu Udc10Pu "Start value of dc voltage at terminal 1 in pu (base UdcNom)";
  parameter Types.VoltageModulePu Udc20Pu "Start value of dc voltage at terminal 2 in pu (base UdcNom)";
  parameter Types.VoltageModulePu UdcRef0Pu "Start value of dc voltage reference in pu (base UdcNom)";
  parameter Types.Angle UPhase10 "Start value of voltage angle at terminal 1 (in rad)";

equation
  terminal2.i = Complex(0, 0);
  Conv2_state = Conv1.state;
  connect(PQDanglingTerminal.y, Conv2_PInjPu) annotation(
    Line(points = {{91, 40}, {100, 40}, {100, 50}, {130, 50}, {130, 50}}, color = {0, 0, 127}));
  connect(PQDanglingTerminal.y, Conv2_QInjPu) annotation(
    Line(points = {{91, 40}, {100, 40}, {100, 30}, {130, 30}, {130, 30}}, color = {0, 0, 127}));
  connect(UdcPu_Side.ipRefUdcPu, Conv1.idPu) annotation(
    Line(points = {{-61, 6}, {-77, 6}, {-77, 6}, {-78, 6}}, color = {0, 0, 127}));
  connect(UdcPu_Side.iqRefPu, Conv1.iqPu) annotation(
    Line(points = {{-61, -4}, {-78, -4}, {-78, -4}, {-78, -4}}, color = {0, 0, 127}));
  connect(UdcRefPu, UdcPu_Side.UdcRefPu) annotation(
    Line(points = {{-60, 77}, {-60, 77}, {-60, 17}, {-60, 17}}, color = {0, 0, 127}));
  connect(QRef1Pu, UdcPu_Side.QRefPu) annotation(
    Line(points = {{-50, 77}, {-50, 77}, {-50, 17}, {-50, 17}}, color = {0, 0, 127}));
  connect(URef1Pu, UdcPu_Side.URefPu) annotation(
    Line(points = {{-40, 77}, {-40, 77}, {-40, 17}, {-40, 17}}, color = {0, 0, 127}));
  connect(modeU1, realToBoolean1.u) annotation(
    Line(points = {{-30, 77}, {-30, 77}, {-30, 64}, {-30, 64}}, color = {0, 0, 127}));
  connect(realToBoolean1.y, UdcPu_Side.modeU) annotation(
    Line(points = {{-30, 53}, {-30, 53}, {-30, 17}, {-30, 17}}, color = {255, 0, 255}));
  connect(UdcPu_Side.POutPu, dCLine.P1Pu) annotation(
    Line(points = {{-28, 0}, {-18, 0}, {-18, 0}, {-16, 0}}, color = {0, 0, 127}));
  connect(ConstantPdcDanglingTerminal.y, dCLine.P2Pu) annotation(
    Line(points = {{32, 0}, {17, 0}, {17, 0}, {17, 0}}, color = {0, 0, 127}));
  connect(Conv1.UPu, Blocking.UPu) annotation(
    Line(points = {{-101, 8}, {-110, 8}, {-110, -50}, {-72, -50}, {-72, -50}}, color = {0, 0, 127}));
  connect(Blocking.blocked, UdcPu_Side.blocked) annotation(
    Line(points = {{-49, -50}, {-38, -50}, {-38, -16}, {-38, -16}}, color = {255, 0, 255}));
  connect(dCLine.U1dcPu, UdcPu_Side.UdcPu) annotation(
    Line(points = {{-11, -11}, {-11, -11}, {-11, -30}, {-31, -30}, {-31, -16}, {-31, -16}}, color = {0, 0, 127}));
  connect(Conv1.UPu, UdcPu_Side.UPu) annotation(
    Line(points = {{-101, 8}, {-110, 8}, {-110, -30}, {-45, -30}, {-45, -16}, {-45, -16}}, color = {0, 0, 127}));
  connect(Conv1.PInjPuSn, UdcPu_Side.PPu) annotation(
    Line(points = {{-101, 4}, {-109, 4}, {-109, -28}, {-52, -28}, {-52, -16}, {-52, -16}}, color = {0, 0, 127}));
  connect(Conv1.QInjPuSn, UdcPu_Side.QPu) annotation(
    Line(points = {{-101, 1}, {-108, 1}, {-108, -26}, {-59, -26}, {-59, -16}, {-59, -16}}, color = {0, 0, 127}));
  connect(omegaRef1.y, pll1.omegaRefPu) annotation(
    Line(points = {{-119.5, 36}, {-114, 36}}, color = {0, 0, 127}));
  connect(pll1.phi, Conv1.UPhase) annotation(
    Line(points = {{-92, 29}, {-90, 29}, {-90, 12}}, color = {0, 0, 127}));
  connect(Conv1.uPu, pll1.uPu) annotation(
    Line(points = {{-101, -3}, {-118, -3}, {-118, 24}, {-114, 24}}, color = {85, 170, 255}));
  connect(Conv1.terminal, terminal1) annotation(
    Line(points = {{-101, -8}, {-130, -8}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-120, -70}, {120, 70}})),
    Icon(coordinateSystem(grid = {1, 1})));
end HvdcVSCDanglingUdc;
