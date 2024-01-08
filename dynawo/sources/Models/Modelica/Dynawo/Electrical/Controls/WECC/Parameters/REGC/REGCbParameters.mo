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

record REGCbParameters "Parameters for REGCb"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.BaseREGCParameters;

  //REGCb parameters
  parameter Types.PerUnit RSourcePu = 0 "Source resistance in pu (base SNom, UNom) (typical: 0..0.01)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCb"));
  parameter Types.Time tE "Emulated delay in converter controls in s (typical: 0..0.02)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCb"));
  parameter Types.Time tG "Emulated delay in converter controls in s (typical: 0.02..0.05)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCb"));
  parameter Types.PerUnit XSourcePu "Source reactance in pu (base SNom, UNom) (typical: 0.05..0.2)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCb"));

  annotation(
    preferredView = "text");
end REGCbParameters;
