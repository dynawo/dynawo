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

  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit Lfilter "Filter inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit Rfilter "Filter resistance in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency" annotation(
    Placement(visible = true, transformation(origin = {-142, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter" annotation(
    Placement(visible = true, transformation(origin = {-142, 52}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter" annotation(
    Placement(visible = true, transformation(origin = {-142, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {80, 140}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-80,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = 0) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {80, -126}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-40,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start = IdConv0Pu) "d-axis current reference in the converter" annotation(
    Placement(visible = true, transformation(origin = {-142, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start = IqConv0Pu) "q-axis current reference in the converter" annotation(
    Placement(visible = true, transformation(origin = {-142, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference" annotation(
    Placement(visible = true, transformation(origin = {180, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference" annotation(
    Placement(visible = true, transformation(origin = {180, -86}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gaind(k = Kpc) annotation(
    Placement(visible = true, transformation(origin = {-12, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratord(k = Kic, y_start = Rfilter * IdConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-12, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
    Placement(visible = true, transformation(origin = {74, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addd2 annotation(
    Placement(visible = true, transformation(origin = {112, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addq2 annotation(
    Placement(visible = true, transformation(origin = {114, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit UdFilter0Pu;
  parameter Types.PerUnit UdConv0Pu;
  parameter Types.PerUnit UqConv0Pu;
  parameter Types.PerUnit IdConv0Pu;
  parameter Types.PerUnit IqConv0Pu;

equation
  connect(feedbackd.u1, idConvRefPu) annotation(
    Line(points = {{-70, 80}, {-142, 80}}, color = {0, 0, 127}));
  connect(feedbackd.u2, idConvPu) annotation(
    Line(points = {{-62, 72}, {-62, 52}, {-142, 52}}, color = {0, 0, 127}));
  connect(feedbackq.u1, iqConvRefPu) annotation(
    Line(points = {{-70, -80}, {-142, -80}}, color = {0, 0, 127}));
  connect(feedbackq.u2, iqConvPu) annotation(
    Line(points = {{-62, -72}, {-62, -50}, {-142, -50}}, color = {0, 0, 127}));
  connect(gaind.u, feedbackd.y) annotation(
    Line(points = {{-24, 80}, {-53, 80}}, color = {0, 0, 127}));
  connect(integratord.u, feedbackd.y) annotation(
    Line(points = {{-24, 112}, {-54, 112}, {-54, 80}, {-53, 80}}, color = {0, 0, 127}));
  connect(gainq.u, feedbackq.y) annotation(
    Line(points = {{-24, -80}, {-53, -80}}, color = {0, 0, 127}));
  connect(product.u1, idConvPu) annotation(
    Line(points = {{-60, 28}, {-122, 28}, {-122, 52}, {-142, 52}}, color = {0, 0, 127}));
  connect(product.u2, omegaPu) annotation(
    Line(points = {{-60, 16}, {-122, 16}, {-122, 2}, {-142, 2}}, color = {0, 0, 127}));
  connect(product1.u1, omegaPu) annotation(
    Line(points = {{-60, -12}, {-122, -12}, {-122, 2}, {-142, 2}}, color = {0, 0, 127}));
  connect(product1.u2, iqConvPu) annotation(
    Line(points = {{-60, -24}, {-122, -24}, {-122, -50}, {-142, -50}}, color = {0, 0, 127}));
  connect(integratorq.u, feedbackq.y) annotation(
    Line(points = {{-24, -110}, {-53, -110}, {-53, -80}}, color = {0, 0, 127}));
  connect(GainLfd.u, product.y) annotation(
    Line(points = {{-24, 22}, {-37, 22}}, color = {0, 0, 127}));
  connect(GainLfq.u, product1.y) annotation(
    Line(points = {{-24, -18}, {-37, -18}}, color = {0, 0, 127}));
  connect(addd1.u2, gaind.y) annotation(
    Line(points = {{22, 80}, {0, 80}, {0, 80}, {0, 80}}, color = {0, 0, 127}));
  connect(addd1.u1, integratord.y) annotation(
    Line(points = {{22, 92}, {20, 92}, {20, 112}, {0, 112}, {0, 112}}, color = {0, 0, 127}));
  connect(addq1.u1, gainq.y) annotation(
    Line(points = {{22, -80}, {0, -80}, {0, -80}, {0, -80}}, color = {0, 0, 127}));
  connect(addq1.u2, integratorq.y) annotation(
    Line(points = {{22, -92}, {20, -92}, {20, -110}, {0, -110}, {0, -110}}, color = {0, 0, 127}));
  connect(feedbackLwq.u1, addd1.y) annotation(
    Line(points = {{62, 86}, {46, 86}, {46, 86}, {46, 86}}, color = {0, 0, 127}));
  connect(feedbackLwq.u2, GainLfq.y) annotation(
    Line(points = {{70, 78}, {70, 78}, {70, -18}, {0, -18}, {0, -18}}, color = {0, 0, 127}));
  connect(feedbackLwd.u2, addq1.y) annotation(
    Line(points = {{62, -86}, {44, -86}, {44, -86}, {46, -86}}, color = {0, 0, 127}));
  connect(feedbackLwd.u1, GainLfd.y) annotation(
    Line(points = {{62, -74}, {60, -74}, {60, 22}, {0, 22}, {0, 22}}, color = {0, 0, 127}));
  connect(addd2.u2, feedbackLwq.y) annotation(
    Line(points = {{100, 86}, {80, 86}, {80, 86}, {80, 86}}, color = {0, 0, 127}));
  connect(addd2.u1, udFilterPu) annotation(
    Line(points = {{100, 98}, {80, 98}, {80, 140}, {80, 140}}, color = {0, 0, 127}));
  connect(addd2.y, udConvRefPu) annotation(
    Line(points = {{124, 92}, {162, 92}, {162, 90}, {180, 90}}, color = {0, 0, 127}));
  connect(addq2.u1, feedbackLwd.y) annotation(
    Line(points = {{102, -80}, {86, -80}, {86, -80}, {86, -80}}, color = {0, 0, 127}));
  connect(addq2.u2, uqFilterPu) annotation(
    Line(points = {{102, -92}, {80, -92}, {80, -126}, {80, -126}}, color = {0, 0, 127}));
  connect(addq2.y, uqConvRefPu) annotation(
    Line(points = {{126, -86}, {160, -86}, {160, -86}, {180, -86}}, color = {0, 0, 127}));

  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})));
end CurrentLoop;
