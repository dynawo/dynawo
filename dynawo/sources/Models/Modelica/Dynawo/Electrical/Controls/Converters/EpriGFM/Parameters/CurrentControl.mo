within Dynawo.Electrical.Controls.Converters.EpriGFM.Parameters;

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

record CurrentControl "Current control parameters"
  parameter Types.PerUnit KPi "Proportional gain of the current loop, example value = 0.5" annotation(
  Dialog(tab = "CurrentControl"));
  parameter Types.PerUnit KIi "Integral gain of the current loop, example value = 5" annotation(
  Dialog(tab = "CurrentControl"));
  parameter Types.Time tE "PT1 constant for voltage output in s, example value = 0.01" annotation(
  Dialog(tab = "CurrentControl"));

  annotation(
  preferredView = "text");
end CurrentControl;
