within Dynawo.Electrical.StaticVarCompensators.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

partial model BaseModeHandling "Base dynamic model for static var compensator mode handling"

  input Boolean selectModeAuto(start = selectModeAuto0) "Whether the static var compensator is in automatic configuration";
  input Integer setModeManual(start = setModeManual0) "Mode selected when in manual configuration";

  parameter BaseControls.Mode Mode0 "Start value for mode";
  parameter Boolean selectModeAuto0 = true "Start value of the boolean indicating whether the SVarC is initially in automatic configuration";

  final parameter Integer setModeManual0 = Integer(Mode0) "Start value of the mode when in manual configuration";

  annotation(preferredView = "text");
end BaseModeHandling;
