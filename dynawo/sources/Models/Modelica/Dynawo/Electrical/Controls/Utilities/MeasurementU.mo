within Dynawo.Electrical.Controls.Utilities;

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

model MeasurementU "This block measures the voltage in pu (base UNom)"

/*
  Equivalent circuit and conventions:

               iPu, uPu
   (terminal1) -->---------MEASUREMENTS------------ (terminal2)

*/
  import Modelica;
  import Dynawo.Connectors;

  Connectors.ACPower terminal1 annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal2 annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UPu "Voltage module at terminal 1 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-100, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-100, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  terminal1.i = -terminal2.i;
  terminal1.V = terminal2.V;
  UPu = Modelica.ComplexMath.'abs'(terminal1.V);

  annotation(
    preferredView = "text");
end MeasurementU;
