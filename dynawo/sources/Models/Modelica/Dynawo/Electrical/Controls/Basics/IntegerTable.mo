within Dynawo.Electrical.Controls.Basics;

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

model IntegerTable "Generate an Integer output signal based on a table stored in a .txt file (data from a two-column table in a .txt file)"

  parameter Modelica.Blocks.Types.Extrapolation Extrapolation "Extrapolation of data outside the definition range";
  parameter String FileName = "NoName" "File where vector is stored" annotation(
    Dialog(enable = TableOnFile,
    loadSelector(filter = "Text files (*.txt);;MATLAB MAT-files (*.mat)",
    caption = "Open file in which table is present")));
  parameter String TableName = "NoName" "Table name on file or in function usertab (see docu)";

  Dynawo.Connectors.IntPin source "Output value";

  Modelica.Blocks.Sources.IntegerTable integerTable(
    combiTimeTable(fileName = FileName, tableName = TableName, tableOnFile = true),
    extrapolation = Extrapolation,
    table = [0, 0]) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  source.value = integerTable.y;

  annotation(preferredView = "text");
end IntegerTable;
