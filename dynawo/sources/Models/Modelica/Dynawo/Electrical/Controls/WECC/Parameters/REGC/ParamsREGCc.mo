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

record ParamsREGCc "REGC type C parameters"
  parameter Types.CurrentModulePu IMaxPu "Maximum current rating of the converter in pu (base SNom, UNom)" annotation(
  Dialog(tab="Generator Converter", group = "REGCc"));
  parameter Types.PerUnit Kii "Integrator gain of the inner current loop" annotation(
  Dialog(tab="Generator Converter", group = "REGCc"));
  parameter Types.PerUnit Kip "Proportional gain of the inner current loop" annotation(
  Dialog(tab="Generator Converter", group = "REGCc"));
  parameter Boolean RateFlag "Active current (=false) or active power (=true) ramp (if unkown set to false)" annotation(
  Dialog(tab="Generator Converter", group = "REGCc"));

  annotation(preferredView = "text");
end ParamsREGCc;
