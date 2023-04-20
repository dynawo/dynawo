within Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

block SatChar "Saturation Characteristic"
  import Modelica;
  
  parameter Types.PerUnit e1 "Exciter saturation point 1 in pu";
  parameter Types.PerUnit e2 "Exciter saturation point 2 in pu";
  parameter Types.PerUnit s1 "Saturation at e1 in pu";
  parameter Types.PerUnit s2 "Saturation at e2 in pu";
  
  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
  parameter Types.PerUnit Asq = (e_l - e_h*sq) / (1 - sq);
  parameter Types.PerUnit Bsq = if e_h - Asq > 0 then e_h * s_h / (e_h - Asq) ^ 2 else 0;
  
protected
  parameter Types.PerUnit e_h = max(max(e1, e2), 0);
  parameter Types.PerUnit e_l = max(min(e1, e2), 0);
  parameter Types.PerUnit s_h = max(max(s1, s2), 0);
  parameter Types.PerUnit s_l = max(min(s1, s2), 0);
  parameter Types.PerUnit sq = if ((e_h > 0) and (s_h > 0)) then sqrt(e_l*s_l/(e_h*s_h)) else 0;

equation
  if u  > Asq then 
    y = Bsq * (u - Asq) ^ 2;
  else
    y = 0.0;
  end if;

annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 2},extent = {{-40, 40}, {40, -40}}, textString = "S(E)"), Text(lineColor = {0, 0, 255}, extent = {{-150, 140}, {150, 100}}, textString = "%name")}));
end SatChar;
