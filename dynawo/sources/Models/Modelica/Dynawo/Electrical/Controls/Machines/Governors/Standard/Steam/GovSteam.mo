within Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam;

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

model GovSteam "Speed governor and steam turbine"
  parameter Types.PerUnit dZMaxPu "Control valves rate opening limit in pu/s";
  parameter Types.PerUnit dZMinPu "Control valves rate closing limit in pu/s";
  parameter Types.PerUnit FHp "Turbine output gain for high pressure part";
  parameter Types.PerUnit FMp "Turbine output gain for medium pressure part";
  parameter Types.PerUnit Ivo "Intercept valve opening, 1 (no effect) or 0 (only high pressure power partcipating to mechanical power)";
  parameter Types.ActivePower PNomTurb "Nominal turbine active power in MW";
  parameter Types.PerUnit Sigma "Droop";
  parameter Types.Time tHp "High pressure turbine time constant in s";
  parameter Types.Time tLp "Low pressure turbine time constant in s";
  parameter Types.Time tMeas "Measurement time constant in s";
  parameter Types.Time tR "Reheater time constant in s";
  parameter Types.Time tSm "Control valves servo time constant in s";
  parameter Types.PerUnit ZMaxPu "Maximum control valve position in pu (base PNomTurb)";
  parameter Types.PerUnit ZMinPu "Minimum control valve position in pu (base PNomTurb)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-232, 80}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency (base OmegaNom)"annotation(
    Placement(visible = true, transformation(origin = {-232, 40}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = Pm0Pu) "Reference power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {-233, 101}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {230, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / Sigma)  annotation(
    Placement(visible = true, transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tMeas)  annotation(
    Placement(visible = true, transformation(origin = {-50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = 1 / tSm) annotation(
    Placement(visible = true, transformation(origin = {50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedIntegrator limitedIntegrator(Y0 = Pm0Pu,YMax = ZMaxPu, YMin = ZMinPu)  annotation(
    Placement(visible = true, transformation(origin = {130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = dZMaxPu, uMin = dZMinPu)  annotation(
    Placement(visible = true, transformation(origin = {90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {20, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tHp, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tR, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tLp, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = FLp) annotation(
    Placement(visible = true, transformation(origin = {90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(nin = 3)  annotation(
    Placement(visible = true, transformation(origin = {150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = FMp) annotation(
    Placement(visible = true, transformation(origin = {90, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain4(k = FHp) annotation(
    Placement(visible = true, transformation(origin = {90, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = Ivo)  annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ActivePowerPu Pm0Pu "Start value of mechanical power in pu (base PNomTurb)";

  final parameter Types.PerUnit FLp = 1 - FHp - FMp "Turbine output gain for low pressure part";

equation
  connect(omegaPu, add.u1) annotation(
    Line(points = {{-232, 80}, {-160, 80}, {-160, 66}, {-142, 66}}, color = {0, 0, 127}));
  connect(add.y, gain.u) annotation(
    Line(points = {{-119, 60}, {-102, 60}}, color = {0, 0, 127}));
  connect(gain.y, firstOrder.u) annotation(
    Line(points = {{-79, 60}, {-63, 60}}, color = {0, 0, 127}));
  connect(firstOrder.y, add1.u2) annotation(
    Line(points = {{-39, 60}, {-33, 60}, {-33, 54}, {-23, 54}}, color = {0, 0, 127}));
  connect(PRefPu, add1.u1) annotation(
    Line(points = {{-233, 101}, {-29, 101}, {-29, 65}, {-23, 65}}, color = {0, 0, 127}));
  connect(gain1.y, limiter.u) annotation(
    Line(points = {{61, 60}, {78, 60}}, color = {0, 0, 127}));
  connect(limiter.y, limitedIntegrator.u) annotation(
    Line(points = {{101, 60}, {118, 60}}, color = {0, 0, 127}));
  connect(add1.y, feedback.u1) annotation(
    Line(points = {{1, 60}, {11, 60}}, color = {0, 0, 127}));
  connect(feedback.y, gain1.u) annotation(
    Line(points = {{29, 60}, {37, 60}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, feedback.u2) annotation(
    Line(points = {{142, 60}, {160, 60}, {160, 20}, {20, 20}, {20, 52}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, firstOrder1.u) annotation(
    Line(points = {{142, 60}, {180, 60}, {180, 0}, {-160, 0}, {-160, -20}, {-142, -20}}, color = {0, 0, 127}));
  connect(firstOrder1.y, firstOrder2.u) annotation(
    Line(points = {{-118, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(firstOrder2.y, product.u1) annotation(
    Line(points = {{-58, -20}, {-40, -20}, {-40, -14}, {-22, -14}}, color = {0, 0, 127}));
  connect(product.y, firstOrder3.u) annotation(
    Line(points = {{2, -20}, {38, -20}}, color = {0, 0, 127}));
  connect(firstOrder3.y, gain2.u) annotation(
    Line(points = {{62, -20}, {78, -20}}, color = {0, 0, 127}));
  connect(gain2.y, sum1.u[1]) annotation(
    Line(points = {{102, -20}, {120, -20}, {120, -60}, {138, -60}}, color = {0, 0, 127}));
  connect(gain3.y, sum1.u[2]) annotation(
    Line(points = {{101, -60}, {138, -60}}, color = {0, 0, 127}));
  connect(product.y, gain3.u) annotation(
    Line(points = {{2, -20}, {20, -20}, {20, -60}, {78, -60}}, color = {0, 0, 127}));
  connect(firstOrder1.y, gain4.u) annotation(
    Line(points = {{-118, -20}, {-100, -20}, {-100, -100}, {78, -100}}, color = {0, 0, 127}));
  connect(gain4.y, sum1.u[3]) annotation(
    Line(points = {{101, -100}, {120, -100}, {120, -60}, {138, -60}}, color = {0, 0, 127}));
  connect(sum1.y, PmPu) annotation(
    Line(points = {{162, -60}, {230, -60}}, color = {0, 0, 127}));
  connect(const.y, product.u2) annotation(
    Line(points = {{-59, -60}, {-40, -60}, {-40, -26}, {-22, -26}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u2) annotation(
    Line(points = {{-232, 40}, {-160, 40}, {-160, 54}, {-142, 54}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-220, -160}, {220, 160}}), graphics = {Rectangle(origin = {89, 50}, lineColor = {92, 53, 102}, pattern = LinePattern.Dash, lineThickness = 1, extent = {{-81, 38}, {81, -38}}), Text(origin = {95, 28}, lineColor = {92, 53, 102}, extent = {{-43, 4}, {43, -4}}, textString = "Control valve opening"), Text(origin = {-129, -40}, extent = {{-25, 6}, {25, -6}}, textString = "High pressure stage"), Text(origin = {-60, -39}, extent = {{-38, 5}, {38, -5}}, textString = "Reheater & medium pressure stage"), Text(origin = {-61, -82}, extent = {{-29, 2}, {29, -2}}, textString = "Intercept valve opening"), Text(origin = {49, -40}, extent = {{-25, 6}, {25, -6}}, textString = "Low pressure stage"), Text(origin = {116, -13}, extent = {{-20, 3}, {20, -3}}, textString = "PmLp"), Text(origin = {114, -95}, extent = {{-20, 3}, {20, -3}}, textString = "PmHp"), Text(origin = {114, -55}, extent = {{-20, 3}, {20, -3}}, textString = "PmMp")}),
    Icon(graphics = {Text(origin = {-164, 62}, extent = {{-18, 6}, {18, -6}}, textString = "PRefPu"), Text(origin = {-170, -60}, extent = {{-18, 6}, {18, -6}}, textString = "omegaPu"), Text(origin = {-169, -1}, extent = {{-21, 7}, {21, -7}}, textString = "omegaRefPu"), Text(origin = {146, 0}, extent = {{-18, 6}, {18, -6}}, textString = "PmPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {1, 0}, extent = {{-59, 24}, {59, -24}}, textString = "Steam governor")}));
end GovSteam;
