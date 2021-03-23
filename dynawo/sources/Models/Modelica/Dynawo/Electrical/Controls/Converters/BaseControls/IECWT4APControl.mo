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
  parameter Types.Time TpOrdp4A "Time constant in power order lag in seconds" annotation(
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

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start = -P0Pu*SystemBase.SnRef / (SNom * U0Pu)) "Active current command to generator system in pu (base UNom, SNom) (generator convention)" annotation(
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
  Modelica.Blocks.Sources.Constant const1(k = UpDip) annotation(
    Placement(visible = true, transformation(origin = {-75, -5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {0, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = 999, uMin = 0.01)  annotation(
    Placement(visible = true, transformation(origin = {0, 85}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = 0) annotation(
    Placement(visible = true, transformation(origin = {15, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {85, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRampLimit firstOrderRampLimit(DuMax = DpMaxp4A, DuMin = -999, GainAW = 1000, T = TpOrdp4A, k = 1, y_start = -P0Pu*SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {50, -55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRamp firstOrderRamp(DuMax = DpRefMax4A, DuMin = DpRefMin4A, T = TpWTRef4A, k = 1, y_start = -P0Pu*SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {-74, -63}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = MpUScale)  annotation(
    Placement(visible = true, transformation(origin = {-74, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

  connect(uWTCfiltPu, limiter1.u) annotation(
    Line(points = {{-110, 85}, {-13, 85}, {-13, 85}, {-12, 85}}, color = {0, 0, 127}));
  connect(ipMaxPu, product1.u1) annotation(
    Line(points = {{-110, 65}, {-32, 65}, {-32, 61}, {-12, 61}, {-12, 61}}, color = {0, 0, 127}));
  connect(uWTCPu, product1.u2) annotation(
    Line(points = {{-110, 45}, {-32, 45}, {-32, 49}, {-12, 49}, {-12, 49}}, color = {0, 0, 127}));
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
  connect(switch1.y, firstOrderRampLimit.u) annotation(
    Line(points = {{26, -55}, {36, -55}, {36, -55}, {36, -55}}, color = {0, 0, 127}));
  connect(const2.y, firstOrderRampLimit.uMin) annotation(
    Line(points = {{26, -84}, {30, -84}, {30, -64}, {36, -64}}, color = {0, 0, 127}));
  connect(and1.y, switch1.u2) annotation(
    Line(points = {{-4, 20}, {-2, 20}, {-2, -56}, {3, -56}, {3, -55}}, color = {255, 0, 255}));
  connect(division.y, ipCmdPu) annotation(
    Line(points = {{96, -60}, {103, -60}, {103, -60}, {110, -60}}, color = {0, 0, 127}));
  connect(firstOrderRamp.y, switch1.u3) annotation(
    Line(points = {{-60, -63}, {3, -63}}, color = {0, 0, 127}));
  connect(pWTRefPu, firstOrderRamp.u) annotation(
    Line(points = {{-110, -63}, {-88, -63}}, color = {0, 0, 127}));
  connect(uWTCPu, product.u1) annotation(
    Line(points = {{-110, 45}, {-97, 45}, {-97, -28}, {-42, -28}, {-42, -29}}, color = {0, 0, 127}));
  connect(firstOrderRamp.y, product.u2) annotation(
    Line(points = {{-60, -63}, {-52, -63}, {-52, -41}, {-42, -41}}, color = {0, 0, 127}));
  connect(product.y, switch1.u1) annotation(
    Line(points = {{-19, -35}, {-12, -35}, {-12, -47}, {3, -47}, {3, -47}}, color = {0, 0, 127}));
  connect(booleanConstant.y, and1.u1) annotation(
    Line(points = {{-63, 28}, {-47, 28}, {-47, 21}, {-27, 21}, {-27, 20}}, color = {255, 0, 255}));
  connect(product1.y, firstOrderRampLimit.uMax) annotation(
    Line(points = {{11, 55}, {31, 55}, {31, -46}, {36, -46}, {36, -46}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -100}, {100, 100}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-9, 32}, extent = {{-83, -19}, {100, 30}}, textString = "IEC WT 4A"), Text(origin = {-11, -34}, extent = {{-77, -16}, {100, 30}}, textString = "PControl")}));

end IECWT4APControl;
