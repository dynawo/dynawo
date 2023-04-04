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
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GeneratorPVProp "Model for generator PV based on SignalN for the frequency handling and with a proportional voltage regulation"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseClasses.BaseGeneratorSignalN;
  extends AdditionalIcons.Machine;

  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power in pu (base SnRef)";
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power in pu (base SnRef)";
  parameter Types.PerUnit KVoltage "Parameter of the proportional voltage regulation";

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  input Types.VoltageModulePu URefPu(start = URef0Pu) "Voltage regulation set point in pu (base UNom)";

  parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point in pu (base UNom)";
  parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power set point in pu (base SnRef) (receptor convention)";
  parameter QStatus qStatus0 "Start voltage regulation status: standard, absorptionMax or generationMax";

protected
  QStatus qStatus(start = qStatus0) "Voltage regulation status: standard, absorptionMax or generationMax";

equation
  when qStatus == QStatus.AbsorptionMax and pre(qStatus) <> QStatus.AbsorptionMax then
    Timeline.logEvent1(TimelineKeys.GeneratorPVMinQ);
  elsewhen qStatus == QStatus.GenerationMax and pre(qStatus) <> QStatus.GenerationMax then
    Timeline.logEvent1(TimelineKeys.GeneratorPVMaxQ);
  elsewhen qStatus == QStatus.Standard and pre(qStatus) <> QStatus.Standard then
    Timeline.logEvent1(TimelineKeys.GeneratorPVBackRegulation);
  end when;

  when QGenPu <= QMinPu and UPu >= URefPu then
    qStatus = QStatus.AbsorptionMax;
  elsewhen QGenPu >= QMaxPu and UPu <= URefPu then
    qStatus = QStatus.GenerationMax;
  elsewhen (QGenPu > QMinPu or UPu < URefPu) and (QGenPu < QMaxPu or UPu > URefPu) then
    qStatus = QStatus.Standard;
  end when;

  if running.value then
    if qStatus == QStatus.GenerationMax then
      QGenPu = QMaxPu;
    elseif qStatus == QStatus.AbsorptionMax then
      QGenPu = QMinPu;
    else
      QGenPu = - QRef0Pu + KVoltage * (URefPu - UPu);
    end if;
  else
    terminal.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This generator regulates the voltage UPu with a proportional regulation unless its reactive power generation hits its limits QMinPu or QMaxPu (in this case, the generator provides QMinPu or QMaxPu and the voltage is no longer regulated).</div></body></html>"));
end GeneratorPVProp;
