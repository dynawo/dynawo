within Dynawo.Electrical.Controls.WECC.Parameters.REGC;

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

record ParamsREGCa "REGC type A parameters"
  parameter Types.Time tG "Emulated delay in converter controls in s(Cannot be zero, typical: 0.02..0.05)" annotation(
  Dialog(tab="Generator Converter", group = "REGCa"));
  parameter Types.PerUnit brkpt "LVPL breakpoint in pu (base UNom)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));
  parameter Types.PerUnit lvpl1 "LVPL gain breakpoint in pu" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));
  parameter Boolean Lvplsw "Low voltage power logic switch: 1-enabled/0-disabled" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));
  parameter Types.PerUnit zerox "LVPL zero crossing in pu (base UNom)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));

  annotation(preferredView = "text");
end ParamsREGCa;
