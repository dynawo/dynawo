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

record ParamsACEmulation
  parameter Types.Time tFilter "Time constant of the angle measurement filter";
  parameter Types.PerUnit KACEmulation "Inverse of the emulated AC reactance (base SnRef or SNom) (receptor or generator convention). If in generator convention, KACEmulation should be < 0.";

  annotation(preferredView = "text");
end ParamsACEmulation;
