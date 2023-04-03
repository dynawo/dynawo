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

model GeneratorPVRemoteDiagramPQ "Model for generator PV with a PQ diagram, based on SignalN for the frequency handling and a remote voltage regulation"
  import Modelica;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseClasses.BaseGeneratorSignalN;
  extends AdditionalIcons.Machine;

  parameter String QMinTableName "Name of the table in the text file to get QMinPu from PGenPu";
  parameter String QMaxTableName "Name of the table in the text file to get QMaxPu from PGenPu";
  parameter String QMinTableFile "Text file that contains the table to get QMinPu from PGenPu";
  parameter String QMaxTableFile "Text file that contains the table to get QMaxPu from PGenPu";

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  input Types.VoltageModule URegulated(start = URegulated0) "Regulated voltage in kV";
  input Types.VoltageModule URef(start = URef0) "Voltage regulation set point in kV";

  Modelica.Blocks.Tables.CombiTable1D tableQMin(tableOnFile = true, tableName = QMinTableName, fileName = QMinTableFile) "Table to get QMinPu from PGenPu";
  Modelica.Blocks.Tables.CombiTable1D tableQMax(tableOnFile = true, tableName = QMaxTableName, fileName = QMaxTableFile) "Table to get QMaxPu from PGenPu";
  Types.ReactivePowerPu QMinPu(start = QMin0Pu) "Minimum reactive power in pu (base SnRef)";
  Types.ReactivePowerPu QMaxPu(start = QMax0Pu) "Maximum reactive power in pu (base SnRef)";

  parameter Types.ReactivePowerPu QMin0Pu "Start value of the minimum reactive power in pu (base SnRef)";
  parameter Types.ReactivePowerPu QMax0Pu "Start value of the maximum reactive power in pu (base SnRef)";
  parameter Types.VoltageModule URef0 "Start value of the voltage regulation set point in kV";
  parameter Types.VoltageModulePu URegulated0 "Start value of the voltage regulated in pu (base UNom)";
  parameter QStatus qStatus0 "Start voltage regulation status: standard, absorptionMax or generationMax";

protected
  QStatus qStatus(start = qStatus0) "Voltage regulation status: standard, absorptionMax or generationMax";

equation
  PGenPu = tableQMin.u[1];
  QMinPu = tableQMin.y[1];
  PGenPu = tableQMax.u[1];
  QMaxPu = tableQMax.y[1];

  when QGenPu <= QMinPu and URegulated >= URef then
    qStatus = QStatus.AbsorptionMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPVMinQ);
  elsewhen QGenPu >= QMaxPu and URegulated <= URef then
    qStatus = QStatus.GenerationMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPVMaxQ);
  elsewhen (QGenPu > QMinPu or URegulated < URef) and (QGenPu < QMaxPu or URegulated > URef) then
    qStatus = QStatus.Standard;
    Timeline.logEvent1(TimelineKeys.GeneratorPVBackRegulation);
  end when;

  if running.value then
    if qStatus == QStatus.GenerationMax then
      QGenPu = QMaxPu;
    elseif qStatus == QStatus.AbsorptionMax then
      QGenPu = QMinPu;
    else
      URegulated = URef;
    end if;
  else
    terminal.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This generator regulates the voltage URegulatedPu unless its reactive power generation hits its limits QMinPu or QMaxPu (in this case, the generator provides QMinPu or QMaxPu and the voltage is no longer regulated). The reactive power limitations follow a PQ diagram. </div></body></html>"));
end GeneratorPVRemoteDiagramPQ;
