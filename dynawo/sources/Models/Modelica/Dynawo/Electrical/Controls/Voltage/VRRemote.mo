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
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Boolean FreezingActivated = false "Whether the freezing functionality is activated or not";
  parameter Real Gain "Control gain";
  parameter Integer NbGenMax = 30 "Maximum number of generators that can participate in the coordinated primary voltage regulation of the considered bus";
  parameter Types.Time tIntegral "Time integration constant";

  Modelica.Blocks.Interfaces.BooleanInput[NbGenMax] limUQDown(start = limUQDown0) "Whether the minimum reactive power limits are reached or not (for each generator participating in the coordinated primary voltage regulation of the considered bus)" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput[NbGenMax] limUQUp(start = limUQUp0) "Whether the maximum reactive power limits are reached or not (for each generator participating in the coordinated primary voltage regulation of the considered bus)" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Regulated voltage reference in in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URegulatedPu(start = U0Pu) "Regulated voltage in in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput NQ "Signal to change the reactive power generation of the generators participating in the coordinated primary voltage regulation of the considered bus (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Boolean[NbGenMax] limUQDown0 = fill(true, NbGenMax) "Whether the minimum reactive power limits are initially reached or not (for each generator participating in the coordinated primary voltage regulation of the considered bus)";
  parameter Boolean[NbGenMax] limUQUp0 = fill(true, NbGenMax) "Whether the maximum reactive power limits are initially reached or not (for each generator participating in the coordinated primary voltage regulation of the considered bus)";
  parameter Types.VoltageModule U0Pu "Start value of the regulated voltage in in pu (base UNom)";
  parameter Types.VoltageModule URef0Pu "Start value of the regulated voltage reference in in pu (base UNom)";
  parameter Boolean Frozen0 = false "Start value of the frozen status";

protected
  Boolean blockedDown(start = Modelica.Math.BooleanVectors.allTrue(limUQDown0)) "Whether all the generators have reached their minimum reactive power limits";
  Boolean blockedUp(start = Modelica.Math.BooleanVectors.allTrue(limUQUp0)) "Whether all the generators have reached their maximum reactive power limits";
  Types.VoltageModule deltaUInt(start = 0) "State of the integrator in kV";
  Boolean frozen(start = Frozen0) "True if the integration is frozen";

equation
  blockedUp = Modelica.Math.BooleanVectors.allTrue(limUQUp);
  blockedDown = Modelica.Math.BooleanVectors.allTrue(limUQDown);
  frozen = FreezingActivated and ((blockedUp and (URefPu - URegulatedPu) > 0) or (blockedDown and (URefPu - URegulatedPu) < 0));
  when frozen and not(pre(frozen)) then
    Timeline.logEvent1 (TimelineKeys.VRFrozen);
  elsewhen not(frozen) and pre(frozen) then
    Timeline.logEvent1 (TimelineKeys.VRUnfrozen);
  end when;
  der(deltaUInt) = if frozen then 0 else (URefPu - URegulatedPu) / tIntegral;
  NQ = Gain * (deltaUInt + URefPu - URegulatedPu);

  annotation(preferredView = "text");
end VRRemote;
