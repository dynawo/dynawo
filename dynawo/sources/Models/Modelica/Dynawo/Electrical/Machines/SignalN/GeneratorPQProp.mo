within Dynawo.Electrical.Machines.SignalN;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GeneratorPQProp "Model for generator PQ based on SignalN for the frequency handling and with a proportional reactive power regulation"

  extends BaseClasses.BaseGeneratorSignalN;
  extends AdditionalIcons.Machine;

public
  parameter Types.VoltageModulePu QRef0Pu "Start value of the reactive power set point in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QMinPu  "Minimum reactive power in p.u (base SnRef)";
  parameter Types.ReactivePowerPu QMaxPu  "Maximum reactive power in p.u (base SnRef)";
  parameter Real QPercent "Percentage of the coordinated reactive control that comes from this machine";

  Connectors.ImPin NQ "Signal to change the reactive power generation of the group depending on the centralized distant voltage regulation";

protected
  Types.ReactivePowerPu QGenRawPu (start = QGen0Pu) "Reactive power generation without taking limits into account in p.u (base SnRef) (generator convention)";

equation

  QGenRawPu = - QRef0Pu + QPercent * NQ.value;

if running.value then
  QGenPu = if QGenRawPu >= QMaxPu then QMaxPu elseif QGenRawPu <= QMinPu then QMinPu else QGenRawPu;
else
  QGenPu = 0;
end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This PQ generator adapts it Q to regulate the voltage of a distant bus along with other generators depending on a participation factor QPercent. To do so, it receives a set point NQ to adapt its Q. This NQ is common to all the generators participating in this regulation.</div></body></html>"));
end GeneratorPQProp;
