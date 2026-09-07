within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

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

model IEEET1 "IEEE type 1 Exciter (IEEET1)"

  parameter Types.VoltageModulePu EfdHighPu "Higher abscissa of saturation characteristic in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfdLowPu "Lower abscissa of saturation characteristic in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfdRawMaxPu "Maximum non-saturated excitation voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfdRawMinPu "Minimum non-saturated excitation voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfdSatHighPu "Higher ordinate of saturation characteristic in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfdSatLowPu "Lower ordinate of saturation characteristic in pu (user-selected base voltage)";
  parameter Types.PerUnit Ka "Voltage regulator gain";
  parameter Types.PerUnit Ke "Exciter gain";
  parameter Types.PerUnit Kf "Exciter rate feedback gain";
  parameter Types.Time tA "Voltage regulator time constant in s";
  parameter Types.Time tE "Exciter time constant in s";
  parameter Types.Time tF "Exciter rate feedback time constant in s";
  parameter Types.Time tR "Stator voltage time constant in s";

  final parameter Types.PerUnit Bsq = if EfdHighPu > EfdThresholdPu then EfdHighPu * EfdSatHighPu / (EfdHighPu - EfdThresholdPu) ^ 2 else 0 "Proportional coefficient of saturation characteristic";
  final parameter Types.VoltageModulePu EfdThresholdPu = (EfdLowPu - EfdHighPu * Sq) / (1 - Sq) "Excitation voltage below which saturation function output is zero, in pu (user-selected base voltage)";
  final parameter Types.PerUnit Sq = if (EfdHighPu > 0 and EfdSatHighPu > 0) then sqrt(EfdLowPu * EfdSatLowPu / (EfdHighPu * EfdSatHighPu)) else 0 "Ratio of staturation characteristic";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = 0) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = 0) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.SatChar satChar(Asq = EfdThresholdPu, Bsq = Bsq, Sq = Sq, UHigh = EfdHighPu, ULow = EfdLowPu, YHigh = EfdSatHighPu, YLow = EfdSatLowPu) annotation(
    Placement(visible = true, transformation(origin = {130, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(initType = Modelica.Blocks.Types.Init.InitialState, T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(K = Ka, tFilter = tA, Y0 = EfdRaw0Pu, YMax = EfdRawMaxPu, YMin = EfdRawMinPu) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(k = {1, 1, 1, 1, -1}, nin = 5) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = -1, k3 = -Ke) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / tE, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = tF, k = Kf, x_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu EfdRaw0Pu = Ke * Efd0Pu + (if Efd0Pu > EfdThresholdPu then Bsq * (Efd0Pu - EfdThresholdPu) ^ 2 else 0) "Initial non-saturated excitation voltage in pu (user-selected base voltage)";
  final parameter Types.VoltageModulePu UsRef0Pu = if Ka > 0 then Us0Pu + EfdRaw0Pu / Ka else 0 "Initial reference stator voltage in pu (base UNom)";

equation
  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-200, -80}, {-162, -80}}, color = {0, 0, 127}));
  connect(feedback.y, limitedFirstOrder.u) annotation(
    Line(points = {{-11, 0}, {17, 0}}, color = {0, 0, 127}));
  connect(sum1.y, feedback.u1) annotation(
    Line(points = {{-59, 0}, {-29, 0}}, color = {0, 0, 127}));
  connect(UOelPu, sum1.u[1]) annotation(
    Line(points = {{-200, 80}, {-100, 80}, {-100, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(UUelPu, sum1.u[2]) annotation(
    Line(points = {{-200, 40}, {-100, 40}, {-100, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[3]) annotation(
    Line(points = {{-200, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(UsRefPu, sum1.u[4]) annotation(
    Line(points = {{-200, -40}, {-100, -40}, {-100, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum1.u[5]) annotation(
    Line(points = {{-138, -80}, {-100, -80}, {-100, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(satChar.y, add3.u1) annotation(
    Line(points = {{120, 60}, {60, 60}, {60, 8}, {78, 8}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, add3.u2) annotation(
    Line(points = {{42, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(add3.y, integrator.u) annotation(
    Line(points = {{102, 0}, {118, 0}}, color = {0, 0, 127}));
  connect(integrator.y, EfdPu) annotation(
    Line(points = {{142, 0}, {190, 0}}, color = {0, 0, 127}));
  connect(integrator.y, satChar.u) annotation(
    Line(points = {{142, 0}, {160, 0}, {160, 60}, {142, 60}}, color = {0, 0, 127}));
  connect(integrator.y, derivative.u) annotation(
    Line(points = {{142, 0}, {160, 0}, {160, -80}, {102, -80}}, color = {0, 0, 127}));
  connect(derivative.y, feedback.u2) annotation(
    Line(points = {{80, -80}, {-20, -80}, {-20, -8}}, color = {0, 0, 127}));
  connect(integrator.y, add3.u3) annotation(
    Line(points = {{142, 0}, {160, 0}, {160, -40}, {60, -40}, {60, -8}, {78, -8}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-180, -100}, {180, 100}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Rectangle(extent = {{-138, 100}, {-138, 100}}), Text(extent = {{-100, 60}, {100, -60}}, textString = "IEEET1")}),
    Documentation(info = "<html><head></head><body>This model implements the IEEE Type 1 Exciter as shown in the&nbsp;<!--StartFragment-->I. C. Report, \"Computer representation of excitation systems,\" in <em>IEEE Transactions on Power Apparatus and Systems</em>, vol. PAS-87, no. 6, pp. 1460-1464, June 1968, doi: 10.1109/TPAS.1968.292114.<!--EndFragment--></body></html>"));
end IEEET1;
