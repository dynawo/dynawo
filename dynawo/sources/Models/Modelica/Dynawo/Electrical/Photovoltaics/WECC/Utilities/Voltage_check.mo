within Dynawo.Electrical.Photovoltaics.WECC.Utilities;

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


block Voltage_check

  import Modelica.Blocks;

  import Dynawo.Types;

  parameter Types.PerUnit Vdip "Lower Voltage limit for freeze";
  parameter Types.PerUnit Vup "Upper Voltage limit for freeze";

  Blocks.Interfaces.RealInput Vt annotation(
    Placement(visible = true, transformation(origin = {-112, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.BooleanOutput freeze annotation(
    Placement(visible = true, transformation(origin = {110, 2.88658e-15}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {110, 2.88658e-15}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));

equation
    if Vt < Vdip then
      freeze = true;
    elseif Vt > Vup then
      freeze = true;
    else
      freeze = false;
    end if;

annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {18, -4}, extent = {{-96, 52}, {60, -36}}, textString = "Voltage Dip")}));

end Voltage_check;
