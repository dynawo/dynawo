within Dynawo.Electrical.InverterBasedGeneration.BaseClasses.AggregatedIBG;

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
  parameter Types.AngularVelocityPu OmegaMinPu "Minimum frequency before start of disconnections in pu (base omegaNom)";
  parameter Types.AngularVelocityPu p "Additional frequency drop compared that leads to full trip of units in pu (base omegaNom)";
  parameter Types.PerUnit r(min = 0, max = 1) "Share of units that trip at OmegaMinPu";
  parameter Types.Time tFilter = 1e-2 "Filter time constant for computation of MinOmegaPu in s";

  Dynawo.Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the generator";

  Modelica.Blocks.Interfaces.RealInput omegaPu annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Types.PerUnit fFrequency(start = 1) "Partial tripping coefficient, equals to 1 if no trip, 0 if fully tripped";
  Types.AngularVelocityPu MinOmegaPu(start = 1) "Minimum measured frequency in pu (base omegaNom)";

equation
  when omegaPu > OmegaMaxPu and not(pre(switchOffSignal.value)) then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.OverspeedTripped);
  elsewhen omegaPu < OmegaMinPu - p and not(pre(switchOffSignal.value)) then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.UnderspeedTripped);
  end when;

  MinOmegaPu + tFilter * der(MinOmegaPu) = if omegaPu < MinOmegaPu then omegaPu else MinOmegaPu;

  if MinOmegaPu > OmegaMinPu then
    fFrequency = 1;
  elseif MinOmegaPu > OmegaMinPu - p then
    fFrequency = r * (OmegaMinPu - MinOmegaPu) / p;
  else
    fFrequency = 0;
  end if;

  annotation(preferredView = "text");
end FrequencyProtection;