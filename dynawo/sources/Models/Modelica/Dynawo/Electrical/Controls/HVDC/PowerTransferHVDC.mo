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

model PowerTransferHVDC "Power transfer model for HVDC"
  import Dynawo.Types;
  import Dynawo.Connectors;

  Connectors.ImPin PRefSet1RawPu (value(start = PRefSet10Pu)) "Raw reference active power of HVDC link 1 in pu (base SnRef)";
  Connectors.ImPin PRefSet2RawPu (value(start = PRefSet20Pu)) "Raw reference active power of HVDC link 2 in pu (base SnRef)";
  Connectors.BPin running1 (value(start = true)) "Boolean assessing if the HVDC link 1 is running";
  Connectors.BPin running2 (value(start = true)) "Boolean assessing if the HVDC link 2 is running";

  Connectors.ImPin PRefSet1Pu (value(start = PRefSet10Pu)) "Reference active power of HVDC link 1 in pu (base SnRef)";
  Connectors.ImPin PRefSet2Pu (value(start = PRefSet20Pu)) "Reference active power of HVDC link 2 in pu (base SnRef)";

  parameter Types.ActivePowerPu PRefSet10Pu "Start value of reference active power in pu (base SnRef) for HVDC link 1";
  parameter Types.ActivePowerPu PRefSet20Pu "Start value of reference active power in pu (base SnRef) for HVDC link 2";

equation

  if running1.value and running2.value then
    PRefSet1Pu.value = PRefSet1RawPu.value;
    PRefSet2Pu.value = PRefSet2RawPu.value;
  elseif not(running1.value) and running2.value then
    PRefSet1Pu.value = 0;
    PRefSet2Pu.value = PRefSet2RawPu.value + PRefSet1RawPu.value;
  elseif running1.value and not(running2.value) then
    PRefSet1Pu.value = PRefSet1RawPu.value + PRefSet2RawPu.value;
    PRefSet2Pu.value = 0;
  else
    PRefSet1Pu.value = 0;
    PRefSet2Pu.value = 0;
  end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This model adapts the PRefSetPu of each of the two HVDC links in parallel depending on the running state of each of the links. If one link is disconnected, this allows the other one to compensate for the power loss. </div></body></html>"));
end PowerTransferHVDC;
