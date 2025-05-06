within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/
  
model Aerodynamic2D "Two-dimensional aerodynmaic module for type 3 wind turbines (IEC N°61400-27-1:2020)"

  // parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.Aerodynamic2D;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPAg;

  // inputs
  Modelica.Blocks.Interfaces.RealInput omegaWTRPu(start=SystemBase.omega0Pu) "Wind turbine rotor speed in pu (base SystemBase.omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput theta(start=Theta0) "Wind turbine pitch angle in degrees" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  
  //outputs
  Modelica.Blocks.Interfaces.RealOutput pAeroPu(start=PAg0Pu) "Wind turbine aerodynamic power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Math.Add addDPOmega(k2 = +1, k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-18, -30}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Add addOmega(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-38, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addP annotation(
    Placement(visible = true, transformation(origin = {68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addTheta(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-36, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constDPOmega0Pu(k = DPOmega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-35, -47}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constOmega0Pu(k = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-78, -84}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constPAvailPu(k =  PAvailPu) annotation(
    Placement(visible = true, transformation(origin = {19, 1}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constTheta0(k = Theta0) annotation(
    Placement(visible = true, transformation(origin = {-70, 42}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainDPOmegaThetaPu(k = DPOmegaThetaPu) annotation(
    Placement(visible = true, transformation(origin = {-68, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainDPThetaPu(k = DPThetaPu) annotation(
    Placement(visible = true, transformation(origin = {22, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product productPOmega annotation(
    Placement(visible = true, transformation(origin = {28, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(addTheta.y, gainDPThetaPu.u) annotation(
    Line(points = {{-25, 54}, {10, 54}}, color = {0, 0, 127}));
  connect(constPAvailPu.y, addP.u2) annotation(
    Line(points = {{27, 1}, {44.5, 1}, {44.5, 0}, {56, 0}}, color = {0, 0, 127}));
  connect(gainDPThetaPu.y, addP.u1) annotation(
    Line(points = {{33, 54}, {44, 54}, {44, 8}, {56, 8}}, color = {0, 0, 127}));
  connect(omegaWTRPu, addOmega.u1) annotation(
    Line(points = {{-120, -60}, {-94, -60}, {-94, -72}, {-50, -72}}, color = {0, 0, 127}));
  connect(constOmega0Pu.y, addOmega.u2) annotation(
    Line(points = {{-69, -84}, {-50, -84}}, color = {0, 0, 127}));
  connect(theta, addTheta.u1) annotation(
    Line(points = {{-120, 60}, {-48, 60}}, color = {0, 0, 127}));
  connect(addP.y, pAeroPu) annotation(
    Line(points = {{79, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(theta, gainDPOmegaThetaPu.u) annotation(
    Line(points = {{-120, 60}, {-88, 60}, {-88, -26}, {-80, -26}}, color = {0, 0, 127}));
  connect(addOmega.y, productPOmega.u2) annotation(
    Line(points = {{-27, -78}, {-12, -78}, {-12, -42}, {10, -42}}, color = {0, 0, 127}));
  connect(productPOmega.y, addP.u3) annotation(
    Line(points = {{39, -36}, {46, -36}, {46, -8}, {56, -8}}, color = {0, 0, 127}));
  connect(gainDPOmegaThetaPu.y, addDPOmega.u1) annotation(
    Line(points = {{-57, -26}, {-25, -26}}, color = {0, 0, 127}));
  connect(constDPOmega0Pu.y, addDPOmega.u2) annotation(
    Line(points = {{-35, -39}, {-35, -34}, {-25, -34}}, color = {0, 0, 127}));
  connect(addDPOmega.y, productPOmega.u1) annotation(
    Line(points = {{-11, -30}, {16, -30}}, color = {0, 0, 127}));
  connect(constTheta0.y, addTheta.u2) annotation(
    Line(points = {{-61, 42}, {-54.5, 42}, {-54.5, 48}, {-48, 48}}, color = {0, 0, 127}));
  
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Text(origin = {0, 4}, extent = {{-98, 86}, {98, -86}}, textString = "Aero
dynamic
2d"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end Aerodynamic2D;
