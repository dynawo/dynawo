within Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls.AuxiliaryControls;

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

model IqLimitation

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //General parameters
  parameter Types.PerUnit IMaxPu "Maximum current" annotation(
    Dialog(tab = "General"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput iPcmdPu(start=-P0Pu*SystemBase.SnRef/(SNom*U0Pu)) "Reactive current command" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput iQMaxPu annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ReactivePowerPu P0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group="Operating point"));

equation
  iQMaxPu = sqrt(max(0.001,IMaxPu ^ 2 - iPcmdPu ^ 2));

annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 2}, extent = {{-96, 96}, {96, -96}}, textString = "Limit
Iq")}));
end IqLimitation;
