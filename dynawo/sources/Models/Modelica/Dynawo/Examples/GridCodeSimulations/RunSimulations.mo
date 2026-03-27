within Dynawo.Examples.GridCodeSimulations;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model RunSimulations
  extends Modelica.Icons.Example;

  SheetSimulations.SheetI2Xcca sheetI2Xcca annotation(
    Placement(transformation(origin = {-90, 30}, extent = {{-20, -20}, {20, 20}})));
  SheetSimulations.SheetI2Xccb sheetI2Xccb annotation(
    Placement(transformation(origin = {-30, 30}, extent = {{-20, -20}, {20, 20}})));
  SheetSimulations.SheetI5 sheetI5 annotation(
    Placement(transformation(origin = {30, 30}, extent = {{-20, -20}, {20, 20}})));
  SheetSimulations.SheetI6 sheetI6 annotation(
    Placement(transformation(origin = {90, 30}, extent = {{-20, -20}, {20, 20}})));
  SheetSimulations.SheetI7QMax sheetI7QMax annotation(
    Placement(transformation(origin = {-90, -30}, extent = {{-20, -20}, {20, 20}})));
  SheetSimulations.SheetI7QMin sheetI7QMin annotation(
    Placement(transformation(origin = {-30, -30}, extent = {{-20, -20}, {20, 20}})));
  SheetSimulations.SheetI10 sheetI10 annotation(
    Placement(transformation(origin = {30, -30}, extent = {{-20, -20}, {20, 20}})));

equation

annotation(
  Diagram(coordinateSystem(extent = {{-120, -100}, {120, 100}})),
  Icon(coordinateSystem(extent = {{-120, -100}, {120, 100}})),
  Documentation(info = "<html><head></head><body>Run this simulation to run at the same time all the simulation test cases fom the french grid code.<div><br></div><div>
<p data-start=\"61\" data-end=\"96\"><strong data-start=\"61\" data-end=\"96\">Ideas for package improvements:</strong></p><p style=\"margin: 0px;\">
</p><ul data-start=\"98\" data-end=\"297\">
<li data-section-id=\"1is4hjg\" data-start=\"98\" data-end=\"230\">
<p data-start=\"100\" data-end=\"230\">Expose parameters at a higher level to allow direct modification while visualizing curves across all simulations simultaneously.</p>
</li>
<li data-section-id=\"18yh7n5\" data-start=\"231\" data-end=\"269\">
<p data-start=\"233\" data-end=\"269\">Identify and fix the issue in I10.</p>
</li>
<li data-section-id=\"1vussqs\" data-start=\"270\" data-end=\"297\">
<p data-start=\"272\" data-end=\"297\">Perform the Zone 1 tests.</p></li></ul><p style=\"margin: 0px;\"><!--EndFragment--></p></div></body></html>"));
end RunSimulations;
