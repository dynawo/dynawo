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

record QControlParameters
  parameter Real TableQwpMaxPwpFiltCom11 = 0 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMaxPwpFiltCom12 = 0.33 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMaxPwpFiltCom21 = 0.5 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMaxPwpFiltCom22 = 0.33 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMaxPwpFiltCom31 = 1 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMaxPwpFiltCom32 = 0.33 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMaxPwpFiltCom[:,:] = [TableQwpMaxPwpFiltCom11,TableQwpMaxPwpFiltCom12;TableQwpMaxPwpFiltCom21,TableQwpMaxPwpFiltCom22;TableQwpMaxPwpFiltCom31,TableQwpMaxPwpFiltCom32] "Power dependent reactive power maximum limit" annotation(
    Dialog(tab = "QControlTables"));

  parameter Real TableQwpMinPwpFiltCom11 = 0 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMinPwpFiltCom12 = -0.33 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMinPwpFiltCom21 = 0.5 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMinPwpFiltCom22 = -0.33 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMinPwpFiltCom31 = 1 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMinPwpFiltCom32 = -0.33 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMinPwpFiltCom[:,:] = [TableQwpMinPwpFiltCom11,TableQwpMinPwpFiltCom12;TableQwpMinPwpFiltCom21,TableQwpMinPwpFiltCom22;TableQwpMinPwpFiltCom31,TableQwpMinPwpFiltCom32] "Power dependent reactive power minimum limit" annotation(
    Dialog(tab = "QControlTables"));

  parameter Real TableQwpUerr11 = -0.05 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUerr12 = 1.21 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUerr21 = 0 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUerr22 = 0.21 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUerr31 = 0.05 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUerr32 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUerr[:,:] = [TableQwpUerr11,TableQwpUerr12;TableQwpUerr21,TableQwpUerr22;TableQwpUerr31,TableQwpUerr32] "Table for the UQ static mode" annotation(
    Dialog(tab = "QControlTables"));

  annotation(
    preferredView = "text");
end QControlParameters;
