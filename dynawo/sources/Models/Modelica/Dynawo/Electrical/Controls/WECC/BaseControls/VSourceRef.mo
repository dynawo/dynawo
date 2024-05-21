within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model VSourceRef

/*                uSourcePu                                uInjPu                      uPu
     --------         |                                       |                         |
    | Source |--------+---->>--------RSourcePu+jXSourcePu-----+------RPu+jXPu-----<<----+---- terminal
     --------           iSourcePu                                                 iPu
*/
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsVSourceRef;

  Modelica.Blocks.Interfaces.RealInput idPu(start = Id0Pu) "d-axis current in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uInjPu(re(start = uInj0Pu.re), im(start = uInj0Pu.im)) "Complex voltage at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-126, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPu(start = Iq0Pu) "q-axis current in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput uiSourcePu(start = uSource0Pu.im) "Imaginary voltage at source in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -39}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput urSourcePu(start = uSource0Pu.re) "Real voltage at source in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.WECC.BaseControls.UdqRef udqRef(RSourcePu = RSourcePu, XSourcePu = XSourcePu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, UdInj0Pu = UdInj0Pu, UqInj0Pu = UqInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 7}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(visible = true, transformation(origin = {-44, -1}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tE, k = 1, y_start = UdInj0Pu + Id0Pu * RSourcePu - Iq0Pu * XSourcePu) annotation(
    Placement(visible = true, transformation(origin = {40, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tE, k = 1, y_start = UqInj0Pu + Iq0Pu * RSourcePu + Id0Pu * XSourcePu) annotation(
    Placement(visible = true, transformation(origin = {40, 3}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = 30, Kp = 10, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-90, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Id0Pu "Start value of d-axis current in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of q-axis current in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage injector in pu (base UNom)";
  parameter Types.ComplexVoltagePu uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage injector in pu (base UNom)";
  parameter Types.ComplexVoltagePu uSource0Pu "Start value of complex voltage at source in pu (base UNom)";

equation
  connect(OmegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-119, -40}, {-101, -40}}, color = {0, 0, 127}));
  connect(firstOrder1.y, transformDQtoRI.uqPu) annotation(
    Line(points = {{51, 3}, {79, 3}}, color = {0, 0, 127}));
  connect(udqRef.udSourceRefPu, firstOrder.u) annotation(
    Line(points = {{11, 11}, {20, 11}, {20, 40}, {28, 40}}, color = {0, 0, 127}));
  connect(udqRef.uqSourceRefPu, firstOrder1.u) annotation(
    Line(points = {{11, 3}, {28, 3}}, color = {0, 0, 127}));
  connect(transformRItoDQ.udPu, udqRef.udInjPu) annotation(
    Line(points = {{-33, 5}, {-23.5, 5}, {-23.5, 4}, {-11, 4}}, color = {0, 0, 127}));
  connect(uInjPu, transformRItoDQ.uPu) annotation(
    Line(points = {{-126, 4}, {-94, 4}, {-94, 5}, {-55, 5}}, color = {85, 170, 255}));
  connect(idPu, udqRef.idRefPu) annotation(
    Line(points = {{-130, 60}, {-20, 60}, {-20, 15}, {-11, 15}}, color = {0, 0, 127}));
  connect(iqPu, udqRef.iqRefPu) annotation(
    Line(points = {{-130, 30}, {-30, 30}, {-30, 10}, {-11, 10}}, color = {0, 0, 127}));
  connect(uInjPu, pll.uPu) annotation(
    Line(points = {{-126, 4}, {-110, 4}, {-110, -28}, {-101, -28}}, color = {85, 170, 255}));
  connect(transformDQtoRI.urPu, urSourcePu) annotation(
    Line(points = {{101, 6}, {110, 6}, {110, 20}, {130, 20}}, color = {0, 0, 127}));
  connect(transformDQtoRI.uiPu, uiSourcePu) annotation(
    Line(points = {{101, -6}, {110, -6}, {110, -20}, {130, -20}}, color = {0, 0, 127}));
  connect(firstOrder.y, transformDQtoRI.udPu) annotation(
    Line(points = {{51, 40}, {70, 40}, {70, 7}, {79, 7}}, color = {0, 0, 127}));
  connect(transformRItoDQ.uqPu, udqRef.uqInjPu) annotation(
    Line(points = {{-33, -7}, {-20, -7}, {-20, -1}, {-11, -1}}, color = {0, 0, 127}));
  connect(pll.phi, transformRItoDQ.phi) annotation(
    Line(points = {{-79, -33}, {-55, -33}, {-55, -7}}, color = {0, 0, 127}));
  connect(pll.phi, transformDQtoRI.phi) annotation(
    Line(points = {{-79, -33}, {70, -33}, {70, -6}, {79, -6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 4}, extent = {{-82, 76}, {78, -84}}, textString = "VSourceRef"), Text(origin = {8.20588, -101.625}, extent = {{3.79412, -3.375}, {46.7941, -21.375}}, textString = "uInjPu"), Text(origin = {-121.5, 59}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "iqPu"), Text(origin = {-121.5, -42}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "idPu"), Text(origin = {127, 67.3045}, extent = {{-19, 12.6955}, {57, -36.3045}}, textString = "urSourcePu"), Text(origin = {127, -12.7}, extent = {{-19, 12.7}, {57, -36.3}}, textString = "uiSourcePu")}, coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {1, 1})),
    Diagram(coordinateSystem(extent = {{-150, 70}, {150, -60}}, grid = {1, 1})));
end VSourceRef;