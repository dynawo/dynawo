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

record QControlParameters2015
  parameter Real TableQwpUErr11 = -0.05 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr12 = 1.21 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr21 = 0 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr22 = 0.21 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr31 = 0.05 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr32 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr41 = 0.06 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr42 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr51 = 0.07 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr52 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr61 = 0.08 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr62 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr[:,:] = [TableQwpUErr11, TableQwpUErr12; TableQwpUErr21, TableQwpUErr22; TableQwpUErr31, TableQwpUErr32; TableQwpUErr41, TableQwpUErr42; TableQwpUErr51, TableQwpUErr52; TableQwpUErr61, TableQwpUErr62] "Table for the UQ static mode" annotation(
    Dialog(tab = "QControlTables"));

  annotation(
    preferredView = "text");
end QControlParameters2015;
