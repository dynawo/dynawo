within Dynawo.Electrical.Machines.SignalN.BaseClasses;

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

partial model BaseQStator "Base dynamic model for the calculation of QStatorPu in pu (base QNomAlt)"
  parameter Types.ReactivePower QNomAlt "Nominal reactive power of the generator on alternator side in Mvar";

  Dynawo.Connectors.ReactivePowerPuConnector QStatorPu "Stator reactive power in pu (base QNomAlt) (generator convention)";
  Types.ReactivePowerPu QStator "Stator reactive power in MVar (generator convention)";

equation
  QStator = QStatorPu * QNomAlt;

  annotation(preferredView = "text");
end BaseQStator;
