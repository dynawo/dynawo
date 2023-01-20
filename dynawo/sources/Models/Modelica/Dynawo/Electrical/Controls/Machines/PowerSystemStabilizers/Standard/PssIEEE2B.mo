within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard;

/*
* Copyright (c) 2022 RTE (http://www.rte-france.com) and UPC/Citcea (https://www.citcea.upc.edu/)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PssIEEE2B "IEEE Power System Stabilizer type 2B"
  import Modelica;
  import Dynawo;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;

  //Regulation parameters
  parameter Types.PerUnit Ks1 "Stabilizer gain. Typical value = 12";
  parameter Types.PerUnit Ks2 "Gain on signal #2. Typical value = 0.2";
  parameter Types.PerUnit Ks3 "Gain on signal #2 input before ramp-tracking filter. Typical value = 1";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.Time t1 "Lead time constant of first lead/lag in s (>= 0). Typical value = 0.12";
  parameter Types.Time t2 "Lag time constant of first lead/lag in s (>= 0). Typical value = 0.02";
  parameter Types.Time t3 "Lead time constant of second lead/lag in s (>= 0). Typical value = 0.3";
  parameter Types.Time t4 "Lag time constant of second lead/lag in s (>= 0). Typical value = 0.02";
  parameter Types.Time t6 "Time constant on signal #1 in s (>= 0). Typical value = 0";
  parameter Types.Time t7 "Time constant on signal #2 in s (>= 0). Typical value = 2";
  parameter Types.Time t8 "Lead time constant of ramp tracking filter in s (>= 0). Typical value = 0.2";
  parameter Types.Time t9 "Lag time constant of ramp tracking filter in s (>= 0). Typical value = 0.1";
  parameter Types.Time t10 "Lead time constant of third lead/lag in s (>= 0). Typical value = 0";
  parameter Types.Time t11 "Lag time constant of third lead/lag in s (>= 0). Typical value = 0";
  parameter Types.Time tw1 "First washout on signal #1 in s (>= 0). Typical value = 2";
  parameter Types.Time tw2 "Second washout on signal #1 in s (>= 0). Typical value = 2";
  parameter Types.Time tw3 "First washout on signal #2 in s (>= 0). Typical value = 2";
  parameter Types.Time tw4 "Second washout on signal #2 in s (>= 0). Typical value = 0";
  parameter Types.VoltageModulePu Vsi1MaxPu "Input signal #1 maximum limit in pu (base UNom) (> vsi1min). Typical value = 2";
  parameter Types.VoltageModulePu Vsi1MinPu "Input signal #1 minimum limit in pu (base UNom) (< vsi1max). Typical value = -2";
  parameter Types.VoltageModulePu Vsi2MaxPu "Input signal #2 maximum limit in pu (base UNom) (> vsi2min). Typical value = 2";
  parameter Types.VoltageModulePu Vsi2MinPu "Input signal #2 minimum limit in pu (base UNom) (< vsi2max). Typical value = -2";
  parameter Types.VoltageModulePu VstMaxPu "Stabilizer output maximum limit in pu (base UNom) (> vstmin). Typical value = 0.1";
  parameter Types.VoltageModulePu VstMinPu "Stabilizer output minimum limit in pu (base UNom) (< vstmax). Typical value = -0.1";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PGenPu(start = PGen0Pu) "Active power input in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-254, -40}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-254, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput UPssPu(start = 0) "Voltage output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {250, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = tw1, k = tw1, x_start = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative1(T = tw2, k = tw2) annotation(
    Placement(visible = true, transformation(origin = {-90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative2(T = tw3, k = tw3, x_start = PGen0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative3(T = tw4, k = tw4) annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = t6) annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = t7, k = Ks2) annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Ks3) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain1(k = Ks1) annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = VstMaxPu, uMin = VstMinPu) annotation(
    Placement(visible = true, transformation(origin = {210, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = Vsi1MaxPu, uMin = Vsi1MinPu) annotation(
    Placement(visible = true, transformation(origin = {-170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(uMax = Vsi2MaxPu, uMin = Vsi2MinPu) annotation(
    Placement(visible = true, transformation(origin = {-170, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RampTrackingFilter rampTrackingFilter(M = 5, t1 = t8, t2 = t9) annotation(
    Placement(visible = true, transformation(origin = {30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction1(a = {t11, 1}, b = {t10, 1}) annotation(
    Placement(visible = true, transformation(origin = {170, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction2(a = {t4, 1}, b = {t3, 1}) annotation(
    Placement(visible = true, transformation(origin = {130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction3(a = {t2, 1}, b = {t1, 1}) annotation(
    Placement(visible = true, transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-210, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ActivePowerPu PGen0Pu "Initial active power input in pu (base SnRef) (generator convention)" annotation(
  Dialog(group="Initialization"));

equation
  connect(limiter.y, UPssPu) annotation(
    Line(points = {{221, -40}, {250, -40}}, color = {0, 0, 127}));
  connect(omegaPu, limiter1.u) annotation(
    Line(points = {{-254, 40}, {-182, 40}}, color = {0, 0, 127}));
  connect(limiter1.y, derivative.u) annotation(
    Line(points = {{-159, 40}, {-142, 40}}, color = {0, 0, 127}));
  connect(derivative.y, derivative1.u) annotation(
    Line(points = {{-119, 40}, {-102, 40}}, color = {0, 0, 127}));
  connect(limiter2.y, derivative2.u) annotation(
    Line(points = {{-159, -40}, {-142, -40}}, color = {0, 0, 127}));
  connect(feedback.y, gain1.u) annotation(
    Line(points = {{79, 40}, {98, 40}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback.u2) annotation(
    Line(points = {{-39, -40}, {70, -40}, {70, 32}}, color = {0, 0, 127}));
  connect(gain1.y, transferFunction3.u) annotation(
    Line(points = {{121, 40}, {138, 40}}, color = {0, 0, 127}));
  connect(transferFunction3.y, transferFunction2.u) annotation(
    Line(points = {{161, 40}, {200, 40}, {200, 0}, {100, 0}, {100, -40}, {118, -40}}, color = {0, 0, 127}));
  connect(transferFunction2.y, transferFunction1.u) annotation(
    Line(points = {{141, -40}, {158, -40}}, color = {0, 0, 127}));
  connect(transferFunction1.y, limiter.u) annotation(
    Line(points = {{181, -40}, {198, -40}}, color = {0, 0, 127}));
  connect(firstOrder1.y, gain.u) annotation(
    Line(points = {{-39, -40}, {-30, -40}, {-30, -12}}, color = {0, 0, 127}));
  connect(gain.y, add.u2) annotation(
    Line(points = {{-30, 11}, {-30, 34}, {-22, 34}}, color = {0, 0, 127}));
  connect(derivative1.y, firstOrder.u) annotation(
    Line(points = {{-79, 40}, {-62, 40}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u1) annotation(
    Line(points = {{-39, 40}, {-30, 40}, {-30, 46}, {-22, 46}}, color = {0, 0, 127}));
  connect(rampTrackingFilter.y, feedback.u1) annotation(
    Line(points = {{41, 40}, {62, 40}}, color = {0, 0, 127}));
  connect(add.y, rampTrackingFilter.u) annotation(
    Line(points = {{1, 40}, {18, 40}}, color = {0, 0, 127}));
  connect(PGenPu, gain2.u) annotation(
    Line(points = {{-254, -40}, {-222, -40}}, color = {0, 0, 127}));
  connect(gain2.y, limiter2.u) annotation(
    Line(points = {{-198, -40}, {-182, -40}}, color = {0, 0, 127}));
  connect(derivative3.y, firstOrder1.u) annotation(
    Line(points = {{-79, -40}, {-62, -40}}, color = {0, 0, 127}));
  connect(derivative2.y, derivative3.u) annotation(
    Line(points = {{-118, -40}, {-102, -40}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
  Diagram(coordinateSystem(extent = {{-240, -100}, {240, 100}})));
end PssIEEE2B;
