within Dynawo.NonElectrical.Logs.Timeline;

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

function logEvent2 "Print a log message in event file using the multi-language dictionary"
  extends Icons.Function;

  input Integer key;
  input String arg1;

  external "C" addLogEvent2(key, arg1) annotation(Include = "#include \"logEvent.h\"");

  annotation(preferredView = "text");
end logEvent2;
