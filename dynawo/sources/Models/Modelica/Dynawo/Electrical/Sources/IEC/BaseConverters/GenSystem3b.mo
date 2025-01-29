within Dynawo.Electrical.Sources.IEC.BaseConverters;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GenSystem3b "Type 3B generator system module (IEC N°61400-27-1)"

  /*
  Equivalent circuit and conventions:

     __   fOCB     iGs
    /__\---/------->-- (terminal)
    \__/--------------

  */

  extends BaseGenSystem3(
    rateLimitP.y_start=(IGsRe0Pu+UGsIm0Pu/XEqv)*cos(UPhase0) + (IGsIm0Pu-UGsRe0Pu/XEqv)*sin(UPhase0),
    rateLimitQ.y_start=-1*(IGsRe0Pu+UGsIm0Pu/XEqv)*sin(UPhase0) + (IGsIm0Pu-UGsRe0Pu/XEqv)*cos(UPhase0) - (UGsIm0Pu^2+UGsRe0Pu^2)^0.5/XEqv
  );
  extends Dynawo.Electrical.Wind.IEC.Parameters.GenSystem3b;

  Modelica.Blocks.Sources.RealExpression absU(y = complexToAbs.len) annotation(
    Placement(visible = true, transformation(origin = {-148, -58}, extent = {{-6, -10}, {6, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression absU2(y = complexToAbs.len) annotation(
    Placement(visible = true, transformation(origin = {-210, 300}, extent = {{-6, -10}, {6, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-69, 287}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Math.Add addXEqv(k2 = 1 / XEqv)  annotation(
    Placement(visible = true, transformation(origin = {-62, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToAbs annotation(
    Placement(visible = true, transformation(origin = {0, 130}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 1e-6) annotation(
    Placement(visible = true, transformation(origin = {-89, 271}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant constMCrb(k = MCrb) annotation(
    Placement(visible = true, transformation(origin = {-189, 119}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constOne(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-189, 94}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToReal crowbarFlag annotation(
    Placement(visible = true, transformation(origin = {110, 290}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay delay(delayTime = 1e-6) annotation(
    Placement(visible = true, transformation(origin = {-98, 290}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay delay2(delayTime = 1e-6) annotation(
    Placement(visible = true, transformation(origin = {-8, 222}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {-46, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation(
    Placement(visible = true, transformation(origin = {66, 298}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagTgP(T = tG, y_start = IGsRe0Pu + UGsIm0Pu / XEqv)  annotation(
    Placement(visible = true, transformation(origin = {44, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagTgQ(T = tG, y_start = IGsIm0Pu - UGsRe0Pu / XEqv)  annotation(
    Placement(visible = true, transformation(origin = {42, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D lutTCrb(table = tCrb) annotation(
    Placement(visible = true, transformation(origin = {-140, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {-14, 300}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Product prodCrowbarP annotation(
    Placement(visible = true, transformation(origin = {-180, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product prodCrowbarQ annotation(
    Placement(visible = true, transformation(origin = {-180, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-8, 250}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchMCrb annotation(
    Placement(visible = true, transformation(origin = {-169, 103}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {16, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative washoutFilter(T = tWo, k = tWo) annotation(
    Placement(visible = true, transformation(origin = {-180, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(rateLimitP.y, rotationWtToGrid.ipCmdPu) annotation(
    Line(points = {{-88, 60}, {-20, 60}, {-20, 0}, {-8, 0}}, color = {0, 0, 127}));
  connect(rotationWtToGrid.iGsRePu, lagTgP.u) annotation(
    Line(points = {{10, -8}, {18, -8}, {18, 60}, {32, 60}}, color = {0, 0, 127}));
  connect(rotationWtToGrid.iGsImPu, lagTgQ.u) annotation(
    Line(points = {{10, -30}, {18, -30}, {18, -40}, {30, -40}}, color = {0, 0, 127}));
  connect(lagTgP.y, addXRe.u1) annotation(
    Line(points = {{56, 60}, {66, 60}}, color = {0, 0, 127}));
  connect(complexToAbs.u, uGs2.y) annotation(
    Line(points = {{12, 130}, {162, 130}, {162, 34}, {166, 34}}, color = {85, 170, 255}));
  connect(prodCrowbarQ.y, limitQ.u) annotation(
    Line(points = {{-168, -20}, {-142, -20}}, color = {0, 0, 127}));
  connect(iqCmdPu, prodCrowbarQ.u2) annotation(
    Line(points = {{-230, -20}, {-206, -20}, {-206, -26}, {-192, -26}}, color = {0, 0, 127}));
  connect(prodCrowbarP.y, limitP.u) annotation(
    Line(points = {{-168, 60}, {-142, 60}}, color = {0, 0, 127}));
  connect(ipCmdPu, prodCrowbarP.u2) annotation(
    Line(points = {{-230, 60}, {-210, 60}, {-210, 54}, {-192, 54}}, color = {0, 0, 127}));
  connect(switchMCrb.y, prodCrowbarP.u1) annotation(
    Line(points = {{-162, 104}, {-156, 104}, {-156, 74}, {-196, 74}, {-196, 66}, {-192, 66}}, color = {0, 0, 127}));
  connect(constOne.y, switchMCrb.u3) annotation(
    Line(points = {{-184, 94}, {-180, 94}, {-180, 98}, {-178, 98}}, color = {0, 0, 127}));
  connect(constMCrb.y, switchMCrb.u2) annotation(
    Line(points = {{-184, 120}, {-182, 120}, {-182, 104}, {-178, 104}}, color = {255, 0, 255}));
  connect(absU2.y, washoutFilter.u) annotation(
    Line(points = {{-204, 300}, {-192, 300}}, color = {0, 0, 127}));
  connect(washoutFilter.y, lutTCrb.u[1]) annotation(
    Line(points = {{-168, 300}, {-152, 300}}, color = {0, 0, 127}));
  connect(lutTCrb.y[1], delay.u) annotation(
    Line(points = {{-128, 300}, {-114, 300}, {-114, 290}, {-106, 290}}, color = {0, 0, 127}));
  connect(delay.y, add1.u1) annotation(
    Line(points = {{-92, 290}, {-78, 290}, {-78, 292}}, color = {0, 0, 127}));
  connect(constant1.y, add1.u2) annotation(
    Line(points = {{-84, 272}, {-82, 272}, {-82, 282}, {-78, 282}}, color = {0, 0, 127}));
  connect(lutTCrb.y[1], greater.u1) annotation(
    Line(points = {{-128, 300}, {-58, 300}}, color = {0, 0, 127}));
  connect(add1.y, greater.u2) annotation(
    Line(points = {{-62, 288}, {-58, 288}, {-58, 292}}, color = {0, 0, 127}));
  connect(lutTCrb.y[1], switch.u1) annotation(
    Line(points = {{-128, 300}, {-124, 300}, {-124, 256}, {-16, 256}}, color = {0, 0, 127}));
  connect(switch.y, delay2.u) annotation(
    Line(points = {{0, 250}, {14, 250}, {14, 222}, {0, 222}}, color = {0, 0, 127}));
  connect(delay2.y, switch.u3) annotation(
    Line(points = {{-14, 222}, {-26, 222}, {-26, 244}, {-16, 244}}, color = {0, 0, 127}));
  connect(greater.y, switch.u2) annotation(
    Line(points = {{-34, 300}, {-30, 300}, {-30, 250}, {-16, 250}}, color = {255, 0, 255}));
  connect(greater.y, not1.u) annotation(
    Line(points = {{-34, 300}, {-22, 300}}, color = {255, 0, 255}));
  connect(not1.y, timer.u) annotation(
    Line(points = {{-8, 300}, {4, 300}}, color = {255, 0, 255}));
  connect(switch.y, greaterEqual.u2) annotation(
    Line(points = {{0, 250}, {38, 250}, {38, 290}, {54, 290}}, color = {0, 0, 127}));
  connect(timer.y, greaterEqual.u1) annotation(
    Line(points = {{28, 300}, {42, 300}, {42, 298}, {54, 298}}, color = {0, 0, 127}));
  connect(greaterEqual.y, crowbarFlag.u) annotation(
    Line(points = {{78, 298}, {84, 298}, {84, 290}, {98, 290}}, color = {255, 0, 255}));
  connect(crowbarFlag.y, prodCrowbarQ.u1) annotation(
    Line(points = {{122, 290}, {140, 290}, {140, 180}, {-200, 180}, {-200, -14}, {-192, -14}}, color = {0, 0, 127}));
  connect(crowbarFlag.y, switchMCrb.u1) annotation(
    Line(points = {{122, 290}, {140, 290}, {140, 180}, {-200, 180}, {-200, 108}, {-178, 108}}, color = {0, 0, 127}));
  connect(lagTgQ.y, addXIm.u2) annotation(
    Line(points = {{54, -40}, {66, -40}}, color = {0, 0, 127}));
  connect(rateLimitQ.y, addXEqv.u1) annotation(
    Line(points = {{-88, -20}, {-84, -20}, {-84, -14}, {-74, -14}}, color = {0, 0, 127}));
  connect(addXEqv.y, rotationWtToGrid.iqCmdPu) annotation(
    Line(points = {{-50, -20}, {-40, -20}, {-40, -40}, {-18, -40}, {-18, -18}, {-8, -18}}, color = {0, 0, 127}));
  connect(absU.y, addXEqv.u2) annotation(
    Line(points = {{-142, -58}, {-84, -58}, {-84, -26}, {-74, -26}}, color = {0, 0, 127}));
  
  annotation(
    Diagram(graphics = {Rectangle(origin = {-76, 289}, lineColor = {23, 156, 125}, lineThickness = 1, extent = {{-44, 29}, {44, -29}}), Text(origin = {-44, 267}, lineColor = {23, 156, 125}, extent = {{10, -7}, {-10, 7}}, textString = "rising value
detection")}));
end GenSystem3b;
