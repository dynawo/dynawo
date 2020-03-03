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


block DQ_Transformation "Transformation from real/imaginary to d/q rotating reference frame with rotation angle phi."

  import Modelica.Blocks;
  import Modelica.ComplexBlocks;

  ComplexBlocks.Interfaces.ComplexInput uPu annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput cosphi annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput sinphi annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealOutput ud annotation(
    Placement(visible = true, transformation(origin = {109, 39}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {111, 77}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Blocks.Interfaces.RealOutput uq annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {112, 38}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));

equation

  ud =  ComplexMath.real(uPu)*cosphi + ComplexMath.imag(uPu)*sinphi;
  uq = -ComplexMath.real(uPu)*sinphi + ComplexMath.imag(uPu)*cosphi;

end DQ_Transformation;
