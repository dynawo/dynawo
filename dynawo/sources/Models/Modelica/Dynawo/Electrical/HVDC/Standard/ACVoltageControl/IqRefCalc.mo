within Dynawo.Electrical.HVDC.Standard.ACVoltageControl;

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

model IqRefCalc

  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit IqMinPu;
  parameter Types.PerUnit IqMaxPu;
  parameter Types.Time TQ;

  Modelica.Blocks.Interfaces.RealInput QRefLimPu(start = Q0Pu) "Reference reactive power in p.u (base SNom) after applying the diagrams" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage module in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqMod(start = 0) "Additional reactive current in case of fault or overvoltage in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) "Boolean assessing the state of the HVDC link: true if blocked, false if not blocked" annotation(
    Placement(visible = true, transformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = Iq0Pu) "Reactive current reference in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));


  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-6, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = IqMaxPu, uMin = IqMinPu) annotation(
    Placement(visible = true, transformation(origin = {24, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-88,50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1)  annotation(
    Placement(visible = true, transformation(origin = {85, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-76, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = TQ)  annotation(
    Placement(visible = true, transformation(origin = {-46, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Iq0Pu;
  parameter Types.ReactivePowerPu Q0Pu;
  parameter Types.VoltageModulePu U0Pu;

equation

  connect(limiter1.y, switch1.u3) annotation(
    Line(points = {{35, -8}, {42, -8}}, color = {0, 0, 127}));
  connect(add.y, limiter1.u) annotation(
    Line(points = {{5, -8}, {12, -8}}, color = {0, 0, 127}));
  connect(zero.y, switch1.u1) annotation(
    Line(points = {{-77, 50}, {38, 50}, {38, 8}, {42, 8}}, color = {0, 0, 127}));
  connect(iqMod, add.u1) annotation(
    Line(points = {{-120, -2}, {-18, -2}}, color = {0, 0, 127}));
  connect(blocked, switch1.u2) annotation(
    Line(points = {{-120, 30}, {36, 30}, {36, 0}, {42, 0}}, color = {255, 0, 255}));
  connect(switch1.y, gain.u) annotation(
    Line(points = {{65, 0}, {73, 0}}, color = {0, 0, 127}));
  connect(gain.y, iqRefPu) annotation(
    Line(points = {{96, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(QRefLimPu, division.u1) annotation(
    Line(points = {{-120, -40}, {-89, -40}, {-89, -40}, {-88, -40}}, color = {0, 0, 127}));
  connect(UPu, division.u2) annotation(
    Line(points = {{-120, -80}, {-95, -80}, {-95, -52}, {-88, -52}, {-88, -52}}, color = {0, 0, 127}));
  connect(division.y, firstOrder.u) annotation(
    Line(points = {{-65, -46}, {-60, -46}, {-60, -46}, {-58, -46}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u2) annotation(
    Line(points = {{-35, -46}, {-30, -46}, {-30, -14}, {-18, -14}, {-18, -14}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));

end IqRefCalc;
