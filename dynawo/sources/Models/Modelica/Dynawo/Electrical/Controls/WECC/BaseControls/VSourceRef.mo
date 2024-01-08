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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model VSourceRef

/*                uSourcePu                                uInjPu                      uPu
     --------         |                                       |                         |
    | Source |--------+---->>--------RSourcePu+jXSourcePu-----+------RPu+jXPu-----<<----+---- terminal
     --------           iSourcePu                                                 iPu
*/

  //Source parameters
  parameter Types.Time tE "Emulated delay in converter controls in s (cannot be zero, typical: 0.02..0.05)";
  parameter Types.PerUnit RSourcePu "Source resistance in pu (base SNom, UNom)";
  parameter Types.PerUnit XSourcePu "Source reactance in pu (base SNom, UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput idPu(start = Id0Pu) "d-axis current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPu(start = Iq0Pu) "q-axis current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uInjPu(re(start = uInj0Pu.re), im(start = uInj0Pu.im)) "Complex voltage at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput uImSourcePu(start = uSource0Pu.im) "Imaginary part of the voltage at source in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {210, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uReSourcePu(start = uSource0Pu.re) "Real part of the voltage at source in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {210, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.WECC.BaseControls.UdqRef udqRef(RSourcePu = RSourcePu, XSourcePu = XSourcePu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, UdInj0Pu = UdInj0Pu, UqInj0Pu = UqInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tE, k = 1, y_start = UdInj0Pu + Id0Pu * RSourcePu - Iq0Pu * XSourcePu) annotation(
    Placement(visible = true, transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tE, k = 1, y_start = UqInj0Pu + Iq0Pu * RSourcePu + Id0Pu * XSourcePu) annotation(
    Placement(visible = true, transformation(origin = {70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = 30, Kp = 10, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-140, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-210, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit Id0Pu "Start value of d-axis current at injector in pu (base SNom, UNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of q-axis current at injector in pu (base SNom, UNom) (generator convention)";
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage at injector in pu (base UNom)";
  parameter Types.ComplexVoltagePu uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage at injector in pu (base UNom)";
  parameter Types.ComplexVoltagePu uSource0Pu "Start value of complex voltage at source in pu (base UNom)";

equation
  connect(transformDQtoRI.xImPu, uImSourcePu) annotation(
    Line(points = {{162, -12}, {180, -12}, {180, -40}, {210, -40}}, color = {0, 0, 127}));
  connect(transformDQtoRI.xRePu, uReSourcePu) annotation(
    Line(points = {{162, 12}, {180, 12}, {180, 40}, {210, 40}}, color = {0, 0, 127}));
  connect(OmegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-198, -80}, {-180, -80}, {-180, -72}, {-162, -72}}, color = {0, 0, 127}));
  connect(uInjPu, pll.uPu) annotation(
    Line(points = {{-210, 0}, {-180, 0}, {-180, -48}, {-162, -48}}, color = {85, 170, 255}));
  connect(transformRItoDQ.xdPu, udqRef.udInjPu) annotation(
    Line(points = {{-58, 12}, {-22, 12}}, color = {0, 0, 127}));
  connect(transformRItoDQ.xqPu, udqRef.uqInjPu) annotation(
    Line(points = {{-58, -12}, {-22, -12}}, color = {0, 0, 127}));
  connect(iqPu, udqRef.iqRefPu) annotation(
    Line(points = {{-210, 40}, {-8, 40}, {-8, 22}}, color = {0, 0, 127}));
  connect(idPu, udqRef.idRefPu) annotation(
    Line(points = {{-210, 80}, {8, 80}, {8, 22}}, color = {0, 0, 127}));
  connect(udqRef.udSourceRefPu, firstOrder.u) annotation(
    Line(points = {{22, 12}, {40, 12}, {40, 20}, {58, 20}}, color = {0, 0, 127}));
  connect(udqRef.uqSourceRefPu, firstOrder1.u) annotation(
    Line(points = {{22, -12}, {40, -12}, {40, -20}, {58, -20}}, color = {0, 0, 127}));
  connect(uInjPu, transformRItoDQ.xPu) annotation(
    Line(points = {{-210, 0}, {-102, 0}}, color = {85, 170, 255}));
  connect(firstOrder1.y, transformDQtoRI.xqPu) annotation(
    Line(points = {{82, -20}, {100, -20}, {100, -12}, {118, -12}}, color = {0, 0, 127}));
  connect(firstOrder.y, transformDQtoRI.xdPu) annotation(
    Line(points = {{82, 20}, {100, 20}, {100, 12}, {118, 12}}, color = {0, 0, 127}));
  connect(pll.phi, transformRItoDQ.phi) annotation(
    Line(points = {{-118, -48}, {-80, -48}, {-80, -22}}, color = {0, 0, 127}));
  connect(pll.phi, transformDQtoRI.phi) annotation(
    Line(points = {{-118, -48}, {140, -48}, {140, -22}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the converter part of the WECC model according to the WECC document Modeling Updates 021623 Rev27 (page 12) : <a href='https://www.wecc.org/_layouts/15/WopiFrame.aspx?sourcedoc=/Reliability/Memo_RES_Modeling_Updates_021623_Rev27_Clean.pdf'>https://www.wecc.org/_layouts/15/WopiFrame.aspx?sourcedoc=/Reliability/Memo_RES_Modeling_Updates_021623_Rev27_Clean.pdf </a> </p>
    <img src=\"modelica://Dynawo/Electrical/Controls/WECC/Images/VSourceRef.png\" alt=\"Voltage source reference\">
    </html>"),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 4}, extent = {{-82, 76}, {78, -84}}, textString = "VSourceRef"), Text(origin = {8.20588, -101.625}, extent = {{3.79412, -3.375}, {46.7941, -21.375}}, textString = "uInjPu"), Text(origin = {-131.5, 79}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "iqPu"), Text(origin = {-131.5, -74}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "idPu"), Text(origin = {127, 87.3045}, extent = {{-19, 12.6955}, {57, -36.3045}}, textString = "urSourcePu"), Text(origin = {127, -62.7}, extent = {{-19, 12.7}, {57, -36.3}}, textString = "uiSourcePu")}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end VSourceRef;
