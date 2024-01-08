within Dynawo.Electrical.Controls.WECC.Parameters.REEC;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

record REECdParameters "Parameters for REECd"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.BaseREECParameters;

  //REECd parameters
  parameter Types.PerUnit IqFrzPu "Value to which reactive-current command is frozen after a voltage-dip in pu (base SNom, UNom) (typical: 0)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Types.PerUnit Kc "Reactive-current compensation gain in pu (base SNom, UNom) (typical: 0.01..0.05)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Types.PerUnit Ke "Scaling on IpMinPu in pu (base SNom, UNom) (typical: 0..1; set to 0 for a generator, set to a value between 0 and 1 for a storage device, as appropriate)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Boolean PFlag "Power reference flag: const. Pref (0) or consider generator speed (1)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Types.PerUnit QUMaxPu "Maximum value of the incoming Qext or Vext in pu (base SNom or UNom)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Types.PerUnit QUMinPu "Minimum value of the incoming Qext or Vext in pu (base SNom or UNom)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Types.PerUnit RcPu "Current-compensation resistance in pu (base SNom, UNom) (typical: 0..0.2)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Types.Time tBlkDelay "Time delay following blocking of the converter after which the converter is released from being blocked, in s (typical: 0.04..0.1)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Types.Time tHld "Time for which reactive-current command is frozen after a voltage-dip; if positive then iqCmdPu is frozen to its final value during the voltage-dip; if negative then iqCmdPu is frozen to IqFrzPu; in s (typical: 0, set to 0 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Types.Time tHld2 "Time for which active current is held at its value during a voltage-dip, following the termination of the voltage-dip; in s (typical: 0..1, set to 0 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Types.Time tR1 "Filter time constant for voltage measurement in s (typical: 0.02..0.05)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Types.VoltageModulePu UBlkHPu "Voltage above which the converter is blocked (i.e. Iq = Ip = 0), in pu (base UNom)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Types.VoltageModulePu UBlkLPu "Voltage below which the converter is blocked (i.e. Iq = Ip = 0), in pu (base UNom)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Boolean UCmpFlag "Voltage compensation flag : reactive droop (0) or current compensation (1)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Dynawo.Types.VoltageModulePu VRef1Pu = 0 "User-defined reference/bias on the inner-loop voltage control in pu (base UNom) (typical: 0)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));
  parameter Types.PerUnit XcPu "Current-compensation reactance in pu (base SNom, UNom) (typical: 0.01..0.12)" annotation(
    Dialog(tab = "Electrical Control", group = "REECd"));

  //CombiTable parameters
  parameter Types.PerUnit VDLIp11 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp12 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp21 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp22 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp31 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp32 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp41 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp42 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp51 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp52 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp61 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp62 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp71 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp72 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp81 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp82 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp91 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp92 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp101 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp102 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq11 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq12 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq21 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq22 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq31 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq32 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq41 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq42 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq51 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq52 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq61 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq62 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq71 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq72 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq81 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq82 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq91 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq92 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq101 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq102 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIpPoints[:, :] = [VDLIp11, VDLIp12; VDLIp21, VDLIp22; VDLIp31, VDLIp32; VDLIp41, VDLIp42; VDLIp51, VDLIp52; VDLIp61, VDLIp62; VDLIp71, VDLIp72; VDLIp81, VDLIp82; VDLIp91, VDLIp92; VDLIp101, VDLIp102] "Pair of points for voltage-dependent active current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIqPoints[:, :] = [VDLIq11, VDLIq12; VDLIq21, VDLIq22; VDLIq31, VDLIq32; VDLIq41, VDLIq42; VDLIq51, VDLIq52; VDLIq61, VDLIq62; VDLIq71, VDLIq72; VDLIq81, VDLIq82; VDLIq91, VDLIq92; VDLIq101, VDLIq102] "Pair of points for voltage-dependent reactive current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));

  annotation(
    preferredView = "text");
end REECdParameters;
