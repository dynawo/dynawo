within Dynawo.Electrical.Machines.SignalN.BaseClasses;

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

partial model BasePVProp "Base dynamic model for a proportional voltage regulation"
  extends BaseClasses.BasePV;

  parameter Types.PerUnit KVoltage "Parameter of the proportional voltage regulation";

  parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power set point in pu (base SnRef) (receptor convention)";

  annotation(preferredView = "text");
end BasePVProp;
