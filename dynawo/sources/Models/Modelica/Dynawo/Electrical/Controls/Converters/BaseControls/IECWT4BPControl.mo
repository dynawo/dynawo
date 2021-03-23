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

model IECWT4BPControl "IEC Wind turbine active power control"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  /*Control parameters*/
  parameter Types.Time TpOrdp4A "Time constant in power order lag in seconds" annotation(
  Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.Time Tpaero "Time constant in power order lag in seconds" annotation(
  Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit DpMaxp4A "Maximum WT power ramp rate" annotation(
  Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.Time TpWTRef4A "Time constant in reference power order lag in seconds" annotation(
  Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit DpRefMax4A "Maximum WT reference power ramp rate in p.u/s (base SNom) (generator convention)" annotation(
  Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit DpRefMin4A "Minimum WT reference power ramp rate in p.u/s (base SNom) (generator convention)" annotation(
  Dialog(group = "group", tab = "Pcontrol"));
  parameter Boolean MpUScale "Voltage scaling for power reference during voltage dip (0: no scaling, 1: u scaling)" annotation(
  Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit UpDip "Voltage dip threshold for P control in pu (base UNom). Part of WT control, often different from converter thersholds" annotation(
  Dialog(group = "group", tab = "Pcontrol"));

  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  /*Parameters for internal initialization*/
  parameter Types.PerUnit IpMax0Pu "Start value of the maximum active current in pu (base UNom, SNom) (generator convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput uWTCfiltPu(start = U0Pu) "Voltage measurement (filtered) at wind turbine terminals in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 85}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWTCPu(start = U0Pu) "Module of the voltage at wind turbine terminals in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 45}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximum active current in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 65}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pWTRefPu(start = -P0Pu*SystemBase.SnRef / SNom ) "WTT active power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -63}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaGenPu(start = SystemBase.omegaRef0Pu) "Imaginary component of the current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start = -P0Pu*SystemBase.SnRef / (SNom * U0Pu)) "Active current command to generator system in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput paeroPu(start = -P0Pu*SystemBase.SnRef / SNom) "Phase shift of the converter's rotating frame with respect to the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {111, -85}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = { 110, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));

  /*Blocks*/
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-3, -55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-40, -47}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(visible = true, transformation(origin = {-57, 3}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {-30, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = UpDip) annotation(
    Placement(visible = true, transformation(origin = {-85, -5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {0, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = 999, uMin = 0.01)  annotation(
    Placement(visible = true, transformation(origin = {0, 85}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-23, -90}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {86, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRampLimit firstOrderRampLimit(DuMax = DpMaxp4A, DuMin = -999, GainAW = 1000, T = TpOrdp4A, k = 1, y_start = -P0Pu*SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {51, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = MpUScale)  annotation(
    Placement(visible = true, transformation(origin = {-77, 29}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tpaero, y_start = -P0Pu * SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {55, -85}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {23, -55}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Falling = DpRefMin4A, Rising = DpRefMax4A)  annotation(
    Placement(visible = true, transformation(origin = {-80, -63}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(uWTCfiltPu, limiter1.u) annotation(
    Line(points = {{-110, 85}, {-13, 85}, {-13, 85}, {-12, 85}}, color = {0, 0, 127}));
  connect(ipMaxPu, product1.u1) annotation(
    Line(points = {{-110, 65}, {-32, 65}, {-32, 61}, {-12, 61}, {-12, 61}}, color = {0, 0, 127}));
  connect(uWTCPu, product1.u2) annotation(
    Line(points = {{-110, 45}, {-32, 45}, {-32, 49}, {-12, 49}, {-12, 49}}, color = {0, 0, 127}));
  connect(less.y, and1.u2) annotation(
    Line(points = {{-46, 3}, {-42, 3}, {-42, 12}}, color = {255, 0, 255}));
  connect(const1.y, less.u2) annotation(
    Line(points = {{-74, -5}, {-69, -5}}, color = {0, 0, 127}));
  connect(uWTCPu, less.u1) annotation(
    Line(points = {{-110, 45}, {-97, 45}, {-97, 11}, {-69, 11}, {-69, 3}}, color = {0, 0, 127}));
  connect(firstOrderRampLimit.y, division.u1) annotation(
    Line(points = {{65, -54}, {74, -54}}, color = {0, 0, 127}));
  connect(limiter1.y, division.u2) annotation(
    Line(points = {{11, 85}, {70, 85}, {70, -67}, {74, -67}, {74, -66}}, color = {0, 0, 127}));
  connect(product1.y, firstOrderRampLimit.uMax) annotation(
    Line(points = {{11, 55}, {31, 55}, {31, -45}, {37, -45}}, color = {0, 0, 127}));
  connect(const2.y, firstOrderRampLimit.uMin) annotation(
    Line(points = {{-16, -90}, {30, -90}, {30, -63}, {37, -63}}, color = {0, 0, 127}));
  connect(division.y, ipCmdPu) annotation(
    Line(points = {{97, -60}, {110, -60}}, color = {0, 0, 127}));
  connect(uWTCPu, product.u1) annotation(
    Line(points = {{-110, 45}, {-97, 45}, {-97, -41}, {-52, -41}}, color = {0, 0, 127}));
  connect(product.y, switch1.u1) annotation(
    Line(points = {{-29, -47}, {-15, -47}}, color = {0, 0, 127}));
  connect(booleanConstant.y, and1.u1) annotation(
    Line(points = {{-66, 29}, {-47, 29}, {-47, 20}, {-42, 20}}, color = {255, 0, 255}));
  connect(firstOrder.y, paeroPu) annotation(
    Line(points = {{64, -85}, {111, -85}}, color = {0, 0, 127}));
  connect(and1.y, switch1.u2) annotation(
    Line(points = {{-19, 20}, {-18, 20}, {-18, -55}, {-15, -55}}, color = {255, 0, 255}));
  connect(switch1.y, product2.u1) annotation(
    Line(points = {{8, -55}, {10, -55}, {10, -51}, {16, -51}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, switch1.u3) annotation(
    Line(points = {{-69, -63}, {-15, -63}}, color = {0, 0, 127}));
  connect(pWTRefPu, slewRateLimiter.u) annotation(
    Line(points = {{-110, -63}, {-92, -63}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, product.u2) annotation(
    Line(points = {{-69, -63}, {-60, -63}, {-60, -53}, {-52, -53}, {-52, -53}}, color = {0, 0, 127}));
  connect(product2.y, firstOrderRampLimit.u) annotation(
    Line(points = {{30, -55}, {40, -55}, {40, -54}, {37, -54}}, color = {0, 0, 127}));
  connect(switch1.y, firstOrder.u) annotation(
    Line(points = {{8, -55}, {10, -55}, {10, -85}, {45, -85}}, color = {0, 0, 127}));
  connect(omegaGenPu, product2.u2) annotation(
    Line(points = {{-110, -90}, {-50, -90}, {-50, -75}, {14, -75}, {14, -59}, {16, -59}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -100}, {100, 100}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-9, 32}, extent = {{-83, -19}, {100, 30}}, textString = "IEC WT 4B"), Text(origin = {-11, -34}, extent = {{-77, -16}, {100, 30}}, textString = "PControl")}));

end IECWT4BPControl;
