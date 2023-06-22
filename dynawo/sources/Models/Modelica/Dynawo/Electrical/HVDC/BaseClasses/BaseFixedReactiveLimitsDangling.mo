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

partial model BaseFixedReactiveLimitsDangling "Base dynamic model for fixed reactive limits at terminal 1"

  parameter Types.ReactivePower Q1Max "Maximum reactive power in Mvar at terminal 1 (generator convention)";
  parameter Types.ReactivePower Q1Min "Minimum reactive power in Mvar at terminal 1 (generator convention)";

  final parameter Types.ReactivePowerPu Q1MaxPu = Q1Max / SystemBase.SnRef "Maximum reactive power in pu (base SnRef) at terminal 1 (generator convention)";
  final parameter Types.ReactivePowerPu Q1MinPu = Q1Min / SystemBase.SnRef "Minimum reactive power in pu (base SnRef) at terminal 1 (generator convention)";

  annotation(preferredView = "text");
end BaseFixedReactiveLimitsDangling;
