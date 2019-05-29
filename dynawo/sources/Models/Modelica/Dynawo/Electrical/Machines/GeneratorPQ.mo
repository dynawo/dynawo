within Dynawo.Electrical.Machines;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GeneratorPQ "Generator with power / frequency modulation and fixed reactive power under normal voltages"
  /*
  The P output is modulated according to frequency (in order to model frequency containment reserves)
  The Q output is only modulated when large voltage variations occur
  */

  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseClasses.BaseGeneratorSimplified;
  extends BaseClasses.BaseGeneratorSimplifiedPFBehavior;

  public

    type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                                AbsorptionMax "Reactive power is fixed to its absorption limit",
                                GenerationMax "Reactive power is fixed to its generation limit");

    parameter Types.VoltageModulePu UMinPu "Minimum voltage in p.u (base UNom)";
    parameter Types.VoltageModulePu UMaxPu "Maximum voltage in p.u (base UNom)";
    parameter Types.ReactivePowerPu QMinPu  "Minimum reactive power in p.u (base SnRef)";
    parameter Types.ReactivePowerPu QMaxPu  "Maximum reactive power in p.u (base SnRef)";

  protected

    constant Types.VoltageModulePu UDeadBand = 1e-4 "Voltage dead-band";

    QStatus qStatus (start = QStatus.Standard) "Reactive power status: standard, absorptionMax or generationMax";

equation

  when UPu >= UMaxPu + UDeadBand and pre(qStatus) <> QStatus.AbsorptionMax then
    qStatus = QStatus.AbsorptionMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPQMaxV);
  elsewhen UPu <= UMinPu - UDeadBand and pre(qStatus) <> QStatus.GenerationMax then
    qStatus = QStatus.GenerationMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPQMinV);
  elsewhen (UPu < UMaxPu - UDeadBand and pre(qStatus) == QStatus.AbsorptionMax) or (UPu > UMinPu + UDeadBand and pre(qStatus) == QStatus.GenerationMax) then
    qStatus = QStatus.Standard;
    Timeline.logEvent1(TimelineKeys.GeneratorPQBackRegulation);
  end when;

  if running.value then
    QGenPu = if pre(qStatus) == QStatus.AbsorptionMax then QMaxPu else if pre(qStatus) == QStatus.GenerationMax then QMinPu else QGen0Pu;
  else
    QGenPu = 0;
  end if;

end GeneratorPQ;
