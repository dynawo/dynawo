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

model EventQuadripoleStatus "Event for quadripole opening or closing (for example, for tripping)"
  extends SingleRealEvent(stateEvent1 = if(openOrigin and openExtremity) then Constants.stateToReal(Constants.state.Open)
                                         elseif (openOrigin and not openExtremity) then Constants.stateToReal(Constants.state.Closed2)
                                         elseif (not openOrigin and openExtremity) then Constants.stateToReal(Constants.state.Closed1)
                                         else Constants.stateToReal(Constants.state.Closed));

  parameter Boolean openOrigin "Open the quadripole origin ?";
  parameter Boolean openExtremity "Open the quadripole extremity ?";

  annotation(preferredView = "text");
end EventQuadripoleStatus;
