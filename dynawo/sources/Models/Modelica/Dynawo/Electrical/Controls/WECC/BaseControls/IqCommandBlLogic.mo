within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

model IqCommandBlLogic "Reactive current command logic"

  parameter Types.CurrentModulePu IqFrzPu "Constant reactive current injection value in pu (base SNom, UNom)";
  parameter Types.Time tHoldIq "Absolute value of tHoldIq defines seconds to hold current injection after voltage dip ended. tHoldIq > 0 to hold command value after voltage dip, 0 for continuous command, tHoldIq < 0 for constant command";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput iqCmdBlPu(start = 0) "Input for reactive current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput vDip(start = false) "Ongoing voltage dip" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Output variable
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = 0) "Reactive current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.PerUnit IqCmdFrzPu(start = 0);
  Types.Time vDipFrzEndTime(start = -1) "ending time of the voltage dip start, in s";

equation
  when (vDip == false and pre(vDip) == true) or (time < pre(vDipFrzEndTime) and pre(vDipFrzEndTime) >= 0) then
    vDipFrzEndTime = time + abs(tHoldIq);
    IqCmdFrzPu = pre(iqCmdPu);
  elsewhen (vDip == true or pre(vDip) == false) and (time >= pre(vDipFrzEndTime) or pre(vDipFrzEndTime) < 0) then
    vDipFrzEndTime = -1;
    IqCmdFrzPu = pre(IqCmdFrzPu);
  end when;

  if (vDip == false and vDipFrzEndTime >= 0 and tHoldIq < 0 and time <= vDipFrzEndTime) then
// check for vDipFrzEndTime >= 0 to see if there is a freeze state and time <= vDipFrzEndTime for additional safety.
    iqCmdPu = IqFrzPu;
  elseif (vDip == false and vDipFrzEndTime >= 0 and tHoldIq > 0 and time <= vDipFrzEndTime) then
    iqCmdPu = IqCmdFrzPu;
  else
    iqCmdPu = iqCmdBlPu;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body><p>This block implements the behavior of the switch mechanic for reactive current command, as specified in:<br><a href=\"https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a></p><ul><li>Setting tHoldIq to 0&nbsp;<span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">&nbsp;has no effect on the command the value is unchanged.</span></li><li>Setting tHoldIq to a negative value implies a constant current command&nbsp;<span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">&nbsp;for a duration equal to the value of tHoldIp after the end of the voltage dip.</span></li><li>Setting tHoldIq to a positive value<span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">&nbsp;holds the value of the command right before the end of the voltage dip for a duration equal to the value of tHoldIp after the end of the voltage dip.</span></li></ul></body></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 74}, extent = {{-74, -38}, {82, -78}}, textString = "Reactive Current"), Text(origin = {1, -7}, extent = {{-63, 17}, {69, -21}}, textString = "Injection Logic"), Text(origin = {-129, 108}, extent = {{-19, 10}, {19, -10}}, textString = "vDip"), Text(origin = {-127, 28}, extent = {{-19, 10}, {19, -10}}, textString = "iqVPu"), Text(origin = {-127, 28}, extent = {{-19, 10}, {19, -10}}, textString = "iqVPu"), Text(origin = {121, 16}, extent = {{-19, 10}, {19, -10}}, textString = "iqCmdPu")}));
end IqCommandBlLogic;
