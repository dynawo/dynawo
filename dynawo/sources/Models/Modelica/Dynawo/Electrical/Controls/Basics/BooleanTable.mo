within Dynawo.Electrical.Controls.Basics;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

model BooleanTable "Generates a Boolean output signal based on a vector of time instants"
  import Modelica;
  import Dynawo;

  parameter Modelica.Blocks.Types.Extrapolation Extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint
    "Extrapolation of data outside the definition range";
  parameter String FileName = "NoName" "File where vector is stored"
    annotation(Dialog(
      enable=TableOnFile,
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));
  parameter String TableName = "NoName"
    "Table name on file or in function usertab (see docu)";
  parameter Dynawo.Types.Time tShift = 0
    "Shift time of table";
  parameter Dynawo.Types.Time tStart = -Modelica.Constants.inf
    "Output = false for time < tStart";

  Dynawo.Connectors.BPin source "Output value";

  Modelica.Blocks.Sources.BooleanTable booleanTable(
    combiTimeTable.tableName = TableName,
    combiTimeTable.tableOnFile = true,
    combiTimeTable.fileName = FileName,
    extrapolation = Extrapolation,
    shiftTime = tShift,
    startTime = tStart) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  source.value = booleanTable.y;

  annotation(preferredView = "text");
end BooleanTable;
