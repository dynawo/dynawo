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

  parameter Real TabletUoverUwtfilt11 = 1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt12 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt21 = 1.5 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt22 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt31 = 2 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt32 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt[:, :] = [TabletUoverUwtfilt11, TabletUoverUwtfilt12; TabletUoverUwtfilt21, TabletUoverUwtfilt22; TabletUoverUwtfilt31, TabletUoverUwtfilt32] "Disconnection time versus over voltage lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  parameter Real TabletUunderUwtfilt11 = 0 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt12 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt21 = 0.5 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt22 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt31 = 1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt32 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt[:, :] = [TabletUunderUwtfilt11, TabletUunderUwtfilt12; TabletUunderUwtfilt21, TabletUunderUwtfilt22; TabletUunderUwtfilt31, TabletUunderUwtfilt32] "Disconnection time versus under voltage lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  parameter Real Tabletfoverfwtfilt11 = 1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt12 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt21 = 1.5 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt22 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt31 = 2 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt32 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt[:, :] = [Tabletfoverfwtfilt11, Tabletfoverfwtfilt12; Tabletfoverfwtfilt21, Tabletfoverfwtfilt22; Tabletfoverfwtfilt31, Tabletfoverfwtfilt32] "Disconnection time versus over frequency lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  parameter Real Tabletfunderfwtfilt11 = 0 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt12 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt21 = 0.5 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt22 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt31 = 1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt32 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt[:, :] = [Tabletfunderfwtfilt11, Tabletfunderfwtfilt12; Tabletfunderfwtfilt21, Tabletfunderfwtfilt22; Tabletfunderfwtfilt31, Tabletfunderfwtfilt32] "Disconnection time versus under frequency lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  annotation(
    preferredView = "text");
end GridProtectionParameters;
