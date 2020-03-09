within Dynawo.Electrical.HVDC.Standard.ActivePowerControl;

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

model ActivePowerControl

  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.VoltageModulePu VdcMinPu;
  parameter Types.VoltageModulePu VdcMaxPu;
  parameter Types.PerUnit Kpdeltap;
  parameter Types.PerUnit Kideltap;
  parameter Types.PerUnit IpMaxcstPu;
  parameter Types.PerUnit DUDC;
  parameter Types.PerUnit Kppcontrol;
  parameter Types.PerUnit Kipcontrol;
  parameter Types.PerUnit IpMaxPu;
  parameter Types.PerUnit IpMinPu;
  parameter Types.ActivePowerPu PMaxOp;
  parameter Types.ActivePowerPu PMinOp;
  parameter Types.Time TFilterPRef;

  Dynawo.Electrical.HVDC.Standard.ActivePowerControl.DeltaPCalc deltaP(DUDC = DUDC, Ip0Pu = Ip0Pu, IpMaxcstPu = IpMaxcstPu, Kideltap = Kideltap, Kpdeltap = Kpdeltap, Vdc0Pu = Vdc0Pu, VdcMaxPu = VdcMaxPu, VdcMinPu = VdcMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.HVDC.Standard.ActivePowerControl.IpRefPPuCalc pControl(Ip0Pu = Ip0Pu, IpMaxPu = IpMaxPu, IpMinPu = IpMinPu, Kipcontrol = Kipcontrol, Kppcontrol = Kppcontrol, P0Pu = P0Pu, PMaxOp = PMaxOp, PMinOp = PMinOp, TFilterPRef = TFilterPRef)  annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ipRefVdcPu(start = Ip0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vdcPu(start = Vdc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) annotation(
    Placement(visible = true, transformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pRefPu(start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pPu(start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput rpfault(start = 1) annotation(
    Placement(visible = true, transformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipRefPPu(start = Ip0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu Vdc0Pu;
  parameter Types.PerUnit Ip0Pu;
  parameter Types.ActivePowerPu P0Pu;

equation
  connect(deltaP.deltaP, pControl.deltaP) annotation(
    Line(points = {{-49, 0}, {29, 0}}, color = {0, 0, 127}));
  connect(vdcPu, deltaP.vdcPu) annotation(
    Line(points = {{-110, -10}, {-90, -10}, {-90, -4}, {-71, -4}, {-71, -4}}, color = {0, 0, 127}));
  connect(ipRefVdcPu, deltaP.ipRefVdcPu) annotation(
    Line(points = {{-110, 10}, {-90, 10}, {-90, 4}, {-71, 4}, {-71, 4}}, color = {0, 0, 127}));
  connect(pRefPu, pControl.pRefPu) annotation(
    Line(points = {{-110, 30}, {-40, 30}, {-40, 4}, {29, 4}}, color = {0, 0, 127}));
  connect(blocked, pControl.blocked) annotation(
    Line(points = {{-110, 50}, {-30, 50}, {-30, 8}, {29, 8}}, color = {255, 0, 255}));
  connect(pPu, pControl.pPu) annotation(
    Line(points = {{-110, -30}, {-40, -30}, {-40, -4}, {29, -4}}, color = {0, 0, 127}));
  connect(rpfault, pControl.rpfault) annotation(
    Line(points = {{-110, -50}, {-30, -50}, {-30, -8}, {29, -8}}, color = {0, 0, 127}));
  connect(ipRefPPu, pControl.ipRefPPu) annotation(
    Line(points = {{110, 0}, {51, 0}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end ActivePowerControl;
