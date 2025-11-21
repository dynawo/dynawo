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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BasePV "Base dynamic model for PV control"
  extends BaseClasses.BasePVDangling;

  parameter Types.PerUnit Lambda2Pu "Parameter Lambda of the voltage regulation law U2RefPu = U2Pu + Lambda2Pu * QInj2Pu, in pu (base UNom, SnRef) at terminal 2";
  parameter Types.ReactivePower Q2Nom "Nominal reactive power in Mvar at terminal 2";

  final parameter Boolean UseLambda2 = not(Lambda2Pu == 0) "If true, the voltage regulation follows the law U2RefPu = U2Pu + Lambda2Pu * QInj2Pu at terminal 2";

  input Types.VoltageModulePu U2RefPu(start = U2Ref0Pu) "Voltage regulation set point in pu (base UNom) at terminal 2";

  Types.ReactivePowerPu QInj2PuQNom "Reactive power at terminal 2 in pu (base Q2Nom) (generator convention)";

  parameter Types.VoltageModulePu U2Ref0Pu "Start value of the voltage regulation set point in pu (base UNom) at terminal 2";

  annotation(preferredView = "text");
end BasePV;
