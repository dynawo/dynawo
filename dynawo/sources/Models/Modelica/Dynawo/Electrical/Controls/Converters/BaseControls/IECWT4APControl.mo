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

model IECWT4APControl "IEC Wind turbine active power control"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  /*Control parameters*/
  parameter Types.PerUnit upDip "Voltage dip threshold for P control. Part of WT control, often different from converter thershold" annotation(Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit Tpordp4A "Time constant in power order lag" annotation(Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit TpWTref4A "Time constant in reference power order lag" annotation(Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit dprefmax4A "Maximum WT reference power ramp rate" annotation(Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit dprefmin4A "Minimum WT reference power ramp rate" annotation(Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit dpmaxp4A "Maximum WT power ramp rate" annotation(Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit MpUscale "Voltage scaling for power reference during voltage dip (0: no scaling - 1: u scaling)" annotation(Dialog(group = "group", tab = "Pcontrol"));
  /*Parameters for initialization from load flow*/
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in p.u (base SnRef) (receptor convention)" annotation(Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)" annotation(Dialog(group = "group", tab = "Operating point"));
  /*Parameters for internal initialization*/
  parameter Types.PerUnit IpMax0Pu "Start value of the maximum active current in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Operating point"));
  final parameter Types.PerUnit uWTC0Pu = sqrt(u0Pu.re*u0Pu.re + u0Pu.im*u0Pu.im) "Initial value of the WT terminal voltage in p.u (Ubase)";
  final parameter Types.PerUnit pWTRef0Pu = -P0Pu*SystemBase.SnRef / SNom "Initial value of the active power reference at PCC in p.u. (SNom) (generator convention)";
  final parameter Types.PerUnit ipCmd0Pu = pWTRef0Pu/uWTC0Pu "Initial value of the d-axis reference current at the generator system module terminals (converter) in p.u (Ubase,SNom) (generator convention)";
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput uWTCfiltPu(start = uWTC0Pu) "Filtered voltage measurement for WT control (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-110, 85}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWTCPu(start = uWTC0Pu) "Module of the voltage at wind turbine terminals in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 45}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximum active current (Ibase)" annotation(
    Placement(visible = true, transformation(origin = {-110, 65}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pWTRefPu(start = pWTRef0Pu) "WTT active power reference in p.u. (SNom, generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -63}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start = ipCmd0Pu) "Active current command to generator system (Ibase)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Blocks*/
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {15, -55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-30, -35}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(visible = true, transformation(origin = {-45, 3}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {-15, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = upDip) annotation(
    Placement(visible = true, transformation(origin = {-75, -5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {0, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = 100, uMin = 0.01)  annotation(
    Placement(visible = true, transformation(origin = {0, 85}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = -100) annotation(
    Placement(visible = true, transformation(origin = {15, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = MpUscale) annotation(
    Placement(visible = true, transformation(origin = {-75, 29}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.RealToBoolean realToBoolean annotation(
    Placement(visible = true, transformation(origin = {-45, 29}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {85, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRampLimit firstOrderRampLimit(DuMax = dpmaxp4A, DuMin = -100, T = Tpordp4A, k = 1, y_start = pWTRef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {50, -55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRamp firstOrderRamp(DuMax = dprefmax4A, DuMin = dprefmin4A, T = TpWTref4A, k = 1, y_start = pWTRef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-75, -63}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(uWTCfiltPu, limiter1.u) annotation(
    Line(points = {{-110, 85}, {-13, 85}, {-13, 85}, {-12, 85}}, color = {0, 0, 127}));
  connect(ipMaxPu, product1.u1) annotation(
    Line(points = {{-110, 65}, {-32, 65}, {-32, 61}, {-12, 61}, {-12, 61}}, color = {0, 0, 127}));
  connect(uWTCPu, product1.u2) annotation(
    Line(points = {{-110, 45}, {-32, 45}, {-32, 49}, {-12, 49}, {-12, 49}}, color = {0, 0, 127}));
  connect(const.y, realToBoolean.u) annotation(
    Line(points = {{-64, 29}, {-57, 29}}, color = {0, 0, 127}));
  connect(realToBoolean.y, and1.u1) annotation(
    Line(points = {{-34, 29}, {-31, 29}, {-31, 19}, {-27, 19}, {-27, 20}}, color = {255, 0, 255}));
  connect(less.y, and1.u2) annotation(
    Line(points = {{-34, 3}, {-31, 3}, {-31, 11}, {-27, 11}, {-27, 12}}, color = {255, 0, 255}));
  connect(const1.y, less.u2) annotation(
    Line(points = {{-64, -5}, {-57, -5}, {-57, -5}, {-57, -5}}, color = {0, 0, 127}));
  connect(uWTCPu, less.u1) annotation(
    Line(points = {{-110, 45}, {-97, 45}, {-97, 11}, {-62, 11}, {-62, 4}, {-57, 4}, {-57, 3}}, color = {0, 0, 127}));
  connect(firstOrderRampLimit.y, division.u1) annotation(
    Line(points = {{64, -55}, {72, -55}, {72, -54}, {73, -54}}, color = {0, 0, 127}));
  connect(limiter1.y, division.u2) annotation(
    Line(points = {{11, 85}, {68, 85}, {68, -67}, {73, -67}, {73, -66}}, color = {0, 0, 127}));
  connect(product1.y, firstOrderRampLimit.uMax) annotation(
    Line(points = {{11, 55}, {31, 55}, {31, -46}, {36, -46}, {36, -46}}, color = {0, 0, 127}));
  connect(switch1.y, firstOrderRampLimit.u) annotation(
    Line(points = {{26, -55}, {36, -55}, {36, -55}, {36, -55}}, color = {0, 0, 127}));
  connect(const2.y, firstOrderRampLimit.uMin) annotation(
    Line(points = {{26, -80}, {30, -80}, {30, -64}, {36, -64}, {36, -64}}, color = {0, 0, 127}));
  connect(and1.y, switch1.u2) annotation(
    Line(points = {{-4, 20}, {-2, 20}, {-2, -56}, {3, -56}, {3, -55}}, color = {255, 0, 255}));
  connect(division.y, ipCmdPu) annotation(
    Line(points = {{96, -60}, {103, -60}, {103, -60}, {110, -60}}, color = {0, 0, 127}));
  connect(firstOrderRamp.y, switch1.u3) annotation(
    Line(points = {{-61, -63}, {3, -63}, {3, -63}, {3, -63}}, color = {0, 0, 127}));
  connect(pWTRefPu, firstOrderRamp.u) annotation(
    Line(points = {{-110, -63}, {-89, -63}, {-89, -63}, {-89, -63}}, color = {0, 0, 127}));
  connect(uWTCPu, product.u1) annotation(
    Line(points = {{-110, 45}, {-97, 45}, {-97, -28}, {-42, -28}, {-42, -29}}, color = {0, 0, 127}));
  connect(firstOrderRamp.y, product.u2) annotation(
    Line(points = {{-61, -63}, {-52, -63}, {-52, -41}, {-42, -41}, {-42, -41}}, color = {0, 0, 127}));
  connect(product.y, switch1.u1) annotation(
    Line(points = {{-19, -35}, {-12, -35}, {-12, -47}, {3, -47}, {3, -47}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -100}, {100, 100}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, extent = {{-100, -100}, {100, 100}}), Text(origin = {0, 30}, extent = {{-100, -30}, {100, 30}}, textString = "IEC WT 4A"), Text(origin = {0, -30}, extent = {{-100, -30}, {100, 30}}, textString = "PControl")}));

end IECWT4APControl;
