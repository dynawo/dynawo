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

model DCVoltageControl "DC Voltage Control for the HVDC VSC model"
  import Modelica;
  import Dynawo.Electrical.HVDC;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_ActivateDeltaP;
  extends HVDC.HvdcVSC.BaseControls.DCVoltageControl.BaseDCVoltageControl;

  Modelica.Blocks.Interfaces.BooleanOutput activateDeltaP(start = false) "Boolean that indicates whether DeltaP is activated or not" annotation(
    Placement(visible = true, transformation(origin = {200, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  HVDC.HvdcVSC.BaseControls.DCVoltageControl.ActivateDeltaP activateDeltaPfunction(DUDC = DUDC, Ip0Pu = Ip0Pu, IpMaxCstPu = IpMaxCstPu) "Function that activates the DeltaP when necessary" annotation(
    Placement(visible = true, transformation(origin = {170, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(activateDeltaPfunction.activateDeltaP, activateDeltaP) annotation(
    Line(points = {{181, -40}, {200, -40}}, color = {255, 0, 255}));
  connect(gain1.y, activateDeltaPfunction.ipRefUdcPu) annotation(
    Line(points = {{141, -6}, {150, -6}, {150, -40}, {159, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-170, -100}, {160, 100}})),
    Icon(coordinateSystem(grid = {1, 1})));
end DCVoltageControl;
