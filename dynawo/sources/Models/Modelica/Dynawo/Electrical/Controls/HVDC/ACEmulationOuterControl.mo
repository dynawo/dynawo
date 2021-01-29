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

model ACEmulationOuterControl "AC Emulation outer control for HVDC"

  Connectors.ImPin PRefSet1RawPu (value(start = PRefSet10Pu)) "Raw reference active power of HVDC link 1 in p.u (base SnRef)";
  Connectors.ImPin PRefSet2RawPu (value(start = PRefSet20Pu)) "Raw reference active power of HVDC link 2 in p.u (base SnRef)";

  Connectors.ImPin KACEmulation1Raw (value(start = KACEmulation10)) "Raw inverse of the emulated AC reactance for HVDC link 1";
  Connectors.ImPin KACEmulation2Raw (value(start = KACEmulation20)) "Raw inverse of the emulated AC reactance for HVDC link 2";

  Connectors.BPin running1 (value(start = true)) "Boolean assessing if the HVDC link 1 is running";
  Connectors.BPin running2 (value(start = true)) "Boolean assessing if the HVDC link 2 is running";

  parameter Types.PerUnit KACEmulation10 "Start value of inverse of the emulated AC reactance for HVDC link 1";
  parameter Types.PerUnit KACEmulation20 "Start value of inverse of the emulated AC reactance for HVDC link 2";
  parameter Types.ActivePowerPu PRefSet10Pu "Start value of reference active power in p.u (base SnRef) for HVDC link 1";
  parameter Types.ActivePowerPu PRefSet20Pu "Start value of reference active power in p.u (base SnRef) for HVDC link 2";

  output Types.ActivePowerPu PRefSet1Pu (start = PRefSet10Pu) "Reference active power of HVDC link 1 in p.u (base SnRef)";
  output Types.ActivePowerPu PRefSet2Pu (start = PRefSet20Pu) "Reference active power of HVDC link 2 in p.u (base SnRef)";

  output Types.PerUnit KACEmulation1 (start = KACEmulation10) "Inverse of the emulated AC reactance for HVDC link 1";
  output Types.PerUnit KACEmulation2 (start = KACEmulation20) "Inverse of the emulated AC reactance for HVDC link 2";

equation

  if running1.value and running2.value then
    KACEmulation1 = KACEmulation1Raw.value;
    KACEmulation2 = KACEmulation2Raw.value;
    PRefSet1Pu = PRefSet1RawPu.value;
    PRefSet2Pu = PRefSet2RawPu.value;
  elseif not(running1.value) and running2.value then
    KACEmulation1 = 0;
    KACEmulation2 = KACEmulation2Raw.value + KACEmulation1Raw.value;
    PRefSet1Pu = 0;
    PRefSet2Pu = PRefSet2RawPu.value + PRefSet1RawPu.value;
  elseif running1.value and not(running2.value) then
    KACEmulation1 = KACEmulation1Raw.value + KACEmulation2Raw.value;
    KACEmulation2 = 0;
    PRefSet1Pu = PRefSet1RawPu.value + PRefSet2RawPu.value;
    PRefSet2Pu = 0;
  else
    KACEmulation1 = 0;
    KACEmulation2 = 0;
    PRefSet1Pu = 0;
    PRefSet2Pu = 0;
  end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This control adapts the KACEmulation and PRefSetPu of each of the two HVDC links in parallel depending on the running state of each of the links. If one link is disconnected, this allows the other one to compensate for the power loss. </div></body></html>"));
end ACEmulationOuterControl;
