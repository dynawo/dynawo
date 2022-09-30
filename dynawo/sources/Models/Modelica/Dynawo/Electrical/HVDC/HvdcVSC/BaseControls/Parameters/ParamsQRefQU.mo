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

record ParamsQRefQU "Parameters of reactive power reference calculation"
  parameter Types.PerUnit KiAc "Integral coefficient of the PI controller for the AC voltage control";
  parameter Types.PerUnit KpAc "Proportional coefficient of the PI controller for the AC voltage control";
  parameter Types.PerUnit LambdaPu "Lambda coefficient for the QRefUPu calculation in pu (base SNom, UNom)";
  parameter Types.PerUnit SlopeQRefPu "Slope of the ramp of QRefPu in pu/s (base SNom)";
  parameter Types.PerUnit SlopeURefPu "Slope of the ramp of URefPu in pu/s (base UNom)";

  annotation(preferredView = "text");
end ParamsQRefQU;
