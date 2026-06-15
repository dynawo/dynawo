within Dynawo.Electrical.Events;

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

package Event
  import Dynawo.Electrical.Constants;

  extends Icons.Package;

  annotation(preferredView = "info",
    Documentation(info = "<html><head></head><body><div>A simulation event is described as follows :</div><div><br></div><div>when tEvent is reached, one or more variables (connected using state1 - state5 ZPins) are updated. Their new value is stateEvent1 - stateEvent5. Depending on the type of model variable they are connected to, the event model is different.</div></body></html>"));
end Event;
