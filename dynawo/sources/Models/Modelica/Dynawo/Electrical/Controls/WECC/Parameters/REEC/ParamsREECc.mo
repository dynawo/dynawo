within Dynawo.Electrical.Controls.WECC.Parameters.REEC;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record ParamsREECc "REEC type C parameters"
  parameter Types.PerUnit SOCMaxPu "Maximum allowable state of charge in pu (base SNom) (typical: 0.8..1)" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit SOCMinPu "Minimum allowable state of charge in pu (base SNom) (typical: 0..0.2)" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.Time tBattery "Time it takes for the battery to discharge when putting out 1 pu power, in s (typically set to 9999 since most batteries are large as compared to the typical simulation time in a stability study)" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIp11 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIp12 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIp21 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIp22 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIp31 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIp32 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIp41 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIp42 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIq11 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIq12 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIq21 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIq22 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIq31 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIq32 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIq41 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIq42 annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIpPoints[:, :] = [VDLIp11, VDLIp12; VDLIp21, VDLIp22; VDLIp31, VDLIp32; VDLIp41, VDLIp42] "Pair of points for voltage-dependent active current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit VDLIqPoints[:, :] = [VDLIq11, VDLIq12; VDLIq21, VDLIq22; VDLIq31, VDLIq32; VDLIq41, VDLIq42] "Pair of points for voltage-dependent reactive current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));

  // Initial parameter
  parameter Types.PerUnit SOC0Pu "Initial state of charge in pu (base SNom)" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));

  annotation(preferredView = "text");
end ParamsREECc;
