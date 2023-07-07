within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
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

model IqInjectionLogic "Reactive Current Injection Logic"

  //Parameters
  parameter Types.PerUnit IqFrzPu "Value at which reactive current injection (during a voltage-dip) is held for tHld seconds following a voltage dip if tHld > 0; in pu (base SNom, UNom) (typical: 0..Iqh1)";
  parameter Types.Time tHld "Time for which reactive current injection is held at some value following termination of the voltage-dip; if positive, then current is held at IqFrzPu, if negative then held at the value just prior to ending of the voltage-dip; in s (typical: -1..1, set to 0 to disable)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput iqVPu(start = 0) "Input for voltage-dependent reactive current injection in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput vDip(start = false) "True if voltage dip" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput iqInjPu(start = 0) "Reactive current injection in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.Time vDipInjEndTime(start = -1) "Ending time of the voltage dip in s";

equation
  /*
   *  This equation handles the time sensitive control variables that manage
   *  the equations and ultimately the output of the block.
   *  It uses "when" clauses, which activate only once, when the condition
   *  is met, in other words: when an event happens.
   *
   *  1. When a Voltage dip occurs, the injection is set to the voltage-dependent input.
   *  2. When the Voltage dip ends, the end timing vDipInjEndTime is calculated by adding the absolute
   *     value of tHld to the current time. During this time, the injection depends on the value of tHld.
   *  3. Finally, when the current time passes the end timing vDipInjEndTime, the injection returns to 0.
   */
  when not(vDip) then
    vDipInjEndTime = time + abs(tHld);
  elsewhen vDip then
    vDipInjEndTime = -1;
  end when;

  if vDip or (not(vDip) and tHld < -Modelica.Constants.eps and time <= vDipInjEndTime) then
    iqInjPu = iqVPu;
  elseif not(vDip) and tHld > Modelica.Constants.eps and time <= vDipInjEndTime then
    iqInjPu = IqFrzPu;
  else
    iqInjPu = 0;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body><p>This block implements the behavior of the switch mechanic for reactive current injection, as specified in:<br><a href=\"https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a></p><ul><li>Setting tHld to 0 results in abrupt ending of injection after the voltage dip has ended.</li><li>Setting tHld to a negative value continues the injection with the voltage-dependent injection for the absolute value of tHld seconds after the voltage dip has ended.</li><li>Setting tHld to a positive value continues the injection with a set constant (IqFrzPu) for the absolute value of tHld seconds after the voltage dip has ended.</li></ul></body></html>"),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 74}, extent = {{-74, -38}, {82, -78}}, textString = "Reactive Current"), Text(origin = {1, -7}, extent = {{-63, 17}, {69, -21}}, textString = "Injection Logic"), Text(origin = {-129, 108}, extent = {{-19, 10}, {19, -10}}, textString = "vDip"), Text(origin = {-127, 28}, extent = {{-19, 10}, {19, -10}}, textString = "iqVPu"), Text(origin = {-127, 28}, extent = {{-19, 10}, {19, -10}}, textString = "iqVPu"), Text(origin = {121, 16}, extent = {{-19, 10}, {19, -10}}, textString = "iqInjPu")}));
end IqInjectionLogic;
