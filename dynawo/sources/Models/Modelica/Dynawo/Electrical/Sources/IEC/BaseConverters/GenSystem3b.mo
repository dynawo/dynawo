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
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.BaseGenSystem3(rateLimitP.y_start = (IGsRe0Pu + UGsIm0Pu/XEqv)*cos(UPhase0) + (IGsIm0Pu - UGsRe0Pu/XEqv)*sin(UPhase0), rateLimitP.y(start = (IGsRe0Pu + UGsIm0Pu/XEqv)*cos(UPhase0) + (IGsIm0Pu - UGsRe0Pu/XEqv)*sin(UPhase0)), rateLimitQ.y_start = -1*(IGsRe0Pu + UGsIm0Pu/XEqv)*sin(UPhase0) + (IGsIm0Pu - UGsRe0Pu/XEqv)*cos(UPhase0) - (UGsIm0Pu^2 + UGsRe0Pu^2)^0.5/XEqv, rateLimitQ.y(start = -1*(IGsRe0Pu + UGsIm0Pu/XEqv)*sin(UPhase0) + (IGsIm0Pu - UGsRe0Pu/XEqv)*cos(UPhase0) - (UGsIm0Pu^2 + UGsRe0Pu^2)^0.5/XEqv));

  // Control parameters
  parameter Boolean MCrb "Crowbar control mode (true=disable only iq control, false=disable iq and ip control, example value = false)" annotation(
    Dialog(tab = "genSystem"));
  parameter Real tCrb[:, :] = [-99, 0.1; -1, 0.1; -0.1, 0; 0, 0] "Crowbar duration versus voltage variation look-up table, for example [-99,0.1; -1,0.1; -0.1,0; 0,0]" annotation(
    Dialog(tab = "genSystem"));
  parameter Types.Time tG "Current generation time constant, example value = 0.01" annotation(
    Dialog(tab = "genSystem"));
  parameter Types.Time tWo "Time constant for crowbar washout filter, example value = 0.001" annotation(
    Dialog(tab = "genSystem"));

  Modelica.Blocks.Math.Add add1 annotation(
    Placement(transformation(origin = {-76, 270}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addXEqv(k2 = 1/XEqv) annotation(
    Placement(transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToAbs annotation(
    Placement(transformation(origin = {10, 154}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant constant1(k = 1e-6) annotation(
    Placement(transformation(origin = {-110, 240}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant constMCrb(k = MCrb) annotation(
    Placement(transformation(origin = {-220, 140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constOne(k = 1) annotation(
    Placement(transformation(origin = {-220, 109}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.BooleanToReal crowbarFlag annotation(
    Placement(transformation(origin = {110, 300}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.FixedDelay delay(delayTime = 1e-6) annotation(
    Placement(transformation(origin = {-110, 280}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.FixedDelay delay2(delayTime = 1e-6) annotation(
    Placement(transformation(origin = {-10, 190}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(transformation(origin = {-50, 300}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation(
    Placement(transformation(origin = {70, 300}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder lagTgP(T = tG, y_start = IGsRe0Pu + UGsIm0Pu/XEqv) annotation(
    Placement(visible = true, transformation(origin = {44, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagTgQ(T = tG, y_start = IGsIm0Pu - UGsRe0Pu/XEqv) annotation(
    Placement(visible = true, transformation(origin = {42, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D lutTCrb(table = tCrb) annotation(
    Placement(transformation(origin = {-150, 300}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(transformation(origin = {-10, 300}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product prodCrowbarP annotation(
    Placement(transformation(origin = {-170, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product prodCrowbarQ annotation(
    Placement(visible = true, transformation(origin = {-180, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(transformation(origin = {-10, 220}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Logical.Switch switchMCrb annotation(
    Placement(transformation(origin = {-170, 140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(transformation(origin = {30, 300}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Derivative washoutFilter(T = tWo, k = tWo) annotation(
    Placement(transformation(origin = {-190, 300}, extent = {{-10, -10}, {10, 10}})));

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
    Line(points = {{22, 154}, {162, 154}, {162, 34}, {166, 34}}, color = {85, 170, 255}));
  connect(prodCrowbarQ.y, limitQ.u) annotation(
    Line(points = {{-168, -20}, {-142, -20}}, color = {0, 0, 127}));
  connect(prodCrowbarP.y, limitP.u) annotation(
    Line(points = {{-159, 60}, {-142, 60}}, color = {0, 0, 127}));
  connect(switchMCrb.y, prodCrowbarP.u1) annotation(
    Line(points = {{-159, 140}, {-150, 140}, {-150, 100}, {-189, 100}, {-189, 66}, {-182, 66}}, color = {0, 0, 127}));
  connect(constOne.y, switchMCrb.u3) annotation(
    Line(points = {{-209, 109}, {-194.5, 109}, {-194.5, 132}, {-182, 132}}, color = {0, 0, 127}));
  connect(constMCrb.y, switchMCrb.u2) annotation(
    Line(points = {{-209, 140}, {-182, 140}}, color = {255, 0, 255}));
  connect(washoutFilter.y, lutTCrb.u[1]) annotation(
    Line(points = {{-179, 300}, {-162, 300}}, color = {0, 0, 127}));
  connect(delay.y, add1.u1) annotation(
    Line(points = {{-99, 280}, {-91.5, 280}, {-91.5, 276}, {-88, 276}}, color = {0, 0, 127}));
  connect(constant1.y, add1.u2) annotation(
    Line(points = {{-99, 240}, {-93.5, 240}, {-93.5, 264}, {-88, 264}, {-88, 264}}, color = {0, 0, 127}));
  connect(lutTCrb.y[1], greater.u1) annotation(
    Line(points = {{-139, 300}, {-62, 300}}, color = {0, 0, 127}));
  connect(add1.y, greater.u2) annotation(
    Line(points = {{-65, 270}, {-62.75, 270}, {-62.75, 292}, {-62, 292}}, color = {0, 0, 127}));
  connect(lutTCrb.y[1], switch.u1) annotation(
    Line(points = {{-139, 300}, {-132, 300}, {-132, 229}, {-23, 229}}, color = {0, 0, 127}));
  connect(delay2.y, switch.u3) annotation(
    Line(points = {{-21, 190}, {-40, 190}, {-40, 211}, {-23, 211}}, color = {0, 0, 127}));
  connect(greater.y, switch.u2) annotation(
    Line(points = {{-39, 300}, {-30, 300}, {-30, 220}, {-23, 220}}, color = {255, 0, 255}));
  connect(greater.y, not1.u) annotation(
    Line(points = {{-39, 300}, {-22, 300}}, color = {255, 0, 255}));
  connect(not1.y, timer.u) annotation(
    Line(points = {{1, 300}, {18, 300}}, color = {255, 0, 255}));
  connect(switch.y, greaterEqual.u2) annotation(
    Line(points = {{2, 220}, {48, 220}, {48, 292}, {58, 292}}, color = {0, 0, 127}));
  connect(timer.y, greaterEqual.u1) annotation(
    Line(points = {{41, 300}, {58, 300}}, color = {0, 0, 127}));
  connect(greaterEqual.y, crowbarFlag.u) annotation(
    Line(points = {{81, 300}, {98, 300}}, color = {255, 0, 255}));
  connect(crowbarFlag.y, prodCrowbarQ.u1) annotation(
    Line(points = {{121, 300}, {140, 300}, {140, 170}, {-200, 170}, {-200, -14}, {-192, -14}}, color = {0, 0, 127}));
  connect(crowbarFlag.y, switchMCrb.u1) annotation(
    Line(points = {{121, 300}, {140, 300}, {140, 170}, {-200, 170}, {-200, 148}, {-182, 148}}, color = {0, 0, 127}));
  connect(lagTgQ.y, addXIm.u2) annotation(
    Line(points = {{54, -40}, {66, -40}}, color = {0, 0, 127}));
  connect(rateLimitQ.y, addXEqv.u1) annotation(
    Line(points = {{-88, -20}, {-74, -20}, {-74, -14}, {-62, -14}}, color = {0, 0, 127}));
  connect(addXEqv.y, rotationWtToGrid.iqCmdPu) annotation(
    Line(points = {{-39, -20}, {-18, -20}, {-18, -18}, {-8, -18}}, color = {0, 0, 127}));
  connect(complexToAbs.len, addXEqv.u2) annotation(
    Line(points = {{-2, 160}, {-238, 160}, {-238, -60}, {-71, -60}, {-71, -26}, {-62, -26}}, color = {0, 0, 127}));
  connect(complexToAbs.len, washoutFilter.u) annotation(
    Line(points = {{-2, 160}, {-238, 160}, {-238, 300}, {-202, 300}}, color = {0, 0, 127}));
  connect(iqCmdPu, prodCrowbarQ.u2) annotation(
    Line(points = {{-250, -20}, {-200, -20}, {-200, -26}, {-192, -26}}, color = {0, 0, 127}));
  connect(ipCmdPu, prodCrowbarP.u2) annotation(
    Line(points = {{-250, 60}, {-194, 60}, {-194, 54}, {-182, 54}}, color = {0, 0, 127}));
  connect(lutTCrb.y[1], delay.u) annotation(
    Line(points = {{-138, 300}, {-132, 300}, {-132, 280}, {-122, 280}}, color = {0, 0, 127}));
  connect(switch.y, delay2.u) annotation(
    Line(points = {{2, 220}, {48, 220}, {48, 190}, {2, 190}}, color = {0, 0, 127}));

  annotation(
    Diagram(graphics = {Rectangle(origin = {-80, 273}, lineColor = {23, 156, 125}, lineThickness = 1, extent = {{-48, 43}, {48, -43}}), Text(origin = {-55, 249}, textColor = {23, 156, 125}, extent = {{21, -7}, {-21, 7}}, textString = "rising value
detection")}));
end GenSystem3b;
