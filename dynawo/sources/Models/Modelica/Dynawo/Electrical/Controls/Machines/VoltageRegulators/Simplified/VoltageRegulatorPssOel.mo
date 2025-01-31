within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified;

model VoltageRegulatorPssOel "Voltage regulator with excitation system and overexcitation limiter"
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
  parameter Types.PerUnit C;
  parameter Types.PerUnit EfdMinPu;
  parameter Types.PerUnit EfdMaxPu;
  parameter Types.PerUnit G;
  parameter Types.PerUnit ifLim1;
  parameter Types.PerUnit ifLim2;
  parameter Types.PerUnit KPss;
  parameter Types.PerUnit KOel;
  parameter Types.PerUnit L1;
  parameter Types.PerUnit L2;
  parameter Types.PerUnit L3;
  parameter Types.Time t1;
  parameter Types.Time t2;
  parameter Types.Time t3;
  parameter Types.Time t4;
  parameter Types.Time tA;
  parameter Types.Time tB;
  parameter Types.Time tE;
  parameter Types.Time tOel;
  parameter Types.Time tOmega;
  // Input variables
  Modelica.Blocks.Interfaces.RealInput ifPu(start = If0Pu) annotation(
    Placement(visible = true, transformation(origin = {-300, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-300, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-300, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-230, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) annotation(
    Placement(transformation(origin = {-300, -30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-230, 0}, extent = {{-20, -20}, {20, 20}})));
  // Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {290, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {226, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, limitsAtInit = true, uMax = C) annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-250, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = ifLim1) annotation(
    Placement(visible = true, transformation(origin = {-290, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = ifLim2) annotation(
    Placement(visible = true, transformation(origin = {-250, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {-190, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator1(k = 1/tOel, outMax = L2, outMin = L1, y_start = L1) annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = KOel) annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, limitsAtInit = true, uMax = L3, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Real dvpss;
  //Modelica.Blocks.Sources.Constant constant3(k = UsRef0Pu) annotation(
  // Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Initial parameter
  parameter Types.PerUnit Efd0Pu;
  parameter Types.PerUnit If0Pu;
  parameter Types.PerUnit Us0Pu;
  final parameter Types.VoltageModulePu UsRef0Pu = Efd0Pu / G + Us0Pu;
equation
  dvpss = limiter.y;
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
//connect(constant3.y, sum1.u[3]) annotation(
//  Line(points = {{-118, -40}, {-40, -40}, {-40, 0}, {-2, 0}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-280, -140}, {280, 140}})),
    Icon);
end VoltageRegulatorPssOel;
