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
*/model ExciterAvrPssOelNordic32

  import Modelica;
  import Dynawo.Connectors;
  parameter Real G;
  parameter Real Ta;
  parameter Real Tb;
  parameter Real L2;
  parameter Real Kp;
  parameter Real Tw;
  parameter Real T1;
  parameter Real T2;
  parameter Real L1;
  parameter Real r;
  parameter Real f;
  parameter Real IfLimPu;
  Modelica.Blocks.Interfaces.RealInput UStatorPu(start = UStator0Pu) annotation(
    Placement(visible = true, transformation(origin = {-182, -44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ifPu(start = If0Pu) annotation(
    Placement(visible = true, transformation(origin = {-182, 56}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput efdPu(start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {198, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ImPin efdPuPin(value(start = Efd0Pu));
  Modelica.Blocks.Math.Min min1 annotation(
    Placement(visible = true, transformation(origin = {14, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add31(k1 = 1, k2 = -1, k3 = 1) annotation(
    Placement(visible = true, transformation(origin = {-126, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = UsRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-174, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction2(a = {Tw, 1}, b = {Kp, 0}, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-92, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction3(a = {T2, 1}, b = {T1, 1}, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-56, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction4(a = {T2, 1}, b = {T1, 1}, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-20, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = 0.1, uMin = -0.1) annotation(
    Placement(visible = true, transformation(origin = {12, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-26, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.RealToBoolean realToBoolean1(threshold = -L1) annotation(
    Placement(visible = true, transformation(origin = {-64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = -1, k2 = 1) annotation(
    Placement(visible = true, transformation(origin = {-124, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {-88, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = IfLimPu) annotation(
    Placement(visible = true, transformation(origin = {-172, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = G) annotation(
    Placement(visible = true, transformation(origin = {48, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OELFunction oELFunction1(f = f, r = r, y_start = -1) annotation(
    Placement(visible = true, transformation(origin = {-158, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer1 annotation(
    Placement(visible = true, transformation(origin = {-96, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.RealToBoolean realToBoolean2(threshold = 0) annotation(
    Placement(visible = true, transformation(origin = {-128, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = 10) annotation(
    Placement(visible = true, transformation(origin = {120, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = 1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {88, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = 1, outMax = L2, outMin = 0, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {156, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu annotation(
    Placement(visible = true, transformation(origin = {-182, -108}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3(k1 = -1, k2 = 1) annotation(
    Placement(visible = true, transformation(origin = {-124, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-174, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  parameter Modelica.SIunits.PerUnit Efd0Pu;
  parameter Modelica.SIunits.PerUnit UStator0Pu;
  parameter Modelica.SIunits.PerUnit If0Pu;
  final parameter Modelica.SIunits.PerUnit UsRef0Pu = Efd0Pu / G + UStator0Pu;
equation
  connect(limIntegrator.y, efdPu) annotation(
    Line(points = {{167, -44}, {189, -44}, {189, -44}, {197, -44}}, color = {0, 0, 127}));
  connect(efdPu, efdPuPin.value) annotation(
    Line);
  connect(limIntegrator.y, add2.u2) annotation(
    Line(points = {{167, -44}, {173, -44}, {173, -70}, {63, -70}, {63, -50}, {75, -50}, {75, -50}, {75, -50}, {75, -50}}, color = {0, 0, 127}));
  connect(gain3.y, limIntegrator.u) annotation(
    Line(points = {{131, -44}, {141, -44}, {141, -44}, {143, -44}, {143, -44}, {143, -44}}, color = {0, 0, 127}));
  connect(add2.y, gain3.u) annotation(
    Line(points = {{99, -44}, {107, -44}, {107, -44}, {107, -44}}, color = {0, 0, 127}));
  connect(gain2.y, add2.u1) annotation(
    Line(points = {{60, -38}, {76, -38}}, color = {0, 0, 127}));
  connect(omegaPu, add3.u2) annotation(
    Line(points = {{-182, -108}, {-152, -108}, {-152, -94}, {-136, -94}, {-136, -94}}, color = {0, 0, 127}));
  connect(const.y, add3.u1) annotation(
    Line(points = {{-162, -72}, {-152, -72}, {-152, -82}, {-136, -82}, {-136, -82}}, color = {0, 0, 127}));
  connect(add3.y, transferFunction2.u) annotation(
    Line(points = {{-113, -88}, {-105, -88}, {-105, -88}, {-105, -88}}, color = {0, 0, 127}));
  connect(limiter1.y, add31.u3) annotation(
    Line(points = {{23, -88}, {40, -88}, {40, -64}, {-152, -64}, {-152, -52}, {-138, -52}}, color = {0, 0, 127}));
  connect(transferFunction4.y, limiter1.u) annotation(
    Line(points = {{-9, -88}, {0, -88}}, color = {0, 0, 127}));
  connect(transferFunction3.y, transferFunction4.u) annotation(
    Line(points = {{-45, -88}, {-35, -88}, {-35, -88}, {-33, -88}}, color = {0, 0, 127}));
  connect(transferFunction2.y, transferFunction3.u) annotation(
    Line(points = {{-81, -88}, {-71, -88}, {-71, -88}, {-69, -88}}, color = {0, 0, 127}));
  connect(timer1.y, realToBoolean1.u) annotation(
    Line(points = {{-84, 22}, {-76, 22}}, color = {0, 0, 127}));
  connect(realToBoolean1.y, switch1.u2) annotation(
    Line(points = {{-53, 22}, {-38, 22}}, color = {255, 0, 255}));
  connect(realToBoolean2.y, timer1.u) annotation(
    Line(points = {{-116, 22}, {-108, 22}, {-108, 22}, {-108, 22}}, color = {255, 0, 255}));
  connect(oELFunction1.y, realToBoolean2.u) annotation(
    Line(points = {{-148, 22}, {-140, 22}, {-140, 22}, {-140, 22}}, color = {0, 0, 127}));
  connect(add1.y, oELFunction1.u) annotation(
    Line(points = {{-113, 62}, {-109, 62}, {-109, 42}, {-181, 42}, {-181, 22}, {-170, 22}}, color = {0, 0, 127}));
  connect(min1.y, gain2.u) annotation(
    Line(points = {{25, -38}, {35, -38}, {35, -38}, {35, -38}}, color = {0, 0, 127}));
  connect(add31.y, min1.u2) annotation(
    Line(points = {{-115, -44}, {2, -44}}, color = {0, 0, 127}));
  connect(switch1.y, min1.u1) annotation(
    Line(points = {{-15, 22}, {-6, 22}, {-6, -32}, {2, -32}}, color = {0, 0, 127}));
  connect(UStatorPu, add31.u2) annotation(
    Line(points = {{-182, -44}, {-138, -44}}, color = {0, 0, 127}));
  connect(const1.y, add31.u1) annotation(
    Line(points = {{-163, -10}, {-152, -10}, {-152, -36}, {-138, -36}}, color = {0, 0, 127}));
  connect(add31.y, switch1.u3) annotation(
    Line(points = {{-115, -44}, {-47, -44}, {-47, 14}, {-38, 14}}, color = {0, 0, 127}));
  connect(gain1.y, switch1.u1) annotation(
    Line(points = {{-77, 62}, {-47, 62}, {-47, 30}, {-38, 30}}, color = {0, 0, 127}));
  connect(add1.y, gain1.u) annotation(
    Line(points = {{-113, 62}, {-100, 62}}, color = {0, 0, 127}));
  connect(const2.y, add1.u1) annotation(
    Line(points = {{-161, 86}, {-151, 86}, {-151, 68}, {-136, 68}}, color = {0, 0, 127}));
  connect(ifPu, add1.u2) annotation(
    Line(points = {{-182, 56}, {-136, 56}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}),
    uses(Modelica(version = "3.2.3")));
end ExciterAvrPssOelNordic32;
