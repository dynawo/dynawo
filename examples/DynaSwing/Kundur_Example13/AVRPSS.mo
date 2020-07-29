/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model AVRPSS "Simple Proportional Voltage Regulator with PSS"
/*This model is inherated from the Kundur "Power System Stability and Control" book.
  Notations are kept identical whenever possible for readability reasons.*/

  import Modelica.Blocks;
  import Modelica.SIunits;
  import Dynawo.Connectors;

  // AVR parameters
  parameter SIunits.PerUnit KA "Exciter gain";
  parameter SIunits.Time TR "Transducer time constant";
  parameter SIunits.PerUnit EfdMin "Minimum excitation voltage";
  parameter SIunits.PerUnit EfdMax "Maximum excitation voltage";

  // PSS parameters
  parameter SIunits.PerUnit KStab "PSS gain";
  parameter SIunits.Time Tw "Washout time constant";
  parameter SIunits.Time T1 "Phase compensation time constant";
  parameter SIunits.Time T2 "Phase compensation time constant";
  parameter SIunits.PerUnit VsMin "Minimum output of PSS";
  parameter SIunits.PerUnit VsMax "Maximum output of PSS";

  // AVR
  Blocks.Sources.Constant URefPu(k = URef0Pu) annotation(
    Placement(visible = true, transformation(origin = {2, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput UStatorPu(start = UStator0Pu) annotation(
    Placement(visible = true, transformation(origin = {-44, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-56, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Continuous.FirstOrder Transducer(T = TR, k = 1, y_start = UStator0Pu) annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add3 error(k1 = 1, k2 = -1, k3 = 1) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain Exciter(k = KA) annotation(
    Placement(visible = true, transformation(origin = {96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter LimiterAVR(limitsAtInit = true, uMax = EfdMax, uMin = EfdMin) annotation(
    Placement(visible = true, transformation(origin = {132, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealOutput efdPu(start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {162, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {162, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ImPin efdPuPin(value(start = Efd0Pu)) "Exciter field voltage Pin";

  // PSS
  Blocks.Interfaces.RealInput omegaRefPu(start = 1) annotation(
    Placement(visible = true, transformation(origin = {-212, -8}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-46, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput omegaPu(start = 1) annotation(
    Placement(visible = true, transformation(origin = {-212, -54}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-46, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Math.Add dW(k1 = -1, k2 = 1) annotation(
    Placement(visible = true, transformation(origin = {-158, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain GainPSS(k = KStab) annotation(
    Placement(visible = true, transformation(origin = {-118, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.Derivative Washout(T = Tw, k = Tw, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-78, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.TransferFunction PhaseCompensation(a = {T2, 1}, b = {T1, 1}, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-36, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter LimiterPSS(limitsAtInit = true, uMax = VsMax, uMin = VsMin) annotation(
    Placement(visible = true, transformation(origin = {2, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter SIunits.PerUnit UStator0Pu "Initial stator voltage";
  parameter SIunits.PerUnit Efd0Pu "Initial excitation voltage";
  final parameter SIunits.PerUnit URef0Pu = Efd0Pu / KA + UStator0Pu "Initial reference stator voltage";

equation
  connect(URefPu.y, error.u1) annotation(
    Line(points = {{14, 36}, {29, 36}, {29, 8}, {48, 8}}, color = {0, 0, 127}));
  connect(omegaPu, dW.u2) annotation(
    Line(points = {{-212, -54}, {-180, -54}, {-180, -40}, {-170, -40}}, color = {0, 0, 127}));
  connect(omegaRefPu, dW.u1) annotation(
    Line(points = {{-212, -8}, {-180, -8}, {-180, -28}, {-170, -28}}, color = {0, 0, 127}));
  connect(dW.y, GainPSS.u) annotation(
    Line(points = {{-147, -34}, {-131, -34}, {-131, -34}, {-131, -34}, {-131, -34}, {-131, -34}}, color = {0, 0, 127}));
  connect(UStatorPu, Transducer.u) annotation(
    Line(points = {{-44, 0}, {-12, 0}, {-12, 0}, {-11, 0}, {-11, 0}, {-10, 0}}, color = {0, 0, 127}));
  connect(Transducer.y, error.u2) annotation(
    Line(points = {{13, 0}, {45, 0}, {45, 0}, {47, 0}}, color = {0, 0, 127}));
  connect(GainPSS.y, Washout.u) annotation(
    Line(points = {{-107, -34}, {-99, -34}, {-99, -34}, {-91, -34}, {-91, -34}, {-91, -34}, {-91, -34}, {-91, -34}}, color = {0, 0, 127}));
  connect(Washout.y, PhaseCompensation.u) annotation(
    Line(points = {{-67, -34}, {-49, -34}, {-49, -34}, {-49, -34}, {-49, -34}, {-49, -34}}, color = {0, 0, 127}));
  connect(PhaseCompensation.y, LimiterPSS.u) annotation(
    Line(points = {{-25, -34}, {-19, -34}, {-19, -34}, {-13, -34}, {-13, -34}, {-12, -34}, {-12, -34}, {-11, -34}}, color = {0, 0, 127}));
  connect(LimiterPSS.y, error.u3) annotation(
    Line(points = {{13, -34}, {22, -34}, {22, -34}, {31, -34}, {31, -8}, {39, -8}, {39, -8}, {47, -8}}, color = {0, 0, 127}));
  connect(error.y, Exciter.u) annotation(
    Line(points = {{71, 0}, {84, 0}}, color = {0, 0, 127}));
  connect(Exciter.y, LimiterAVR.u) annotation(
    Line(points = {{107, 0}, {120, 0}}, color = {0, 0, 127}));
  connect(LimiterAVR.y, efdPu) annotation(
    Line(points = {{143, 0}, {162, 0}}, color = {0, 0, 127}));
  connect(efdPuPin.value, efdPu);
  annotation(
    uses(Modelica(version = "3.2.2")),
    Diagram);
end AVRPSS;
