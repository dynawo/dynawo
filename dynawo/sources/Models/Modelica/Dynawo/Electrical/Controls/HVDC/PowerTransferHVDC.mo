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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PowerTransferHVDC "Power transfer model for HVDC"

  input Types.ActivePowerPu PRefSet1RawPu(start = PRefSet10Pu) "Raw reference active power of HVDC link 1 in pu (base SnRef)";
  input Types.ActivePowerPu PRefSet2RawPu(start = PRefSet20Pu) "Raw reference active power of HVDC link 2 in pu (base SnRef)";
  input Boolean running1(start = true) "Boolean assessing if the HVDC link 1 is running";
  input Boolean running2(start = true) "Boolean assessing if the HVDC link 2 is running";

  output Types.ActivePowerPu PRefSet1Pu(start = PRefSet10Pu) "Reference active power of HVDC link 1 in pu (base SnRef)";
  output Types.ActivePowerPu PRefSet2Pu(start = PRefSet20Pu) "Reference active power of HVDC link 2 in pu (base SnRef)";

  parameter Types.ActivePowerPu PRefSet10Pu "Start value of reference active power in pu (base SnRef) for HVDC link 1";
  parameter Types.ActivePowerPu PRefSet20Pu "Start value of reference active power in pu (base SnRef) for HVDC link 2";

equation
  if running1 and running2 then
    PRefSet1Pu = PRefSet1RawPu;
    PRefSet2Pu = PRefSet2RawPu;
  elseif not(running1) and running2 then
    PRefSet1Pu = 0;
    PRefSet2Pu = PRefSet2RawPu + PRefSet1RawPu;
  elseif running1 and not(running2) then
    PRefSet1Pu = PRefSet1RawPu + PRefSet2RawPu;
    PRefSet2Pu = 0;
  else
    PRefSet1Pu = 0;
    PRefSet2Pu = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This model adapts the PRefSetPu of each of the two HVDC links in parallel depending on the running state of each of the links. If one link is disconnected, this allows the other one to compensate for the power loss. </div></body></html>"));
end PowerTransferHVDC;
