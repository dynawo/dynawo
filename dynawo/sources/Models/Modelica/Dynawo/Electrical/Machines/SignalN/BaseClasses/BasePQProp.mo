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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BasePQProp "Base dynamic model for a proportional reactive power regulation"
  parameter Real QPercent "Percentage of the coordinated reactive control that comes from this machine";

  input Types.PerUnit NQ "Signal to change the reactive power generation of the generator depending on the centralized distant voltage regulation (generator convention)";

  parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power set point in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QDeadBandPu(min = 0) "Reactive power deadband around the target in pu (base SnRef)";

protected
  Types.ReactivePowerPu QGenRawPu "Reactive power generation without taking limits into account in pu (base SnRef) (generator convention)";

equation
  QGenRawPu = - QRef0Pu + abs(QPercent) * NQ;

  annotation(preferredView = "text");
end BasePQProp;
