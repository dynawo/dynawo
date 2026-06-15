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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record ParamsActivePowerControl "Parameters of active power control"
  parameter Types.PerUnit KiP "Integral coefficient of the PI controller for the active power control";
  parameter Types.PerUnit KpP "Proportional coefficient of the PI controller for the active power control";
  parameter Types.ActivePowerPu POpMaxPu "Maximum operator value of the active power in pu (base SNom) (DC to AC)";
  parameter Types.ActivePowerPu POpMinPu "Minimum operator value of the active power in pu (base SNom) (DC to AC)";
  parameter Types.Time SlopePRefPu "Slope of the ramp of PRefPu in pu/s (base SNom)";
  parameter Types.PerUnit SlopeRPFault "Slope of the recovery of rpfault after a fault in pu/s";
  parameter Types.Time tMeasureP "Time constant of the active power measurement filter in s";

  annotation(preferredView = "text");
end ParamsActivePowerControl;
