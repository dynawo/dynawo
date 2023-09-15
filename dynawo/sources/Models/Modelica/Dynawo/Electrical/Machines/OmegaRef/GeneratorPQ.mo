within Dynawo.Electrical.Machines.OmegaRef;

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

model GeneratorPQ "Generator with power / frequency modulation and fixed reactive power"
  /*
  The P output is modulated according to frequency (in order to model frequency containment reserves)
  The Q output is fixed equal to its initial value QGen0Pu
  */

  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseClasses.BaseGeneratorSimplifiedPFBehavior;
  extends AdditionalIcons.Machine;

equation
  if running.value then
    QGenPu = QGen0Pu;
  else
    terminal.i.im = 0;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The active power output is modulated according to frequency (in order to model frequency containment reserves).<div>The reactive power output is fixed equal to its initial value QGen0Pu.</div></body></html>"));
end GeneratorPQ;
