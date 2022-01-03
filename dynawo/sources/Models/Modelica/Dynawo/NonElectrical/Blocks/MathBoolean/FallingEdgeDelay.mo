within Dynawo.NonElectrical.Blocks.MathBoolean;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block FallingEdgeDelay "Trigger on falling edge with reset time, based on Modelica.Blocks.MathBoolean.OnDelay."
  import Modelica.Blocks.Interfaces;
  import Modelica.SIunits;

  extends Interfaces.PartialBooleanSISO_small;

  parameter SIunits.Time delayTime "Delay time, used as reset time";

protected
  Boolean delaySignal(start = false, fixed = true);
  discrete SIunits.Time t_next;

initial equation
  pre(u) = false;
  pre(t_next) = time - 1;

algorithm
  when initial() then
    delaySignal := u;
    t_next := time - 1;
  elsewhen u then
    delaySignal := false;
    t_next := time -1;
  elsewhen not u then
    delaySignal := true;
    t_next := time + delayTime;
  end when;

equation
  if delaySignal then
    y = time <= t_next;
  else
    y = false;
  end if;

end FallingEdgeDelay;
