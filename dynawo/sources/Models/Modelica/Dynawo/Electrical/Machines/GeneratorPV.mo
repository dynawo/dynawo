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
  extends AdditionalIcons.Machine;

    type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                                AbsorptionMax "Reactive power is fixed to its absorption limit",
                                GenerationMax "Reactive power is fixed to its generation limit");

    Connectors.ZPin URefPu (value = URef0Pu) "Voltage regulation set point in p.u (base UNom)";

    parameter Types.ReactivePower QMin "Minimum reactive power in Mvar";
    parameter Types.ReactivePower QMax "Maximum reactive power in Mvar";
    parameter Types.ApparentPowerModule SNom "Apparent nominal power in MVA";
    parameter Types.PerUnit LambdaPuSNom "Reactive power sensitivity of the voltage regulation in p.u (base UNom, SNom)";

  protected

    final parameter Types.ReactivePowerPu QMinPu = QMin / SystemBase.SnRef "Minimum reactive power in p.u. (base SnRef)";
    final parameter Types.ReactivePowerPu QMaxPu = QMax / SystemBase.SnRef "Maximum reactive power in p.u. (base SnRef)";
    final parameter Types.PerUnit LambdaPu = LambdaPuSNom * SNom / SystemBase.SnRef "Reactive power sensitivity of the voltage regulation in p.u. (base UNom, SnRef)";
    final parameter Types.Time T = 1 "Time constant used to filter the reactive power reference";

    parameter Types.VoltageModulePu URef0Pu "Initial voltage regulation set point";

    Types.ReactivePowerPu QGenRefPu (start = QGen0Pu) "Reactive power set point in p.u (base SnRef)";

    QStatus qStatus (start = QStatus.Standard) "Voltage regulation status: standard, absorptionMax or generationMax";

equation

  URefPu.value = UPu + LambdaPu * (QGenRefPu + T * der(QGenRefPu));

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

annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The active power output is modulated according to frequency (in order to model frequency containment reserves).<div>The reactive power output is modulated in order to keep U + lambda * Q as close as possible to the target value. When a reactive power limit is reached, the generator produces a constant reactive power equal to the limit reached.</div></body></html>"));
end GeneratorPV;
