within Dynawo.Examples.HVDC;

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

package BaseModel "Base HVDC Model used for the test case"
  extends Icons.Package;
  annotation(
    Documentation(info = "<html><head></head><body>This model is the same as the HVDC VSC model but without the blocking function.</body></html>"));
end BaseModel;
