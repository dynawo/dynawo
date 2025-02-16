within Dynawo.Electrical.Controls.IEC.IEC63406.Protections.AuxiliaryProtections;

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

model FRTCurrentBounds "Current limitation during FRT (IEC63406)"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Parameters
  parameter Types.PerUnit IMaxPu "Maximum current at converter terminal in pu (base in UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean pqFRTFlag "Active/reactive control priority during FRT, 0/1" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IPMaxPu "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IPMinPu "Minimum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IQMaxPu "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IQMinPu "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipLVRTPrimPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current calculated by the LVRT module in pu (base UNom, SNom) and before saturation" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqLVRTPrimPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current calculated by the LVRT module in pu (base UNom, SNom) and before saturation" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IPMax0Pu) "Maximum active current calculated in the FRT block in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu(start = IPMin0Pu) "Minimum active current calculated in the FRT block in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = IQMax0Pu) "Maximum reactive current calculated in the FRT block in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = IQMin0Pu) "Minimum reactive current calculated in the FRT block in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit IPMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit IPMin0Pu "Initial minimum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group="Operating point"));

equation
  ipMaxPu = if pqFRTFlag then min(max(IMaxPu ^ 2 - iqLVRTPrimPu ^ 2, 0), IPMaxPu) else min(IMaxPu, IPMaxPu);
  ipMinPu = 0;
  iqMaxPu = if pqFRTFlag then min(IMaxPu, IQMaxPu) else min(sqrt(max(IMaxPu ^ 2 - ipLVRTPrimPu ^ 2, 0)), IQMaxPu);
  iqMinPu = if pqFRTFlag then max(-IMaxPu, IQMinPu) else max(-sqrt(max(IMaxPu ^ 2 - ipLVRTPrimPu ^ 2, 0)), IQMinPu);

  annotation(
    Diagram(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}),
    Icon(graphics = {Text(extent = {{-100, 100}, {100, -100}}, textString = "Ip&Iq
limiter"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end FRTCurrentBounds;
