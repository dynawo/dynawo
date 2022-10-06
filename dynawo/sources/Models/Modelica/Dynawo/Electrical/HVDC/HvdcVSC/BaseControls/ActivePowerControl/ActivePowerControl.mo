within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.ActivePowerControl;

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

model ActivePowerControl "Active power control for the HVDC VSC model"
  import Modelica;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;

  extends HVDC.HvdcVSC.BaseControls.ActivePowerControl.BaseActivePowerControl;
  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_DeltaP;

  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) "DC voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, 74}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 33}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput activateDeltaP(start = false) "Boolean that indicates whether DeltaP is activated or not" annotation(
    Placement(visible = true, transformation(origin = {-130, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HVDC.HvdcVSC.BaseControls.ActivePowerControl.DeltaP deltaP(Ip0Pu = Ip0Pu, IpMaxCstPu = IpMaxCstPu, KiDeltaP = KiDeltaP, KpDeltaP = KpDeltaP, Udc0Pu = Udc0Pu, UdcMaxPu = UdcMaxPu, UdcMinPu = UdcMinPu) "Function that calculates a DeltaP for the active power control side of the HVDC link to help the other side maintain the DC voltage" annotation(
    Placement(visible = true, transformation(origin = {-90, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-53, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu Udc0Pu "Start value of dc voltage in pu (base SNom, UNom)";

equation
  connect(UdcPu, deltaP.UdcPu) annotation(
    Line(points = {{-130, 74}, {-101, 74}}, color = {0, 0, 127}));
  connect(activateDeltaP, switch.u2) annotation(
    Line(points = {{-130, 40}, {-22, 40}}, color = {255, 0, 255}));
  connect(deltaP.DeltaPRawPu, switch.u1) annotation(
    Line(points = {{-79, 74}, {-71, 74}, {-71, 48}, {-22, 48}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u3) annotation(
    Line(points = {{-42, 20}, {-30, 20}, {-30, 32}, {-22, 32}, {-22, 32}}, color = {0, 0, 127}));
  connect(switch.y, add1.u1) annotation(
    Line(points = {{1, 40}, {15, 40}, {15, -2}, {19, -2}, {19, -2}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-110, -95}, {130, 105}})),
    Icon(coordinateSystem(grid = {1, 1})));
end ActivePowerControl;
