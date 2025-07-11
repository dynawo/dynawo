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
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical.Aerodynamic2DParameters;

  //Input variable
  Modelica.Blocks.Interfaces.RealInput omegaWTRPu(start = SystemBase.omega0Pu) "Wind turbine rotor speed in pu (base SystemBase.omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0 + (PAg0Pu - PAvailPu) / DPThetaPu) "Wind turbine pitch angle in degrees" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput pAeroPu(start = PAg0Pu) "Wind turbine aerodynamic power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add addDPOmega(k2 = +1, k1 = -1) annotation(
    Placement(transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addOmega(k2 = -1) annotation(
    Placement(transformation(origin = {-30, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add3 addP annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addTheta(k2 = -1) annotation(
    Placement(transformation(origin = {-30, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constDPOmega0Pu(k = DPOmega0Pu) annotation(
    Placement(transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constOmega0Pu(k = SystemBase.omega0Pu) annotation(
    Placement(transformation(origin = {-70, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constPAvailPu(k = PAvailPu) annotation(
    Placement(transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constTheta0(k = Theta0) annotation(
    Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gainDPOmegaThetaPu(k = DPOmegaThetaPu) annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gainDPThetaPu(k = DPThetaPu) annotation(
    Placement(transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product productPOmega annotation(
    Placement(transformation(origin = {10, -40}, extent = {{-10, -10}, {10, 10}})));

  //Initial parameters
  parameter Types.PerUnit IGsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Initialization"));
  parameter Types.PerUnit IGsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Initialization"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu PAg0Pu "Initial generator (air gap) power in pu (base SNom) (generator convention)" annotation(
      Dialog(tab = "Initialization"));
  parameter Types.PerUnit UGsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
      Dialog(tab = "Initialization"));
  parameter Types.PerUnit UGsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
      Dialog(tab = "Initialization"));

equation
  connect(addTheta.y, gainDPThetaPu.u) annotation(
    Line(points = {{-19, 60}, {-2, 60}}, color = {0, 0, 127}));
  connect(constPAvailPu.y, addP.u2) annotation(
    Line(points = {{21, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(gainDPThetaPu.y, addP.u1) annotation(
    Line(points = {{21, 60}, {40, 60}, {40, 8}, {58, 8}}, color = {0, 0, 127}));
  connect(omegaWTRPu, addOmega.u1) annotation(
    Line(points = {{-120, -60}, {-94, -60}, {-94, -74}, {-42, -74}}, color = {0, 0, 127}));
  connect(constOmega0Pu.y, addOmega.u2) annotation(
    Line(points = {{-59, -90}, {-55.5, -90}, {-55.5, -86}, {-42, -86}}, color = {0, 0, 127}));
  connect(theta, addTheta.u1) annotation(
    Line(points = {{-120, 60}, {-88, 60}, {-88, 66}, {-42, 66}}, color = {0, 0, 127}));
  connect(addP.y, pAeroPu) annotation(
    Line(points = {{81, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(theta, gainDPOmegaThetaPu.u) annotation(
    Line(points = {{-120, 60}, {-88, 60}, {-88, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(addOmega.y, productPOmega.u2) annotation(
    Line(points = {{-19, -80}, {-12, -80}, {-12, -46}, {-2, -46}}, color = {0, 0, 127}));
  connect(productPOmega.y, addP.u3) annotation(
    Line(points = {{21, -40}, {46, -40}, {46, -8}, {58, -8}}, color = {0, 0, 127}));
  connect(gainDPOmegaThetaPu.y, addDPOmega.u1) annotation(
    Line(points = {{-59, 0}, {-50.5, 0}, {-50.5, -14}, {-42, -14}}, color = {0, 0, 127}));
  connect(constDPOmega0Pu.y, addDPOmega.u2) annotation(
    Line(points = {{-50, -39}, {-50, -26.75}, {-42, -26.75}, {-42, -26}}, color = {0, 0, 127}));
  connect(addDPOmega.y, productPOmega.u1) annotation(
    Line(points = {{-19, -20}, {-7.5, -20}, {-7.5, -34}, {-2, -34}}, color = {0, 0, 127}));
  connect(constTheta0.y, addTheta.u2) annotation(
    Line(points = {{-59, 40}, {-54.5, 40}, {-54.5, 54}, {-42, 54}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Text(origin = {0, 4}, extent = {{-98, 86}, {98, -86}}, textString = "Aero
dynamic
2d"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end Aerodynamic2D;
