within Dynawo.Electrical.Controls.PEIR.BaseControls;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model VirtualImpedance "Virtual impedance model for the current limitation of grid forming converters"

  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.CurrentModulePu IMaxVI "Maximum current before activating the virtual impedance in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput DeltaVVId(start = DeltaVVId0) "d-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput DeltaVVIq(start = DeltaVVIq0) "q-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.CurrentModulePu IConvSquare0Pu "Start value of square current in the converter in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu DeltaIConvSquare0Pu "Start value of extra square current in the converter in pu (base UNom, SNom)";
  parameter Types.PerUnit RVI0 "Start value of virtual resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XVI0 "Start value of virtual reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit DeltaVVId0 "Start value of d-axis virtual impedance output in pu (base UNom)";
  parameter Types.PerUnit DeltaVVIq0 "Start value of q-axis virtual impedance output in pu (base UNom)";

protected
  Types.CurrentModulePu IConvSquarePu(start = IConvSquare0Pu) "Square current in the converter in pu (base UNom, SNom)";
  Types.CurrentModulePu DeltaIConvSquarePu(start = DeltaIConvSquare0Pu) "Extra square current in the converter in pu (base UNom, SNom)";
  Types.PerUnit RVI(start = RVI0) "Virtual resistance in pu (base UNom, SNom)";
  Types.PerUnit XVI(start = XVI0) "Virtual reactance in pu (base UNom, SNom)";

equation
  IConvSquarePu = idConvPu ^ 2 + iqConvPu ^ 2;
  DeltaIConvSquarePu = max((IConvSquarePu - IMaxVI ^ 2), 0);
  RVI = KpVI * DeltaIConvSquarePu;
  XVI = RVI * XRratio;
  DeltaVVId = idConvPu * RVI - iqConvPu * XVI;
  DeltaVVIq = iqConvPu * RVI + idConvPu * XVI;

  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1})));
end VirtualImpedance;
