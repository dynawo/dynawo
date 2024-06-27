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

model TGov1 "IEEE governor type TGOV1"

  //Regulation parameters
  parameter Types.PerUnit Dt "Turbine damping coefficient";
  parameter Types.PerUnit R "Permanent droop";
  parameter Types.Time t1 "Steam bowl time constant in s";
  parameter Types.Time t2 "Reheater lead time constant in s";
  parameter Types.Time t3 "Reheater lag time constant in s";
  parameter Types.PerUnit VMax "Maximum valve position";
  parameter Types.PerUnit VMin "Minimum valve position";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-114, -40}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-114, -80}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = R * Pm0Pu) "Reference mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-114, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {t3, 1}, b = {t2, 1}, x_scaled(start = {Pm0Pu}), x_start = {Pm0Pu}, y(start = Pm0Pu)) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-90, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / R) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(tFilter = t1, Y0 = Pm0Pu, YMax = VMax, YMin = VMin) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Dt) annotation(
    Placement(visible = true, transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameter
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNomTurb)";

equation
  connect(omegaPu, add.u1) annotation(
    Line(points = {{-160, -40}, {-120, -40}, {-120, -54}, {-102, -54}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u2) annotation(
    Line(points = {{-160, -80}, {-120, -80}, {-120, -66}, {-102, -66}}, color = {0, 0, 127}));
  connect(PmRefPu, feedback.u1) annotation(
    Line(points = {{-160, 0}, {-68, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-50, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(gain.y, limitedFirstOrder.u) annotation(
    Line(points = {{2, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, transferFunction.u) annotation(
    Line(points = {{42, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(transferFunction.y, feedback1.u1) annotation(
    Line(points = {{82, 0}, {112, 0}}, color = {0, 0, 127}));
  connect(add.y, gain1.u) annotation(
    Line(points = {{-78, -60}, {-22, -60}}, color = {0, 0, 127}));
  connect(add.y, feedback.u2) annotation(
    Line(points = {{-78, -60}, {-60, -60}, {-60, -8}}, color = {0, 0, 127}));
  connect(gain1.y, feedback1.u2) annotation(
    Line(points = {{2, -60}, {120, -60}, {120, -8}}, color = {0, 0, 127}));
  connect(feedback1.y, PmPu) annotation(
    Line(points = {{130, 0}, {150, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
end TGov1;
