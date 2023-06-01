within Dynawo;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package AdditionalIcons "Icons for the Dynawo library"
  extends Icons.IconsPackage;

  model Bus
  equation

  annotation(
      Icon(graphics = {Rectangle(origin = {0, 2}, fillPattern = FillPattern.Solid, extent = {{-100, 6}, {100, -10}}), Text(origin = {0, 30}, lineColor = {0, 0, 255}, extent = {{-100, 10}, {100, -10}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)));end Bus;

  model Line
  equation

  annotation(
      Icon(graphics = {Rectangle(origin = {-1, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-59, 11}, {61, -11}}), Line(origin = {-80, 0}, points = {{-20, 0}, {20, 0}}), Line(origin = {80, 0}, points = {{-20, 0}, {20, 0}}), Text(origin = {0, 30}, lineColor = {0, 0, 255}, extent = {{-80, 10}, {80, -10}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)));end Line;

  model Transformer
  equation

  annotation(
      Icon(graphics = {Ellipse(origin = {-15, -7}, extent = {{-45, 47}, {35, -33}}, endAngle = 360), Ellipse(origin = {3, -9}, extent = {{57, 49}, {-23, -31}}, endAngle = 360), Line(origin = {-80, 0}, points = {{-20, 0}, {20, 0}, {20, 0}}), Line(origin = {80, 0}, points = {{-20, 0}, {20, 0}}), Text(origin = {0, 61}, lineColor = {0, 0, 255}, extent = {{-80, 11}, {80, -11}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)));end Transformer;

  model Load
  equation

  annotation(
      Icon(graphics = {Line(origin = {0, -20}, points = {{0, 20}, {0, -20}, {0, -20}}), Polygon(origin = {0, -70}, fillPattern = FillPattern.Solid, points = {{-40, 30}, {40, 30}, {0, -30}, {-40, 30}}), Text(origin = {-1, -120}, lineColor = {0, 0, 255}, extent = {{-81, 10}, {81, -10}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)));end Load;

  model Machine
  equation

  annotation(
      Icon(graphics = {Ellipse(origin = {0, -1}, extent = {{-60, 61}, {60, -59}}, endAngle = 360), Text(origin = {0, 80}, lineColor = {0, 0, 255}, extent = {{-80, 10}, {80, -10}}, textString = "%name"), Line(origin = {-110, 55}, points = {{42, -15}}), Line(points = {{-35.9986, -20}, {-34.0014, -5.4116}, {-30.0014, 9.5884}, {-23.0014, 22.0884}, {-16.0014, 26.5884}, {-6.00142, 21.5884}, {-1, 8.4116}, {0, 0}, {1, -8.4116}, {6.00142, -21.5884}, {16.0014, -26.5884}, {23.0014, -22.0884}, {30.0014, -9.5884}, {34.0014, 5.4116}, {35.9986, 20}})}, coordinateSystem(initialScale = 0.1)));end Machine;

  model Shunt
  equation

  annotation(
    Icon(graphics = {Text(origin = {-1, -120}, lineColor = {0, 0, 255}, extent = {{-81, 10}, {81, -10}}, textString = "%name"), Rectangle(origin = {0, -42}, fillPattern = FillPattern.Solid, extent = {{-40, 2}, {40, -2}}), Rectangle(origin = {-20, -62}, fillPattern = FillPattern.Solid, extent = {{-20, 2}, {60, -2}}), Line(origin = {0, -21}, points = {{0, 21}, {0, -21}}), Line(origin = {0, -100}, points = {{-40, 0}, {40, 0}}), Line(origin = {0, -81}, points = {{0, -19}, {0, 19}})}, coordinateSystem(initialScale = 0.1))); end Shunt;

  model SVarC
  equation

  annotation(
    Icon(graphics = {Text(origin = {-1, -120}, lineColor = {0, 0, 255}, extent = {{-81, 10}, {81, -10}}, textString = "%name"), Rectangle(origin = {0, 18}, fillPattern = FillPattern.Solid, extent = {{-40, 2}, {40, -2}}), Rectangle(origin = {-20, -18}, fillPattern = FillPattern.Solid, extent = {{-20, 2}, {60, -2}}), Line(origin = {0, -21}, points = {{0, 81}, {0, -59}}), Line(origin = {-0.0916367, -80.3386}, points = {{-40, 0}, {40, 0}}), Line(origin = {-2.83665, -2.96415}, points = {{-44, -44}, {52, 52}}, thickness = 1), Line(origin = {39.2032, 49.0758}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {49.6216, 39.4941}, points = {{0, -10}, {0, 10}}, thickness = 1)}, coordinateSystem(initialScale = 0.1)));
  end SVarC;

  model ConditionalForward
  equation
  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}},
            preserveAspectRatio=true), graphics={
          Line(origin={10,34}, points={{-100,-60},{-54,-60}}),
          Ellipse(origin={10,34}, extent={{-54,-64},{-46,-56}}),
          Line(origin={10,34}, points={{-47,-58},{30,-10}}),
          Line(origin={10,34}, points={{30,-40},{30,-60}}),
          Line(origin={10,34}, points={{30,-60},{80,-60}})}));
  end ConditionalForward;

  model Hvdc
  equation

  annotation(
      Icon(graphics = {Rectangle(origin = {1, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-61, 21}, {-21, -19}}), Line(origin = {-80, 0}, points = {{-20, 0}, {20, 0}}), Line(origin = {80, 0}, points = {{-20, 0}, {20, 0}}), Text(origin = {0, 30}, lineColor = {0, 0, 255}, extent = {{-80, 10}, {80, -10}}, textString = "%name"), Rectangle(origin = {40, 0}, extent = {{-20, 20}, {20, -20}}), Line(origin = {0, 10}, points = {{-20, 0}, {20, 0}, {20, 0}}), Line(origin = {0, -10}, points = {{-20, 0}, {20, 0}}), Line(origin = {40, 0}, points = {{-20, -20}, {20, 20}}), Line(origin = {-40, 0}, points = {{-20, -20}, {20, 20}})}, coordinateSystem(initialScale = 0.1)));end Hvdc;

  model Init
  equation
  annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics={Polygon(origin = {-79.17, -24}, fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-15.833, 20}, {-15.833, 30}, {12.167, 38}, {24.167, 20}, {4.167, -30}, {14.167, -30}, {24.167, -30}, {24.167, -40}, {-5.833, -50}, {-15.833, -30}, {4.167, 20}, {-5.833, 20}, {-15.833, 20}}, smooth = Smooth.Bezier), Polygon(origin = {55.833, -23}, fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{12.167, 65}, {14.167, 93}, {36.167, 89}, {24.167, 20}, {4.167, -30}, {14.167, -30}, {24.167, -30}, {24.167, -40}, {-5.833, -50}, {-15.833, -30}, {4.167, 20}, {12.167, 65}}, smooth = Smooth.Bezier), Polygon(origin = {60.74, 15.6673}, fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{49.2597, 22.3327}, {31.2597, 24.3327}, {5.2597, 22.3327}, {-0.740299, 18.3327}, {-0.740299, 18.3327}, {-16.7403, 4.3327}, {-12.7403, -1.6673}, {-6.7403, 4.3327}, {33.2597, 14.3327}, {49.2597, 14.3327}, {49.2597, 22.3327}}, smooth = Smooth.Bezier), Polygon(origin = {18.83, -24}, fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-15.833, 20}, {-15.833, 30}, {14.167, 40}, {24.167, 20}, {4.167, -30}, {14.167, -30}, {24.167, -30}, {24.167, -40}, {-5.833, -50}, {-15.833, -30}, {4.167, 20}, {-5.833, 20}, {-15.833, 20}}, smooth = Smooth.Bezier), Polygon(origin = {-17.17, -24}, fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-41.833, -52}, {-31.833, 22}, {4.167, 36}, {12.167, 18}, {10.167, -24}, {14.167, -30}, {24.167, -30}, {24.167, -40}, {-5.833, -50}, {0.167, 4}, {-15.833, 12}, {-23.833, -36}, {-41.833, -52}}, smooth = Smooth.Bezier), Ellipse(origin = {23.5, 28.5}, fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-12.5, -12.5}, {12.5, 12.5}}, endAngle = 360), Ellipse(origin = {-74.5, 28.5}, fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-12.5, -12.5}, {12.5, 12.5}}, endAngle = 360)}));end Init;


end AdditionalIcons;
