within Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam;

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

model TGov3 "IEEE governor type TGOV3"

  //Regulation parameters
  parameter Types.PerUnit K "Governor gain (reciprocal of droop)";
  parameter Types.PerUnit K1 "Fraction of HP shaft power after first boiler pass";
  parameter Types.PerUnit K2 "Fraction of LP shaft power after first boiler pass";
  parameter Types.PerUnit K3 "Fraction of HP shaft power after second boiler pass";
  parameter Types.ActivePowerPu PMaxPu "Maximum valve opening in pu (base PNomTurb)";
  parameter Types.ActivePowerPu PMinPu "Minimum valve opening in pu (base PNomTurb)";
  parameter Types.ActivePowerPu PrMaxPu "Maximum pressure in reheater in pu (base PNomTurb)";
  parameter Types.Time t1 "Governor lag time constant in s";
  parameter Types.Time t2 "Governor lead time constant in s";
  parameter Types.Time t3 "Valve positioner time constant in s";
  parameter Types.Time t4 "Inlet piping / steam bowl time constant in s";
  parameter Types.Time t5 "Time constant of second boiler pass (reheater) in s";
  parameter Types.Time t6 "Time constant of crossover of third boiler pass in s";
  parameter Types.Time tA "Time to close intercept valve in s";
  parameter Types.Time tB "Time until intercept valve starts to reopen in s";
  parameter Types.Time tC "Time until intercept valve is fully open in s";
  parameter Types.PerUnit Uc "Maximum valve closing velocity in pu/s (base PNomTurb)";
  parameter Types.PerUnit Uo "Maximum valve opening velocity in pu/s (base PNomTurb)";

  //Table parameters
  parameter String FValveTableName "Name of table in text file for flow rate as a function of pressure";
  parameter String TablesFile "Text file that contains the table for the function";

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput fastValving(start = false) "If true, fast valving is initiated" annotation(
    Placement(visible = true, transformation(origin = {-420, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-114, 80}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-420, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-114, -40}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-420, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-114, -80}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) "Reference mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {-420, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-114, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {390, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {t1, 1}, b = {t2, 1}) annotation(
    Placement(visible = true, transformation(origin = {-310, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-350, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -K) annotation(
    Placement(visible = true, transformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / t3) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = Uo, uMin = Uc) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = t4, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = 1 / t5, outMax = PrMaxPu, outMin = -999, y_start = Pr0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = K1, k2 = K2, k3 = K3) annotation(
    Placement(visible = true, transformation(origin = {350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(fileName = TablesFile, tableName = FValveTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {230, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = t6, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {290, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {-70, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds1(table = [0, 1; tA, 0; tB, 0; tC, 1; 2 * tC, 1]) annotation(
    Placement(visible = true, transformation(origin = {-30, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {190, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameter
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNomTurb)";

  //Initial parameter (calculated with the initialization model)
  parameter Types.ActivePowerPu Pr0Pu "Initial pressure in reheater in pu (base PNomTurb)";

equation
  connect(omegaPu, add.u1) annotation(
    Line(points = {{-420, -40}, {-380, -40}, {-380, -54}, {-362, -54}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u2) annotation(
    Line(points = {{-420, -80}, {-380, -80}, {-380, -66}, {-362, -66}}, color = {0, 0, 127}));
  connect(add.y, transferFunction.u) annotation(
    Line(points = {{-339, -60}, {-323, -60}}, color = {0, 0, 127}));
  connect(PmRefPu, add1.u1) annotation(
    Line(points = {{-420, 40}, {-280, 40}, {-280, 6}, {-262, 6}}, color = {0, 0, 127}));
  connect(transferFunction.y, add1.u2) annotation(
    Line(points = {{-299, -60}, {-280, -60}, {-280, -6}, {-263, -6}}, color = {0, 0, 127}));
  connect(add1.y, feedback.u1) annotation(
    Line(points = {{-239, 0}, {-209, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-191, 0}, {-163, 0}}, color = {0, 0, 127}));
  connect(gain.y, limiter.u) annotation(
    Line(points = {{-139, 0}, {-123, 0}}, color = {0, 0, 127}));
  connect(limiter.y, integrator.u) annotation(
    Line(points = {{-99, 0}, {-83, 0}}, color = {0, 0, 127}));
  connect(integrator.y, limiter1.u) annotation(
    Line(points = {{-59, 0}, {-43, 0}}, color = {0, 0, 127}));
  connect(limiter1.y, firstOrder.u) annotation(
    Line(points = {{-19, 0}, {17, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, feedback1.u1) annotation(
    Line(points = {{41, 0}, {71, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, limIntegrator.u) annotation(
    Line(points = {{89, 0}, {117, 0}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], firstOrder1.u) annotation(
    Line(points = {{241, 40}, {260, 40}, {260, -40}, {278, -40}}, color = {0, 0, 127}));
  connect(add3.y, PmPu) annotation(
    Line(points = {{361, 0}, {390, 0}, {390, -1}}, color = {0, 0, 127}));
  connect(firstOrder.y, add3.u1) annotation(
    Line(points = {{41, 0}, {60, 0}, {60, 80}, {320, 80}, {320, 8}, {338, 8}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], feedback1.u2) annotation(
    Line(points = {{241, 40}, {260, 40}, {260, -40}, {80, -40}, {80, -8}}, color = {0, 0, 127}));
  connect(limiter1.y, feedback.u2) annotation(
    Line(points = {{-19, 0}, {0, 0}, {0, -40}, {-200, -40}, {-200, -8}}, color = {0, 0, 127}));
  connect(product.y, combiTable1Ds.u) annotation(
    Line(points = {{201, 40}, {217, 40}}, color = {0, 0, 127}));
  connect(fastValving, timer.u) annotation(
    Line(points = {{-420, 120}, {-82, 120}}, color = {255, 0, 255}));
  connect(timer.y, combiTable1Ds1.u) annotation(
    Line(points = {{-58, 120}, {-42, 120}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], product.u1) annotation(
    Line(points = {{-18, 120}, {160, 120}, {160, 46}, {178, 46}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(limIntegrator.y, product.u2) annotation(
    Line(points = {{142, 0}, {160, 0}, {160, 34}, {178, 34}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], add3.u2) annotation(
    Line(points = {{242, 40}, {260, 40}, {260, 0}, {338, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, add3.u3) annotation(
    Line(points = {{302, -40}, {320, -40}, {320, -8}, {338, -8}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-400, -180}, {380, 180}})));
end TGov3;
