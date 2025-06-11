within Dynawo.Electrical.Controls.WECC.BaseControls;


/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model CurrentLimitsCalculationD "This block calculates the current limits of the WECC REEC-C regulation"

  parameter Types.PerUnit IMaxPu "Maximum inverter current amplitude in pu (base SNom, UNom)";
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag";
  parameter Real Ke "Allow for modeling of energy storage";
  // Input variables
  Modelica.Blocks.Interfaces.RealInput ipCmdPu "p-axis command current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu "q-axis command current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ipVdlPu "Voltage-dependent limit for active current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, 73}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, 41}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqVdlPu "Voltage-dependent limit for reactive current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, -75}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, -35}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu "p-axis maximum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu "q-axis maximum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu "p-axis minimum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu "q-axis minimum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
 equation
if PQFlag==false then
  iqMaxPu=min(iqVdlPu,IMaxPu);
  if iqMaxPu>0 then
    iqMinPu=-iqMaxPu;
  else
    iqMinPu=iqMaxPu;
  end if;
  ipMaxPu=min(ipVdlPu,noEvent(if IMaxPu>iqCmdPu then sqrt(IMaxPu^2-iqCmdPu^2) else 0));
  ipMinPu=-Ke*ipMaxPu;
else
  iqMaxPu=min(iqVdlPu,noEvent(if IMaxPu>ipCmdPu then sqrt(IMaxPu^2-ipCmdPu^2) else 0));
  if iqMaxPu>0 then
    iqMinPu=-iqMaxPu;
  else
    iqMinPu=iqMaxPu;
  end if;
  ipMaxPu=min(ipVdlPu,IMaxPu);
  ipMinPu=-Ke*ipMaxPu;
end if;
  

end CurrentLimitsCalculationD;
