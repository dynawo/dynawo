within Dynawo.Electrical.Controls.IEC.IEC63406.Measurement;

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

model PLL "Phase-Locked-Loop (IEC 63406)"

  //Nominal parameters
  parameter Types.Time tS "Integration time step in s";

  //Parameters
  parameter Types.Time DeltaT "Time step of the simulation" annotation(
    Dialog(tab = "PLL"));
  parameter Types.AngularVelocityPu DfMaxPu "Maximum angle rotation ramp rate in rad/s" annotation(
    Dialog(tab = "PLL"));
  parameter Real KPpll "Proportional gain in PI controller" annotation(
    Dialog(tab = "PLL"));
  parameter Real KIpll "Integral gain in PI controller" annotation(
    Dialog(tab = "PLL"));
  parameter Integer PLLFlag "0 for the case when the phase angle can be read from the calculation result of the simulation program, 1 for the case of adding a filter based on case 1, 2 for the case where the dynamics of the PLL need to be considered" annotation(
    Dialog(tab = "PLL"));
  parameter Types.Time TpllFilt "Time constant in PLL angle filter. Put 0 if no filter for the PLL (PLLFlag=2 in the norm)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.Time TfFilt "Time constant in PLL angle filter. Put 0 if no filter for the PLL (PLLFlag=2 in the norm)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit UpllPu "Voltage below which the frequency of the voltage is filtered and the angle of the voltage is possibly frozen" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit WMaxPu "Maximum PLL frequency deviation in pu (base rated frequency)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit WMinPu "Minimum PLL frequency deviation in pu (base rated frequency)" annotation(
    Dialog(tab = "PLL"));

  //Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-112, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput fMeasPu(start = 1) "Measured frequency outputted by the phase-locked loop  in pu (base nominal frequency in Hz)" annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput thetaPLL(start=UPhase0) "Phase angle outputted by phase-locked loop" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = TpllFilt, y_start = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y = PLLFlag) annotation(
    Placement(visible = true, transformation(origin = {80, 80}, extent = {{-14, -10}, {14, 10}}, rotation = -90)));
  Modelica.ComplexBlocks.Sources.ComplexExpression complexExpr(y = Complex(0, 0)) annotation(
    Placement(visible = true, transformation(origin = {-92, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Logical.Switch switch11 annotation(
    Placement(visible = true, transformation(origin = {22, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.AuxiliaryBlocks.SwitchComplex switch12 annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = Dynawo.Electrical.SystemBase.omegaNom) annotation(
    Placement(visible = true, transformation(origin = {-20, -102}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-38, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = TfFilt) annotation(
    Placement(visible = true, transformation(origin = {-68, -88}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Complex.ComplexToPolar complexToPolar1 annotation(
    Placement(visible = true, transformation(origin = {-50, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression3(y = 1) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{10, -6}, {-10, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(visible = true, transformation(origin = {60, -58}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gain2(k = 1 / Dynawo.Electrical.SystemBase.omegaNom) annotation(
    Placement(visible = true, transformation(origin = {42, -40}, extent = {{8, -8}, {-8, 8}}, rotation = 180)));
  Modelica.Blocks.Continuous.Derivative derivative annotation(
    Placement(visible = true, transformation(origin = {80, -20}, extent = {{-8, -8}, {8, 8}}, rotation = 180)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = UpllPu) annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y(fixed = true), y_start = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {48, 6}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = 1 / Dynawo.Electrical.SystemBase.omegaNom) annotation(
    Placement(visible = true, transformation(origin = {28, -80}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression annotation(
    Placement(visible = true, transformation(origin = {12, -28}, extent = {{-8, -8}, {8, 8}}, rotation = 90)));
  Dynawo.NonElectrical.Blocks.Continuous.LimitedPI limitedPI(Ki = KIpll, Kp = KPpll, YMax = WMaxPu * Dynawo.Electrical.SystemBase.omegaNom, YMin = WMinPu * Dynawo.Electrical.SystemBase.omegaNom)  annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DfMaxPu, Y0 = 0, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-36, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter1(DuMax = DfMaxPu, Y0 = 0, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {54, -20}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch1(nu = 3)  annotation(
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group="Operating point"));
  parameter Types.Angle UPhase0 "Initial Phase angle outputted by phase-locked loop" annotation(
      Dialog(group="Operating point"));

equation
  connect(uPu, switch12.u3) annotation(
    Line(points = {{-112, 0}, {-92, 0}, {-92, 6}, {-82, 6}}, color = {85, 170, 255}));
  connect(complexExpr.y, switch12.u1) annotation(
    Line(points = {{-92, -19}, {-92, -6}, {-82, -6}}, color = {85, 170, 255}));
  connect(complexToPolar1.len, lessThreshold.u) annotation(
    Line(points = {{-38, 74}, {-20, 74}, {-20, 40}, {-38, 40}}, color = {0, 0, 127}));
  connect(lessThreshold.y, switch12.u2) annotation(
    Line(points = {{-60, 40}, {-86, 40}, {-86, 0}, {-82, 0}}, color = {255, 0, 255}));
  connect(uPu, complexToPolar1.u) annotation(
    Line(points = {{-112, 0}, {-92, 0}, {-92, 80}, {-62, 80}}, color = {85, 170, 255}));
  connect(complexToPolar1.phi, firstOrder.u) annotation(
    Line(points = {{-38, 86}, {-10, 86}, {-10, 40}, {-2, 40}}, color = {0, 0, 127}));
  connect(switch12.y, transformRItoDQ.uPu) annotation(
    Line(points = {{-58, 0}, {-54, 0}, {-54, -6}, {-51, -6}}, color = {85, 170, 255}));
  connect(switch11.y, integrator.u) annotation(
    Line(points = {{33, 0}, {37, 0}, {37, 6}, {41, 6}}, color = {0, 0, 127}));
  connect(lessThreshold.y, switch11.u2) annotation(
    Line(points = {{-60, 40}, {-86, 40}, {-86, 20}, {6, 20}, {6, 0}, {10, 0}}, color = {255, 0, 255}));
  connect(firstOrder1.y, switch1.u1) annotation(
    Line(points = {{-62, -88}, {-50, -88}}, color = {0, 0, 127}));
  connect(switch1.y, add.u1) annotation(
    Line(points = {{-26, -80}, {-20, -80}, {-20, -74}, {-12, -74}}, color = {0, 0, 127}));
  connect(realExpression1.y, add.u2) annotation(
    Line(points = {{-20, -91}, {-20, -86}, {-12, -86}}, color = {0, 0, 127}));
  connect(add.y, gain1.u) annotation(
    Line(points = {{12, -80}, {18, -80}}, color = {0, 0, 127}));
  connect(realExpression.y, switch11.u1) annotation(
    Line(points = {{12, -19}, {12, -16}, {6, -16}, {6, -8}, {10, -8}}, color = {0, 0, 127}));
  connect(gain2.y, add3.u2) annotation(
    Line(points = {{51, -40}, {54, -40}, {54, -46}}, color = {0, 0, 127}));
  connect(realExpression3.y, add3.u1) annotation(
    Line(points = {{79, -40}, {66, -40}, {66, -46}}, color = {0, 0, 127}));
  connect(integrator.y, transformRItoDQ.phi) annotation(
    Line(points = {{55, 6}, {60, 6}, {60, 16}, {-54, 16}, {-54, 6}, {-50, 6}}, color = {0, 0, 127}));
  connect(lessThreshold.y, switch1.u2) annotation(
    Line(points = {{-60, 40}, {-86, 40}, {-86, -80}, {-50, -80}}, color = {255, 0, 255}));
  connect(transformRItoDQ.uqPu, limitedPI.u) annotation(
    Line(points = {{-28, 6}, {-26, 6}, {-26, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(limitedPI.y, switch11.u3) annotation(
    Line(points = {{1, 0}, {4, 0}, {4, 8}, {10, 8}}, color = {0, 0, 127}));
  connect(limitedPI.y, rampLimiter.u) annotation(
    Line(points = {{1, 0}, {4, 0}, {4, -40}, {-24, -40}}, color = {0, 0, 127}));
  connect(rampLimiter.y, firstOrder1.u) annotation(
    Line(points = {{-46, -40}, {-80, -40}, {-80, -88}, {-76, -88}}, color = {0, 0, 127}));
  connect(rampLimiter.y, switch1.u3) annotation(
    Line(points = {{-46, -40}, {-80, -40}, {-80, -72}, {-50, -72}}, color = {0, 0, 127}));
  connect(derivative.y, rampLimiter1.u) annotation(
    Line(points = {{72, -20}, {64, -20}}, color = {0, 0, 127}));
  connect(rampLimiter1.y, gain2.u) annotation(
    Line(points = {{46, -20}, {28, -20}, {28, -40}, {32, -40}}, color = {0, 0, 127}));
  connect(complexToPolar1.phi, multiSwitch.u[1]) annotation(
    Line(points = {{-38, 86}, {60, 86}, {60, 40}, {70, 40}}, color = {0, 0, 127}));
  connect(firstOrder.y, multiSwitch.u[2]) annotation(
    Line(points = {{22, 40}, {70, 40}}, color = {0, 0, 127}));
  connect(integrator.y, multiSwitch.u[3]) annotation(
    Line(points = {{54, 6}, {60, 6}, {60, 40}, {70, 40}}, color = {0, 0, 127}));
  connect(multiSwitch.y, thetaPLL) annotation(
    Line(points = {{92, 40}, {110, 40}}, color = {0, 0, 127}));
  connect(integerExpression.y, multiSwitch.f) annotation(
    Line(points = {{80, 64}, {80, 52}}, color = {255, 127, 0}));
  connect(multiSwitch.y, derivative.u) annotation(
    Line(points = {{92, 40}, {96, 40}, {96, -20}, {90, -20}}, color = {0, 0, 127}));
  connect(add3.y, multiSwitch1.u[1]) annotation(
    Line(points = {{60, -68}, {60, -74}, {70, -74}, {70, -80}}, color = {0, 0, 127}));
  connect(add3.y, multiSwitch1.u[2]) annotation(
    Line(points = {{60, -68}, {60, -80}, {70, -80}}, color = {0, 0, 127}));
  connect(gain1.y, multiSwitch1.u[3]) annotation(
    Line(points = {{36, -80}, {70, -80}}, color = {0, 0, 127}));
  connect(multiSwitch1.y, fMeasPu) annotation(
    Line(points = {{92, -80}, {110, -80}}, color = {0, 0, 127}));
  connect(integerExpression.y, multiSwitch1.f) annotation(
    Line(points = {{80, 64}, {80, 60}, {140, 60}, {140, -60}, {80, -60}, {80, -68}}, color = {255, 127, 0}));

  annotation(
    Icon(graphics = {Text(extent = {{-100, 100}, {100, -100}}, textString = "PLL"), Rectangle(extent = {{-100, 100}, {100, -100}})}),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end PLL;
