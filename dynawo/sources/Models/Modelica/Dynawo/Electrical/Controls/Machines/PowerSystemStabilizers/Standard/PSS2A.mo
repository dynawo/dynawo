within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com) and UPC/Citcea (https://www.citcea.upc.edu/)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PSS2A "IEEE Power System Stabilizer type 2A"

  parameter Types.PerUnit Ks1 "PSS gain";
  parameter Types.PerUnit Ks2 "2nd signal transducer factor";
  parameter Types.PerUnit Ks3 "Washouts coupling factor";
  parameter Types.Time Tw1 "1st washout 1st time constant in s";
  parameter Types.Time Tw2 "1st washout 2nd time constant in s";
  parameter Types.Time Tw3 "2nd washout 1st time constant in s";
  parameter Types.Time Tw4 "2nd washout 2nd time constant in s";
  parameter Types.Time T1 "1st lead-lag derivative time constant in s";
  parameter Types.Time T2 "1st lead-lag delay time constant in s";
  parameter Types.Time T3 "2nd lead-lag derivative time constant in s";
  parameter Types.Time T4 "2nd lead-lag delay time constant in s";
  parameter Types.Time T6 "1st signal transducer time constant in s";
  parameter Types.Time T7 "2nd signal transducer time constant in s";
  parameter Types.Time T8 "Ramp tracking filter derivative time constant in s";
  parameter Types.Time T9 "Ramp tracking filter delay time constant in s";
  parameter Types.VoltageModulePu VstMin "Controller minimum output in pu (base UNom)";
  parameter Types.VoltageModulePu VstMax "Controller maximum output in pu (base UNom)";
  parameter Types.PerUnit IC1 "1st input selector";
  parameter Types.PerUnit IC2 "2nd input selector";
  parameter Types.ActivePower PNomAlt "Nominal active (alternator) power in MW";
  parameter Types.VoltageModulePu Upss0Pu "Initial voltage output in pu (base UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PGenPu(start = PGen0Pu) "Active power input in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-194, -40}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-194, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput UpssPu(start = Upss0Pu) "Voltage output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = VstMax, uMin = VstMin) annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder transducerOmega(T = T6) annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative washoutOmega1(k = Tw1, T = Tw1) annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative washoutPGen1(k = Tw3, T = Tw3, x_start = PGen0Pu * gain.k) annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder transducerPGen(k = Ks2, T = T7, y_start = Ks2 * PGen0Pu * gain.k) annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction leadLag1(a = {T2, 1}, b = {T1, 1}, x_scaled(start = {Upss0Pu}), x_start = {Upss0Pu}, y(start = Upss0Pu)) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative washoutOmega2(k = Tw2, T = Tw2) annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative washoutPGen2(k = Tw4, T = Tw4) annotation(
    Placement(visible = true, transformation(origin = {-80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction leadLag2(a = {T4, 1}, b = {T3, 1}, x_scaled(start = {Upss0Pu}), x_start = {Upss0Pu}, y(start = Upss0Pu)) annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-140, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-170, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = SystemBase.SnRef / PNomAlt) annotation(
    Placement(visible = true, transformation(origin = {-140, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Ks1) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = Ks3) annotation(
    Placement(visible = true, transformation(origin = {-10, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ActivePowerPu PGen0Pu "Initial active power input in pu (base SnRef) (generator convention)";

equation
  connect(transducerPGen.y, feedback.u2) annotation(
    Line(points = {{-39, -40}, {30, -40}, {30, -8}}, color = {0, 0, 127}));
  connect(washoutOmega1.y, washoutOmega2.u) annotation(
    Line(points = {{-99, 40}, {-92, 40}}, color = {0, 0, 127}));
  connect(washoutOmega2.y, transducerOmega.u) annotation(
    Line(points = {{-69, 40}, {-62, 40}}, color = {0, 0, 127}));
  connect(washoutPGen1.y, washoutPGen2.u) annotation(
    Line(points = {{-99, -40}, {-92, -40}}, color = {0, 0, 127}));
  connect(washoutPGen2.y, transducerPGen.u) annotation(
    Line(points = {{-69, -40}, {-62, -40}}, color = {0, 0, 127}));
  connect(leadLag1.y, leadLag2.u) annotation(
    Line(points = {{101, 0}, {108, 0}}, color = {0, 0, 127}));
  connect(leadLag2.y, limiter.u) annotation(
    Line(points = {{131, 0}, {138, 0}}, color = {0, 0, 127}));
  connect(omegaPu, feedback1.u1) annotation(
    Line(points = {{-194, 40}, {-148, 40}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, feedback1.u2) annotation(
    Line(points = {{-159, 10}, {-140, 10}, {-140, 32}}, color = {0, 0, 127}));
  connect(feedback1.y, washoutOmega1.u) annotation(
    Line(points = {{-131, 40}, {-122, 40}}, color = {0, 0, 127}));
  connect(limiter.y, UpssPu) annotation(
    Line(points = {{161, 0}, {190, 0}}, color = {0, 0, 127}));
  connect(PGenPu, gain.u) annotation(
    Line(points = {{-194, -40}, {-152, -40}}, color = {0, 0, 127}));
  connect(gain.y, washoutPGen1.u) annotation(
    Line(points = {{-129, -40}, {-122, -40}}, color = {0, 0, 127}));
  connect(gain1.y, leadLag1.u) annotation(
    Line(points = {{71, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain1.u) annotation(
    Line(points = {{39, 0}, {48, 0}}, color = {0, 0, 127}));
  connect(transducerPGen.y, add.u2) annotation(
    Line(points = {{-39, -40}, {-30, -40}, {-30, 28}, {-22, 28}}, color = {0, 0, 127}));
  connect(transducerOmega.y, add.u1) annotation(
    Line(points = {{-39, 40}, {-22, 40}}, color = {0, 0, 127}));
  connect(add.y, feedback.u1) annotation(
    Line(points = {{1, 34}, {10, 34}, {10, 0}, {22, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3")),
  Diagram(coordinateSystem(extent = {{-180, -100}, {180, 100}})),
  Documentation(info = "<html><head></head><body>This model is the IEEE PSS2A model, based on the chapter 8.2 of the&nbsp;<span class=\"pl-c\">IEEE Std 421.5-1992 documentation. It enables to represent a large variety of dual-input stabilizers.</span></body></html>"));
end PSS2A;
