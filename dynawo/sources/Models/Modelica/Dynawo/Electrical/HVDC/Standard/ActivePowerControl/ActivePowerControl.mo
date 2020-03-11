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

  parameter Types.VoltageModulePu UdcMinPu;
  parameter Types.VoltageModulePu UdcMaxPu;
  parameter Types.PerUnit Kpdeltap;
  parameter Types.PerUnit Kideltap;
  parameter Types.PerUnit IpMaxcstPu;
  parameter Types.PerUnit DUDC;
  parameter Types.PerUnit Kppcontrol;
  parameter Types.PerUnit Kipcontrol;
  parameter Types.PerUnit IpMaxPu;
  parameter Types.PerUnit IpMinPu;
  parameter Types.ActivePowerPu PMaxOPPu;
  parameter Types.ActivePowerPu PMinOPPu;
  parameter Types.Time TFilterPRef;

  Modelica.Blocks.Interfaces.RealInput ipRefUdcPu(start = Ip0Pu) "Active current reference in p.u for the DC voltage control side of the HVDC link (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) "DC voltage in p.u (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) "Boolean assessing the state of the HVDC link: true if blocked, false if not blocked" annotation(
    Placement(visible = true, transformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = P0Pu) "Reference active power in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput rpfault(start = 1) "Signal that is equal to 1 in normal conditions, 0 when the HVDC link is blocked, and that goeas back to 1 with a ramp when it is unblocked" annotation(
    Placement(visible = true, transformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput ipRefPPu(start = Ip0Pu) "Active current reference in p.u for the active power control side of the HVDC link (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.HVDC.Standard.ActivePowerControl.DeltaPCalc deltaP(DUDC = DUDC, Ip0Pu = Ip0Pu, IpMaxcstPu = IpMaxcstPu, Kideltap = Kideltap, Kpdeltap = Kpdeltap, Udc0Pu = Udc0Pu, UdcMaxPu = UdcMaxPu, UdcMinPu = UdcMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.HVDC.Standard.ActivePowerControl.IpRefPPuCalc pControl(Ip0Pu = Ip0Pu, IpMaxPu = IpMaxPu, IpMinPu = IpMinPu, Kipcontrol = Kipcontrol, Kppcontrol = Kppcontrol, P0Pu = P0Pu, PMaxOPPu = PMaxOPPu, PMinOPPu = PMinOPPu, TFilterPRef = TFilterPRef)  annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu Udc0Pu;
  parameter Types.PerUnit Ip0Pu;
  parameter Types.ActivePowerPu P0Pu;

equation

  connect(deltaP.DeltaPPu, pControl.DeltaPPu) annotation(
    Line(points = {{-49, 0}, {29, 0}}, color = {0, 0, 127}));
  connect(UdcPu, deltaP.UdcPu) annotation(
    Line(points = {{-110, -10}, {-90, -10}, {-90, -4}, {-71, -4}, {-71, -4}}, color = {0, 0, 127}));
  connect(ipRefUdcPu, deltaP.ipRefUdcPu) annotation(
    Line(points = {{-110, 10}, {-90, 10}, {-90, 4}, {-71, 4}, {-71, 4}}, color = {0, 0, 127}));
  connect(PRefPu, pControl.PRefPu) annotation(
    Line(points = {{-110, 30}, {-40, 30}, {-40, 4}, {29, 4}}, color = {0, 0, 127}));
  connect(blocked, pControl.blocked) annotation(
    Line(points = {{-110, 50}, {-30, 50}, {-30, 8}, {29, 8}}, color = {255, 0, 255}));
  connect(PPu, pControl.PPu) annotation(
    Line(points = {{-110, -30}, {-40, -30}, {-40, -4}, {29, -4}}, color = {0, 0, 127}));
  connect(rpfault, pControl.rpfault) annotation(
    Line(points = {{-110, -50}, {-30, -50}, {-30, -8}, {29, -8}}, color = {0, 0, 127}));
  connect(ipRefPPu, pControl.ipRefPPu) annotation(
    Line(points = {{110, 0}, {51, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));

end ActivePowerControl;
