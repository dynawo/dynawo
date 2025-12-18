within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WPP;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WPPQControl2020 "Reactive power control module for wind power plants (IEC N°61400-27-1:2020)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseWPPQControl(combiTable1Ds2(table = TableQwpUErr));
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QControlParameters2020;

  //QControl parameters
  parameter Types.PerUnit RwpDropPu "Resistive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.VoltageModulePu UwpqRisePu "Voltage threshold for OVRT detection in pu (base UNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XErrMaxPu "Maximum reactive power or voltage error input to PI controller in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XErrMinPu "Minimum reactive power or voltage error input to PI controller in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XwpDropPu "Inductive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControlWP"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PWPFiltComPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered active power communicated to WP in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-340, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QWPFiltComPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Filtered reactive power communicated to WP in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-340, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWPFiltComPu(start = U0Pu) "Filtered voltage module communicated to WP in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xWPRefComPu(start = X0Pu) "Reference reactive power or voltage communicated to WP in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-340, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.BooleanOutput fWPFrt(start = false) "True if fault status" annotation(
    Placement(visible = true, transformation(origin = {360, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110},extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput xPDRefPu(start = XWT0Pu) "Reference reactive power or voltage communicated to WT in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {360, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = TableQwpMaxPwpFiltCom) annotation(
    Placement(visible = true, transformation(origin = {-190, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds1(table = TableQwpMinPwpFiltCom) annotation(
    Placement(visible = true, transformation(origin = {-190, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.VDrop vDrop(P0Pu = P0Pu, Q0Pu = Q0Pu, RDropPu = RwpDropPu, U0Pu = U0Pu, XDropPu = XwpDropPu) annotation(
    Placement(visible = true, transformation(origin = {-220, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = UwpqRisePu) annotation(
    Placement(visible = true, transformation(origin = {-110, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {-10, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {-30, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = XErrMaxPu, uMin = XErrMinPu) annotation(
    Placement(visible = true, transformation(origin = {110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  equation
  connect(xWPRefComPu, multiSwitch.u[1]) annotation(
    Line(points = {{-340, 120}, {-140, 120}, {-140, 103}, {-80, 103}}, color = {0, 0, 127}));
  connect(multiSwitch.y, variableLimiter.u) annotation(
    Line(points = {{-58, 100}, {-42, 100}}, color = {0, 0, 127}));
  connect(variableLimiter.y, feedback2.u1) annotation(
    Line(points = {{-18, 100}, {12, 100}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], variableLimiter.limit2) annotation(
    Line(points = {{-178, 100}, {-176, 100}, {-176, 86}, {-50, 86}, {-50, 92}, {-42, 92}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], variableLimiter.limit1) annotation(
    Line(points = {{-178, 140}, {-50, 140}, {-50, 108}, {-42, 108}}, color = {0, 0, 127}));
  connect(PWPFiltComPu, combiTable1Ds.u) annotation(
    Line(points = {{-340, 40}, {-220, 40}, {-220, 140}, {-202, 140}}, color = {0, 0, 127}));
  connect(PWPFiltComPu, combiTable1Ds1.u) annotation(
    Line(points = {{-340, 40}, {-220, 40}, {-220, 100}, {-202, 100}}, color = {0, 0, 127}));
  connect(QWPFiltComPu, vDrop.QPu) annotation(
    Line(points = {{-340, -40}, {-260, -40}, {-260, -120}, {-242, -120}}, color = {0, 0, 127}));
  connect(QWPFiltComPu, feedback2.u2) annotation(
    Line(points = {{-340, -40}, {20, -40}, {20, 92}}, color = {0, 0, 127}));
  connect(UWPFiltComPu, vDrop.UPu) annotation(
    Line(points = {{-340, -120}, {-280, -120}, {-280, -132}, {-242, -132}}, color = {0, 0, 127}));
  connect(vDrop.PPu, PWPFiltComPu) annotation(
    Line(points = {{-242, -108}, {-250, -108}, {-250, 40}, {-340, 40}}, color = {0, 0, 127}));
  connect(vDrop.UDropPu, greaterThreshold.u) annotation(
    Line(points = {{-198, -120}, {-140, -120}, {-140, -106}, {-122, -106}}, color = {0, 0, 127}));
  connect(vDrop.UDropPu, lessThreshold.u) annotation(
    Line(points = {{-198, -120}, {-140, -120}, {-140, -140}, {-122, -140}}, color = {0, 0, 127}));
  connect(lessThreshold.y, or1.u2) annotation(
    Line(points = {{-98, -140}, {-40, -140}, {-40, -128}, {-22, -128}}, color = {255, 0, 255}));
  connect(greaterThreshold.y, or1.u1) annotation(
    Line(points = {{-99, -106}, {-40, -106}, {-40, -120}, {-22, -120}}, color = {255, 0, 255}));
  connect(multiSwitch1.y, limiter.u) annotation(
    Line(points = {{82, 100}, {98, 100}}, color = {0, 0, 127}));
  connect(limiter.y, gain2.u) annotation(
    Line(points = {{122, 100}, {158, 100}}, color = {0, 0, 127}));
  connect(limiter.y, antiWindupIntegrator.u) annotation(
    Line(points = {{122, 100}, {140, 100}, {140, 60}, {158, 60}}, color = {0, 0, 127}));
  connect(variableLimiter.y, gain1.u) annotation(
    Line(points = {{-18, 100}, {-4, 100}, {-4, 140}, {158, 140}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.y, xPDRefPu) annotation(
    Line(points = {{272, 100}, {360, 100}}, color = {0, 0, 127}));
  connect(or1.y, fWPFrt) annotation(
    Line(points = {{2, -120}, {360, -120}}, color = {255, 0, 255}));
  connect(or1.y, absLimRateLimFirstOrderFreeze.freeze) annotation(
    Line(points = {{2, -120}, {10, -120}, {10, -20}, {-110, -20}, {-110, 8}}, color = {255, 0, 255}));
  connect(or1.y, absLimRateLimFeedthroughFreezeLimDetection.freeze) annotation(
    Line(points = {{2, -120}, {300, -120}, {300, 140}, {260, 140}, {260, 112}}, color = {255, 0, 255}));
  connect(or1.y, or2.u[1]) annotation(
    Line(points = {{2, -120}, {260, -120}, {260, 20}, {240, 20}}, color = {255, 0, 255}));
  connect(or2.y, antiWindupIntegrator.fMax) annotation(
    Line(points = {{218, 20}, {178, 20}, {178, 48}}, color = {255, 0, 255}));
  connect(or2.y, antiWindupIntegrator.fMin) annotation(
    Line(points = {{218, 20}, {174, 20}, {174, 48}}, color = {255, 0, 255}));
  connect(PWPFiltComPu, product.u2) annotation(
    Line(points = {{-340, 40}, {-180, 40}, {-180, 54}, {-162, 54}}, color = {0, 0, 127}));
  connect(xWPRefComPu, product.u1) annotation(
    Line(points = {{-340, 120}, {-240, 120}, {-240, 66}, {-162, 66}}, color = {0, 0, 127}));
  connect(xWPRefComPu, feedback.u1) annotation(
    Line(points = {{-340, 120}, {-240, 120}, {-240, 0}, {-228, 0}}, color = {0, 0, 127}));
  connect(vDrop.UDropPu, feedback.u2) annotation(
    Line(points = {{-198, -120}, {-180, -120}, {-180, -20}, {-220, -20}, {-220, -8}}, color = {0, 0, 127}));
  connect(QWPFiltComPu, gain.u) annotation(
    Line(points = {{-340, -40}, {-140, -40}, {-140, -72}, {-122, -72}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {22, -108}, extent = {{-94, 60}, {48, 12}}, textString = "2020")}));
end WPPQControl2020;
