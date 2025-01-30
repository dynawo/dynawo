within Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls;

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

model EpriVoltageCtrl "Voltage controller in EPRI Grid Forming model"
  extends Parameters.VoltageCtrl;
  extends Parameters.InitialVoltageCtrl;
  
  // inputs
  Modelica.Blocks.Interfaces.RealInput deltaOmegaPu(start = 0) "frequency deviation in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-285, 146}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = PRef0Pu) "active power at converter's terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-285, 161}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power reference in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-285, 181}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QAuxPu(start = 0) "Auxiliary reactive power (optional input) in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-285, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UdFilterPu(start = UdFilter0Pu) "Measured d-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-285, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdFilterRefPu(start = UdFilter0Pu) "D-axis voltage reference at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-285, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary active power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-285, 201}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = QRef0Pu) "Reactive power at converter's terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-285, -70}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QRef0Pu) "Reactive power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-285.5, -45.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UqFilterPu(start = UqFilter0Pu) "Measured q-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-285, -125}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // outputs
  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = IdConv0Pu) "D-axis current reference in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {259, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = IqConv0Pu) "Q-axis current reference in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {259, 19}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-165, -205}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {20, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPAuxPu annotation(
    Placement(visible = true, transformation(origin = {-55, 186}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPiP annotation(
    Placement(visible = true, transformation(origin = {50, 186}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPiQ annotation(
    Placement(visible = true, transformation(origin = {15, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPiV annotation(
    Placement(visible = true, transformation(origin = {50, 83}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addQAuxPu annotation(
    Placement(visible = true, transformation(origin = {-135, -5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addQu annotation(
    Placement(visible = true, transformation(origin = {-82, -11}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-225, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.CurrentLimiter currentLimiter(IMaxPu = IMaxPu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, PQflag = PQflag, Theta0 = Theta0) annotation(
    Placement(visible = true, transformation(origin = {190, 9}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {-85, -150}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackDroop annotation(
    Placement(visible = true, transformation(origin = {-98, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackP annotation(
    Placement(visible = true, transformation(origin = {-134, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackQ annotation(
    Placement(visible = true, transformation(origin = {-180, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackV annotation(
    Placement(visible = true, transformation(origin = {-175, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput Frz annotation(
    Placement(visible = true, transformation(origin = {260, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {74, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gain7(k = KPv) annotation(
    Placement(visible = true, transformation(origin = {-20, -135}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainDroop(k = 1 / OmegaDroopPu) annotation(
    Placement(visible = true, transformation(origin = {-122, 145}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainInvertSign(k = -1) annotation(
    Placement(visible = true, transformation(origin = {55, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainInvertSign2(k = 1) annotation(
    Placement(visible = true, transformation(origin = {55, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainPiP(k = KPp) annotation(
    Placement(visible = true, transformation(origin = {10, 154}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainPiQ(k = KPv) annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainPiV(k = KPp) annotation(
    Placement(visible = true, transformation(origin = {10, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainQDroop(k = QDroopPu) annotation(
    Placement(visible = true, transformation(origin = {-140, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant1(k = OmegaFlag) annotation(
    Placement(visible = true, transformation(origin = {89, 31}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorSetFreeze integratorSetFreezePiP(K = KIp, UseFreeze = true, Y0 = IdConv0Pu, y(start = IdConv0Pu)) annotation(
    Placement(visible = true, transformation(origin = {10, 199}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorSetFreeze integratorSetFreezePiQ(K = KIv, UseFreeze = true, Y0 = IqConv0Pu, y(start = IqConv0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-23, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorSetFreeze integratorSetFreezePiV(K = KIp, UseFreeze = true, Y0 = IdConv0Pu, y(start = IdConv0Pu)) annotation(
    Placement(visible = true, transformation(origin = {11, 109}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorSetFreeze integratorSetFreezePiVq(K = KIv, UseFreeze = true, Y0 = IqConv0Pu, y(start = IqConv0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-20, -165}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.LvrtFrz lvrtFrz(UDipPu = UDipPu, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-65, -205}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchD(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {104, 83}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchQ(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {159, -77}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-215, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-215, -190}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt1 annotation(
    Placement(visible = true, transformation(origin = {-129, -205}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uMagPu annotation(
    Placement(visible = true, transformation(origin = {260, -225}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {44, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

equation
  connect(feedbackP.u1, PRefPu) annotation(
    Line(points = {{-142, 180}, {-201, 180}, {-201, 181}, {-285, 181}}, color = {0, 0, 127}));
  connect(feedbackV.u1, UdFilterRefPu) annotation(
    Line(points = {{-183, 0}, {-285, 0}}, color = {0, 0, 127}));
  connect(feedbackV.u2, UdFilterPu) annotation(
    Line(points = {{-175, 8}, {-175, 40}, {-285, 40}}, color = {0, 0, 127}));
  connect(addPiP.u2, gainPiP.y) annotation(
    Line(points = {{38, 180}, {29.5, 180}, {29.5, 154}, {21, 154}}, color = {0, 0, 127}));
  connect(addPiQ.u1, gainPiQ.y) annotation(
    Line(points = {{3, -9}, {-4, -9}, {-4, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(deltaOmegaPu, gainDroop.u) annotation(
    Line(points = {{-285, 146}, {-197, 146}, {-197, 145}, {-134, 145}}, color = {0, 0, 127}));
  connect(PPu, feedbackP.u2) annotation(
    Line(points = {{-285, 161}, {-134, 161}, {-134, 172}}, color = {0, 0, 127}));
  connect(feedbackDroop.u1, feedbackP.y) annotation(
    Line(points = {{-106, 180}, {-125, 180}}, color = {0, 0, 127}));
  connect(gainDroop.y, feedbackDroop.u2) annotation(
    Line(points = {{-111, 145}, {-98, 145}, {-98, 172}}, color = {0, 0, 127}));
  connect(feedbackDroop.y, addPAuxPu.u2) annotation(
    Line(points = {{-89, 180}, {-67, 180}}, color = {0, 0, 127}));
  connect(feedbackQ.y, gainQDroop.u) annotation(
    Line(points = {{-171, -60}, {-152, -60}}, color = {0, 0, 127}));
  connect(feedbackV.y, addQAuxPu.u1) annotation(
    Line(points = {{-166, 0}, {-146, 0}}, color = {0, 0, 127}));
  connect(addQu.y, gainPiQ.u) annotation(
    Line(points = {{-71, -11}, {-40.5, -11}, {-40.5, 6}, {-31, 6}}, color = {0, 0, 127}));
  connect(QPu, feedbackQ.u2) annotation(
    Line(points = {{-285, -70}, {-192.5, -70}, {-192.5, -68}, {-180, -68}}, color = {0, 0, 127}));
  connect(QRefPu, feedbackQ.u1) annotation(
    Line(points = {{-285.5, -45.5}, {-206.5, -45.5}, {-206.5, -60}, {-188, -60}}, color = {0, 0, 127}));
  connect(addPiQ.y, gainInvertSign.u) annotation(
    Line(points = {{26, -15}, {43, -15}}, color = {0, 0, 127}));
  connect(addPiV.u2, gainPiV.y) annotation(
    Line(points = {{38, 77}, {28.5, 77}, {28.5, 62}, {21, 62}}, color = {0, 0, 127}));
  connect(add5.y, gainInvertSign2.u) annotation(
    Line(points = {{31, -150}, {42, -150}}, color = {0, 0, 127}));
  connect(add5.u1, gain7.y) annotation(
    Line(points = {{8, -144}, {-0.5, -144}, {-0.5, -135}, {-9, -135}}, color = {0, 0, 127}));
  connect(constant1.y, feedback4.u1) annotation(
    Line(points = {{-214, -150}, {-93, -150}}, color = {0, 0, 127}));
  connect(feedback4.u2, UqFilterPu) annotation(
    Line(points = {{-85, -142}, {-85, -125}, {-285, -125}}, color = {0, 0, 127}));
  connect(addQAuxPu.y, addQu.u1) annotation(
    Line(points = {{-124, -5}, {-94, -5}}, color = {0, 0, 127}));
  connect(gainQDroop.y, addQu.u2) annotation(
    Line(points = {{-129, -60}, {-100, -60}, {-100, -17}, {-94, -17}}, color = {0, 0, 127}));
  connect(QAuxPu, addQAuxPu.u2) annotation(
    Line(points = {{-285, -15}, {-175, -15}, {-175, -11}, {-147, -11}}, color = {0, 0, 127}));
  connect(addPiP.y, multiSwitchD.u[1]) annotation(
    Line(points = {{61, 186}, {73, 186}, {73, 91}, {87, 91}, {87, 83}, {94, 83}}, color = {0, 0, 127}));
  connect(PAuxPu, addPAuxPu.u1) annotation(
    Line(points = {{-285, 201}, {-99, 201}, {-99, 192}, {-67, 192}}, color = {0, 0, 127}));
  connect(addPAuxPu.y, gainPiP.u) annotation(
    Line(points = {{-44, 186}, {-24, 186}, {-24, 154}, {-2, 154}}, color = {0, 0, 127}));
  connect(addPiV.y, multiSwitchD.u[2]) annotation(
    Line(points = {{61, 83}, {94, 83}}, color = {0, 0, 127}));
  connect(addPiV.y, multiSwitchD.u[3]) annotation(
    Line(points = {{61, 83}, {94, 83}}, color = {0, 0, 127}));
  connect(addPiV.y, multiSwitchD.u[4]) annotation(
    Line(points = {{61, 83}, {94, 83}}, color = {0, 0, 127}));
  connect(gainInvertSign.y, multiSwitchQ.u[1]) annotation(
    Line(points = {{66, -15}, {111, -15}, {111, -77}, {149, -77}}, color = {0, 0, 127}));
  connect(gainInvertSign2.y, multiSwitchQ.u[2]) annotation(
    Line(points = {{66, -150}, {119, -150}, {119, -77}, {149, -77}}, color = {0, 0, 127}));
  connect(gainInvertSign2.y, multiSwitchQ.u[3]) annotation(
    Line(points = {{66, -150}, {119, -150}, {119, -77}, {149, -77}}, color = {0, 0, 127}));
  connect(gainInvertSign2.y, multiSwitchQ.u[4]) annotation(
    Line(points = {{66, -150}, {119, -150}, {119, -77}, {149, -77}}, color = {0, 0, 127}));
  connect(integerConstant1.y, multiSwitchD.f) annotation(
    Line(points = {{100, 31}, {119, 31}, {119, 109}, {104, 109}, {104, 95}}, color = {255, 127, 0}));
  connect(integerConstant1.y, multiSwitchQ.f) annotation(
    Line(points = {{100, 31}, {119, 31}, {119, -45}, {159, -45}, {159, -65}}, color = {255, 127, 0}));
  connect(add.y, sqrt1.u) annotation(
    Line(points = {{-154, -205}, {-139, -205}}, color = {0, 0, 127}));
  connect(product.y, add.u2) annotation(
    Line(points = {{-204, -230}, {-189, -230}, {-189, -212}, {-178, -212}}, color = {0, 0, 127}));
  connect(product1.y, add.u1) annotation(
    Line(points = {{-204, -190}, {-177, -190}, {-177, -199}}, color = {0, 0, 127}));
  connect(feedback4.y, gain7.u) annotation(
    Line(points = {{-76, -150}, {-54, -150}, {-54, -135}, {-32, -135}}, color = {0, 0, 127}));
  connect(sqrt1.y, lvrtFrz.UPu) annotation(
    Line(points = {{-118, -205}, {-76, -205}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiVq.u, feedback4.y) annotation(
    Line(points = {{-32, -165}, {-74, -165}, {-74, -149}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiVq.y, add5.u2) annotation(
    Line(points = {{-9, -165}, {3, -165}, {3, -155}, {10, -155}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiQ.y, addPiQ.u2) annotation(
    Line(points = {{-12, -32}, {-4, -32}, {-4, -21}, {3, -21}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiQ.u, addQu.y) annotation(
    Line(points = {{-35, -32}, {-41, -32}, {-41, -11}, {-71, -11}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiV.y, addPiV.u1) annotation(
    Line(points = {{22, 109}, {31, 109}, {31, 89}, {38, 89}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiP.y, addPiP.u1) annotation(
    Line(points = {{21, 199}, {29, 199}, {29, 192}, {38, 192}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiP.u, addPAuxPu.y) annotation(
    Line(points = {{-2, 199}, {-25, 199}, {-25, 186}, {-44, 186}}, color = {0, 0, 127}));
  connect(currentLimiter.idConvRefPu, multiSwitchD.y) annotation(
    Line(points = {{179, 13}, {115, 13}, {115, 83}}, color = {0, 0, 127}));
  connect(currentLimiter.iqConvRefPu, multiSwitchQ.y) annotation(
    Line(points = {{179, 5}, {170, 5}, {170, -77}}, color = {0, 0, 127}));
  connect(sqrt1.y, uMagPu) annotation(
    Line(points = {{-118, -205}, {-98, -205}, {-98, -224}, {260, -224}}, color = {0, 0, 127}));
  connect(currentLimiter.idConvRefLimPu, idConvRefPu) annotation(
    Line(points = {{201, 5}, {259, 5}, {259, 4}}, color = {0, 0, 127}));
  connect(currentLimiter.iqConvRefLimPu, iqConvRefPu) annotation(
    Line(points = {{201, 13}, {223, 13}, {223, 19}, {259, 19}}, color = {0, 0, 127}));
  connect(UdFilterPu, product.u1) annotation(
    Line(points = {{-285, 40}, {-248, 40}, {-248, -224}, {-227, -224}}, color = {0, 0, 127}));
  connect(product.u2, UdFilterPu) annotation(
    Line(points = {{-227, -236}, {-248, -236}, {-248, 40}, {-285, 40}}, color = {0, 0, 127}));
  connect(UqFilterPu, product1.u1) annotation(
    Line(points = {{-285, -125}, {-243, -125}, {-243, -184}, {-229, -184}}, color = {0, 0, 127}));
  connect(UqFilterPu, product1.u2) annotation(
    Line(points = {{-285, -125}, {-243, -125}, {-243, -196}, {-229, -196}}, color = {0, 0, 127}));
  connect(lvrtFrz.Frz, integratorSetFreezePiV.freeze) annotation(
    Line(points = {{-54, -205}, {-49, -205}, {-49, 81}, {5, 81}, {5, 97}}, color = {255, 0, 255}));
  connect(feedbackV.y, integratorSetFreezePiV.u) annotation(
    Line(points = {{-166, 0}, {-156, 0}, {-156, 88}, {-10, 88}, {-10, 109}, {-1, 109}}, color = {0, 0, 127}));
  connect(feedbackV.y, gainPiV.u) annotation(
    Line(points = {{-166, 0}, {-156, 0}, {-156, 88}, {-10, 88}, {-10, 62}, {-2, 62}}, color = {0, 0, 127}));
  connect(lvrtFrz.Frz, integratorSetFreezePiP.freeze) annotation(
    Line(points = {{-54, -205}, {-49, -205}, {-49, 167}, {-11, 167}, {-11, 176}, {4, 176}, {4, 187}}, color = {255, 0, 255}));
  connect(lvrtFrz.Frz, integratorSetFreezePiQ.freeze) annotation(
    Line(points = {{-54, -205}, {-49, -205}, {-49, -60}, {-29, -60}, {-29, -44}}, color = {255, 0, 255}));
  connect(lvrtFrz.Frz, integratorSetFreezePiVq.freeze) annotation(
    Line(points = {{-54, -205}, {-49, -205}, {-49, -187}, {-26, -187}, {-26, -177}}, color = {255, 0, 255}));
  connect(lvrtFrz.Frz, Frz) annotation(
    Line(points = {{-54, -205}, {103, -205}, {103, -200}, {260, -200}}, color = {255, 0, 255}));
  
  annotation(
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Rectangle(extent = {{-100, 99}, {100, -99}}), Text(origin = {-2, 4}, extent = {{-87, 70}, {87, -70}}, textString = "EPRI
voltage
control")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-275, -250}, {250, 250}})));
end EpriVoltageCtrl;
