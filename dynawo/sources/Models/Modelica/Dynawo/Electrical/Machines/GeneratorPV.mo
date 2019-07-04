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

model GeneratorPV "Generator with power / frequency modulation and voltage / reactive regulation"
  /*
  The P output is modulated according to frequency (in order to model frequency containment reserves)
  The Q output is modulated in order to keep U + lambda * Q as close as possible to the target value
  When a reactive power limit is reached, the PV generator acts as a PQ generator
  */

  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseClasses.BaseGeneratorSimplified;
  extends BaseClasses.BaseGeneratorSimplifiedPFBehavior;

  public

    type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                                AbsorptionMax "Reactive power is fixed to its absorption limit",
                                GenerationMax "Reactive power is fixed to its generation limit");

    Connectors.ZPin URefPu (value = URef0Pu) "Voltage regulation set point in p.u (base UNom)";

    parameter Types.ReactivePowerPu QMinPu  "Minimum reactive power in p.u (base SnRef)";
    parameter Types.ReactivePowerPu QMaxPu  "Maximum reactive power in p.u (base SnRef)";
    parameter Types.PerUnit LambdaPu "Reactive power sensitivity of the voltage regulation in p.u (base UNom, SnRef)";

  protected

    parameter Types.VoltageModulePu URef0Pu "Initial voltage regulation set point";

    Types.ReactivePowerPu QGenRefPu (start = QGen0Pu) "Reactive power set point in p.u (base SnRef)";

    QStatus qStatus (start = QStatus.Standard) "Voltage regulation status: standard, absorptionMax or generationMax";

equation

  URefPu.value = UPu + LambdaPu * QGenRefPu;

  when QGenRefPu >= QMaxPu and pre(qStatus) <> QStatus.AbsorptionMax then
    qStatus = QStatus.AbsorptionMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPVMaxQ);
  elsewhen QGenRefPu <= QMinPu and pre(qStatus) <> QStatus.GenerationMax then
    qStatus = QStatus.GenerationMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPVMinQ);
  elsewhen (QGenRefPu < QMaxPu and pre(qStatus) == QStatus.AbsorptionMax) or (QGenRefPu > QMinPu and pre(qStatus) == QStatus.GenerationMax) then
    qStatus = QStatus.Standard;
    Timeline.logEvent1(TimelineKeys.GeneratorPVBackRegulation);
  end when;

  if running.value then
    QGenPu = if qStatus == QStatus.AbsorptionMax then QMaxPu else if qStatus == QStatus.GenerationMax then QMinPu else QGenRefPu;
  else
    QGenPu = 0;
  end if;

end GeneratorPV;
