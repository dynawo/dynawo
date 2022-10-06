within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.DCVoltageControl;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model ActivateDeltaP "Function that activates the DeltaP when necessary"
  import Modelica;
  import Dynawo.Electrical.HVDC;
  import Dynawo.NonElectrical.Blocks;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_ActivateDeltaP;
  parameter Types.PerUnit IpMaxCstPu "Maximum value of the active current in pu (base SNom, UNom)";

  Modelica.Blocks.Interfaces.RealInput ipRefUdcPu(start = Ip0Pu) "Active current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput activateDeltaP(start = false) "Boolean that indicates whether DeltaP is activated or not" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = IpMaxCstPu - DUDC) annotation(
    Placement(visible = true, transformation(origin = {-19, 15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = (-IpMaxCstPu) + DUDC) annotation(
    Placement(visible = true, transformation(origin = {-19, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Ip0Pu "Start value of active current in pu (base SNom)";

equation
  connect(greaterThreshold.y, or1.u1) annotation(
    Line(points = {{-8, 15}, {1, 15}, {1, 0}, {8, 0}}, color = {255, 0, 255}));
  connect(lessThreshold.y, or1.u2) annotation(
    Line(points = {{-8, -15}, {1, -15}, {1, -8}, {8, -8}}, color = {255, 0, 255}));
  connect(or1.y, activateDeltaP) annotation(
    Line(points = {{31, 0}, {110, 0}}, color = {255, 0, 255}));
  connect(ipRefUdcPu, greaterThreshold.u) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, 15}, {-31, 15}, {-31, 15}}, color = {0, 0, 127}));
  connect(ipRefUdcPu, lessThreshold.u) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, -15}, {-31, -15}, {-31, -15}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end ActivateDeltaP;
