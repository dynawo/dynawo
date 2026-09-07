within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters;

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

record ParamsDcVoltageControl "Parameters of DC voltage control"
  parameter Types.PerUnit KiDc "Integral coefficient of the PI controller for the DC voltage control";
  parameter Types.PerUnit KpDc "Proportional coefficient of the PI controller for the DC voltage control";
  parameter Types.Time tMeasureU "Time constant of the voltage measurement filter in s";
  parameter Types.VoltageModulePu UDcRefMaxPu "Maximum value of the DC voltage reference in pu (base UDcNom)";
  parameter Types.VoltageModulePu UDcRefMinPu "Minimum value of the DC voltage reference in pu (base UDcNom)";

  annotation(preferredView = "text");
end ParamsDcVoltageControl;
