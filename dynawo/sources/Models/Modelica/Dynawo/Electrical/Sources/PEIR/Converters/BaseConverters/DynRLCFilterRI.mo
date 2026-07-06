within Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters;

model DynRLCFilterRI "Dynamic RLC Filter in (RI) frame"
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

   UConv,IConv                         IPcc, UFilter
   (terminal1) -->-------R+jX-------<-- (terminal2)
                                |
                                jB
                                |
    */
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffLine;
  // RLC parameters
  parameter Types.PerUnit RPu "Resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LPu "Inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit CPu "Capacitance in pu (base UNom, SNom)";

  // Initial parameters
  parameter Types.ComplexVoltagePu UFilter0Pu "Start value of complex voltage at the filter terminal in pu (base UNom)";
  parameter Types.ComplexCurrentPu IPcc0Pu "Start value of complex current at the PCC terminal in pu (base UNom, SnRef) (receptor convention)";

 // Final parameters
  final parameter Types.ComplexCurrentPu IConv0Pu =  - IPcc0Pu "Start value of d-axis current at the converter in pu (base UNom, SNom) in generator convention";
  final parameter Types.ComplexVoltagePu UConv0Pu = RPu * IConv0Pu  + UFilter0Pu "Start value of d-axis voltage at the converter in pu (base UNom)";

  // Terminals
  Dynawo.Connectors.ACPower terminal1(V(re(start = UConv0Pu.re), im(start = UConv0Pu.im)), i(re(start = IConv0Pu.re), im(start = IConv0Pu.im))) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-115, -3}, extent = {{-15, -15}, {15, 15}})));
  Dynawo.Connectors.ACPower terminal2(V(re(start = UFilter0Pu.re), im(start = UFilter0Pu.im)), i(re(start = IPcc0Pu.re), im(start = IPcc0Pu.im))) annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {114,-2}, extent = {{-15, -15}, {15, 15}})));

equation
  if running then
    LPu / SystemBase.omegaNom * der(terminal1.i.re) = terminal1.V.re - terminal2.V.re - RPu*terminal1.i.re;
    LPu / SystemBase.omegaNom * der(terminal1.i.im) = terminal1.V.im - terminal2.V.im - RPu*terminal1.i.im;
    CPu / SystemBase.omegaNom * der(terminal2.V.re) = terminal1.i.re + terminal2.i.re;
    CPu / SystemBase.omegaNom * der(terminal2.V.im) = terminal1.i.im + terminal2.i.im;
   else
    terminal1.i = Complex(0);
    terminal2.i = Complex(0);
    end if;
  annotation(
    preferredView = "text",
    Icon(graphics = {Line(origin = {0.292174, 0}, points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {-19.5757, 0.292221}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {10, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {40, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {40, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {70, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Rectangle(extent = {{-100, 100}, {100, -100}}), Line(origin = {139.367, 0.29217}, points = {{-100, 0}, {-40, 0}}, color = {0, 0, 255}), Line(origin = {68.0764, 39.1513}, rotation = 90, points = {{-64, 0}, {-40, 0}}, color = {0, 0, 255}), Line(origin = {157.19, -25.4192}, points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {157.19, -29.4192}, points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {68.3686, 11.1026}, rotation = 90, points = {{-76, 0}, {-40, 0}}, color = {0, 0, 255}), Line(origin = {157.19, -65.4192}, points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {155.19, -67.4192}, points = {{-94, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {151.19, -69.4192}, points = {{-86, 0}, {-80, 0}}, color = {0, 0, 255})}, coordinateSystem(initialScale = 0.01)));
end DynRLCFilterRI;
