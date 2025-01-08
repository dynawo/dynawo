within Dynawo.Electrical.Events;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model VariableImpedantFault "Variable impedant fault with R and X of the fault given by tables as functions of time"

/*
  Equivalent circuit and conventions:

                I
   (terminal) -->-------R+jX-------| Earth

*/
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffLine;

  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Parameters
  parameter String ImpedanceTableFile "Text file that contains the table to get the impedance from time";
  parameter String ImpedanceTimeTable "Table to get the impedance from time : 3 columns, the first for time, second for R and third for X";

  // Variable
  Types.ComplexImpedancePu ZvPu "The complex variable representing the impedance of the fault";

  Modelica.Blocks.Sources.CombiTimeTable ZvTimeTable(columns = 2:3,fileName = ImpedanceTableFile, tableName = ImpedanceTimeTable, tableOnFile = true)  annotation(
    Placement(visible = true, transformation(origin = {-1.77636e-15, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation

  ZvPu = Complex(ZvTimeTable.y[1], ZvTimeTable.y[2]);

  if (running.value) then
    ZvPu * terminal.i = terminal.V;
  else
    terminal.i = Complex (0);
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The variable impedant fault model enables making R and X of the fault vary through time. The values of R and X are entered with a combiTimeTable. The model is represented with the following equivalent circuit and conventions:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                I                  </span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">   (terminal) --&gt;-------R+jX------| Earth</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                    </span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--EndFragment--></pre></div><div><div><pre style=\"text-align: center; margin-top: 0px; margin-bottom: 0px;\"><!--EndFragment--></pre></div></div></body></html>"),
  Icon(graphics = {Line(origin = {-1, 49}, points = {{1, 41}, {1, 11}}), Rectangle(origin = {0, 10}, extent = {{-20, 50}, {20, -50}}), Line(origin = {-1, 49}, points = {{1, 41}, {1, 11}}), Line(origin = {-0.943182, -81.0105}, points = {{1, 41}, {1, 1}}), Line(origin = {0, -80}, points = {{-40, 0}, {40, 0}}), Line(origin = {-30, -90}, points = {{-10, -10}, {10, 10}}), Line(origin = {-10.0293, -89.9432}, points = {{-10, -10}, {10, 10}}), Line(origin = {9.98079, -90.0347}, points = {{-10, -10}, {10, 10}}), Line(origin = {30.0723, -90.1262}, points = {{-10, -10}, {10, 10}}), Line(origin = {-49.7114, -90.0225}, points = {{-10, -10}, {10, 10}}), Line(origin = {-0.252786, 9.79497}, points = {{-39.7472, -29.795}, {40.2528, 30.205}, {34.2528, 18.205}, {40.2528, 30.205}, {26.2528, 28.205}})}));
end VariableImpedantFault;
