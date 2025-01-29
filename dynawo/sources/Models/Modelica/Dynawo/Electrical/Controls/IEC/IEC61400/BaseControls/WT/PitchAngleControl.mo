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
  extends Dynawo.Electrical.Wind.IEC.Parameters.PitchAngleControl;
  
  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaWTRPu(start=SystemBase.omega0Pu) "Wind turbine rotor speed in pu (base SystemBase.omegaNom)" annotation(
    Placement(transformation(origin = {-220, 144}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start=SystemBase.omegaRef0Pu) "Wind turbine speed reference in pu (base SystemBase.omegaNom)" annotation(
    Placement(transformation(origin = {-220, 112}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput POrdPu(start=POrd0Pu) "Active power order from wind turbine controller in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-220, -72}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput pWTrefPu(start=PWTRef0Pu) "Active power reference at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-220, -110}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  
  // Output variables
  Modelica.Blocks.Interfaces.RealOutput theta(start=firstOrderTheta.Y0) "Wind turbine pitch angle in degrees" annotation(
    Placement(visible = true,transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-146, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addOmega(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-102, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainKPX(k = KPXPu)  annotation(
    Placement(visible = true, transformation(origin = {-126, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gainPiOmega(k = KPomegaPu)  annotation(
    Placement(visible = true, transformation(origin = {-16, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainPiPower(k = KPcPu) annotation(
    Placement(transformation(origin = {-24, -130}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addPiOmega annotation(
    Placement(transformation(origin = {48, 112}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addPiPower annotation(
    Placement(visible = true, transformation(origin = {50, -112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add12 annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter thetaOmegaLim(uMax = ThetaOmegamax, uMin = ThetaOmegamin, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy)  annotation(
    Placement(transformation(origin = {69, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter thetaOmegaRateLim( Falling = DThetaOmegamin,Rising = DThetaOmegamax, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 0)  annotation(
    Placement(transformation(origin = {69, 49}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.Limiter thetaOmegaLim1(uMax = ThetaCmax, uMin = ThetaCmin, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {69, -67}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter thetaOmegaRateLim1(Falling = DThetaCmin, Rising = DThetaCmax, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 0) annotation(
    Placement(transformation(origin = {69, -37}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Dynawo.NonElectrical.Blocks.Continuous.AntiWindupIntegrator integratorPiOmega( DyMax = DThetaOmegamax, DyMin = DThetaOmegamin, Y0 = 0, YMax = ThetaOmegamax, YMin = ThetaOmegamin,tI = if KIomegaPu > 1e-6 then 1 / KIomegaPu else 1 / Modelica.Constants.eps)  annotation(
    Placement(transformation(origin = {-16, 130}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.AntiWindupIntegrator integratorPiPower(DyMax = DThetaCmax, DyMin = DThetaCmin, Y0 = 0, YMax = ThetaCmax, YMin = ThetaCmin, tI = if KIcPu > 1e-6 then 1 / KIcPu else 1 / Modelica.Constants.eps) annotation(
    Placement(transformation(origin = {-26, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = false) annotation(
    Placement(visible = true, transformation(origin = {120, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderFreezeLimDetection firstOrderTheta(DyMax = DThetaMax, DyMin = DThetaMin, UseLimits = false, Y0 = 0, YMax = ThetaMax, YMin = ThetaMin, tI = TTheta)  annotation(
    Placement(visible = true, transformation(origin = {145, -1}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  
equation
  connect(omegaRefPu, addOmega.u2) annotation(
    Line(points = {{-220, 112}, {-114, 112}}, color = {0, 0, 127}));
  connect(add.y, GainKPX.u) annotation(
    Line(points = {{-135, -92}, {-126, -92}, {-126, 20}}, color = {0, 0, 127}));
  connect(gainPiOmega.u, addOmega.y) annotation(
    Line(points = {{-28, 90}, {-80, 90}, {-80, 112}, {-91, 112}}, color = {0, 0, 127}));
  connect(gainPiPower.u, add.y) annotation(
    Line(points = {{-36, -130}, {-94, -130}, {-94, -92}, {-135, -92}}, color = {0, 0, 127}));
  connect(gainPiOmega.y, addPiOmega.u2) annotation(
    Line(points = {{-4, 90}, {36, 90}, {36, 106}}, color = {0, 0, 127}));
  connect(gainPiPower.y, addPiPower.u2) annotation(
    Line(points = {{-13, -130}, {31, -130}, {31, -118}, {38, -118}}, color = {0, 0, 127}));
  connect(thetaOmegaLim.y, thetaOmegaRateLim.u) annotation(
    Line(points = {{69, 69.3}, {69, 57.3}}, color = {0, 0, 127}));
  connect(addPiOmega.y, thetaOmegaLim.u) annotation(
    Line(points = {{60, 112}, {69, 112}, {69, 85}}, color = {0, 0, 127}));
  connect(thetaOmegaRateLim.y, add12.u1) annotation(
    Line(points = {{69, 41}, {70, 41}, {70, 6}, {78, 6}}, color = {0, 0, 127}));
  connect(thetaOmegaLim1.y, thetaOmegaRateLim1.u) annotation(
    Line(points = {{69, -59.3}, {69, -45.3}}, color = {0, 0, 127}));
  connect(addPiPower.y, thetaOmegaLim1.u) annotation(
    Line(points = {{61, -112}, {70, -112}, {70, -76}}, color = {0, 0, 127}));
  connect(thetaOmegaRateLim1.y, add12.u2) annotation(
    Line(points = {{70, -30}, {68, -30}, {68, -6}, {78, -6}}, color = {0, 0, 127}));
  connect(integratorPiOmega.u, addOmega.y) annotation(
    Line(points = {{-28, 130}, {-80, 130}, {-80, 112}, {-91, 112}}, color = {0, 0, 127}));
  connect(integratorPiOmega.y, addPiOmega.u1) annotation(
    Line(points = {{-4, 130}, {26, 130}, {26, 118}, {36, 118}}, color = {0, 0, 127}));
  connect(integratorPiPower.u, add.y) annotation(
    Line(points = {{-38, -70}, {-94, -70}, {-94, -92}, {-135, -92}}, color = {0, 0, 127}));
  connect(integratorPiPower.y, addPiPower.u1) annotation(
    Line(points = {{-14, -70}, {24, -70}, {24, -106}, {38, -106}}, color = {0, 0, 127}));
  connect(omegaWTRPu, addOmega.u1) annotation(
    Line(points = {{-220, 144}, {-168, 144}, {-168, 120}, {-114, 120}}, color = {0, 0, 127}));
  connect(GainKPX.y, addOmega.u3) annotation(
    Line(points = {{-126, 44}, {-126, 104}, {-114, 104}}, color = {0, 0, 127}));
  connect(POrdPu, add.u1) annotation(
    Line(points = {{-220, -72}, {-182, -72}, {-182, -86}, {-158, -86}}, color = {0, 0, 127}));
  connect(pWTrefPu, add.u2) annotation(
    Line(points = {{-220, -110}, {-182, -110}, {-182, -98}, {-158, -98}}, color = {0, 0, 127}));
  connect(add12.y, firstOrderTheta.u) annotation(
    Line(points = {{101, 0}, {115, 0}, {115, -1}, {127, -1}}, color = {0, 0, 127}));
  connect(booleanConstant.y, firstOrderTheta.freeze) annotation(
    Line(points = {{131, 52}, {145, 52}, {145, 17}}, color = {255, 0, 255}));
  connect(firstOrderTheta.fMax, integratorPiOmega.fMax) annotation(
    Line(points = {{161.5, 8}, {174, 8}, {174, 30}, {12, 30}, {12, 104}, {-8, 104}, {-8, 118}}, color = {255, 0, 255}));
  connect(firstOrderTheta.fMin, integratorPiOmega.fMin) annotation(
    Line(points = {{161.5, -10}, {176, -10}, {176, 34}, {16, 34}, {16, 106}, {-12, 106}, {-12, 118}}, color = {255, 0, 255}));
  connect(firstOrderTheta.fMax, integratorPiPower.fMax) annotation(
    Line(points = {{161.5, 8}, {174, 8}, {174, -144}, {0, -144}, {0, -98}, {-18, -98}, {-18, -82}}, color = {255, 0, 255}));
  connect(firstOrderTheta.fMin, integratorPiPower.fMin) annotation(
    Line(points = {{161.5, -10}, {176, -10}, {176, -146}, {-2, -146}, {-2, -100}, {-22, -100}, {-22, -82}}, color = {255, 0, 255}));
  connect(firstOrderTheta.y, theta) annotation(
    Line(points = {{161.5, -1}, {210, -1}, {210, 0}}, color = {0, 0, 127}));
  
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 1}, extent = {{-98, 97}, {98, -97}}, textString = "pitch\nangle\ncontrol")}));
end PitchAngleControl;
