within Dynawo.Electrical.Controls.Machines.StatorCurrentLimiters.Standard;

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

model Scl2c_INIT "IEEE overexcitation limiter type SCL2C initialization model"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.ComplexCurrentPuConnector it0Pu "Initial complex stator current in pu (base SnRef, UNom)";
  Dynawo.Connectors.ActivePowerPuConnector PGen0Pu "Initial active power in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.ReactivePowerPuConnector QGen0Pu "Initial reactive power in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.ComplexVoltagePuConnector ut0Pu "Initial complex stator voltage in pu (base UNom)";

  annotation(preferredView = "text");
end Scl2c_INIT;
