within Dynawo.Electrical.HVDC.BaseClasses;

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

partial model BaseDiagramPQTerminal1 "Base dynamic model for a PQ diagram at terminal 1"

  parameter String QInj1MaxTableFile "Text file that contains the table to get QInj1MaxPu from PInj1Pu (generator convention)";
  parameter String QInj1MaxTableName "Name of the table in the text file to get QInj1MaxPu from PInj1Pu (generator convention)";
  parameter String QInj1MinTableFile "Text file that contains the table to get QInj1MinPu from PInj1Pu (generator convention)";
  parameter String QInj1MinTableName "Name of the table in the text file to get QInj1MinPu from PInj1Pu (generator convention)";

  Modelica.Blocks.Tables.CombiTable1Dv tableQInj1Max(tableOnFile = true, tableName = QInj1MaxTableName, fileName = QInj1MaxTableFile) "Table to get QInj1MaxPu from PInj1Pu (generator convention)";
  Modelica.Blocks.Tables.CombiTable1Dv tableQInj1Min(tableOnFile = true, tableName = QInj1MinTableName, fileName = QInj1MinTableFile) "Table to get QInj1MinPu from PInj1Pu (generator convention)";

  Types.ReactivePowerPu QInj1MaxPu(start = QInj1Max0Pu) "Maximum reactive power at terminal 1 in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QInj1MinPu(start = QInj1Min0Pu) "Minimum reactive power at terminal 1 in pu (base SnRef) (generator convention)";

  parameter Types.ReactivePowerPu QInj1Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 1";
  parameter Types.ReactivePowerPu QInj1Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 1";

equation
  QInj1MaxPu = tableQInj1Max.y[1];
  QInj1MinPu = tableQInj1Min.y[1];

  annotation(preferredView = "text");
end BaseDiagramPQTerminal1;
