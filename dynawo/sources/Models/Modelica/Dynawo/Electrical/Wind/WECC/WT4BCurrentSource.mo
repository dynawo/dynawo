within Dynawo.Electrical.Wind.WECC;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WT4BCurrentSource "WECC Wind Turbine model without plant controller and with a current source as interface with the grid"
  import Modelica;
  import Dynawo;

  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BaseWT4B;

  Modelica.Blocks.Interfaces.RealInput PInjRefPu(start = PInj0Pu) "Active power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-96.5, 1.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = 0), iconTransformation(origin = {-90, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QInjRefPu(start = QInj0Pu) "Reactive power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-95.5, -10.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = 0), iconTransformation(origin = {-90, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  connect(wecc_reec.PInjRefPu, PInjRefPu) annotation(
    Line(points = {{-33, 2}, {-96, 2}}, color = {0, 0, 127}));
  connect(wecc_reec.QInjRefPu, QInjRefPu) annotation(
    Line(points = {{-33, -10}, {-95, -10}}, color = {0, 0, 127}));
  annotation(
    Documentation(info = "<html><head></head><body><p> This block contains the generic WECC WT model according to (in case page cannot be found, copy link in browser): <br><a href=\"https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a> </p>
<p> The overall model is structured as follows:
</p><ul>
<li> Main model: WECC_Wind with terminal connection and measurement inputs for P/Q/U/I.</li>
<li> Electrical inverter control.</li>
<li> Constant speed of drive train represented by constant block (no drive train).</li>
<li> Generator control. </li>
<li> Injector (id,iq). </li>
</ul><div>Notice that in this model and contrary to the one in the norm, there is no plant controller included.</div> <p></p></body></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC WT 4B")}, coordinateSystem(initialScale = 0.1)),
  Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -60}, {170, 50}})));
end WT4BCurrentSource;
