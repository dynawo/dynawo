within Dynawo.Electrical.Machines.SignalN;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GeneratorPQPropDiagramPQSFR "Model for generator PQ with a PQ diagram, based on SignalN for the frequency handling, with a proportional reactive power regulation and that participates in the Secondary Frequency Regulation (SFR)"
  import Modelica;

  extends BaseClasses.BaseGeneratorSignalNSFR;
  extends AdditionalIcons.Machine;

  parameter Real QPercent "Percentage of the coordinated reactive control that comes from this machine";
  parameter Types.Time tFilter "Filter time constant to update QMin/QMax";
  parameter String QMinTableName "Name of the table in the text file to get QMinPu from PGenPu";
  parameter String QMaxTableName "Name of the table in the text file to get QMaxPu from PGenPu";
  parameter String QMinTableFile "Text file that contains the table to get QMinPu from PGenPu";
  parameter String QMaxTableFile "Text file that contains the table to get QMaxPu from PGenPu";

  input Types.PerUnit NQ "Signal to change the reactive power generation of the generator depending on the centralized distant voltage regulation (generator convention)";

  Modelica.Blocks.Tables.CombiTable1D tableQMin(tableOnFile = true, tableName = QMinTableName, fileName = QMinTableFile) "Table to get QMinPu from PGenPu";
  Modelica.Blocks.Tables.CombiTable1D tableQMax(tableOnFile = true, tableName = QMaxTableName, fileName = QMaxTableFile) "Table to get QMaxPu from PGenPu";
  Types.ReactivePowerPu QMinPu(start = QMin0Pu) "Minimum reactive power in pu (base SnRef)";
  Types.ReactivePowerPu QMaxPu(start = QMax0Pu) "Maximum reactive power in pu (base SnRef)";

  parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power set point in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QMin0Pu "Start value of the minimum reactive power in pu (base SnRef)";
  parameter Types.ReactivePowerPu QMax0Pu "Start value of the maximum reactive power in pu (base SnRef)";

protected
  Types.ReactivePowerPu QGenRawPu(start = QGen0Pu) "Reactive power generation without taking limits into account in pu (base SnRef) (generator convention)";

equation
  PGenPu = tableQMin.u[1];
  tFilter * der(QMinPu) + QMinPu = tableQMin.y[1];
  PGenPu = tableQMax.u[1];
  tFilter * der(QMaxPu) + QMaxPu = tableQMax.y[1];

  QGenRawPu = - QRef0Pu + QPercent * NQ;

  if running.value then
    QGenPu = if QGenRawPu >= QMaxPu then QMaxPu elseif QGenRawPu <= QMinPu then QMinPu else QGenRawPu;
  else
    terminal.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This PQ generator adapts it Q to regulate the voltage of a distant bus along with other generators depending on a participation factor QPercent. To do so, it receives a set point NQ to adapt its Q. This NQ is common to all the generators participating in this regulation. The reactive power limitations follow a PQ diagram. </div></body></html>"));
end GeneratorPQPropDiagramPQSFR;
