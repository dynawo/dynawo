within Dynawo.Electrical.Controls.Converters.BasicBlocks;

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

model MatchingControl "Matching Control"

  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit K "Proportional gain of the matching control";
  parameter Types.PerUnit Veffref0 "Start value of the voltage reference at the converter's capacitor in p.u (base UNom)";
  parameter Types.PerUnit omega0Pu;
  parameter Types.PerUnit omegaRef0Pu;
  parameter Types.PerUnit wref0;
  parameter Types.PerUnit voqref0;
  parameter Types.PerUnit vodref0;
  parameter Types.PerUnit DeltaVVIq0;
  parameter Types.PerUnit DeltaVVId0;
  parameter Types.Angle deph0;
  parameter Types.PerUnit vdcref0;
  parameter Types.PerUnit vdc0;

  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = omega0Pu) "Converter's frequency" annotation(
    Placement(visible = true, transformation(origin = {33, 65}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vdcref(start = vdcref0) annotation(
    Placement(visible = true, transformation(origin = {-120, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-71, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vdc(start = vdc0) annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain(k = K) annotation(
    Placement(visible = true, transformation(origin = {-37, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput wref(start = wref0) annotation(
    Placement(visible = true, transformation(origin = {-120, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {0, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {49, 65}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = SystemBase.omegaNom) annotation(
    Placement(visible = true, transformation(origin = {81, 65}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput deph(start = deph0) annotation(
    Placement(visible = true, transformation(origin = {110, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Veffref(start = Veffref0) annotation(
    Placement(visible = true, transformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVId(start = DeltaVVId0) annotation(
    Placement(visible = true, transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Feedback feedback5 annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput vodref(start = vodref0) annotation(
    Placement(visible = true, transformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-53, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVIq(start = DeltaVVIq0) annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Feedback feedback7 annotation(
    Placement(visible = true, transformation(origin = {0, -95}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput voqref(start = voqref0) annotation(
    Placement(visible = true, transformation(origin = {110, -95}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  connect(feedback1.y, gain.u) annotation(
    Line(points = {{-62, 40}, {-49, 40}}, color = {0, 0, 127}));
  connect(add1.y, omegaPu) annotation(
    Line(points = {{11, 64}, {18.5, 64}, {18.5, 65}, {33, 65}}, color = {0, 0, 127}));
  connect(feedback2.u1, omegaPu) annotation(
    Line(points = {{41, 65}, {33, 65}}, color = {0, 0, 127}));
  connect(feedback2.u2, omegaRefPu) annotation(
    Line(points = {{49, 73}, {49, 100}, {-120, 100}}, color = {0, 0, 127}));
  connect(integrator.u, feedback2.y) annotation(
    Line(points = {{69, 65}, {58, 65}}, color = {0, 0, 127}));
  connect(deph, integrator.y) annotation(
    Line(points = {{110, 64}, {108, 64}, {108, 65}, {92, 65}}, color = {0, 0, 127}));
  connect(feedback5.y, vodref) annotation(
    Line(points = {{9, -50}, {110, -50}}, color = {0, 0, 127}));
  connect(DeltaVVIq, feedback7.u2) annotation(
    Line(points = {{-120, -80}, {0, -80}, {0, -87}}, color = {0, 0, 127}));
  connect(feedback7.y, voqref) annotation(
    Line(points = {{9, -95}, {110, -95}}, color = {0, 0, 127}));
  connect(vdc, feedback1.u1) annotation(
    Line(points = {{-120, 40}, {-79, 40}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{-62, 40}, {-49, 40}}, color = {0, 0, 127}));
  connect(add1.y, omegaPu) annotation(
    Line(points = {{11, 64}, {18.5, 64}, {18.5, 65}, {33, 65}}, color = {0, 0, 127}));
  connect(const.y, feedback7.u1) annotation(
    Line(points = {{-42, -96}, {-8, -96}, {-8, -95}}, color = {0, 0, 127}));
  connect(vdcref, feedback1.u2) annotation(
    Line(points = {{-120, 10}, {-71, 10}, {-71, 32}}, color = {0, 0, 127}));
  connect(wref, add1.u1) annotation(
    Line(points = {{-120, 70}, {-12, 70}}, color = {0, 0, 127}));
  connect(gain.y, add1.u2) annotation(
    Line(points = {{-26, 40}, {-20, 40}, {-20, 58}, {-12, 58}, {-12, 58}}, color = {0, 0, 127}));
  connect(Veffref, feedback5.u1) annotation(
    Line(points = {{-120, -50}, {-9, -50}, {-9, -50}, {-8, -50}}, color = {0, 0, 127}));
  connect(DeltaVVId, feedback5.u2) annotation(
    Line(points = {{-120, -20}, {0, -20}, {0, -42}, {0, -42}}, color = {0, 0, 127}));

  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})));

end MatchingControl;
