within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

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

model BbSex1 "Model of exciter BBSEX1"

  //Regulation parameters
  parameter Types.VoltageModulePu EfdMaxPu "Maximum excitation voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfdMinPu "Minimum excitation voltage in pu (user-selected base voltage)";
  parameter Types.PerUnit K "Voltage regulator gain";
  parameter Types.Time t1 "Voltage regulator first time constant in s";
  parameter Types.Time t2 "Voltage regulator second time constant in s";
  parameter Types.Time t3 "Voltage regulator lead time constant in s";
  parameter Types.Time t4 "Voltage regulator lag time constant in s";
  parameter Types.Time tR "Stator voltage filter time constant in s";
  parameter Types.VoltageModulePu VrMaxPu "Maximum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum output voltage of voltage regulator in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = 0) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = 0) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Sum sum1(k = {1, 1, 1, 1, -1}, nin = 5) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction(a = {t4 , 1}, b = {t3 , 1}, initType = Modelica.Blocks.Types.Init.SteadyState, u_start = Efd0Pu / K) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k =  t2 / t1) annotation(
    Placement(visible = true, transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = VrMaxPu, uMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = K) annotation(
    Placement(visible = true, transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = t1 / t2 - 1) annotation(
    Placement(visible = true, transformation(origin = {50, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = t2, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = EfdMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-90, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain4(k = EfdMinPu) annotation(
    Placement(visible = true, transformation(origin = {-90, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-170, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu UsRef0Pu = Us0Pu + Efd0Pu / K "Initial reference stator voltage in pu (base UNom)";

equation
  connect(UOelPu, sum1.u[1]) annotation(
    Line(points = {{-220, 80}, {-140, 80}, {-140, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(UUelPu, sum1.u[2]) annotation(
    Line(points = {{-220, 40}, {-140, 40}, {-140, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[3]) annotation(
    Line(points = {{-220, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(UsRefPu, sum1.u[4]) annotation(
    Line(points = {{-220, -40}, {-140, -40}, {-140, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, sum1.u[5]) annotation(
    Line(points = {{-160, -80}, {-140, -80}, {-140, 0}, {-102, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(sum1.y, transferFunction.u) annotation(
    Line(points = {{-79, 0}, {-63, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, gain2.u) annotation(
    Line(points = {{79, -60}, {61, -60}}, color = {0, 0, 127}));
  connect(add.y, gain1.u) annotation(
    Line(points = {{21, -20}, {37, -20}}, color = {0, 0, 127}));
  connect(gain1.y, limiter.u) annotation(
    Line(points = {{61, -20}, {77, -20}}, color = {0, 0, 127}));
  connect(limiter.y, firstOrder.u) annotation(
    Line(points = {{101, -20}, {120, -20}, {120, -60}, {101, -60}}, color = {0, 0, 127}));
  connect(transferFunction.y, add.u1) annotation(
    Line(points = {{-39, 0}, {-20, 0}, {-20, -14}, {-3, -14}}, color = {0, 0, 127}));
  connect(firstOrder1.y, gain3.u) annotation(
    Line(points = {{-160, -80}, {-120, -80}, {-120, 80}, {-102, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(firstOrder1.y, gain4.u) annotation(
    Line(points = {{-160, -80}, {-102, -80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain3.y, variableLimiter.limit1) annotation(
    Line(points = {{-79, 80}, {140, 80}, {140, 8}, {157, 8}}, color = {0, 0, 127}));
  connect(gain4.y, variableLimiter.limit2) annotation(
    Line(points = {{-79, -80}, {140, -80}, {140, -8}, {157, -8}}, color = {0, 0, 127}));
  connect(limiter.y, variableLimiter.u) annotation(
    Line(points = {{101, -20}, {120, -20}, {120, 0}, {157, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, EfdPu) annotation(
    Line(points = {{181, 0}, {209, 0}}, color = {0, 0, 127}));
  connect(gain2.y, add.u2) annotation(
    Line(points = {{39, -60}, {-20, -60}, {-20, -26}, {-3, -26}}, color = {0, 0, 127}));
  connect(UsPu, firstOrder1.u) annotation(
    Line(points = {{-220, -80}, {-182, -80}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end BbSex1;
