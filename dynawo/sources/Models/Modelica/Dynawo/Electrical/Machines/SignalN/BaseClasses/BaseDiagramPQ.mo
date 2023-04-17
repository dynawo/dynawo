within Dynawo.Electrical.Machines.SignalN.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseDiagramPQ "Base dynamic model for a PQ diagram"
  import Modelica;

  parameter String QMaxTableFile "Text file that contains the table to get QMaxPu from PGenPu";
  parameter String QMaxTableName "Name of the table in the text file to get QMaxPu from PGenPu";
  parameter String QMinTableFile "Text file that contains the table to get QMinPu from PGenPu";
  parameter String QMinTableName "Name of the table in the text file to get QMinPu from PGenPu";

  Types.ReactivePowerPu QMaxPu(start = QMax0Pu) "Maximum reactive power in pu (base SnRef)";
  Types.ReactivePowerPu QMinPu(start = QMin0Pu) "Minimum reactive power in pu (base SnRef)";

  Modelica.Blocks.Tables.CombiTable1D tableQMax(tableOnFile = true, tableName = QMaxTableName, fileName = QMaxTableFile) "Table to get QMaxPu from PGenPu";
  Modelica.Blocks.Tables.CombiTable1D tableQMin(tableOnFile = true, tableName = QMinTableName, fileName = QMinTableFile) "Table to get QMinPu from PGenPu";

  parameter Types.ReactivePowerPu QMax0Pu "Start value of the maximum reactive power in pu (base SnRef)";
  parameter Types.ReactivePowerPu QMin0Pu "Start value of the minimum reactive power in pu (base SnRef)";

equation
  QMaxPu = tableQMax.y[1];
  QMinPu = tableQMin.y[1];

  annotation(preferredView = "text");
end BaseDiagramPQ;
