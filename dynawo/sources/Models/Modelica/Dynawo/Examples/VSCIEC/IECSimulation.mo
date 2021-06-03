within Dynawo.Examples.VSCIEC;

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

  model IECSimulation

    import Dynawo;

    extends Icons.Example;

    Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 0.90081) annotation(
      Placement(visible = true, transformation(origin = {-98, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.022522) annotation(
      Placement(visible = true, transformation(origin = {-39, 25}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    Dynawo.Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0, XPu = 0.04189) annotation(
      Placement(visible = true, transformation(origin = {-39, -23}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
      Placement(visible = true, transformation(origin = {32, 6.66134e-16}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  equation
    line1.switchOffSignal1.value = false;
    line1.switchOffSignal2.value = false;
    line2.switchOffSignal1.value = false;
    line2.switchOffSignal2.value = false;
    transformer.switchOffSignal1.value = false;
    transformer.switchOffSignal2.value = false;
    connect(line1.terminal1, infiniteBus.terminal) annotation(
      Line(points = {{-64, 25}, {-64, 0}, {-98, 0}}, color = {0, 0, 255}));
    connect(line2.terminal1, infiniteBus.terminal) annotation(
      Line(points = {{-64, -23}, {-64, 0}, {-98, 0}}, color = {0, 0, 255}));
    connect(line1.terminal2, transformer.terminal1) annotation(
      Line(points = {{-14, 25}, {0, 25}, {0, 0}, {8, 0}}, color = {0, 0, 255}));
    connect(line2.terminal2, transformer.terminal1) annotation(
      Line(points = {{-14, -23}, {0, -23}, {0, 0}, {8, 0}}, color = {0, 0, 255}));
    annotation(
      experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.004),
      __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
      This test case represents a 2220 MWA synchronous machine connected to an infinite bus through a transformer and two lines in parallel. <div><br></div><div> The simulated event is a 0.02 p.u. step variation on the generator mechanical power Pm occurring at t=1s.
      </div><div><br></div><div>The two following figures show the expected evolution of the generator's voltage and active power during the simulation.
      <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/PGen.png\">
      </figure>
      <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/UStatorPu.png\">
      </figure>
      We observe that the active power is increased by 44.05 MW. The voltage drop between the infinite bus and the machine terminal is consequently increased, resulting in a decrease of the machine terminal voltage.
      </div><div><br></div><div>Initial equation are provided on the generator's differential variables to ensure a steady state initialisation by the Modelica tool. It had to be written here and not directly in Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous because the Dynawo simulator applies a different initialisation strategy that does not involve the initial equation section.
      </div><div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>
      "),
    Diagram(graphics = {Rectangle(extent = {{88, 12}, {88, 12}})}, coordinateSystem(initialScale = 0.1)));


end IECSimulation;
