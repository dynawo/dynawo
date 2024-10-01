within Dynawo.Electrical.Wind.IEC.WPP;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WPP4CurrentSource2015_INIT "Wind Power Plant Type 4 model from IEC 61400-27-1 standard : initialization model"
  extends Dynawo.Electrical.Wind.IEC.WT.WT4CurrentSource_INIT;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QControlParameters2020;

  //WPP Qcontrol parameters
  parameter Types.PerUnit Kwpqu "Voltage controller cross coupling gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Integer MwpqMode "Control mode (0 : reactive power reference, 1 : power factor reference, 2 : UQ static, 3 : voltage control)";

  Dynawo.Types.PerUnit X0Pu "Initial reactive power or voltage reference in pu (base SNom or UNom) (generator convention)";

  //These variables are dedicated to reverse the lookup table TableQwpUErr (only necessary when MwpqMode = 2)
  Dynawo.Types.PerUnit UErr0 "Initial voltage difference UWPRef0Pu - U0Pu such that the combitable TableQwpUErr gives -Q0Pu * SystemBase.SnRef / SNom as its output";
  Integer i "Iterative variable to search in each interval of the lookup table";
  Boolean search "Boolean variable to know whether it is necessary to keep searching or not";
  Dynawo.Types.PerUnit x1 "Left bound of interval i" ;
  Dynawo.Types.PerUnit x2 "Right bound of interval i";
  Dynawo.Types.ReactivePowerPu y1 "y-value associated to x1 in the lookup table";
  Dynawo.Types.ReactivePowerPu y2 "y-value associated to x2 in the lookup table";
  Dynawo.Types.ReactivePowerPu yma "Maximum between y1 and y2";
  Dynawo.Types.ReactivePowerPu ymi "Minimum between y1 and y2";

algorithm
  i := 0;
  search := true;

  while search loop
    i := i + 1; //For each iteration we search into the i-th interval

    //Let's update the data for this interval
    x1 := TableQwpUErr[i,1];
    x2 := TableQwpUErr[i+1,1];
    y1 := TableQwpUErr[i,2];
    y2 := TableQwpUErr[i+1,2];

    if y1 < y2 then
      yma := y2;
      ymi := y1;
    else
      yma := y1;
      ymi := y2;
    end if;

    // Check if y0 is between ymi and yma
    if (-Q0Pu * SystemBase.SnRef / SNom >= ymi) and (-Q0Pu * SystemBase.SnRef / SNom <= yma) then
      // Interpolate to find the corresponding x value and set search to false to stop searching (possible other solutions in other intervals are ignored)
      search := false;
      UErr0 := x1 + (-Q0Pu * SystemBase.SnRef / SNom - y1) / (y2 - y1) * (x2 - x1); // Store the solution
    end if;

  // If we are at the end of the table and no corresponding value has been found, UErr0 is set to 0 and we stop searching
    if i >= size(TableQwpUErr,1) - 1 and search then
      UErr0 := 0;
      search := false;
    end if;

  end while;

equation
  X0Pu = if MwpqMode == 0 then -Q0Pu * SystemBase.SnRef / SNom else if MwpqMode == 1 then Q0Pu / P0Pu else if MwpqMode == 2 then U0Pu + UErr0 else if MwpqMode == 3 then U0Pu - Kwpqu * Q0Pu * SystemBase.SnRef / SNom else 0;

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})));
end WPP4CurrentSource2015_INIT;
