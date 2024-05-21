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

  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit LFilter "Filter inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit RFilter "Filter resistance in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start = IdConv0Pu) "d-axis current reference in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start = IqConv0Pu) "q-axis current reference in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-149, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {150, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {150, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gaind(k = Kpc) annotation(
    Placement(visible = true, transformation(origin = {-60, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratord(k = Kic, y_start = RFilter * IdConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackd annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackq annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainq(k = Kpc) annotation(
    Placement(visible = true, transformation(origin = {-60, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorq(k = Kic, y_start = RFilter * IqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-90, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-90, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainLfd(k = LFilter) annotation(
    Placement(visible = true, transformation(origin = {-10, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainLfq(k = LFilter) annotation(
    Placement(visible = true, transformation(origin = {-10, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addd1 annotation(
    Placement(visible = true, transformation(origin = {-20, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addq1 annotation(
    Placement(visible = true, transformation(origin = {-20, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add feedbackLwd annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add feedbackLwq(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addd2 annotation(
    Placement(visible = true, transformation(origin = {90, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addq2 annotation(
    Placement(visible = true, transformation(origin = {90, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage in pu (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage in pu (base UNom)";

equation
  connect(feedbackd.u1, idConvRefPu) annotation(
    Line(points = {{-128, 80}, {-150, 80}}, color = {0, 0, 127}));
  connect(feedbackd.u2, idConvPu) annotation(
    Line(points = {{-120, 72}, {-120, 50}, {-150, 50}}, color = {0, 0, 127}));
  connect(feedbackq.u1, iqConvRefPu) annotation(
    Line(points = {{-128, -80}, {-150, -80}}, color = {0, 0, 127}));
  connect(feedbackq.u2, iqConvPu) annotation(
    Line(points = {{-120, -72}, {-120, -50}, {-150, -50}}, color = {0, 0, 127}));
  connect(gaind.u, feedbackd.y) annotation(
    Line(points = {{-72, 80}, {-111, 80}}, color = {0, 0, 127}));
  connect(gainq.u, feedbackq.y) annotation(
    Line(points = {{-72, -80}, {-111, -80}}, color = {0, 0, 127}));
  connect(GainLfd.u, product.y) annotation(
    Line(points = {{-22, 25}, {-79, 25}}, color = {0, 0, 127}));
  connect(GainLfq.u, product1.y) annotation(
    Line(points = {{-22, -25}, {-79, -25}}, color = {0, 0, 127}));
  connect(addd1.u2, gaind.y) annotation(
    Line(points = {{-32, 80}, {-49, 80}}, color = {0, 0, 127}));
  connect(addq1.u1, gainq.y) annotation(
    Line(points = {{-32, -80}, {-49, -80}}, color = {0, 0, 127}));
  connect(feedbackLwd.u2, addq1.y) annotation(
    Line(points = {{38, -86}, {-9, -86}}, color = {0, 0, 127}));
  connect(addd2.y, udConvRefPu) annotation(
    Line(points = {{101, 86}, {150, 86}}, color = {0, 0, 127}));
  connect(addq2.u1, feedbackLwd.y) annotation(
    Line(points = {{78, -80}, {61, -80}}, color = {0, 0, 127}));
  connect(addq2.y, uqConvRefPu) annotation(
    Line(points = {{101, -86}, {150, -86}}, color = {0, 0, 127}));
  connect(idConvPu, product.u1) annotation(
    Line(points = {{-150, 50}, {-120, 50}, {-120, 31}, {-102, 31}}, color = {0, 0, 127}));
  connect(omegaPu, product.u2) annotation(
    Line(points = {{-150, 0}, {-120, 0}, {-120, 19}, {-102, 19}}, color = {0, 0, 127}));
  connect(omegaPu, product1.u1) annotation(
    Line(points = {{-150, 0}, {-120, 0}, {-120, -19}, {-102, -19}}, color = {0, 0, 127}));
  connect(iqConvPu, product1.u2) annotation(
    Line(points = {{-150, -50}, {-120, -50}, {-120, -31}, {-102, -31}}, color = {0, 0, 127}));
  connect(feedbackd.y, integratord.u) annotation(
    Line(points = {{-111, 80}, {-90, 80}, {-90, 110}, {-72, 110}}, color = {0, 0, 127}));
  connect(integratord.y, addd1.u1) annotation(
    Line(points = {{-49, 110}, {-40, 110}, {-40, 92}, {-32, 92}}, color = {0, 0, 127}));
  connect(feedbackq.y, integratorq.u) annotation(
    Line(points = {{-111, -80}, {-90, -80}, {-90, -110}, {-72, -110}}, color = {0, 0, 127}));
  connect(integratorq.y, addq1.u2) annotation(
    Line(points = {{-49, -110}, {-40, -110}, {-40, -92}, {-32, -92}}, color = {0, 0, 127}));
  connect(addd1.y, feedbackLwq.u1) annotation(
    Line(points = {{-9, 86}, {38, 86}}, color = {0, 0, 127}));
  connect(GainLfq.y, feedbackLwq.u2) annotation(
    Line(points = {{1, -25}, {10, -25}, {10, 74}, {38, 74}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(feedbackLwq.y, addd2.u2) annotation(
    Line(points = {{61, 80}, {78, 80}}, color = {0, 0, 127}));
  connect(udFilterPu, addd2.u1) annotation(
    Line(points = {{-149, 130}, {70, 130}, {70, 92}, {78, 92}}, color = {0, 0, 127}));
  connect(GainLfd.y, feedbackLwd.u1) annotation(
    Line(points = {{1, 25}, {10, 25}, {10, -74}, {38, -74}}, color = {0, 0, 127}));
  connect(uqFilterPu, addq2.u2) annotation(
    Line(points = {{-150, -130}, {70, -130}, {70, -92}, {78, -92}}, color = {0, 0, 127}));

  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {140, 140}})));
end CurrentLoop;