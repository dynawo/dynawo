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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model NegCurrentLogic "Negative Current Logic used in the SCRX controller of the RVS."
  import Modelica;

  parameter Types.PerUnit rc_rfd "Ratio of field discharge resistance to field winding resistance";

  Modelica.Blocks.Interfaces.RealInput EPu "Generator field voltage before negative current logic in pu (non-reciprocal)" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IRotorPu "Generator field current in pu (non-reciprocal)" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput EfdPu "Generator field voltage before negative current logic in pu (non-reciprocal)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  if (-IRotorPu * rc_rfd) > 0 and (-IRotorPu * rc_rfd) > EPu then
  EfdPu = -IRotorPu * rc_rfd;
  else
    EfdPu = EPu;
  end if;

annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(extent = {{-80, 80}, {80, -80}}, textString = "Neg Current Logic")}));
end NegCurrentLogic;
