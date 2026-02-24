within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model AcRotatingExciter "Rotating exciter model for IEEE regulations type AC"

  //Regulation parameters
  parameter Types.PerUnit AEx "Gain of saturation function";
  parameter Types.PerUnit BEx "Exponential coefficient of saturation function";
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Kd "Demagnetizing factor, function of exciter alternator reactances";
  parameter Types.PerUnit Ke "Exciter field resistance constant";
  parameter Types.Time tE "Exciter field time constant in s";
  parameter Types.PerUnit TolLi "Tolerance on limit crossing as a fraction of the difference between initial limits of limited integrator";
  parameter Types.VoltageModulePu VeMinPu "Minimum exciter output voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VfeMaxPu "Maximum exciter field current signal in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput EfePu(start = Efe0Pu) "Output voltage of voltage regulator in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-240, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-240, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput VfePu(start = Efe0Pu) "Field current signal in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-180, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorVariableLimits integratorVariableLimits(K = 1 / tE, LimitMax0 = VeMax0Pu, LimitMin0 = VeMinPu, Tol = TolLi, Y0 = Ve0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-10, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic rectifierRegulationCharacteristic annotation(
    Placement(visible = true, transformation(origin = {150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = AEx) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kd) annotation(
    Placement(visible = true, transformation(origin = {-150, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = VfeMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-150, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {-150, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = VeMinPu) annotation(
    Placement(visible = true, transformation(origin = {-130, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Power power(base = exp(BEx)) annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 1e-5, y_start = VeMax0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = Ke) annotation(
    Placement(visible = true, transformation(origin = {50, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";

  //Initial parameters (calculated by initialization model)
  parameter Types.VoltageModulePu Efe0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Ve0Pu "Initial exciter output voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VeMax0Pu "Maximum exciter output voltage in pu (user-selected base voltage)";

equation
  connect(EfePu, feedback.u1) annotation(
    Line(points = {{-240, -80}, {-188, -80}}, color = {0, 0, 127}));
  connect(IrPu, gain.u) annotation(
    Line(points = {{-240, 120}, {-22, 120}}, color = {0, 0, 127}));
  connect(gain.y, division.u1) annotation(
    Line(points = {{1, 120}, {80, 120}, {80, 86}, {98, 86}}, color = {0, 0, 127}));
  connect(integratorVariableLimits.y, division.u2) annotation(
    Line(points = {{-59, -80}, {80, -80}, {80, 74}, {98, 74}}, color = {0, 0, 127}));
  connect(division.y, rectifierRegulationCharacteristic.u) annotation(
    Line(points = {{121, 80}, {137, 80}}, color = {0, 0, 127}));
  connect(rectifierRegulationCharacteristic.y, product.u1) annotation(
    Line(points = {{161, 80}, {180, 80}, {180, 6}, {198, 6}}, color = {0, 0, 127}));
  connect(product.y, EfdPu) annotation(
    Line(points = {{221, 0}, {249, 0}}, color = {0, 0, 127}));
  connect(integratorVariableLimits.y, product.u2) annotation(
    Line(points = {{-59, -80}, {180, -80}, {180, -6}, {198, -6}}, color = {0, 0, 127}));
  connect(feedback.y, integratorVariableLimits.u) annotation(
    Line(points = {{-171, -80}, {-82, -80}}, color = {0, 0, 127}));
  connect(IrPu, gain1.u) annotation(
    Line(points = {{-240, 120}, {-180, 120}, {-180, 60}, {-162, 60}}, color = {0, 0, 127}));
  connect(const.y, add1.u1) annotation(
    Line(points = {{-139, 100}, {-120, 100}, {-120, 86}, {-82, 86}}, color = {0, 0, 127}));
  connect(gain1.y, add1.u2) annotation(
    Line(points = {{-139, 60}, {-120, 60}, {-120, 74}, {-82, 74}}, color = {0, 0, 127}));
  connect(add1.y, division1.u1) annotation(
    Line(points = {{-59, 80}, {-40, 80}, {-40, 66}, {-22, 66}}, color = {0, 0, 127}));
  connect(gain1.y, add2.u1) annotation(
    Line(points = {{-139, 60}, {-120, 60}, {-120, 26}, {-138, 26}}, color = {0, 0, 127}));
  connect(add2.y, feedback.u2) annotation(
    Line(points = {{-161, 20}, {-180, 20}, {-180, -72}}, color = {0, 0, 127}));
  connect(const1.y, integratorVariableLimits.limitMin) annotation(
    Line(points = {{-119, -120}, {-100, -120}, {-100, -88}, {-83, -88}}, color = {0, 0, 127}));
  connect(division1.y, firstOrder.u) annotation(
    Line(points = {{2, 60}, {38, 60}}, color = {0, 0, 127}));
  connect(firstOrder.y, integratorVariableLimits.limitMax) annotation(
    Line(points = {{61, 60}, {100, 60}, {100, -40}, {-100, -40}, {-100, -72}, {-83, -72}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(add2.y, VfePu) annotation(
    Line(points = {{-161, 20}, {-180, 20}, {-180, -40}, {-151, -40}}, color = {0, 0, 127}));
  connect(power.y, add.u1) annotation(
    Line(points = {{39, 20}, {20, 20}, {20, 6}, {2, 6}}, color = {0, 0, 127}));
  connect(const2.y, add.u2) annotation(
    Line(points = {{40, -20}, {20, -20}, {20, -6}, {2, -6}}, color = {0, 0, 127}));
  connect(add.y, product1.u1) annotation(
    Line(points = {{-20, 0}, {-40, 0}, {-40, -14}, {-58, -14}}, color = {0, 0, 127}));
  connect(integratorVariableLimits.y, product1.u2) annotation(
    Line(points = {{-58, -80}, {-40, -80}, {-40, -26}, {-58, -26}}, color = {0, 0, 127}));
  connect(integratorVariableLimits.y, power.u) annotation(
    Line(points = {{-58, -80}, {80, -80}, {80, 20}, {62, 20}}, color = {0, 0, 127}));
  connect(product1.y, add2.u2) annotation(
    Line(points = {{-80, -20}, {-100, -20}, {-100, 14}, {-138, 14}}, color = {0, 0, 127}));
  connect(product1.y, division1.u2) annotation(
    Line(points = {{-80, -20}, {-100, -20}, {-100, 54}, {-22, 54}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-220, -140}, {240, 140}})));
end AcRotatingExciter;
