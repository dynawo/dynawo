within Dynawo.Electrical.Sources.BaseConverters;

model IECMechanical
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
  /*Blocks*/
  /*Equivalent circuit and conventions:*/
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  /*Mechanical parameters*/
  parameter Types.PerUnit Cdrt;
  parameter Types.PerUnit Kdrt;
  parameter Types.PerUnit Hwtr;
  parameter Types.PerUnit Hgen;
  /*Parameters for initialization from load flow*/
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput paeroPu(start = -P0Pu * SystemBase.SnRef / SNom) "d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput pagPu(start = -P0Pu * SystemBase.SnRef / SNom) "Maximal d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  /*Ouputs*/
  Modelica.Blocks.Interfaces.RealOutput omegaWTRPu(start = SystemBase.omegaRef0Pu) "Real component of the current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {70, 32.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-51, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput omegaGenPu(start = SystemBase.omegaRef0Pu) "Imaginary component of the current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {70, -33}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  //
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-23, 33}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / 2 * Hwtr, y_start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {15, 33}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-23, -33}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {35, 0}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = 1 / 2 * Hgen, y_start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {15, -33}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator2(k = Kdrt, y_start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {15, -10}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-15, 0}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = Cdrt) annotation(
    Placement(visible = true, transformation(origin = {15, 10}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-45, 33}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {-45, -33}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
equation
/*Connectors*/
  connect(integrator.y, omegaWTRPu) annotation(
    Line(points = {{20.5, 33}, {63, 33}, {63, 32.5}, {70, 32.5}}, color = {0, 0, 127}));
  connect(add.y, integrator.u) annotation(
    Line(points = {{-17, 33}, {9, 33}}, color = {0, 0, 127}));
  connect(integrator.y, add3.u1) annotation(
    Line(points = {{20.5, 33}, {50, 33}, {50, 3}, {41, 3}}, color = {0, 0, 127}));
  connect(integrator1.y, add3.u2) annotation(
    Line(points = {{20.5, -33}, {50, -33}, {50, -3}, {41, -3}}, color = {0, 0, 127}));
  connect(integrator2.y, add1.u2) annotation(
    Line(points = {{9.5, -10}, {0.25, -10}, {0.25, -3}, {-9, -3}}, color = {0, 0, 127}));
  connect(const.y, add1.u1) annotation(
    Line(points = {{9.5, 10}, {0, 10}, {0, 3}, {-9, 3}}, color = {0, 0, 127}));
  connect(add3.y, integrator2.u) annotation(
    Line(points = {{30, 0}, {25.5, 0}, {25.5, -10}, {21, -10}}, color = {0, 0, 127}));
  connect(add1.y, add.u2) annotation(
    Line(points = {{-20.5, 0}, {-30, 0}, {-30, 30}, {-29, 30}}, color = {0, 0, 127}));
  connect(add1.y, add2.u1) annotation(
    Line(points = {{-20.5, 0}, {-30, 0}, {-30, -30}, {-29, -30}}, color = {0, 0, 127}));
  connect(add2.y, integrator1.u) annotation(
    Line(points = {{-17, -33}, {9, -33}}, color = {0, 0, 127}));
  connect(integrator1.y, omegaGenPu) annotation(
    Line(points = {{20.5, -33}, {70, -33}}, color = {0, 0, 127}));
  connect(division.y, add.u1) annotation(
    Line(points = {{-39, 33}, {-35, 33}, {-35, 36}, {-29, 36}, {-29, 36}}, color = {0, 0, 127}));
  connect(paeroPu, division.u2) annotation(
    Line(points = {{-70, 30}, {-51, 30}, {-51, 30}, {-51, 30}}, color = {0, 0, 127}));
  connect(integrator.y, division.u1) annotation(
    Line(points = {{21, 33}, {50, 33}, {50, 50}, {-55, 50}, {-55, 36}, {-51, 36}}, color = {0, 0, 127}));
  connect(division1.y, add2.u2) annotation(
    Line(points = {{-39, -33}, {-35, -33}, {-35, -36}, {-29, -36}, {-29, -36}}, color = {0, 0, 127}));
  connect(pagPu, division1.u1) annotation(
    Line(points = {{-70, -30}, {-52, -30}, {-52, -30}, {-51, -30}}, color = {0, 0, 127}));
  connect(integrator1.y, division1.u2) annotation(
    Line(points = {{21, -33}, {50, -33}, {50, -50}, {-55, -50}, {-55, -36}, {-51, -36}, {-51, -36}}, color = {0, 0, 127}));
  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-60, -60}, {60, 60}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-3, 27}, extent = {{-93, -15}, {100, 20}}, textString = "Mechanical"), Text(origin = {4, -27}, extent = {{-100, -20}, {91, 16}}, textString = "module")}));
end IECMechanical;
