within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.BlockingFunction;

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

model GeneralBlockingFunction "Undervoltage blocking function for the two sides of an HVDC Link"
  import Modelica;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_BlockingFunction;

  Modelica.Blocks.Interfaces.RealInput U1Pu(start = U10Pu) "Voltage module at terminal 1 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput U2Pu(start = U20Pu) "Voltage module at terminal 2 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  Modelica.Blocks.Interfaces.BooleanOutput blocked(start = false) "Boolean assessing the state of the HVDC link: true if blocked, false if not blocked" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  HVDC.HvdcVSC.BaseControls.BlockingFunction.BlockingFunction blockingFunction1(TBlock = TBlock, TBlockUV = TBlockUV, TDeblockU = TDeblockU, UBlockUVPu = UBlockUVPu, UMaxdbPu = UMaxdbPu, UMindbPu = UMindbPu, U0Pu = U10Pu) "Undervoltage blocking function for one side of an HVDC Link" annotation(
    Placement(visible = true, transformation(origin = {-40, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HVDC.HvdcVSC.BaseControls.BlockingFunction.BlockingFunction blockingFunction2(TBlock = TBlock, TBlockUV = TBlockUV, TDeblockU = TDeblockU, UBlockUVPu = UBlockUVPu, UMaxdbPu = UMaxdbPu, UMindbPu = UMindbPu, U0Pu = U20Pu) "Undervoltage blocking function for one side of an HVDC Link" annotation(
    Placement(visible = true, transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 2 in pu (base UNom)";
  parameter Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base UNom)";

equation
  connect(U1Pu, blockingFunction1.UPu) annotation(
    Line(points = {{-110, 30}, {-52, 30}}, color = {0, 0, 127}));
  connect(U2Pu, blockingFunction2.UPu) annotation(
    Line(points = {{-110, -30}, {-52, -30}}, color = {0, 0, 127}));
  connect(blockingFunction1.blocked, or1.u1) annotation(
    Line(points = {{-29, 30}, {0, 30}, {0, 0}, {8, 0}, {8, 0}}, color = {255, 0, 255}));
  connect(blockingFunction2.blocked, or1.u2) annotation(
    Line(points = {{-29, -30}, {0, -30}, {0, -8}, {8, -8}, {8, -8}}, color = {255, 0, 255}));
  connect(or1.y, blocked) annotation(
    Line(points = {{31, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {255, 0, 255}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end GeneralBlockingFunction;
