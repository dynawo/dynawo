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


block U_dq_ref "Calculation of setpoints for ud and uq of inner voltage source with source impedance R+jX based on current setpoints id and iq at measured terminal voltage ud uq "

  import Modelica.Blocks;

  import Dynawo.Types;

  parameter Types.PerUnit R "Resistance equivalence ";
  parameter Types.PerUnit X "Reactance equivalence ";

  Blocks.Interfaces.RealInput id_ref annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput iq_ref annotation(
    Placement(visible = true, transformation(origin = {-110, 26}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 26}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput ud annotation(
    Placement(visible = true, transformation(origin = {-110, -24}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -24}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput uq annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealOutput ud_ref annotation(
    Placement(visible = true, transformation(origin = {113, 39}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {113, 39}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Blocks.Interfaces.RealOutput uq_ref annotation(
    Placement(visible = true, transformation(origin = {113, -41}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {113, -41}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));

equation

  ud_ref = ud + id_ref * R - iq_ref * X;
  uq_ref = uq + iq_ref * R + id_ref * X;

end U_dq_ref;
