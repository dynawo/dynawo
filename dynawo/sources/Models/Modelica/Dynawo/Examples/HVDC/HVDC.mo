within Dynawo.Examples.HVDC;

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

model HVDC "HVDC link connected to two infinite buses"
  import Dynawo;
  import Modelica;

  extends Icons.Example;

  Dynawo.Electrical.HVDC.HvdcVsc.HvdcVsc HVDC(
    CDcPu = 1.68,
    i10Pu = Complex(8.3614, -3.488),
    i20Pu = Complex(-8.6047, -3.3591),
    InPu = 1.081,
    Ip10Pu = -0.8678,
    Ip20Pu = 0.8846,
    IpDeadBandPu = 0.01,
    IpMaxPu = 2,
    Iq10Pu = 0.2603,
    Iq20Pu = 0.266,
    IqModTableName = "IqMod",
    KiAc = 33.5,
    KiDc = 20,
    KiDeltaP = 20,
    KiP = 100,
    KiPLL = 1,
    KpAc = 0,
    KpDc = 40,
    KpDeltaP = 10,
    KpP = 0.4,
    KpPLL = 2,
    LambdaPu = 0.1316,
    ModeU10 = true,
    ModeU20 = true,
    OmegaMaxPu = 1.5,
    OmegaMinPu = 0.5,
    P10Pu = 9,
    P20Pu = -8.98057,
    POpMaxPu = 1.05,
    POpMinPu = -1.05,
    Q10Pu = 2.7,
    Q20Pu = 2.7,
    QOpMaxPu = 0.4,
    QOpMinPu = -0.4,
    QPMaxTableName = "QPMax",
    QPMinTableName = "QPMin",
    QUMaxTableName = "QUMax",
    QUMinTableName = "QUMin",
    RDcPu = 0.00012,
    SlopePRefPu = 0.083333,
    SlopeQRefPu = 100,
    SlopeRPFault = 6.7,
    SlopeURefPu = 100,
    SNom = 1000,
    TablesFile = "None",
    tBlock = 0.1,
    tBlockUnderV = 0.01,
    tMeasure = 0.01,
    tMeasureP = 1e-4,
    tMeasureU = 0.01,
    tMeasureUBlock = 1e-4,
    tQ = 0.01,
    tUnblock = 0.02,
    U10Pu = 1.03714,
    U20Pu = 1.01521,
    u10Pu = Complex(1.0316, -0.1074),
    u20Pu = Complex(1.012, 0.0813),
    UBlockUnderVPu = -1,
    UDc10Pu = 0.997804,
    UDc20Pu = 1,
    UDcMaxPu = 1.05,
    UDcMinPu = 0.95,
    UDcRef0Pu = 1,
    UDcRefMaxPu = 1.15,
    UDcRefMinPu = 0.95,
    UMaxDbPu = 1.2,
    UMinDbPu = 0.8,
    UPhase10 = -0.103748,
    UPhase20 = 0.080137,
    PPuSide.aCVoltageControl.IqMod.table = [0.467, 1; 0.8, 0; 1.2, 0; 1.533, -1],
    PPuSide.aCVoltageControl.IqMod.tableOnFile = false,
    PPuSide.aCVoltageControl.qRefLim.QPMax.table = [0, 0.34; 1.1, 0.34],
    PPuSide.aCVoltageControl.qRefLim.QPMax.tableOnFile = false,
    PPuSide.aCVoltageControl.qRefLim.QPMin.table = [0, -0.34; 1.1, -0.34],
    PPuSide.aCVoltageControl.qRefLim.QPMin.tableOnFile = false,
    PPuSide.aCVoltageControl.qRefLim.QUMax.table = [0, 0.34; 1.1, 0.34; 1.101, 0; 2, 0],
    PPuSide.aCVoltageControl.qRefLim.QUMax.tableOnFile = false,
    PPuSide.aCVoltageControl.qRefLim.QUMin.table = [0, 0; 0.85, 0; 0.851, -0.34; 2, -0.34],
    PPuSide.aCVoltageControl.qRefLim.QUMin.tableOnFile = false,
    UDcPuSide.aCVoltageControl.IqMod.table = [0.467, 1; 0.8, 0; 1.2, 0; 1.533, -1],
    UDcPuSide.aCVoltageControl.IqMod.tableOnFile = false,
    UDcPuSide.aCVoltageControl.qRefLim.QPMax.table = [0, 0.34; 1.1, 0.34],
    UDcPuSide.aCVoltageControl.qRefLim.QPMax.tableOnFile = false,
    UDcPuSide.aCVoltageControl.qRefLim.QPMin.table = [0, -0.34; 1.1, -0.34],
    UDcPuSide.aCVoltageControl.qRefLim.QPMin.tableOnFile = false,
    UDcPuSide.aCVoltageControl.qRefLim.QUMax.table = [0, 0.34; 1.1, 0.34; 1.101, 0; 2, 0],
    UDcPuSide.aCVoltageControl.qRefLim.QUMax.tableOnFile = false,
    UDcPuSide.aCVoltageControl.qRefLim.QUMin.table = [0, 0; 0.85, 0; 0.851, -0.34; 2, -0.34],
    UDcPuSide.aCVoltageControl.qRefLim.QUMin.tableOnFile = false) annotation(
    Placement(visible = true, transformation(origin = {20, -30}, extent = {{-50, -30}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.00037, XPu = 0.013) annotation(
    Placement(visible = true, transformation(origin = {-52, -25}, extent = {{-40, -40}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0.00037, XPu = 0.0093) annotation(
    Placement(visible = true, transformation(origin = {82, -25}, extent = {{-40, -40}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus1(UPhase = 0, UPu = 1.08) annotation(
    Placement(visible = true, transformation(origin = {-95, -55}, extent = {{-40, -40}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus2(UPhase = 0, UPu = 1.04) annotation(
    Placement(visible = true, transformation(origin = {95, -25}, extent = {{-40, -40}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.CombiTimeTable URef1Pu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, table = [0, 1.0016; 5, 0.9; 6, 1.0016]) annotation(
    Placement(visible = true, transformation(origin = {-50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRef1Pu(k = -0.27) annotation(
    Placement(visible = true, transformation(origin = {-50, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable PRefPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, table = [0, -0.9; 1, -0.45; 2, -0.9]) annotation(
    Placement(visible = true, transformation(origin = {-50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant modeU1(k = true) annotation(
    Placement(visible = true, transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant modeU2(k = true) annotation(
    Placement(visible = true, transformation(origin = {50, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRef2Pu(k = -0.27) annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable URef2Pu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, table = [0, 0.9797; 7, 1; 8, 0.9797]) annotation(
    Placement(visible = true, transformation(origin = {50, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable UDcRefPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, table = [0, 1; 3, 0.95; 4, 1]) annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 1e-4, tBegin = 8, tEnd = 9) annotation(
    Placement(visible = true, transformation(origin = {42, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
    Line(points = {{30, -40}, {42, -40}}, color = {0, 0, 255}));
  connect(HVDC.terminal1, line1.terminal2) annotation(
    Line(points = {{-30, -40}, {-42, -40}}, color = {0, 0, 255}));
  connect(line1.terminal1, infiniteBus1.terminal) annotation(
    Line(points = {{-92, -40}, {-110, -40}}, color = {0, 0, 255}));
  connect(line2.terminal2, infiniteBus2.terminal) annotation(
    Line(points = {{92, -40}, {110, -40}}, color = {0, 0, 255}));
  connect(QRef1Pu.y, HVDC.QRef1Pu) annotation(
    Line(points = {{-39, -10}, {-27, -10}, {-27, -18}}, color = {0, 0, 127}));
  connect(URef1Pu.y[1], HVDC.URef1Pu) annotation(
    Line(points = {{-39, 20}, {-21, 20}, {-21, -18}}, color = {0, 0, 127}));
  connect(PRefPu.y[1], HVDC.PRefPu) annotation(
    Line(points = {{-39, 50}, {-15, 50}, {-15, -18}}, color = {0, 0, 127}));
  connect(modeU1.y, HVDC.modeU1) annotation(
    Line(points = {{-39, 80}, {-9, 80}, {-9, -18}}, color = {255, 0, 255}));
  connect(modeU2.y, HVDC.modeU2) annotation(
    Line(points = {{39, -10}, {27, -10}, {27, -18}}, color = {255, 0, 255}));
  connect(UDcRefPu.y[1], HVDC.UDcRefPu) annotation(
    Line(points = {{39, 20}, {21, 20}, {21, -18}}, color = {0, 0, 127}));
  connect(URef2Pu.y[1], HVDC.URef2Pu) annotation(
    Line(points = {{39, 50}, {15, 50}, {15, -18}}, color = {0, 0, 127}));
  connect(QRef2Pu.y, HVDC.QRef2Pu) annotation(
    Line(points = {{39, 80}, {9, 80}, {9, -18}}, color = {0, 0, 127}));
  connect(nodeFault.terminal, line2.terminal1) annotation(
    Line(points = {{42, -84}, {42, -40}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.0001, emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
     This test case works with Modelica Standard Library 3.2.3. </div><div><br></div><div>This test case consists in one HVDC link connected to two infinite buses. A short-circuit at the HVDC link terminal 2 is simulated at t = 8 s and cleared at t = 9 s.    </div><div><br></div><div>
    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div>
</span></body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", s = "ida", nls = "hybrid", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10"));
end HVDC;
