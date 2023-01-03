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

  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power in pu (base SnRef)";
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power in pu (base SnRef)";
  parameter Real QPercent "Percentage of the coordinated reactive control that comes from this machine";

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  input Types.PerUnit NQ "Signal to change the reactive power generation of the generator depending on the centralized distant voltage regulation (generator convention)";

  Boolean limUQUp(start = limUQUp0) "Whether the maximum reactive power limits are reached or not (from generator voltage regulator)";
  Boolean limUQDown(start = limUQDown0) "Whether the minimum reactive power limits are reached or not (from generator voltage regulator)";

  parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power set point in pu (base SnRef) (receptor convention)";
  parameter Boolean limUQUp0 "Whether the maximum reactive power limits are reached or not (from generator voltage regulator), start value";
  parameter Boolean limUQDown0 "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";
  parameter QStatus qStatus0 "Start voltage regulation status: standard, absorptionMax or generationMax";

protected
  Types.ReactivePowerPu QGenRawPu(start = QGen0Pu) "Reactive power generation without taking limits into account in pu (base SnRef) (generator convention)";
  QStatus qStatus(start = qStatus0) "Voltage regulation status: standard, absorptionMax or generationMax";

equation
  QGenRawPu = - QRef0Pu + QPercent * NQ;

  when QGenRawPu <= QMinPu then
    qStatus = QStatus.AbsorptionMax;
    limUQUp = false;
    limUQDown = true;
  elsewhen QGenRawPu >= QMaxPu then
    qStatus = QStatus.GenerationMax;
    limUQUp = true;
    limUQDown = false;
  elsewhen QGenRawPu > QMinPu and QGenRawPu < QMaxPu then
    qStatus = QStatus.Standard;
    limUQUp = false;
    limUQDown = false;
  end when;

  if running.value then
    if qStatus == QStatus.GenerationMax then
      QGenPu = QMaxPu;
    elseif qStatus == QStatus.AbsorptionMax then
      QGenPu = QMinPu;
    else
      QGenPu = QGenRawPu;
    end if;
  else
    terminal.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This PQ generator adapts it Q to regulate the voltage of a distant bus along with other generators depending on a participation factor QPercent. To do so, it receives a set point NQ to adapt its Q. This NQ is common to all the generators participating in this regulation.</div></body></html>"));
end GeneratorPQProp;
