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

package Event
  import Dynawo.Connectors;
  import Dynawo.Electrical.Constants;

  extends Icons.Package;

/* A simulation event is described as follows when tEvent is reached, one or more variables (connected using state1 - state5 ZPins) are updated
   Their new value is stateEvent1 - stateEvent5
   Depending on the type of model variable they are connected to, the event model is different */

  model EventEquations
   parameter typeParameter stateEvent1 "Post event state";
   parameter typeParameter stateEvent2 if (nbEventVariables >= 2);
   parameter typeParameter stateEvent3 if (nbEventVariables >= 3);
   parameter typeParameter stateEvent4 if (nbEventVariables >= 4);
   parameter typeParameter stateEvent5 if (nbEventVariables >= 5);

   typeConnector state1 "Current state";
   typeConnector state2 if (nbEventVariables >= 2);
   typeConnector state3 if (nbEventVariables >= 3);
   typeConnector state4 if (nbEventVariables >= 4);
   typeConnector state5 if (nbEventVariables >= 5);

   parameter Types.Time tEvent "Event time";

   parameter Integer nbEventVariables(min = 1, max = 5) "Number of variables to update during the event";

  protected
   // Replaceable items in order to allow using this model for various types (integer, boolean, real...)
   replaceable connector typeConnector = Connectors.ZPin;
   replaceable type typeParameter = Real;

  equation
   when (time >= tEvent) then
     state1.value = stateEvent1;
   end when;

   if (nbEventVariables >= 2) then
     when (time >= tEvent) then
       state2.value = stateEvent2;
     end when;
   end if;

   if (nbEventVariables >= 3) then
     when (time >= tEvent) then
       state3.value = stateEvent3;
     end when;
   end if;

   if (nbEventVariables >= 4) then
     when (time >= tEvent) then
       state4.value = stateEvent4;
     end when;
   end if;

   if (nbEventVariables >= 5) then
     when (time >= tEvent) then
       state5.value = stateEvent5;
     end when;
   end if;

   annotation(preferredView = "text");
  end EventEquations;

// Specific model for Boolean variables events
model EventBoolean = EventEquations (redeclare type typeParameter = Boolean, redeclare connector typeConnector = Connectors.BPin);

// Specific model for Real variables events
model EventReal = EventEquations (redeclare type typeParameter = Real, redeclare connector typeConnector = Connectors.ZPin);

// Simple models used to avoid having to set the number of variables for each model, and to use precompiled models
model SingleRealEvent = EventReal (nbEventVariables = 1);
model DoubleRealEvent = EventReal (nbEventVariables = 2);
model TripleRealEvent = EventReal (nbEventVariables = 3);

model SingleBooleanEvent = EventBoolean (nbEventVariables = 1);
model DoubleBooleanEvent = EventBoolean (nbEventVariables = 2);
model TripleBooleanEvent = EventBoolean (nbEventVariables = 3);

// Event for quadripole opening or closing (for example, for tripping)
model EventQuadripoleStatus
  extends SingleRealEvent (stateEvent1 = if(openOrigin and openExtremity) then Constants.stateToReal(Constants.state.Open)
                                         elseif (openOrigin and not openExtremity) then Constants.stateToReal(Constants.state.Closed2)
                                         elseif (not openOrigin and openExtremity) then Constants.stateToReal(Constants.state.Closed1)
                                         else Constants.stateToReal(Constants.state.Closed));

  parameter Boolean openOrigin "Open the quadripole origin ?";
  parameter Boolean openExtremity "Open the quadripole extremity ?";

  annotation(preferredView = "text");
end EventQuadripoleStatus;

// Event for quadripole connection
model EventQuadripoleConnection
  extends EventQuadripoleStatus(openOrigin = not(connectOrigin), openExtremity = not(connectExtremity));

  parameter Boolean connectOrigin "Connect the quadripole origin ?";
  parameter Boolean connectExtremity "Connect the quadripole extremity ?";

  annotation(preferredView = "text");
end EventQuadripoleConnection;

// Event for quadripole disconnection
model EventQuadripoleDisconnection
  extends EventQuadripoleStatus(openOrigin = disconnectOrigin, openExtremity = disconnectExtremity);

  parameter Boolean disconnectOrigin "Disconnect the quadripole origin ?";
  parameter Boolean disconnectExtremity "Disconnect the quadripole extremity ?";

  annotation(preferredView = "text");
end EventQuadripoleDisconnection;

// Event for changing connection status of a component (connected or disconnected)
model EventConnectedStatus
  extends SingleRealEvent (stateEvent1 = if(open) then Constants.stateToReal(Constants.state.Open)
                                         else Constants.stateToReal(Constants.state.Closed));

  parameter Boolean open "Disconnect the component ?";

  annotation(preferredView = "text");
end EventConnectedStatus;

annotation(preferredView = "text");
end Event;
