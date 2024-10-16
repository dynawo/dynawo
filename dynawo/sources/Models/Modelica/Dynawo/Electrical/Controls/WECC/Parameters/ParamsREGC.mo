within Dynawo.Electrical.Controls.WECC.Parameters;

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

record ParamsREGC
  parameter Types.PerUnit IqrMaxPu "Maximum rate-of-change of reactive current after fault in pu (base UNom, SNom) (typical: 1..999)" annotation(
    Dialog(tab="Generator Converter"));
  parameter Types.PerUnit IqrMinPu "Minimum rate-of-change of reactive current after fault in pu (base UNom, SNom) (typical: -999..-1)" annotation(
  Dialog(tab="Generator Converter"));
  parameter Boolean RateFlag "Active current (=false) or active power (=true) ramp (if unkown set to false)" annotation(
  Dialog(tab="Generator Converter"));
  parameter Types.PerUnit RrpwrPu "Active current (power) recovery rate in pu/s (base UNom, SNom) (typical: 1..20)" annotation(
  Dialog(tab="Generator Converter"));
  parameter Types.Time tFilterGC "Filter time constant of terminal voltage in s(Cannot be set to zero, typical: 0.02..0.05)" annotation(
  Dialog(tab="Generator Converter"));
  parameter Types.Time tG "Emulated delay in converter controls in s(Cannot be zero, typical: 0.02..0.05)" annotation(
  Dialog(tab="Generator Converter"));

  annotation(preferredView = "text");
end ParamsREGC;
