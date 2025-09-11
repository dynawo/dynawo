within Dynawo.Electrical.HVDC.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseQStatusDangling "Base dynamic model QStatus at terminal 1"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  type QStatus = enumeration(Standard "Reactive power is fixed to its initial value",
                             AbsorptionMax "Reactive power is fixed to its absorption limit",
                             GenerationMax "Reactive power is fixed to its generation limit");

  Modelica.Blocks.Interfaces.BooleanOutput limUQDown1(start = limUQDown10) "Whether the minimum reactive power limits are reached or not at terminal 1";
  Modelica.Blocks.Interfaces.BooleanOutput limUQUp1(start = limUQUp10) "Whether the maximum reactive power limits are reached or not at terminal 1";
  QStatus q1Status(start = q1Status0) "Voltage regulation status of terminal 1: Standard, AbsorptionMax or GenerationMax";

  parameter Boolean limUQDown10 "Whether the minimum reactive power limits are reached or not at terminal 1, start value";
  parameter Boolean limUQUp10 "Whether the maximum reactive power limits are reached or not at terminal 1, start value";
  parameter QStatus q1Status0 "Start voltage regulation status of terminal 1: Standard, AbsorptionMax, GenerationMax";

equation
  when q1Status == QStatus.AbsorptionMax and pre(q1Status) <> QStatus.AbsorptionMax then
    Timeline.logEvent1(TimelineKeys.HVDC1MinQ);
  elsewhen q1Status == QStatus.GenerationMax and pre(q1Status) <> QStatus.GenerationMax then
    Timeline.logEvent1(TimelineKeys.HVDC1MaxQ);
  elsewhen q1Status == QStatus.Standard and pre(q1Status) <> QStatus.Standard then
    Timeline.logEvent1(TimelineKeys.HVDC1BackRegulation);
  end when;

  annotation(preferredView = "text");
end BaseQStatusDangling;
