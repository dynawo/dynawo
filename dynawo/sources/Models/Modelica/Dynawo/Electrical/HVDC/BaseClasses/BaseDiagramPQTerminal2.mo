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

partial model BaseDiagramPQTerminal2 "Base dynamic model for a PQ diagram at terminal 2"
  import Modelica;

  parameter String QInj2MaxTableFile "Text file that contains the table to get QInj2MaxPu from PInj2Pu (generator convention)";
  parameter String QInj2MaxTableName "Name of the table in the text file to get QInj2MaxPu from PInj2Pu (generator convention)";
  parameter String QInj2MinTableFile "Text file that contains the table to get QInj2MinPu from PInj2Pu (generator convention)";
  parameter String QInj2MinTableName "Name of the table in the text file to get QInj2MinPu from PInj2Pu (generator convention)";

  Modelica.Blocks.Tables.CombiTable1D tableQInj2Max(tableOnFile = true, tableName = QInj2MaxTableName, fileName = QInj2MaxTableFile) "Table to get QInj2MaxPu from PInj2Pu (generator convention)";
  Modelica.Blocks.Tables.CombiTable1D tableQInj2Min(tableOnFile = true, tableName = QInj2MinTableName, fileName = QInj2MinTableFile) "Table to get QInj2MinPu from PInj2Pu (generator convention)";

  Types.ReactivePowerPu QInj2MaxPu(start = QInj2Max0Pu) "Maximum reactive power at terminal 2 in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QInj2MinPu(start = QInj2Min0Pu) "Minimum reactive power at terminal 2 in pu (base SnRef) (generator convention)";

  parameter Types.ReactivePowerPu QInj2Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 2";
  parameter Types.ReactivePowerPu QInj2Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 2";

equation
  QInj2MaxPu = tableQInj2Max.y[1];
  QInj2MinPu = tableQInj2Min.y[1];

  annotation(preferredView = "text");
end BaseDiagramPQTerminal2;
