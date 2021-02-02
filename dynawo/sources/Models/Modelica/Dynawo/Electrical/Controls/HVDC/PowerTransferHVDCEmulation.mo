within Dynawo.Electrical.Controls.HVDC;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PowerTransferHVDCEmulation "Power transfer model for HVDC with AC emulation"
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.HVDC;
  extends HVDC.PowerTransferHVDC;

  Connectors.ImPin KACEmulation1 (value(start = KACEmulation10)) "Inverse of the emulated AC reactance for HVDC link 1";
  Connectors.ImPin KACEmulation2 (value(start = KACEmulation20)) "Inverse of the emulated AC reactance for HVDC link 2";

  parameter Types.PerUnit KACEmulation10 "Start value of inverse of the emulated AC reactance for HVDC link 1";
  parameter Types.PerUnit KACEmulation20 "Start value of inverse of the emulated AC reactance for HVDC link 2";

equation

  if running1.value and running2.value then
    KACEmulation1.value = KACEmulation10;
    KACEmulation2.value = KACEmulation20;
  elseif not(running1.value) and running2.value then
    KACEmulation1.value = 0;
    KACEmulation2.value = KACEmulation20 + KACEmulation10;
  elseif running1.value and not(running2.value) then
    KACEmulation1.value = KACEmulation10 + KACEmulation20;
    KACEmulation2.value = 0;
  else
    KACEmulation1.value = 0;
    KACEmulation2.value = 0;
  end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This model adapts the KACEmulation and PRefSetPu of each of the two HVDC links in parallel depending on the running state of each of the links. If one link is disconnected, this allows the other one to compensate for the power loss. </div></body></html>"));
end PowerTransferHVDCEmulation;
