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

model WTGPb "WECC Pitch Controller Type B"
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsWTGPb;
  extends Dynawo.Electrical.Controls.WECC.Mechanical.BaseClasses.BaseWTGP;

  NonElectrical.Blocks.Continuous.AntiWindupIntegrator antiWindupIntegrator(tI = 1 / kiw, YMax = thetaWMax, YMin = thetaWMin, Y0 = 0, DyMax = 999, DyMin = -999) annotation(
    Placement(transformation(origin = {-24, 88}, extent = {{-10, 10}, {10, -10}})));
  NonElectrical.Blocks.Continuous.AntiWindupIntegrator antiWindupIntegrator1(YMax = thetaCMax, YMin = thetaCMin, tI = 1 / kic, Y0 = 0, DyMax = 999, DyMin = -999) annotation(
    Placement(transformation(origin = {-22, -18}, extent = {{-10, 10}, {10, -10}})));

equation
  connect(sum1.y, antiWindupIntegrator.u) annotation(
    Line(points = {{-36, 66}, {-36, 88}}, color = {0, 0, 127}));
  connect(antiWindupIntegrator.y, add1.u1) annotation(
    Line(points = {{-13, 88}, {-13, 86}, {-8, 86}, {-8, 70}}, color = {0, 0, 127}));
  connect(antiWindupIntegrator1.y, add.u1) annotation(
    Line(points = {{-11, -18}, {-8, -18}, {-8, -38}, {-6, -38}}, color = {0, 0, 127}));
  connect(sum.y, antiWindupIntegrator1.u) annotation(
    Line(points = {{-50, -42}, {-34, -42}, {-34, -18}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderFreezeLimDetection.fMax, antiWindupIntegrator.fMax) annotation(
    Line(points = {{98, 48}, {100, 48}, {100, 96}, {-4, 96}, {-4, 114}, {-17, 114}, {-17, 100}, {-16, 100}}, color = {255, 0, 255}));
  connect(absLimRateLimFirstOrderFreezeLimDetection.fMin, antiWindupIntegrator.fMin) annotation(
    Line(points = {{98, 36}, {100, 36}, {100, 96}, {-4, 96}, {-4, 114}, {-21, 114}, {-21, 100}, {-20, 100}}, color = {255, 0, 255}));
  connect(absLimRateLimFirstOrderFreezeLimDetection.fMax, antiWindupIntegrator1.fMax) annotation(
    Line(points = {{98, 48}, {100, 48}, {100, 0}, {-12, 0}, {-12, -14}}, color = {255, 0, 255}));
  connect(absLimRateLimFirstOrderFreezeLimDetection.fMin, antiWindupIntegrator1.fMin) annotation(
    Line(points = {{98, 36}, {100, 36}, {100, 0}, {-18, 0}, {-18, -6}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">This block contains the Pitch controller model Type B for a WindTurbineGenerator Type 3 based on &nbsp;<br><a href=\"3002027129_Model%20User%20Guide%20for%20Generic%20Renewable%20Energy%20Systems.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a></p><p data-start=\"358\" data-end=\"553\" class=\"\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">The Pitch Controller is designed to regulate blade pitch angle, ensuring optimal performance and protection under varying wind conditions. It serves the following primary functions:</p><p style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"></p><ol data-start=\"555\" data-end=\"1421\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><li data-start=\"555\" data-end=\"758\" class=\"\"><p data-start=\"558\" data-end=\"758\" class=\"\"><strong data-start=\"558\" data-end=\"597\">Protection against High Wind Speeds</strong>: The controller adjusts the blade pitch to reduce aerodynamic loading during high wind conditions, preventing potential mechanical damage or structural failure.</p></li><li data-start=\"760\" data-end=\"975\" class=\"\"><p data-start=\"763\" data-end=\"975\" class=\"\"><strong data-start=\"763\" data-end=\"786\">Energy Optimization</strong>: Under moderate to low wind conditions, the pitch angle is adjusted to maximize the turbine's energy capture by optimizing the angle of attack of the blades relative to the wind direction.</p></li><li data-start=\"977\" data-end=\"1244\" class=\"\"><p data-start=\"980\" data-end=\"1244\" class=\"\"><strong data-start=\"980\" data-end=\"1004\">Power Output Control</strong>: The controller also regulates the turbine's power output, especially in higher wind speeds, by adjusting the blade pitch to prevent exceeding the turbine's rated power capacity. This helps ensure the generator operates within safe limits.</p></li><li data-start=\"1246\" data-end=\"1421\" class=\"\"><p data-start=\"1249\" data-end=\"1421\" class=\"\"><strong data-start=\"1249\" data-end=\"1271\">Low Wind Operation</strong>: In low wind conditions, the controller adjusts the blade pitch to ensure the turbine starts generating power efficiently, even at lower wind speeds.</p><p data-start=\"1249\" data-end=\"1421\" class=\"\"><!--StartFragment-->By tying together the limits of the controller’s various correctors, this model offers enhanced flexibility<!--EndFragment-->&nbsp;compared to the model A.&nbsp;</p></li></ol>
<p>
 </p><p></p></body></html>"),
    Icon(graphics = {Text(origin = {0, 4}, extent = {{-60, 46}, {60, -46}}, textString = "WTGP B"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {116, 22}, extent = {{-18, 12}, {18, -12}}, textString = "theta"), Text(origin = {-34, 114}, extent = {{-28, 14}, {28, -14}}, textString = "wt"), Text(origin = {-127, 85}, extent = {{-21, 13}, {21, -13}}, textString = "wref"), Text(origin = {-124, -38}, extent = {{-20, 12}, {20, -12}}, textString = "Pord"), Text(origin = {-28, -110}, extent = {{-16, 14}, {16, -14}}, textString = "Pref"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end WTGPb;
