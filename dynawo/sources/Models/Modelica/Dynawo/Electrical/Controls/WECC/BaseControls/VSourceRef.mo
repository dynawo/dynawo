within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
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
  import Modelica.Blocks;
  import Modelica.ComplexBlocks;
  import Dynawo.Types;
  import Dynawo;
  import Dynawo.Electrical.Controls.WECC.Parameters;

  extends Parameters.Params_VSourceRef;

  ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re),im(start = u0Pu.im)) "Complex voltage at inverter terminal in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, 5}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput idPu "d-axis current in p.u (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput iqPu "q-axis current in p.u (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Blocks.Interfaces.RealOutput UrPu(start = Ur0Pu) "Real voltage of inner voltage source in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealOutput UiPu(start = Ui0Pu) "Imaginary voltage of inner voltage source in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.WECC.BaseControls.UdqRef udqRef(RPu = RPu, XPu = XPu) annotation(
    Placement(visible = true, transformation(origin = {0, 7}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(visible = true, transformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder firstOrder(T = tE, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {40, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder firstOrder1(T = tE, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {40, 3}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = 30, Kp = 10, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-90, -33}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant OmegaRefPu(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-130, -39}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at inverter terminal in p.u (base UNom)";
  parameter Types.VoltageModulePu Ur0Pu "Start value of real voltage of inner voltage source in p.u (base UNom)";
  parameter Types.VoltageModulePu Ui0Pu "Start value of imaginary voltage of inner voltage source in p.u (base UNom)";

equation
  connect(OmegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-119, -39}, {-101, -39}}, color = {0, 0, 127}));
  connect(firstOrder1.y, transformDQtoRI.uqPu) annotation(
    Line(points = {{51, 3}, {79, 3}}, color = {0, 0, 127}));
  connect(udqRef.udRefPu, firstOrder.u) annotation(
    Line(points = {{11, 11}, {20, 11}, {20, 40}, {28, 40}}, color = {0, 0, 127}));
  connect(udqRef.uqRefPu, firstOrder1.u) annotation(
    Line(points = {{11, 3}, {28, 3}}, color = {0, 0, 127}));
  connect(transformRItoDQ.udPu, udqRef.udPu) annotation(
    Line(points = {{-29, 4}, {-11, 4}}, color = {0, 0, 127}));
  connect(transformRItoDQ.uqPu, udqRef.uqPu) annotation(
    Line(points = {{-29, -8}, {-16, -8}, {-16, -1}, {-11, -1}}, color = {0, 0, 127}));
  connect(uPu, transformRItoDQ.uPu) annotation(
    Line(points = {{-130, 5}, {-51, 5}}, color = {85, 170, 255}));
  connect(idPu, udqRef.idRefPu) annotation(
    Line(points = {{-130, 60}, {-20, 60}, {-20, 15}, {-11, 15}}, color = {0, 0, 127}));
  connect(iqPu, udqRef.iqRefPu) annotation(
    Line(points = {{-130, 30}, {-30, 30}, {-30, 10}, {-11, 10}}, color = {0, 0, 127}));
  connect(uPu, pll.uPu) annotation(
    Line(points = {{-130, 5}, {-110, 5}, {-110, -27}, {-101, -27}}, color = {85, 170, 255}));
  connect(pll.cosPhi, transformRItoDQ.cosPhi) annotation(
    Line(points = {{-79, -36}, {-70, -36}, {-70, -5}, {-51, -5}}, color = {0, 0, 127}));
  connect(pll.sinPhi, transformRItoDQ.sinPhi) annotation(
    Line(points = {{-79, -40}, {-60, -40}, {-60, -9}, {-51, -9}}, color = {0, 0, 127}));
  connect(transformDQtoRI.urPu, UrPu) annotation(
    Line(points = {{101, 6}, {110, 6}, {110, 20}, {130, 20}}, color = {0, 0, 127}));
  connect(transformDQtoRI.uiPu, UiPu) annotation(
    Line(points = {{101, -6}, {110, -6}, {110, -20}, {130, -20}}, color = {0, 0, 127}));
  connect(pll.sinPhi, transformDQtoRI.sinPhi) annotation(
    Line(points = {{-79, -40}, {70, -40}, {70, -7}, {79, -7}}, color = {0, 0, 127}));
  connect(pll.cosPhi, transformDQtoRI.cosPhi) annotation(
    Line(points = {{-79, -36}, {60, -36}, {60, -3}, {79, -3}}, color = {0, 0, 127}));
  connect(firstOrder.y, transformDQtoRI.udPu) annotation(
    Line(points = {{51, 40}, {70, 40}, {70, 7}, {79, 7}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 4}, extent = {{-82, 76}, {78, -84}}, textString = "VSourceRef"), Text(origin = {-141, 89}, extent = {{3, -3}, {37, -19}}, textString = "uPu"), Text(origin = {-121.5, 18}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "iqPu"), Text(origin = {-121.5, 18}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "iqPu"), Text(origin = {-121.5, -42}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "idPu"), Text(origin = {112.5, 20}, extent = {{-10.5, 7}, {31.5, -20}}, textString = "UrPu"), Text(origin = {112.5, -40}, extent = {{-10.5, 7}, {31.5, -20}}, textString = "UiPu")}, coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {1, 1})),
  Diagram(coordinateSystem(extent = {{-120, -120}, {120, 120}}, grid = {1, 1})));
end VSourceRef;
