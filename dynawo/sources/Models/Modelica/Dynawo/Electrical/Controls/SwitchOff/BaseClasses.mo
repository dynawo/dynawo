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

package BaseClasses

  extends Icons.Package;

partial model SwitchOffLogic "Manage switch-off logic"
  /* Handles a predefinite number of switch-off signals and sets running to false as soon as one signal is set to true */

  public

    parameter Integer NbSwitchOffSignals (min = 1, max = 3) "Number of switch-off signals to take into account in inputs";

    Connectors.BPin switchOffSignal1 (value (start = false)) "Switch-off signal 1";
    Connectors.BPin switchOffSignal2 (value (start = false)) if NbSwitchOffSignals >= 2 "Switch-off signal 2";
    Connectors.BPin switchOffSignal3 (value (start = false)) if NbSwitchOffSignals >= 3 "Switch-off signal 3";

    Connectors.BPin running (value (start=true)) "Indicates if the component is running or not";

    Constants.state state (start = State0) "Connection state";

  protected
    parameter Constants.state State0 = Constants.state.Closed " Start value of connection state";

  equation

    if (NbSwitchOffSignals >= 3) then
      when switchOffSignal1.value or switchOffSignal2.value or switchOffSignal3.value and pre(running.value) then
        running.value = false;
      end when;
    elseif (NbSwitchOffSignals >= 2) then
      when switchOffSignal1.value or switchOffSignal2.value and pre(running.value) then
        running.value = false;
      end when;
    else
      when switchOffSignal1.value and pre(running.value) then
        running.value = false;
      end when;
    end if;

annotation(preferredView = "text");
end SwitchOffLogic;

annotation(preferredView = "text");
end BaseClasses;
