within Dynawo.Electrical.Sources.BaseConverters;

model IECFrameRotation
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
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  /*Control parameters*/
  parameter Types.Time Tpll "Time constant for PLL first order filter model in seconds";
  parameter Types.PerUnit Upll1 "Voltage below which the angle of the voltage is filtered/frozen in p.u (base UNom)";
  //parameter Types.PerUnit Upll2         "Voltage below which the angle of the voltage is frozen in p.u (base UNom)";
  /*Operational parameters for initialization*/
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in p.u (base UNom, SnRef) (receptor convention)";
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = -(i0Pu.re * cos(Theta0) + i0Pu.im * sin(Theta0)) * SystemBase.SnRef / SNom) "d-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = -((-i0Pu.re * sin(Theta0)) + i0Pu.im * cos(Theta0)) * SystemBase.SnRef / SNom) "q-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-90, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput uWTPu(start = sqrt(u0Pu.re * u0Pu.re + u0Pu.im * u0Pu.im)) "WTT voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -90}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  /*Ouputs*/
  Modelica.Blocks.Interfaces.RealOutput iGsRePu(start = -i0Pu.re * SystemBase.SnRef / SNom) "Real component of the current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iGsImPu(start = -i0Pu.im * SystemBase.SnRef / SNom) "Imaginary component of the current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput thetaPll(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {90, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  /*Blocks*/
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {62, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = Upll1) annotation(
    Placement(visible = true, transformation(origin = {10, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tpll, k = 1, y_start = Theta0) annotation(
    Placement(visible = true, transformation(origin = {12, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //
equation
/*Reference frame transformation*/
  [iGsRePu; iGsImPu] = [cos(thetaPll), -sin(thetaPll); sin(thetaPll), cos(thetaPll)] * [ipCmdPu; iqCmdPu];
/*Connectors*/
  connect(lessThreshold.y, switch1.u2) annotation(
    Line(points = {{21, -30}, {40, -30}, {40, -70}, {50, -70}}, color = {255, 0, 255}));
  connect(firstOrder.y, switch1.u1) annotation(
    Line(points = {{23, -62}, {50, -62}}, color = {0, 0, 127}));
  connect(uWTPu, lessThreshold.u) annotation(
    Line(points = {{-90, -30}, {-2, -30}, {-2, -30}, {-2, -30}}, color = {0, 0, 127}));
  connect(theta, firstOrder.u) annotation(
    Line(points = {{-90, -90}, {-30, -90}, {-30, -62}, {0, -62}, {0, -62}}, color = {0, 0, 127}));
  connect(theta, switch1.u3) annotation(
    Line(points = {{-90, -90}, {38, -90}, {38, -78}, {50, -78}, {50, -78}}, color = {0, 0, 127}));
  connect(switch1.y, thetaPll) annotation(
    Line(points = {{74, -70}, {84, -70}, {84, -70}, {90, -70}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-80, -100}, {80, 100}})),
    Icon(coordinateSystem(extent = {{-30, -100}, {30, 100}}, initialScale = 0.1), graphics = {Rectangle(origin = {1, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-31, 100}, {29, -102}}), Text(origin = {46, 57}, rotation = 90, extent = {{-148, 127}, {34, -33}}, textString = "Reference Frame Rotation")}));
end IECFrameRotation;
