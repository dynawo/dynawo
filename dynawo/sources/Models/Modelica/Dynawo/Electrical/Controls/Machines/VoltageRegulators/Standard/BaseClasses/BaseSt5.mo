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

partial model BaseSt5 "IEEE excitation system type ST5 base model"

  //Regulation parameters
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Kr "Gain of voltage after overexcitation and underexcitation limitations";
  parameter Types.Time t1 "Inverse timing current constant in s";
  parameter Types.Time tB1 "Second lag time constant in s";
  parameter Types.Time tB2 "First lag time constant in s";
  parameter Types.Time tC1 "Second lead time constant in s";
  parameter Types.Time tC2 "First lead time constant in s";
  parameter Types.Time tOB1 "Second lag time constant (overexcitation limitation) in s";
  parameter Types.Time tOB2 "First lag time constant (overexcitation limitation) in s";
  parameter Types.Time tOC1 "Second lead time constant (overexcitation limitation) in s";
  parameter Types.Time tOC2 "First lead time constant (overexcitation limitation) in s";
  parameter Types.Time tR "Stator voltage filter time constant in s";
  parameter Types.Time tUB1 "Second lag time constant (underexcitation limitation) in s";
  parameter Types.Time tUB2 "First lag time constant (underexcitation limitation) in s";
  parameter Types.Time tUC1 "Second lead time constant (underexcitation limitation) in s";
  parameter Types.Time tUC2 "First lead time constant (underexcitation limitation) in s";
  parameter Types.VoltageModulePu VrMaxPu "Maximum field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum field voltage in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-380, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = UUel0Pu) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {370, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-310, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction(a = {tB2, 1}, b = {tC2, 1}, x_start = {Vr0Pu}, y_start = Vr0Pu) annotation(
    Placement(visible = true, transformation(origin = {70, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {170, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {220, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {330, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = VrMaxPu) annotation(
    Placement(visible = true, transformation(origin = {270, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {270, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinMaxDynawo3 max1 annotation(
    Placement(visible = true, transformation(origin = {-150, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinMaxDynawo3 min1 annotation(
    Placement(visible = true, transformation(origin = {-90, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-250, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = t1, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = VrMaxPu, uMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain6(k = Kr) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag(t1 = tC1, t2 = tB1, Y0 = Vr0Pu, YMax = VrMaxPu, YMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag1(t1 = tUC1, t2 = tUB1, Y0 = Vr0Pu, YMax = VrMaxPu, YMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction1(a = {tUB2, 1}, b = {tUC2, 1}, x_start = {Vr0Pu}, y_start = Vr0Pu) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction2(a = {tOB2, 1}, b = {tOC2, 1}, x_start = {Vr0Pu}, y_start = Vr0Pu) annotation(
    Placement(visible = true, transformation(origin = {70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag2(t1 = tOC1, t2 = tOB1, Y0 = Vr0Pu, YMax = VrMaxPu, YMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu UOel0Pu = 0 "Overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UUel0Pu = 0 "Underexcitation limitation initial output voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu UsRef0Pu = Us0Pu + Vr0Pu / Kr "Initial reference stator voltage in pu (base UNom)";
  final parameter Types.VoltageModulePu Vr0Pu = Efd0Pu + Kc * Ir0Pu "Initial field voltage in pu (user-selected base voltage)";

equation
  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-380, -40}, {-322, -40}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain.y, feedback1.u2) annotation(
    Line(points = {{181, 160}, {220, 160}, {220, 8}}, color = {0, 0, 127}));
  connect(UsPu, gain2.u) annotation(
    Line(points = {{-380, -40}, {-340, -40}, {-340, -120}, {258, -120}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(UsPu, gain1.u) annotation(
    Line(points = {{-380, -40}, {-340, -40}, {-340, 120}, {258, 120}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain2.y, variableLimiter.limit2) annotation(
    Line(points = {{281, -120}, {300, -120}, {300, -8}, {318, -8}}, color = {0, 0, 127}));
  connect(variableLimiter.y, EfdPu) annotation(
    Line(points = {{341, 0}, {370, 0}}, color = {0, 0, 127}));
  connect(max1.yMax, min1.u[1]) annotation(
    Line(points = {{-139, -14}, {-100, -14}}, color = {0, 0, 127}));
  connect(UsRefPu, add3.u1) annotation(
    Line(points = {{-380, 0}, {-280, 0}, {-280, -14}, {-262, -14}}, color = {0, 0, 127}));
  connect(firstOrder.y, add3.u2) annotation(
    Line(points = {{-299, -40}, {-280, -40}, {-280, -26}, {-263, -26}}, color = {0, 0, 127}));
  connect(UPssPu, add1.u1) annotation(
    Line(points = {{-380, 40}, {-60, 40}, {-60, 6}, {-42, 6}}, color = {0, 0, 127}));
  connect(min1.yMin, add1.u2) annotation(
    Line(points = {{-79, -20}, {-60, -20}, {-60, -6}, {-42, -6}}, color = {0, 0, 127}));
  connect(limiter.y, feedback1.u1) annotation(
    Line(points = {{181, 0}, {212, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, firstOrder1.u) annotation(
    Line(points = {{229, 0}, {258, 0}}, color = {0, 0, 127}));
  connect(add1.y, gain6.u) annotation(
    Line(points = {{-19, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, variableLimiter.u) annotation(
    Line(points = {{281, 0}, {317, 0}}, color = {0, 0, 127}));
  connect(gain6.y, transferFunction.u) annotation(
    Line(points = {{21, 0}, {40, 0}, {40, 80}, {57, 80}}, color = {0, 0, 127}));
  connect(gain6.y, transferFunction1.u) annotation(
    Line(points = {{21, 0}, {57, 0}}, color = {0, 0, 127}));
  connect(gain6.y, transferFunction2.u) annotation(
    Line(points = {{21, 0}, {40, 0}, {40, -80}, {57, -80}}, color = {0, 0, 127}));
  connect(transferFunction.y, limitedLeadLag.u) annotation(
    Line(points = {{81, 80}, {97, 80}}, color = {0, 0, 127}));
  connect(transferFunction1.y, limitedLeadLag1.u) annotation(
    Line(points = {{81, 0}, {97, 0}}, color = {0, 0, 127}));
  connect(transferFunction2.y, limitedLeadLag2.u) annotation(
    Line(points = {{81, -80}, {97, -80}}, color = {0, 0, 127}));
  connect(gain1.y, variableLimiter.limit1) annotation(
    Line(points = {{281, 120}, {300, 120}, {300, 8}, {318, 8}}, color = {0, 0, 127}));
  connect(IrPu, gain.u) annotation(
    Line(points = {{-380, 160}, {158, 160}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-360, -180}, {360, 180}})));
end BaseSt5;
