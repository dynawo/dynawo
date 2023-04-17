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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseQStatus "Base dynamic model QStatus"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseClasses.BaseQStatusDangling;

  Boolean limUQDown2(start = limUQDown20) "Whether the minimum reactive power limits are reached or not at terminal 2";
  Boolean limUQUp2(start = limUQUp20) "Whether the maximum reactive power limits are reached or not at terminal 2";
  QStatus q2Status(start = q2Status0) "Voltage regulation status of terminal 2: Standard, AbsorptionMax or GenerationMax";

  parameter Boolean limUQDown20 "Whether the minimum reactive power limits are reached or not at terminal 2, start value";
  parameter Boolean limUQUp20 "Whether the maximum reactive power limits are reached or not at terminal 2, start value";
  parameter QStatus q2Status0 "Start voltage regulation status of terminal 2: Standard, AbsorptionMax, GenerationMax";

equation
  when q2Status == QStatus.AbsorptionMax and pre(q2Status) <> QStatus.AbsorptionMax then
    Timeline.logEvent1(TimelineKeys.HVDC2MinQ);
  elsewhen q2Status == QStatus.GenerationMax and pre(q2Status) <> QStatus.GenerationMax then
    Timeline.logEvent1(TimelineKeys.HVDC2MaxQ);
  elsewhen q2Status == QStatus.Standard and pre(q2Status) <> QStatus.Standard then
    Timeline.logEvent1(TimelineKeys.HVDC2BackRegulation);
  end when;

  annotation(preferredView = "text");
end BaseQStatus;
