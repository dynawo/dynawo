within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model VoltageRegulatorPssOel "Voltage regulator with power system stabilizer and overexcitation limiter"

  parameter Types.VoltageModulePu EfdMinPu "Minimum exciter field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfdMaxPu "Maximum exciter field voltage in pu (user-selected base voltage)";
  parameter Types.PerUnit G "Voltage regulator gain";
  parameter Types.PerUnit ifLim1Pu "First excitation field current limit in pu (base SNom, user-selected base voltage)";
  parameter Types.PerUnit ifLim2Pu "Second excitation field current limit in pu (base SNom, user-selected base voltage)";
  parameter Types.PerUnit KPss "Power system stabilizer gain";
  parameter Types.PerUnit KOel "Over-excitation limiter gain";
  parameter Types.Time t1 "First lead time constant of PSS in s";
  parameter Types.Time t2 "First lag time constant of PSS in s";
  parameter Types.Time t3 "Second lead time constant of PSS in s";
  parameter Types.Time t4 "Second lag time constant of PSS in s";
  parameter Types.Time tA "Lead time constant of exciter first order";
  parameter Types.Time tB "Lag time constant of exciter first order";
  parameter Types.Time tE "Time constant of exciter in s";
  parameter Types.Time tOel "OEL integral time constant in s";
  parameter Types.Time tOmega "PSS washout time constant in s";
  parameter Types.VoltageModulePu VOel1MaxPu "OEL integrator maximum output in pu (base UNom)";
  parameter Types.VoltageModulePu VOel1MinPu "OEL integrator minimum output in pu (base UNom)";
  parameter Types.VoltageModulePu VOel2MaxPu "OEL maximum output in pu (base UNom)";
  parameter Types.VoltageModulePu VPssMaxPu "Maximum voltage output of power system stabilizer in pu (base UNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput ifPu(start = If0Pu) "Excitation field current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-300, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu( base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)"annotation(
    Placement(visible = true,transformation(origin = {-300, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation field voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {290, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction(a = {tB, 1}, b = {tA, 1}, x_start = {Efd0Pu}, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = G) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = 1/tE) annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(outMax = EfdMaxPu, outMin = EfdMinPu, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(k = {1, -1, 1, -1}, nin = 4) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = tOmega, k = KPss) annotation(
    Placement(visible = true, transformation(origin = {-230, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction1(a = {t2, 1}, b = {t1, 1}) annotation(
    Placement(visible = true, transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction2(a = {t4, 1}, b = {t3, 1}) annotation(
    Placement(visible = true, transformation(origin = {-150, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, limitsAtInit = true, uMax = VPssMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-250, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = ifLim1Pu) annotation(
    Placement(visible = true, transformation(origin = {-290, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = ifLim2Pu) annotation(
    Placement(visible = true, transformation(origin = {-250, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {-190, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator1(k = 1/tOel, outMax = VOel1MaxPu, outMin = VOel1MinPu, y_start = VOel1MinPu) annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = KOel) annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, limitsAtInit = true, uMax = VOel2MaxPu, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameter
  parameter Types.VoltageModulePu Efd0Pu "Start value of excitation field voltage in pu (user-selected base voltage)";
  parameter Types.PerUnit If0Pu "Start value of excitation field current in pu (base SNom, user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Start value of stator voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu UsRef0Pu = Efd0Pu / G + Us0Pu "Start value of reference stator voltage in pu (base UNom)";

equation
  connect(gain.y, transferFunction.u) annotation(
    Line(points = {{81, 0}, {97, 0}}, color = {0, 0, 127}));
  connect(transferFunction.y, feedback.u1) annotation(
    Line(points = {{121, 0}, {132, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain1.u) annotation(
    Line(points = {{149, 0}, {157, 0}}, color = {0, 0, 127}));
  connect(gain1.y, limIntegrator.u) annotation(
    Line(points = {{181, 0}, {197, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, EfdPu) annotation(
    Line(points = {{221, 0}, {290, 0}}, color = {0, 0, 127}));
  connect(gain.u, sum1.y) annotation(
    Line(points = {{58, 0}, {21, 0}}, color = {0, 0, 127}));
  connect(omegaPu, derivative.u) annotation(
    Line(points = {{-300, 60}, {-242, 60}}, color = {0, 0, 127}));
  connect(derivative.y, transferFunction1.u) annotation(
    Line(points = {{-219, 60}, {-203, 60}}, color = {0, 0, 127}));
  connect(transferFunction1.y, transferFunction2.u) annotation(
    Line(points = {{-179, 60}, {-163, 60}}, color = {0, 0, 127}));
  connect(transferFunction2.y, limiter.u) annotation(
    Line(points = {{-139, 60}, {-123, 60}}, color = {0, 0, 127}));
  connect(limiter.y, sum1.u[1]) annotation(
    Line(points = {{-99, 60}, {-40, 60}, {-40, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(UsPu, sum1.u[2]) annotation(
    Line(points = {{-300, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(constant2.y, add.u2) annotation(
    Line(points = {{-279, -120}, {-269.5, -120}, {-269.5, -106}, {-262, -106}}, color = {0, 0, 127}));
  connect(constant1.y, min.u1) annotation(
    Line(points = {{-239, -50}, {-221, -50}, {-221, -74}, {-203, -74}}, color = {0, 0, 127}));
  connect(add.y, min.u2) annotation(
    Line(points = {{-239, -100}, {-221, -100}, {-221, -86}, {-203, -86}}, color = {0, 0, 127}));
  connect(min.y, limIntegrator1.u) annotation(
    Line(points = {{-179, -80}, {-163, -80}}, color = {0, 0, 127}));
  connect(limIntegrator1.y, gain2.u) annotation(
    Line(points = {{-138, -80}, {-122, -80}}, color = {0, 0, 127}));
  connect(gain2.y, limiter1.u) annotation(
    Line(points = {{-98, -80}, {-82, -80}}, color = {0, 0, 127}));
  connect(limiter1.y, sum1.u[4]) annotation(
    Line(points = {{-58, -80}, {-40, -80}, {-40, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, feedback.u2) annotation(
    Line(points = {{222, 0}, {240, 0}, {240, -40}, {140, -40}, {140, -8}}, color = {0, 0, 127}));
  connect(ifPu, add.u1) annotation(
    Line(points = {{-300, -80}, {-272, -80}, {-272, -94}, {-262, -94}}, color = {0, 0, 127}));
  connect(UsRefPu, sum1.u[3]) annotation(
    Line(points = {{-300, -30}, {-40, -30}, {-40, 0}, {-2, 0}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-280, -140}, {280, 140}}), graphics = {Rectangle(origin = {-163, 69}, lineColor = {92, 53, 102}, pattern = LinePattern.Dash, lineThickness = 1, extent = {{-109, 49}, {109, -49}}), Text(origin = {-157, 105}, lineColor = {92, 53, 102}, extent = {{-57, 5}, {57, -5}}, textString = "Power System Stabilizer (PSS)"), Rectangle(origin = {-163, -81}, lineColor = {143, 89, 2}, pattern = LinePattern.Dash, lineThickness = 1, extent = {{-109, 49}, {109, -49}}), Text(origin = {-163, -117}, lineColor = {143, 89, 2}, extent = {{-57, 5}, {57, -5}}, textString = "Over Excitation Limiter (OEL)"), Rectangle(origin = {191, -13}, lineColor = {32, 74, 135}, pattern = LinePattern.Dash, lineThickness = 1, extent = {{-65, 51}, {65, -51}}), Text(origin = {193, -55}, lineColor = {32, 74, 135}, extent = {{-57, 5}, {57, -5}}, textString = "Exciter")}),
    Icon(graphics = {Text(origin = {-184, 63}, extent = {{-34, 7}, {34, -7}}, textString = "omegaPu"), Text(origin = {-182, 25}, extent = {{-34, 7}, {34, -7}}, textString = "UsPu"), Text(origin = {-182, -23}, extent = {{-34, 7}, {34, -7}}, textString = "UsRefPu"), Text(origin = {-184, -61}, extent = {{-34, 7}, {34, -7}}, textString = "ifPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-4, 2}, extent = {{-84, 74}, {84, -74}}, textString = "Voltage Regulator with PSS and OEL")}));
end VoltageRegulatorPssOel;
