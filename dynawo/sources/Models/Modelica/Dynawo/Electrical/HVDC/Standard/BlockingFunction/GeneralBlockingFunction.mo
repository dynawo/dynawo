within Dynawo.Electrical.HVDC.Standard.BlockingFunction;

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

model GeneralBlockingFunction "General Blocking function"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.VoltageModulePu UBlockUVPu "Minimum voltage that triggers the blocking function in p.u (base UNom)";
  parameter Types.Time TBlockUV "If UPu < UBlockUVPu during TBlockUV then the blocking is activated";
  parameter Types.Time TBlock "The blocking is activated during at least TBlock";
  parameter Types.Time TDeblockU "When UPu goes back between UMindbPu and UMaxdbPu for TDeblockU then the blocking is deactivated";
  parameter Types.VoltageModulePu UMindbPu "Minimum voltage that deactivate the blocking function in p.u (base UNom)";
  parameter Types.VoltageModulePu UMaxdbPu "Maximum voltage that deactivate the blocking function in p.u (base UNom)";

  Modelica.Blocks.Interfaces.RealInput U1Pu(start = U10Pu) "Voltage module in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput U2Pu(start = U20Pu) "Voltage module in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.BooleanOutput blocked(start = false) "Boolean assessing the state of the HVDC link: true if blocked, false if not blocked" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.HVDC.Standard.BlockingFunction.BlockingFunction blockingFunction1(TBlock = TBlock, TBlockUV = TBlockUV, TDeblockU = TDeblockU, UBlockUVPu = UBlockUVPu, UMaxdbPu = UMaxdbPu, UMindbPu = UMindbPu, U0Pu = U10Pu)  annotation(
    Placement(visible = true, transformation(origin = {-40, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.HVDC.Standard.BlockingFunction.BlockingFunction blockingFunction2(TBlock = TBlock, TBlockUV = TBlockUV, TDeblockU = TDeblockU, UBlockUVPu = UBlockUVPu, UMaxdbPu = UMaxdbPu, UMindbPu = UMindbPu, U0Pu = U20Pu)  annotation(
    Placement(visible = true, transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu U10Pu;
  parameter Types.VoltageModulePu U20Pu;

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
  annotation(preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));

end GeneralBlockingFunction;
