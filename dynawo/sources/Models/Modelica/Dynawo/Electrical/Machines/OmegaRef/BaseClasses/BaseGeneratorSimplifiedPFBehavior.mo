within Dynawo.Electrical.Machines.OmegaRef.BaseClasses;

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

partial model BaseGeneratorSimplifiedPFBehavior "Base model for generator active power / frequency modulation"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends Dynawo.Electrical.Machines.BaseClasses.BaseGeneratorSimplified;

  type PStatus = enumeration(Standard "Active power is modulated by the frequency deviation", LimitPMin "Active power is fixed to its minimum value", LimitPMax "Active power is fixed to its maximum value");

  Dynawo.Connectors.ImPin deltaPmRefPu(value(start = 0)) "Additional active power reference in pu (base PNom)";
  Dynawo.Connectors.ImPin omegaRefPu "Network angular reference frequency in pu (base OmegaNom)";

  parameter Types.ActivePower PMin "Minimum active power in MW";
  parameter Types.ActivePower PMax "Maximum active power in MW";
  parameter Types.ActivePower PNom "Nominal active power in MW";
  parameter Types.PerUnit AlphaPuPNom "Frequency sensitivity in pu (base PNom, OmegaNom)";

  final parameter Types.ActivePowerPu PMinPu = PMin / SystemBase.SnRef "Minimum active power in pu (base SnRef)";
  final parameter Types.ActivePowerPu PMaxPu = PMax / SystemBase.SnRef "Maximum active power in pu (base SnRef)";
  final parameter Types.PerUnit AlphaPu = AlphaPuPNom * PNom / SystemBase.SnRef "Frequency sensitivity in pu (base SnRef, OmegaNom)";

protected
  Types.ActivePowerPu PGenRawPu(start = PGen0Pu) "Active power generation without taking limits into account in pu (base SnRef) (generator convention)";
  PStatus pStatus(start = PStatus.Standard) "Status of the power / frequency regulation function";

equation
  when PGenRawPu >= PMaxPu and pre(pStatus) <> PStatus.LimitPMax then
    pStatus = PStatus.LimitPMax;
    Timeline.logEvent1(TimelineKeys.ActivatePMAX);
  elsewhen PGenRawPu <= PMinPu and pre(pStatus) <> PStatus.LimitPMin then
    pStatus = PStatus.LimitPMin;
    Timeline.logEvent1(TimelineKeys.ActivatePMIN);
  elsewhen PGenRawPu > PMinPu and pre(pStatus) == PStatus.LimitPMin then
    pStatus = PStatus.Standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMIN);
  elsewhen PGenRawPu < PMaxPu and pre(pStatus) == PStatus.LimitPMax then
    pStatus = PStatus.Standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMAX);
  end when;

  if running.value then
    PGenRawPu = PGen0Pu + deltaPmRefPu.value * PNom / SystemBase.SnRef + AlphaPu * (1 - omegaRefPu.value);
    PGenPu = if pStatus == PStatus.LimitPMax then PMaxPu else if pStatus == PStatus.LimitPMin then PMinPu else PGenRawPu;
  else
    PGenRawPu = 0;
    terminal.i.re = 0;
  end if;

  annotation(preferredView = "text");
end BaseGeneratorSimplifiedPFBehavior;
