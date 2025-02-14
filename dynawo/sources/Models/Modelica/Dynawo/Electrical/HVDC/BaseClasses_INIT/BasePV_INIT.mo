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

partial model BasePV_INIT "Base initialization model for PV HVDC"

  parameter Types.ActivePowerPu P1RefSetPu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePower Q1Nom "Nominal reactive power in Mvar at terminal 1";

  parameter Types.VoltageModulePu U1Ref0Pu "Start value of the voltage regulation set point in pu (base UNom) at terminal 1";

  Types.ReactivePowerPuConnector QInj10PuQNom "Reactive power at terminal 1 in pu (base Q1Nom) (generator convention)";
  Types.VoltageModulePuConnector U1Ref0PuVar "Start value of the voltage regulation set point in pu (base UNom) at terminal 1";

equation
  U1Ref0PuVar = U1Ref0Pu;

  annotation(preferredView = "text");
end BasePV_INIT;
