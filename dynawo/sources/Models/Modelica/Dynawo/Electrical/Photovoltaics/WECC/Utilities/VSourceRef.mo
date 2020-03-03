within Dynawo.Electrical.Photovoltaics.WECC.Utilities;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/


model VSourceRef
  import Modelica.Blocks;
  import Modelica.ComplexBlocks;

  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.PLL;
  import Dynawo.Types;

  parameter Types.Time Te "Emulated delay in converter controls (Cannot be zero, typical: 0.02..0.05)";
  parameter Types.PerUnit R "Source resistance (typically set to zero, typical: 0..0.01)";
  parameter Types.PerUnit X "Source reactance (typical: 0.05..0.2)";

  // Inputs:
  ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re),im(start = u0Pu.im)) "Complex inverter terminal voltage" annotation(
    Placement(visible = true, transformation(origin = {-116, 73}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {-108, 72}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Interfaces.RealInput idPu "Setpoint d-axis current, injector convention (pu base SNom/UNom)" annotation(
    Placement(visible = true, transformation(origin = {-116, -23}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {-108, -64}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Interfaces.RealInput iqPu "Setpoint q-axis current, injector convention (pu base SNom/UNom)" annotation(
    Placement(visible = true, transformation(origin = {-116, -67}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {-108, 0}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));

  // Outputs:
  Blocks.Interfaces.RealOutput urSource(start = Ur0Pu) "Real part inverter terminal voltage" annotation(
    Placement(visible = true, transformation(origin = {114, 53}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {108, -2}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Interfaces.RealOutput uiSource(start = Ui0Pu) "Imaginary part inverter terminal voltage" annotation(
    Placement(visible = true, transformation(origin = {116, -57}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {108, -64}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));

  // Blocks:
  U_dq_ref u_dq_ref1(R = R, X = X) annotation(
    Placement(visible = true, transformation(origin = {-40, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DQ_Transformation dQ_Transformation1 annotation(
    Placement(visible = true, transformation(origin = {-24, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DQ_BackTransformation dQ_BackTransformation1 annotation(
    Placement(visible = true, transformation(origin = {64, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder UdCmd_Filt(T = Te, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-5, -19}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Blocks.Continuous.FirstOrder UqCmd_Filt(T = Te, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {17, -33}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  PLL.PLL pll(Ki = 30, Kp = 10, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-62, 68}, extent = {{-10, -10}, {15, 10}}, rotation = 0)));
  Blocks.Sources.Constant OmegaRefPu(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-86, 48}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

protected

  parameter Types.ComplexVoltagePu u0Pu "Start value of measured complex voltage at inverter terminal in p.u";
  parameter Types.VoltageModulePu Ur0Pu "Start value of real voltage inner voltage source at injector in p.u";
  parameter Types.VoltageModulePu Ui0Pu "Start value of imaginary voltage inner voltage source at injector in p.u";

equation

  connect(OmegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-80, 48}, {-78, 48}, {-78, 64}, {-72, 64}, {-72, 64}}, color = {0, 0, 127}));
  connect(dQ_BackTransformation1.ui, uiSource) annotation(
    Line(points = {{76, -38}, {84, -38}, {84, -58}, {116, -58}, {116, -56}}, color = {0, 0, 127}));
  connect(dQ_BackTransformation1.ur, urSource) annotation(
    Line(points = {{76, -26}, {84, -26}, {84, 52}, {114, 52}, {114, 54}}, color = {0, 0, 127}));
  connect(pll.sinphi, dQ_BackTransformation1.sinphi) annotation(
    Line(points = {{-52, 60}, {-44, 60}, {-44, 18}, {-80, 18}, {-80, -52}, {44, -52}, {44, -40}, {52, -40}, {52, -38}}, color = {0, 0, 127}));
  connect(pll.cosphi, dQ_BackTransformation1.cosphi) annotation(
    Line(points = {{-52, 64}, {-46, 64}, {-46, 20}, {-82, 20}, {-82, -54}, {42, -54}, {42, -34}, {52, -34}, {52, -34}}, color = {0, 0, 127}));
  connect(UqCmd_Filt.y, dQ_BackTransformation1.uq) annotation(
    Line(points = {{24, -32}, {34, -32}, {34, -28}, {52, -28}, {52, -28}}, color = {0, 0, 127}));
  connect(u_dq_ref1.uq_ref, UqCmd_Filt.u) annotation(
    Line(points = {{-28, -32}, {8, -32}, {8, -32}, {8, -32}}, color = {0, 0, 127}));
  connect(UdCmd_Filt.y, dQ_BackTransformation1.ud) annotation(
    Line(points = {{3, -19}, {34, -19}, {34, -24}, {52, -24}}, color = {0, 0, 127}));
  connect(u_dq_ref1.ud_ref, UdCmd_Filt.u) annotation(
    Line(points = {{-28, -24}, {-20, -24}, {-20, -19}, {-13, -19}}, color = {0, 0, 127}));
  connect(dQ_Transformation1.uq, u_dq_ref1.uq) annotation(
    Line(points = {{-12, 82}, {-4, 82}, {-4, 10}, {-74, 10}, {-74, -34}, {-50, -34}, {-50, -34}}, color = {0, 0, 127}));
  connect(dQ_Transformation1.ud, u_dq_ref1.ud) annotation(
    Line(points = {{-12, 86}, {0, 86}, {0, 6}, {-70, 6}, {-70, -30}, {-50, -30}, {-50, -30}}, color = {0, 0, 127}));
  connect(iqPu, u_dq_ref1.iq_ref) annotation(
    Line(points = {{-116, -66}, {-90, -66}, {-90, -26}, {-50, -26}, {-50, -26}}, color = {0, 0, 127}));
  connect(idPu, u_dq_ref1.id_ref) annotation(
    Line(points = {{-116, -22}, {-52, -22}, {-52, -22}, {-50, -22}}, color = {0, 0, 127}));
  connect(pll.sinphi, dQ_Transformation1.sinphi) annotation(
    Line(points = {{-52, 60}, {-44, 60}, {-44, 70}, {-34, 70}, {-34, 70}}, color = {0, 0, 127}));
  connect(pll.cosphi, dQ_Transformation1.cosphi) annotation(
    Line(points = {{-52, 64}, {-46, 64}, {-46, 74}, {-34, 74}, {-34, 74}}, color = {0, 0, 127}));
  connect(uPu, dQ_Transformation1.uPu) annotation(
    Line(points = {{-116, 74}, {-88, 74}, {-88, 86}, {-34, 86}, {-34, 86}}, color = {85, 170, 255}));
  connect(uPu, pll.uPu) annotation(
    Line(points = {{-116, 74}, {-72, 74}, {-72, 73}}, color = {85, 170, 255}));

annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 4}, extent = {{-80, 62}, {80, -62}}, textString = "VSourceRef")}));end VSourceRef;
