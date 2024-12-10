within Dynawo.Electrical.Controls.IEC.IEC63406.Protections.AuxiliaryProtections;

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

model FRTCurrentBounds

  //Parameters
  parameter Types.PerUnit IMaxPu "Maximum current" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean pqFRTFlag "Active/reactive control priority, 0/1" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IPMaxPu "Maximum active current" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IQMaxPu "Maximum reactive current" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IPMinPu "Minimum active current" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IQMinPu "Minimum reactive current" annotation(
    Dialog(tab = "FRT"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipLVRTPrimPu annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqLVRTPrimPu annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipMinPu annotation(
    Placement(visible = true, transformation(origin = {110, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu annotation(
    Placement(visible = true, transformation(origin = {110, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
