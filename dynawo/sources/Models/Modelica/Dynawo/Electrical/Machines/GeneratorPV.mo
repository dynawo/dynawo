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

    type QStatus = enumeration (standard "Reactive power is fixed to its initial value",
                                absorptionMax "Reactive power is fixed to its absorption limit",
                                generationMax "Reactive power is fixed to its generation limit");

    Connectors.ZPin URefPu (value = URef0Pu) "Voltage regulation set point in p.u (base UNom)";

    parameter Types.AC.ReactivePower QMinPu  "Minimum reactive power in p.u (base SnRef)";
    parameter Types.AC.ReactivePower QMaxPu  "Maximum reactive power in p.u (base SnRef)";
    parameter SIunits.PerUnit LambdaPu "Reactive power sensitivity of the voltage regulation in p.u (base UNom, SnRef)";

  protected

    parameter Types.AC.VoltageModule URef0Pu "Initial voltage regulation set point";

    Types.AC.ReactivePower QGenRefPu (start = QGen0Pu) "Reactive power set point in p.u (base SnRef)";

    QStatus qStatus (start = QStatus.standard) "Voltage regulation status: standard, absorptionMax or generationMax";

equation

  URefPu.value = UPu + LambdaPu * QGenRefPu;

  when QGenRefPu >= QMaxPu and pre(qStatus) <> QStatus.absorptionMax then
    qStatus = QStatus.absorptionMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPVMaxQ);
  elsewhen QGenRefPu <= QMinPu and pre(qStatus) <> QStatus.generationMax then
    qStatus = QStatus.generationMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPVMinQ);
  elsewhen (QGenRefPu < QMaxPu and pre(qStatus) == QStatus.absorptionMax) or (QGenRefPu > QMinPu and pre(qStatus) == QStatus.generationMax) then
    qStatus = QStatus.standard;
    Timeline.logEvent1(TimelineKeys.GeneratorPVBackRegulation);
  end when;

  if running.value then
    QGenPu = if pre(qStatus) == QStatus.absorptionMax then QMaxPu else if pre(qStatus) == QStatus.generationMax then QMinPu else QGenRefPu;
  else
    QGenPu = 0;
  end if;

end GeneratorPV;
