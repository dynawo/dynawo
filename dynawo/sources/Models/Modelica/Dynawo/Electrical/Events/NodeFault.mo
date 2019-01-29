within Dynawo.Electrical.Events;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model NodeFault "Node fault which lasts from tBegin to tEnd"
  /*
    Between tBegin and tEnd, the impedance between the node and the ground is equal to ZPu.
  */

  import Dynawo.Connectors;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  Connectors.ACPower terminal;

  parameter SIunits.Resistance RPu  "Fault resistance in p.u (base SnRef)";
  parameter SIunits.Reactance XPu  "Fault reactance in p.u (base SnRef)";
  parameter SIunits.Time tBegin "Time when the fault begins";
  parameter SIunits.Time tEnd "Time when the fault ends";

protected
  parameter Types.AC.Impedance ZPu (re = RPu, im = XPu) "Impedance of the fault in p.u (base SnRef)";

equation
    when time >= tEnd then
      Timeline.logEvent1(TimelineKeys.NodeFaultEnd);
    elsewhen time >= tBegin then
      Timeline.logEvent1(TimelineKeys.NodeFaultBegin);
    end when;

    if time < tBegin or time >= tEnd then
      terminal.i = Complex(0);
    else
      terminal.V = ZPu * terminal.i;
    end if;
end NodeFault;
