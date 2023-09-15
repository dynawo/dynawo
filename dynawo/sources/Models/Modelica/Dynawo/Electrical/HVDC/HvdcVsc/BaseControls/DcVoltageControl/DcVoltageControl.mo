within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.DcVoltageControl;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model DcVoltageControl "DC voltage control for the HVDC VSC model"
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsDcVoltageControl;

  parameter Types.PerUnit IpMaxPu "Maximum value of the active current in pu (base SNom, UNom) (DC to AC)";
  parameter Types.PerUnit RDcPu "Resistance of one cable of DC line in pu (base UDcNom, SnRef)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMaxPu) "Maximum active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-300, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput ipMinPu(start = -IpMaxPu) "Minimum active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-300, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UDcPu(start = UDc0Pu) "DC voltage in pu (base UDcNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -43}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UDcRefPu(start = UDcRef0Pu) "Reference DC voltage in pu (base UDcNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 17}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "AC voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput ipRefPu(start = Ip0Pu) "Active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {290, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tMeasureU, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = UDcRefMaxPu, uMin = UDcRefMinPu) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupVariableLimits PI(Ki = KiDc, Kp = KpDc, Y0 = -Ip0Pu) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division iDCCalc annotation(
    Placement(visible = true, transformation(origin = {-90, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product pCalc annotation(
    Placement(visible = true, transformation(origin = {-190, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = 0, uMin = -0.15) annotation(
    Placement(visible = true, transformation(origin = {-10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 2) annotation(
    Placement(visible = true, transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = RDcPu) annotation(
    Placement(visible = true, transformation(origin = {-50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = SNom / SystemBase.SnRef) annotation(
    Placement(visible = true, transformation(origin = {-50, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  parameter Types.PerUnit Ip0Pu "Start value of active current in pu (base SNom, UNom) (DC to AC)";
  parameter Types.VoltageModulePu U0Pu "Start value of AC voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UDc0Pu "Start value of DC voltage in pu (base UDcNom)";
  parameter Types.VoltageModulePu UDcRef0Pu "Start value of DC voltage reference in pu (base UDcNom)";

equation
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{101, 0}, {132, 0}}, color = {0, 0, 127}));
  connect(gain1.y, ipRefPu) annotation(
    Line(points = {{261, 0}, {290, 0}}, color = {0, 0, 127}));
  connect(feedback.y, PI.u) annotation(
    Line(points = {{149, 0}, {178, 0}}, color = {0, 0, 127}));
  connect(PI.y, gain1.u) annotation(
    Line(points = {{201, 0}, {238, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain.u, pCalc.y) annotation(
    Line(points = {{-162, 40}, {-179, 40}}, color = {0, 0, 127}));
  connect(gain.y, iDCCalc.u1) annotation(
    Line(points = {{-139, 40}, {-120, 40}, {-120, 26}, {-102, 26}}, color = {0, 0, 127}));
  connect(UDcRefPu, add.u2) annotation(
    Line(points = {{-300, -40}, {20, -40}, {20, -6}, {38, -6}}, color = {0, 0, 127}));
  connect(limiter1.y, add.u1) annotation(
    Line(points = {{1, 20}, {20, 20}, {20, 6}, {38, 6}}, color = {0, 0, 127}));
  connect(limiter.u, add.y) annotation(
    Line(points = {{78, 0}, {61, 0}}, color = {0, 0, 127}));
  connect(iDCCalc.y, gain2.u) annotation(
    Line(points = {{-79, 20}, {-62, 20}}, color = {0, 0, 127}));
  connect(gain2.y, limiter1.u) annotation(
    Line(points = {{-39, 20}, {-22, 20}}, color = {0, 0, 127}));
  connect(UDcRefPu, iDCCalc.u2) annotation(
    Line(points = {{-300, -40}, {-120, -40}, {-120, 14}, {-102, 14}}, color = {0, 0, 127}));
  connect(ipMaxPu, PI.limitMax) annotation(
    Line(points = {{-300, 120}, {160, 120}, {160, 6}, {178, 6}}, color = {0, 0, 127}));
  connect(ipMinPu, PI.limitMin) annotation(
    Line(points = {{-300, -120}, {160, -120}, {160, -6}, {178, -6}}, color = {0, 0, 127}));
  connect(firstOrder1.y, pCalc.u2) annotation(
    Line(points = {{-240, 0}, {-220, 0}, {-220, 34}, {-202, 34}}, color = {0, 0, 127}));
  connect(firstOrder1.u, UPu) annotation(
    Line(points = {{-263, 0}, {-300, 0}}, color = {0, 0, 127}));
  connect(UDcPu, feedback.u2) annotation(
    Line(points = {{-300, -80}, {140, -80}, {140, -8}}, color = {0, 0, 127}));
  connect(PI.y, gain3.u) annotation(
    Line(points = {{202, 0}, {220, 0}, {220, 80}, {-38, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain3.y, pCalc.u1) annotation(
    Line(points = {{-61, 80}, {-220, 80}, {-220, 46}, {-202, 46}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-280, -140}, {280, 140}})));
end DcVoltageControl;
