within Dynawo.Electrical.Sources.InertialGrid;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model InertialGrid
  extends Dynawo.Electrical.Controls.Frequency.SystemFrequencyResponse.SFRParameters;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-16, -10}, {4, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.Frequency.SystemFrequencyResponse.ReducedOrderSFR reducedOrderSFR(DPu = DPu, Fh = Fh, H = H, Km = Km, Pe0Pu = P0Pu * SystemBase.SnRef / SNom, R = R, Tr = Tr) annotation(
    Placement(visible = true, transformation(origin = {-73, 1}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = SystemBase.omegaNom, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-26, -4}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.PolarToRectangular polarToRectangular annotation(
    Placement(visible = true, transformation(origin = {46, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {7, -9}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant initialPhase(k = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {-26, -40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant module(k = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-26, 34}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorURI injectorURI(u0Pu = u0Pu, i0Pu = i0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain baseConversion(k = SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-14, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  // Initial parameters
  parameter Types.ActivePowerPu P0Pu "Start value of the active power in pu (base SnRef)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of the reactive power in pu (base SnRef)";
  parameter Types.Angle UPhase0 "Start value of the voltage angle";
  parameter Types.VoltageModulePu U0Pu "Start and constant value of the voltage module in pu (base UNom)";
  final parameter Types.ComplexVoltagePu u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  final parameter Types.ComplexCurrentPu i0Pu = ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu);

equation
  connect(reducedOrderSFR.deltaOmegaPu, integrator.u) annotation(
    Line(points = {{-59, -4}, {-36, -4}}, color = {0, 0, 127}));
  connect(integrator.y, add.u1) annotation(
    Line(points = {{-18, -4}, {-4, -4}}, color = {0, 0, 127}));
  connect(add.u2, initialPhase.y) annotation(
    Line(points = {{-4, -14}, {-10, -14}, {-10, -40}, {-18, -40}}, color = {0, 0, 127}));
  connect(add.y, polarToRectangular.u_arg) annotation(
    Line(points = {{16, -8}, {34, -8}}, color = {0, 0, 127}));
  connect(module.y, polarToRectangular.u_abs) annotation(
    Line(points = {{-18, 34}, {26, 34}, {26, 4}, {34, 4}}, color = {0, 0, 127}));
  connect(injectorURI.uiPu, polarToRectangular.y_im) annotation(
    Line(points = {{69, -6}, {62, -6}, {62, -8}, {58, -8}}, color = {0, 0, 127}));
  connect(polarToRectangular.y_re, injectorURI.urPu) annotation(
    Line(points = {{58, 4}, {64, 4}, {64, 2}, {69, 2}}, color = {0, 0, 127}));
  connect(injectorURI.PInjPu, baseConversion.u) annotation(
    Line(points = {{91, 5}, {96, 5}, {96, -80}, {-2, -80}}, color = {0, 0, 127}));
  connect(baseConversion.y, reducedOrderSFR.PePu) annotation(
    Line(points = {{-24, -80}, {-98, -80}, {-98, -4}, {-89, -4}}, color = {0, 0, 127}));
  connect(injectorURI.terminal, terminal) annotation(
    Line(points = {{91.5, -2}, {110, -2}}, color = {0, 0, 255}));

  annotation(
    Icon(graphics = {Text(origin = {-33, 34}, extent = {{-59, 22}, {129, -88}}, textString = "InertialGrid"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end InertialGrid;
