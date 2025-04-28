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

partial model BaseAc1 "IEEE excitation system type AC1 base model"

  //Regulation parameters
  parameter Types.PerUnit AEx "Gain of saturation function";
  parameter Types.PerUnit BEx "Exponential coefficient of saturation function";
  parameter Types.VoltageModulePu EfeMaxPu "Maximum exciter field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfeMinPu "Minimum exciter field voltage in pu (user-selected base voltage)";
  parameter Types.PerUnit Ka "Voltage regulator gain";
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Kd "Demagnetizing factor, function of exciter alternator reactances";
  parameter Types.PerUnit Ke "Exciter field resistance constant";
  parameter Types.PerUnit Kf "Exciter rate feedback gain";
  parameter Types.Time tA "Voltage regulator time constant in s";
  parameter Types.Time tB "Voltage regulator lag time constant in s";
  parameter Types.Time tC "Voltage regulator lead time constant in s";
  parameter Types.Time tE "Exciter field time constant in s";
  parameter Types.Time tF "Exciter rate feedback time constant in s";
  parameter Types.PerUnit TolLi "Tolerance on limit crossing as a fraction of the difference between initial limits of limited integrator";
  parameter Types.Time tR "Stator voltage filter time constant in s";
  parameter Types.VoltageModulePu VaMaxPu "Maximum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VaMinPu "Minimum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VeMinPu "Minimum exciter output voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VfeMaxPu "Maximum exciter field current signal in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-300, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = UUel0Pu) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {290, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-250, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction(a = {tB, 1}, b = {tC, 1}, x_start = {Efe0Pu / Ka}, y_start = Efe0Pu / Ka) annotation(
    Placement(visible = true, transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-80, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.AcRotatingExciter acRotatingExciter(
    AEx = AEx,
    BEx = BEx,
    Efd0Pu = Efd0Pu,
    Efe0Pu = Efe0Pu,
    Ir0Pu = Ir0Pu,
    Kc = Kc,
    Kd = Kd,
    Ke = Ke,
    tE = tE,
    TolLi = TolLi,
    Ve0Pu = Ve0Pu,
    VeMax0Pu = VeMax0Pu,
    VeMinPu = VeMinPu,
    VfeMaxPu = VfeMaxPu) annotation(
    Placement(visible = true, transformation(origin = {240, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax min1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {130, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(k = Kf, T = tF, x_start = Efe0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, -140}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(K = Ka, Y0 = Efe0Pu, YMax = VaMaxPu, YMin = VaMinPu, tFilter = tA) annotation(
    Placement(visible = true, transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = EfeMaxPu, uMin = EfeMinPu) annotation(
    Placement(visible = true, transformation(origin = {170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu UOel0Pu "Overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UUel0Pu "Underexcitation limitation initial output voltage in pu (base UNom)";

  //Initial parameters (calculated by initialization model)
  parameter Types.VoltageModulePu Efe0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Ve0Pu "Initial exciter output voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VeMax0Pu "Maximum exciter output voltage in pu (user-selected base voltage)";

  final parameter Types.VoltageModulePu UsRef0Pu = Efe0Pu / Ka + Us0Pu "Initial reference stator voltage in pu (base UNom)";

equation
  connect(UPssPu, add3.u1) annotation(
    Line(points = {{-300, 20}, {-220, 20}, {-220, -12}, {-202, -12}}, color = {0, 0, 127}));
  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-300, -20}, {-262, -20}}, color = {0, 0, 127}));
  connect(firstOrder.y, add3.u2) annotation(
    Line(points = {{-239, -20}, {-203, -20}}, color = {0, 0, 127}));
  connect(UsRefPu, add3.u3) annotation(
    Line(points = {{-300, -60}, {-220, -60}, {-220, -28}, {-202, -28}}, color = {0, 0, 127}));
  connect(acRotatingExciter.EfdPu, EfdPu) annotation(
    Line(points = {{262, 0}, {290, 0}}, color = {0, 0, 127}));
  connect(IrPu, acRotatingExciter.IrPu) annotation(
    Line(points = {{-300, 140}, {200, 140}, {200, 16}, {216, 16}}, color = {0, 0, 127}));
  connect(max1.yMax, min1.u[1]) annotation(
    Line(points = {{81, -14}, {119, -14}}, color = {0, 0, 127}));
  connect(feedback.y, transferFunction.u) annotation(
    Line(points = {{-70, -20}, {-42, -20}}, color = {0, 0, 127}));
  connect(transferFunction.y, limitedFirstOrder.u) annotation(
    Line(points = {{-18, -20}, {-2, -20}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, max1.u[1]) annotation(
    Line(points = {{22, -20}, {60, -20}}, color = {0, 0, 127}));
  connect(min1.yMin, limiter.u) annotation(
    Line(points = {{142, -20}, {158, -20}}, color = {0, 0, 127}));
  connect(limiter.y, acRotatingExciter.EfePu) annotation(
    Line(points = {{181, -20}, {200, -20}, {200, 0}, {215, 0}}, color = {0, 0, 127}));
  connect(acRotatingExciter.VfePu, derivative.u) annotation(
    Line(points = {{262, -16}, {280, -16}, {280, -140}, {22, -140}}, color = {0, 0, 127}));
  connect(derivative.y, feedback.u2) annotation(
    Line(points = {{-1, -140}, {-80, -140}, {-80, -28}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-280, -160}, {280, 160}})));
end BaseAc1;
