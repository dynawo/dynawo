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

model DCVoltageControlSide "DC Voltage Control Side of the HVDC link"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.VoltageModulePu UdcRefMaxPu;
  parameter Types.VoltageModulePu UdcRefMinPu;
  parameter Types.PerUnit Kpdc;
  parameter Types.PerUnit Kidc;
  parameter Types.PerUnit IpMaxcstPu;
  parameter Types.CurrentModulePu DUDC;
  parameter Real tableQMaxPPu[:,:]=[-1.049009,0;-1.049,0;-1.018,0.301;0,0.4;1.018,0.301;1.049,0;1.049009,0] "PQ diagram for Q>0";
  parameter Real tableQMaxUPu[:,:]=[0,0.401;1.105263,0.401;1.131579,0;2,0] "UQ diagram for Q>0";
  parameter Real tableQMinPPu[:,:]=[-1.049009,0;-1.049,0;-1.018,-0.288;-0.911,-0.6;0,-0.6;0.911,-0.6;1.018,-0.288;1.049,0;1.049009,0] "PQ diagram for Q<0";
  parameter Real tableQMinUPu[:,:]=[0,0;0.986842,0;1.052632,-0.601;2,-0.601] "UQ diagram for Q<0";
  parameter Real tableiqMod[:,:]=[0,1;0.736842,1;0.894737,0;1.157895,0;1.315789,-1;2,-1] "iqMod diagram";
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

  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = Udc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {31, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput modeU(start = true) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = Q0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = Q0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput ipRefUdcPu(start = Ip0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanOutput activateDeltaP(start = false) annotation(
    Placement(visible = true, transformation(origin = {110, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  Dynawo.Electrical.HVDC.Standard.DCVoltageControl.DCVoltageControl dCVoltageControl(DUDC = DUDC, Ip0Pu = Ip0Pu, IpMaxcstPu = IpMaxcstPu, Kidc = Kidc, Kpdc = Kpdc, Udc0Pu = Udc0Pu, UdcRefMaxPu = UdcRefMaxPu, UdcRefMinPu = UdcRefMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-40, 70}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Dynawo.Electrical.HVDC.Standard.ACVoltageControl.ACVoltageControl aCVoltageControl(DeadBandU = DeadBandU, InPu = InPu, Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, Kiacvoltagecontrol = Kiacvoltagecontrol, Kpacvoltagecontrol = Kpacvoltagecontrol, Lambda = Lambda, P0Pu = P0Pu, Q0Pu = Q0Pu, QMaxCombPu = QMaxCombPu, QMaxOPPu = QMaxOPPu, QMinCombPu = QMinCombPu, QMinOPPu = QMinOPPu, SlopeQRefPu = SlopeQRefPu, SlopeURefPu = SlopeURefPu, TQ = TQ, U0Pu = U0Pu, tableQMaxPPu = tableQMaxPPu, tableQMaxUPu = tableQMaxUPu, tableQMinPPu = tableQMinPPu, tableQMinUPu = tableQMinUPu, tableiqMod = tableiqMod)  annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Dynawo.Electrical.HVDC.Standard.LimitsCalculationFunction.LimitsCalculationFunction limitsCalculationFunction(InPu = InPu, Ip0Pu = Ip0Pu, IpMaxcstPu = IpMaxcstPu, Iq0Pu = Iq0Pu)  annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu Udc0Pu;
  parameter Types.PerUnit Ip0Pu;
  parameter Types.PerUnit Iq0Pu;
  parameter Types.ReactivePowerPu Q0Pu;
  parameter Types.VoltageModulePu U0Pu;
  parameter Types.ActivePowerPu P0Pu;

equation
  connect(aCVoltageControl.iqModPu, limitsCalculationFunction.iqModPu) annotation(
    Line(points = {{-7, 0}, {17, 0}}, color = {0, 0, 127}));
  connect(dCVoltageControl.activateDeltaP, activateDeltaP) annotation(
    Line(points = {{-7, 82}, {110, 82}}, color = {255, 0, 255}));
  connect(dCVoltageControl.ipRefUdcPu, limitsCalculationFunction.ipRefPu) annotation(
    Line(points = {{-7, 58}, {0, 58}, {0, 21}, {17, 21}}, color = {0, 0, 127}));
  connect(aCVoltageControl.iqRefPu, limitsCalculationFunction.iqRefPu) annotation(
    Line(points = {{-7, -21}, {17, -21}}, color = {0, 0, 127}));
  connect(UdcRefPu, dCVoltageControl.UdcRefPu) annotation(
    Line(points = {{-110, 80}, {-73, 80}}, color = {0, 0, 127}));
  connect(UdcPu, dCVoltageControl.UdcPu) annotation(
    Line(points = {{-110, 60}, {-73, 60}}, color = {0, 0, 127}));
  connect(limitsCalculationFunction.IqMinPu, aCVoltageControl.IqMinPu) annotation(
    Line(points = {{32, -33}, {32, -33}, {32, -40}, {-19, -40}, {-19, -33}, {-19, -33}}, color = {0, 0, 127}));
  connect(limitsCalculationFunction.IqMaxPu, aCVoltageControl.IqMaxPu) annotation(
    Line(points = {{68, -33}, {68, -33}, {68, -50}, {-61, -50}, {-61, -33}, {-61, -33}}, color = {0, 0, 127}));
  connect(QRefPu, aCVoltageControl.QRefPu) annotation(
    Line(points = {{-110, 40}, {-80, 40}, {-80, 28}, {-73, 28}, {-73, 27}}, color = {0, 0, 127}));
  connect(URefPu, aCVoltageControl.URefPu) annotation(
    Line(points = {{-110, 20}, {-90, 20}, {-90, 18}, {-75, 18}, {-75, 18}, {-73, 18}}, color = {0, 0, 127}));
  connect(modeU, aCVoltageControl.modeU) annotation(
    Line(points = {{-110, 0}, {-90, 0}, {-90, 10}, {-73, 10}, {-73, 9}}, color = {255, 0, 255}));
  connect(QPu, aCVoltageControl.QPu) annotation(
    Line(points = {{-110, -20}, {-86, -20}, {-86, 0}, {-73, 0}, {-73, 0}}, color = {0, 0, 127}));
  connect(UPu, aCVoltageControl.UPu) annotation(
    Line(points = {{-110, -40}, {-85, -40}, {-85, -8}, {-73, -8}, {-73, -9}}, color = {0, 0, 127}));
  connect(PPu, aCVoltageControl.PPu) annotation(
    Line(points = {{-110, -60}, {-82, -60}, {-82, -17}, {-73, -17}, {-73, -18}}, color = {0, 0, 127}));
  connect(blocked, aCVoltageControl.blocked) annotation(
    Line(points = {{-110, -80}, {-79, -80}, {-79, -26}, {-73, -26}, {-73, -27}}, color = {255, 0, 255}));
  connect(dCVoltageControl.ipRefUdcPu, ipRefUdcPu) annotation(
    Line(points = {{-7, 58}, {110, 58}}, color = {0, 0, 127}));
  connect(aCVoltageControl.iqRefPu, iqRefPu) annotation(
    Line(points = {{-7, -21}, {6, -21}, {6, -60}, {110, -60}, {110, -60}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end DCVoltageControlSide;
