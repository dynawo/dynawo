within Dynawo.NonElectrical.Blocks.MathBoolean;

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

model OffDelay "Delay a falling edge of the input, but do not delay a rising edge."
  extends Modelica.Blocks.Interfaces.PartialBooleanSISO_small;

  parameter Modelica.SIunits.Time tDelay "Delay time in s";

protected
  Boolean delaySignal(start = false);
  discrete Modelica.SIunits.Time tNext;

algorithm
  when initial() then
    delaySignal := u;
    tNext := time - 1;
  elsewhen u then
    delaySignal := false;
    tNext := time - 1;
  elsewhen not u then
    delaySignal := true;
    tNext := time + tDelay;
  end when;

equation
  if delaySignal then
    y = time <= tNext;
  else
    y = false;
  end if;

end OffDelay;
