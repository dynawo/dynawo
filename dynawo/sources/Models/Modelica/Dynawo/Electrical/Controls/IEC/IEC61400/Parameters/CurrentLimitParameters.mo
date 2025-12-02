within Dynawo.Electrical.Controls.IEC.IEC61400.Parameters;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

record CurrentLimitParameters
  parameter Real TableIpMaxUwt[:,:] = [0, 0; 0.1, 0; 0.15, 1; 0.9, 1; 0.925, 1; 1.075, 1.0001; 1.1, 1.0001] "Voltage dependency of active current limits" annotation(
    Dialog(tab = "CurrentLimitTables"));


  parameter Real TableIqMaxUwt[:,:] = [0, 0; 0.1, 0; 0.15, 1; 0.9, 1; 0.925, 0.33; 1.075, 0.33; 1.1, 1; 1.1001, 1] "Voltage dependency of reactive current limits" annotation(
    Dialog(tab = "CurrentLimitTables"));

  annotation(
    preferredView = "text");
end CurrentLimitParameters;
