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

model PitchAngleControl "Wind turbine pitch angle control module from IEC 61400-27-1:2020 standard"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical.PitchAngleControlParameters;

  // Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  // Parameters from aerodynamics needed for initialisation
  parameter Types.ActivePowerPu DPThetaPu "Aerodynamic power partial derivative with respect to changes in pitch angle in pu (base SNom/degrees), example value = -0.03" annotation(
    Dialog(tab = "Aerodynamic"));
  parameter Types.ActivePowerPu PAvailPu "Available power in pu (base SNom), example value = active power setpoint" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit Theta0 "Pitch angle of the wind turbine in degrees, if not derated, example value = 0.0" annotation(
    Dialog(tab = "Aerodynamic"));

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaWTRPu(start = SystemBase.omega0Pu) "Wind turbine rotor speed in pu (base SystemBase.omegaNom)" annotation(
    Placement(transformation(origin = {-220, 160}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = OmegaRef0Pu) "Wind turbine speed reference in pu (base SystemBase.omegaNom)" annotation(
    Placement(transformation(origin = {-220, 120}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput POrdPu(start = POrd0Pu) "Active power order from wind turbine controller in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-220, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput pWTrefPu(start = PWTRef0Pu) "Active power reference at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-220, -120}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));

  // Output variable
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0 + (PAg0Pu - PAvailPu) / DPThetaPu) "Wind turbine pitch angle in degrees" annotation(
    Placement(transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 2}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(transformation(origin = {-170, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add3 addOmega(k2 = -1) annotation(
    Placement(transformation(origin = {-110, 140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain GainKPX(k = KPXPu) annotation(
    Placement(transformation(origin = {-140, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gainPiOmega(k = KPomegaPu) annotation(
    Placement(transformation(origin = {-28, 120}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gainPiPower(k = KPcPu) annotation(
    Placement(transformation(origin = {-30, -120}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addPiOmega annotation(
    Placement(transformation(origin = {50, 140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addPiPower annotation(
    Placement(transformation(origin = {50, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add12 annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter thetaOmegaLim(uMax = ThetaOmegaMax, uMin = ThetaOmegaMin, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {80, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter thetaOmegaRateLim(Falling = DThetaOmegaMin, Rising = DThetaOmegaMax, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = Theta0 + (PAg0Pu - PAvailPu) / DPThetaPu, y(start = thetaOmegaRateLim.y_start)) annotation(
    Placement(transformation(origin = {80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.Limiter thetaOmegaLim1(uMax = ThetaCMax, uMin = ThetaCMin, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {80, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter thetaOmegaRateLim1(Falling = DThetaCMin, Rising = DThetaCMax, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 0, y(start = thetaOmegaRateLim1.y_start)) annotation(
    Placement(transformation(origin = {80, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.NonElectrical.Blocks.Continuous.AntiWindupIntegrator integratorPiOmega(DyMax = DThetaOmegaMax, DyMin = DThetaOmegaMin, Y0 = Theta0 + (PAg0Pu - PAvailPu) / DPThetaPu, YMax = ThetaOmegaMax, YMin = ThetaOmegaMin, tI = if KIomegaPu > 1e-6 then 1/KIomegaPu else 1/Modelica.Constants.eps) annotation(
    Placement(transformation(origin = {-30, 160}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.AntiWindupIntegrator integratorPiPower(DyMax = DThetaCMax, DyMin = DThetaCMin, Y0 = 0, YMax = ThetaCMax, YMin = ThetaCMin, tI = if KIcPu > 1e-6 then 1/KIcPu else 1/Modelica.Constants.eps) annotation(
    Placement(transformation(origin = {-30, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = false) annotation(
    Placement(transformation(origin = {130, 70}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderFreezeLimDetection firstOrderTheta(DyMax = DThetaMax, DyMin = DThetaMin, UseLimits = false, Y0 = Theta0 + (PAg0Pu - PAvailPu) / DPThetaPu, YMax = ThetaMax, YMin = ThetaMin, tI = TTheta) annotation(
    Placement(transformation(origin = {150, -1.77636e-15}, extent = {{-10, -10}, {10, 10}})));

  //Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu PAg0Pu "Initial generator (air gap) power in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.ActivePower PWTRef0Pu "Initial upper power limit of the wind turbine (if less than PAvail then the turbine will be derated) in pu (base SNom), example value = 1.1" annotation(
  Dialog(tab = "Operating point"));

  parameter Types.PerUnit OmegaRef0Pu "Initial value for omegaRef (output of omega(p) characteristic) in pu (base SystemBase.omegaRef0Pu)" annotation(
    Dialog(tab = "Initialization"));
  final parameter Types.ActivePowerPu POrd0Pu = -P0Pu * SystemBase.SnRef / SNom "Initial active power order in pu (base SNom) (generator convention)" annotation(
  Dialog(tab = "Initialization"));

equation
  connect(omegaRefPu, addOmega.u2) annotation(
    Line(points = {{-220, 120}, {-161, 120}, {-161, 140}, {-122, 140}}, color = {0, 0, 127}));
  connect(add.y, GainKPX.u) annotation(
    Line(points = {{-159, -100}, {-139.25, -100}, {-139.25, -2}, {-140, -2}}, color = {0, 0, 127}));
  connect(gainPiOmega.u, addOmega.y) annotation(
    Line(points = {{-40, 120}, {-80, 120}, {-80, 140}, {-99, 140}}, color = {0, 0, 127}));
  connect(gainPiPower.u, add.y) annotation(
    Line(points = {{-42, -120}, {-80, -120}, {-80, -100}, {-159, -100}}, color = {0, 0, 127}));
  connect(gainPiOmega.y, addPiOmega.u2) annotation(
    Line(points = {{-17, 120}, {19.25, 120}, {19.25, 134}, {38, 134}}, color = {0, 0, 127}));
  connect(gainPiPower.y, addPiPower.u2) annotation(
    Line(points = {{-19, -120}, {19.5, -120}, {19.5, -106}, {38, -106}}, color = {0, 0, 127}));
  connect(thetaOmegaLim.y, thetaOmegaRateLim.u) annotation(
    Line(points = {{80, 79}, {80, 62}}, color = {0, 0, 127}));
  connect(addPiOmega.y, thetaOmegaLim.u) annotation(
    Line(points = {{61, 140}, {79.5, 140}, {79.5, 102}, {80, 102}}, color = {0, 0, 127}));
  connect(thetaOmegaRateLim.y, add12.u1) annotation(
    Line(points = {{80, 39}, {80, 6}, {98, 6}}, color = {0, 0, 127}));
  connect(thetaOmegaLim1.y, thetaOmegaRateLim1.u) annotation(
    Line(points = {{80, -59}, {80, -42}}, color = {0, 0, 127}));
  connect(addPiPower.y, thetaOmegaLim1.u) annotation(
    Line(points = {{61, -100}, {80, -100}, {80, -82}}, color = {0, 0, 127}));
  connect(thetaOmegaRateLim1.y, add12.u2) annotation(
    Line(points = {{80, -19}, {80, -6}, {98, -6}}, color = {0, 0, 127}));
  connect(integratorPiOmega.u, addOmega.y) annotation(
    Line(points = {{-42, 160}, {-79.5, 160}, {-79.5, 140}, {-99, 140}}, color = {0, 0, 127}));
  connect(integratorPiOmega.y, addPiOmega.u1) annotation(
    Line(points = {{-19, 160}, {20, 160}, {20, 146}, {38, 146}}, color = {0, 0, 127}));
  connect(integratorPiPower.u, add.y) annotation(
    Line(points = {{-42, -80}, {-80, -80}, {-80, -100}, {-159, -100}}, color = {0, 0, 127}));
  connect(integratorPiPower.y, addPiPower.u1) annotation(
    Line(points = {{-19, -80}, {20, -80}, {20, -94}, {38, -94}}, color = {0, 0, 127}));
  connect(omegaWTRPu, addOmega.u1) annotation(
    Line(points = {{-220, 160}, {-160, 160}, {-160, 148}, {-122, 148}}, color = {0, 0, 127}));
  connect(GainKPX.y, addOmega.u3) annotation(
    Line(points = {{-140, 21}, {-140, 132}, {-122, 132}}, color = {0, 0, 127}));
  connect(POrdPu, add.u1) annotation(
    Line(points = {{-220, -80}, {-193, -80}, {-193, -94}, {-182, -94}}, color = {0, 0, 127}));
  connect(pWTrefPu, add.u2) annotation(
    Line(points = {{-220, -120}, {-194, -120}, {-194, -106}, {-182, -106}}, color = {0, 0, 127}));
  connect(add12.y, firstOrderTheta.u) annotation(
    Line(points = {{121, 0}, {138, 0}}, color = {0, 0, 127}));
  connect(booleanConstant.y, firstOrderTheta.freeze) annotation(
    Line(points = {{141, 70}, {141, 69}, {150, 69}, {150, 12}}, color = {255, 0, 255}));
  connect(firstOrderTheta.fMax, integratorPiOmega.fMax) annotation(
    Line(points = {{161, 6}, {174, 6}, {174, 126}, {-22, 126}, {-22, 148}}, color = {255, 0, 255}));
  connect(firstOrderTheta.fMin, integratorPiOmega.fMin) annotation(
    Line(points = {{161, -6}, {180, -6}, {180, 110}, {-26, 110}, {-26, 148}}, color = {255, 0, 255}));
  connect(firstOrderTheta.fMax, integratorPiPower.fMax) annotation(
    Line(points = {{161, 6}, {174, 6}, {174, -118}, {-22, -118}, {-22, -92}}, color = {255, 0, 255}));
  connect(firstOrderTheta.fMin, integratorPiPower.fMin) annotation(
    Line(points = {{161, -6}, {180, -6}, {180, -128}, {-26, -128}, {-26, -92}}, color = {255, 0, 255}));
  connect(firstOrderTheta.y, theta) annotation(
    Line(points = {{162, 0}, {210, 0}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 1}, extent = {{-98, 97}, {98, -97}}, textString = "pitch\nangle\ncontrol")}));
end PitchAngleControl;
