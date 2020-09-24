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

model GeneratorPVDiagramPQ "Model for generator PV based on SignalN for the frequency handling with an N points PQ diagram."

  import Modelica;
  extends BaseClasses.BaseGeneratorSignalN;
  extends AdditionalIcons.Machine;

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  parameter Types.ReactivePowerPu QMin0Pu "Start value of the minimum reactive power in p.u (base SnRef)";
  parameter Types.ReactivePowerPu QMax0Pu "Start value of the maximum reactive power in p.u (base SnRef)";
  parameter Types.Time tFilter "Filter time constant to update QMin/QMax";
  parameter String QMinTableName "Name of the table in the text file to get QMinPu from PGenPu";
  parameter String QMaxTableName "Name of the table in the text file to get QMaxPu from PGenPu";
  parameter String QMinTableFile "Text file that contains the table to get QMinPu from PGenPu";
  parameter String QMaxTableFile "Text file that contains the table to get QMaxPu from PGenPu";

  Connectors.ImPin URefPu (value(start = U0Pu)) "Voltage regulation set point in p.u (base UNom)";
  Modelica.Blocks.Tables.CombiTable1D tableQMin(tableOnFile = true, tableName = QMinTableName, fileName = QMinTableFile) "Table to get QMinPu from PGenPu";
  Modelica.Blocks.Tables.CombiTable1D tableQMax(tableOnFile = true, tableName = QMaxTableName, fileName = QMaxTableFile) "Table to get QMaxPu from PGenPu";
  Types.ReactivePowerPu QMinPu(start = QMin0Pu) "Minimum reactive power in p.u (base SnRef)";
  Types.ReactivePowerPu QMaxPu(start = QMax0Pu) "Maximum reactive power in p.u (base SnRef)";

protected
  QStatus qStatus (start = QStatus.Standard) "Voltage regulation status: standard, absorptionMax or generationMax";

equation

  PGenPu = tableQMin.u[1];
  tFilter * der(QMinPu) + QMinPu = tableQMin.y[1];
  PGenPu = tableQMax.u[1];
  tFilter * der(QMaxPu) + QMaxPu = tableQMax.y[1];

  when QGenPu <= QMinPu and UPu >= URefPu.value then
    qStatus = QStatus.AbsorptionMax;
  elsewhen QGenPu >= QMaxPu and UPu <= URefPu.value then
    qStatus = QStatus.GenerationMax;
  elsewhen (QGenPu > QMinPu or UPu < URefPu.value) and (QGenPu < QMaxPu or UPu > URefPu.value) then
    qStatus = QStatus.Standard;
  end when;

  if qStatus == QStatus.GenerationMax then
    QGenPu = QMaxPu;
  elseif qStatus == QStatus.AbsorptionMax then
    QGenPu = QMinPu;
  else
    UPu = URefPu.value;
  end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>  This generator provides an active power PGenPu that depends on an emulated frequency regulation (signal N and total generators participation alphaSum) and regulates the voltage UPu unless its reactive power generation hits its limits QMinPu or QMaxPu. These limits are calculated in the model depending on PGenPu.</div></body></html>"));
end GeneratorPVDiagramPQ;
