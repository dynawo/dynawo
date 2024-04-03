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

model IEEEG1 "Steam turbine governor"

  //Regulation parameters
  parameter Types.PerUnit K "Governor gain (reciprocal of droop)";
  parameter Types.PerUnit K1 "Fraction of HP shaft power after first boiler pass";
  parameter Types.PerUnit K2 "Fraction of LP shaft power after first boiler pass";
  parameter Types.PerUnit K3 "Fraction of HP shaft power after second boiler pass";
  parameter Types.PerUnit K4 "Fraction of LP shaft power after second boiler pass";
  parameter Types.PerUnit K5 "Fraction of HP shaft power after third boiler pass";
  parameter Types.PerUnit K6 "Fraction of LP shaft power after third boiler pass";
  parameter Types.PerUnit K7 "Fraction of HP shaft power after fourth boiler pass";
  parameter Types.PerUnit K8 "Fraction of LP shaft power after fourth boiler pass";
  parameter Types.ActivePowerPu PMaxPu "Power output of boiler at maximum valve opening in pu (base PNomTurb)";
  parameter Types.ActivePowerPu PMinPu "Power output of boiler at minimum valve opening in pu (base PNomTurb)";
  parameter Types.Time t1 "Governor lag time constant in s";
  parameter Types.Time t2 "Governor lead time constant in s";
  parameter Types.Time t3 "Valve positioner time constant in s";
  parameter Types.Time t4 "HP bowl time constant in s";
  parameter Types.Time t5 "Reheater time constant in s";
  parameter Types.Time t6 "Crossover time constant in s";
  parameter Types.Time t7 "Double reheat time constant in s";
  parameter Types.PerUnit Uc "Maximum valve closing velocity in pu/s (base PNomTurb)";
  parameter Types.PerUnit Uo "Maximum valve opening velocity in pu/s (base PNomTurb)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = PmRef0Pu) "Reference mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {-340, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput Pm1Pu(start = (K1 + K3 + K5 + K7) * PmRef0Pu) "Mechanical power of HP turbine in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {350, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Pm2Pu(start = (K2 + K4 + K6 + K8) * PmRef0Pu) "Mechanical power of LP turbine in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {350, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power of HP turbine in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = t4, y_start = PmRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = t5, y_start = PmRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = t6, y_start = PmRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / t3) annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limitedIntegrator(outMax = PMaxPu, outMin = PMinPu, y_start = PmRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = Uo, uMin = Uc) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = t7, y_start = PmRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {t1, 1}, b = {t2, 1}) annotation(
    Placement(visible = true, transformation(origin = {-230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(k = {K1, K3, K5, K7}, nin = 4) annotation(
    Placement(visible = true, transformation(origin = {250, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum2(k = {K2, K4, K6, K8}, nin = 4) annotation(
    Placement(visible = true, transformation(origin = {250, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {310, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k2 = -K, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameter
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNomTurb)";

  final parameter Types.ActivePowerPu PmRef0Pu = Pm0Pu / (K1 + K2 + K3 + K4 + K5 + K6 + K7 + K8) "Initial reference mechanical power in pu (base PNomTurb)";

equation
  connect(limiter.y, limitedIntegrator.u) annotation(
    Line(points = {{-79, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, firstOrder1.u) annotation(
    Line(points = {{21, 0}, {57, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, firstOrder2.u) annotation(
    Line(points = {{81, 0}, {117, 0}}, color = {0, 0, 127}));
  connect(gain.y, limiter.u) annotation(
    Line(points = {{-119, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(firstOrder2.y, firstOrder3.u) annotation(
    Line(points = {{141, 0}, {178, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum1.u[1]) annotation(
    Line(points = {{21, 0}, {40, 0}, {40, 100}, {237, 100}}, color = {0, 0, 127}));
  connect(firstOrder1.y, sum1.u[2]) annotation(
    Line(points = {{81, 0}, {100, 0}, {100, 100}, {237, 100}}, color = {0, 0, 127}));
  connect(firstOrder2.y, sum1.u[3]) annotation(
    Line(points = {{141, 0}, {160, 0}, {160, 100}, {237, 100}}, color = {0, 0, 127}));
  connect(firstOrder3.y, sum1.u[4]) annotation(
    Line(points = {{201, 0}, {220, 0}, {220, 100}, {238, 100}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum2.u[1]) annotation(
    Line(points = {{21, 0}, {40, 0}, {40, -100}, {237, -100}}, color = {0, 0, 127}));
  connect(firstOrder1.y, sum2.u[2]) annotation(
    Line(points = {{81, 0}, {100, 0}, {100, -100}, {237, -100}}, color = {0, 0, 127}));
  connect(firstOrder2.y, sum2.u[3]) annotation(
    Line(points = {{141, 0}, {160, 0}, {160, -100}, {237, -100}}, color = {0, 0, 127}));
  connect(firstOrder3.y, sum2.u[4]) annotation(
    Line(points = {{201, 0}, {220, 0}, {220, -100}, {237, -100}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, firstOrder.u) annotation(
    Line(points = {{-39, 0}, {-3, 0}}, color = {0, 0, 127}));
  connect(omegaPu, add.u1) annotation(
    Line(points = {{-340, 20}, {-300, 20}, {-300, 6}, {-282, 6}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u2) annotation(
    Line(points = {{-340, -20}, {-300, -20}, {-300, -6}, {-282, -6}}, color = {0, 0, 127}));
  connect(add.y, transferFunction.u) annotation(
    Line(points = {{-259, 0}, {-243, 0}}, color = {0, 0, 127}));
  connect(sum1.y, add1.u1) annotation(
    Line(points = {{261, 100}, {280, 100}, {280, 6}, {297, 6}}, color = {0, 0, 127}));
  connect(sum2.y, add1.u2) annotation(
    Line(points = {{261, -100}, {280, -100}, {280, -6}, {297, -6}}, color = {0, 0, 127}));
  connect(add1.y, PmPu) annotation(
    Line(points = {{321, 0}, {349, 0}}, color = {0, 0, 127}));
  connect(sum1.y, Pm1Pu) annotation(
    Line(points = {{261, 100}, {349, 100}}, color = {0, 0, 127}));
  connect(sum2.y, Pm2Pu) annotation(
    Line(points = {{261, -100}, {349, -100}}, color = {0, 0, 127}));
  connect(transferFunction.y, add3.u2) annotation(
    Line(points = {{-219, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(PmRefPu, add3.u1) annotation(
    Line(points = {{-340, 100}, {-200, 100}, {-200, 8}, {-182, 8}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, add3.u3) annotation(
    Line(points = {{-39, 0}, {-20, 0}, {-20, -40}, {-200, -40}, {-200, -8}, {-183, -8}}, color = {0, 0, 127}));
  connect(add3.y, gain.u) annotation(
    Line(points = {{-159, 0}, {-143, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-320, -160}, {340, 160}})));
end IEEEG1;
