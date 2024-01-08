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

record BaseREGCParameters "Common parameters for generator converters"

  //Common parameters
  parameter Types.PerUnit IqrMaxPu "Rate at which reactive current (power) recovers after a fault when the initial reactive output of the unit is less than zero; in pu/s (base SNom, UNom) (typical: 1..999)" annotation(
    Dialog(tab = "Generator Converter", group = "Common"));
  parameter Types.PerUnit IqrMinPu "Rate at which reactive current (power) recovers after a fault when the initial reactive output of the unit is greater than zero; in pu/s (base SNom, UNom) (typical: -999..-1)" annotation(
    Dialog(tab = "Generator Converter", group = "Common"));
  parameter Boolean RateFlag "Active current (0) or active power (1) ramp (if unknown set to false)" annotation(
    Dialog(tab = "Generator Converter", group = "Common"));
  parameter Types.PerUnit RrpwrPu "Rate at which active current (power) recovers after a fault in pu/s (base SNom, UNom) (typical: 1..20)" annotation(
    Dialog(tab = "Generator Converter", group = "Common"));
  parameter Types.Time tFilterGC "Filtering time constant for voltage measurement in s (typical: 0.02..0.05, but can be set to 0)" annotation(
    Dialog(tab = "Generator Converter", group = "Common"));

  annotation(
    preferredView = "text");
end BaseREGCParameters;
