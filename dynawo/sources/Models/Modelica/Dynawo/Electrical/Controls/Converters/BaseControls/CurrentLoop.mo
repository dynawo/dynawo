within Dynawo.Electrical.Controls.Converters.BaseControls;

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

model CurrentLoop "Current loop control for grid forming and grid following converters"

  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit UdFilter0Pu "Start value of the d-axis voltage at the converter terminal (filter) in p.u (base UNom)";
  parameter Types.PerUnit UdConv0Pu "Start value of the d-axis converter modulated voltage in p.u (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of the q-axis converter modulated voltage in p.u (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of the d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of the q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit Lfilter "Filter inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Rfilter "Filter resistance in p.u (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency" annotation(
    Placement(visible = true, transformation(origin = {-151, 3}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-140, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter" annotation(
    Placement(visible = true, transformation(origin = {-150, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-90, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter" annotation(
    Placement(visible = true, transformation(origin = {-151, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-30, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {80, 140}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-90, 130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = 0) "q-axis voltage at the converter's capacitor in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {80, -139}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-30, 130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start = IdConv0Pu) "d-axis current reference in the converter" annotation(
    Placement(visible = true, transformation(origin = {-150, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-140, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start = IqConv0Pu) "q-axis current reference in the converter" annotation(
    Placement(visible = true, transformation(origin = {-151, -89}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-140, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference" annotation(
    Placement(visible = true, transformation(origin = {150, 92}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {140, 39}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference" annotation(
    Placement(visible = true, transformation(origin = {150, -85}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {140, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gaind(k = Kpc) annotation(
    Placement(visible = true, transformation(origin = {-12, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratord(y_start = Rfilter * IdConv0Pu, k = Kic)  annotation(
    Placement(visible = true, transformation(origin = {-12, 111}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackd annotation(
    Placement(visible = true, transformation(origin = {-62, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackq annotation(
    Placement(visible = true, transformation(origin = {-62, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainq(k = Kpc) annotation(
    Placement(visible = true, transformation(origin = {-12, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorq(k = Kic, y_start = Rfilter * IqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-12, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-48, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-48, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainLfd(k=Lfilter) annotation(
    Placement(visible = true, transformation(origin = {-12, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainLfq(k=Lfilter) annotation(
    Placement(visible = true, transformation(origin = {-12, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addd1 annotation(
    Placement(visible = true, transformation(origin = {34, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addq1 annotation(
    Placement(visible = true, transformation(origin = {34, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackLwq annotation(
    Placement(visible = true, transformation(origin = {70, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add feedbackLwd annotation(
    Placement(visible = true, transformation(origin = {70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addd2 annotation(
    Placement(visible = true, transformation(origin = {108, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addq2 annotation(
    Placement(visible = true, transformation(origin = {111, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  connect(feedbackd.u1, idConvRefPu) annotation(
    Line(points = {{-70, 80}, {-119.5, 80}, {-119.5, 100}, {-150, 100}}, color = {0, 0, 127}));
  connect(feedbackd.u2, idConvPu) annotation(
    Line(points = {{-62, 72}, {-62, 50}, {-150, 50}}, color = {0, 0, 127}));
  connect(feedbackq.u1, iqConvRefPu) annotation(
    Line(points = {{-70, -80}, {-120, -80}, {-120, -89}, {-151, -89}}, color = {0, 0, 127}));
  connect(feedbackq.u2, iqConvPu) annotation(
    Line(points = {{-62, -72}, {-62, -40}, {-151, -40}}, color = {0, 0, 127}));
  connect(gaind.u, feedbackd.y) annotation(
    Line(points = {{-24, 80}, {-53, 80}}, color = {0, 0, 127}));
  connect(gainq.u, feedbackq.y) annotation(
    Line(points = {{-24, -80}, {-53, -80}}, color = {0, 0, 127}));
  connect(product.u1, idConvPu) annotation(
    Line(points = {{-60, 28}, {-122, 28}, {-122, 50}, {-150, 50}}, color = {0, 0, 127}));
  connect(product.u2, omegaPu) annotation(
    Line(points = {{-60, 16}, {-122, 16}, {-122, 3}, {-151, 3}}, color = {0, 0, 127}));
  connect(product1.u1, omegaPu) annotation(
    Line(points = {{-60, -12}, {-122, -12}, {-122, 3}, {-151, 3}}, color = {0, 0, 127}));
  connect(product1.u2, iqConvPu) annotation(
    Line(points = {{-60, -24}, {-122, -24}, {-122, -40}, {-151, -40}}, color = {0, 0, 127}));
  connect(integratorq.u, feedbackq.y) annotation(
    Line(points = {{-24, -110}, {-53, -110}, {-53, -80}}, color = {0, 0, 127}));
  connect(GainLfd.u, product.y) annotation(
    Line(points = {{-24, 22}, {-37, 22}}, color = {0, 0, 127}));
  connect(GainLfq.u, product1.y) annotation(
    Line(points = {{-24, -18}, {-37, -18}}, color = {0, 0, 127}));
  connect(addd1.u2, gaind.y) annotation(
    Line(points = {{22, 80}, {0, 80}, {0, 80}, {0, 80}}, color = {0, 0, 127}));
  connect(addd1.u1, integratord.y) annotation(
    Line(points = {{22, 92}, {20, 92}, {20, 111}, {-1, 111}}, color = {0, 0, 127}));
  connect(addq1.u1, gainq.y) annotation(
    Line(points = {{22, -80}, {0, -80}, {0, -80}, {0, -80}}, color = {0, 0, 127}));
  connect(addq1.u2, integratorq.y) annotation(
    Line(points = {{22, -92}, {20, -92}, {20, -110}, {0, -110}, {0, -110}}, color = {0, 0, 127}));
  connect(feedbackLwq.u1, addd1.y) annotation(
    Line(points = {{62, 86}, {46, 86}, {46, 86}, {46, 86}}, color = {0, 0, 127}));
  connect(feedbackLwq.u2, GainLfq.y) annotation(
    Line(points = {{70, 78}, {70, 78}, {70, -18}, {0, -18}, {0, -18}}, color = {0, 0, 127}));
  connect(feedbackLwd.u2, addq1.y) annotation(
    Line(points = {{58, -86}, {46, -86}}, color = {0, 0, 127}));
  connect(addd2.u2, feedbackLwq.y) annotation(
    Line(points = {{96, 86}, {80, 86}}, color = {0, 0, 127}));
  connect(addd2.u1, udFilterPu) annotation(
    Line(points = {{96, 98}, {80, 98}, {80, 140}}, color = {0, 0, 127}));
  connect(addd2.y, udConvRefPu) annotation(
    Line(points = {{119, 92}, {150, 92}}, color = {0, 0, 127}));
  connect(addq2.u1, feedbackLwd.y) annotation(
    Line(points = {{99, -80}, {81, -80}}, color = {0, 0, 127}));
  connect(addq2.u2, uqFilterPu) annotation(
    Line(points = {{99, -92}, {80, -92}, {80, -139}}, color = {0, 0, 127}));
  connect(addq2.y, uqConvRefPu) annotation(
    Line(points = {{122, -86}, {138, -86}, {138, -85}, {150, -85}}, color = {0, 0, 127}));
  connect(integratord.u, feedbackd.y) annotation(
    Line(points = {{-24, 111}, {-54, 111}, {-54, 80}, {-53, 80}}, color = {0, 0, 127}));
  connect(GainLfd.y, feedbackLwd.u1) annotation(
    Line(points = {{-1, 22}, {50, 22}, {50, -73}, {58, -73}, {58, -74}}, color = {0, 0, 127}));

annotation(
    Icon(coordinateSystem(grid = {1, 1}, extent = {{-130, -120}, {130, 120}}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, extent = {{-130, 119.5}, {130, -120.5}}), Text(origin = {-71, 46.5}, extent = {{195, -137.5}, {-52, 47.5}}, textString = "CurrentLoop")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-130, -120}, {130, 120}})));

end CurrentLoop;
