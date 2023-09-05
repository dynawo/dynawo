within Dynawo.Electrical.StaticVarCompensators.BaseControls.Parameters;

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

record ParamsBlockingFunction

  parameter Types.VoltageModule UBlock "Voltage value under which the static var compensator is blocked, in kV";
  parameter Types.VoltageModule UUnblockDown "Lower voltage value defining the voltage interval in which the static var compensator is unblocked, in kV";
  parameter Types.VoltageModule UUnblockUp "Upper voltage value defining the voltage interval in which the static var compensator is unblocked, in kV";

  annotation(preferredView = "text");
end ParamsBlockingFunction;
