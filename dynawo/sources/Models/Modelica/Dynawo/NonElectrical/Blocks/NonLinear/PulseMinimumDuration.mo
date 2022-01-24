within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block PulseMinimumDuration "Activates a Boolean signal for a duration tPulse or more if input is true"

  import Dynawo;

  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BasePulse;

equation
  y = u or time - tTrigger < tPulse;

  annotation(
  preferredView = "text",
  Documentation(info= "<html><head></head><body><p>
The Boolean output y depends on the activation of a Boolean input.</p><p>If this Boolean becomes true, y is true at least for a duration tPulse. y becomes false again&nbsp;<span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">if u is false and the duration tPulse has elapsed</span>.</p>
</body></html>"));
end PulseMinimumDuration;
