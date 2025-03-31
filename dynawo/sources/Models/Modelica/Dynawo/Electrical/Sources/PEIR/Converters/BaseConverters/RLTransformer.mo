within Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters;

model RLTransformer "RL Transformer in (dq) frame"
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
  parameter Types.PerUnit RPu "Resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XPu "Impedance in pu (base UNom, SNom)";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udPccPu(start = UdPcc0Pu) "d-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqPccPu(start = UqPcc0Pu) "q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdPcc0Pu "Start value of d-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit UqPcc0Pu "Start value of q-axis voltage at the PCC in pu (base UNom)";

  final parameter Types.PerUnit UdFilter0Pu = RPu * IdPcc0Pu - XPu * IqPcc0Pu + UdPcc0Pu "Start value of d-axis voltage at the filter in pu (base UNom)";
  final parameter Types.PerUnit UqFilter0Pu = RPu * IqPcc0Pu + XPu * IdPcc0Pu + UqPcc0Pu "Start value of q-axis voltage at the filter in pu (base UNom)";

equation
  0 = udFilterPu - RPu * idPccPu + XPu * iqPccPu - udPccPu;
  0 = uqFilterPu - RPu * iqPccPu - XPu * idPccPu - uqPccPu;

  annotation(preferredView = "text",
    Icon(graphics = {Line(origin = {0.292174, 0},points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255}), Line(origin = {0.4243, 0.292221}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {30, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {60, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {60, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {90, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Rectangle(extent = {{-100, 100}, {100, -100}}), Line(origin = {160.466, 0.26087}, points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255})}, coordinateSystem(initialScale = 0.01)));
end RLTransformer;
