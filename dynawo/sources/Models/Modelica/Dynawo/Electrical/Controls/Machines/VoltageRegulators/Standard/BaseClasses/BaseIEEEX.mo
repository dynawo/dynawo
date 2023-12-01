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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model BaseIEEEX "IEEE excitation system types 1 and 2 base model"

  //Regulation parameters
  parameter Types.PerUnit AEx "Gain of saturation function";
  parameter Types.PerUnit BEx "Exponential coefficient of saturation function";
  parameter Types.PerUnit Ka "Voltage regulator gain";
  parameter Types.PerUnit Ke "Exciter field proportional constant";
  parameter Types.PerUnit Kf "Exciter rate feedback gain";
  parameter Types.Time tA "Voltage regulator time constant in s";
  parameter Types.Time tB "Voltage regulator lag time constant in s";
  parameter Types.Time tC "Voltage regulator lead time constant in s";
  parameter Types.Time tE "Exciter field time constant in s";
  parameter Types.Time tF1 "Feedback lead time constant in s";
  parameter Types.Time tR "Stator voltage filter time constant in s";
  parameter Types.VoltageModulePu VrMaxPu "Maximum field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum field voltage in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = 0) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-280, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-280, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-280, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-280, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = 0) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-280, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Sum sum1(k = {-1, 1, 1, 1, 1}, nin = 5) annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {tB, 1}, b = {tC, 1}, x_scaled(start = {Va0Pu / Ka}), x_start = {Va0Pu / Ka}, y_start = Va0Pu / Ka) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(K = Ka, Y0 = Va0Pu, YMax = VrMaxPu, YMin = VrMinPu, tFilter = tA) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / tE, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = AEx) annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = tF1, k = Kf) annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Abs abs1 annotation(
    Placement(visible = true, transformation(origin = {210, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Power power(base = exp(BEx)) annotation(
    Placement(visible = true, transformation(origin = {170, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = Ke) annotation(
    Placement(visible = true, transformation(origin = {170, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu UsRef0Pu = Va0Pu / Ka + Us0Pu "Initial reference stator voltage in pu (base UNom)";
  final parameter Types.VoltageModulePu Va0Pu = Efd0Pu * (Ke + AEx * exp(BEx * Efd0Pu)) "Initial output voltage of voltage regulator in pu (user-selected base voltage)";

equation
  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-280, 0}, {-242, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum1.u[1]) annotation(
    Line(points = {{-219, 0}, {-183, 0}}, color = {0, 0, 127}));
  connect(UsRefPu, sum1.u[2]) annotation(
    Line(points = {{-280, -40}, {-200, -40}, {-200, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[3]) annotation(
    Line(points = {{-280, 40}, {-200, 40}, {-200, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(UUelPu, sum1.u[4]) annotation(
    Line(points = {{-280, -80}, {-200, -80}, {-200, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(UOelPu, sum1.u[5]) annotation(
    Line(points = {{-280, 80}, {-200, 80}, {-200, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(sum1.y, feedback.u1) annotation(
    Line(points = {{-159, 0}, {-129, 0}}, color = {0, 0, 127}));
  connect(feedback.y, transferFunction.u) annotation(
    Line(points = {{-111, 0}, {-83, 0}}, color = {0, 0, 127}));
  connect(derivative.y, feedback.u2) annotation(
    Line(points = {{-81, -60}, {-120, -60}, {-120, -8}}, color = {0, 0, 127}));
  connect(integrator.y, EfdPu) annotation(
    Line(points = {{121, 0}, {270, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, integrator.u) annotation(
    Line(points = {{29, 0}, {98, 0}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, feedback1.u1) annotation(
    Line(points = {{-19, 0}, {12, 0}}, color = {0, 0, 127}));
  connect(transferFunction.y, limitedFirstOrder.u) annotation(
    Line(points = {{-59, 0}, {-43, 0}}, color = {0, 0, 127}));
  connect(integrator.y, abs1.u) annotation(
    Line(points = {{121, 0}, {240, 0}, {240, -40}, {222, -40}}, color = {0, 0, 127}));
  connect(power.y, add.u1) annotation(
    Line(points = {{159, -40}, {140, -40}, {140, -54}, {122, -54}}, color = {0, 0, 127}));
  connect(const.y, add.u2) annotation(
    Line(points = {{160, -80}, {140, -80}, {140, -66}, {122, -66}}, color = {0, 0, 127}));
  connect(add.y, product.u1) annotation(
    Line(points = {{100, -60}, {80, -60}, {80, -74}, {62, -74}}, color = {0, 0, 127}));
  connect(integrator.y, product.u2) annotation(
    Line(points = {{122, 0}, {240, 0}, {240, -100}, {80, -100}, {80, -86}, {62, -86}}, color = {0, 0, 127}));
  connect(product.y, feedback1.u2) annotation(
    Line(points = {{40, -80}, {20, -80}, {20, -8}}, color = {0, 0, 127}));
  connect(abs1.y, power.u) annotation(
    Line(points = {{200, -40}, {182, -40}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-260, -120}, {260, 120}})));
end BaseIEEEX;
