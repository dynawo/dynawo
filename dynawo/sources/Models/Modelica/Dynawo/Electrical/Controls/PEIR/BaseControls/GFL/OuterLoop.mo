within Dynawo.Electrical.Controls.PEIR.BaseControls.GFL;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model OuterLoop "Average outer loop for GFL converters"

  parameter Types.PerUnit Kpd "Active power PI controller proportional gain in pu/s (base UNom, SNom)";
  parameter Types.PerUnit Kid "Active power PI controller integral gain in pu/s (base UNom, SNom)";
  parameter Types.PerUnit Kpq "Reactive power PI controller proportional gain in pu/s (base UNom, SNom)";
  parameter Types.PerUnit Kiq "Reactive power PI controller integral gain in pu/s (base UNom, SNom)";
  parameter Types.PerUnit Kqv "Reactive current gain for fault-ride through mode in pu";
  parameter Types.PerUnit UFrt "Voltage value to activate the frt mode in pu";
  parameter Types.PerUnit IMaxPu "Maximum inverter current amplitude in pu (base UNom, SNom)";
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag";

  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = PFilter0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PFilteredFilterPu(start = PFilter0Pu) "Active power at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilteredFilterPu(start = QFilter0Pu) "Reactive power at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -52}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = QFilter0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = IdConv0Pu) "d-axis current reference at the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = IqConv0Pu) "q-axis current reference at the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = -1, k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-10, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Kiq, outMax = 1000, outMin = -1000, y_start = -IqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-46, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpq) annotation(
    Placement(visible = true, transformation(origin = {-46, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator1(k = Kid, outMax = 1000, outMin = -1000, y_start = IdConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {12, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kpd) annotation(
    Placement(visible = true, transformation(origin = {-38, 104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-80, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-84, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit PFilter0Pu "Start value of active power at the converter's capacitor in pu (base SNom)";
  parameter Types.PerUnit QFilter0Pu "Start value of reactive power at the converter's capacitor in pu (base SNom)";
  parameter Types.PerUnit UPcc0Pu "Start value of voltage at the converter's pcc in pu (base UNom)";
  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {84, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {86, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFL.CurrentLimitsCalculation currentLimitsCalculation(IMaxPu = IMaxPu, PQFlag = PQFlag)  annotation(
    Placement(visible = true, transformation(origin = {52, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UPcc0PuValue(k = UPcc0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-109, -99}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPccFilteredPu(start = UPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-112, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Math.Add add2(k1 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-54, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Kqv)  annotation(
    Placement(visible = true, transformation(origin = {-22, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3(k1 = 1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {22, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant ZeroIqFault(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-108, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch frtOn annotation(
    Placement(visible = true, transformation(origin = {0, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Logical.GreaterThreshold frtOff(threshold = UFrt)  annotation(
    Placement(visible = true, transformation(origin = {-52, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(limIntegrator.y, add1.u2) annotation(
    Line(points = {{-35, -10}, {-31.5, -10}, {-31.5, -8}, {-30, -8}, {-30, 4}, {-22, 4}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{-35, 30}, {-30, 30}, {-30, 16}, {-22, 16}}, color = {0, 0, 127}));
  connect(limIntegrator1.y, add.u2) annotation(
    Line(points = {{-27, 62}, {-10, 62}, {-10, 76}, {0, 76}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{-27, 104}, {-10, 104}, {-10, 88}, {0, 88}}, color = {0, 0, 127}));
  connect(PFilterRefPu, feedback1.u1) annotation(
    Line(points = {{-110, 84}, {-88, 84}}, color = {0, 0, 127}));
  connect(feedback1.y, gain1.u) annotation(
    Line(points = {{-71, 84}, {-60, 84}, {-60, 104}, {-50, 104}}, color = {0, 0, 127}));
  connect(feedback1.y, limIntegrator1.u) annotation(
    Line(points = {{-71, 84}, {-60, 84}, {-60, 62}, {-50, 62}}, color = {0, 0, 127}));
  connect(QFilterRefPu, feedback.u1) annotation(
    Line(points = {{-110, 18}, {-92, 18}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-75, 18}, {-66, 18}, {-66, 30}, {-58, 30}}, color = {0, 0, 127}));
  connect(feedback.y, limIntegrator.u) annotation(
    Line(points = {{-75, 18}, {-66, 18}, {-66, -10}, {-58, -10}}, color = {0, 0, 127}));
  connect(PFilteredFilterPu, feedback1.u2) annotation(
    Line(points = {{-110, 58}, {-80, 58}, {-80, 76}}, color = {0, 0, 127}));
  connect(QFilteredFilterPu, feedback.u2) annotation(
    Line(points = {{-110, -12}, {-84, -12}, {-84, 10}}, color = {0, 0, 127}));
  connect(add.y, variableLimiter.u) annotation(
    Line(points = {{23, 82}, {72, 82}}, color = {0, 0, 127}));
  connect(UPcc0PuValue.y, add2.u2) annotation(
    Line(points = {{-101, -99}, {-85.1, -99}, {-85.1, -92}, {-66, -92}}, color = {0, 0, 127}));
  connect(gain2.u, add2.y) annotation(
    Line(points = {{-34, -86}, {-43, -86}}, color = {0, 0, 127}));
  connect(add3.y, variableLimiter1.u) annotation(
    Line(points = {{33, -2}, {74, -2}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.idConvRefUnlPu, add.y) annotation(
    Line(points = {{41, 38}, {32, 38}, {32, 82}, {24, 82}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.ipMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{63, 40}, {66, 40}, {66, 90}, {72, 90}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(currentLimitsCalculation.ipMinPu, variableLimiter.limit2) annotation(
    Line(points = {{63, 36}, {68, 36}, {68, 74}, {72, 74}}, color = {0, 0, 127}));
  connect(add3.u1, add1.y) annotation(
    Line(points = {{10, 4}, {6, 4}, {6, 10}, {2, 10}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.iqConvRefUnlPu, add3.y) annotation(
    Line(points = {{41, 26}, {35, 26}, {35, -2}, {33, -2}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.iqMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{63, 24}, {65, 24}, {65, -10}, {74, -10}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(variableLimiter1.limit1, currentLimitsCalculation.iqMaxPu) annotation(
    Line(points = {{74, 6}, {74, 28}, {64, 28}}, color = {0, 0, 127}));
  connect(UPccFilteredPu, add2.u1) annotation(
    Line(points = {{-112, -58}, {-88, -58}, {-88, -80}, {-66, -80}}, color = {0, 0, 127}));
  connect(ZeroIqFault.y, frtOn.u1) annotation(
    Line(points = {{-101, -40}, {-8, -40}, {-8, -38}}, color = {0, 0, 127}));
  connect(frtOn.y, add3.u2) annotation(
    Line(points = {{0, -15}, {0, -8}, {10, -8}}, color = {0, 0, 127}));
  connect(gain2.y, frtOn.u3) annotation(
    Line(points = {{-11, -86}, {8, -86}, {8, -38}}, color = {0, 0, 127}));
  connect(variableLimiter.y, idConvRefPu) annotation(
    Line(points = {{96, 82}, {110, 82}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, iqConvRefPu) annotation(
    Line(points = {{98, -2}, {110, -2}}, color = {0, 0, 127}));
  connect(UPccFilteredPu, frtOff.u) annotation(
    Line(points = {{-112, -58}, {-64, -58}}, color = {0, 0, 127}));
  connect(frtOff.y, frtOn.u2) annotation(
    Line(points = {{-40, -58}, {0, -58}, {0, -38}}, color = {255, 0, 255}));
  annotation(preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(extent = {{-100, 100}, {100, -100}}, textString = "Outer Loop")}),
  Diagram(coordinateSystem(initialScale = 0.5)));
end OuterLoop;
