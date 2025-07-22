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

record GridProtectionParameters
  parameter Real TabletUoverUwtfilt[:,:] = [1, 0.33; 1.5, 0.33; 2, 0.33; 2.01, 0.33; 2.02, 0.33; 2.03, 0.33; 2.04, 0.33; 2.05, 0.33] "Disconnection time versus over voltage lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  parameter Real TabletUunderUwtfilt[:,:] = [0, 0.33; 0.5, 0.33; 1, 0.33; 1.01, 0.33; 1.02, 0.33; 1.03, 0.33; 1.04, 0.33] "Disconnection time versus under voltage lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  parameter Real Tabletfoverfwtfilt[:,:] = [1, 0.33; 1.5, 0.33; 2, 0.33; 2.01, 0.33] "Disconnection time versus over frequency lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  parameter Real Tabletfunderfwtfilt[:,:] = [0, 0.33; 0.5, 0.33; 1, 0.33; 1.01, 0.33; 1.02, 0.33; 1.03, 0.33] "Disconnection time versus under frequency lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  annotation(
    preferredView = "text");
end GridProtectionParameters;
