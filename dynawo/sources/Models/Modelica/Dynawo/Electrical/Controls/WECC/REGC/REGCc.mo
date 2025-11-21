within Dynawo.Electrical.Controls.WECC.REGC;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model REGCc "WECC Generator Converter REGC type C"
  extends Dynawo.Electrical.Controls.WECC.REGC.BaseClasses.BaseREGC(rateLimFirstOrderFreeze2.T = 1e-6, rateLimFirstOrderFreeze2.UseRateLim = true, rateLimFirstOrderFreeze1.T = 1e-6, rateLimFirstOrderFreeze1.UseRateLim = true, rateLimFirstOrderFreeze1.Y0 = Id0Pu * UInj0Pu, rateLimFirstOrderFreeze2.Y0 = Iq0Pu);
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGCc;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsVSourceRef;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput iInjPu(im(start = iInj0Pu.im), re(start = iInj0Pu.re)) "Complex current at injector in pu (base SnRef, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -109}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IMaxPu) "p-axis maximum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {160, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput ipMinPu(start = - IMaxPu) "p-axis minimum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {160, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {20, 109}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqMaxPu(start = IMaxPu) "q-axis maximum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {120, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-21, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqMinPu(start = - IMaxPu) "q-axis minimum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {120, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-61, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput phi(start = Modelica.ComplexMath.arg(uInj0Pu)) "Voltage phase at injector in rad" annotation(
    Placement(visible = true, transformation(origin = {-210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uInjPu(im(start = uInj0Pu.im), re(start = uInj0Pu.re)) "Complex voltage at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {257, -190}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {79, -109}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput urSource(start = uSource0Pu.re) "Real voltage at source in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {310, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {109, 39}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uiSource(start = uSource0Pu.im) "Imaginary voltage at source in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {310, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {109, -41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-60, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UNomFix(k = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -99}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-19, -120}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant RateFlag0(k = RateFlag) annotation(
    Placement(visible = true, transformation(origin = {-150, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, limitsAtInit = true, uMax = 999, uMin = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-99, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {120, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VSourceRef vSourceRef(Id0Pu =  Id0Pu, Iq0Pu =  -Iq0Pu, RSourcePu = RSourcePu, UdInj0Pu = UdInj0Pu, UqInj0Pu = UqInj0Pu, XSourcePu = XSourcePu, tE = tE, uInj0Pu = uInj0Pu, uSource0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {255.5, 0.5}, extent = {{-25.5, -25.5}, {25.5, 25.5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {100, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {159, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(visible = true, transformation(origin = {50, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupVariableLimits pIAntiWindupVariableLimits(Ki = Kii, Kp = Kip, Y0 =  -Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {160, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupVariableLimits pIAntiWindupVariableLimits1(Ki = Kii, Kp = Kip, Y0 =  Id0Pu)  annotation(
    Placement(visible = true, transformation(origin = {200, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {109, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {69, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain3(k = -1) annotation(
    Placement(visible = true, transformation(origin = {50, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ComplexCurrentPu iInj0Pu "Start value of complex current at injector in pu (base SnRef, UNom) (generator convention)";
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage injector in pu (base UNom)";
  parameter Types.ComplexVoltagePu uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage injector in pu (base UNom)";
  parameter Types.ComplexVoltagePu uSource0Pu "Start value of complex voltage at source in pu (base UNom)";

equation
  connect(RateFlag0.y, switch.u2) annotation(
    Line(points = {{-139, -70}, {-90, -70}, {-90, -80}, {-72, -80}}, color = {255, 0, 255}));
  connect(switch.y, division.u2) annotation(
    Line(points = {{-49, -80}, {30.5, -80}, {30.5, -96}, {108, -96}}, color = {0, 0, 127}));
  connect(limiter.y, switch.u1) annotation(
    Line(points = {{-88, -40}, {-80, -40}, {-80, -72}, {-72, -72}}, color = {0, 0, 127}));
  connect(UNomFix.y, switch.u3) annotation(
    Line(points = {{-109, -99}, {-101, -99}, {-101, -88}, {-72, -88}}, color = {0, 0, 127}));
  connect(switch.y, product.u2) annotation(
    Line(points = {{-49, -80}, {-39, -80}, {-39, -114}, {-31, -114}}, color = {0, 0, 127}));
  connect(product.y, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{-8, -120}, {48, -120}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze1.y, division.u1) annotation(
    Line(points = {{71, -120}, {92, -120}, {92, -84}, {108, -84}}, color = {0, 0, 127}));
  connect(firstOrder.y, limiter.u) annotation(
    Line(points = {{-139, -40}, {-111, -40}}, color = {0, 0, 127}));
  connect(uInjPu, vSourceRef.uInjPu) annotation(
    Line(points = {{257, -190}, {257, -68}, {255.5, -68}, {255.5, -28}}, color = {85, 170, 255}));
  connect(iInjPu, transformRItoDQ.u) annotation(
    Line(points = {{-210, 20}, {39, 20}}, color = {85, 170, 255}));
  connect(vSourceRef.uiSourcePu, uiSource) annotation(
    Line(points = {{284, -9}, {284, -9.75}, {290, -9.75}, {290, -60}, {310, -60}}, color = {0, 0, 127}));
  connect(vSourceRef.urSourcePu, urSource) annotation(
    Line(points = {{284, 11}, {284, 10.5}, {290, 10.5}, {290, 60}, {310, 60}}, color = {0, 0, 127}));
  connect(add.y, pIAntiWindupVariableLimits.u) annotation(
    Line(points = {{111, 100}, {148, 100}}, color = {0, 0, 127}));
  connect(add1.y, pIAntiWindupVariableLimits1.u) annotation(
    Line(points = {{170, -90}, {188, -90}}, color = {0, 0, 127}));
  connect(pIAntiWindupVariableLimits1.y, vSourceRef.idPu) annotation(
    Line(points = {{211, -90}, {220, -90}, {220, -15}, {227, -15}}, color = {0, 0, 127}));
  connect(division.y, add1.u2) annotation(
    Line(points = {{131, -90}, {140, -90}, {140, -96}, {147, -96}}, color = {0, 0, 127}));
  connect(ipMinPu, pIAntiWindupVariableLimits1.limitMin) annotation(
    Line(points = {{160, -120}, {179, -120}, {179, -96}, {188, -96}}, color = {0, 0, 127}));
  connect(ipMaxPu, pIAntiWindupVariableLimits1.limitMax) annotation(
    Line(points = {{160, -60}, {179, -60}, {179, -84}, {188, -84}}, color = {0, 0, 127}));
  connect(iqMinPu, pIAntiWindupVariableLimits.limitMin) annotation(
    Line(points = {{120, 70}, {140, 70}, {140, 94}, {148, 94}}, color = {0, 0, 127}));
  connect(iqMaxPu, pIAntiWindupVariableLimits.limitMax) annotation(
    Line(points = {{120, 130}, {140, 130}, {140, 106}, {148, 106}}, color = {0, 0, 127}));
  connect(idCmdPu, product.u1) annotation(
    Line(points = {{-210, -120}, {-40, -120}, {-40, -126}, {-31, -126}}, color = {0, 0, 127}));
  connect(phi, transformRItoDQ.phi) annotation(
    Line(points = {{-210, 0}, {-85.5, 0}, {-85.5, 8}, {39, 8}}, color = {0, 0, 127}));
  connect(phi, vSourceRef.phi) annotation(
    Line(points = {{-210, 0}, {227, 0}}, color = {0, 0, 127}));
  connect(transformRItoDQ.uq, gain1.u) annotation(
    Line(points = {{61, 8}, {69, 8}, {69, 40}}, color = {0, 0, 127}));
  connect(gain1.y, add.u2) annotation(
    Line(points = {{69, 63}, {70, 63}, {70, 94}, {88, 94}}, color = {0, 0, 127}));
  connect(transformRItoDQ.ud, gain.u) annotation(
    Line(points = {{61, 20}, {97, 20}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{120, 20}, {140, 20}, {140, -84}, {147, -84}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze2.y, gain3.u) annotation(
    Line(points = {{21, 100}, {38, 100}}, color = {0, 0, 127}));
  connect(gain3.y, add.u1) annotation(
    Line(points = {{61, 100}, {72, 100}, {72, 106}, {88, 106}}, color = {0, 0, 127}));
  connect(pIAntiWindupVariableLimits.y, vSourceRef.iqPu) annotation(
    Line(points = {{171, 100}, {220, 100}, {220, 16}, {227, 16}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-200, -180}, {300, 180}}, initialScale = 0.2, grid = {1, 1})),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-27, 18}, extent = {{-53, 60}, {107, -100}}, textString = "REGC C"), Text(origin = {143, 49}, extent = {{-22, 16}, {36, -28}}, textString = "urSourcePu"), Text(origin = {143, -34}, extent = {{-22, 16}, {36, -28}}, textString = "uiSourcePu"), Text(origin = {74, -132}, extent = {{-19, 14}, {30, -24}}, textString = "uInjPu"), Text(origin = {-2, -135}, extent = {{-19, 14}, {30, -24}}, textString = "iInjPu"), Text(origin = {-32, 139}, extent = {{-22, 16}, {36, -28}}, textString = "iqMaxPu"), Text(origin = {-94, 137}, extent = {{-22, 16}, {36, -28}}, textString = "iqMinPu"), Text(origin = {86, 137}, extent = {{-22, 16}, {36, -28}}, textString = "ipMaxPu"), Text(origin = {25, 138}, extent = {{-22, 16}, {36, -28}}, textString = "ipMinPu"), Text(origin = {-150, 97}, extent = {{-10, 8}, {16, -14}}, textString = "phi")}),
  Documentation(info = "<html><head></head><body><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The block calculates the final setpoints for Iq and Id.</span><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">It is&nbsp;</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">connected to the grid with a voltage source interface through urSource and uiSource.</span></div></body></html>"));
end REGCc;
