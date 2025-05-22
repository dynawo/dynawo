within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ElecMeasurements "This block measures the voltage and current in pu (base UNom, SNom)"

/*
  Equivalent circuit and conventions:

               iPu, uPu
   (terminal1) -->---------MEASUREMENTS------------ (terminal2)

*/

  //Nominal parameter
  parameter Dynawo.Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Interfaces
  Dynawo.Connectors.ACPower terminal1 "Terminal 1, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2 "Terminal 2, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.ComplexBlocks.Interfaces.ComplexOutput iPu "Complex current at terminal 1 in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput PPu "Active power P at terminal 1 in pu (base SNom) (generator convention)";
  Modelica.Blocks.Interfaces.RealOutput PPuSnRef "Active power P at terminal 1 in pu (base SnRef) (generator convention)";
  Modelica.Blocks.Interfaces.RealOutput QPu "Reactive power Q at terminal 1 in pu (base SNom) (generator convention)";
  Modelica.Blocks.Interfaces.RealOutput QPuSnRef "Reactive power Q at terminal 1 in pu (base SnRef) (generator convention)";
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uPu "Complex voltage at terminal 1 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

equation
  terminal1.i = -terminal2.i;
  terminal1.V = terminal2.V;
  iPu = terminal1.i * (SystemBase.SnRef / SNom);
  uPu = terminal1.V;
  PPu = ComplexMath.real(uPu * ComplexMath.conj(iPu));
  QPu = ComplexMath.imag(uPu * ComplexMath.conj(iPu));
  PPuSnRef = (SNom / SystemBase.SnRef) * PPu;
  QPuSnRef = (SNom / SystemBase.SnRef) * QPu;

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-60, -60}, {60, 60}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(extent = {{-100, -20}, {100, 20}}, textString = "Measurements")}));
end ElecMeasurements;
