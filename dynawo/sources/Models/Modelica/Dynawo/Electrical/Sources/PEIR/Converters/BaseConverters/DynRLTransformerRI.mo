within Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters;

model DynRLTransformerRI "Dynamic RL Transformer in (RI) frame"
  /*
    * Copyright (c) 2026, RTE (http://www.rte-france.com)
    * See AUTHORS.txt
    * All rights reserved.
    * This Source Code Form is subject to the terms of the Mozilla Public
    * License, v. 2.0. If a copy of the MPL was not distributed with this
    * file, you can obtain one at http://mozilla.org/MPL/2.0/.
    * SPDX-License-Identifier: MPL-2.0
    *
    * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
         Equivalent circuit and conventions:

   UFilter,IFilter                        IPcc, UPcc
   (terminal1) -->-------R+jX-------<-- (terminal2)

    */
   extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffLine;
    // Transformer parameters
  parameter Types.PerUnit RPu "Resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LPu "Inductance in pu (base UNom, SNom)";

  // Initial parameters
  parameter Types.ComplexCurrentPu IPcc0Pu "Complex start value of  current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.ComplexVoltagePu UPcc0Pu "Complex start value of voltage at the PCC in pu (base UNom)";

  // Final Parameters
  final parameter Types.ComplexVoltagePu UFilter0Pu = - RPu*IPcc0Pu + UPcc0Pu "Complex start value of voltage at the filter in pu (base UNom)";
  final parameter Types.ComplexCurrentPu IFilter0Pu = - IPcc0Pu "Complex start value of the current at the filter in pu (base UNom, SNom)";

  // Terminals
  Dynawo.Connectors.ACPower terminal1(V(re(start = UFilter0Pu.re), im(start = UFilter0Pu.im)), i(re(start = IFilter0Pu.re), im(start = IFilter0Pu.im))) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-115, -3}, extent = {{-15, -15}, {15, 15}})));
  Dynawo.Connectors.ACPower terminal2(V(re(start = UPcc0Pu.re), im(start = UPcc0Pu.im)), i(re(start = IPcc0Pu.re), im(start = IPcc0Pu.im))) annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {114,-2}, extent = {{-15, -15}, {15, 15}})));

equation
  if running then
    LPu/SystemBase.omegaNom * der(terminal1.i.re) = terminal1.V.re - RPu*terminal1.i.re - terminal2.V.re;
    LPu/SystemBase.omegaNom * der(terminal1.i.im) = terminal1.V.im - RPu*terminal1.i.im - terminal2.V.im;
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
