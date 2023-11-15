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

model UdqRef "Calculation of setpoints udSourceRefPu and uqSourceRefPu with source impedance RSourcePu+jXSourcePu based on current setpoints idRefPu and iqRefPu and measured injector voltage udInjPu and uqInjPu"

/*                uSourcePu                                uInjPu                      uPu
     --------         |                                       |                         |
    | Source |--------+---->>--------RSourcePu+jXSourcePu-----+------RPu+jXPu-----<<----+---- terminal
     --------           iSourcePu                                                 iPu
*/

  parameter Types.PerUnit RSourcePu "Source resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XSourcePu "Source reactance in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput idRefPu(start = Id0Pu) "d-axis reference current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqRefPu(start = Iq0Pu) "q-axis reference current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udInjPu(start = UdInj0Pu) "d-axis voltage at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqInjPu(start = UqInj0Pu) "q-axis voltage at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udSourceRefPu(start = UdInj0Pu + Id0Pu * RSourcePu - Iq0Pu * XSourcePu) "d-axis reference voltage at source in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqSourceRefPu(start = UqInj0Pu + Iq0Pu * RSourcePu + Id0Pu * XSourcePu) "q-axis reference voltage at source in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Id0Pu "Start value of d-axis current in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of q-axis current in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage injector in pu (base UNom)";
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage injector in pu (base UNom)";

equation
  udSourceRefPu = udInjPu + idRefPu * RSourcePu - iqRefPu * XSourcePu;
  uqSourceRefPu = uqInjPu + iqRefPu * RSourcePu + idRefPu * XSourcePu;

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Text(origin = {-121.5, 96}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "idRef"), Text(origin = {-121.5, 46}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "iqRef"), Text(origin = {-135.067, -7.72727}, extent = {{1.06667, 1.72727}, {33.0667, -17.2727}}, textString = "udInjPu"), Text(origin = {126.654, 55.8824}, extent = {{-26.6538, 11.1176}, {39.3462, -15.8824}}, textString = "udSourceRef"), Text(origin = {-10.5, 12}, extent = {{-69.5, 68}, {90.5, -92}}, textString = "UdqRef"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-135.07, -56.73}, extent = {{1.07, 1.73}, {33.07, -17.27}}, textString = "uqInjPu"), Text(origin = {126.654, 55.8824}, extent = {{-26.6538, 11.1176}, {39.3462, -15.8824}}, textString = "udSourceRef"), Text(origin = {126.65, -24.12}, extent = {{-26.65, 11.12}, {39.35, -15.88}}, textString = "uqSourceRef")}));
end UdqRef;
