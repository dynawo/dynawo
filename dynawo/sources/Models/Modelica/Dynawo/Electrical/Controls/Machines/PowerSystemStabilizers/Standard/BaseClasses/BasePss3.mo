within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.BaseClasses;

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

model BasePss3 "IEEE power system stabilizer type 3 base model"

  //Regulation parameters
  parameter Types.Time A1 "First numerator coefficient of first notch filter in s";
  parameter Types.PerUnit A2 "Second numerator coefficient of first notch filter in s ^ 2";
  parameter Types.Time A3 "First denominator coefficient of first notch filter in s";
  parameter Types.PerUnit A4 "Second denominator coefficient of first notch filter in s ^ 2";
  parameter Types.Time A5 "First numerator coefficient of second notch filter in s";
  parameter Types.PerUnit A6 "Second numerator coefficient of second notch filter in s ^ 2";
  parameter Types.Time A7 "First denominator coefficient of second notch filter in s";
  parameter Types.PerUnit A8 "Second denominator coefficient of second notch filter in s ^ 2";
  parameter Types.PerUnit KOmega = 1 "Coefficient applied to angular frequency";
  parameter Types.PerUnit KOmegaRef = 0 "Coefficient applied to reference angular frequency";
  parameter Types.PerUnit Ks1 "Gain of active power branch";
  parameter Types.PerUnit Ks2 "Gain of angular frequency branch";
  parameter Types.Time t1 "Transducer time constant (active power branch) in s";
  parameter Types.Time t2 "Transducer time constant (angular frequency branch) in s";
  parameter Types.Time tW1 "Washout time constant (active power branch) in s";
  parameter Types.Time tW2 "Washout time constant (angular frequency branch) in s";
  parameter Types.Time tW3 "Washout time constant (main branch) in s";
  parameter Types.VoltageModulePu VPssMaxPu "Maximum voltage output of power system stabilizer in pu (base UNom)";
  parameter Types.VoltageModulePu VPssMinPu "Minimum voltage output of power system stabilizer in pu (base UNom)";

  //Generator parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PGenPu(start = PGen0Pu) "Active power in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-240, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput VPssPu(start = 0) "Voltage output of power system stabilizer in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {230, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gain(k = SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Washout washout1(U0 = Ks1 * PGen0Pu * SystemBase.SnRef / SNom, tW = tW1) annotation(
    Placement(visible = true, transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Washout washout(U0 = Ks2 * (KOmega * SystemBase.omega0Pu + KOmegaRef * SystemBase.omegaRef0Pu), tW = tW2) annotation(
    Placement(visible = true, transformation(origin = {-90, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = t2, k = Ks2, y_start = Ks2 * (KOmega * SystemBase.omega0Pu + KOmegaRef * SystemBase.omegaRef0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = t1, k = Ks1, y_start = Ks1 * PGen0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction(a = {A4, A3, 1}, b = {A2, A1, 1}) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction1(a = {A8, A7, 1}, b = {A6, A5, 1}) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = VPssMaxPu, uMin = VPssMinPu) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Washout washout2(tW = tW3) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = KOmega, k2 = KOmegaRef) annotation(
    Placement(visible = true, transformation(origin = {-170, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameter
  parameter Types.ActivePowerPu PGen0Pu "Initial active power in pu (base SnRef) (generator convention)";

equation
  connect(PGenPu, gain.u) annotation(
    Line(points = {{-240, 60}, {-182, 60}}, color = {0, 0, 127}));
  connect(transferFunction.y, transferFunction1.u) annotation(
    Line(points = {{61, 0}, {77, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, washout.u) annotation(
    Line(points = {{-119, -60}, {-103, -60}}, color = {0, 0, 127}));
  connect(gain.y, firstOrder1.u) annotation(
    Line(points = {{-159, 60}, {-143, 60}}, color = {0, 0, 127}));
  connect(firstOrder1.y, washout1.u) annotation(
    Line(points = {{-119, 60}, {-103, 60}}, color = {0, 0, 127}));
  connect(add.y, washout2.u) annotation(
    Line(points = {{-19, 0}, {-3, 0}}, color = {0, 0, 127}));
  connect(washout2.y, transferFunction.u) annotation(
    Line(points = {{20.8, 0}, {36.8, 0}}, color = {0, 0, 127}));
  connect(transferFunction1.y, limiter2.u) annotation(
    Line(points = {{101, 0}, {117, 0}}, color = {0, 0, 127}));
  connect(washout1.y, add.u1) annotation(
    Line(points = {{-79.2, 60}, {-60, 60}, {-60, 6}, {-43.2, 6}}, color = {0, 0, 127}));
  connect(washout.y, add.u2) annotation(
    Line(points = {{-79.2, -60}, {-60, -60}, {-60, -6}, {-43.2, -6}}, color = {0, 0, 127}));
  connect(omegaPu, add1.u1) annotation(
    Line(points = {{-240, -40}, {-200, -40}, {-200, -54}, {-182, -54}}, color = {0, 0, 127}));
  connect(omegaRefPu, add1.u2) annotation(
    Line(points = {{-240, -80}, {-200, -80}, {-200, -66}, {-182, -66}}, color = {0, 0, 127}));
  connect(add1.y, firstOrder.u) annotation(
    Line(points = {{-159, -60}, {-143, -60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-220, -120}, {220, 120}})));
end BasePss3;
