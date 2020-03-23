within Dynawo.Electrical.HVDC.Standard;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model ActivePowerControlSide "Active Power Control Side of the HVDC link"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit Kppcontrol;
  parameter Types.PerUnit Kipcontrol;
  parameter Types.ActivePowerPu PMaxOPPu;
  parameter Types.ActivePowerPu PMinOPPu;
  parameter Types.Time SlopePRefPu;
  parameter Types.VoltageModulePu UdcMinPu;
  parameter Types.VoltageModulePu UdcMaxPu;
  parameter Types.PerUnit Kpdeltap;
  parameter Types.PerUnit Kideltap;
  parameter Types.PerUnit IpMaxcstPu;
  parameter Types.PerUnit SlopeRPFault;
  parameter Real tableQMaxPPu[:,:]=[-1,2;-0.5,2;0,2;0.5,2;1,2];
  parameter Real tableQMaxUPu[:,:]=[0,2;0.25,2;0.5,2;0.75,2;1,2];
  parameter Real tableQMinPPu[:,:]=[-1,-2;-0.5,-2;0,-2;0.5,-2;1,-2];
  parameter Real tableQMinUPu[:,:]=[0,-2;0.25,-2;0.5,-2;0.75,-2;1,-2];
  parameter Real tableiqMod[:,:]=[0,0;1,0;2,0;3,0];
  parameter Types.PerUnit SlopeURefPu;
  parameter Types.PerUnit SlopeQRefPu;
  parameter Types.PerUnit Lambda;
  parameter Types.PerUnit Kiacvoltagecontrol;
  parameter Types.PerUnit Kpacvoltagecontrol;
  parameter Types.ReactivePowerPu QMinCombPu;
  parameter Types.ReactivePowerPu QMaxCombPu;
  parameter Types.PerUnit DeadBandU;
  parameter Types.ReactivePowerPu QMinOPPu;
  parameter Types.ReactivePowerPu QMaxOPPu;
  parameter Types.Time TQ;
  parameter Types.CurrentModulePu InPu;

  Modelica.Blocks.Interfaces.RealInput QRefPu(start = Q0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = Q0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) annotation(
    Placement(visible = true, transformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput modeU(start = true) annotation(
    Placement(visible = true, transformation(origin = {-110, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {89, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput activateDeltaP(start = false) annotation(
    Placement(visible = true, transformation(origin = {-110, 95}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {69, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput ipRefPPu(start = Ip0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Dynawo.Electrical.HVDC.Standard.ActivePowerControl.ActivePowerControl activePowerControl(Ip0Pu = Ip0Pu, IpMaxcstPu = IpMaxcstPu, Kideltap = Kideltap, Kipcontrol = Kipcontrol, Kpdeltap = Kpdeltap, Kppcontrol = Kppcontrol, P0Pu = P0Pu, PMaxOPPu = PMaxOPPu, PMinOPPu = PMinOPPu, SlopePRefPu = SlopePRefPu, SlopeRPFault = SlopeRPFault, Udc0Pu = Udc0Pu, UdcMaxPu = UdcMaxPu, UdcMinPu = UdcMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-40, 70}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Dynawo.Electrical.HVDC.Standard.LimitsCalculationFunction.LimitsCalculationFunction limitsCalculationFunction(InPu = InPu, Ip0Pu = Ip0Pu, IpMaxcstPu = IpMaxcstPu, Iq0Pu = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, -8}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Dynawo.Electrical.HVDC.Standard.ACVoltageControl.ACVoltageControl aCVoltageControl(DeadBandU = DeadBandU, InPu = InPu, Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, Kiacvoltagecontrol = Kiacvoltagecontrol, Kpacvoltagecontrol = Kpacvoltagecontrol, Lambda = Lambda, P0Pu = P0Pu, Q0Pu = Q0Pu, QMaxCombPu = QMaxCombPu, QMaxOPPu = QMaxOPPu, QMinCombPu = QMinCombPu, QMinOPPu = QMinOPPu, SlopeQRefPu = SlopeQRefPu, SlopeURefPu = SlopeURefPu, TQ = TQ, U0Pu = U0Pu, tableQMaxPPu = tableQMaxPPu, tableQMaxUPu = tableQMaxUPu, tableQMinPPu = tableQMinPPu, tableQMinUPu = tableQMinUPu, tableiqMod = tableiqMod) annotation(
    Placement(visible = true, transformation(origin = {-40, -8}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu Udc0Pu;
  parameter Types.ActivePowerPu P0Pu;
  parameter Types.PerUnit Iq0Pu;
  parameter Types.PerUnit Ip0Pu;
  parameter Types.ReactivePowerPu Q0Pu;
  parameter Types.VoltageModulePu U0Pu;

equation
  connect(aCVoltageControl.iqModPu, limitsCalculationFunction.iqModPu) annotation(
    Line(points = {{-7, -8}, {17, -8}}, color = {0, 0, 127}));
  connect(QPu, aCVoltageControl.QPu) annotation(
    Line(points = {{-110, -30}, {-86, -30}, {-86, -8}, {-73, -8}}, color = {0, 0, 127}));
  connect(UPu, aCVoltageControl.UPu) annotation(
    Line(points = {{-110, -50}, {-85, -50}, {-85, -17}, {-73, -17}}, color = {0, 0, 127}));
  connect(blocked, aCVoltageControl.blocked) annotation(
    Line(points = {{-110, -90}, {-79, -90}, {-79, -35}, {-73, -35}}, color = {255, 0, 255}));
  connect(aCVoltageControl.iqRefPu, iqRefPu) annotation(
    Line(points = {{-7, -29}, {6, -29}, {6, -70}, {110, -70}}, color = {0, 0, 127}));
  connect(modeU, aCVoltageControl.modeU) annotation(
    Line(points = {{-110, -10}, {-90, -10}, {-90, 1}, {-73, 1}}, color = {255, 0, 255}));
  connect(URefPu, aCVoltageControl.URefPu) annotation(
    Line(points = {{-110, 10}, {-73, 10}}, color = {0, 0, 127}));
  connect(aCVoltageControl.iqRefPu, limitsCalculationFunction.iqRefPu) annotation(
    Line(points = {{-7, -29}, {17, -29}}, color = {0, 0, 127}));
  connect(QRefPu, aCVoltageControl.QRefPu) annotation(
    Line(points = {{-110, 30}, {-80, 30}, {-80, 19}, {-73, 19}}, color = {0, 0, 127}));
  connect(PPu, aCVoltageControl.PPu) annotation(
    Line(points = {{-110, -70}, {-82, -70}, {-82, -26}, {-73, -26}}, color = {0, 0, 127}));
  connect(limitsCalculationFunction.IqMinPu, aCVoltageControl.IqMinPu) annotation(
    Line(points = {{32, -41}, {32, -50}, {-19, -50}, {-19, -41}}, color = {0, 0, 127}));
  connect(limitsCalculationFunction.IqMaxPu, aCVoltageControl.IqMaxPu) annotation(
    Line(points = {{68, -41}, {68, -60}, {-61, -60}, {-61, -41}}, color = {0, 0, 127}));
  connect(activePowerControl.ipRefPPu, ipRefPPu) annotation(
    Line(points = {{-7, 70}, {110, 70}}, color = {0, 0, 127}));
  connect(activePowerControl.ipRefPPu, limitsCalculationFunction.ipRefPu) annotation(
    Line(points = {{-7, 70}, {0, 70}, {0, 13}, {17, 13}}, color = {0, 0, 127}));
  connect(limitsCalculationFunction.IpMinPu, activePowerControl.IpMinPu) annotation(
    Line(points = {{32, 25}, {32, 28}, {-61, 28}, {-61, 37}}, color = {0, 0, 127}));
  connect(limitsCalculationFunction.IpMaxPu, activePowerControl.IpMaxPu) annotation(
    Line(points = {{68, 25}, {68, 31}, {-19, 31}, {-19, 37}}, color = {0, 0, 127}));
  connect(activateDeltaP, activePowerControl.activateDeltaP) annotation(
    Line(points = {{-110, 95}, {-76, 95}, {-76, 94}, {-73, 94}}, color = {255, 0, 255}));
  connect(PRefPu, activePowerControl.PRefPu) annotation(
    Line(points = {{-110, 80}, {-80, 80}, {-80, 83}, {-73, 83}, {-73, 83}}, color = {0, 0, 127}));
  connect(UdcPu, activePowerControl.UdcPu) annotation(
    Line(points = {{-110, 60}, {-90, 60}, {-90, 71}, {-73, 71}, {-73, 70}}, color = {0, 0, 127}));
  connect(PPu, activePowerControl.PPu) annotation(
    Line(points = {{-110, -70}, {-88, -70}, {-88, 45}, {-73, 45}, {-73, 45}}, color = {0, 0, 127}));
  connect(blocked, activePowerControl.blocked) annotation(
    Line(points = {{-110, -90}, {-94, -90}, {-94, 57}, {-73, 57}, {-73, 57}}, color = {255, 0, 255}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end ActivePowerControlSide;
