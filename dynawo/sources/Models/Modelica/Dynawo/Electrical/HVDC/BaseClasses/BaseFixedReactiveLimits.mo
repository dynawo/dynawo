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

partial model BaseFixedReactiveLimits "Base dynamic model for fixed reactive limits"
  extends BaseClasses.BaseFixedReactiveLimitsDangling;

  parameter Types.ReactivePower Q2Max "Maximum reactive power in Mvar at terminal 2 (generator convention)";
  parameter Types.ReactivePower Q2Min "Minimum reactive power in Mvar at terminal 2 (generator convention)";

  final parameter Types.ReactivePowerPu Q2MaxPu = Q2Max / SystemBase.SnRef "Maximum reactive power in pu (base SnRef) at terminal 2 (generator convention)";
  final parameter Types.ReactivePowerPu Q2MinPu = Q2Min / SystemBase.SnRef "Minimum reactive power in pu (base SnRef) at terminal 2 (generator convention)";

  annotation(preferredView = "text");
end BaseFixedReactiveLimits;
