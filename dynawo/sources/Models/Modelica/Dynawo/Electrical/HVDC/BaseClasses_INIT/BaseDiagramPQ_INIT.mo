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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseDiagramPQ_INIT "Base initialization model for PQ diagram"
  extends BaseClasses_INIT.BaseDiagramPQDangling_INIT;

  parameter Types.ReactivePowerPu QInj2Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 2";
  parameter Types.ReactivePowerPu QInj2Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 2";

  annotation(preferredView = "text");
end BaseDiagramPQ_INIT;
