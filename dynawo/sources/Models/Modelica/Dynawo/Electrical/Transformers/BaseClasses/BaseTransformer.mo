within Dynawo.Electrical.Transformers.BaseClasses;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseTransformer "Base model for a general two winding transformer (fixed or variable phase and/or ratio)"


/* Equivalent circuit and conventions:

               I1  r,theta          I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---
*/
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffTransformer;
  extends Dynawo.Electrical.Transformers.BaseClasses.TransformerParameters;

  Dynawo.Connectors.ACPower terminal1 "Connector used to connect the transformer to the grid (terminal 1)" annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2 "Connector used to connect the transformer to the grid (terminal 2)" annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Types.ComplexPerUnit rTfoPu(re(start = RatioTfo0Pu * Modelica.Math.cos(ThetaTfo0)), im(start = RatioTfo0Pu * Modelica.Math.sin(ThetaTfo0))) "Transformation complex ratio in complex pu";

  // initial parameters
  parameter Types.PerUnit RatioTfo0Pu "Start value of transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.Angle ThetaTfo0 "Start value of transformation phase shift in rad";

equation
  if (running.value) then
    // Kirchoff law
    rTfoPu * ComplexMath.conj(rTfoPu) * terminal1.V = ComplexMath.conj(rTfoPu) * terminal2.V + ZPu * terminal1.i;
    terminal1.i = ComplexMath.conj(rTfoPu) * (YPu * terminal2.V - terminal2.i);
  else
    terminal1.i = Complex(0);
    terminal2.i = Complex(0);
  end if;

  annotation(preferredView = "text");
end BaseTransformer;
