within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model Mechanical "Two-mass module for wind turbines (IEC N°61400-27-1)"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Mechanical parameters
  parameter Types.PerUnit CdrtPu "Drive train damping in pu (base SNom, omegaNom)" annotation(
    Dialog(tab = "Mechanical"));
  parameter Types.Time Hgen "Generator inertia time constant in s" annotation(
    Dialog(tab = "Mechanical"));
  parameter Types.Time Hwtr "WT rotor inertia time constant in s" annotation(
    Dialog(tab = "Mechanical"));
  parameter Types.PerUnit KdrtPu "Drive train stiffness in pu (base SNom, omegaNom)" annotation(
    Dialog(tab = "Mechanical"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PAeroPu(start = -P0Pu * SystemBase.SnRef / SNom) "Aerodynamic power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 54}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PAgPu(start = PAg0Pu) "Generator (air gap) power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, -54}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaGenPu(start = SystemBase.omega0Pu) "Generator angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaWTRPu(start = SystemBase.omega0Pu) "Rotor angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / (2 * Hwtr), y_start = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = 1 / (2 * Hgen), y_start = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PI pI(Ki = KdrtPu, Kp = CdrtPu, Y0 = PAg0Pu / SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu PAg0Pu "Initial generator (air gap) power in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));

equation
  connect(PAgPu, division1.u1) annotation(
    Line(points = {{-120, -54}, {-82, -54}}, color = {0, 0, 127}));
  connect(division1.y, add1.u2) annotation(
    Line(points = {{-58, -60}, {-40, -60}, {-40, -66}, {-22, -66}}, color = {0, 0, 127}));
  connect(add1.y, integrator1.u) annotation(
    Line(points = {{2, -60}, {18, -60}}, color = {0, 0, 127}));
  connect(integrator1.y, omegaGenPu) annotation(
    Line(points = {{42, -60}, {110, -60}}, color = {0, 0, 127}));
  connect(integrator1.y, add2.u2) annotation(
    Line(points = {{42, -60}, {80, -60}, {80, -6}, {42, -6}}, color = {0, 0, 127}));
  connect(integrator1.y, division1.u2) annotation(
    Line(points = {{42, -60}, {80, -60}, {80, -80}, {-90, -80}, {-90, -66}, {-82, -66}}, color = {0, 0, 127}));
  connect(add.y, integrator.u) annotation(
    Line(points = {{2, 60}, {18, 60}}, color = {0, 0, 127}));
  connect(integrator.y, omegaWTRPu) annotation(
    Line(points = {{42, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(integrator.y, add2.u1) annotation(
    Line(points = {{42, 60}, {80, 60}, {80, 6}, {42, 6}}, color = {0, 0, 127}));
  connect(PAeroPu, division.u1) annotation(
    Line(points = {{-120, 54}, {-82, 54}}, color = {0, 0, 127}));
  connect(integrator.y, division.u2) annotation(
    Line(points = {{42, 60}, {80, 60}, {80, 80}, {-90, 80}, {-90, 66}, {-82, 66}}, color = {0, 0, 127}));
  connect(division.y, add.u1) annotation(
    Line(points = {{-58, 60}, {-40, 60}, {-40, 66}, {-22, 66}}, color = {0, 0, 127}));
  connect(add2.y, pI.u) annotation(
    Line(points = {{19, 0}, {2, 0}}, color = {0, 0, 127}));
  connect(pI.y, add1.u1) annotation(
    Line(points = {{-21, 0}, {-40, 0}, {-40, -54}, {-22, -54}}, color = {0, 0, 127}));
  connect(pI.y, add.u2) annotation(
    Line(points = {{-21, 0}, {-40, 0}, {-40, 54}, {-22, 54}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram,
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-37, 81}, extent = {{-53, 49}, {127, -133}}, textString = "Mechanical"), Text(origin = {-3, -45}, extent = {{-53, 49}, {61, -39}}, textString = "Module")}, coordinateSystem(initialScale = 0.1)));
end Mechanical;
