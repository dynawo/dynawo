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
  import Dynawo.Electrical.Controls.PLL;
  import Dynawo.Electrical.Controls.WECC.Utilities;
  import Dynawo.Electrical.Controls.WECC.BaseControls;

  parameter Types.Time Te "Emulated delay in converter controls (cannot be zero, typical: 0.02..0.05)";
  parameter Types.PerUnit R "Source resistance (typically set to zero, typical: 0..0.01)";
  parameter Types.PerUnit X "Source reactance (typical: 0.05..0.2)";

  ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re),im(start = u0Pu.im)) "Complex voltage at inverter terminal in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput idPu "d-axis current in p.u (base SNom/UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput iqPu "q-axis current in p.u (base SNom/UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Blocks.Interfaces.RealOutput urSource(start = Ur0Pu) "Real voltage of inner voltage source in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealOutput uiSource(start = Ui0Pu) "Imaginary voltage of inner voltage source in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  BaseControls.UdqRef u_dq_ref1(R = R, X = X) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Utilities.TransformRItoDQ dQ_Transformation1 annotation(
    Placement(visible = true, transformation(origin = {-40, -9}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Utilities.TransformDQtoRI dQ_BackTransformation1 annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder UdCmd_Filt(T = Te, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder UqCmd_Filt(T = Te, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {40, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  PLL.PLL pll(Ki = 30, Kp = 10, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-80, -37}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant OmegaRefPu(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-130, -43}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at inverter terminal in p.u (base UNom)";
  parameter Types.VoltageModulePu Ur0Pu "Start value of real voltage of inner voltage source in p.u (base UNom)";
  parameter Types.VoltageModulePu Ui0Pu "Start value of imaginary voltage of inner voltage source in p.u (base UNom)";

equation
  connect(OmegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-119, -43}, {-91, -43}}, color = {0, 0, 127}));
  connect(dQ_BackTransformation1.ui, uiSource) annotation(
    Line(points = {{91, -6}, {105.5, -6}, {105.5, -20}, {130, -20}}, color = {0, 0, 127}));
  connect(dQ_BackTransformation1.ur, urSource) annotation(
    Line(points = {{91, 6}, {100, 6}, {100, 20}, {130, 20}}, color = {0, 0, 127}));
  connect(UdCmd_Filt.y, dQ_BackTransformation1.ud) annotation(
    Line(points = {{51, 20}, {60, 20}, {60, 7}, {69, 7}}, color = {0, 0, 127}));
  connect(UqCmd_Filt.y, dQ_BackTransformation1.uq) annotation(
    Line(points = {{51, -20}, {60, -20}, {60, 3}, {69, 3}}, color = {0, 0, 127}));
  connect(u_dq_ref1.udRef, UdCmd_Filt.u) annotation(
    Line(points = {{11, 4}, {20, 4}, {20, 20}, {28, 20}}, color = {0, 0, 127}));
  connect(u_dq_ref1.uqRef, UqCmd_Filt.u) annotation(
    Line(points = {{11, -4}, {19.5, -4}, {19.5, -20}, {28, -20}}, color = {0, 0, 127}));
  connect(dQ_Transformation1.ud, u_dq_ref1.ud) annotation(
    Line(points = {{-29, -3}, {-11, -3}}, color = {0, 0, 127}));
  connect(dQ_Transformation1.uq, u_dq_ref1.uq) annotation(
    Line(points = {{-29, -15}, {-16, -15}, {-16, -8}, {-11, -8}}, color = {0, 0, 127}));
  connect(pll.sinphi, dQ_Transformation1.sinphi) annotation(
    Line(points = {{-69, -44}, {-56, -44}, {-56, -16}, {-51, -16}}, color = {0, 0, 127}));
  connect(pll.cosphi, dQ_Transformation1.cosphi) annotation(
    Line(points = {{-69, -40}, {-60, -40}, {-60, -12}, {-51, -12}}, color = {0, 0, 127}));
  connect(uPu, pll.uPu) annotation(
    Line(points = {{-130, -2}, {-100, -2}, {-100, -31}, {-91, -31}}, color = {85, 170, 255}));
  connect(uPu, dQ_Transformation1.uPu) annotation(
    Line(points = {{-130, -2}, {-51, -2}}, color = {85, 170, 255}));
  connect(idPu, u_dq_ref1.idRef) annotation(
    Line(points = {{-130, 60}, {-20, 60}, {-20, 8}, {-11, 8}}, color = {0, 0, 127}));
  connect(iqPu, u_dq_ref1.iqRef) annotation(
    Line(points = {{-130, 30}, {-30, 30}, {-30, 3}, {-11, 3}}, color = {0, 0, 127}));
  connect(pll.cosphi, dQ_BackTransformation1.cosphi) annotation(
    Line(points = {{-69, -40}, {62, -40}, {62, -3}, {69, -3}}, color = {0, 0, 127}));
  connect(pll.sinphi, dQ_BackTransformation1.sinphi) annotation(
    Line(points = {{-69, -44}, {64, -44}, {64, -7}, {69, -7}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 4}, extent = {{-82, 76}, {78, -84}}, textString = "VSourceRef"), Text(origin = {-141, 89}, extent = {{3, -3}, {37, -19}}, textString = "uPu"), Text(origin = {-121.5, 18}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "iqPu"), Text(origin = {-121.5, 18}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "iqPu"), Text(origin = {-121.5, -42}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "idPu"), Text(origin = {112.5, 20}, extent = {{-10.5, 7}, {31.5, -20}}, textString = "urSource"), Text(origin = {112.5, -40}, extent = {{-10.5, 7}, {31.5, -20}}, textString = "uiSource")}, coordinateSystem(extent = {{-120, -120}, {120, 120}}, grid = {1, 1})),
  Diagram(coordinateSystem(extent = {{-120, -120}, {120, 120}}, grid = {1, 1})));
end VSourceRef;
