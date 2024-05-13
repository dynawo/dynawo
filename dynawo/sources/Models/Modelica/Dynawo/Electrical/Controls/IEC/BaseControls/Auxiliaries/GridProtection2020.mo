within Dynawo.Electrical.Controls.IEC.BaseControls.Auxiliaries;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GridProtection2020 "Grid protection system for wind turbines (IEC N°61400-27-1:2020)"
  extends Dynawo.Electrical.Controls.IEC.BaseClasses.BaseGridProtection;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaFiltPu(start = SystemBase.omegaRef0Pu) "Filtered grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTPFiltPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameter
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(omegaFiltPu, lessEqual2.u2) annotation(
    Line(points = {{-180, -80}, {-80, -80}, {-80, -28}, {-62, -28}}, color = {0, 0, 127}));
  connect(UWTPFiltPu, lessEqual.u2) annotation(
    Line(points = {{-180, 80}, {-80, 80}, {-80, 132}, {-62, 132}}, color = {0, 0, 127}));
  connect(UWTPFiltPu, combiTable1D.u) annotation(
    Line(points = {{-180, 80}, {-20, 80}, {-20, 100}, {-2, 100}}, color = {0, 0, 127}));
  connect(UWTPFiltPu, combiTable1D1.u) annotation(
    Line(points = {{-180, 80}, {-20, 80}, {-20, 60}, {-2, 60}}, color = {0, 0, 127}));
  connect(omegaFiltPu, combiTable1D2.u) annotation(
    Line(points = {{-180, -80}, {-20, -80}, {-20, -60}, {-2, -60}}, color = {0, 0, 127}));
  connect(omegaFiltPu, combiTable1D3.u) annotation(
    Line(points = {{-180, -80}, {-20, -80}, {-20, -100}, {-2, -100}}, color = {0, 0, 127}));
  connect(UWTPFiltPu, lessEqual1.u1) annotation(
    Line(points = {{-180, 80}, {-80, 80}, {-80, 20}, {-62, 20}}, color = {0, 0, 127}));
  connect(omegaFiltPu, lessEqual3.u1) annotation(
    Line(points = {{-180, -80}, {-80, -80}, {-80, -140}, {-62, -140}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {10, 5}, extent = {{-52, 43}, {32, 7}}, textString = "Grid"), Text(origin = {-10, -27}, extent = {{-76, 65}, {98, -71}}, textString = "Protection"), Text(origin = {-14, -73}, extent = {{-76, 20}, {100, -23}}, textString = "2020")}),
    Diagram(coordinateSystem(extent = {{-160, -160}, {160, 160}})));
end GridProtection2020;
