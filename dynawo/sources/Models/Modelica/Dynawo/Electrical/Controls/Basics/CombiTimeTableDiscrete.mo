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

model CombiTimeTableDiscrete "Table look-up with respect to time and constant extrapolation method (data from a two-column table in a .txt file) with one discrete Real output"
  import Modelica;
  import Dynawo;

  parameter String FileName = "NoName" "File where matrix is stored"
    annotation(Dialog(
      enable=TableOnFile,
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));
  parameter String TableName = "NoName"
    "Table name on file or in function usertab (see docu)";
  parameter Dynawo.Types.Time tDelay = 0.1 "Time delay after which the discrete output changes, in s";

  Dynawo.Connectors.ZPin source "Output connector";

  Dynawo.Types.Time tChange(start = 0) "Time instant at which the table continuous output changes, in s";

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, fileName = FileName, smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, tableName = TableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  when change(combiTimeTable.nextTimeEvent) then
    tChange = time;
  end when;

  when time > tChange + tDelay then
    source.value = combiTimeTable.y[1];
  end when;

  annotation(preferredView = "text");
end CombiTimeTableDiscrete;
