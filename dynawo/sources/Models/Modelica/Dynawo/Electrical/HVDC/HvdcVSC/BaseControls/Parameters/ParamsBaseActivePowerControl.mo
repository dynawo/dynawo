within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.Parameters;

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

record ParamsBaseActivePowerControl
  extends ParamsRPFaultFunction;

  parameter Types.PerUnit KpPControl "Proportional coefficient of the PI controller for the active power control";
  parameter Types.PerUnit KiPControl "Integral coefficient of the PI controller for the active power control";
  parameter Types.ActivePowerPu PMaxOPPu "Maximum operator value of the active power in pu (base SNom)";
  parameter Types.ActivePowerPu PMinOPPu "Minimum operator value of the active power in pu (base SNom)";
  parameter Types.Time SlopePRefPu "Slope of the ramp of PRefPu";

  annotation(preferredView = "text");
end ParamsBaseActivePowerControl;
