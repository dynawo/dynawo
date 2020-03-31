within Dynawo.Electrical.HVDC.Standard;

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

model HVDCStandard "HVDC Standard model"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  Dynawo.Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-130, -8}, extent = {{-40, -40}, {40, 40}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(origin = {130, -8}, extent = {{-40, -40}, {40, 40}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit IpMaxcstPu "Maximum value of the active current in p.u (base SNom, UNom)";
  parameter Types.CurrentModulePu InPu "Nominal current in p.u (base SNom, UNom)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  extends Parameters.Params_DCLine;
  extends Parameters.Params_ActivePowerControl;
  extends Parameters.Params_DCVoltageControl;
  extends Parameters.Params_BlockingFunction;
  extends Parameters.Params_ACVoltageControl;

  Modelica.Blocks.Interfaces.RealInput QRef1Pu(start = - Q10Pu / (SNom/SystemBase.SnRef)) "Reactive power reference for the side 1 of the HVDC link in p.u (base SNom) and in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-50, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = - P10Pu / (SNom/SystemBase.SnRef)) "Active power reference of the HVDC link in p.u (base SNom) and in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-60, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URef1Pu(start = U10Pu - Lambda * Q10Pu / (SNom/SystemBase.SnRef)) "Voltage reference for the side 1 of the HVDC link in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput modeU1(start = 1) "Real assessing the mode of the control: 1 if U mode, 0 if Q mode" annotation(
    Placement(visible = true, transformation(origin = {-30, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QRef2Pu(start = - Q20Pu / (SNom/SystemBase.SnRef)) "Reactive power reference for the side 2 of the HVDC link in p.u (base SNom) and in generator convention" annotation(
    Placement(visible = true, transformation(origin = {50, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URef2Pu(start = U20Pu - Lambda * Q20Pu / (SNom/SystemBase.SnRef)) "Voltage reference for the side 2 of the HVDC link in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = Udc20Pu) "DC voltage reference of the HVDC link in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {60, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput modeU2(start = 1) "Boolean assessing the mode of the control: 1 if U mode, 0 if Q mode" annotation(
    Placement(visible = true, transformation(origin = {30, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90), iconTransformation(origin = {90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Dynawo.Electrical.HVDC.Standard.DCVoltageControlSide UdcPu_Side(DUDC = DUDC, DeadBandU = DeadBandU, InPu = InPu, Ip0Pu = Ip20Pu, IpMaxcstPu = IpMaxcstPu, Iq0Pu = Iq20Pu, KiACVoltageControl = KiACVoltageControl, Kidc = Kidc, KpACVoltageControl = KpACVoltageControl, Kpdc = Kpdc, Lambda = Lambda, P0Pu = - P20Pu / (SNom/SystemBase.SnRef), Q0Pu = - Q20Pu / (SNom/SystemBase.SnRef), QMaxCombPu = QMaxCombPu, QMaxOPPu = QMaxOPPu, QMinCombPu = QMinCombPu, QMinOPPu = QMinOPPu, SlopeQRefPu = SlopeQRefPu, SlopeURefPu = SlopeURefPu, TQ = TQ, U0Pu = U20Pu, Udc0Pu = Udc20Pu, UdcRefMaxPu = UdcRefMaxPu, UdcRefMinPu = UdcRefMinPu, tableQMaxPPu = tableQMaxPPu, tableQMaxUPu = tableQMaxUPu, tableQMinPPu = tableQMinPPu, tableQMinUPu = tableQMinUPu, tableiqMod = tableiqMod)  annotation(
    Placement(visible = true, transformation(origin = {45, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.HVDC.Standard.ActivePowerControlSide PPu_Side(DeadBandU = DeadBandU, InPu = InPu, Ip0Pu = Ip10Pu, IpMaxcstPu = IpMaxcstPu, Iq0Pu = Iq10Pu, KiACVoltageControl = KiACVoltageControl, KiDeltaP = KiDeltaP, KiPControl = KiPControl, KpACVoltageControl = KpACVoltageControl, KpDeltaP = KpDeltaP, KpPControl = KpPControl, Lambda = Lambda, P0Pu = - P10Pu / (SNom/SystemBase.SnRef), PMaxOPPu = PMaxOPPu, PMinOPPu = PMinOPPu, Q0Pu = - Q10Pu / (SNom/SystemBase.SnRef), QMaxCombPu = QMaxCombPu, QMaxOPPu = QMaxOPPu, QMinCombPu = QMinCombPu, QMinOPPu = QMinOPPu, SlopePRefPu = SlopePRefPu, SlopeQRefPu = SlopeQRefPu, SlopeRPFault = SlopeRPFault, SlopeURefPu = SlopeURefPu, TQ = TQ, U0Pu = U10Pu, Udc0Pu = Udc10Pu, UdcMaxPu = UdcMaxPu, UdcMinPu = UdcMinPu, tableQMaxPPu = tableQMaxPPu, tableQMaxUPu = tableQMaxUPu, tableQMinPPu = tableQMinPPu, tableQMinUPu = tableQMinUPu, tableiqMod = tableiqMod)  annotation(
    Placement(visible = true, transformation(origin = {-45, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.HVDC.Standard.BlockingFunction.GeneralBlockingFunction Blocking(TBlock = TBlock, TBlockUV = TBlockUV, TDeblockU = TDeblockU, UBlockUVPu = UBlockUVPu, UMaxdbPu = UMaxdbPu, UMindbPu = UMindbPu, U10Pu = U10Pu, U20Pu = U20Pu)  annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.HVDC.Standard.DCLine.DCLine dCLine(CdcPu = CdcPu, P10Pu = - P10Pu / (SNom/SystemBase.SnRef), P20Pu = - P20Pu / (SNom/SystemBase.SnRef), RdcPu = RdcPu, U1dc0Pu = Udc10Pu, U2dc0Pu = Udc20Pu)  annotation(
    Placement(visible = true, transformation(origin = {5, 0}, extent = {{-20, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ Conv1(Id0Pu = Ip10Pu, Iq0Pu = Iq10Pu, P0Pu = P10Pu / (SNom/SystemBase.SnRef), Q0Pu = Q10Pu / (SNom/SystemBase.SnRef), SNom = SNom, U0Pu = U10Pu, UPhase0 = UPhase10, i0Pu = i10Pu, s0Pu = s10Pu, u0Pu = u10Pu)  annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ Conv2(Id0Pu = Ip20Pu, Iq0Pu = Iq20Pu, P0Pu = P20Pu / (SNom/SystemBase.SnRef), Q0Pu = Q20Pu / (SNom/SystemBase.SnRef), SNom = SNom, U0Pu = U20Pu, UPhase0 = UPhase20, i0Pu = i20Pu, s0Pu = s20Pu, u0Pu = u20Pu)  annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.RealToBoolean realToBoolean annotation(
    Placement(visible = true, transformation(origin = {-30, 58}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Math.RealToBoolean realToBoolean1 annotation(
    Placement(visible = true, transformation(origin = {30, 58}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));

protected

  parameter Types.VoltageModulePu U10Pu  "Start value of voltage amplitude at terminal 1 in p.u (base UNom)";
  parameter Types.Angle UPhase10  "Start value of voltage angle at terminal 1 (in rad)";
  parameter Types.ActivePowerPu P10Pu  "Start value of active power at terminal 1 in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu  "Start value of reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in p.u (base UNom)";
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu Udc10Pu "Start value of dc voltage at terminal 1 in p.u (base SNom, UNom)";
  parameter Types.PerUnit Ip10Pu "Start value of active current at terminal 1 in p.u (base SNom)";
  parameter Types.PerUnit Iq10Pu "Start value of reactive current at terminal 1 in p.u (base SNom)";

  parameter Types.VoltageModulePu U20Pu  "Start value of voltage amplitude at terminal 2 in p.u (base UNom)";
  parameter Types.Angle UPhase20  "Start value of voltage angle at terminal 2 (in rad)";
  parameter Types.ActivePowerPu P20Pu  "Start value of active power at terminal 2 in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q20Pu  "Start value of reactive power at terminal 2 in p.u (base SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in p.u (base UNom)";
  parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in p.u (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power at terminal 2 in p.u (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu Udc20Pu "Start value of dc voltage at terminal 2 in p.u (base SNom, UNom)";
  parameter Types.PerUnit Ip20Pu "Start value of active current at terminal 2 in p.u (base SNom)";
  parameter Types.PerUnit Iq20Pu "Start value of reactive current at terminal 2 in p.u (base SNom)";
equation
  connect(modeU1, realToBoolean.u) annotation(
    Line(points = {{-30, 77}, {-30, 64}}, color = {0, 0, 127}));
  connect(modeU2, realToBoolean1.u) annotation(
    Line(points = {{30, 77}, {30, 64}}, color = {0, 0, 127}));
  connect(Conv1.terminal, terminal1) annotation(
    Line(points = {{-101.5, -8}, {-130, -8}}, color = {0, 0, 255}));
  connect(Conv2.terminal, terminal2) annotation(
    Line(points = {{102, -8}, {130, -8}}, color = {0, 0, 255}));
  connect(UdcPu_Side.activateDeltaP, PPu_Side.activateDeltaP) annotation(
    Line(points = {{29, 13}, {-28, 13}, {-28, 14}, {-28, 14}}, color = {255, 0, 255}));
  connect(PPu_Side.POutPu, dCLine.P1Pu) annotation(
    Line(points = {{-28, 0}, {-16.5, 0}}, color = {0, 0, 127}));
  connect(UdcPu_Side.POutPu, dCLine.P2Pu) annotation(
    Line(points = {{29, 0}, {16.5, 0}}, color = {0, 0, 127}));
  connect(dCLine.U1dcPu, PPu_Side.UdcPu) annotation(
    Line(points = {{-11, -11}, {-11, -11}, {-11, -24}, {-31, -24}, {-31, -16}, {-31, -16}}, color = {0, 0, 127}));
  connect(dCLine.U2dcPu, UdcPu_Side.UdcPu) annotation(
    Line(points = {{10, -11}, {10, -11}, {10, -24}, {31, -24}, {31, -16}, {31, -16}}, color = {0, 0, 127}));
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
  connect(realToBoolean1.y, UdcPu_Side.modeU) annotation(
    Line(points = {{30, 52.5}, {30, 17}}, color = {255, 0, 255}));
  connect(URef2Pu, UdcPu_Side.URefPu) annotation(
    Line(points = {{40, 77}, {40, 17}}, color = {0, 0, 127}));
  connect(QRef2Pu, UdcPu_Side.QRefPu) annotation(
    Line(points = {{50, 77}, {50, 17}}, color = {0, 0, 127}));
  connect(UdcRefPu, UdcPu_Side.UdcRefPu) annotation(
    Line(points = {{60, 77}, {60, 17}}, color = {0, 0, 127}));
  connect(Blocking.blocked, PPu_Side.blocked) annotation(
    Line(points = {{0, -39}, {0, -39}, {0, -30}, {-38, -30}, {-38, -16}, {-39, -16}}, color = {255, 0, 255}));
  connect(Blocking.blocked, UdcPu_Side.blocked) annotation(
    Line(points = {{0, -39}, {0, -39}, {0, -30}, {38, -30}, {38, -16}, {39, -16}}, color = {255, 0, 255}));
  connect(Conv1.UPu, PPu_Side.UPu) annotation(
    Line(points = {{-101, 8}, {-110, 8}, {-110, -30}, {-45, -30}, {-45, -16}, {-45, -16}}, color = {0, 0, 127}));
  connect(Conv1.PInjPu, PPu_Side.PPu) annotation(
    Line(points = {{-101, 4}, {-109, 4}, {-109, -28}, {-52, -28}, {-52, -16}, {-52, -16}}, color = {0, 0, 127}));
  connect(Conv1.QInjPu, PPu_Side.QPu) annotation(
    Line(points = {{-101, 1}, {-108, 1}, {-108, -26}, {-59, -26}, {-59, -16}, {-59, -16}}, color = {0, 0, 127}));
  connect(Conv1.UPu, Blocking.U1Pu) annotation(
    Line(points = {{-101, 8}, {-110, 8}, {-110, -50}, {-11, -50}, {-11, -50}}, color = {0, 0, 127}));
  connect(Conv2.UPu, UdcPu_Side.UPu) annotation(
    Line(points = {{102, 8}, {110, 8}, {110, -30}, {45, -30}, {45, -16}, {45, -16}}, color = {0, 0, 127}));
  connect(Conv2.UPu, Blocking.U2Pu) annotation(
    Line(points = {{102, 8}, {110, 8}, {110, -50}, {11, -50}, {11, -50}}, color = {0, 0, 127}));
  connect(UdcPu_Side.ipRefUdcPu, Conv2.idPu) annotation(
    Line(points = {{62, 6}, {77, 6}, {77, 6}, {79, 6}}, color = {0, 0, 127}));
  connect(UdcPu_Side.iqRefPu, Conv2.iqPu) annotation(
    Line(points = {{62, -4}, {77, -4}, {77, -4}, {79, -4}}, color = {0, 0, 127}));
  connect(realToBoolean.y, PPu_Side.modeU) annotation(
    Line(points = {{-30, 53}, {-30, 53}, {-30, 17}, {-30, 17}}, color = {255, 0, 255}));
  connect(Conv2.QInjPu, UdcPu_Side.QPu) annotation(
    Line(points = {{102, 1}, {108, 1}, {108, -26}, {59, -26}, {59, -16}, {59, -16}}, color = {0, 0, 127}));
  connect(UdcPu_Side.PPu, Conv2.PInjPu) annotation(
    Line(points = {{52, -16}, {52, -16}, {52, -28}, {109, -28}, {109, 4}, {102, 4}, {102, 4}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-120, -70}, {120, 70}})),
    Icon(coordinateSystem(grid = {1, 1})));
end HVDCStandard;
