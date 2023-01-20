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

model VoltageLoop "Voltage loop control for grid forming and grid following converters"
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit Kpv "Proportional gain of the voltage loop";
  parameter Types.PerUnit Kiv "Integral gain of the voltage loop";
  parameter Types.PerUnit CFilter "Filter capacitance in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterRefPu(start = UdFilter0Pu) "d-axis voltage reference at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterRefPu(start = UqFilter0Pu) "q-axis voltage reference at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = IdConv0Pu) "d-axis current reference in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {150, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = IqConv0Pu) "q-axis current reference in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {150, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gaind(k = Kpv) annotation(
    Placement(visible = true, transformation(origin = {-60, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratord(k = Kiv, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackd annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackq annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainq(k = Kpv) annotation(
    Placement(visible = true, transformation(origin = {-60, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorq(k = Kiv, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-90, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-90, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainCfd(k = CFilter) annotation(
    Placement(visible = true, transformation(origin = {-10, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainCfq(k = CFilter) annotation(
    Placement(visible = true, transformation(origin = {-10, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addd1 annotation(
    Placement(visible = true, transformation(origin = {-20, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addq1 annotation(
    Placement(visible = true, transformation(origin = {-20, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add feedbackCwd annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add feedbackCwq(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addd2 annotation(
    Placement(visible = true, transformation(origin = {90, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addq2 annotation(
    Placement(visible = true, transformation(origin = {90, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";

equation
  connect(feedbackd.u1, udFilterRefPu) annotation(
    Line(points = {{-128, 80}, {-150, 80}}, color = {0, 0, 127}));
  connect(feedbackd.u2, udFilterPu) annotation(
    Line(points = {{-120, 72}, {-120, 50}, {-150, 50}}, color = {0, 0, 127}));
  connect(feedbackq.u1, uqFilterRefPu) annotation(
    Line(points = {{-128, -80}, {-150, -80}}, color = {0, 0, 127}));
  connect(feedbackq.u2, uqFilterPu) annotation(
    Line(points = {{-120, -72}, {-120, -50}, {-150, -50}}, color = {0, 0, 127}));
  connect(gaind.u, feedbackd.y) annotation(
    Line(points = {{-72, 80}, {-111, 80}}, color = {0, 0, 127}));
  connect(gainq.u, feedbackq.y) annotation(
    Line(points = {{-72, -80}, {-111, -80}}, color = {0, 0, 127}));
  connect(GainCfd.u, product.y) annotation(
    Line(points = {{-22, 25}, {-79, 25}}, color = {0, 0, 127}));
  connect(GainCfq.u, product1.y) annotation(
    Line(points = {{-22, -25}, {-79, -25}}, color = {0, 0, 127}));
  connect(addd1.u2, gaind.y) annotation(
    Line(points = {{-32, 80}, {-49, 80}}, color = {0, 0, 127}));
  connect(addq1.u1, gainq.y) annotation(
    Line(points = {{-32, -80}, {-49, -80}}, color = {0, 0, 127}));
  connect(feedbackCwd.u2, addq1.y) annotation(
    Line(points = {{38, -86}, {-9, -86}}, color = {0, 0, 127}));
  connect(addd2.y, idConvRefPu) annotation(
    Line(points = {{101, 86}, {150, 86}}, color = {0, 0, 127}));
  connect(addq2.u1, feedbackCwd.y) annotation(
    Line(points = {{78, -80}, {61, -80}}, color = {0, 0, 127}));
  connect(addq2.y, iqConvRefPu) annotation(
    Line(points = {{101, -86}, {150, -86}}, color = {0, 0, 127}));
  connect(uqFilterPu, product1.u2) annotation(
    Line(points = {{-150, -50}, {-120, -50}, {-120, -31}, {-102, -31}}, color = {0, 0, 127}));
  connect(omegaPu, product1.u1) annotation(
    Line(points = {{-150, 0}, {-120, 0}, {-120, -19}, {-102, -19}}, color = {0, 0, 127}));
  connect(omegaPu, product.u2) annotation(
    Line(points = {{-150, 0}, {-120, 0}, {-120, 19}, {-102, 19}}, color = {0, 0, 127}));
  connect(udFilterPu, product.u1) annotation(
    Line(points = {{-150, 50}, {-120, 50}, {-120, 31}, {-102, 31}}, color = {0, 0, 127}));
  connect(feedbackq.y, integratorq.u) annotation(
    Line(points = {{-111, -80}, {-90, -80}, {-90, -110}, {-72, -110}}, color = {0, 0, 127}));
  connect(integratorq.y, addq1.u2) annotation(
    Line(points = {{-49, -110}, {-40, -110}, {-40, -92}, {-32, -92}}, color = {0, 0, 127}));
  connect(feedbackd.y, integratord.u) annotation(
    Line(points = {{-111, 80}, {-90, 80}, {-90, 110}, {-72, 110}}, color = {0, 0, 127}));
  connect(integratord.y, addd1.u1) annotation(
    Line(points = {{-49, 110}, {-40, 110}, {-40, 92}, {-32, 92}}, color = {0, 0, 127}));
  connect(addd1.y, feedbackCwq.u1) annotation(
    Line(points = {{-9, 86}, {38, 86}}, color = {0, 0, 127}));
  connect(GainCfq.y, feedbackCwq.u2) annotation(
    Line(points = {{1, -25}, {10, -25}, {10, 74}, {38, 74}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(GainCfd.y, feedbackCwd.u1) annotation(
    Line(points = {{1, 25}, {10, 25}, {10, -74}, {38, -74}}, color = {0, 0, 127}));
  connect(feedbackCwq.y, addd2.u2) annotation(
    Line(points = {{61, 80}, {78, 80}}, color = {0, 0, 127}));
  connect(idPccPu, addd2.u1) annotation(
    Line(points = {{-150, 130}, {70, 130}, {70, 92}, {78, 92}}, color = {0, 0, 127}));
  connect(iqPccPu, addq2.u2) annotation(
    Line(points = {{-150, -130}, {70, -130}, {70, -92}, {78, -92}}, color = {0, 0, 127}));

  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {140, 140}})));
end VoltageLoop;
