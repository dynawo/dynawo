within Dynawo.Electrical.Sources.IEC.BaseConverters;

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

model ElecSystem "RLC filter for WT (IEC N°61400-27-1)"

/*
  Equivalent circuit and conventions:

            i1Pu                                 i2Pu
    (terminal1) -->--------------RPu+jXPu------->-- (terminal2)
                            |
                      GPu+jBPu
                            |
                           ---
*/

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Circuit parameters
  parameter Types.PerUnit BPu "Shunt susceptance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit GPu "Shunt conductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit RPu "Serial resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit XPu "Serial reactance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  //Interfaces
  Dynawo.Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re*SNom/SystemBase.SnRef), im(start = i10Pu.im*SNom/SystemBase.SnRef))) "terminal 1, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = -i20Pu.re*SNom/SystemBase.SnRef), im(start = -i20Pu.im*SNom/SystemBase.SnRef))) "terminal 2, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Output variables
  Types.ComplexCurrentPu i1Pu(re(start = i10Pu.re), im(start = i10Pu.im)) "Complex current at terminal 1 in pu (base UNom, SNom) (generator convention)";
  Types.ComplexCurrentPu i2Pu(re(start = i20Pu.re), im(start = i20Pu.im)) "Complex current at terminal 2 in pu (base UNom, SNom) (generator convention)";
  Types.ComplexVoltagePu u1Pu(re(start = u10Pu.re), im(start = u10Pu.im)) "Complex voltage at terminal 1 in pu (base UNom)";
  Types.ComplexVoltagePu u2Pu(re(start = u20Pu.re), im(start = u20Pu.im)) "Complex voltage at terminal 2 in pu (base UNom)";
  Modelica.Blocks.Interfaces.RealOutput i1ImPu(start = i10Pu.im) "Imaginary component of the current at terminal 1 in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {20, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {90, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput i1RePu(start = i10Pu.re) "Real component of the current at terminal 1 in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {10, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {70, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput i2ImPu(start = i20Pu.im) "Imaginary component of the current at terminal 2 in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-40, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {-20, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput i2RePu(start = i20Pu.re) "Real component of the current at terminal 2 in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-50, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {-40, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput u1ImPu(start = u10Pu.im) "Imaginary component of the voltage at terminal 1 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {50, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {40, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput u1RePu(start = u10Pu.re) "Real component of the voltage at terminal 1 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {20, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput u2ImPu(start = u20Pu.im) "Imaginary component of the voltage at terminal 2 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-10, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {-70, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput u2RePu(start = u20Pu.re) "Real component of the voltage at terminal 2 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-20, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {-90, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));

  //Initial parameters
  final parameter Types.ComplexCurrentPu i10Pu = i20Pu + Complex(GPu, BPu)*u10Pu "Initial complex current at terminal 1 in pu (base UNom, SNom) (receptor convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexCurrentPu i20Pu "Initial complex current at terminal 2 in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  final parameter Types.ComplexVoltagePu u10Pu = u20Pu + Complex(RPu, XPu)*i20Pu "Initial complex voltage at terminal 1 in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexVoltagePu u20Pu "Initial complex voltage at terminal 2 in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
equation
  u1Pu = terminal1.V;
  u2Pu = terminal2.V;
  i1Pu = terminal1.i*(SystemBase.SnRef/SNom);
  i2Pu = -terminal2.i*(SystemBase.SnRef/SNom);
  u2Pu = u1Pu - Complex(RPu, XPu)*i2Pu;
  i1Pu = i2Pu + Complex(GPu, BPu)*u1Pu;
  i1Pu = Complex(i1RePu, i1ImPu);
  i2Pu = Complex(i2RePu, i2ImPu);
  u1Pu = Complex(u1RePu, u1ImPu);
  u2Pu = Complex(u2RePu, u2ImPu);

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-60, -60}, {60, 60}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Rectangle( fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-31, 12}, {33, -12}}), Line(origin = {-80, 0}, points = {{-20, 0}, {49, 0}}), Line(origin = {80, 0}, points = {{-47, 0}, {20, 0}}), Text(origin = {0, 30}, textColor = {0, 0, 255}, extent = {{-80, 10}, {80, -10}}, textString = "%name"), Text(origin = {0, -1}, extent = {{-39, 10}, {39, -10}}, textString = "R+jX"), Line(origin = {-54.9682, -0.00794913}, points = {{-20, 0}, {-20, -20}}), Rectangle(origin = {-75, -40}, rotation = -90, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-31, 12}, {33, -12}}), Text(origin = {-76, -39}, rotation = -90, extent = {{-39, 10}, {39, -10}}, textString = "G+jB"), Line(origin = {-75, -138},points = {{-20, 50}, {20, 50}}, color = {0, 0, 255}), Line(origin = {-75, -123},points = {{-10, 30}, {10, 30}}, color = {0, 0, 255}), Line(origin = {-75, -108},points = {{-5, 10}, {6, 10}}, color = {0, 0, 255}), Line(origin = {-75, -138},points = {{0, 65}, {0, 50}}, color = {0, 0, 255})}));
end ElecSystem;
