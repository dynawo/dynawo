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

record ParamsREGCb "REGC type B parameters"
  parameter Boolean RateFlag "Active current (=false) or active power (=true) ramp (if unkown set to false)" annotation(
  Dialog(tab="Generator Converter", group = "REGCb"));
  parameter Types.Time tG "Emulated delay in converter controls in s(Cannot be zero, typical: 0.02..0.05)" annotation(
  Dialog(tab="Generator Converter", group = "REGCb"));

  annotation(preferredView = "text");
end ParamsREGCb;
