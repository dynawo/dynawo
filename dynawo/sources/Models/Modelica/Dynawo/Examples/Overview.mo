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

package Overview
  extends Icons.Information;

  annotation(
    preferredView = "info",
    Documentation(info = "<html><head></head><body><p>This package contains simple test cases to illustrate the way to use Dynawo models in a full Modelica environment. Each test case has been configured with the best options available in OpenModelica for power sytem simulations.</p><p>Please notice that the models available into the Dynawo library have been developed to be used with the DAE mode into OpenModelica. Unfortunately, there is currently a bug under correction into OpenModelica which prevents us from using the DAE mode into our examples (the link to external C methods is broken): it could either lead to a compilation error with some models (containing when loops with non linear conditions) or affect dramatically the performances. Once this will be corrected, the daeMode option will be uncommented in our test cases.</p></body></html>"));
end Overview;
