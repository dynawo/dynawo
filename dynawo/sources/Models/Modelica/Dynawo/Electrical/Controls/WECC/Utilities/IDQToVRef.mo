within Dynawo.Electrical.Controls.WECC.Utilities;

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

model IDQToVRef "Conversion of Id/Iq setpoints to voltage setpoints for a voltage source"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  extends Parameters.Params_IDQToVRef;

  Modelica.Blocks.Interfaces.RealInput idPu "Complex d-axis current in p.u (injector convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-112, 69}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {-108, -64}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPu "Complex q-axis current in p.u (injector convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-112, 31}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {-108, 0}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));


  Modelica.Blocks.Interfaces.RealOutput urPu(start = Ur0Pu) "Real part of voltage at regulated bus in p.u" annotation(
    Placement(visible = true, transformation(origin = {116, 41}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {104, 40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uiPu(start = Ui0Pu) "Imaginary part of voltage at regulated bus in p.u" annotation(
    Placement(visible = true, transformation(origin = {116, -39}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {100, -40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));


  Dynawo.Electrical.Controls.WECC.Utilities.UdqRef udqRef(RPu = RPuSource, XPu = XPuSource) annotation(
    Placement(visible = true, transformation(origin = {-10, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(visible = true, transformation(origin = {-30, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(visible = true, transformation(origin = {70, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder UdCmd_Filt(T = Te, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {31, 69}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder UqCmd_Filt(T = Te, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {31, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = 30, Kp = 10, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-72, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRefPu(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-109, -53}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(im(start = u0Pu.im), re(start = u0Pu.re)) annotation(
    Placement(visible = true, transformation(origin = {-110, -17}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 62}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));

protected
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at regulated bus in p.u";
  parameter Types.PerUnit Ur0Pu "Start value of real part of voltage inside the voltage source at injector in p.u";
  parameter Types.PerUnit Ui0Pu "Start value of imaginary part of voltage inside the voltage source at injector in p.u";

equation
  connect(OmegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-98, -52}, {-83, -52}}, color = {0, 0, 127}));
  connect(transformDQtoRI.ui, uiPu) annotation(
    Line(points = {{81, 4}, {96, 4}, {96, -39}, {100, -39}}, color = {0, 0, 127}));
  connect(transformDQtoRI.ur, urPu) annotation(
    Line(points = {{81, 16}, {96, 16}, {96, 41}, {100, 41}}, color = {0, 0, 127}));
  connect(pll.sinphi, transformDQtoRI.sinphi) annotation(
    Line(points = {{-56, -52}, {10, -52}, {10, 3}, {59, 3}}, color = {0, 0, 127}));
  connect(pll.cosphi, transformDQtoRI.cosphi) annotation(
    Line(points = {{-56, -48}, {5, -48}, {5, 7}, {59, 7}}, color = {0, 0, 127}));
  connect(UqCmd_Filt.y, transformDQtoRI.uq) annotation(
    Line(points = {{42, 25}, {48, 25}, {48, 13}, {59, 13}}, color = {0, 0, 127}));
  connect(UdCmd_Filt.y, transformDQtoRI.ud) annotation(
    Line(points = {{42, 69}, {54, 69}, {54, 17}, {59, 17}}, color = {0, 0, 127}));
  connect(udqRef.udRef, UdCmd_Filt.u) annotation(
    Line(points = {{0, 56}, {15, 56}, {15, 69}, {19, 69}}, color = {0, 0, 127}));
  connect(udqRef.uqRef, UqCmd_Filt.u) annotation(
    Line(points = {{0, 48}, {9.5, 48},{9.5, 25}, {19, 25}}, color = {0, 0, 127}));
  connect(transformRItoDQ.uq, udqRef.uq) annotation(
    Line(points = {{-19, -16}, {-6, -16}, {-6, 41}}, color = {0, 0, 127}));
  connect(transformRItoDQ.ud, udqRef.ud) annotation(
    Line(points = {{-19, -4}, {-14, -4}, {-14, 41}}, color = {0, 0, 127}));
  connect(pll.sinphi, transformRItoDQ.sinphi) annotation(
    Line(points = {{-56, -52}, {-43.5, -52}, {-43.5, -17}, {-41, -17}}, color = {0, 0, 127}));
  connect(pll.cosphi, transformRItoDQ.cosphi) annotation(
    Line(points = {{-56, -48}, {-45.5, -48}, {-45.5, -13}, {-41, -13}}, color = {0, 0, 127}));
  connect(uPu, transformRItoDQ.uPu) annotation(
    Line(points = {{-110, -17}, {-93, -17}, {-93, -3}, {-41, -3}}, color = {85, 170, 255}));
  connect(uPu, pll.uPu) annotation(
    Line(points = {{-110, -17}, {-93, -17}, {-93, -40}, {-83, -40}}, color = {85, 170, 255}));
  connect(idPu, udqRef.idRef) annotation(
    Line(points = {{-112, 70}, {-70, 70}, {-70, 56}, {-20, 56}}, color = {0, 0, 127}));
  connect(iqPu, udqRef.iqRef) annotation(
    Line(points = {{-112, 32}, {-70, 32}, {-70, 48}, {-20, 48}}, color = {0, 0, 127}));
  annotation(
  Documentation(info="<html>
<p> The block expressses the setpoints for Iq and Id as voltage setpoints for a voltage source with source impedance. This implementation is based on <a href=\"https://www.wecc.org/Administrative/Memo%20RES%20Modeling%20Updates-%20Pourbeik.pdf\" >https://www.wecc.org/Administrative/Memo%20RES%20Modeling%20Updates-%20Pourbeik.pdf</a> where the second generation of the WECC models is proposed.</p> </ul> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 4}, extent = {{-80, 62}, {80, -62}}, textString = "IDQToRef"), Text(origin = {-135, 75}, extent = {{-13, 9}, {13, -9}}, textString = "uPu"), Text(origin = {-138, 17}, extent = {{-16, 9}, {16, -9}}, textString = "idPu"), Text(origin = {-137, -38}, extent = {{-16, 9}, {16, -9}}, textString = "iqPu"), Text(origin = {130, 56}, extent = {{-16, 9}, {16, -9}}, textString = "urPu"), Text(origin = {132, -23}, extent = {{-16, 9}, {16, -9}}, textString = "uiPu")}));


end IDQToVRef;
