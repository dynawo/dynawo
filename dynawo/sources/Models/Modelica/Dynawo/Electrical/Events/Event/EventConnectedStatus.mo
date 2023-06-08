within Dynawo.Electrical.Events.Event;

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

model EventConnectedStatus "Event for changing connection status of a component (connected or disconnected)"
  extends SingleRealEvent(stateEvent1 = if(open) then Constants.stateToReal(Constants.state.Open)
                                         else Constants.stateToReal(Constants.state.Closed));

  parameter Boolean open "Disconnect the component ?";

  annotation(preferredView = "text");
end EventConnectedStatus;
