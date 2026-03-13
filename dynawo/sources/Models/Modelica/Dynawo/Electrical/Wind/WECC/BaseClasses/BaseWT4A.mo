within Dynawo.Electrical.Wind.WECC.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

partial model BaseWT4A "Partial base model for WECC Wind Turbine 4A"
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGT;
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BaseWT4;

  Dynawo.Electrical.Controls.WECC.Mechanical.WTGTa wecc_wtgt(
    Dshaft = Dshaft,
    Hg = Hg,
    Ht = Ht,
    Kshaft = Kshaft,
    PConv0Pu = PConv0Pu,
    PePu(start = PConv0Pu),
    Pm0Pu = PConv0Pu,
    omegaRefWTGQPu0 = omegaRefWTGQPu0) annotation(
    Placement(visible = true, transformation(origin = {-91, -41}, extent = {{-10, -5}, {10, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmConst(k = PConv0Pu) annotation(
    Placement(transformation(origin = {-119, -37}, extent = {{-5, -5}, {5, 5}})));

equation
  connect(wecc_wtgt.omegaGPu, wecc_reec.omegaGPu) annotation(
    Line(points = {{-86, -35}, {-85, -35}, {-85, -11}}, color = {0, 0, 127}));
  connect(PmConst.y, wecc_wtgt.PmPu) annotation(
    Line(points = {{-113.5, -37}, {-102, -37}}, color = {0, 0, 127}));
  connect(LvMeasurements.PPu, wecc_wtgt.PePu) annotation(
    Line(points = {{62, -6}, {62, -41}, {-80, -41}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end BaseWT4A;
