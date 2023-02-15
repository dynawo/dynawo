within Dynawo.Electrical.Controls.Voltage;

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

model VRRemote "Model for coordinated primary voltage regulation. This model is used when several generators regulate the same bus with a control law U = URef."
  import Dynawo.Types;
  import Modelica;

  parameter Boolean FreezingActivated = false "Whether the freezing functionnality is activated or not";
  parameter Real Gain "Control gain";
  parameter Integer NbGenMax = 30 "Maximum number of generators that can participate in the coordinated primary voltage regulation of the considered bus";
  parameter Types.Time tIntegral "Time integration constant";

  Modelica.Blocks.Interfaces.BooleanInput[NbGenMax] limUQDown(start = limUQDown0) "Whether the minimum reactive power limits are reached or not (for each generator participating in the coordinated primary voltage regulation of the considered bus)" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput[NbGenMax] limUQUp(start = limUQUp0) "Whether the maximum reactive power limits are reached or not (for each generator participating in the coordinated primary voltage regulation of the considered bus)" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URef(start = URef0) "Regulated voltage reference in kV" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URegulated(start = U0) "Regulated voltage in kV" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput NQ "Signal to change the reactive power generation of the generators participating in the coordinated primary voltage regulation of the considered bus (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Boolean[NbGenMax] limUQDown0 = fill(true, NbGenMax) "Whether the minimum reactive power limits are initially reached or not (for each generator participating in the coordinated primary voltage regulation of the considered bus)";
  parameter Boolean[NbGenMax] limUQUp0 = fill(true, NbGenMax) "Whether the maximum reactive power limits are initially reached or not (for each generator participating in the coordinated primary voltage regulation of the considered bus)";
  parameter Types.VoltageModule U0 "Start value of the regulated voltage in kV";
  parameter Types.VoltageModule URef0 "Start value of the regulated voltage reference in kV";
  parameter Boolean frozen0 = false "Start value of the frozen status";

protected
  Boolean blockedDown(start = Modelica.Math.BooleanVectors.allTrue(limUQDown0)) "Whether all the generators have reached their minimum reactive power limits";
  Boolean blockedUp(start = Modelica.Math.BooleanVectors.allTrue(limUQUp0)) "Whether all the generators have reached their maximum reactive power limits";
  Types.VoltageModule deltaUInt(start = 0) "State of the integrator in kV";
  Boolean frozen(start = frozen0) "True if the integration is frozen";

equation
  blockedUp = Modelica.Math.BooleanVectors.allTrue(limUQUp);
  blockedDown = Modelica.Math.BooleanVectors.allTrue(limUQDown);
  frozen = FreezingActivated and ((blockedUp and (URef - URegulated) > 0) or (blockedDown and (URef - URegulated) < 0));
  der(deltaUInt) = if frozen then 0 else (URef - URegulated) / tIntegral;
  NQ = Gain * (deltaUInt + URef - URegulated);

  annotation(preferredView = "text");
end VRRemote;
