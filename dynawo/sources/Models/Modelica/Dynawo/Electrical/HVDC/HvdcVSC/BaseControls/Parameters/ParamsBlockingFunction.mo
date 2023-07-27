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

record ParamsBlockingFunction
  parameter Types.VoltageModulePu UBlockUVPu "Minimum voltage that triggers the blocking function in pu (base UNom)";
  parameter Types.Time TBlockUV "If UPu < UBlockUVPu during TBlockUV then the blocking is activated";
  parameter Types.Time TBlock "The blocking is activated during at least TBlock";
  parameter Types.Time TDeblockU "When UPu goes back between UMindbPu and UMaxdbPu for TDeblockU then the blocking is deactivated";
  parameter Types.VoltageModulePu UMindbPu "Minimum voltage that deactivates the blocking function in pu (base UNom)";
  parameter Types.VoltageModulePu UMaxdbPu "Maximum voltage that deactivates the blocking function in pu (base UNom)";
  parameter Types.Time tFilter = 0.01 "Time constant of the measurement filter in s";

  annotation(preferredView = "text");
end ParamsBlockingFunction;
