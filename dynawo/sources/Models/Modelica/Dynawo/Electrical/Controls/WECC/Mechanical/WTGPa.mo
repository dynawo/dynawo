within Dynawo.Electrical.Controls.WECC.Mechanical;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model WTGPa "WECC Pitch Controller Type A"
  extends Dynawo.Electrical.Controls.WECC.Mechanical.BaseClasses.BaseWTGP;

  NonElectrical.Blocks.NonLinear.LimitedIntegrator limitedIntegrator(K = kic, YMax = thetaMax, YMin = thetaMin) annotation(
    Placement(transformation(origin = {-22, -24}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.NonLinear.LimitedIntegrator limitedIntegrator1(K = kiw, YMax = thetaMax, YMin = thetaMin) annotation(
    Placement(transformation(origin = {-20, 86}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(sum.y, limitedIntegrator.u) annotation(
    Line(points = {{-50, -42}, {-34, -42}, {-34, -24}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, add.u1) annotation(
    Line(points = {{-11, -24}, {-6, -24}, {-6, -38}}, color = {0, 0, 127}));
  connect(limitedIntegrator1.y, add1.u1) annotation(
    Line(points = {{-9, 86}, {-8, 86}, {-8, 70}}, color = {0, 0, 127}));
  connect(sum1.y, limitedIntegrator1.u) annotation(
    Line(points = {{-36, 66}, {-32, 66}, {-32, 86}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p> This block contains the Pitch controller model Type A for a WindTurbineGenerator Type 3 based on&nbsp;<br><a href=\"3002027129_Model%20User%20Guide%20for%20Generic%20Renewable%20Energy%20Systems.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a> </p><p data-start=\"358\" data-end=\"553\" class=\"\">The Pitch Controller is designed to regulate the blade pitch angle, ensuring optimal performance and protection under varying wind conditions. It serves the following primary functions:</p><p><!--StartFragment-->
<!--EndFragment--></p><ol data-start=\"555\" data-end=\"1421\">
<li data-start=\"555\" data-end=\"758\" class=\"\">
<p data-start=\"558\" data-end=\"758\" class=\"\"><strong data-start=\"558\" data-end=\"597\">Protection against High Wind Speeds</strong>: The controller adjusts the blade pitch to reduce aerodynamic loading during high wind conditions, preventing potential mechanical damage or structural failure.</p>
</li>
<li data-start=\"760\" data-end=\"975\" class=\"\">
<p data-start=\"763\" data-end=\"975\" class=\"\"><strong data-start=\"763\" data-end=\"786\">Energy Optimization</strong>: Under moderate to low wind conditions, the pitch angle is adjusted to maximize the turbine's energy capture by optimizing the angle of attack of the blades relative to the wind direction.</p>
</li>
<li data-start=\"977\" data-end=\"1244\" class=\"\">
<p data-start=\"980\" data-end=\"1244\" class=\"\"><strong data-start=\"980\" data-end=\"1004\">Power Output Control</strong>: The controller also regulates the turbine's power output, especially in higher wind speeds, by adjusting the blade pitch to prevent exceeding the turbine's rated power capacity. This helps ensure the generator operates within safe limits.</p>
</li>
<li data-start=\"1246\" data-end=\"1421\" class=\"\">
<p data-start=\"1249\" data-end=\"1421\" class=\"\"><strong data-start=\"1249\" data-end=\"1271\">Low Wind Operation</strong>: In low wind conditions, the controller adjusts the blade pitch to ensure the turbine starts generating power efficiently, even at lower wind speeds.</p></li></ol>
<p>
 </p><p></p></body></html>"),
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.8.0")),
    Icon(graphics = {Text(origin = {118, 18}, extent = {{-14, 8}, {14, -8}}, textString = "theta"), Text(origin = {-40, 112}, extent = {{-22, 14}, {22, -14}}, textString = "wt"), Text(origin = {-113, 92}, extent = {{-15, 14}, {15, -14}}, textString = "wref"), Text(origin = {-120, -30}, extent = {{-16, 10}, {16, -10}}, textString = "Pord"), Text(origin = {-29, -108}, extent = {{-15, 12}, {15, -12}}, textString = "Pref"), Text(origin = {4, 0}, extent = {{-60, 46}, {60, -46}}, textString = "WTGP A"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end WTGPa;
