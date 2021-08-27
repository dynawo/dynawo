within Dynawo.Electrical.Controls.WECC.Utilities;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block Measurements "This block measures the voltage, current, active power and reactive power in p.u. (base UNom, SNom)"

/*
  Equivalent circuit and conventions:

               iPu, uPu
   (terminal1) -->---------MEASUREMENTS------------ (terminal2)

*/
  import Modelica;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Modelica.ComplexMath;

  Connectors.ACPower terminal1 annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal2 annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  Modelica.Blocks.Interfaces.RealOutput PPu "Active power on side in p.u. (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput QPu "Reactive power on side in p.u. (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uPu "Voltage in p.u. (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput iPu "Current (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  terminal1.i = - terminal2.i;
  terminal1.V = terminal2.V;
  terminal1.i * SystemBase.SnRef / SNom = iPu;
  terminal1.V = uPu;
  PPu = ComplexMath.real(terminal1.V * ComplexMath.conj(iPu));
  QPu = ComplexMath.imag(terminal1.V * ComplexMath.conj(iPu));

annotation(preferredView = "text");
end Measurements;
