within Dynawo.Electrical.Controls.Machines.UnderExcitationLimiters.Standard;

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

model Uel1_INIT "IEEE overexcitation limiter type UEL1 initialization model"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.ComplexCurrentPuConnector it0Pu "Initial complex stator current in pu (base SnRef, UNom)";
  Dynawo.Connectors.ComplexVoltagePuConnector ut0Pu "Initial complex stator voltage in pu (base UNom)";

  annotation(preferredView = "text");
end Uel1_INIT;
