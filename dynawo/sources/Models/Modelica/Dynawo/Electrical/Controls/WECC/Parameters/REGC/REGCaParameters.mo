within Dynawo.Electrical.Controls.WECC.Parameters.REGC;

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

record REGCaParameters "Parameters for REGCa"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.BaseREGCParameters;

  //REGCa parameters
  parameter Types.VoltageModulePu Brkpt "Low Voltage Power Logic breakpoint, used only when LvplSw = 1; voltage point in pu (base UNom) below which active current is linearly reduced as a function of voltage until it reaches zero at Zerox (typical: 0.05..0.9)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));
  parameter Types.PerUnit Lvpl1 "Low Voltage Power Logic active current limit at Brkpt and above, in pu (base SNom, UNom) (typical: 1.1..1.5)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));
  parameter Boolean LvplSw "Enable (1) or disable (0) Low Voltage Power Logic" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));
  parameter Types.Time tG "Emulated delay in converter controls in s (typical: 0.02..0.05)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));
  parameter Types.VoltageModulePu Zerox "Low Voltage Power Logic zero crossing, used only when LvplSw = 1; voltage point in pu (base UNom) below which active current becomes zero (typical: 0.02..0.5)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));

  annotation(
    preferredView = "text");
end REGCaParameters;
