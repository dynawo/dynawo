within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PControl4B2020 "Active power control module for type 4B wind turbines (IEC N°61400-27-1:2020)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BasePControl4(absLimRateLimFirstOrderAntiWindup.tI = tPOrdP4B, absLimRateLimFirstOrderAntiWindup.DyMax = DPMaxP4BPu, absLimRateLimFirstOrderAntiWindup.UseLimits = true);

  //Nominal parameter
  extends Dynawo.Electrical.Wind.IEC.Parameters.IntegrationTimeStep;

  //PControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWT4b;
  
  //Input variables
  Modelica.Blocks.Interfaces.RealInput UWTCFiltPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PAeroPu(start = -P0Pu * SystemBase.SnRef / SNom) "Aerodynamic power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = MpUScale) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = UpDipPu) annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tPAero, y_start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {110, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaGenPu(start = SystemBase.omega0Pu) "Generator angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-50, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {50, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DPRefMax4BPu, DuMin = DPRefMin4BPu, Y0 = -P0Pu * SystemBase.SnRef / SNom, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {10, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

equation
  connect(UWTCPu, product1.u2) annotation(
    Line(points = {{-180, 100}, {-20, 100}, {-20, 66}, {-2, 66}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, max.u2) annotation(
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
  connect(switch1.y, product2.u1) annotation(
    Line(points = {{22, -100}, {30, -100}, {30, -106}, {38, -106}}, color = {0, 0, 127}));
  connect(product2.y, absLimRateLimFirstOrderAntiWindup.u) annotation(
    Line(points = {{62, -100}, {78, -100}}, color = {0, 0, 127}));
  connect(omegaGenPu, product2.u2) annotation(
    Line(points = {{-180, 20}, {30, 20}, {30, -94}, {38, -94}}, color = {0, 0, 127}));
  connect(PWTRefPu, rampLimiter.u) annotation(
    Line(points = {{-180, -100}, {-122, -100}}, color = {0, 0, 127}));
  connect(rampLimiter.y, product.u1) annotation(
    Line(points = {{-98, -100}, {-80, -100}, {-80, -134}, {-62, -134}}, color = {0, 0, 127}));
  connect(rampLimiter.y, switch1.u3) annotation(
    Line(points = {{-98, -100}, {-40, -100}, {-40, -92}, {-2, -92}}, color = {0, 0, 127}));
  connect(switch1.y, firstOrder.u) annotation(
    Line(points = {{22, -100}, {30, -100}, {30, -120}, {80, -120}, {80, -140}, {98, -140}}, color = {0, 0, 127}));
  connect(firstOrder.y, PAeroPu) annotation(
    Line(points = {{122, -140}, {170, -140}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {83, 35}, extent = {{-14, 21}, {14, -20}}, textString = "B"), Text(origin = {-1, -16}, extent = {{-54, 26}, {54, -23}}, textString = "2020")}));
end PControl4B2020;
