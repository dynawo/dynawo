within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PQCalculus "Active power P and reactive power Q calculation at terminal (generator convention)"

  //Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput iWtPu "Complex injected current at terminal in pu (base UNom, SNom) (generator convention)"  annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uWtPu "Complex voltage at terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PWtPu "Active power P at terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QWtPu "Reactive power Q at terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  PWtPu = ComplexMath.real(uWtPu * ComplexMath.conj(iWtPu));
  QWtPu = ComplexMath.imag(uWtPu * ComplexMath.conj(iWtPu));

end PQCalculus;
