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

  // Input and Output
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference speed in pu (base OmegaNom)" annotation(
    Placement(transformation(origin = {-72, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Speed in pu (base OmegaNom)" annotation(
    Placement(transformation(origin = {-150, 80}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {150, 80}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Connectors.ACPower terminal(
    V(re(start = u0Pu.re), im(start = u0Pu.im)),
    i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(extent = {{-16, -10}, {4, 10}})));
  Dynawo.Electrical.Controls.Frequency.SystemFrequencyResponse.ReducedOrderSFR reducedOrderSFR(
    DPu = DPu,
    Fh = Fh,
    H = H,
    Km = Km,
    Pe0Pu = P0Pu*SystemBase.SnRef/SNom,
    R = R,
    Tr = Tr) annotation(
    Placement(transformation(origin = {-105, -1}, extent = {{-13, -13}, {13, 13}})));
  Modelica.Blocks.Continuous.Integrator integrator(k = SystemBase.omegaNom) annotation(
    Placement(transformation(origin = {-6, 0}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Blocks.Math.PolarToRectangular polarToRectangular annotation(
    Placement(transformation(origin = {66, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {27, -5}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Sources.Constant initialPhase(k = UPhase0) annotation(
    Placement(transformation(origin = {-6, -36}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Blocks.Sources.Constant module(k = U0Pu) annotation(
    Placement(transformation(origin = {-6, 38}, extent = {{-8, -8}, {8, 8}})));
  Dynawo.Electrical.Sources.InjectorURI injectorURI(
    u0Pu = u0Pu,
    i0Pu = i0Pu) annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain baseConversion(k = SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {6, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(transformation(origin = {-48, 0}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.ActivePowerPu P0Pu "Start value of the active power in pu (base SnRef)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of the reactive power in pu (base SnRef)";
  parameter Types.Angle UPhase0 "Start value of the voltage angle";
  parameter Types.VoltageModulePu U0Pu "Start and constant value of the voltage module in pu (base UNom)";
  final parameter Types.ComplexVoltagePu u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  final parameter Types.ComplexCurrentPu i0Pu = ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu);

equation
  connect(integrator.y, add.u1) annotation(
    Line(points = {{2.8, 0}, {16.8, 0}}, color = {0, 0, 127}));
  connect(add.u2, initialPhase.y) annotation(
    Line(points = {{16.2, -10.4}, {10.2, -10.4}, {10.2, -36.4}, {2.2, -36.4}}, color = {0, 0, 127}));
  connect(add.y, polarToRectangular.u_arg) annotation(
    Line(points = {{36.9, -5}, {45.9, -5}, {45.9, -6}, {54, -6}}, color = {0, 0, 127}));
  connect(module.y, polarToRectangular.u_abs) annotation(
    Line(points = {{2.8, 38}, {46.8, 38}, {46.8, 6}, {54, 6}}, color = {0, 0, 127}));
  connect(injectorURI.uiPu, polarToRectangular.y_im) annotation(
    Line(points = {{89, -4}, {81.9, -4}, {81.9, -6}, {77, -6}}, color = {0, 0, 127}));
  connect(polarToRectangular.y_re, injectorURI.urPu) annotation(
    Line(points = {{77, 6}, {83, 6}, {83, 4}, {89, 4}}, color = {0, 0, 127}));
  connect(injectorURI.PInjPu, baseConversion.u) annotation(
    Line(points = {{111, 7}, {116, 7}, {116, -76.4}, {18, -76.4}}, color = {0, 0, 127}));
  connect(baseConversion.y, reducedOrderSFR.PePu) annotation(
    Line(points = {{-5, -76}, {-130, -76}, {-130, -6}, {-120, -6}}, color = {0, 0, 127}));
  connect(injectorURI.terminal, terminal) annotation(
    Line(points = {{111.5, 0}, {150, 0}}, color = {0, 0, 255}));
  connect(reducedOrderSFR.omegaPu, add1.u2) annotation(
    Line(points = {{-91.1875, -6.2}, {-60.1875, -6.2}}, color = {0, 0, 127}));
  connect(omegaRefPu, add1.u1) annotation(
    Line(points = {{-72, 120}, {-72, 6}, {-60, 6}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{-37, 0}, {-16, 0}}, color = {0, 0, 127}));
  connect(reducedOrderSFR.omegaPu, omegaPu) annotation(
    Line(points = {{-91.1875, -6.2}, {-86.1875, -6.2}, {-86.1875, 80}, {-150, 80}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
  Icon(graphics = {Text(origin = {-33, 34}, extent = {{-59, 22}, {129, -88}}, textString = "InertialGrid"), Rectangle(extent = {{-140, 100}, {140, -100}})}, coordinateSystem(extent = {{-140, -100}, {140, 100}})),
  Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
end InertialGrid;
