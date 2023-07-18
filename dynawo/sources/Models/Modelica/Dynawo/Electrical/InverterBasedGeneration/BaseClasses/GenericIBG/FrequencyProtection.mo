within Dynawo.Electrical.InverterBasedGeneration.BaseClasses.GenericIBG;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model FrequencyProtection
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.AngularVelocityPu OmegaMaxPu "Maximum frequency before disconnection in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMinPu "Minimum frequency before disconnection in pu (base omegaNom)";

  Dynawo.Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the generator";

  Modelica.Blocks.Interfaces.RealInput omegaPu annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  when omegaPu > OmegaMaxPu and not(pre(switchOffSignal.value)) then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.OverspeedTripped);
  elsewhen omegaPu < OmegaMinPu and not(pre(switchOffSignal.value)) then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.UnderspeedTripped);
  end when;

  annotation(preferredView = "text");
end FrequencyProtection;