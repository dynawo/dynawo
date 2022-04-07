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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model IqInjectionLogic "Reactive Current Injection Logic"
  import Modelica;
  import Dynawo.Types;

  parameter Types.CurrentModulePu IqFrzPu "Constant reactive current injection value in pu (base SNom, UNom)";
  parameter Types.Time HoldIq "Absolute value of HoldIq defines seconds to hold current injection after voltage dip ended. HoldIq < 0 for constant, 0 for no injection after voltage dip, HoldIq > 0 for voltage dependent injection";

  Modelica.Blocks.Interfaces.RealInput iqVPu(start = 0) "Input for voltage dependent reactive current injection in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput vDip(start = false) "Ongoing voltage dip" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqInjPu(start = 0) "Reactive current injection in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Types.Time vDipInjEndTime(start = -1) "ending time of the voltage dip start (in seconds)";

equation
  /*
   *  This equations handles the time sensitive control variables that manage
   *  the equations and ultimately the output of the block.
   *  It uses "when" clauses, which activate only once, when the condition
   *  is met, in other words: when an event happens.
   *
   *  1. When a Voltage dip occurs, the injection is set to the voltage dependent input.
   *  2. When the Voltage dip ends, the end timing vDipInjEndTime is calculated by adding the absolute value of HoldIq to the current time.
   *     During this time, the injection depends on the value of HoldIq.
   *  3. Finally, when the current time passes the end timing vDipInjEndTime, the injection returns to 0.
   */
  when (vDip == false and pre(vDip) == true) or (time < pre(vDipInjEndTime) and pre(vDipInjEndTime) >= 0)  then
    vDipInjEndTime = time + abs(HoldIq);
  elsewhen (vDip == true or pre(vDip) == false) and (time >= pre(vDipInjEndTime) or pre(vDipInjEndTime) < 0) then
    vDipInjEndTime = -1;
  end when;

  if (vDip == true) or (vDip == false and vDipInjEndTime >= 0 and HoldIq > 0 and time <= vDipInjEndTime) then // check for vDipInjEndTime >= 0 to see if there is a freeze state and time <= vDipInjEndTime for additional safety.
    iqInjPu = iqVPu;
  elseif (vDip == false and vDipInjEndTime >= 0 and HoldIq < 0 and time <= vDipInjEndTime) then
    iqInjPu = IqFrzPu;
  else
    iqInjPu = 0;
  end if;

  annotation(
    Documentation(info = "<html><head></head><body><p>This block implements the behavior of the switch mechanic for reactive current injection, as specified in:<br><a href=\"https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a></p><ul><li>Setting HoldIq to 0 results in abrupt ending of injection after the voltage dip has ended.</li><li>Setting HoldIq to a positive value continues the injection with the voltage dependent injection for the absolute value of HoldIq seconds after the voltage dip has ended.</li><li>Setting HoldIq to a negative value continues the injection with a set constant (IqFrzPu) for the absolute value of HoldIq seconds after the voltage dip has ended.</li></ul></body></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 74}, extent = {{-74, -38}, {82, -78}}, textString = "Reactive Current"), Text(origin = {1, -7}, extent = {{-63, 17}, {69, -21}}, textString = "Injection Logic"), Text(origin = {-129, 108}, extent = {{-19, 10}, {19, -10}}, textString = "vDip"), Text(origin = {-127, 28}, extent = {{-19, 10}, {19, -10}}, textString = "iqVPu"), Text(origin = {-127, 28}, extent = {{-19, 10}, {19, -10}}, textString = "iqVPu"), Text(origin = {121, 16}, extent = {{-19, 10}, {19, -10}}, textString = "iqInjPu")}));
end IqInjectionLogic;
