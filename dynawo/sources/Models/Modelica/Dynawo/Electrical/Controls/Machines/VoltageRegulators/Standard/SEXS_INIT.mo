within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com) and UPC/Citcea (https://www.citcea.upc.edu/)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SEXS_INIT "IEEE Automatic Voltage Regulator type SEXS initialization model"
  import Modelica;
  extends AdditionalIcons.Init;

  parameter Types.VoltageModulePu Upss0Pu = 0 "Initial PSS output voltage in pu (base UNom)";
  parameter Types.PerUnit K "Controller gain";

  Modelica.Blocks.Interfaces.RealInput Efd0Pu(start = 1) "Initial voltage output in pu (base UNom)";
  Modelica.Blocks.Interfaces.RealInput Us0Pu(start = 1) "Initial stator voltage in pu (base UNom)";
  Modelica.Blocks.Interfaces.RealInput UsRef0Pu "Initial control voltage in pu (base UNom)";

equation
  UsRef0Pu = Us0Pu + Efd0Pu / K - Upss0Pu;

  annotation(
    preferredView = "text",
    uses(Modelica(version = "3.2.3")));
end SEXS_INIT;
