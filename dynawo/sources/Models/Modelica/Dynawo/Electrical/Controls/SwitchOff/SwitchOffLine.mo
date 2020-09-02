within Dynawo.Electrical.Controls.SwitchOff;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SwitchOffLine "Switch-off model"
  /* The three possible/expected switch-off signals are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  import Dynawo.Electrical.Constants;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseClasses.SwitchOffLogic(NbSwitchOffSignals = 2);

  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.LineOpen);
      state = Constants.state.Open;
    end when;

annotation(preferredView = "text");
end SwitchOffLine;
