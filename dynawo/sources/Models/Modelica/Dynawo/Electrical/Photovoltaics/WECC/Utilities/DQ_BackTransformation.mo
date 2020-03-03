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


block DQ_BackTransformation "Transformation from d/q rotating reference frame with rotation angle phi to real/imaginary in stationary reference frame."
  import Modelica.Blocks;

  Blocks.Interfaces.RealInput ud annotation(
    Placement(visible = true, transformation(origin = {-112, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput uq annotation(
    Placement(visible = true, transformation(origin = {-112, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput cosphi annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput sinphi annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealOutput ur annotation(
    Placement(visible = true, transformation(origin = {111, 61}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {111, 61}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Blocks.Interfaces.RealOutput ui annotation(
    Placement(visible = true, transformation(origin = {110, -62}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {110, -62}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));

equation

  ur = ud*cosphi - uq*sinphi;
  ui = ud*sinphi + uq*cosphi;

end DQ_BackTransformation;
