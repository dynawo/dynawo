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

record PControlParameters
  parameter Real TablePwpBiasfwpFiltCom11 = 0.95 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom12 = 1 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom21 = 1 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom22 = 0 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom31 = 1.05 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom32 = -1 annotation(
    Dialog(tab = "PControlTables"));

  parameter Real TablePwpBiasfwpFiltCom[:,:] = [TablePwpBiasfwpFiltCom11, TablePwpBiasfwpFiltCom12; TablePwpBiasfwpFiltCom21, TablePwpBiasfwpFiltCom22; TablePwpBiasfwpFiltCom31, TablePwpBiasfwpFiltCom32] "Table for defining power variation versus frequency" annotation(
    Dialog(tab = "PControlTables"));

  annotation(
    preferredView = "text");
end PControlParameters;
