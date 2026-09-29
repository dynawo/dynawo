within Dynawo.Examples.GridFollowing.FourVSC;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model FourVSCDynamicLinesConv "Four grid-following converters in a meshed network with dynamic lines: fault at bus A"
  // HVDC1 - Bus A
  Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLConverterUCtrl gFLHVDC1(SNom = 1200, U0Pu = 1.016485, UPhase0 = 0.210724, P0Pu = -11.445, Q0Pu = 0.536945, Omega0Pu = 1.0, tVSC = 1e-3, RFilterPu = 0.005, LFilterPu = 0.15, CFilterPu = 1e-9, omegaNom = 2*Modelica.Constants.pi*50, RTransformerLVPu = 1e-5, LTransformerLVPu = 1e-5, RTransformerHVPu = 1e-5, LTransformerHVPu = 1e-5, KFilter = 1, tFilter = 0.0033, Kpc = 0.5730, Kic = 6, KpdOuter = 0.0333, KidOuter = 10, KpqOuter = 0.1667, KiqOuter = 50, UBoostHighPu = 1.1, UBoostLowPu = 0.9, Kqv = 0, IMaxPu = 1.1, PQFlag = false, IqBoostMaxPu = 2, IqBoostMinPu = -2, KpPLL = 0.31831, KiPLL = 7.95775, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, DidMax = 0.5, DidMin = -999, tSid = 1e-4, Kfd = 1, Kfq = 0, tBoost = 1e-3, PControlFlag = false) annotation(
    Placement(transformation(origin = {-222, 102}, extent = {{-20, -20}, {20, 20}})));
  // HVDC2 - Bus B
  Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLConverterUCtrl gFLHVDC2(SNom = 1700, U0Pu = 1.018446, UPhase0 = 0.216682, P0Pu = -13.94108, Q0Pu = -5.04, Omega0Pu = 1.0, tVSC = 1e-3, RFilterPu = 0.005, LFilterPu = 0.15, CFilterPu = 1e-9, omegaNom = 2*Modelica.Constants.pi*50, RTransformerLVPu = 1e-5, LTransformerLVPu = 1e-5, RTransformerHVPu = 1e-5, LTransformerHVPu = 1e-5, KFilter = 1, tFilter = 0.0033, Kpc = 0.5730, Kic = 6,  KpdOuter = 0.1667, KidOuter = 50, KpqOuter = 0.1667, KiqOuter = 50, UBoostHighPu = 1.1, UBoostLowPu = 0.9, Kqv = 0, IMaxPu = 1.1, PQFlag = false, IqBoostMaxPu = 2, IqBoostMinPu = -2, KpPLL = 0.31831, KiPLL = 7.95775, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, DidMax = 0.5, DidMin = -999, tSid = 1e-4, Kfd = 1, Kfq = 0, tBoost = 1e-3, PControlFlag = false) annotation(
    Placement(transformation(origin = {198, 102}, extent = {{20, -20}, {-20, 20}})));
  // WP1 converter (wind park) - Bus E
  Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLConverterUCtrl gFLWP1(SNom = 2400, U0Pu = 1.06870, UPhase0 = 0.352335, P0Pu = -19.916, Q0Pu = 1.594, Omega0Pu = 1.0, tVSC = 1e-3, RFilterPu = 0.005, LFilterPu = 0.12, CFilterPu = 1e-9, omegaNom = 2*Modelica.Constants.pi*50, RTransformerLVPu = 1e-5, LTransformerLVPu = 1e-5, RTransformerHVPu = 1e-5, LTransformerHVPu = 1e-5, KFilter = 1, tFilter = 0.0333, Kpc = 0.4584, Kic = 6,  KpdOuter = 0.0333, KidOuter = 10, KpqOuter = 0.033, KiqOuter = 10, UBoostHighPu = 1.1, UBoostLowPu = 0.9, Kqv = 0, IMaxPu = 1, PQFlag = false, IqBoostMaxPu = 2, IqBoostMinPu = -2, KpPLL = 0.31831, KiPLL = 7.95775, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, DidMax = 0.5, DidMin = -999, tSid = 1e-4, Kfd = 1, Kfq = 0, tBoost = 1e-3, PControlFlag = false) annotation(
    Placement(transformation(origin = {-236, -154}, extent = {{-20, -20}, {20, 20}})));
  // WP2 converter (wind park) - Bus F
  Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLConverterUCtrl gFLWP2(SNom = 2400, U0Pu = 1.037386, UPhase0 = 0.366498, P0Pu = -19.917, Q0Pu = 7.368258, Omega0Pu = 1.0, tVSC = 1e-3, RFilterPu = 0.005, LFilterPu = 0.12, CFilterPu = 1e-9, omegaNom = 2*Modelica.Constants.pi*50, RTransformerLVPu = 1e-5, LTransformerLVPu = 1e-5, RTransformerHVPu = 1e-5, LTransformerHVPu = 1e-5, KFilter = 1, tFilter = 0.0033, Kpc = 0.4584, Kic = 6, KpdOuter = 0.0333, KidOuter = 10, KpqOuter = 0.1667, KiqOuter = 50, UBoostHighPu = 1.1, UBoostLowPu = 0.9, Kqv = 0, IMaxPu = 1.1, PQFlag = false, IqBoostMaxPu = 2, IqBoostMinPu = -2, KpPLL = 0.31831, KiPLL = 7.95775, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, DidMax = 0.5, DidMin = -999, tSid = 1e-4, Kfd = 1, Kfq = 0, tBoost = 1e-3, PControlFlag = false) annotation(
    Placement(transformation(origin = {230, -146}, extent = {{20, -20}, {-20, 20}})));
  // Lines (per-unit impedances, base SnRef=100MVA)
  // A-B (Line1/Line2)
  Electrical.Lines.Line lineAB1(RPu = 0.00031875, XPu = 0.0064, BPu = 0.1536/2, GPu = 0) annotation(
    Placement(transformation(origin = {0, 82}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line lineAB2(RPu = 0.00031875, XPu = 0.0064, BPu = 0.1536/2, GPu = 0) annotation(
    Placement(transformation(origin = {2, 30}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line lineAC1(RPu = 0.00065, XPu = 0.013, BPu = 0.3136/2, GPu = 0) annotation(
    Placement(transformation(origin = {-100, -30}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line lineAC2(RPu = 0.00065, XPu = 0.013, BPu = 0.3136/2, GPu = 0) annotation(
    Placement(transformation(origin = {-140, -60}, extent = {{-10, -10}, {10, 10}})));
  // B-C (Line5/Line6)
  Electrical.Lines.DynLineRLC lineBC1(RPu = 0.0007, XPu = 0.014, BPu = 0.336/2, GPu = 0, U01Pu = 1.01845, UPhase01 = 0.21668, P01Pu = 15.75887, Q01Pu = 2.04163, U02Pu = 1.00055, UPhase02 = 0.00000, P02Pu = -15.58796, Q02Pu = 1.03420) annotation(
    Placement(transformation(origin = {100, -30}, extent = {{10, -10}, {-10, 10}})));
  Electrical.Lines.DynLineRLC lineBC2(RPu = 0.0007, XPu = 0.014, BPu = 0.336/2, GPu = 0, U01Pu = 1.01845, UPhase01 = 0.21668, P01Pu = 15.75887, Q01Pu = 2.04163, U02Pu = 1.00055, UPhase02 = 0.00000, P02Pu = -15.58796, Q02Pu = 1.03420) annotation(
    Placement(transformation(origin = {140, -60}, extent = {{10, -10}, {-10, 10}})));
  // A2-E (Line7)
  Electrical.Lines.DynLineRLC lineA2E(RPu = 0.00082963, XPu = 0.0016395, BPu = 9.1125/2, GPu = 0, U01Pu = 1.05091, UPhase01 = 0.32458, P01Pu = -19.62557, Q01Pu = -6.24039, U02Pu = 1.06870, UPhase02 = 0.35234, P02Pu = 19.91600, Q02Pu = -3.42139) annotation(
    Placement(transformation(origin = {-220, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  // B2-F (Line8)
  Electrical.Lines.DynLineRLC lineB2F(RPu = 0.00082963, XPu = 0.0016395, BPu = 9.1125/2, GPu = 0, U01Pu = 1.02590, UPhase01 = 0.33389, P01Pu = -19.60662, Q01Pu = -1.71674, U02Pu = 1.03739, UPhase02 = 0.36650, P02Pu = 19.91712, Q02Pu = -7.36826) annotation(
    Placement(transformation(origin = {220, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  // Network buses
  Electrical.Buses.Bus busA annotation(
    Placement(transformation(origin = {-180, 60}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.Bus busB annotation(
    Placement(transformation(origin = {180, 60}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.Bus busC annotation(
    Placement(transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.Bus busA2 annotation(
    Placement(transformation(origin = {-220, -20}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.Bus busB2 annotation(
    Placement(transformation(origin = {220, -20}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.Bus busE annotation(
    Placement(transformation(origin = {-220, -100}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.Bus busF annotation(
    Placement(transformation(origin = {220, -100}, extent = {{-10, -10}, {10, 10}})));
  // Infinite bus
  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.00055, UPhase = 0.0, omega0Pu = 1.0, UEvtPu = 1.00055, tUEvtStart = 1e6, tUEvtEnd = 1e6, omegaEvtPu = 1.0, tOmegaEvtStart = 1e6, tOmegaEvtEnd = 1e6) annotation(
    Placement(transformation(origin = {0, -140}, extent = {{-10, -10}, {10, 10}})));
  // Series impedance of the infinite bus
  Electrical.Lines.Line lineInfBus(RPu = 0, XPu = 0.005, BPu = 0, GPu = 0) annotation(
    Placement(transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  // Common frequency reference (PLL) shared by all converters
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1.0) annotation(
    Placement(transformation(origin = {-6, 166}, extent = {{-10, -10}, {10, 10}})));
  // Three-phase fault at Bus A
  Electrical.Events.NodeFault fault(tBegin = 5, tEnd = 5.1, RPu = 0, XPu = 0) annotation(
    Placement(transformation(origin = {-180, 126}, extent = {{-10, -10}, {10, 10}})));
  // Shunts
  Electrical.Shunts.ShuntB ShuntE(BPu = 1.6, u0Pu = Complex(1.003047, 0.368799), s0Pu = Complex(0.0, 1.827385), i0Pu = Complex(0.590079, -1.604875)) annotation(
    Placement(transformation(origin = {-194, -114}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Shunts.ShuntB ShuntC(BPu = -4.0, u0Pu = Complex(1.000550, 0.0), s0Pu = Complex(0.0, -4.004401), i0Pu = Complex(0.0, 4.002200)) annotation(
    Placement(transformation(origin = {48, -80}, extent = {{-10, -10}, {10, 10}})));
  // Transformers A2-A and B2-B
  Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafoA2A(RPu = 0.0002083, XPu = 0.00625, GPu = 0, BPu = 0, rTfoPu = 1.02) annotation(
    Placement(transformation(origin = {-220, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafoB2B(BPu = 0, GPu = 0, RPu = 0.0002083, XPu = 0.00625, rTfoPu = 1.05) annotation(
    Placement(transformation(origin = {220, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  gFLHVDC1.PRefPu = 0.95375;
  gFLHVDC1.URefPu = 1.024319;
  gFLHVDC2.PRefPu = 0.82006;
  gFLHVDC2.URefPu = 1.072794;
  gFLWP1.PRefPu = 0.82983;
  gFLWP1.URefPu = 1.069218;
  gFLWP2.PRefPu = 0.82988;
  gFLWP2.URefPu = 1.010584;
  lineBC1.omegaPu = 1;
  lineBC2.omegaPu = 1;
  lineA2E.omegaPu = 1;
  lineB2F.omegaPu = 1;

  lineAB1.switchOffSignal1 = false;
  lineAB1.switchOffSignal2 = false;
  lineAB2.switchOffSignal1 = false;
  lineAB2.switchOffSignal2 = false;
  lineAC1.switchOffSignal1 = false;
  lineAC1.switchOffSignal2 = false;
  lineAC2.switchOffSignal1 = false;
  lineAC2.switchOffSignal2 = false;
  lineBC1.switchOffSignal1 = false;
  lineBC1.switchOffSignal2 = false;
  lineBC2.switchOffSignal1 = false;
  lineBC2.switchOffSignal2 = false;
  lineA2E.switchOffSignal1 = false;
  lineA2E.switchOffSignal2 = false;
  lineB2F.switchOffSignal1 = false;
  lineB2F.switchOffSignal2 = false;
  lineInfBus.switchOffSignal1 = false;
  lineInfBus.switchOffSignal2 = false;
  gFLHVDC1.switchOffSignal1 = false;
  gFLHVDC1.switchOffSignal2 = false;
  gFLHVDC1.switchOffSignal3 = false;
  gFLHVDC2.switchOffSignal1 = false;
  gFLHVDC2.switchOffSignal2 = false;
  gFLHVDC2.switchOffSignal3 = false;
  gFLWP1.switchOffSignal1 = false;
  gFLWP1.switchOffSignal2 = false;
  gFLWP1.switchOffSignal3 = false;
  gFLWP2.switchOffSignal1 = false;
  gFLWP2.switchOffSignal2 = false;
  gFLWP2.switchOffSignal3 = false;
  ShuntC.switchOffSignal1 = false;
  ShuntC.switchOffSignal2 = false;
  ShuntE.switchOffSignal1 = false;
  ShuntE.switchOffSignal2 = false;
  trafoA2A.switchOffSignal1 = false;
  trafoA2A.switchOffSignal2 = false;
  trafoB2B.switchOffSignal1 = false;
  trafoB2B.switchOffSignal2 = false;
  fault.switchOffSignal1 = false;
  fault.switchOffSignal2 = false;

  connect(gFLHVDC1.terminal, busA.terminal) annotation(
    Line(points = {{-206, 105}, {-206, 109.5}, {-180, 109.5}, {-180, 60}}, color = {0, 0, 255}));
  connect(gFLHVDC2.terminal, busB.terminal) annotation(
    Line(points = {{182, 105}, {182, 60}, {180, 60}}, color = {0, 0, 255}));
  connect(gFLWP1.terminal, busE.terminal) annotation(
    Line(points = {{-220, -151}, {-220, -100}}, color = {0, 0, 255}));
  connect(gFLWP2.terminal, busF.terminal) annotation(
    Line(points = {{214, -143}, {214, -120.5}, {220, -120.5}, {220, -100}}, color = {0, 0, 255}));
  connect(busA.terminal, lineAB1.terminal1) annotation(
    Line(points = {{-180, 60}, {-140, 60}, {-140, 82}, {-10, 82}}, color = {0, 0, 255}));
  connect(lineAB1.terminal2, busB.terminal) annotation(
    Line(points = {{10, 82}, {140, 82}, {140, 60}, {180, 60}}, color = {0, 0, 255}));
  connect(busA.terminal, lineAB2.terminal1) annotation(
    Line(points = {{-180, 60}, {-110, 60}, {-110, 30}, {-8, 30}}, color = {0, 0, 255}));
  connect(lineAB2.terminal2, busB.terminal) annotation(
    Line(points = {{12, 30}, {110, 30}, {110, 60}, {180, 60}}, color = {0, 0, 255}));
  connect(busA.terminal, lineAC2.terminal1) annotation(
    Line(points = {{-180, 60}, {-160, 60}, {-160, -60}, {-150, -60}}, color = {0, 0, 255}));
  connect(lineAC2.terminal2, busC.terminal) annotation(
    Line(points = {{-130, -60}, {0, -60}}, color = {0, 0, 255}));
  connect(busA.terminal, lineAC1.terminal1) annotation(
    Line(points = {{-180, 60}, {-110, 60}, {-110, -30}}, color = {0, 0, 255}));
  connect(lineAC1.terminal2, busC.terminal) annotation(
    Line(points = {{-90, -30}, {0, -30}, {0, -60}}, color = {0, 0, 255}));
  connect(busB.terminal, lineBC2.terminal1) annotation(
    Line(points = {{180, 60}, {160, 60}, {160, -60}, {150, -60}}, color = {0, 0, 255}));
  connect(lineBC2.terminal2, busC.terminal) annotation(
    Line(points = {{130, -60}, {0, -60}}, color = {0, 0, 255}));
  connect(busB.terminal, lineBC1.terminal1) annotation(
    Line(points = {{180, 60}, {110, 60}, {110, -30}}, color = {0, 0, 255}));
  connect(lineBC1.terminal2, busC.terminal) annotation(
    Line(points = {{90, -30}, {0, -30}, {0, -60}}, color = {0, 0, 255}));
  connect(busA2.terminal, lineA2E.terminal1) annotation(
    Line(points = {{-220, -20}, {-220, -30}}, color = {0, 0, 255}));
  connect(lineA2E.terminal2, busE.terminal) annotation(
    Line(points = {{-220, -50}, {-220, -100}}, color = {0, 0, 255}));
  connect(busB2.terminal, lineB2F.terminal1) annotation(
    Line(points = {{220, -20}, {220, -30}}, color = {0, 0, 255}));
  connect(lineB2F.terminal2, busF.terminal) annotation(
    Line(points = {{220, -50}, {220, -100}}, color = {0, 0, 255}));
  connect(busC.terminal, lineInfBus.terminal1) annotation(
    Line(points = {{0, -60}, {0, -90}}, color = {0, 0, 255}));
  connect(lineInfBus.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{0, -110}, {0, -140}}, color = {0, 0, 255}));
  connect(busA.terminal, fault.terminal) annotation(
    Line(points = {{-180, 60}, {-180, 126}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, gFLHVDC1.omegaRefPu) annotation(
    Line(points = {{5, 166}, {-260.562, 166}, {-260.562, 90}, {-246, 90}}, color = {198, 70, 0}, thickness = 0.75));
  connect(omegaRefPu.y, gFLHVDC2.omegaRefPu) annotation(
    Line(points = {{5, 166}, {222, 166}, {222, 90}}, color = {198, 70, 0}, thickness = 0.75));
  connect(omegaRefPu.y, gFLWP1.omegaRefPu) annotation(
    Line(points = {{5, 166}, {-286, 166}, {-286, -165.5}, {-260, -165.5}, {-260, -166}}, color = {230, 97, 0}, thickness = 0.75));
  connect(omegaRefPu.y, gFLWP2.omegaRefPu) annotation(
    Line(points = {{5, 166}, {254, 166}, {254, -158}}, color = {198, 70, 0}, thickness = 0.75));
  connect(busE.terminal, ShuntE.terminal) annotation(
    Line(points = {{-220, -100}, {-194, -100}, {-194, -114}}, color = {0, 0, 255}));
  connect(ShuntC.terminal, busC.terminal) annotation(
    Line(points = {{48, -80}, {0, -80}, {0, -60}}, color = {0, 0, 255}));
  connect(busA2.terminal, trafoA2A.terminal1) annotation(
    Line(points = {{-220, -20}, {-220, 8}, {-220, 8}}, color = {0, 0, 255}));
  connect(busA.terminal, trafoA2A.terminal2) annotation(
    Line(points = {{-180, 60}, {-220, 60}, {-220, 28}}, color = {0, 0, 255}));
  connect(trafoB2B.terminal2, busB.terminal) annotation(
    Line(points = {{220, 28}, {180, 28}, {180, 60}}, color = {0, 0, 255}));
  connect(busB2.terminal, trafoB2B.terminal1) annotation(
    Line(points = {{220, -20}, {222, -20}, {222, 8}, {220, 8}}, color = {0, 0, 255}));

  annotation(
    experiment(StartTime = 0, StopTime = 7, Tolerance = 1e-05, Interval = 0.0005),
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -180}, {300, 180}})),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
        Documentation(info = "<html><head></head><body>
<h4>Four grid-following converters in a meshed network with dynamic lines: fault at bus A</h4>

<p>Four grid-following converters without plant control (<code>DynGFLConverterUCtrl</code>, P/U outer loop) are connected
to a meshed network: two HVDC converters (<code>gFLHVDC1</code>, <code>gFLHVDC2</code>) and two wind parks
(<code>gFLWP1</code>, <code>gFLWP2</code>). The case reproduces a reference EMT simulation: after a three-phase fault at
bus A, an oscillation at about 20 Hz appears and is damped over time, as in the EMT results.</p>

<h4>Network</h4>
<pre>
      gFLHVDC1                                        gFLHVDC2
          |                                                |
  fault - busA ============ lineAB1 // lineAB2 =========== busB
          |  \\                                         /    |
   trafoA2A   lineAC1 // lineAC2     lineBC1 // lineBC2   trafoB2B
          |              \\                   /              |
        busA2              +----- busC ------+            busB2
          |                         |   ShuntC              |
       lineA2E                 lineInfBus                lineB2F
          |                         |                       |
        busE  ShuntE           infiniteBus                busF
          |                                                 |
       gFLWP1                                           gFLWP2
</pre>
<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">
  <tbody><tr><th>Branch</th><th>Model</th><th>RPu</th><th>XPu</th><th>BPu (each end)</th><th>Between</th></tr>
  <tr><td><code>lineAB1</code>, <code>lineAB2</code></td><td>static <code>Line</code></td><td>0.00031875</td><td>0.0064</td><td>0.0768</td><td>busA and busB</td></tr>
  <tr><td><code>lineAC1</code>, <code>lineAC2</code></td><td>static <code>Line</code></td><td>0.00065</td><td>0.013</td><td>0.1568</td><td>busA and busC</td></tr>
  <tr><td><code>lineBC1</code>, <code>lineBC2</code></td><td>dynamic <code>DynLineRLC</code></td><td>0.0007</td><td>0.014</td><td>0.168</td><td>busB and busC</td></tr>
  <tr><td><code>lineA2E</code></td><td>dynamic <code>DynLineRLC</code></td><td>0.00082963</td><td>0.0016395</td><td>4.55625</td><td>busA2 and busE (cable)</td></tr>
  <tr><td><code>lineB2F</code></td><td>dynamic <code>DynLineRLC</code></td><td>0.00082963</td><td>0.0016395</td><td>4.55625</td><td>busB2 and busF (cable)</td></tr>
  <tr><td><code>trafoA2A</code></td><td><code>TransformerFixedRatio</code>, <code>rTfoPu = 1.02</code></td><td>0.0002083</td><td>0.00625</td><td>0</td><td>busA2 and busA</td></tr>
  <tr><td><code>trafoB2B</code></td><td><code>TransformerFixedRatio</code>, <code>rTfoPu = 1.05</code></td><td>0.0002083</td><td>0.00625</td><td>0</td><td>busB2 and busB</td></tr>
  <tr><td><code>lineInfBus</code></td><td>static <code>Line</code></td><td>0</td><td>0.005</td><td>0</td><td>busC and infinite bus</td></tr>
</tbody></table>
<p>Impedances in pu on the system base (SnRef = 100 MVA). Shunts: <code>ShuntC</code> at bus C, <code>BPu = -4</code>
(capacitive, produces 4 pu of reactive power); <code>ShuntE</code> at bus E, <code>BPu = 1.6</code> (inductive, absorbs
1.83 pu). The infinite bus is at <code>U = 1.00055 pu</code>, <code>UPhase = 0</code>.</p>

<h4>Converters</h4>
<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">
  <tbody><tr><th>Converter</th><th>Bus</th><th>SNom (MVA)</th><th>P (pu, base SNom)</th><th>Q (pu, base SNom)</th><th>U0Pu</th><th>IMaxPu</th></tr>
  <tr><td><code>gFLHVDC1</code></td><td>A</td><td>1200</td><td>0.954</td><td>-0.045</td><td>1.0165</td><td>1.1</td></tr>
  <tr><td><code>gFLHVDC2</code></td><td>B</td><td>1700</td><td>0.820</td><td>0.296</td><td>1.0184</td><td>1.1</td></tr>
  <tr><td><code>gFLWP1</code></td><td>E</td><td>2400</td><td>0.830</td><td>-0.066</td><td>1.0687</td><td>1</td></tr>
  <tr><td><code>gFLWP2</code></td><td>F</td><td>2400</td><td>0.830</td><td>-0.307</td><td>1.0374</td><td>1.1</td></tr>
</tbody></table>
<p>P and Q in generator convention (positive = injected). The load-flow inputs <code>P0Pu</code>, <code>Q0Pu</code> are in
receptor convention, base SnRef. All converters: <code>tVSC = 1 ms</code>, voltage feedforward on the d-axis only
(<code>Kfd = 1</code>, <code>Kfq = 0</code>), reactive power priority (<code>PQFlag = false</code>), no reactive current
boost (<code>Kqv = 0</code>), active current ramp limited to <code>DidMax = 0.5 pu/s</code> (no limit downwards), and
negligible transformer impedances (1e-5 pu): the LV bus is practically the PCC.</p>

<h4>Controller tuning</h4>
<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">
  <tbody><tr><th>Loop</th><th>HVDC1</th><th>HVDC2</th><th>WP1</th><th>WP2</th></tr>
  <tr><td>Current loop (<code>Kpc</code>, <code>Kic</code>)</td><td>0.573, 6</td><td>0.573, 6</td><td>0.4584, 6</td><td>0.4584, 6</td></tr>
  <tr><td>Active power loop (<code>KpdOuter</code>, <code>KidOuter</code>)</td><td>0.0333, 10</td><td>0.1667, 50</td><td>0.0333, 10</td><td>0.0333, 10</td></tr>
  <tr><td>Voltage loop (<code>KpqOuter</code>, <code>KiqOuter</code>)</td><td>0.1667, 50</td><td>0.1667, 50</td><td>0.033, 10</td><td>0.1667, 50</td></tr>
  <tr><td>PLL (<code>KpPLL</code>, <code>KiPLL</code>)</td><td colspan=\"4\">0.31831, 7.95775</td></tr>
  <tr><td>Measurement filter (<code>tFilter</code>)</td><td>3.3 ms</td><td>3.3 ms</td><td>33 ms</td><td>3.3 ms</td></tr>
</tbody></table>
<p>With the rules of <code>DynGFLPlantQCtrlBandWidth</code>, these gains correspond to a current loop bandwidth of
1200 rad/s, a PLL bandwidth of 50 rad/s with a damping ratio of 1, and outer loop bandwidths of 10 or 50 rad/s
(<code>Kp = Ki/OmegaLPF</code> with <code>OmegaLPF = 300 rad/s</code>).</p>

<h4>References</h4>
<p>The active power and voltage references are held constant at their load-flow values (equations on
<code>PRefPu</code> and <code>URefPu</code>). The frequency reference <code>omegaRefPu</code> is 1 pu for all converters.</p>

<h4>Scenario</h4>
<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">
  <tbody><tr><th>Event</th><th>Block</th><th>Time</th></tr>
  <tr><td>Bolted three-phase fault at bus A (<code>RPu = XPu = 0</code>)</td><td><code>fault</code></td><td>5 s to 5.1 s</td></tr>
</tbody></table>
<p><code>gFLHVDC1</code>, connected to the faulted bus, is the most affected converter and reaches its current limit
first. <code>gFLWP2</code>, the farthest from the fault, is the least affected.</p>
</body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --allowNonStandardModelica");
end FourVSCDynamicLinesConv;
