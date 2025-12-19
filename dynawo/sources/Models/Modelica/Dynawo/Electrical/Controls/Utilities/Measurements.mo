within Dynawo.Electrical.Controls.Utilities;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model Measurements "This block measures the voltage, current, active power and reactive power in pu (base UNom, SnRef)"

/*
  Equivalent circuit and conventions:

               iPu, uPu
   (terminal1) -->---------MEASUREMENTS------------ (terminal2)

*/

  Dynawo.Connectors.ACPower terminal1 annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2 annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput IPhase "Current angle at terminal 1 in rad" annotation(
    Placement(visible = true, transformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput IPu "Current module at terminal 1 in pu (base UNom, SnRef)" annotation(
    Placement(visible = true, transformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput iPu "Complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {100, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {100, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput PPu "Active power at terminal 1 in pu (base SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput QPu "Reactive power at terminal 1 in pu (base SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput UPhase "Voltage angle at terminal 1 in rad" annotation(
    Placement(visible = true, transformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput UPu "Voltage module at terminal 1 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-100, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-100, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uPu "Complex voltage at terminal 1 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  terminal1.i = -terminal2.i;
  terminal1.V = terminal2.V;
  terminal1.i = iPu;
  terminal1.V = uPu;
  PPu = ComplexMath.real(uPu * ComplexMath.conj(iPu));
  QPu = ComplexMath.imag(uPu * ComplexMath.conj(iPu));

  if (iPu.re == 0 and iPu.im == 0) then
    IPu = 0;
    IPhase = 0;
  else
    IPu = ComplexMath.'abs'(iPu);
    IPhase = ComplexMath.arg(iPu);
  end if;

  if (uPu.re == 0 and uPu.im == 0) then
    UPu = 0;
    UPhase = 0;
  else
    UPu = ComplexMath.'abs'(uPu);
    UPhase = ComplexMath.arg(uPu);
  end if;

  annotation(
    preferredView = "text");
end Measurements;
