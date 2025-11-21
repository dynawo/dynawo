within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PControl4A2020 "Active power control module for type 4A wind turbines (IEC N°61400-27-1:2020)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BasePControl4(absLimRateLimFirstOrderAntiWindup.tI = tPOrdP4A, absLimRateLimFirstOrderAntiWindup.DyMax = DPMaxP4APu, absLimRateLimFirstOrderAntiWindup.UseLimits = true);

  //PControl parameters
  parameter Types.PerUnit DPMaxP4APu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMax4APu "Maximum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMin4APu "Minimum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean MpUScale "Voltage scaling for power reference during voltage dip (true: u scaling, false: no scaling)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4A "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPWTRef4A "Reference power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.VoltageModulePu UpDipPu "Voltage threshold to activate voltage scaling for power reference during voltage dip in pu (base UNom)" annotation(
    Dialog(tab = "PControl"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UWTCFiltPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = MpUScale) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderAntiWindup absLimRateLimFirstOrderAntiWindup1(DyMax = DPRefMax4APu, DyMin = DPRefMin4APu, Kaw = 0, UseLimits = false, Y0 = -P0Pu * SystemBase.SnRef / SNom, YMax = 999, tI = tPWTRef4A) annotation(
    Placement(visible = true, transformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(UWTCPu, product1.u2) annotation(
    Line(points = {{-180, 100}, {-20, 100}, {-20, 66}, {-2, 66}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, max1.u2) annotation(
    Line(points = {{-180, 140}, {-80, 140}, {-80, 114}, {58, 114}}, color = {0, 0, 127}));
  connect(less.y, and1.u1) annotation(
    Line(points = {{-78, -40}, {-62, -40}}, color = {255, 0, 255}));
  connect(const1.y, less.u2) annotation(
    Line(points = {{-118, -60}, {-110, -60}, {-110, -48}, {-102, -48}}, color = {0, 0, 127}));
  connect(UWTCPu, less.u1) annotation(
    Line(points = {{-180, 100}, {-150, 100}, {-150, -40}, {-102, -40}}, color = {0, 0, 127}));
  connect(UWTCPu, product.u2) annotation(
    Line(points = {{-180, 100}, {-150, 100}, {-150, -146}, {-62, -146}}, color = {0, 0, 127}));
  connect(and1.y, switch1.u2) annotation(
    Line(points = {{-38, -40}, {-20, -40}, {-20, -100}, {-2, -100}}, color = {255, 0, 255}));
  connect(product.y, switch1.u1) annotation(
    Line(points = {{-38, -140}, {-20, -140}, {-20, -108}, {-2, -108}}, color = {0, 0, 127}));
  connect(booleanConstant.y, and1.u2) annotation(
    Line(points = {{-78, 0}, {-70, 0}, {-70, -32}, {-62, -32}}, color = {255, 0, 255}));
  connect(PWTRefPu, absLimRateLimFirstOrderAntiWindup1.u) annotation(
    Line(points = {{-180, -100}, {-122, -100}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderAntiWindup1.y, product.u1) annotation(
    Line(points = {{-98, -100}, {-80, -100}, {-80, -134}, {-62, -134}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderAntiWindup1.y, switch1.u3) annotation(
    Line(points = {{-98, -100}, {-80, -100}, {-80, -92}, {-2, -92}}, color = {0, 0, 127}));
  connect(switch1.y, absLimRateLimFirstOrderAntiWindup.u) annotation(
    Line(points = {{22, -100}, {78, -100}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {83, 35}, extent = {{-14, 21}, {14, -20}}, textString = "A"), Text(origin = {-1, -16}, extent = {{-54, 26}, {54, -23}}, textString = "2020")}));
end PControl4A2020;
