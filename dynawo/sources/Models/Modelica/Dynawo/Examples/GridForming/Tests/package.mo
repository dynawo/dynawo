within Dynawo.Examples.GridForming;

package Tests "Grid Forming converters test cases from DTR I18"
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
  extends Icons.Package;










  annotation(
    Documentation(info = "<html><head></head><body>This package contains basic test cases from the DTR I18 information sheet that illustrate the developed grid-forming converters models. Test matrices are derived from different Operating Condtions (OC) with several Short-Circuit Ratios (SCR) representing a \"weak\", \"medium\" or \"strong\" grid. Tested cases are :&nbsp;<div><br><div>- Voltage Angle Step at the infinite Bus.</div><div>- Voltage Amplitude Step at the infinite Bus.</div><div>- RoCoF with initial frequency not equal to 50 Hz.</div><div>- SCR Jump at the line</div><div>- Node Fault</div></div></body></html>"));
end Tests;
