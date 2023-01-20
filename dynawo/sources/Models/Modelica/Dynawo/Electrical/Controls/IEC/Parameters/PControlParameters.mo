within Dynawo.Electrical.Controls.IEC.Parameters;

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

record PControlParameters
  parameter Real TablePwpbiasFwpFiltCom11 = 0.95 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpbiasFwpFiltCom12 = 1 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpbiasFwpFiltCom21 = 1 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpbiasFwpFiltCom22 = 0 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpbiasFwpFiltCom31 = 1.05 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpbiasFwpFiltCom32 = -1 annotation(
    Dialog(tab = "PControlTables"));

  parameter Real TablePwpbiasFwpFiltCom[:,:] = [TablePwpbiasFwpFiltCom11,TablePwpbiasFwpFiltCom12;TablePwpbiasFwpFiltCom21,TablePwpbiasFwpFiltCom22;TablePwpbiasFwpFiltCom31,TablePwpbiasFwpFiltCom32] "Table for defining power variation versus frequency" annotation(
    Dialog(tab = "PControlTables"));

  annotation(
    preferredView = "text");
end PControlParameters;
