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

record QLimitParameters

  parameter Real TableQMaxUwtcFilt11 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt12 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt21 = 0.001 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt22 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt31 = 0.8 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt32 = 0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt41 = 1.2 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt42 = 0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt[:, :] = [TableQMaxUwtcFilt11, TableQMaxUwtcFilt12; TableQMaxUwtcFilt21, TableQMaxUwtcFilt22; TableQMaxUwtcFilt31, TableQMaxUwtcFilt32; TableQMaxUwtcFilt41, TableQMaxUwtcFilt42] "Voltage dependency of reactive power maximum limit" annotation(
    Dialog(tab = "QLimitTables"));

  parameter Real TableQMinUwtcFilt11 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt12 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt21 = 0.001 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt22 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt31 = 0.8 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt32 = -0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt41 = 1.2 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt42 = -0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt[:, :] = [TableQMinUwtcFilt11, TableQMinUwtcFilt12; TableQMinUwtcFilt21, TableQMinUwtcFilt22; TableQMinUwtcFilt31, TableQMinUwtcFilt32; TableQMinUwtcFilt41, TableQMinUwtcFilt42] "Voltage dependency of reactive power minimum limit" annotation(
    Dialog(tab = "QLimitTables"));

  parameter Real TableQMaxPwtcFilt11 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt12 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt21 = 0.001 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt22 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt31 = 0.3 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt32 = 0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt41 = 1 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt42 = 0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt[:, :] = [TableQMaxPwtcFilt11, TableQMaxPwtcFilt12; TableQMaxPwtcFilt21, TableQMaxPwtcFilt22; TableQMaxPwtcFilt31, TableQMaxPwtcFilt32; TableQMaxPwtcFilt41, TableQMaxPwtcFilt42] "Active power dependency of reactive power maximum limit" annotation(
    Dialog(tab = "QLimitTables"));

  parameter Real TableQMinPwtcFilt11 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt12 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt21 = 0.001 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt22 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt31 = 0.3 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt32 = -0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt41 = 1 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt42 = -0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt[:, :] = [TableQMinPwtcFilt11, TableQMinPwtcFilt12; TableQMinPwtcFilt21, TableQMinPwtcFilt22; TableQMinPwtcFilt31, TableQMinPwtcFilt32; TableQMinPwtcFilt41, TableQMinPwtcFilt42] "Active power dependency of reactive power minimum limit" annotation(
    Dialog(tab = "QLimitTables"));

  annotation(
    preferredView = "text");
end QLimitParameters;
