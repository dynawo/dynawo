within Dynawo.Electrical.Controls.Converters.BaseControls;

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

model IECWT4AQLimitation "IEC WT type 4A Reactive power limitation"

  import Modelica;
  import Dynawo.Types;

  extends Dynawo.Electrical.Controls.Converters.Parameters.Params_QLimit;

  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  /*Parameters for initialization from load flow*/
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in p.u (base SnRef) (receptor convention)" ;
  /*Parameters for internal initialization*/
  parameter Types.PerUnit QMax0Pu "Start value maximum reactive power (Sbase)";
  parameter Types.PerUnit QMin0Pu "Start value minimum reactive power (Sbase)";
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput uWTCfiltPu(start = sqrt(u0Pu.re*u0Pu.re + u0Pu.im*u0Pu.im)) "Filtered voltage measurement for WT control (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pWTCfiltPu(start = -P0Pu* SystemBase.SnRef / SNom) "Filtered WTT active power reference (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerInput Ffrt(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput qWTMaxPu(start = QMax0Pu) "Maximum WTT reactive power (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {120, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput qWTMinPu(start = QMin0Pu) "Maximum WTT reactive power (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {120, -70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Blocks*/
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = tableQMaxuWTCfilt)  annotation(
    Placement(visible = true, transformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D1(table = tableQMinuWTCfilt)  annotation(
    Placement(visible = true, transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D2(table = tableQMaxpWTCfilt)  annotation(
    Placement(visible = true, transformation(origin = {-30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D3(table = tableQMinpWTCfilt)  annotation(
    Placement(visible = true, transformation(origin = {-30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {50, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  connect(combiTable1D.y[1], min.u1) annotation(
    Line(points = {{-18, 80}, {0, 80}, {0, 76}, {38, 76}}, color = {0, 0, 127}));
  connect(combiTable1D3.y[1], max.u2) annotation(
    Line(points = {{-18, -80}, {0, -80}, {0, -76}, {38, -76}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], max.u1) annotation(
    Line(points = {{-18, 40}, {20, 40}, {20, -64}, {38, -64}}, color = {0, 0, 127}));
  connect(combiTable1D2.y[1], min.u2) annotation(
    Line(points = {{-18, -40}, {0, -40}, {0, 64}, {38, 64}}, color = {0, 0, 127}));
  connect(max.y, qWTMinPu) annotation(
    Line(points = {{61, -70}, {120, -70}}, color = {0, 0, 127}));
  connect(min.y, qWTMaxPu) annotation(
    Line(points = {{61, 70}, {120, 70}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, combiTable1D.u[1]) annotation(
    Line(points = {{-120, 60}, {-70, 60}, {-70, 80}, {-42, 80}, {-42, 80}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, combiTable1D1.u[1]) annotation(
    Line(points = {{-120, 60}, {-70, 60}, {-70, 40}, {-42, 40}, {-42, 40}}, color = {0, 0, 127}));
  connect(pWTCfiltPu, combiTable1D2.u[1]) annotation(
    Line(points = {{-120, -60}, {-70, -60}, {-70, -40}, {-42, -40}, {-42, -40}}, color = {0, 0, 127}));
  connect(pWTCfiltPu, combiTable1D3.u[1]) annotation(
    Line(points = {{-120, -60}, {-70, -60}, {-70, -80}, {-42, -80}, {-42, -80}}, color = {0, 0, 127}));

annotation(
    Icon(graphics = {Rectangle(origin = {-1, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-99, 100}, {101, -100}}), Text(origin = {27, 17}, extent = {{-57, 51}, {3, 11}}, textString = "Q"), Text(origin = {-37, 43}, extent = {{-53, 49}, {127, -133}}, textString = "limitation"), Text(origin = {-3, -53}, extent = {{-53, 49}, {61, -39}}, textString = "module")}, coordinateSystem(initialScale = 0.1)));

end IECWT4AQLimitation;
