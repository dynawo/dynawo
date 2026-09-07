within Dynawo.Electrical.HVDC.BaseClasses_INIT;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseDiagramPQDangling_INIT "Base initialization model for PQ diagram at terminal 1"

  parameter Types.ReactivePowerPu QInj1Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 1";
  parameter Types.ReactivePowerPu QInj1Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 1";

  annotation(preferredView = "text");
end BaseDiagramPQDangling_INIT;
