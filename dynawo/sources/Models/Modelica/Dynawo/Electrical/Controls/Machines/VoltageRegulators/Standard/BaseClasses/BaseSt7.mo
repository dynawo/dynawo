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

partial model BaseSt7 "IEEE excitation system type ST7 base model"

  //Regulation parameters
  parameter Types.PerUnit Kh "High-value gate feedback gain";
  parameter Types.PerUnit Kia "Voltage regulator feedback gain";
  parameter Types.PerUnit Kl "Low-value gate feedback gain";
  parameter Types.PerUnit Kpa "Voltage regulator proportional gain";
  parameter Integer PositionOel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";
  parameter Integer PositionScl "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";
  parameter Integer PositionUel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";
  parameter Types.Time tB "Voltage regulator lag time constant in s";
  parameter Types.Time tC "Voltage regulator lead time constant in s";
  parameter Types.Time tF "Stator voltage lag time constant in s";
  parameter Types.Time tG "Stator voltage lead time constant in s";
  parameter Types.Time tIa "Feedback time constant in s";
  parameter Types.Time tR "Stator voltage filter time constant in s";
  parameter Types.VoltageModulePu VMaxPu "Maximum reference voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VMinPu "Minimum reference voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMaxPu "Maximum field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum field voltage in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-400, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-400, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclOelPu(start = USclOel0Pu) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-400, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclUelPu(start = USclUel0Pu) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-400, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-400, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-400, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = UUel0Pu) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-400, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {370, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput VFbPu(start = UsRef0Pu) "Reference stator voltage taking into account OEL and UEL in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-330, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction1(a = {tB, 1}, b = {tC, 1}, x_start = {(1 + Kia) * Efd0Pu}, y_start = (1 + Kia) * Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = VMaxPu, uMin = VMinPu) annotation(
    Placement(visible = true, transformation(origin = {-210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpa) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-60, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {310, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = VrMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-90, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {-90, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(nin = 4) annotation(
    Placement(visible = true, transformation(origin = {-330, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinMaxDynawo3 max1 annotation(
    Placement(visible = true, transformation(origin = {-290, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinMaxDynawo3 min1 annotation(
    Placement(visible = true, transformation(origin = {-250, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinMaxDynawo3 max2 annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinMaxDynawo3 min2 annotation(
    Placement(visible = true, transformation(origin = {210, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MaxDynawo max3 annotation(
    Placement(visible = true, transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinDynawo min3 annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction(a = {tF, 1}, b = {tG, 1}, x_start = {Us0Pu}, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-210, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tIa, k = Kia, y_start = Kia * Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {310, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = Kl) annotation(
    Placement(visible = true, transformation(origin = {30, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain4(k = Kh) annotation(
    Placement(visible = true, transformation(origin = {30, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu UOel0Pu = 0 "Overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclOel0Pu = 0 "Stator current overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclUel0Pu = 0 "Stator current underexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UUel0Pu = 0 "Underexcitation limitation initial output voltage in pu (base UNom)";

  //Initial parameter (calculated by the initialization model)
  parameter Types.VoltageModulePu UsRef0Pu "Initial reference stator voltage in pu (base UNom)";

equation
  if PositionOel == 1 then
    sum1.u[2] = UOelPu;
    min1.u[2] = min1.u[1];
    min2.u[2] = min2.u[1];
  elseif PositionOel == 2 then
    sum1.u[2] = 0;
    min1.u[2] = UOelPu;
    min2.u[2] = min2.u[1];
  elseif PositionOel == 3 then
    sum1.u[2] = 0;
    min1.u[2] = min1.u[1];
    min2.u[2] = UOelPu;
  else
    sum1.u[2] = 0;
    min1.u[2] = min1.u[1];
    min2.u[2] = min2.u[1];
  end if;

  if PositionUel == 1 then
    sum1.u[3] = UUelPu;
    max1.u[2] = max1.u[1];
    max2.u[2] = max2.u[1];
  elseif PositionUel == 2 then
    sum1.u[3] = 0;
    max1.u[2] = UUelPu;
    max2.u[2] = max2.u[1];
  elseif PositionUel == 3 then
    sum1.u[3] = 0;
    max1.u[2] = max1.u[1];
    max2.u[2] = UUelPu;
  else
    sum1.u[3] = 0;
    max1.u[2] = max1.u[1];
    max2.u[2] = max2.u[1];
  end if;

  if PositionScl == 1 then
    sum1.u[4] = USclOelPu + USclUelPu;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
    max2.u[3] = max2.u[1];
    min2.u[3] = min2.u[1];
  elseif PositionScl == 2 then
    sum1.u[4] = 0;
    max1.u[3] = USclUelPu;
    min1.u[3] = USclOelPu;
    max2.u[3] = max2.u[1];
    min2.u[3] = min2.u[1];
  elseif PositionScl == 3 then
    sum1.u[4] = 0;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
    max2.u[3] = USclUelPu;
    min2.u[3] = USclOelPu;
  else
    sum1.u[4] = 0;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
    max2.u[3] = max2.u[1];
    min2.u[3] = min2.u[1];
  end if;

  connect(gain2.y, variableLimiter.limit2) annotation(
    Line(points = {{-79, -140}, {280, -140}, {280, -8}, {298, -8}}, color = {0, 0, 127}));
  connect(variableLimiter.y, EfdPu) annotation(
    Line(points = {{321, 0}, {370, 0}}, color = {0, 0, 127}));
  connect(max1.yMax, min1.u[1]) annotation(
    Line(points = {{-279, 6}, {-261, 6}}, color = {0, 0, 127}));
  connect(max2.yMax, min2.u[1]) annotation(
    Line(points = {{181, 6}, {200, 6}}, color = {0, 0, 127}));
  connect(sum1.y, max1.u[1]) annotation(
    Line(points = {{-319, 0}, {-301, 0}}, color = {0, 0, 127}));
  connect(min1.yMin, limiter.u) annotation(
    Line(points = {{-238, 0}, {-222, 0}}, color = {0, 0, 127}));
  connect(limiter.y, add3.u2) annotation(
    Line(points = {{-199, 0}, {-142, 0}}, color = {0, 0, 127}));
  connect(UPssPu, add3.u1) annotation(
    Line(points = {{-400, 140}, {-160, 140}, {-160, 8}, {-142, 8}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(transferFunction.y, add3.u3) annotation(
    Line(points = {{-199, -100}, {-160, -100}, {-160, -8}, {-142, -8}}, color = {0, 0, 127}));
  connect(add3.y, gain.u) annotation(
    Line(points = {{-119, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(UsRefPu, sum1.u[1]) annotation(
    Line(points = {{-400, 0}, {-342, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-400, -140}, {-360, -140}, {-360, -100}, {-342, -100}}, color = {0, 0, 127}));
  connect(firstOrder.y, transferFunction.u) annotation(
    Line(points = {{-319, -100}, {-222, -100}}, color = {0, 0, 127}));
  connect(gain1.y, variableLimiter.limit1) annotation(
    Line(points = {{-79, 100}, {280, 100}, {280, 8}, {298, 8}}, color = {0, 0, 127}));
  connect(variableLimiter.y, firstOrder2.u) annotation(
    Line(points = {{321, 0}, {340, 0}, {340, -60}, {322, -60}}, color = {0, 0, 127}));
  connect(UsPu, gain2.u) annotation(
    Line(points = {{-400, -140}, {-102, -140}}, color = {0, 0, 127}));
  connect(UsPu, gain1.u) annotation(
    Line(points = {{-400, -140}, {-360, -140}, {-360, 100}, {-102, 100}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback2.u2) annotation(
    Line(points = {{299, -60}, {120, -60}, {120, -8}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(firstOrder2.y, gain3.u) annotation(
    Line(points = {{299, -60}, {100, -60}, {100, 60}, {41, 60}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain3.y, feedback.u2) annotation(
    Line(points = {{19, 60}, {8, 60}}, color = {0, 0, 127}));
  connect(gain1.y, feedback.u1) annotation(
    Line(points = {{-79, 100}, {0, 100}, {0, 68}, {0, 68}}, color = {0, 0, 127}));
  connect(feedback.y, min3.u1) annotation(
    Line(points = {{0, 51}, {0, 6}, {18, 6}}, color = {0, 0, 127}));
  connect(firstOrder2.y, gain4.u) annotation(
    Line(points = {{299, -60}, {41, -60}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain4.y, feedback1.u2) annotation(
    Line(points = {{19, -60}, {-53, -60}}, color = {0, 0, 127}));
  connect(gain2.y, feedback1.u1) annotation(
    Line(points = {{-79, -140}, {-60, -140}, {-60, -68}}, color = {0, 0, 127}));
  connect(feedback1.y, max3.u2) annotation(
    Line(points = {{-60, -51}, {-60, -26}, {-42, -26}}, color = {0, 0, 127}));
  connect(gain.y, max3.u1) annotation(
    Line(points = {{-79, 0}, {-60, 0}, {-60, -14}, {-43, -14}}, color = {0, 0, 127}));
  connect(max3.y, min3.u2) annotation(
    Line(points = {{-19, -20}, {0, -20}, {0, -6}, {17, -6}}, color = {0, 0, 127}));
  connect(min3.y, transferFunction1.u) annotation(
    Line(points = {{41, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(transferFunction1.y, feedback2.u1) annotation(
    Line(points = {{81, 0}, {111, 0}}, color = {0, 0, 127}));
  connect(feedback2.y, max2.u[1]) annotation(
    Line(points = {{129, 0}, {159, 0}}, color = {0, 0, 127}));
  connect(limiter.y, VFbPu) annotation(
    Line(points = {{-198, 0}, {-180, 0}, {-180, 60}, {-210, 60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-380, -180}, {360, 180}})));
end BaseSt7;
