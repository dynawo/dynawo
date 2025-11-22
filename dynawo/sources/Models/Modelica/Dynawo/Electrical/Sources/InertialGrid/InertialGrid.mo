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

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-16, -10}, {4, 10}}, rotation = 0)));

  //Input variable
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omega0Pu) annotation(
    Placement(transformation(origin = {-60, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Controls.Frequency.SystemFrequencyResponse.ReducedOrderSFR reducedOrderSFR(DPu = DPu, Fh = Fh, H = H, Km = Km, Pe0Pu = P0Pu*SystemBase.SnRef/SNom, R = R, Tr = Tr) annotation(
    Placement(transformation(origin = {-81, -1}, extent = {{-13, -13}, {13, 13}})));
  Modelica.Blocks.Continuous.Integrator integrator(k = SystemBase.omegaNom) annotation(
    Placement(transformation(origin = {-18, 0}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Blocks.Math.PolarToRectangular polarToRectangular annotation(
    Placement(transformation(origin = {48, 2}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {15, -5}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Sources.Constant initialPhase(k = UPhase0) annotation(
    Placement(transformation(origin = {-26, -30}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Blocks.Sources.Constant module(k = U0Pu) annotation(
    Placement(transformation(origin = {10, 34}, extent = {{-8, -8}, {8, 8}})));
  Dynawo.Electrical.Sources.InjectorURI injectorURI(u0Pu = u0Pu, i0Pu = i0Pu) annotation(
    Placement(transformation(origin = {80, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain baseConversion(k = SystemBase.SnRef/SNom) annotation(
    Placement(visible = true, transformation(origin = {-14, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(transformation(origin = {-44, 0}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  final parameter Types.ComplexCurrentPu i0Pu = ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu);
  parameter Types.ActivePowerPu P0Pu "Start value of the active power in pu (base SnRef)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of the reactive power in pu (base SnRef)";
  final parameter Types.ComplexVoltagePu u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  parameter Types.VoltageModulePu U0Pu "Start and constant value of the voltage module in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of the voltage angle";

equation
  connect(injectorURI.PInjPu, baseConversion.u) annotation(
    Line(points = {{91, 9}, {96, 9}, {96, -80}, {-2, -80}}, color = {0, 0, 127}));
  connect(injectorURI.terminal, terminal) annotation(
    Line(points = {{91.5, 2}, {100.75, 2}, {100.75, -2}, {110, -2}}, color = {0, 0, 255}));
  connect(integrator.y, add.u1) annotation(
    Line(points = {{-9, 0}, {4, 0}}, color = {0, 0, 127}));
  connect(add.y, polarToRectangular.u_arg) annotation(
    Line(points = {{25, -5}, {34, -5}}, color = {0, 0, 127}));
  connect(reducedOrderSFR.OmegaPu, add1.u2) annotation(
    Line(points = {{-67, -6}, {-56, -6}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{-33, 0}, {-28, 0}}, color = {0, 0, 127}));
  connect(initialPhase.y, add.u2) annotation(
    Line(points = {{-17, -30}, {-10, -30}, {-10, -10}, {4, -10}}, color = {0, 0, 127}));
  connect(polarToRectangular.y_re, injectorURI.urPu) annotation(
    Line(points = {{62, 10}, {64, 10}, {64, 6}, {70, 6}}, color = {0, 0, 127}));
  connect(polarToRectangular.y_im, injectorURI.uiPu) annotation(
    Line(points = {{62, -6}, {64, -6}, {64, -2}, {68, -2}}, color = {0, 0, 127}));
  connect(module.y, polarToRectangular.u_abs) annotation(
    Line(points = {{18, 34}, {26, 34}, {26, 10}, {34, 10}}, color = {0, 0, 127}));
  connect(baseConversion.y, reducedOrderSFR.PePu) annotation(
    Line(points = {{-24, -80}, {-100, -80}, {-100, -6}, {-96, -6}}, color = {0, 0, 127}));
  connect(omegaRefPu, add1.u1) annotation(
    Line(points = {{-60, 120}, {-60, 6}, {-56, 6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {-33, 34}, extent = {{-59, 22}, {129, -88}}, textString = "InertialGrid"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end InertialGrid;
