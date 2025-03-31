within Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters;

model DynRLCFilter "Dynamic RLC Filter in (dq) frame"
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
  parameter Types.PerUnit LPu "Inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit CPu "Capacitance in pu (base UNom, SNom)";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput udConvPu(start = UdConv0Pu) "d-axis voltage at the converter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqConvPu(start = UqConv0Pu) "q-axis voltage at the converter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current at the PCC in pu (base UNom, SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-119, -39}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current at the PCC in pu (base UNom, SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = IdConv0Pu) "d-axis current at the converter in pu (base UNom, SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = IqConv0Pu) "q-axis current at the converter in pu (base UNom, SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current at the PCC in pu (base UNom, SNom) in generator convention";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current at the PCC in pu (base UNom, SNom) in generator convention";
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the filter in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the filter in pu (base UNom)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of converter's frequency in pu (base omegaNom)";

  final parameter Types.PerUnit IdConv0Pu = -Omega0Pu * CPu * UqFilter0Pu + IdPcc0Pu "Start value of d-axis current at the converter in pu (base UNom, SNom) in generator convention";
  final parameter Types.PerUnit IqConv0Pu = Omega0Pu * CPu * UdFilter0Pu + IqPcc0Pu "Start value of q-axis current at the converter in pu (base UNom, SNom) in generator convention";
  final parameter Types.PerUnit UdConv0Pu = RPu * IdConv0Pu - Omega0Pu * LPu * IqConv0Pu + UdFilter0Pu "Start value of d-axis voltage at the converter in pu (base UNom)";
  final parameter Types.PerUnit UqConv0Pu = RPu * IqConv0Pu + Omega0Pu * LPu * IdConv0Pu + UqFilter0Pu "Start value of q-axis voltage at the converter in pu (base UNom)";

equation
  LPu / SystemBase.omegaNom * der(idConvPu) = udConvPu - RPu * idConvPu + omegaPu * LPu * iqConvPu - udFilterPu;
  LPu / SystemBase.omegaNom * der(iqConvPu) = uqConvPu - RPu * iqConvPu - omegaPu * LPu * idConvPu - uqFilterPu;
  CPu / SystemBase.omegaNom * der(udFilterPu) = idConvPu + omegaPu * CPu * uqFilterPu - idPccPu;
  CPu / SystemBase.omegaNom * der(uqFilterPu) = iqConvPu - omegaPu * CPu * udFilterPu - iqPccPu;

  annotation(preferredView = "text",
    Icon(graphics = {Line(origin = {0.292174, 0},points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {-19.5757, 0.292221},points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {10, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {40, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {40, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {70, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Rectangle(extent = {{-100, 100}, {100, -100}}), Line(origin = {139.367, 0.29217}, points = {{-100, 0}, {-40, 0}}, color = {0, 0, 255}), Line(origin = {68.0764, 39.1513}, rotation = 90, points = {{-64, 0}, {-40, 0}}, color = {0, 0, 255}), Line(origin = {157.19, -25.4192}, points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {157.19, -29.4192}, points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {68.3686, 11.1026}, rotation = 90, points = {{-76, 0}, {-40, 0}}, color = {0, 0, 255}), Line(origin = {157.19, -65.4192}, points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {155.19, -67.4192}, points = {{-94, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {151.19, -69.4192}, points = {{-86, 0}, {-80, 0}}, color = {0, 0, 255})}, coordinateSystem(initialScale = 0.01)));
end DynRLCFilter;
