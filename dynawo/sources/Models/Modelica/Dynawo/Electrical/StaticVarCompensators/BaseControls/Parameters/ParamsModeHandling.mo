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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record ParamsModeHandling

  parameter Types.Time tThresholdDown "Time duration associated with the condition U < UThresholdDown for the change from standby to running mode, in s";
  parameter Types.Time tThresholdUp "Time duration associated with the condition U > UThresholdUp for the change from standby to running mode, in s";
  parameter Types.VoltageModule URefDown "Voltage reference taken into account when the static var compensator switches from standby mode to running mode by falling under UThresholdDown for more than tThresholdDown seconds, in kV";
  parameter Types.VoltageModule URefUp "Voltage reference taken into account when the static var compensator switches from standby mode to running mode by exceeding UThresholdUp for more than tThresholdUp seconds, in kV";
  parameter Types.VoltageModule UThresholdDown "Voltage value under which the static var compensator automatically switches from standby mode to running mode, in kV";
  parameter Types.VoltageModule UThresholdUp "Voltage value above which the static var compensator automatically switches from standby mode to running mode, in kV";

  annotation(preferredView = "text");
end ParamsModeHandling;
