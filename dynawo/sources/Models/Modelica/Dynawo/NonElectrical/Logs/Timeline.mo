within Dynawo.NonElectrical.Logs;

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

encapsulated package Timeline "Timeline logs"

//
// Timeline logger function
// --------------------------
  function logEvent1 "Print a log message in event file using the multi-language dictionary"
    input Integer key;
    external "C" addLogEvent1(key) annotation(Include = "#include \"logEvent.h\"");

    annotation(preferredView = "text");
  end logEvent1;

  function logEvent2 "Print a log message in event file using the multi-language dictionary"
    input Integer key;
    input String arg1;
    external "C" addLogEvent2(key, arg1) annotation(Include = "#include \"logEvent.h\"");

    annotation(preferredView = "text");
  end logEvent2;

  function logEvent3 "Print a log message in event file using the multi-language dictionary"
    input Integer key;
    input String arg1;
    input String arg2;
    external "C" addLogEvent3(key, arg1, arg2) annotation(Include = "#include \"logEvent.h\"");

    annotation(preferredView = "text");
  end logEvent3;

  function logEvent4 "Print a log message in event file using the multi-language dictionary"
    input Integer key;
    input String arg1;
    input String arg2;
    input String arg3;
    external "C" addLogEvent4(key, arg1, arg2, arg3) annotation(Include = "#include \"logEvent.h\"");

    annotation(preferredView = "text");
  end logEvent4;

  function logEvent5 "Print a log message in event file using the multi-language dictionary"
    input Integer key;
    input String arg1;
    input String arg2;
    input String arg3;
    input String arg4;
    external "C" addLogEvent5(key, arg1, arg2, arg3, arg4) annotation(Include = "#include \"logEvent.h\"");

    annotation(preferredView = "text");
  end logEvent5;

  function logEventRaw1
    input String key1;

    external "C" addLogEventRaw1 (key1) annotation(Include = "#include \"logEvent.h\"");

    annotation(preferredView = "text");
  end logEventRaw1;

  function logEventRaw2
    input String key1;
    input String key2;

    external "C" addLogEventRaw2 (key1, key2) annotation(Include = "#include \"logEvent.h\"");

    annotation(preferredView = "text");
  end logEventRaw2;

  function logEventRaw3
    input String key1;
    input String key2;
    input String key3;

    external "C" addLogEventRaw3 (key1, key2, key3) annotation(Include = "#include \"logEvent.h\"");

    annotation(preferredView = "text");
  end logEventRaw3;

  function logEventRaw4
    input String key1;
    input String key2;
    input String key3;
    input String key4;

    external "C" addLogEventRaw4 (key1, key2, key3, key4) annotation(Include = "#include \"logEvent.h\"");

    annotation(preferredView = "text");
  end logEventRaw4;

  function logEventRaw5
    input String key1;
    input String key2;
    input String key3;
    input String key4;
    input String key5;

    external "C" addLogEventRaw5 (key1, key2, key3, key4, key5) annotation(Include = "#include \"logEvent.h\"");

    annotation(preferredView = "text");
  end logEventRaw5;

end Timeline;
