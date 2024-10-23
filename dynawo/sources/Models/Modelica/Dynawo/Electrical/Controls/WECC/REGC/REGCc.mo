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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model REGCc "WECC Generator Converter REGC type C"
  extends Dynawo.Electrical.Controls.WECC.REGC.BaseClasses.BaseREGC(rateLimFirstOrderFreeze2.T = 1e-5, rateLimFirstOrderFreeze2.UseRateLim = true, rateLimFirstOrderFreeze1.T = 1e-5, rateLimFirstOrderFreeze1.UseRateLim = true, rateLimFirstOrderFreeze1.Y0 = Id0Pu * UInj0Pu, rateLimFirstOrderFreeze2.Y0 = Iq0Pu);
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsVSourceRef;

  // REGC-C Parameters
  parameter Types.PerUnit IMaxPu "Maximum current rating of the converter in pu (base SNom, UNom)" annotation(
  Dialog(tab="Generator Converter"));
  parameter Types.PerUnit Kii "Integrator gain of the inner current loop" annotation(
  Dialog(tab="Generator Converter"));
  parameter Types.PerUnit Kip "Proportional gain of the inner current loop" annotation(
  Dialog(tab="Generator Converter"));
  parameter Types.PerUnit KiPLL "PLL integrator gain" annotation(
  Dialog(tab="Generator Converter"));
  parameter Types.PerUnit KpPLL "PLL proportional gain" annotation(
  Dialog(tab="Generator Converter"));
  parameter Types.PerUnit OmegaMaxPu "Upper frequency limit in pu (base OmegaNom)" annotation(
  Dialog(tab="Generator Converter"));
  parameter Types.PerUnit OmegaMinPu "Lower frequency limit in pu (base OmegaNom)" annotation(
  Dialog(tab="Generator Converter"));
  parameter Boolean RateFlag "Active current (=false) or active power (=true) ramp (if unkown set to false)" annotation(
  Dialog(tab="Generator Converter"));

  // Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput iInjPu(im(start = iInj0Pu.im), re(start = iInj0Pu.re)) "Complex current at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, -111}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IMaxPu) "p-axis maximum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {160, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 112}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput ipMinPu(start = -IMaxPu) "p-axis minimum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {160, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, 111}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqMaxPu(start = IMaxPu) "q-axis maximum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {120, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-21, 112}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqMinPu(start = -IMaxPu) "q-axis minimum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {120, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-51, 112}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uInjPu(im(start = uInj0Pu.im), re(start = uInj0Pu.re)) "Complex voltage at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {9, -111}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput urSource(start = uSource0Pu.re) "Real voltage at source in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {310, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {109, 39}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uiSource(start = uSource0Pu.im) "Imaginary voltage at source in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {310, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {111, -57}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
  Dynawo.Electrical.Controls.WECC.BaseControls.VSourceRef vSourceRef(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, RSourcePu = RSourcePu, UdInj0Pu = UdInj0Pu, UqInj0Pu = UqInj0Pu, XSourcePu = XSourcePu, tE = tE, uInj0Pu = uInj0Pu, uSource0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {259.5, 4.5}, extent = {{-25.5, -25.5}, {25.5, 25.5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {100, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {159, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(visible = true, transformation(origin = {50, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupVariableLimits pIAntiWindupVariableLimits(Ki = Kii, Kp = Kip, Y0 = Iq0Pu - IInjq0Pu) annotation(
    Placement(visible = true, transformation(origin = {160, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupVariableLimits pIAntiWindupVariableLimits1(Ki = Kii, Kp = Kip, Y0 = Id0Pu - IInjd0Pu)  annotation(
    Placement(visible = true, transformation(origin = {200, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-19, -5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRefPu(k = SystemBase.omegaRef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ComplexCurrentPu iInj0Pu "Start value of complex current at injector in pu (base SNom, UNom)";
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage injector in pu (base UNom)";
  parameter Types.ComplexVoltagePu uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage injector in pu (base UNom)";
  parameter Types.ComplexVoltagePu uSource0Pu "Start value of complex voltage at source in pu (base UNom)";

  final parameter Types.PerUnit IInjd0Pu = ComplexMath.real(iInj0Pu) * cos(Phi0) + ComplexMath.imag(iInj0Pu) * sin(Phi0) "Start value of d-axis injector current in pu (SNom, UNom)";
  final parameter Types.PerUnit IInjq0Pu = (-ComplexMath.real(iInj0Pu) * sin(Phi0)) + ComplexMath.imag(iInj0Pu) * cos(Phi0) "Start value of q-axis injector current in pu (SNom, UNom)";
  final parameter Types.PerUnit Phi0 = Modelica.ComplexMath.arg(uInj0Pu) "Start value of voltage phase at injector in rad";

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
    Line(points = {{-210, -20}, {80, -20}, {80, -50}, {259.5, -50}, {259.5, -24}}, color = {85, 170, 255}));
  connect(iInjPu, transformRItoDQ.uPu) annotation(
    Line(points = {{-210, 20}, {27, 20}, {27, 12}, {39, 12}}, color = {85, 170, 255}));
  connect(rateLimFirstOrderFreeze2.y, add.u1) annotation(
    Line(points = {{21, 100}, {60, 100}, {60, 106}, {88, 106}}, color = {0, 0, 127}));
  connect(transformRItoDQ.ydPu, add.u2) annotation(
    Line(points = {{61, 12}, {80, 12}, {80, 94}, {88, 94}}, color = {0, 0, 127}));
  connect(vSourceRef.uiSourcePu, uiSource) annotation(
    Line(points = {{288, -5}, {294, -5}, {294, -60}, {310, -60}}, color = {0, 0, 127}));
  connect(vSourceRef.urSourcePu, urSource) annotation(
    Line(points = {{288, 15}, {295, 15}, {295, 60}, {310, 60}}, color = {0, 0, 127}));
  connect(add.y, pIAntiWindupVariableLimits.u) annotation(
    Line(points = {{111, 100}, {148, 100}}, color = {0, 0, 127}));
  connect(pIAntiWindupVariableLimits.y, vSourceRef.iqPu) annotation(
    Line(points = {{171, 100}, {220, 100}, {220, 15}, {231, 15}}, color = {0, 0, 127}));
  connect(add1.y, pIAntiWindupVariableLimits1.u) annotation(
    Line(points = {{170, -90}, {188, -90}}, color = {0, 0, 127}));
  connect(pIAntiWindupVariableLimits1.y, vSourceRef.idPu) annotation(
    Line(points = {{211, -90}, {220, -90}, {220, -11}, {231, -11}}, color = {0, 0, 127}));
  connect(transformRItoDQ.yqPu, add1.u1) annotation(
    Line(points = {{61, 0}, {140, 0}, {140, -84}, {147, -84}}, color = {0, 0, 127}));
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
  connect(pll.omegaPLLPu, transformRItoDQ.phi) annotation(
    Line(points = {{-8, 0}, {39, 0}}, color = {0, 0, 127}));
  connect(uInjPu, pll.uPu) annotation(
    Line(points = {{-210, -20}, {-60, -20}, {-60, 1}, {-30, 1}}, color = {85, 170, 255}));
  connect(OmegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-49, -40}, {-39, -40}, {-39, -11}, {-30, -11}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-200, -180}, {300, 180}}, initialScale = 0.2, grid = {1, 1})),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-27, 18}, extent = {{-53, 60}, {107, -100}}, textString = "REGC C"), Text(origin = {143, 49}, extent = {{-22, 16}, {36, -28}}, textString = "urSourcePu"), Text(origin = {145, -50}, extent = {{-22, 16}, {36, -28}}, textString = "uiSourcePu"), Text(origin = {4, -134}, extent = {{-19, 14}, {30, -24}}, textString = "uInjPu"), Text(origin = {-167, 103}, extent = {{-22, 16}, {36, -28}}, textString = "OmegaPLLPu"), Text(origin = {74, -135}, extent = {{-19, 14}, {30, -24}}, textString = "iInjPu"), Text(origin = {-96, 143}, extent = {{-22, 16}, {36, -28}}, textString = "iqMaxPu"), Text(origin = {-28, 143}, extent = {{-22, 16}, {36, -28}}, textString = "iqMinPu"), Text(origin = {92, 143}, extent = {{-22, 16}, {36, -28}}, textString = "ipMaxPu"), Text(origin = {33, 142}, extent = {{-22, 16}, {36, -28}}, textString = "ipMinPu")}),
  Documentation(info = "<html><head></head><body><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The block calculates the final setpoints for Iq and Id.</span><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">It is&nbsp;</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">connected to the grid with a voltage source interface through urSource and uiSource.</span></div></body></html>"));
end REGCc;
