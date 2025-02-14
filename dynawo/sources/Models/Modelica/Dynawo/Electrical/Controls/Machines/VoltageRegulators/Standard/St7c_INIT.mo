within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model St7c_INIT "IEEE excitation system type ST7C initialization model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT;

  //Regulation parameters
  parameter Types.PerUnit Kia "Voltage regulator feedback gain";
  parameter Types.PerUnit Kpa "Voltage regulator proportional gain";

  Types.VoltageModulePuConnector UsRef0Pu "Initial reference stator voltage in pu (base UNom)";

equation
  UsRef0Pu = (1 + Kia) * Efd0Pu / Kpa + Us0Pu;

  annotation(preferredView = "text");
end St7c_INIT;
