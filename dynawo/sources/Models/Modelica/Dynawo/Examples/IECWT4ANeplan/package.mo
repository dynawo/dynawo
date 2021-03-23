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

package IECWT4ANeplan "Wind Turbine Type 4A model from IEC 61400-27-1 standard in the Neplan WT4A test case"
  extends Icons.Package;
  annotation(
    Documentation(info = "<html><head></head><body>The Neplan test case was built based on the Neplan report describing the usage of the IEC 61400-27-1 wind turbine generator (WTG) of available in https://www.neplan.ch/wp-content/uploads/2015/08/NEPLAN_IEC-61400-27-1.pdf. We consider here the WT type 4 which are connected to the grid through a full scale power converter. In particular, here we consider the WT4a where the aerodynamic and mechanical parts are neglected, and a constant Q limitation control is used. The system is shown in Fig. 21.</body></html>"));
end IECWT4ANeplan;
