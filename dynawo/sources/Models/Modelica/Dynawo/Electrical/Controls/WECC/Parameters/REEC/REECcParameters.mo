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

record REECcParameters "Parameters for REECc"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.BaseREECParameters;

  //REECc parameters
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive output limit in pu (base SNom) (typical: 0..1, set to 9999 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive output limit in pu (base SNom) (typical: -1..0, set to -9999 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit SOCMaxPu = 1 "Maximum allowable state of charge in pu (base SNom) (typical: 0.8..1)" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.PerUnit SOCMinPu = 0 "Minimum allowable state of charge in pu (base SNom) (typical: 0..0.2)" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.Time tBattery "Time it takes for the battery to discharge when putting out 1 pu power, in s (typically set to 9999 since most batteries are large as compared to the typical simulation time in a transient stability study)" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Types.Time tHld2 "Time for which active current is held at its value during a voltage-dip, following the termination of the voltage-dip; in s (typical: 0..1, set to 0 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));
  parameter Dynawo.Types.PerUnit VRef1Pu = 0 "User-defined reference/bias on the inner-loop voltage control in pu (base UNom) (typical: 0)" annotation(
    Dialog(tab = "Electrical Control", group = "REECc"));

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
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIqPoints[:, :] = [VDLIq11, VDLIq12 ; VDLIq21, VDLIq22] "Pair of points for voltage-dependent reactive current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control", group = "Current limit CombiTable"));

  annotation(
    preferredView = "text");
end REECcParameters;
