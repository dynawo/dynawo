within Dynawo.Electrical.Controls.PEIR.BaseControls.GFM;
/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model CurrentSaturation "Current saturation block"

  parameter Types.CurrentModulePu IMaxPu "Maximum admissible current in pu (base UNom, SNom)";
  Modelica.Blocks.Interfaces.RealInput idConvRefPu annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-106, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-106, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idPccPu annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-106, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-106, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idConvRefSatPu annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefSatPu annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.CurrentModulePu IConvRefPu;
  Types.CurrentModulePu IPccPu;

equation

  IConvRefPu = sqrt(idConvRefPu*idConvRefPu + iqConvRefPu*iqConvRefPu);
  IPccPu = sqrt(idPccPu*idPccPu+iqPccPu*iqPccPu);

  when (IConvRefPu > IMaxPu) or (IPccPu > IMaxPu) then
    idConvRefSatPu = IMaxPu * idConvRefPu / (IConvRefPu);
    iqConvRefSatPu = IMaxPu * iqConvRefPu / (IConvRefPu);
  end when;

end CurrentSaturation;
