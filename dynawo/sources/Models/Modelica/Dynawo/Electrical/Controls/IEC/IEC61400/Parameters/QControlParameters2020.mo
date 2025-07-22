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

record QControlParameters2020
  parameter Real TableQwpMaxPwpFiltCom[:,:] = [0, 0.33; 0.5, 0.33; 1, 0.33] "Power dependent reactive power maximum limit" annotation(
    Dialog(tab = "QControlTables"));

  parameter Real TableQwpMinPwpFiltCom[:,:] = [0, -0.33; 0.5, -0.33; 1, -0.33] "Power dependent reactive power minimum limit" annotation(
    Dialog(tab = "QControlTables"));

  parameter Real TableQwpUErr[:,:] = [-0.05, 1.21; 0, 0.21; 0.05, -0.79] "Table for the UQ static mode" annotation(
    Dialog(tab = "QControlTables"));

  annotation(
    preferredView = "text");
end QControlParameters2020;
