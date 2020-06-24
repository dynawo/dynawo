within Dynawo.Examples.HVDC;

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

model HVDC "HVDC link connected to two infinite buses"
  import Dynawo;
  import Modelica;
  extends Icons.Example;
  parameter Real modeU1Set = 1 "Set value of the real assessing the mode of the control at terminal 1: 1 if U mode, 0 if Q mode";
  parameter Real modeU2Set = 1 "Set value of the real assessing the mode of the control at terminal 2: 1 if U mode, 0 if Q mode";
  Dynawo.Examples.HVDC.BaseModel.HvdcVSCNoBlockingFunction HVDC(CdcPu = 1.99, DUDC = 0.01, DeadBandU = 0, PPu_Side.limitsCalculationFunction.ipRefPu(start = 0.885771, fixed = true), InPu = 1.081, Ip10Pu = 0.885771, Ip20Pu = -0.876348, IpMaxCstPu = 1.0, Iq10Pu = -0.297138, Iq20Pu = -0.292657, KiACVoltageControl = 33.5, KiDeltaP = 20, KiPControl = 100, Kidc = 20, KpACVoltageControl = 0, KpDeltaP = 10, KpPControl = 0.4, Kpdc = 40, Lambda = 0.1754386, P10Pu = -8.98, P20Pu = 9, PMaxOPPu = 1, PMinOPPu = -1, Q10Pu = -3.01, Q20Pu = -3.01, QMaxCombPu = 0.4, QMaxOPPu = 0.4, QMinCombPu = -0.6, QMinOPPu = -0.6, RdcPu = 0.000244, SNom = 1000, SlopePRefPu = 0.083333, SlopeQRefPu = 100, SlopeRPFault = 1000, SlopeURefPu = 100, TBlock = 0.1, TBlockUV = 0.01, TDeblockU = 0.02, TQ = 0.1, U10Pu = 1.01381, U20Pu = 1.02696, UBlockUVPu = -1, UMaxdbPu = 1.2, UMindbPu = 0.8, UPhase10 = 0.0316757, UPhase20 = -0.0328494, Udc10Pu = 0.9978, Udc20Pu = 1, UdcMaxPu = 1.05, UdcMinPu = 0.95, UdcRefMaxPu = 1.15, UdcRefMinPu = 0.95, modeU10 = modeU1Set, modeU20 = modeU2Set) annotation(
    Placement(visible = true, transformation(origin = {20, -30}, extent = {{-50, -30}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.00037, XPu = 0.0037) annotation(
    Placement(visible = true, transformation(origin = {-52, -25}, extent = {{-40, -40}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0.00037, XPu = 0.0037) annotation(
    Placement(visible = true, transformation(origin = {82, -25}, extent = {{-40, -40}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus1(UPhase = 0, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-95, -55}, extent = {{-40, -40}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus2(UPhase = 0, UPu = 1.02) annotation(
    Placement(visible = true, transformation(origin = {95, -25}, extent = {{-40, -40}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Step URef1Pu(height = 0, offset = 1.066617, startTime = 3) annotation(
    Placement(visible = true, transformation(origin = {-50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRef1Pu(height = 0, offset = 0.301, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-50, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0, offset = 0.898, startTime = 6) annotation(
    Placement(visible = true, transformation(origin = {-50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant modeU1(k = modeU1Set) annotation(
    Placement(visible = true, transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant modeu2(k = modeU2Set) annotation(
    Placement(visible = true, transformation(origin = {50, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRef2Pu(height = 0, offset = 0.301, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step URef2Pu(height = 0, offset = 1.079767, startTime = 4.5) annotation(
    Placement(visible = true, transformation(origin = {50, 49}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcRefPu(height = 0.0, offset = 1, startTime = 6) annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.00, XPu = 0.0075, tBegin = 0.5, tEnd = 1.5) annotation(
    Placement(visible = true, transformation(origin = {42, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation
  HVDC.PPu_Side.limitsCalculationFunction.iqMod1Pu = 0;
equation
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  HVDC.Conv1.switchOffSignal1.value = false;
  HVDC.Conv1.switchOffSignal2.value = false;
  HVDC.Conv1.switchOffSignal3.value = false;
  HVDC.Conv2.switchOffSignal1.value = false;
  HVDC.Conv2.switchOffSignal2.value = false;
  HVDC.Conv2.switchOffSignal3.value = false;
  connect(HVDC.terminal2, line2.terminal1) annotation(
    Line(points = {{33, -40}, {42, -40}}, color = {0, 0, 255}));
  connect(HVDC.terminal1, line1.terminal2) annotation(
    Line(points = {{-33, -40}, {-42, -40}}, color = {0, 0, 255}));
  connect(line1.terminal1, infiniteBus1.terminal) annotation(
    Line(points = {{-92, -40}, {-110, -40}}, color = {0, 0, 255}));
  connect(line2.terminal2, infiniteBus2.terminal) annotation(
    Line(points = {{92, -40}, {110, -40}}, color = {0, 0, 255}));
  connect(QRef1Pu.y, HVDC.QRef1Pu) annotation(
    Line(points = {{-39, -10}, {-27, -10}, {-27, -18}}, color = {0, 0, 127}));
  connect(URef1Pu.y, HVDC.URef1Pu) annotation(
    Line(points = {{-39, 20}, {-21, 20}, {-21, -18}}, color = {0, 0, 127}));
  connect(PRefPu.y, HVDC.PRefPu) annotation(
    Line(points = {{-39, 50}, {-15, 50}, {-15, -18}}, color = {0, 0, 127}));
  connect(modeU1.y, HVDC.modeU1) annotation(
    Line(points = {{-39, 80}, {-9, 80}, {-9, -18}}, color = {0, 0, 127}));
  connect(modeu2.y, HVDC.modeU2) annotation(
    Line(points = {{39, -10}, {27, -10}, {27, -18}}, color = {0, 0, 127}));
  connect(UdcRefPu.y, HVDC.UdcRefPu) annotation(
    Line(points = {{39, 20}, {21, 20}, {21, -18}}, color = {0, 0, 127}));
  connect(URef2Pu.y, HVDC.URef2Pu) annotation(
    Line(points = {{39, 49}, {15, 49}, {15, -18}}, color = {0, 0, 127}));
  connect(QRef2Pu.y, HVDC.QRef2Pu) annotation(
    Line(points = {{39, 80}, {9, 80}, {9, -18}}, color = {0, 0, 127}));
  connect(nodeFault.terminal, line2.terminal1) annotation(
    Line(points = {{42, -84}, {42, -40}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.0001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
     This test case works with Modelica Standard Library 3.2.3. </div><div><br></div><div>This test case consists in one HVDC link connected to two infinite buses. A short-circuit at the HVDC link terminal 2 is simulated at t = 0.5s and cleared at t = 1.5s.    </div><div><br></div><div>The following figures show the evolution of the active power, reactive power, AC voltage and DC voltage for each terminal of the HVDC link.
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/HVDC/Resources/Images/P.png\">
    </figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/HVDC/Resources/Images/Q.png\">
    </figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/HVDC/Resources/Images/U.png\">
    </figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/HVDC/Resources/Images/Udc.png\">
    </figure>
    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>
"),
    Diagram(coordinateSystem(preserveAspectRatio = false, grid = {1, 1})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", s = "ida", nls="kinsol", nlsLS = "klu",  maxIntegrationOrder = "2", maxStepSize = "10"));
end HVDC;
