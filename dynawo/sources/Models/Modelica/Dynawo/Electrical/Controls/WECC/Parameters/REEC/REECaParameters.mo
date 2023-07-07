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

record REECaParameters "Parameters for REECa"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.BaseREECParameters;

  //REECa parameters
  parameter Types.PerUnit IqFrzPu "Value at which reactive current injection (during a voltage-dip) is held for tHld seconds following a voltage dip if tHld > 0; in pu (base SNom, UNom) (typical: 0..Iqh1)" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Boolean PFlag "Power reference flag: directly Pref (0) or consider generator speed (1)" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive output limit in pu (base SNom) (typical: 0..1, set to 9999 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive output limit in pu (base SNom) (typical: -1..0, set to -9999 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.Time tHld "Time for which reactive current injection is held at some value following termination of the voltage-dip; if positive, then current is held at IqFrzPu, if negative then held at the value just prior to ending of the voltage-dip; in s (typical: -1..1, set to 0 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.Time tHld2 "Time for which active current is held at its value during a voltage-dip, following the termination of the voltage-dip; in s (typical: 0..1, set to 0 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Dynawo.Types.VoltageModulePu VRef1Pu = 0 "User-defined reference/bias on the inner-loop voltage control in pu (base UNom) (typical: 0)" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));

  //CombiTable parameters
  parameter Types.PerUnit VDLIp11 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp12 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp21 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIp22 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq11 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq12 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq21 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIq22 annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIpPoints[:, :] = [VDLIp11, VDLIp12 ; VDLIp21, VDLIp22] "Pair of points for voltage-dependent active current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));
  parameter Types.PerUnit VDLIqPoints[:, :] = [VDLIq11, VDLIq12 ; VDLIq21, VDLIq22] "Pair of points for voltage-dependent reactive current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));

  annotation(
    preferredView = "text");
end REECaParameters;
