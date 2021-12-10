within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model UdqRef "Calculation of setpoints udRefPu and uqRefPu with source impedance RPu+jXPu based on current setpoints idRefPu and iqRefPu and measured terminal voltage udPu and uqPu"

  import Modelica.Blocks.Interfaces;
  import Dynawo.Types;

  parameter Types.PerUnit RPu "Source resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit XPu "Source reactance in p.u (base UNom, SNom)";

  Interfaces.RealInput idRefPu(start = Id0Pu) "d-axis reference current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.RealInput iqRefPu(start = Iq0Pu) "q-axis reference current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.RealInput udPu(start = Ud0Pu) "d-axis voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.RealInput uqPu(start = Uq0Pu) "q-axis voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.RealOutput udRefPu(start = Ud0Pu + Id0Pu * RPu - Iq0Pu * XPu) "d-axis reference voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.RealOutput uqRefPu(start = Uq0Pu + Iq0Pu * RPu + Id0Pu * XPu) "q-axis reference voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Types.PerUnit Id0Pu "Start value of d-axis current at injector in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of q-axis current at injector in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Ud0Pu "Start value of d-axis current at injector in p.u (base UNom)";
  parameter Types.PerUnit Uq0Pu "Start value of q-axis current at injector in p.u (base UNom)";

equation
  udRefPu = udPu + idRefPu * RPu - iqRefPu * XPu;
  uqRefPu = uqPu + iqRefPu * RPu + idRefPu * XPu;

  annotation(preferredView = "text",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Text(origin = {-121.5, 96}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "idRef"), Text(origin = {-121.5, 46}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "iqRef"), Text(origin = {-130.5, -11}, extent = {{0.5, 1}, {15.5, -10}}, textString = "ud"), Text(origin = {-130.5, -61}, extent = {{0.5, 1}, {15.5, -10}}, textString = "uq"), Text(origin = {119.5, 52}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "udRef"), Text(origin = {119.5, -29}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "uqRef"), Text(origin = {-10.5, 12}, extent = {{-69.5, 68}, {90.5, -92}}, textString = "UdqRef"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end UdqRef;
