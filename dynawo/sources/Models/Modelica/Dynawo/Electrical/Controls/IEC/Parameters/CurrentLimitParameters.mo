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

record CurrentLimitParameters
  parameter Real TableIpMaxUwt11 = 0 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt12 = 0 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt21 = 0.1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt22 = 0 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt31 = 0.15 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt32 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt41 = 0.9 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt42 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt51 = 0.925 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt52 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt61 = 1.075 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt62 = 1.0001 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt71 = 1.1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt72 = 1.0001 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt[:,:] = [TableIpMaxUwt11, TableIpMaxUwt12; TableIpMaxUwt21, TableIpMaxUwt22; TableIpMaxUwt31, TableIpMaxUwt32; TableIpMaxUwt41, TableIpMaxUwt42; TableIpMaxUwt51, TableIpMaxUwt52; TableIpMaxUwt61, TableIpMaxUwt62; TableIpMaxUwt71, TableIpMaxUwt72] "Voltage dependency of active current limits" annotation(
    Dialog(tab = "CurrentLimitTables"));

  parameter Real TableIqMaxUwt11 = 0 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt12 = 0 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt21 = 0.1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt22 = 0 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt31 = 0.15 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt32 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt41 = 0.9 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt42 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt51 = 0.925 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt52 = 0.33 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt61 = 1.075 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt62 = 0.33 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt71 = 1.1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt72 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt81 = 1.1001 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt82 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt[:,:] = [TableIqMaxUwt11, TableIqMaxUwt12; TableIqMaxUwt21, TableIqMaxUwt22; TableIqMaxUwt31, TableIqMaxUwt32; TableIqMaxUwt41, TableIqMaxUwt42; TableIqMaxUwt51, TableIqMaxUwt52; TableIqMaxUwt61, TableIqMaxUwt62; TableIqMaxUwt71, TableIqMaxUwt72; TableIqMaxUwt81, TableIqMaxUwt82] "Voltage dependency of reactive current limits" annotation(
    Dialog(tab = "CurrentLimitTables"));

  annotation(
    preferredView = "text");
end CurrentLimitParameters;
