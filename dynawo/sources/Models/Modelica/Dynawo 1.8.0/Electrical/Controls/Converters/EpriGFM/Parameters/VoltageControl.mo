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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

record VoltageControl "Voltage control parameters"
  parameter Types.PerUnit IMaxPu "Max current in pu (base UNom, SNom), example value = 1.05" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit KIp "Integral gain of the power loop, example value = 10" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit KIv "Integral gain of the voltage loop, example value = 150 if OmegaFlag=0 else 10" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit KPp "Proportional gain of the power loop, example value = 2" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit KPv "Proportional gain of the voltage loop, example value = 0.5 if OmegaFlag=0 else 2.0" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit OmegaDroopPu "Frequency droop in pu, example value = 0.05" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Boolean PQFlag "Active or active power priority flag: false = P priority, true = Q priority" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit QDroopPu "Voltage droop in pu, example value = 0.2" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit UDipPu "Freeze voltage in pu (base UNom), example value = 0.85" annotation(
  Dialog(tab = "VoltageControl"));

  annotation(
  preferredView = "text");
end VoltageControl;
