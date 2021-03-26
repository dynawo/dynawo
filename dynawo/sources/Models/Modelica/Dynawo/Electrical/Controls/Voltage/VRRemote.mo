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

  parameter Types.VoltageModulePu URef0 "Start value of the regulated voltage reference in kV";
  parameter Types.VoltageModulePu U0 "Start value of the regulated voltage in kV";
  parameter Real Gain "Control gain";
  parameter Types.Time tIntegral "Time integration constant";

  Connectors.ImPin URef (value(start = URef0)) "Voltage regulation set point in kV";
  Connectors.ImPin URegulated (value(start = U0)) "Regulated voltage in kV";
  Connectors.ImPin NQ "Signal to change the reactive power generation of the generators participating in the centralized distant voltage regulation (generator convention)";

protected
  Types.PerUnit UErrorIntegral (start = 0) "Time-integral of the control error in kV";

equation
  der(UErrorIntegral) = Gain/tIntegral * (URef.value - URegulated.value);
  NQ.value = (URef.value - URegulated.value) * Gain + UErrorIntegral;

annotation(preferredView = "text");
end VRRemote;
