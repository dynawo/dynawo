within Dynawo.Examples.DynaFlow.IllustrativeExamples;

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

model CoordinatedVControl_INIT "Initialisation model for the test case with coordinated voltage control"
  import Dynawo;

  extends AdditionalIcons.Init;

  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp_INIT Generator1(P0Pu = -1.5, PMax = 1000000, PMin = -1000000, Q0Pu = -0.5, QMax = 62, QMin = -200, U0Pu = 1.05, UPhase0 = 0) annotation(
    Placement(visible = true, transformation(origin = {-28, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQPropDiagramPQ_INIT Generator2(P0Pu = -1.5, PMax = 1000000, PMin = -1000000, Q0Pu = -0.5, QMax0 = 200, QMin0 = -185, U0Pu = 1.05, UPhase0 = 0) annotation(
    Placement(visible = true, transformation(origin = {-28, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  annotation(
    Documentation(info = "<html><head></head><body>Initialisation is done by initialising each of the two generators.</body></html>"));
end CoordinatedVControl_INIT;
