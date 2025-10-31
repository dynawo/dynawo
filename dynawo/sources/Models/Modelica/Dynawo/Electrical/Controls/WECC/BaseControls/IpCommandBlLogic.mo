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

model IpCommandBlLogic "Active current command logic"

  parameter Types.Time tHoldIp "Absolute value of tHoldIp defines seconds to hold current command after voltage dip ended. tHoldIp > 0 to hold  command value after voltage dip, 0 for continuous command";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput IpCmdBlPu(start = 0) "Input for active current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput vDip(start = false) "Ongoing voltage dip" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Output variable
  Modelica.Blocks.Interfaces.RealOutput IpCmdPu(start = 0) "Active current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.PerUnit IpCmdFrzPu "Value held after end of the dip";
  Types.Time vDipFrzEndTime(start = -1) "Ending time of the voltage dip start, in s";

equation
  when (vDip == false and pre(vDip) == true) or (time < pre(vDipFrzEndTime) and pre(vDipFrzEndTime) >= 0) then
    vDipFrzEndTime = time + abs(tHoldIp);
    IpCmdFrzPu = pre(IpCmdPu);
  elsewhen (vDip == true or pre(vDip) == false) and (time >= pre(vDipFrzEndTime) or pre(vDipFrzEndTime) < 0) then
    vDipFrzEndTime = -1;
    IpCmdFrzPu = pre(IpCmdPu);
  end when;

  if (vDip == false and vDipFrzEndTime >= 0 and tHoldIp > 0 and time <= vDipFrzEndTime) then
// check for vDipFrzEndTime >= 0 to see if there is a freeze state and time <= vDipFrzEndTime for additional safety.
    IpCmdPu = IpCmdFrzPu;
  else
    IpCmdPu = IpCmdBlPu;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body><p>This block implements the behavior of the switch mechanic for active current command, as specified in:<br><a href=\"https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a></p><ul><li>Setting tHoldIp to 0 has no effect on the command the value is unchanged.</li><li>Setting tHoldIp to a positive value holds the value of the command right before the end of the voltage dip for a duration equal to the value of tHoldIp after the end of the voltage dip.</li></ul></body></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-6, 68}, extent = {{-74, -38}, {82, -78}}, textString = "Active Current
 freeze Logic"), Text(origin = {-129, 108}, extent = {{-19, 10}, {19, -10}}, textString = "vDip"), Text(origin = {-127, 26}, extent = {{-19, 10}, {19, -10}}, textString = "IpCmdPBlPu"), Text(origin = {121, 16}, extent = {{-19, 10}, {19, -10}}, textString = "IpCmdPu")}));
end IpCommandBlLogic;
