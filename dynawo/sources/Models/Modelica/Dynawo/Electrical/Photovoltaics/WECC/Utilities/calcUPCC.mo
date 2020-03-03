within Dynawo.Electrical.Photovoltaics.WECC.Utilities;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model calcUPCC
  import Modelica.Blocks;
  import Modelica.ComplexBlocks;
  import Dynawo.Types;

  parameter Types.PerUnit Rc "Line drop compensation resistance";
  parameter Types.PerUnit Xc "Line drop compentation reactance";

  // Inputs:
  Types.ComplexCurrentPu iPu annotation(
    Placement(visible = true, transformation(origin = {-106, 60}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {-98, 60}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  ComplexBlocks.Interfaces.ComplexInput uPu annotation(
    Placement(visible = true, transformation(origin = {-110, -52}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {-100, -60}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  // Outputs:
  Blocks.Interfaces.RealOutput UPuLineDrop annotation(
    Placement(visible = true, transformation(origin = {112, 61}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {100, 60}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Interfaces.RealOutput UPu annotation(
    Placement(visible = true, transformation(origin = {112, -59}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {102, -60}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));

  // Inner variables:
  Types.ComplexPerUnit uLineDrop;

equation

  uLineDrop = uPu + iPu * Complex(Rc,Xc);
  UPuLineDrop = ComplexMath.'abs'(uLineDrop);
  UPu = ComplexMath.'abs'(uPu);

  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-4, 2}, extent = {{-66, 68}, {66, -68}}, textString = "|V-Z*I|")}));
end calcUPCC;
