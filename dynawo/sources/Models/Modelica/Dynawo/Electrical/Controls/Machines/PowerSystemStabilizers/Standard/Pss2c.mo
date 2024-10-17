within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard;

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

model Pss2c "IEEE power system stabilizer type 2C"

  //Regulation parameters
  parameter Types.PerUnit KOmega = 1 "Coefficient applied to angular frequency";
  parameter Types.PerUnit KOmegaRef = 0 "Coefficient applied to reference angular frequency";
  parameter Types.PerUnit Ks1 "Gain of power system stabilizer";
  parameter Types.PerUnit Ks2 "Gain of transducer (active power branch)";
  parameter Types.PerUnit Ks3 "Washouts coupling factor";
  parameter Integer M "Lag order of ramp-tracking filter";
  parameter Integer N "Order of ramp-tracking filter";
  parameter Types.AngularVelocityPu OmegaMaxPu "Maximum angular frequency input of power system stabilizer in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMinPu "Minimum angular frequency input of power system stabilizer in pu (base omegaNom)";
  parameter Types.ActivePowerPu PGenMaxPu "Maximum active power input of power system stabilizer in pu (base SNom) (generator convention)";
  parameter Types.ActivePowerPu PGenMinPu "Minimum active power input of power system stabilizer in pu (base SNom) (generator convention)";
  parameter Types.ActivePowerPu PPssOffPu "Active power threshold for PSS deactivation in pu (base SNom) (generator convention)";
  parameter Types.ActivePowerPu PPssOnPu "Active power threshold for PSS activation in pu (base SNom) (generator convention)";
  parameter Types.Time t1 "First lead time constant in s";
  parameter Types.Time t2 "First lag time constant in s";
  parameter Types.Time t3 "Second lead time constant in s";
  parameter Types.Time t4 "Second lag time constant in s";
  parameter Types.Time t6 "Transducer time constant of angular frequency branch in s";
  parameter Types.Time t7 "Transducer time constant of active power branch in s";
  parameter Types.Time t8 "Ramp-tracking filter lead time constant in s";
  parameter Types.Time t9 "Ramp-tracking filter lag time constant in s";
  parameter Types.Time t10 "Third lead time constant in s";
  parameter Types.Time t11 "Third lag time constant in s";
  parameter Types.Time t12 "Fourth lead time constant in s";
  parameter Types.Time t13 "Fourth lag time constant in s";
  parameter Types.Time tW1 "First washout time constant (angular frequency branch) in s";
  parameter Types.Time tW2 "Second washout time constant (angular frequency branch) in s";
  parameter Types.Time tW3 "First washout time constant (active power branch) in s";
  parameter Types.Time tW4 "Second washout time constant (active power branch) in s";
  parameter Types.VoltageModulePu VPssMaxPu "Maximum voltage output of power system stabilizer in pu (base UNom)";
  parameter Types.VoltageModulePu VPssMinPu "Minimum voltage output of power system stabilizer in pu (base UNom)";

  //Generator parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-360, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-360, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PGenPu(start = PGen0Pu) "Active power in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-360, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput VPssPu(start = 0) "Voltage output of power system stabilizer in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {370, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = OmegaMaxPu, uMin = OmegaMinPu) annotation(
    Placement(visible = true, transformation(origin = {-250, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = PGenMaxPu, uMin = PGenMinPu) annotation(
    Placement(visible = true, transformation(origin = {-250, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-310, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Washout washout(tW = tW1, U0 = KOmega * SystemBase.omega0Pu + KOmegaRef * SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-210, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Washout washout1(tW = tW2) annotation(
    Placement(visible = true, transformation(origin = {-170, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Washout washout2(tW = tW3, U0 = PGen0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-210, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Washout washout3(tW = tW4) annotation(
    Placement(visible = true, transformation(origin = {-170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = t6) annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = t7, k = Ks2) annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RampTrackingFilter rampTrackingFilter(M = M, N = N, t1 = t8, t2 = t9) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = Ks3) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Ks1) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {t2, 1}, b = {t1, 1}) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction1(a = {t4, 1}, b = {t3, 1}) annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction2(a = {t11, 1}, b = {t10, 1}) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction3(a = {t13, 1}, b = {t12, 1}) annotation(
    Placement(visible = true, transformation(origin = {230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = VPssMaxPu, uMin = VPssMinPu) annotation(
    Placement(visible = true, transformation(origin = {270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uHigh = PPssOnPu, uLow = PPssOffPu, y(start = PGen0Pu * SystemBase.SnRef / SNom > PPssOffPu)) annotation(
    Placement(visible = true, transformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {330, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {270, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = KOmega, k2 = KOmegaRef) annotation(
    Placement(visible = true, transformation(origin = {-290, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameter
  parameter Types.ActivePowerPu PGen0Pu "Initial active power in pu (base SnRef) (generator convention)";

equation
  connect(PGenPu, gain.u) annotation(
    Line(points = {{-360, 60}, {-322, 60}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{-299, 60}, {-263, 60}}, color = {0, 0, 127}));
  connect(limiter1.y, washout2.u) annotation(
    Line(points = {{-239, 60}, {-223, 60}}, color = {0, 0, 127}));
  connect(washout2.y, washout3.u) annotation(
    Line(points = {{-199, 60}, {-183, 60}}, color = {0, 0, 127}));
  connect(washout3.y, firstOrder1.u) annotation(
    Line(points = {{-159, 60}, {-143, 60}}, color = {0, 0, 127}));
  connect(limiter.y, washout.u) annotation(
    Line(points = {{-239, -60}, {-223, -60}}, color = {0, 0, 127}));
  connect(washout.y, washout1.u) annotation(
    Line(points = {{-199, -60}, {-183, -60}}, color = {0, 0, 127}));
  connect(washout1.y, firstOrder.u) annotation(
    Line(points = {{-159, -60}, {-143, -60}}, color = {0, 0, 127}));
  connect(add.y, rampTrackingFilter.u) annotation(
    Line(points = {{-59, 0}, {-43, 0}}, color = {0, 0, 127}));
  connect(rampTrackingFilter.y, feedback.u1) annotation(
    Line(points = {{-19, 0}, {12, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback.u2) annotation(
    Line(points = {{-119, 60}, {20, 60}, {20, 8}}, color = {0, 0, 127}));
  connect(feedback.y, gain1.u) annotation(
    Line(points = {{29, 0}, {57, 0}}, color = {0, 0, 127}));
  connect(gain1.y, transferFunction.u) annotation(
    Line(points = {{81, 0}, {97, 0}}, color = {0, 0, 127}));
  connect(transferFunction.y, transferFunction1.u) annotation(
    Line(points = {{121, 0}, {137, 0}}, color = {0, 0, 127}));
  connect(transferFunction1.y, transferFunction2.u) annotation(
    Line(points = {{161, 0}, {177, 0}}, color = {0, 0, 127}));
  connect(transferFunction2.y, transferFunction3.u) annotation(
    Line(points = {{201, 0}, {217, 0}}, color = {0, 0, 127}));
  connect(transferFunction3.y, limiter2.u) annotation(
    Line(points = {{241, 0}, {257, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, add.u1) annotation(
    Line(points = {{-119, 60}, {-100, 60}, {-100, 6}, {-83, 6}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u2) annotation(
    Line(points = {{-119, -60}, {-100, -60}, {-100, -6}, {-83, -6}}, color = {0, 0, 127}));
  connect(gain.y, hysteresis.u) annotation(
    Line(points = {{-298, 60}, {-280, 60}, {-280, 0}, {-262, 0}}, color = {0, 0, 127}));
  connect(hysteresis.y, switch.u2) annotation(
    Line(points = {{-239, 0}, {-120, 0}, {-120, -40}, {318, -40}}, color = {255, 0, 255}));
  connect(limiter2.y, switch.u1) annotation(
    Line(points = {{282, 0}, {300, 0}, {300, -32}, {318, -32}}, color = {0, 0, 127}));
  connect(const.y, switch.u3) annotation(
    Line(points = {{282, -80}, {300, -80}, {300, -48}, {318, -48}}, color = {0, 0, 127}));
  connect(switch.y, VPssPu) annotation(
    Line(points = {{342, -40}, {370, -40}}, color = {0, 0, 127}));
  connect(omegaPu, add1.u1) annotation(
    Line(points = {{-360, -40}, {-320, -40}, {-320, -54}, {-302, -54}}, color = {0, 0, 127}));
  connect(omegaRefPu, add1.u2) annotation(
    Line(points = {{-360, -80}, {-320, -80}, {-320, -66}, {-302, -66}}, color = {0, 0, 127}));
  connect(add1.y, limiter.u) annotation(
    Line(points = {{-278, -60}, {-262, -60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-340, -180}, {360, 180}})));
end Pss2c;
