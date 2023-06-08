within Dynawo.Electrical.HVDC.BaseClasses;

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

partial model BasePQPropDangling "Base dynamic model for proportional reactive power control at terminal 1"

  parameter Real QPercent1 "Percentage of the coordinated reactive control that comes from converter 1";

  input Types.PerUnit NQ1 "Signal to change the reactive power of converter 1 depending on the centralized voltage regulation (generator convention)";

  Types.ReactivePowerPu QInj1RawModeUPu "Reactive power generation of converter 1 without taking limits into account in pu and for mode U activated (base SnRef) (generator convention)";
  Types.ReactivePowerPu QInj1RawPu "Reactive power generation of converter 1 without taking limits into account in pu (base SnRef) (generator convention)";

  annotation(preferredView = "text");
end BasePQPropDangling;
