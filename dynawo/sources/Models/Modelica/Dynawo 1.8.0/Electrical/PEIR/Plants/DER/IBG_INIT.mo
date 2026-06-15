within Dynawo.Electrical.PEIR.Plants.DER;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model IBG_INIT "Initialization model for IBGs"
  extends Dynawo.Electrical.Sources.InjectorIDQ_INIT;

  // Rating
  parameter Types.CurrentModulePu IMaxPu "Maximum current of the injector in pu (base UNom, SNom)";

  // Voltage support
  parameter Types.VoltageModulePu US1 "Lower voltage limit of deadband in pu (base UNom)";
  parameter Types.VoltageModulePu US2 "Higher voltage limit of deadband in pu (base UNom)";
  parameter Real kRCI "Slope of reactive current increase for low voltages in pu (base UNom, SNom)";
  parameter Real kRCA "Slope of reactive current decrease for high voltages in pu (base UNom, SNom)";
  parameter Real m "Current injection just outside of lower deadband in pu (base IMaxPu)";
  parameter Real n "Current injection just outside of lower deadband in pu (base IMaxPu)";

protected
  Types.PerUnit IqRef0Pu "Start value of the reference q-axis current at injector in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IqSup0Pu "Start value of the reactive current support (base Unom, SNom) (generator convention)";

equation
  if U0Pu < US1 then
    IqSup0Pu = m * IMaxPu + kRCI * (US1 - U0Pu);
  elseif U0Pu < US2 then
    IqSup0Pu = 0;
  else
    IqSup0Pu = -n * IMaxPu + kRCA * (U0Pu - US2);
  end if;

  -Iq0Pu = IqRef0Pu + IqSup0Pu;

  annotation(preferredView = "text");
end IBG_INIT;
