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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record ParamsREECe "REEC type E parameters"
  parameter Boolean VCompFlag "Type of compensation : if false, reactive droop, if true, current compensation" annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Boolean PEFlag "Allow local PI control for active power" annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Boolean PQFlagFRT "Allow different P/Q priority during fault conditions" annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Boolean PFlag "Power reference flag : if false, constant PRef, if true, consider generator speed" annotation(
    Dialog(tab="Electrical Control", group = "REECe"));

  parameter Types.PerUnit IqFrzPu "Constant reactive current command value in pu (base SNom, UNom) (typical: -0.1 .. 0.1 pu)" annotation(
    Dialog(tab="Electrical Control", group = "REECd"));
  parameter Types.PerUnit Kc "Reactive droop when VCompFlag = 0 (typical: 0 .. 0.15 pu)" annotation(
    Dialog(tab="Electrical Control", group = "REECd"));
  parameter Types.PerUnit Ke "Scaling on the IpminPu: 0 < Ke ≤ 1, set to 0 for generator and non-zero for a storage device" annotation(
    Dialog(tab="Electrical Control", group = "REECd"));
  parameter Types.PerUnit Kpp "Proportionnal gain for local control of active power" annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit Kpi "Integral gain for local control of active power" annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit RcPu "Current compensation resistance in pu (base SnRef, UNom) (typical: 0 .. 0.02 pu)" annotation(
    Dialog(tab="Electrical Control", group = "REECd"));
  parameter Types.Time tBlkDelay "Time delay for unblocking after voltage recovers (UBlkLPu < UtFilteredPu < UBlkHPu) in s (typical: 0.04 .. 0.1 s)" annotation(
    Dialog(tab="Electrical Control", group = "REECd"));
  parameter Types.Time tHoldIpMax "Time delay for which the active current limit (ipMaxPu) is held after voltage dip in s (typical: 0 s)" annotation(
    Dialog(tab="Electrical Control", group = "REECd"));
  parameter Types.Time tHoldIq "Absolute value of tHoldIq defines seconds to hold current command after voltage dip ended. tHoldIq > 0 for constant, 0 for continuous command, tHoldIq < 0 to hold command after a dip (typical: -1 .. 1 s)" annotation(
    Dialog(tab="Electrical Control", group = "REECd"));
  parameter Types.Time tR1 "Filter time constant in s (typical: 0 .. 0.5 s)" annotation(
    Dialog(tab="Electrical Control", group = "REECd"));
  parameter Types.VoltageModulePu UBlkHPu "Voltage above which the converter will block in pu (base UNom)" annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.VoltageModulePu UBlkLPu "Voltage below which the converter will block in pu (base UNom)" annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp11 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp12 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp21 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp22 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp31 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp32 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp41 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp42 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp51 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp52 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp61 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp62 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp71 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp72 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp81 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp82 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp91 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp92 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp101 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIp102 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq11 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq12 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq21 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq22 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq31 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq32 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq41 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq42 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq51 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq52 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq61 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq62 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq71 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq72 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq81 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq82 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq91 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq92 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq101 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIq102 annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIpPoints[:, :] = [VDLIp11, VDLIp12; VDLIp21, VDLIp22; VDLIp31, VDLIp32; VDLIp41, VDLIp42; VDLIp51, VDLIp52; VDLIp61, VDLIp62; VDLIp71, VDLIp72; VDLIp81, VDLIp82; VDLIp91, VDLIp92; VDLIp101, VDLIp102] "Pair of points for voltage-dependent active current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit VDLIqPoints[:, :] = [VDLIq11, VDLIq12; VDLIq21, VDLIq22; VDLIq31, VDLIq32; VDLIq41, VDLIq42; VDLIq51, VDLIq52; VDLIq61, VDLIq62; VDLIq71, VDLIq72; VDLIq81, VDLIq82; VDLIq91, VDLIq92; VDLIq101, VDLIq102] "Pair of points for voltage-dependent reactive current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.VoltageModulePu VRef1Pu "User-defined reference/bias on the inner-loop voltage control in pu (base UNom) (typical: 0 pu)" annotation(
    Dialog(tab="Electrical Control", group = "REECe"));
  parameter Types.PerUnit XcPu "Current compensation reactance in pu (base SnRef, UNom)(typical: 0 .. 0.15 pu)" annotation(
    Dialog(tab="Electrical Control", group = "REECe"));

  annotation(preferredView = "text");
end ParamsREECe;
