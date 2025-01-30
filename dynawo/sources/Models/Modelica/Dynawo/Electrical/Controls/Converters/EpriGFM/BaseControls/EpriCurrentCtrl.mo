within Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model EpriCurrentCtrl "Current controller in EPRI Grid Forming model"
  extends Parameters.CurrentCtrl;
  extends Parameters.InitialCurrentCtrl;
  
  // inputs
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "D-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start = IdConv0Pu) "D-axis current reference of the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "Q-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start = IqConv0Pu) "Q-axis current reference of the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "Measured d-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-149, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "Measured q-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //outputs
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "D-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {210, 65}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "Q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {210, -57}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {121, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {120, 65}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addd1 annotation(
    Placement(visible = true, transformation(origin = {-20, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addd2 annotation(
    Placement(visible = true, transformation(origin = {90, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addq1 annotation(
    Placement(visible = true, transformation(origin = {-20, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addq2 annotation(
    Placement(visible = true, transformation(origin = {90, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackd annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add feedbackLwd annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add feedbackLwq(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackq annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tE, k = 1, y(start = UdConv0Pu), y_start = UdConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {158, 65}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tE, k = 1, y(start = UqConv0Pu), y_start = UqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {157, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = RFilterPu) annotation(
    Placement(visible = true, transformation(origin = {-45, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = RFilterPu) annotation(
    Placement(visible = true, transformation(origin = {-46, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gaind(k = KPi) annotation(
    Placement(visible = true, transformation(origin = {-60, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainLfd(k = LFilterPu) annotation(
    Placement(visible = true, transformation(origin = {-10, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainLfq(k = LFilterPu) annotation(
    Placement(visible = true, transformation(origin = {-10, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainq(k = KPi) annotation(
    Placement(visible = true, transformation(origin = {-60, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratord(k = KIi, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorq(initType = Modelica.Blocks.Types.Init.InitialState, k = KIi, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-90, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-90, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
  connect(addq2.u1, feedbackLwd.y) annotation(
    Line(points = {{78, -80}, {61, -80}}, color = {0, 0, 127}));
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
  connect(gain.u, iqConvPu) annotation(
    Line(points = {{-57, -50}, {-150, -50}}, color = {0, 0, 127}));
  connect(add.u1, gain.y) annotation(
    Line(points = {{109, -50}, {-34, -50}}, color = {0, 0, 127}));
  connect(add.u2, addq2.y) annotation(
    Line(points = {{109, -62}, {101, -62}, {101, -86}}, color = {0, 0, 127}));
  connect(add1.u1, addd2.y) annotation(
    Line(points = {{108, 71}, {101, 71}, {101, 86}}, color = {0, 0, 127}));
  connect(gain1.u, idConvPu) annotation(
    Line(points = {{-58, 50}, {-150, 50}}, color = {0, 0, 127}));
  connect(add1.u2, gain1.y) annotation(
    Line(points = {{108, 59}, {-35, 59}, {-35, 50}}, color = {0, 0, 127}));
  connect(firstOrder.u, add1.y) annotation(
    Line(points = {{146, 65}, {131, 65}}, color = {0, 0, 127}));
  connect(firstOrder1.u, add.y) annotation(
    Line(points = {{145, -56}, {132, -56}}, color = {0, 0, 127}));
  connect(uqConvRefPu, firstOrder1.y) annotation(
    Line(points = {{210, -57}, {168, -57}, {168, -56}}, color = {0, 0, 127}));
  connect(udConvRefPu, firstOrder.y) annotation(
    Line(points = {{210, 65}, {169, 65}}, color = {0, 0, 127}));
  
  annotation(
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Rectangle(extent = {{-99, 100}, {99, -100}}), Text(origin = {-3, 1}, extent = {{-103, 84}, {103, -84}}, textString = "EPRI\ncurrent\ncontrol")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {200, 140}})));
end EpriCurrentCtrl;
