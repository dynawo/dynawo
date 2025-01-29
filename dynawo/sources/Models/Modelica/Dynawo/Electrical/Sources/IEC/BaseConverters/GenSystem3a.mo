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

model GenSystem3a "Type 3A generator system module (IEC N°61400-27-1)"

  /*
  Equivalent circuit and conventions:

     __   fOCB     iGs
    /__\---/------->-- (terminal)
    \__/--------------

  */

  extends BaseGenSystem3;
  extends Dynawo.Electrical.Wind.IEC.Parameters.GenSystem3a;
  
  Modelica.Blocks.Math.Feedback feedbackP annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Feedback feedbackQ annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorIm(y_start = IGsIm0Pu - UGsRe0Pu / XEqv) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorRe(y_start = IGsRe0Pu + UGsIm0Pu / XEqv) annotation(
    Placement(visible = true, transformation(origin = {50, 60}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Continuous.PI piP(T = TIc, initType = Modelica.Blocks.Types.Init.InitialOutput, k = KPc, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, 61}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Continuous.PI piQ(T = TIc, initType = Modelica.Blocks.Types.Init.InitialOutput, k = KPc, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, -19}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  RefFrameRotation rotationGridToWt(IGsIm0Pu = Q0Pu * SystemBase.SnRef / (SNom * U0Pu), IGsRe0Pu = -P0Pu * SystemBase.SnRef / (SNom * U0Pu), P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, iGsImPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)), iGsRePu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)), ipCmdPu(start = IGsRe0Pu), iqCmdPu(start = IGsIm0Pu), theta(start = -UPhase0)) annotation(
    Placement(visible = true, transformation(origin = {1.02426e-05, 54}, extent = {{-8.00002, -24}, {8.00002, 24}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression theta3(y = -theta) annotation(
    Placement(visible = true, transformation(origin = {0, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(theta3.y, rotationGridToWt.theta) annotation(
    Line(points = {{12, 92}, {18, 92}, {18, 76}, {10, 76}}, color = {0, 0, 127}));
  connect(feedbackP.y, piP.u) annotation(
    Line(points = {{-60, 60}, {-54, 60}, {-54, 61}, {-48, 61}}, color = {0, 0, 127}));
  connect(feedbackQ.y, piQ.u) annotation(
    Line(points = {{-60, -20}, {-54, -20}, {-54, -18}, {-48, -18}}, color = {0, 0, 127}));
  connect(rotationGridToWt.iGsRePu, feedbackP.u2) annotation(
    Line(points = {{-10, 42}, {-18, 42}, {-18, 100}, {-70, 100}, {-70, 68}}, color = {0, 0, 127}));
  connect(piP.y, rotationWtToGrid.ipCmdPu) annotation(
    Line(points = {{-32, 62}, {-22, 62}, {-22, 0}, {-8, 0}}, color = {0, 0, 127}));
  connect(piQ.y, rotationWtToGrid.iqCmdPu) annotation(
    Line(points = {{-32, -18}, {-8, -18}}, color = {0, 0, 127}));
  connect(rotationGridToWt.iGsImPu, feedbackQ.u2) annotation(
    Line(points = {{-10, 66}, {-16, 66}, {-16, -80}, {-70, -80}, {-70, -28}}, color = {0, 0, 127}));
  connect(addXRe.y, rotationGridToWt.ipCmdPu) annotation(
    Line(points = {{90, 54}, {100, 54}, {100, 100}, {22, 100}, {22, 32}, {10, 32}}, color = {0, 0, 127}));
  connect(addXIm.y, rotationGridToWt.iqCmdPu) annotation(
    Line(points = {{90, -34}, {100, -34}, {100, -80}, {18, -80}, {18, 54}, {10, 54}}, color = {0, 0, 127}));
  connect(rotationWtToGrid.iGsRePu, integratorRe.u) annotation(
    Line(points = {{10, -8}, {24, -8}, {24, 60}, {42, 60}}, color = {0, 0, 127}));
  connect(rotationWtToGrid.iGsImPu, integratorIm.u) annotation(
    Line(points = {{10, -30}, {22, -30}, {22, -40}, {42, -40}}, color = {0, 0, 127}));
  connect(integratorRe.y, addXRe.u1) annotation(
    Line(points = {{56, 60}, {66, 60}}, color = {0, 0, 127}));
  connect(integratorIm.y, addXIm.u2) annotation(
    Line(points = {{56, -40}, {66, -40}}, color = {0, 0, 127}));
  connect(ipCmdPu, limitP.u) annotation(
    Line(points = {{-230, 60}, {-142, 60}}, color = {0, 0, 127}));
  connect(iqCmdPu, limitQ.u) annotation(
    Line(points = {{-230, -20}, {-142, -20}}, color = {0, 0, 127}));
  connect(rateLimitP.y, feedbackP.u1) annotation(
    Line(points = {{-88, 60}, {-78, 60}}, color = {0, 0, 127}));
  connect(rateLimitQ.y, feedbackQ.u1) annotation(
    Line(points = {{-88, -20}, {-78, -20}}, color = {0, 0, 127}));
  
  annotation(
    Icon,
    Diagram);
end GenSystem3a;
