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

partial model BasePVDangling "Base dynamic model for PV control at terminal 1"
  import Modelica;

  parameter Types.PerUnit Lambda1Pu "Parameter Lambda of the voltage regulation law U1RefPu = U1Pu + Lambda1Pu * QInj1Pu, in pu (base UNom, SnRef) at terminal 1";
  parameter Types.ReactivePower Q1Nom "Nominal reactive power in Mvar at terminal 1";

  final parameter Boolean UseLambda1 = not(Lambda1Pu == 0) "If true, the voltage regulation follows the law U1RefPu = U1Pu + Lambda1Pu * QInj1Pu at terminal 1";

  Modelica.Blocks.Interfaces.RealInput U1RefPu(start = U1Ref0Pu) "Voltage regulation set point in pu (base UNom) at terminal 1";

  Modelica.Blocks.Interfaces.RealInput QInj1PuQNom "Reactive power at terminal 1 in pu (base Q1Nom) (generator convention)";

  parameter Types.VoltageModulePu U1Ref0Pu "Start value of the voltage regulation set point in pu (base UNom) at terminal 1";

  annotation(preferredView = "text");
end BasePVDangling;
