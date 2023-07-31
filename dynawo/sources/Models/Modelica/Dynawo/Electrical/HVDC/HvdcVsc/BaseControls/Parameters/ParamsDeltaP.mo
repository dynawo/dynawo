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

record ParamsDeltaP "Parameters of DeltaP calculation"
  parameter Types.PerUnit KiDeltaP "Integral coefficient of the PI controller for the calculation of DeltaP";
  parameter Types.PerUnit KpDeltaP "Proportional coefficient of the PI controller for the calculation of DeltaP";
  parameter Types.VoltageModulePu UDcMaxPu "Maximum value of the DC voltage in pu (base UDcNom)";
  parameter Types.VoltageModulePu UDcMinPu "Minimum value of the DC voltage in pu (base UDcNom)";

  annotation(preferredView = "text");
end ParamsDeltaP;
