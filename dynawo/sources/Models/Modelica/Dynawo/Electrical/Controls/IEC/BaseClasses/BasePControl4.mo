within Dynawo.Electrical.Controls.IEC.BaseClasses;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

partial model BasePControl4 "Base active power control module for type 4 wind turbines (IEC N°61400-27-1)"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //PControl parameters
  parameter Types.PerUnit Kpaw "Anti-windup gain for the integrator of the ramp-limited first order in pu/s (base SNom)" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean MpUScale "Voltage scaling for power reference during voltage dip (true: u scaling, false: no scaling)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.VoltageModulePu UpDipPu "Voltage threshold to activate voltage scaling for power reference during voltage dip in pu (base UNom)" annotation(
    Dialog(tab = "PControl"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UWTCFiltPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTRefPu(start = -P0Pu * SystemBase.SnRef / SNom ) "Active power reference at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {10, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-50, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = UpDipPu) annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {130, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = MpUScale) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {70, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0.01) annotation(
    Placement(visible = true, transformation(origin = {10, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderAntiWindup absLimRateLimFirstOrderAntiWindup(DyMin = -999, Kaw = Kpaw, UseLimits = true, Y0 = -P0Pu * SystemBase.SnRef / SNom, YMax = 999) annotation(
    Placement(visible = true, transformation(origin = {90, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = -999) annotation(
    Placement(visible = true, transformation(origin = {10, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit IpMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(const.y, max.u1) annotation(
    Line(points = {{21, 140}, {40, 140}, {40, 126}, {58, 126}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, max.u2) annotation(
    Line(points = {{-180, 140}, {-80, 140}, {-80, 114}, {58, 114}}, color = {0, 0, 127}));
  connect(const1.y, less.u2) annotation(
    Line(points = {{-119, -60}, {-111, -60}, {-111, -48}, {-103, -48}}, color = {0, 0, 127}));
  connect(division.y, ipCmdPu) annotation(
    Line(points = {{142, -100}, {170, -100}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderAntiWindup.y, division.u1) annotation(
    Line(points = {{102, -100}, {110, -100}, {110, -106}, {118, -106}}, color = {0, 0, 127}));
  connect(max.y, division.u2) annotation(
    Line(points = {{82, 120}, {110, 120}, {110, -94}, {118, -94}}, color = {0, 0, 127}));
  connect(ipMaxPu, product1.u1) annotation(
    Line(points = {{-180, 60}, {-20, 60}, {-20, 54}, {-2, 54}}, color = {0, 0, 127}));
  connect(UWTCPu, product1.u2) annotation(
    Line(points = {{-180, 100}, {-20, 100}, {-20, 66}, {-2, 66}}, color = {0, 0, 127}));
  connect(product1.y, absLimRateLimFirstOrderAntiWindup.yMax) annotation(
    Line(points = {{22, 60}, {70, 60}, {70, -94}, {78, -94}}, color = {0, 0, 127}));
  connect(product.y, switch1.u1) annotation(
    Line(points = {{-38, -140}, {-20, -140}, {-20, -108}, {-2, -108}}, color = {0, 0, 127}));
  connect(UWTCPu, product.u2) annotation(
    Line(points = {{-180, 100}, {-150, 100}, {-150, -146}, {-62, -146}}, color = {0, 0, 127}));
  connect(UWTCPu, less.u1) annotation(
    Line(points = {{-180, 100}, {-150, 100}, {-150, -40}, {-102, -40}}, color = {0, 0, 127}));
  connect(and1.y, switch1.u2) annotation(
    Line(points = {{-38, -40}, {-20, -40}, {-20, -100}, {-2, -100}}, color = {255, 0, 255}));
  connect(less.y, and1.u1) annotation(
    Line(points = {{-78, -40}, {-62, -40}}, color = {255, 0, 255}));
  connect(booleanConstant.y, and1.u2) annotation(
    Line(points = {{-78, 0}, {-70, 0}, {-70, -32}, {-62, -32}}, color = {255, 0, 255}));
  connect(const2.y, absLimRateLimFirstOrderAntiWindup.yMin) annotation(
    Line(points = {{21, -140}, {70, -140}, {70, -106}, {78, -106}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-16, 31}, extent = {{-76, -18}, {92, 28}}, textString = "IEC WT 4"), Text(origin = {-11, -34}, extent = {{-77, -16}, {100, 30}}, textString = "PControl")}),
  Diagram(coordinateSystem(extent = {{-160, -160}, {160, 160}})));
end BasePControl4;
