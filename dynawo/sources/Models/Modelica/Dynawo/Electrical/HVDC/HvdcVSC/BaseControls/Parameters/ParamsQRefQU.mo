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

record ParamsQRefQU
  parameter Types.PerUnit SlopeURefPu "Slope of the ramp of URefPu";
  parameter Types.PerUnit SlopeQRefPu "Slope of the ramp of QRefPu";
  parameter Types.PerUnit Lambda "Lambda coefficient for the QRefUPu calculation";
  parameter Types.PerUnit KiACVoltageControl "Integral coefficient of the PI controller for the ac voltage control";
  parameter Types.PerUnit KpACVoltageControl "Proportional coefficient of the PI controller for the ac voltage control";
  parameter Types.ReactivePowerPu QMinCombPu "Minimum combined reactive power in pu (base SNom)";
  parameter Types.ReactivePowerPu QMaxCombPu "Maximum combined reactive power in pu (base SNom)";
  parameter Types.PerUnit DeadBandU "Deadband for the QRefUPu calculation";

  annotation(preferredView = "text");
end ParamsQRefQU;
