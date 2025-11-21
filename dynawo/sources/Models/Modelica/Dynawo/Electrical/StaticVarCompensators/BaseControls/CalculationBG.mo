within Dynawo.Electrical.StaticVarCompensators.BaseControls;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model CalculationBG "Final calculation of the susceptance and the conductance"
  extends Parameters.ParamsCalculationBG;

  Modelica.Blocks.Interfaces.RealInput BVarPu "Variable susceptance of the static var compensator in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput GCstPu "Fixed conductance of the static var compensator in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput BPu "Final susceptance of the static var compensator in pu (base SNom)" annotation(
    Placement(visible = true, transformation(extent = {{100, 50}, {120, 70}}, rotation = 0), iconTransformation(origin = {107, 59}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput GPu "Final conductance of the static var compensator in pu (base SNom)" annotation(
    Placement(visible = true, transformation(extent = {{100, -70}, {120, -50}}, rotation = 0), iconTransformation(origin = {107, -59}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));

  ModeConnector mode "Current mode of the static var compensator" annotation(
    Placement(visible = true, transformation(origin = {62, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {72, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

equation
  if mode.value == Mode.RUNNING_V then
    BPu = BVarPu + BShuntPu;
    GPu = GCstPu;
  elseif mode.value == Mode.STANDBY then
    BPu = BShuntPu;
    GPu = GCstPu;
  else
    BPu = 0;
    GPu = 0;
  end if;

  annotation(preferredView = "text",
    Diagram(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-18, 1}, extent = {{-60, 21}, {94, -23}}, textString = "CalculationBG")}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-70, 28}, extent = {{6, -6}, {142, -46}}, textString = "CalculationBG")}, coordinateSystem(initialScale = 0.1)));
end CalculationBG;
