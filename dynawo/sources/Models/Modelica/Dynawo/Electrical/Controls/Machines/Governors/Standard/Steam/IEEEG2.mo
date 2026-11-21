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

model IEEEG2 "IEEE governor type IEEEG2"

  //Regulation parameters
  parameter Types.PerUnit K "Governor gain (reciprocal of droop)";
  parameter Types.ActivePowerPu PMaxPu "Maximum mechanical power in pu (base PNomTurb)";
  parameter Types.ActivePowerPu PMinPu "Minimum mechanical power in pu (base PNomTurb)";
  parameter Types.Time t1 "Governor mechanism time constant in s";
  parameter Types.Time t2 "Turbine power time constant in s";
  parameter Types.Time t3 "Turbine exhaust temperature time constant in s";
  parameter Types.Time t4 "Governor lead-lag time constant in s";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) "Reference mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {-180, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -K) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction(a = {t4 / 2, 1}, b = {-t4, 1}, initType = Modelica.Blocks.Types.Init.SteadyState, u_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction1(a = {t3, 1}, b = {t2, 1}) annotation(
    Placement(visible = true, transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = t1) annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameter
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNomTurb)";

equation
  connect(omegaPu, add.u1) annotation(
    Line(points = {{-180, -40}, {-140, -40}, {-140, -54}, {-122, -54}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u2) annotation(
    Line(points = {{-180, -80}, {-140, -80}, {-140, -66}, {-122, -66}}, color = {0, 0, 127}));
  connect(PmRefPu, add1.u1) annotation(
    Line(points = {{-180, 40}, {0, 40}, {0, 6}, {18, 6}}, color = {0, 0, 127}));
  connect(add1.y, limiter.u) annotation(
    Line(points = {{42, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(limiter.y, transferFunction.u) annotation(
    Line(points = {{82, 0}, {98, 0}}, color = {0, 0, 127}));
  connect(transferFunction.y, PmPu) annotation(
    Line(points = {{122, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(transferFunction1.y, add1.u2) annotation(
    Line(points = {{-18, -60}, {0, -60}, {0, -6}, {18, -6}}, color = {0, 0, 127}));
  connect(add.y, firstOrder.u) annotation(
    Line(points = {{-98, -60}, {-82, -60}}, color = {0, 0, 127}));
  connect(firstOrder.y, transferFunction1.u) annotation(
    Line(points = {{-58, -60}, {-42, -60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -100}, {140, 100}})));
end IEEEG2;
