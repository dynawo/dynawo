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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model EpriCurrentControl "Current controller in EPRI Grid Forming model"
  extends Parameters.CurrentControl;
  extends Parameters.OmegaFlag;

  // Line parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom), example value = 0.00015" annotation(
  Dialog(tab = "Circuit"));
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom), example value = 0.15"  annotation(
  Dialog(tab = "Circuit"));

  // Input variables
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "D-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start = IdConv0Pu) "D-axis current reference of the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "Q-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start = (if OmegaFlag == 0 then -1 else 1) * IqConv0Pu) "Q-axis current reference of the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "Measured d-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-149, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "Measured q-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output Variables
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "D-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {210, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "Q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {210, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {132, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {131, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addd1 annotation(
    Placement(visible = true, transformation(origin = {-20, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addd2 annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tE, k = 1, y_start = UdConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tE, k = 1, y_start = UqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {171, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = RFilterPu) annotation(
    Placement(visible = true, transformation(origin = {-40, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = RFilterPu) annotation(
    Placement(visible = true, transformation(origin = {-46, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gaind(k = KPi) annotation(
    Placement(visible = true, transformation(origin = {-60, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainLfd(k = LFilterPu) annotation(
    Placement(visible = true, transformation(origin = {-10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainLfq(k = LFilterPu) annotation(
    Placement(visible = true, transformation(origin = {-10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainq(k = KPi) annotation(
    Placement(visible = true, transformation(origin = {-60, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratord(k = KIi, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorq(initType = Modelica.Blocks.Types.Init.InitialState, k = KIi, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-80, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Dialog(tab = "Initial"));
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
  Dialog(tab = "Initial"));

equation
  connect(feedbackd.u1, idConvRefPu) annotation(
    Line(points = {{-128, 80}, {-150, 80}}, color = {0, 0, 127}));
  connect(feedbackd.u2, idConvPu) annotation(
    Line(points = {{-120, 72}, {-120, 50}, {-150, 50}}, color = {0, 0, 127}));
  connect(feedbackq.u1, iqConvRefPu) annotation(
    Line(points = {{-128, -80}, {-150, -80}}, color = {0, 0, 127}));
  connect(gaind.u, feedbackd.y) annotation(
    Line(points = {{-72, 80}, {-111, 80}}, color = {0, 0, 127}));
  connect(gainq.u, feedbackq.y) annotation(
    Line(points = {{-72, -80}, {-111, -80}}, color = {0, 0, 127}));
  connect(addd1.u2, gaind.y) annotation(
    Line(points = {{-32, 80}, {-49, 80}}, color = {0, 0, 127}));
  connect(addq1.u1, gainq.y) annotation(
    Line(points = {{-32, -80}, {-49, -80}}, color = {0, 0, 127}));
  connect(feedbackLwd.u2, addq1.y) annotation(
    Line(points = {{38, -86}, {-9, -86}}, color = {0, 0, 127}));
  connect(addq2.u1, feedbackLwd.y) annotation(
    Line(points = {{78, -80}, {61, -80}}, color = {0, 0, 127}));
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
    Line(points = {{1, -20}, {10, -20}, {10, 74}, {38, 74}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(feedbackLwq.y, addd2.u2) annotation(
    Line(points = {{61, 80}, {69.5, 80}, {69.5, 84}, {78, 84}}, color = {0, 0, 127}));
  connect(udFilterPu, addd2.u1) annotation(
    Line(points = {{-149, 130}, {70, 130}, {70, 96}, {78, 96}}, color = {0, 0, 127}));
  connect(GainLfd.y, feedbackLwd.u1) annotation(
    Line(points = {{1, 20}, {10, 20}, {10, -74}, {38, -74}}, color = {0, 0, 127}));
  connect(uqFilterPu, addq2.u2) annotation(
    Line(points = {{-150, -130}, {70, -130}, {70, -92}, {78, -92}}, color = {0, 0, 127}));
  connect(gain.u, iqConvPu) annotation(
    Line(points = {{-52, -50}, {-150, -50}}, color = {0, 0, 127}));
  connect(add.u1, gain.y) annotation(
    Line(points = {{120, -54}, {109.5, -54}, {109.5, -50}, {-29, -50}}, color = {0, 0, 127}));
  connect(add.u2, addq2.y) annotation(
    Line(points = {{120, -66}, {110.5, -66}, {110.5, -86}, {101, -86}, {101, -86}}, color = {0, 0, 127}));
  connect(add1.u1, addd2.y) annotation(
    Line(points = {{119, 66}, {110, 66}, {110, 90}, {101, 90}}, color = {0, 0, 127}));
  connect(gain1.u, idConvPu) annotation(
    Line(points = {{-58, 50}, {-150, 50}}, color = {0, 0, 127}));
  connect(add1.u2, gain1.y) annotation(
    Line(points = {{119, 54}, {110.5, 54}, {110.5, 50}, {-35, 50}}, color = {0, 0, 127}));
  connect(firstOrder.u, add1.y) annotation(
    Line(points = {{158, 60}, {142, 60}}, color = {0, 0, 127}));
  connect(firstOrder1.u, add.y) annotation(
    Line(points = {{159, -60}, {143, -60}}, color = {0, 0, 127}));
  connect(uqConvRefPu, firstOrder1.y) annotation(
    Line(points = {{210, -60}, {182, -60}}, color = {0, 0, 127}));
  connect(udConvRefPu, firstOrder.y) annotation(
    Line(points = {{210, 60}, {181, 60}}, color = {0, 0, 127}));
  connect(idConvPu, product.u1) annotation(
    Line(points = {{-150, 50}, {-120, 50}, {-120, 26}, {-92, 26}}, color = {0, 0, 127}));
  connect(omegaPu, product.u2) annotation(
    Line(points = {{-150, 0}, {-120, 0}, {-120, 14}, {-92, 14}}, color = {0, 0, 127}));
  connect(product.y, GainLfd.u) annotation(
    Line(points = {{-69, 20}, {-22, 20}}, color = {0, 0, 127}));
  connect(omegaPu, product1.u1) annotation(
    Line(points = {{-150, 0}, {-120, 0}, {-120, -14}, {-92, -14}}, color = {0, 0, 127}));
  connect(iqConvPu, product1.u2) annotation(
    Line(points = {{-150, -50}, {-120, -50}, {-120, -26}, {-92, -26}}, color = {0, 0, 127}));
  connect(product1.y, GainLfq.u) annotation(
    Line(points = {{-69, -20}, {-22, -20}}, color = {0, 0, 127}));
  connect(iqConvPu, feedbackq.u2) annotation(
    Line(points = {{-150, -50}, {-120, -50}, {-120, -72}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Text(origin = {1, -15}, extent = {{-103, 84}, {103, -84}}, textString = "EPRI
current
control"), Rectangle(extent = {{-100, 100}, {100, -100}})}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {200, 140}})));
end EpriCurrentControl;
