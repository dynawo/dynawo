within Dynawo.Electrical.Sources.PEIR.Converters.IEC.BaseConverters;

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

            iGsPu                                 iWtPu
   (terminal1) -->--------------ResPu+jXesPu------->-- (terminal2)
                            |
                      GesPu+jBesPu
                            |
                           ---
*/

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Circuit parameters
  parameter Types.PerUnit BesPu "Shunt susceptance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit GesPu "Shunt conductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit ResPu "Serial resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit XesPu "Serial reactance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));

  //Interfaces
  Dynawo.Connectors.ACPower terminal1(V(re(start = UGsRe0Pu), im(start = UGsIm0Pu)), i(re(start = IGsRe0Pu * SNom / SystemBase.SnRef), im(start = IGsIm0Pu * SNom / SystemBase.SnRef))) "Converter terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Grid terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput iGsImPu(start = IGsIm0Pu) "Imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {20, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {90, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iGsRePu(start = IGsRe0Pu) "Real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {10, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {70, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iWtImPu(start = -i0Pu.im * SystemBase.SnRef / SNom) "Imaginary component of the current at grid terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-40, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {-20, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iWtRePu(start = -i0Pu.re * SystemBase.SnRef / SNom) "Real component of the current at grid terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-50, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {-40, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uGsImPu(start = UGsIm0Pu) "Imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {50, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {40, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uGsRePu(start = UGsRe0Pu) "Real component of the voltage at converter terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {20, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uWtImPu(start = u0Pu.im) "Imaginary component of the voltage at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-10, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {-70, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uWtRePu(start = u0Pu.re) "Real component of the voltage at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-20, -70}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {-90, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));

  Types.CurrentModulePu IGsPu(start = sqrt(IGsRe0Pu^2 + IGsIm0Pu^2)) "Current module at converter terminal in pu (base UNom, SNom)";
  Types.VoltageModulePu UGsPu(start = sqrt(UGsRe0Pu^2 + UGsIm0Pu^2)) "Voltage module at converter terminal in pu (base UNom)";

  //Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group="Initialization"));
  parameter Types.PerUnit IGsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (receptor convention)" annotation(
    Dialog(group="Initialization"));
  parameter Types.PerUnit IGsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (receptor convention)" annotation(
    Dialog(group="Initialization"));
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group="Initialization"));
  parameter Types.PerUnit UGsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group="Initialization"));
  parameter Types.PerUnit UGsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group="Initialization"));

equation
  Complex(uGsRePu, uGsImPu) = terminal1.V;
  Complex(uWtRePu, uWtImPu) = terminal2.V;
  Complex(iGsRePu, iGsImPu) = terminal1.i * (SystemBase.SnRef / SNom);
  Complex(iWtRePu, iWtImPu) = -terminal2.i * (SystemBase.SnRef / SNom);
  Complex(uWtRePu, uWtImPu) = Complex(uGsRePu, uGsImPu) - Complex(ResPu, XesPu) * Complex(iWtRePu, iWtImPu);
  Complex(iGsRePu, iGsImPu) = Complex(iWtRePu, iWtImPu) + Complex(GesPu, BesPu) * Complex(uGsRePu, uGsImPu);
  UGsPu = Modelica.ComplexMath.'abs'(terminal1.V);
  IGsPu = Modelica.ComplexMath.'abs'(terminal1.i) * (SystemBase.SnRef / SNom);

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-60, -60}, {60, 60}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-100, -20}, {100, 20}}, textString = "Electrical"), Text(origin = {0, -30}, extent = {{-100, -20}, {100, 20}}, textString = "System")}));
end ElecSystem;
