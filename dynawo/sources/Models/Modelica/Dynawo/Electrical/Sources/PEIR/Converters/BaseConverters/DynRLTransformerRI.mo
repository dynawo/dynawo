within Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model DynRLTransformerRI "Dynamic RL Transformer in (RI) frame"
  /*
   Equivalent circuit and conventions:

   UFilter,IFilter                        IPcc, UPcc
   (terminal1) -->-------R+jX-------<-- (terminal2)

    */
   extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffLine;

  // Transformer parameters
  parameter Types.PerUnit RPu "Resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LPu "Inductance in pu (base UNom, SNom)";

  // Terminals
  Dynawo.Connectors.ACPower terminal1(V(re(start = uFilter0Pu.re), im(start = uFilter0Pu.im)), i(re(start = iFilter0Pu.re), im(start = iFilter0Pu.im))) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-115, -3}, extent = {{-15, -15}, {15, 15}})));
  Dynawo.Connectors.ACPower terminal2(V(re(start = uPcc0Pu.re), im(start = uPcc0Pu.im)), i(re(start = iPcc0Pu.re), im(start = iPcc0Pu.im))) annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {114,-2}, extent = {{-15, -15}, {15, 15}})));

  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

  // Initial parameters
  parameter Types.ComplexCurrentPu iPcc0Pu "Complex start value of  current in the grid in pu (base UNom, SNom) (receptor convention)";
  parameter Types.ComplexVoltagePu uPcc0Pu "Complex start value of voltage at the PCC in pu (base UNom)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of the converter's frequency in pu (base omegaNom)";

  // Final parameters
  final parameter Types.ComplexVoltagePu uFilter0Pu = Complex(- RPu * iPcc0Pu.re + Omega0Pu * LPu * iPcc0Pu.im + uPcc0Pu.re,
                                                              - RPu * iPcc0Pu.im - Omega0Pu * LPu * iPcc0Pu.re + uPcc0Pu.im) "Complex start value of voltage at the filter in pu (base UNom)";
  final parameter Types.ComplexCurrentPu iFilter0Pu = - iPcc0Pu "Complex start value of the current at the filter in pu (base UNom, SNom) (generator convention for the converter, i.e. entering terminal1 of this block)";

equation
  if running then
    LPu/SystemBase.omegaNom * der(terminal1.i.re) = terminal1.V.re - RPu*terminal1.i.re - terminal2.V.re + omegaPu*LPu*terminal1.i.im;
    LPu/SystemBase.omegaNom * der(terminal1.i.im) = terminal1.V.im - RPu*terminal1.i.im - terminal2.V.im - omegaPu*LPu*terminal1.i.re;
    terminal2.i.re = -terminal1.i.re;
    terminal2.i.im = -terminal1.i.im;
  else
    terminal1.i = Complex(0);
    terminal2.i = Complex(0);
  end if;

  annotation(
    preferredView = "text",
    Icon(graphics = {Line(origin = {0.292174, 0}, points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255}), Line(origin = {0.4243, 0.292221}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {30, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {60, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {60, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {90, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Rectangle(extent = {{-100, 100}, {100, -100}}), Line(origin = {160.466, 0.26087}, points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255})}, coordinateSystem(initialScale = 0.01)));
end DynRLTransformerRI;
