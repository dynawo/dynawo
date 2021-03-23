within Dynawo.Examples;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package VSCIB "Synchronous Machine Infinite Bus test cases"
  extends Icons.Package;
  annotation(
    Documentation(info = "<html><head></head><body>The VSCIB test case was built based on example 13.1 from Kundur Power System Stability and Control book where the synchronous machine is replaced by a Voltage Source Converter. It is is a well-known test case in the power system community. It is very often used to illustrate the transient or the small-signal stability of a  It is also used to demonstrate the behavior of a new regulation.</body></html>"));
end VSCIB;
