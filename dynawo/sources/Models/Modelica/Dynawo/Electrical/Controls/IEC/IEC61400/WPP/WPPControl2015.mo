within Dynawo.Electrical.Controls.IEC.IEC61400.WPP;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WPPControl2015 "Control model for IEC N°61400-27-1:2015 standard WPP"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseWPPControl;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QControlParameters2015;

  //PControl parameters
  parameter Types.Time tpft "Lead time constant in the reference value transfer function in s" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.Time tpfv "Lag time constant in the reference value transfer function in s" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.Time tWPfFiltP "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.Time tWPPFiltP "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "PControlWP"));

  //QControl parameters
  parameter Types.Time tWPPFiltQ "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time tWPQFiltQ "Filter time constant for reactive power measurement in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time tWPUFiltQ "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time txft "Lead time constant in the reference value transfer function in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time txfv "Lag time constant in the reference value transfer function in s" annotation(
    Dialog(tab = "QControlWP"));

  //Measurement parameters
  parameter Types.AngularVelocityPu DfMaxPu "Maximum frequency ramp rate in pu/s (base omegaNom)" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tfFilt "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "Measurement"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput QWPRefPu(start = -Q0Pu*SystemBase.SnRef/SNom) "Reference reactive power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tanPhi(start = Q0Pu/P0Pu) "Tangent phi (can be figured as QPu / PPu)" annotation(
    Placement(visible = true, transformation(origin = {30, -2}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-49, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UWPRefPu(start = U0Pu) "Reference voltage in pu (base UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PWTRefPu(start = -P0Pu*SystemBase.SnRef/SNom) "Reference active power communicated to WT in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(extent = {{100, 30}, {120, 50}})));
  Modelica.Blocks.Interfaces.RealOutput xWTRefPu(start = XWT0Pu) "Reference reactive power or voltage communicated to WT in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WPP.WPPPControl2015 pControl(DPRefMaxPu = DPRefMaxPu, DPRefMinPu = DPRefMinPu, DPwpRefMaxPu = DPwpRefMaxPu, DPwpRefMinPu = DPwpRefMinPu, Kiwpp = Kiwpp, Kpwpp = Kpwpp, KwppRef = KwppRef, P0Pu = P0Pu, PKiwppMaxPu = PKiwppMaxPu, PKiwppMinPu = PKiwppMinPu, PRefMaxPu = PRefMaxPu, PRefMinPu = PRefMinPu, SNom = SNom, TablePwpBiasfwpFiltCom = TablePwpBiasfwpFiltCom, tS = tS, tWPPFiltP = tWPPFiltP, tWPfFiltP = tWPfFiltP, tpft = tpft, tpfv = tpfv) annotation(
    Placement(visible = true, transformation(origin = {40, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WPP.WPPQControl2015 qControl(DXRefMaxPu = DXRefMaxPu, DXRefMinPu = DXRefMinPu, Kiwpx = Kiwpx, XKiwpxMaxPu = XKiwpxMaxPu, XKiwpxMinPu = XKiwpxMinPu, Kpwpx = Kpwpx, KwpqRef = KwpqRef, Kwpqu = Kwpqu, MwpqMode = MwpqMode, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, TableQwpUErr = TableQwpUErr, U0Pu = U0Pu, UwpqDipPu = UwpqDipPu, X0Pu = X0Pu, XRefMaxPu = XRefMaxPu, XRefMinPu = XRefMinPu, XWT0Pu = XWT0Pu, tS = tS, tUqFilt = tUqFilt, tWPPFiltQ = tWPPFiltQ, tWPQFiltQ = tWPQFiltQ, tWPUFiltQ = tWPUFiltQ, txft = txft, txfv = txfv) annotation(
    Placement(visible = true, transformation(origin = {40, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.Product product(useConjugateInput2 = true) annotation(
    Placement(visible = true, transformation(origin = {-130, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal annotation(
    Placement(visible = true, transformation(origin = {-88, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToPolar annotation(
    Placement(visible = true, transformation(origin = {-130, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder4(T = tfFilt) annotation(
    Placement(transformation(origin = {-48, -126}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DfMaxPu, Y0 = 0, tS = tS) annotation(
    Placement(transformation(origin = {-80, -126}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Derivative derivative(T = tfFilt/20, k = 1/SystemBase.omegaNom, x_start = UPhase0) annotation(
    Placement(transformation(origin = {-110, -126}, extent = {{-10, -10}, {10, 10}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToPolar1 annotation(
    Placement(transformation(origin = {-140, -120}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {-12, -114}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(pControl.PWPPu, y) annotation(
    Line(points = {{-76, -24}, {-20, -24}, {-20, 48}, {18, 48}}, color = {0, 0, 127}));
  connect(pControl.PWTRefPu, PWTRefPu) annotation(
    Line(points = {{62, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(tanPhi, qControl.tanPhi) annotation(
    Line(points = {{30, -2}, {30, -38}}, color = {0, 0, 127}));
  connect(qControl.xWTRefPu, xWTRefPu) annotation(
    Line(points = {{62, -60}, {110, -60}}, color = {0, 0, 127}));
  connect(product.y, complexToReal.u) annotation(
    Line(points = {{-118, -30}, {-100, -30}}, color = {85, 170, 255}));
  connect(uPu, product.u1) annotation(
    Line(points = {{-200, 0}, {-160, 0}, {-160, -24}, {-142, -24}}, color = {85, 170, 255}));
  connect(iPu, product.u2) annotation(
    Line(points = {{-200, -60}, {-160, -60}, {-160, -36}, {-142, -36}}, color = {85, 170, 255}));
  connect(uPu, complexToPolar.u) annotation(
    Line(points = {{-200, 0}, {-150, 0}, {-150, -78}, {-142, -78}}, color = {85, 170, 255}));
  connect(qControl.QWPRefPu, QWPRefPu) annotation(
    Line(points = {{18, -48}, {-40, -48}, {-40, 30}, {-200, 30}}, color = {0, 0, 127}));
  connect(qControl.PWPPu, y) annotation(
    Line(points = {{18, -56}, {-20, -56}, {-20, -24}, {-76, -24}}, color = {0, 0, 127}));
  connect(qControl.QWPPu, complexToReal.im) annotation(
    Line(points = {{18, -64}, {-60, -64}, {-60, -36}, {-76, -36}}, color = {0, 0, 127}));
  connect(qControl.UWPPu, complexToPolar.len) annotation(
    Line(points = {{18, -72}, {-118, -72}}, color = {0, 0, 127}));
  connect(qControl.UWPRefPu, UWPRefPu) annotation(
    Line(points = {{18, -80}, {-52, -80}, {-52, 60}, {-200, 60}}, color = {0, 0, 127}));
  connect(complexToReal.re, y) annotation(
    Line(points = {{-20, -56}, {-8, -56}}, color = {0, 0, 127}));
  connect(PWPRefPu, pControl.PWPRefPu) annotation(
    Line(points = {{-200, 86}, {-80, 86}, {-80, 72}, {18, 72}}, color = {0, 0, 127}));
  connect(rampLimiter.y, firstOrder4.u) annotation(
    Line(points = {{-69, -126}, {-60, -126}}, color = {0, 0, 127}));
  connect(derivative.y, rampLimiter.u) annotation(
    Line(points = {{-99, -126}, {-92, -126}}, color = {0, 0, 127}));
  connect(uPu, complexToPolar1.u) annotation(
    Line(points = {{-200, 0}, {-160, 0}, {-160, -120}, {-152, -120}}, color = {85, 170, 255}));
  connect(complexToPolar1.phi, derivative.u) annotation(
    Line(points = {{-128, -126}, {-122, -126}}, color = {0, 0, 127}));
  connect(firstOrder4.y, add.u2) annotation(
    Line(points = {{-37, -126}, {-30.5, -126}, {-30.5, -120}, {-24, -120}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u1) annotation(
    Line(points = {{-200, -100}, {-30, -100}, {-30, -108}, {-24, -108}}, color = {0, 0, 127}));
  connect(add.y, pControl.omegaWPPu) annotation(
    Line(points = {{-1, -114}, {6, -114}, {6, 60}, {18, 60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-180, -140}, {100, 100}})));
end WPPControl2015;
