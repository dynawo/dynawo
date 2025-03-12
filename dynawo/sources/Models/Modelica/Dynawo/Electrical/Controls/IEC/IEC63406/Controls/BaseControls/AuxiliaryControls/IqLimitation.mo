within Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls.AuxiliaryControls;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model IqLimitation "Reactive current limitation block (IEC 63406)"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //General parameters
  parameter Types.PerUnit IMaxPu "Maximum current at converter terminal in pu (base in UNom, SNom) (generator convention)";
  parameter Boolean PriorityFlag "0 for active current priority, 1 for reactive current priority";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput iPcmdPu(start = - P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput iQMaxPu(start = IQMax0Pu) "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ReactivePowerPu P0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group="Operating point"));
  parameter Types.PerUnit IQMax0Pu = if PriorityFlag then IMaxPu else sqrt(IMaxPu ^ 2 - (-P0Pu * SystemBase.SnRef / (SNom * U0Pu)) ^ 2)  "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));

equation
  iQMaxPu = if PriorityFlag then IMaxPu else noEvent(if IMaxPu ^ 2 > iPcmdPu ^ 2 then sqrt(IMaxPu ^ 2 - iPcmdPu ^ 2) else 0);

annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 2}, extent = {{-96, 96}, {96, -96}}, textString = "Limit
Iq")}));
end IqLimitation;
