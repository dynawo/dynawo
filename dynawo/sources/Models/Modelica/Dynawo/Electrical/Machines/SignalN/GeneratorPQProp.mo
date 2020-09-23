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

 import Dynawo.Electrical.Machines;
 import Dynawo.AdditionalIcons;
 import Dynawo.Connectors;

  extends Machines.BaseClasses.BaseGeneratorSimplified;
  extends AdditionalIcons.Machine;

  public

    parameter Types.ActivePowerPu PMinPu "Minimum active power in p.u (base SnRef)";
    parameter Types.ActivePowerPu PMaxPu "Maximum active power in p.u (base SnRef)";
    parameter Types.ReactivePowerPu QMinPu  "Minimum reactive power in p.u (base SnRef)";
    parameter Types.ReactivePowerPu QMaxPu  "Maximum reactive power in p.u (base SnRef)";
    parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
    parameter Types.ActivePower PNom "Nominal power in MW";
    parameter Real QPercent "Percentage of the coordinated reactive control that comes from this machine";
    final parameter Real Alpha = PNom * KGover "Participation of the considered generator in the frequency regulation";

    Connectors.ImPin N "Signal to change the active power reference setpoint of all the generators in the system in p.u (base SnRef)";
    Connectors.ImPin NQ "Signal to change the reactive power generation of the group depending on the centralized distant voltage regulation";
    Connectors.ZPin alpha "Participation of the considered generator in the frequency regulation. It is equal to Alpha if the generator is not blocked, 0 otherwise.";
    Connectors.ZPin alphaSum "Sum of all the participations of all generators in the frequency regulation";

  protected

    Types.ActivePowerPu PGenRawPu (start = PGen0Pu) "Active power generation without taking limits into account in p.u (base SnRef) (generator convention)";
    Types.ReactivePowerPu QGenRawPu (start = QGen0Pu) "Reactive power generation without taking limits into account in p.u (base SnRef) (generator convention)";

  equation

    if running.value then
      PGenRawPu = PGen0Pu + (Alpha / alphaSum.value) * N.value;
      PGenPu = if PGenRawPu >= PMaxPu then PMaxPu elseif PGenRawPu <= PMinPu then PMinPu else PGenRawPu;
      alpha.value = if (N.value > 0 and PGenRawPu >= PMaxPu) then 0 else if (N.value < 0 and PGenRawPu <= PMinPu) then 0 else Alpha;
      QGenRawPu = QGen0Pu + QPercent * NQ.value;
      QGenPu = if QGenRawPu >= QMaxPu then QMaxPu elseif QGenRawPu <= QMinPu then QMinPu else QGenRawPu;
    else
      PGenRawPu = 0;
      PGenPu = 0;
      alpha.value = 0;
      QGenRawPu = 0;
      QGenPu = 0;
    end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This PQ generator adapts it Q to regulate the voltage of a distant bus along with other generators depending on a participation factor QPercent. To do so, it receives a set point NQ to adapt its Q. This NQ is common to all the generators participating in this regulation.</div></body></html>"));
end GeneratorPQProp;
