within Dynawo.Electrical.Controls.WECC.Utilities;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model Measurements "This block measures the voltage, current, active power and reactive power in pu (base UNom, SNom or SnRef)"

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

  Modelica.Blocks.Interfaces.RealOutput PPu "Active power on side 1 in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput QPu "Reactive power on side 1 in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uPu "Complex voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput iPu "Complex current in pu (base UNom, SnRef)" annotation(
    Placement(visible = true, transformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput UPu "Voltage module at terminal 1 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-100, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-100, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput PPuSnRef "Active power on side 1 in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-60, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput QPuSnRef "Reactive power on side 1 in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-20, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));

equation
  terminal1.i = - terminal2.i;
  terminal1.V = terminal2.V;
  terminal1.i = iPu;
  terminal1.V = uPu;
  UPu = Modelica.ComplexMath.'abs'(uPu);
  PPu = (SystemBase.SnRef / SNom) * ComplexMath.real(terminal1.V * ComplexMath.conj(iPu));
  QPu = (SystemBase.SnRef / SNom) * ComplexMath.imag(terminal1.V * ComplexMath.conj(iPu));
  PPuSnRef = (SNom / SystemBase.SnRef) * PPu;
  QPuSnRef = (SNom / SystemBase.SnRef) * QPu;

  annotation(preferredView = "text");
end Measurements;
