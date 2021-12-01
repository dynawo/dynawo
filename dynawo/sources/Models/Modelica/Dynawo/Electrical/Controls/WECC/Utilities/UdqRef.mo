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

block UdqRef "Calculation of setpoints for ud and uq for voltage source with source impedance R+jX based on current setpoints id and iq at measured terminal voltage ud uq "
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Modelica.ComplexMath;
  import Modelica.Blocks.Interfaces;
  import Modelica.Blocks.Types.Init;


  parameter Types.PerUnit RPu "Source resistance in p.u (base SnRef)";
  parameter Types.PerUnit XPu "Source reactance in p.u (base SnRef)";


  Modelica.Blocks.Interfaces.RealInput idRef annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqRef annotation(
    Placement(visible = true, transformation(origin = {-112, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ud annotation(
    Placement(visible = true, transformation(origin = {-40, -108}, extent = {{20, -20}, {-20, 20}}, rotation = -90), iconTransformation(origin = {-40, -100}, extent = {{20, -20}, {-20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput uq annotation(
    Placement(visible = true, transformation(origin = {40, -108}, extent = {{20, -20}, {-20, 20}}, rotation = -90), iconTransformation(origin = {40, -100}, extent = {{20, -20}, {-20, 20}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput udRef annotation(
    Placement(visible = true, transformation(origin = {113, 39}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {113, 39}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqRef annotation(
    Placement(visible = true, transformation(origin = {111, -39}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {113, -41}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));


equation

  udRef = ud + idRef * RPu - iqRef * XPu;
  uqRef = uq + iqRef * RPu + idRef * XPu;

annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-12, 8}, extent = {{-74, 60}, {90, -72}}, textString = "UdqRef"), Text(extent = {{-160, -40}, {-160, -40}}, textString = "iqRef")}));


end UdqRef;
