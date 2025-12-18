within Dynawo.Electrical.Machines.OmegaRef;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

model GeneratorPTanPhi "Generator PV when linked to reactive power control loop"
  extends Dynawo.AdditionalIcons.Machine;
  extends Dynawo.Electrical.Machines.BaseClasses.BaseGeneratorSimplified;

  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  type QStatus = enumeration(Standard "Reactive power is fixed to its initial value",
                             AbsorptionMax "Reactive power is fixed to its absorption limit",
                             GenerationMax "Reactive power is
                             fixed to its generation limit");
  type PStatus = enumeration(Standard "Active power is modulated by the frequency deviation", LimitPMin "Active power is fixed to its minimum value", LimitPMax "Active power is fixed to its maximum value");

  parameter Types.PerUnit AlphaPuPNom "Frequency sensitivity in pu (base PNom, OmegaNom)";
  parameter Types.ActivePower PMax "Maximum active power in MW";
  parameter Types.ActivePower PMin "Minimum active power in MW";
  parameter Types.ActivePower PNom "Nominal active power in MW";
  parameter Types.ReactivePower QMax "Maximum reactive power in Mvar";
  parameter Types.ReactivePower QMin "Minimum reactive power in Mvar";
  parameter Real TanPhiRef = if PGen0Pu <> 0 then QGen0Pu / PGen0Pu else 0 "Start value of tan(Phi) regulation set point at terminal";
  parameter Types.ApparentPowerModule SNom "Apparent nominal power in MVA";

  Modelica.Blocks.Interfaces.RealInput PVariation(start = 0) "Percentage variation of active power reference in pu (base PNom)";
  Modelica.Blocks.Interfaces.RealInput deltaPRefPu(start = 0) "Additional active power reference in pu (base PNom)";
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Network angular reference frequency in pu (base OmegaNom)";

  final parameter Types.ReactivePowerPu QMaxPu = QMax / SystemBase.SnRef "Maximum reactive power in pu (base SnRef)";
  final parameter Types.ReactivePowerPu QMinPu = QMin / SystemBase.SnRef "Minimum reactive power in pu (base SnRef)";
  final parameter Types.ActivePowerPu PMinPu = PMin / SystemBase.SnRef "Minimum active power in pu (base SnRef)";
  final parameter Types.ActivePowerPu PMaxPu = PMax / SystemBase.SnRef "Maximum active power in pu (base SnRef)";
  final parameter Types.PerUnit AlphaPu = AlphaPuPNom * PNom / SystemBase.SnRef "Frequency sensitivity in pu (base SnRef, OmegaNom)";

protected
  Types.ActivePowerPu PGenRawPu(start = PGen0Pu) "Active power generation without taking limits into account in pu (base SnRef) (generator convention)";
  PStatus pStatus(start = PStatus.Standard) "Status of the power / frequency regulation function";
  Types.ReactivePowerPu QGenRawPu(start = QGen0Pu) "Raw reactive power at terminal in pu (base SnRef) (generator convention)";
  QStatus qStatus(start = QStatus.Standard) "Voltage regulation status: standard, absorptionMax or generationMax";

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

  when QGenRawPu >= QMaxPu and pre(qStatus) <> QStatus.AbsorptionMax then
    qStatus = QStatus.AbsorptionMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPTanPhiMaxQ);
  elsewhen QGenRawPu <= QMinPu and pre(qStatus) <> QStatus.GenerationMax then
    qStatus = QStatus.GenerationMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPTanPhiMinQ);
  elsewhen (QGenRawPu < QMaxPu and pre(qStatus) == QStatus.AbsorptionMax) or (QGenRawPu > QMinPu and pre(qStatus) == QStatus.GenerationMax) then
    qStatus = QStatus.Standard;
    Timeline.logEvent1(TimelineKeys.GeneratorPTanPhiBackRegulation);
  end when;

  if running.value then
    PGenRawPu = PGen0Pu * (1 + PVariation) + deltaPRefPu * PNom / SystemBase.SnRef + AlphaPu * (1 - omegaRefPu);
    PGenPu = if pStatus == PStatus.LimitPMax then PMaxPu else if pStatus == PStatus.LimitPMin then PMinPu else PGenRawPu;
    QGenRawPu = TanPhiRef * PGenPu;
    QGenPu = if qStatus == QStatus.AbsorptionMax then QMaxPu else if qStatus == QStatus.GenerationMax then QMinPu else QGenRawPu;
  else
    PGenRawPu = 0;
    QGenRawPu = 0;
    terminal.i.re = 0;
    terminal.i.im = 0;
  end if;

  annotation(
    preferredView = "text");
end GeneratorPTanPhi;
