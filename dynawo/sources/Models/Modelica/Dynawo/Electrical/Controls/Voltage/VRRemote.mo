within Dynawo.Electrical.Controls.Voltage;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model VRRemote "Model for centralized remote voltage regulation"

import Dynawo.Connectors;
import Dynawo.Types;

  parameter Types.VoltageModulePu U0Pu "Start value of the regulated voltage in p.u (base UNom)";
  parameter Real Gain "Control gain";
  parameter Types.Time tIntegral "Time integration constant";

  Connectors.ImPin URefPu (value(start = U0Pu)) "Voltage regulation set point in p.u (base UNom)";
  Connectors.ImPin URegulatedPu (value(start = U0Pu)) "Regulated voltage in p.u (base UNom)";
  Connectors.ImPin NQ "Signal to change the reactive power generation of the generators participating in the centralized distant voltage regulation";

protected
  Types.PerUnit UErrorIntegralPu (start = 0) "Time-integral of the control error in p.u (base UNom)";

equation
  der(UErrorIntegralPu) = Gain/tIntegral * (URefPu.value - URegulatedPu.value);
  NQ.value = (URefPu.value - URegulatedPu.value) * Gain + UErrorIntegralPu;

annotation(preferredView = "text");
end VRRemote;
