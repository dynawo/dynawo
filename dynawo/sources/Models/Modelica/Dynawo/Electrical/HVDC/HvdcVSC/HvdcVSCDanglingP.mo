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

model HvdcVSCDanglingP "HVDC VSC model with terminal2 connected to a switched-off bus (P control on terminal 1)"
  extends AdditionalIcons.Hvdc;

  import Modelica;
  import Dynawo.Electrical.Sources;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Constants;

  Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(origin = {-130, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal2 "Connector used to connect the injector to the grid (switched off side)" annotation(
    Placement(visible = true, transformation(origin = {130, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_BaseActivePowerControl;
  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_BlockingFunction;
  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_ACVoltageControl;
  parameter Types.PerUnit IpMaxCstPu "Maximum value of the active current in pu (base SNom, UNom)";
  parameter Types.CurrentModulePu InPu "Nominal current in pu (base SNom, UNom)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  Modelica.Blocks.Interfaces.RealInput QRef1Pu(start = - Q10Pu * (SystemBase.SnRef/SNom)) "Reactive power reference for the side 1 of the HVDC link in pu (base SNom) and in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-50, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = - P10Pu * (SystemBase.SnRef/SNom)) "Active power reference of the HVDC link in pu (base SNom) and in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-60, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URef1Pu(start = U10Pu - Lambda * Q10Pu * (SystemBase.SnRef/SNom)) "Voltage reference for the side 1 of the HVDC link in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput modeU1(start = modeU10) "Real assessing the mode of the control: 1 if U mode, 0 if Q mode" annotation(
    Placement(visible = true, transformation(origin = {-30, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  HVDC.HvdcVSC.BaseControls.ActivePowerControlSideDangling PPu_Side(DeadBandU = DeadBandU, InPu = InPu, Ip0Pu = Ip10Pu, IpMaxCstPu = IpMaxCstPu, Iq0Pu = Iq10Pu, KiACVoltageControl = KiACVoltageControl, KiPControl = KiPControl, KpACVoltageControl = KpACVoltageControl, KpPControl = KpPControl, Lambda = Lambda, P0Pu = - P10Pu * (SystemBase.SnRef/SNom), PMaxOPPu = PMaxOPPu, PMinOPPu = PMinOPPu, Q0Pu = - Q10Pu * (SystemBase.SnRef/SNom), QMaxCombPu = QMaxCombPu, QMaxOPPu = QMaxOPPu, QMinCombPu = QMinCombPu, QMinOPPu = QMinOPPu, SlopePRefPu = SlopePRefPu, SlopeQRefPu = SlopeQRefPu, SlopeRPFault = SlopeRPFault, SlopeURefPu = SlopeURefPu, TQ = TQ, U0Pu = U10Pu, modeU0 = if modeU10 > 0.5 then true else false, tableQMaxPPu = tableQMaxPPu, tableQMaxUPu = tableQMaxUPu, tableQMinPPu = tableQMinPPu, tableQMinUPu = tableQMinUPu, tableiqMod = tableiqMod) "Active Power Control Side of the HVDC link"  annotation(
    Placement(visible = true, transformation(origin = {-45, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  HVDC.HvdcVSC.BaseControls.BlockingFunction.BlockingFunction Blocking(TBlock = TBlock, TBlockUV = TBlockUV, TDeblockU = TDeblockU, UBlockUVPu = UBlockUVPu, UMaxdbPu = UMaxdbPu, UMindbPu = UMindbPu, U0Pu = U10Pu) "Undervoltage blocking function for the two sides of an HVDC Link"  annotation(
    Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Sources.InjectorIDQ Conv1(Id0Pu = Ip10Pu, Iq0Pu = Iq10Pu, P0Pu = P10Pu, Q0Pu = Q10Pu, SNom = SNom, U0Pu = U10Pu, UPhase0 = UPhase10, i0Pu = i10Pu, s0Pu = s10Pu, u0Pu = u10Pu) "Injector of the Active Power Control Side of the HVDC link"  annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.RealToBoolean realToBoolean annotation(
    Placement(visible = true, transformation(origin = {-30, 58}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant PQDanglingTerminal(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Conv2_PInjPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Conv2_QInjPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Constants.state Conv2_state(start = Conv2_State0) "Converter 2 connection state";

  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base UNom)";
  parameter Types.Angle UPhase10 "Start value of voltage angle at terminal 1 (in rad)";
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.PerUnit Ip10Pu "Start value of active current at terminal 1 in pu (base SNom)";
  parameter Types.PerUnit Iq10Pu "Start value of reactive current at terminal 1 in pu (base SNom)";
  parameter Real modeU10 "Start value of the real assessing the mode of the control at terminal 1: 1 if U mode, 0 if Q mode";

  parameter Constants.state Conv2_State0 = Constants.state.Closed "Start value of converter 2 connection state";

equation
  connect(modeU1, realToBoolean.u) annotation(
    Line(points = {{-30, 77}, {-30, 64}}, color = {0, 0, 127}));
  connect(Conv1.terminal, terminal1) annotation(
    Line(points = {{-101.5, -8}, {-130, -8}}, color = {0, 0, 255}));
  connect(PPu_Side.ipRefPPu, Conv1.idPu) annotation(
    Line(points = {{-61, 6}, {-79, 6}, {-79, 6}, {-78, 6}}, color = {0, 0, 127}));
  connect(PPu_Side.iqRefPu, Conv1.iqPu) annotation(
    Line(points = {{-61, -4}, {-79, -4}, {-79, -4}, {-78, -4}}, color = {0, 0, 127}));
  connect(URef1Pu, PPu_Side.URefPu) annotation(
    Line(points = {{-40, 77}, {-40, 17}}, color = {0, 0, 127}));
  connect(QRef1Pu, PPu_Side.QRefPu) annotation(
    Line(points = {{-50, 77}, {-50, 17}}, color = {0, 0, 127}));
  connect(PRefPu, PPu_Side.PRefPu) annotation(
    Line(points = {{-60, 77}, {-60, 17}, {-59, 17}}, color = {0, 0, 127}));
  connect(Conv1.UPu, PPu_Side.UPu) annotation(
    Line(points = {{-101, 8}, {-110, 8}, {-110, -30}, {-45, -30}, {-45, -16}, {-45, -16}}, color = {0, 0, 127}));
  connect(Conv1.PInjPuSn, PPu_Side.PPu) annotation(
    Line(points = {{-101, 4}, {-109, 4}, {-109, -28}, {-52, -28}, {-52, -16}, {-52, -16}}, color = {0, 0, 127}));
  connect(Conv1.QInjPuSn, PPu_Side.QPu) annotation(
    Line(points = {{-101, 1}, {-108, 1}, {-108, -26}, {-59, -26}, {-59, -16}, {-59, -16}}, color = {0, 0, 127}));
  connect(realToBoolean.y, PPu_Side.modeU) annotation(
    Line(points = {{-30, 53}, {-30, 53}, {-30, 17}, {-30, 17}}, color = {255, 0, 255}));
  connect(Blocking.blocked, PPu_Side.blocked) annotation(
    Line(points = {{-49, -50}, {-38, -50}, {-38, -16}, {-38, -16}}, color = {255, 0, 255}));
  connect(Conv1.UPu, Blocking.UPu) annotation(
    Line(points = {{-101, 8}, {-110, 8}, {-110, -50}, {-72, -50}, {-72, -50}}, color = {0, 0, 127}));
  connect(PQDanglingTerminal.y, Conv2_PInjPu) annotation(
    Line(points = {{91, 40}, {100, 40}, {100, 50}, {130, 50}, {130, 50}}, color = {0, 0, 127}));
  connect(PQDanglingTerminal.y, Conv2_QInjPu) annotation(
    Line(points = {{91, 40}, {100, 40}, {100, 30}, {130, 30}, {130, 30}}, color = {0, 0, 127}));
  terminal2.i = Complex(0,0);
  Conv2_state = Conv1.state;

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-120, -70}, {120, 70}})),
    Icon(coordinateSystem(grid = {1, 1})));
end HvdcVSCDanglingP;
