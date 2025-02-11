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

model EpriVoltageControl "Voltage controller in EPRI Grid Forming model"
  extends Parameters.VoltageControl;
  extends Parameters.OmegaFlag;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput deltaOmegaPu(start = 0) "frequency deviation in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-285, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary active power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-285, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = PGen0Pu) "active power at converter's terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-285, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PGen0Pu) "Active power reference in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-285, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QAuxPu(start = 0) "Auxiliary reactive power (optional input) in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-285, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = QGen0Pu) "Reactive power at converter's terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-285, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QGen0Pu) "Reactive power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-285, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdFilterPu(start = UdFilter0Pu) "Measured d-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-284, 59}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdFilterRefPu(start = UdFilter0Pu) "D-axis voltage reference at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-284, 29}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UqFilterPu(start = UqFilter0Pu) "Measured q-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-285, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = IdConv0Pu) "D-axis current reference in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {260, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = (if OmegaFlag == 0 then -1 else 1) * IqConv0Pu) "Q-axis current reference in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {260, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-170, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {50, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPiP annotation(
    Placement(visible = true, transformation(origin = {50, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPiQ annotation(
    Placement(visible = true, transformation(origin = {51, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPiV annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-135, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {-80, -130}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackQ annotation(
    Placement(visible = true, transformation(origin = {-180, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackV annotation(
    Placement(visible = true, transformation(origin = {-179, 29}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput Frz annotation(
    Placement(visible = true, transformation(origin = {260, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {74, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gain7(k = KPv) annotation(
    Placement(visible = true, transformation(origin = {-1, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainInvertSign(k = -1) annotation(
    Placement(visible = true, transformation(origin = {90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainPiP(k = KPp) annotation(
    Placement(visible = true, transformation(origin = {0, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainPiQ(k = KPv) annotation(
    Placement(visible = true, transformation(origin = {0, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainPiV(k = KPv) annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainQDroop(k = QDroopPu) annotation(
    Placement(visible = true, transformation(origin = {-140, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant1(k = OmegaFlag) annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorSetFreeze integratorSetFreezePiP(K = KIp, UseFreeze = true, Y0 = IdConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorSetFreeze integratorSetFreezePiQ(K = KIv, UseFreeze = true, Y0 = IqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorSetFreeze integratorSetFreezePiV(K = KIv, UseFreeze = true, Y0 = IdConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorSetFreeze integratorSetFreezePiVq(K = KIv, UseFreeze = true, Y0 = IqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-1, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.LvrtFrz lvrtFrz(UDipPu = UDipPu, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchD(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {149, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchQ(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-220, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-220, -190}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uMagPu annotation(
    Placement(visible = true, transformation(origin = {260, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {44, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Sum sum1(k = {1, 1, -1, -1 / OmegaDroopPu}, nin = 4)  annotation(
    Placement(visible = true, transformation(origin = {-100, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum11(k = {1, 1, 1}, nin = 3)  annotation(
    Placement(visible = true, transformation(origin = {-100, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiterid(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy, limitsAtInit = true)  annotation(
    Placement(visible = true, transformation(origin = {200, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiteriq(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy, limitsAtInit = true)  annotation(
    Placement(visible = true, transformation(origin = {201, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.CurrentLimitsCalculation currentLimitsCalculation(IMaxPu = IMaxPu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, OmegaFlag = OmegaFlag, PQFlag = PQFlag)  annotation(
    Placement(visible = true, transformation(origin = {200, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.NonElectrical.Blocks.Continuous.SqrtNoEvent sqrtNoEvent annotation(
    Placement(visible = true, transformation(origin = {-130, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.ActivePowerPu PGen0Pu "Start value of the active power at the converter's terminal in pu (base SNom) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.ReactivePowerPu QGen0Pu "Start value of the reactive power at the converter's terminal in pu (base SNom) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
  Dialog(tab = "Initial"));

equation
  connect(feedbackV.u1, UdFilterRefPu) annotation(
    Line(points = {{-187, 29}, {-284, 29}}, color = {0, 0, 127}));
  connect(feedbackV.u2, UdFilterPu) annotation(
    Line(points = {{-179, 37}, {-179, 59}, {-284, 59}}, color = {0, 0, 127}));
  connect(feedbackQ.y, gainQDroop.u) annotation(
    Line(points = {{-171, -60}, {-152, -60}}, color = {0, 0, 127}));
  connect(QPu, feedbackQ.u2) annotation(
    Line(points = {{-285, -80}, {-180.5, -80}, {-180.5, -69}, {-180.25, -69}, {-180.25, -68}, {-180, -68}}, color = {0, 0, 127}));
  connect(QRefPu, feedbackQ.u1) annotation(
    Line(points = {{-285, -60}, {-188, -60}}, color = {0, 0, 127}));
  connect(addPiQ.y, gainInvertSign.u) annotation(
    Line(points = {{62, -30}, {78, -30}}, color = {0, 0, 127}));
  connect(constant1.y, feedback4.u1) annotation(
    Line(points = {{-124, -130}, {-88, -130}}, color = {0, 0, 127}));
  connect(feedback4.u2, UqFilterPu) annotation(
    Line(points = {{-80, -122}, {-80, -110}, {-285, -110}}, color = {0, 0, 127}));
  connect(integerConstant1.y, multiSwitchD.f) annotation(
    Line(points = {{121, 40}, {150, 40}, {150, 143}, {149, 143}, {149, 142}}, color = {255, 127, 0}));
  connect(integerConstant1.y, multiSwitchQ.f) annotation(
    Line(points = {{121, 40}, {150, 40}, {150, -68}}, color = {255, 127, 0}));
  connect(add.y, sqrtNoEvent.u) annotation(
    Line(points = {{-159, -210}, {-142, -210}}, color = {0, 0, 127}));
  connect(product.y, add.u2) annotation(
    Line(points = {{-209, -230}, {-190, -230}, {-190, -216}, {-182, -216}}, color = {0, 0, 127}));
  connect(product1.y, add.u1) annotation(
    Line(points = {{-209, -190}, {-190.5, -190}, {-190.5, -204}, {-182, -204}}, color = {0, 0, 127}));
  connect(sqrtNoEvent.y, lvrtFrz.UPu) annotation(
    Line(points = {{-119, -210}, {-81, -210}}, color = {0, 0, 127}));
  connect(sqrtNoEvent.y, uMagPu) annotation(
    Line(points = {{-119, -210}, {-100.5, -210}, {-100.5, -230}, {260, -230}}, color = {0, 0, 127}));
  connect(UdFilterPu, product.u1) annotation(
    Line(points = {{-284, 59}, {-250, 59}, {-250, -224}, {-232, -224}}, color = {0, 0, 127}));
  connect(product.u2, UdFilterPu) annotation(
    Line(points = {{-232, -236}, {-250, -236}, {-250, 59}, {-284, 59}}, color = {0, 0, 127}));
  connect(UqFilterPu, product1.u1) annotation(
    Line(points = {{-285, -110}, {-240, -110}, {-240, -184}, {-232, -184}}, color = {0, 0, 127}));
  connect(UqFilterPu, product1.u2) annotation(
    Line(points = {{-285, -110}, {-240, -110}, {-240, -196}, {-232, -196}}, color = {0, 0, 127}));
  connect(lvrtFrz.Frz, integratorSetFreezePiV.freeze) annotation(
    Line(points = {{-59, -210}, {-50, -210}, {-50, 40}, {-6, 40}, {-6, 48}}, color = {255, 0, 255}));
  connect(lvrtFrz.Frz, integratorSetFreezePiP.freeze) annotation(
    Line(points = {{-59, -210}, {-50, -210}, {-50, 140}, {-6, 140}, {-6, 147}, {-6.25, 147}, {-6.25, 148}, {-6, 148}}, color = {255, 0, 255}));
  connect(lvrtFrz.Frz, integratorSetFreezePiQ.freeze) annotation(
    Line(points = {{-59, -210}, {-50, -210}, {-50, -70}, {-6, -70}, {-6, -62}}, color = {255, 0, 255}));
  connect(lvrtFrz.Frz, integratorSetFreezePiVq.freeze) annotation(
    Line(points = {{-59, -210}, {-50, -210}, {-50, -170}, {-7, -170}, {-7, -162}}, color = {255, 0, 255}));
  connect(lvrtFrz.Frz, Frz) annotation(
    Line(points = {{-59, -210}, {260, -210}}, color = {255, 0, 255}));
  connect(PRefPu, sum1.u[2]) annotation(
    Line(points = {{-285, 180}, {-112, 180}}, color = {0, 0, 127}));
  connect(PPu, sum1.u[3]) annotation(
    Line(points = {{-285, 160}, {-150, 160}, {-150, 180}, {-112, 180}}, color = {0, 0, 127}));
  connect(deltaOmegaPu, sum1.u[4]) annotation(
    Line(points = {{-285, 140}, {-150, 140}, {-150, 180}, {-112, 180}}, color = {0, 0, 127}));
  connect(PAuxPu, sum1.u[1]) annotation(
    Line(points = {{-285, 200}, {-150, 200}, {-150, 180}, {-112, 180}}, color = {0, 0, 127}));
  connect(sum1.y, gainPiP.u) annotation(
    Line(points = {{-89, 180}, {-40, 180}, {-40, 200}, {-12, 200}}, color = {0, 0, 127}));
  connect(QAuxPu, sum11.u[2]) annotation(
    Line(points = {{-285, -30}, {-112, -30}}, color = {0, 0, 127}));
  connect(feedbackV.y, sum11.u[1]) annotation(
    Line(points = {{-170, 29}, {-120, 29}, {-120, -30}, {-112, -30}}, color = {0, 0, 127}));
  connect(gainQDroop.y, sum11.u[3]) annotation(
    Line(points = {{-129, -60}, {-120, -60}, {-120, -30}, {-112, -30}}, color = {0, 0, 127}));
  connect(feedbackV.y, gainPiV.u) annotation(
    Line(points = {{-170, 29}, {-120, 29}, {-120, 80}, {-40, 80}, {-40, 100}, {-12, 100}}, color = {0, 0, 127}));
  connect(feedbackV.y, integratorSetFreezePiV.u) annotation(
    Line(points = {{-170, 29}, {-120, 29}, {-120, 80}, {-40, 80}, {-40, 60}, {-12, 60}}, color = {0, 0, 127}));
  connect(sum11.y, integratorSetFreezePiQ.u) annotation(
    Line(points = {{-89, -30}, {-40, -30}, {-40, -50}, {-12, -50}}, color = {0, 0, 127}));
  connect(sum11.y, gainPiQ.u) annotation(
    Line(points = {{-89, -30}, {-40, -30}, {-40, -10}, {-12, -10}}, color = {0, 0, 127}));
  connect(gainPiP.y, addPiP.u1) annotation(
    Line(points = {{11, 200}, {30, 200}, {30, 186}, {38, 186}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiP.y, addPiP.u2) annotation(
    Line(points = {{11, 160}, {30, 160}, {30, 174}, {38, 174}}, color = {0, 0, 127}));
  connect(sum1.y, integratorSetFreezePiP.u) annotation(
    Line(points = {{-89, 180}, {-40, 180}, {-40, 160}, {-12, 160}}, color = {0, 0, 127}));
  connect(gainPiV.y, addPiV.u1) annotation(
    Line(points = {{11, 100}, {30, 100}, {30, 86}, {38, 86}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiV.y, addPiV.u2) annotation(
    Line(points = {{11, 60}, {30, 60}, {30, 74}, {38, 74}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiQ.y, addPiQ.u2) annotation(
    Line(points = {{11, -50}, {30, -50}, {30, -36}, {39, -36}}, color = {0, 0, 127}));
  connect(gainPiQ.y, addPiQ.u1) annotation(
    Line(points = {{11, -10}, {30, -10}, {30, -24}, {39, -24}}, color = {0, 0, 127}));
  connect(gain7.y, add5.u1) annotation(
    Line(points = {{10, -110}, {29, -110}, {29, -124}, {38, -124}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiVq.y, add5.u2) annotation(
    Line(points = {{10, -150}, {29, -150}, {29, -136}, {38, -136}}, color = {0, 0, 127}));
  connect(feedback4.y, gain7.u) annotation(
    Line(points = {{-71, -130}, {-40, -130}, {-40, -110}, {-13, -110}}, color = {0, 0, 127}));
  connect(feedback4.y, integratorSetFreezePiVq.u) annotation(
    Line(points = {{-71, -130}, {-39.5, -130}, {-39.5, -150}, {-13, -150}}, color = {0, 0, 127}));
  connect(multiSwitchD.y, variableLimiterid.u) annotation(
    Line(points = {{160, 130}, {188, 130}}, color = {0, 0, 127}));
  connect(variableLimiterid.y, idConvRefPu) annotation(
    Line(points = {{211, 130}, {260, 130}}, color = {0, 0, 127}));
  connect(variableLimiteriq.y, iqConvRefPu) annotation(
    Line(points = {{212, -80}, {260, -80}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.idConvRefPu, variableLimiterid.y) annotation(
    Line(points = {{211, 44}, {230, 44}, {230, 130}, {211, 130}}, color = {0, 0, 127}));
  connect(variableLimiteriq.y, currentLimitsCalculation.iqConvRefPu) annotation(
    Line(points = {{212, -80}, {230, -80}, {230, 36}, {211, 36}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.idMinPu, variableLimiterid.limit2) annotation(
    Line(points = {{189, 46}, {180, 46}, {180, 122}, {188, 122}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.idMaxPu, variableLimiterid.limit1) annotation(
    Line(points = {{189, 42}, {170, 42}, {170, 138}, {188, 138}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.iqMinPu, variableLimiteriq.limit2) annotation(
    Line(points = {{189, 38}, {170, 38}, {170, -88}, {189, -88}}, color = {0, 0, 127}));
  connect(variableLimiteriq.limit1, currentLimitsCalculation.iqMaxPu) annotation(
    Line(points = {{189, -72}, {180, -72}, {180, 34}, {189, 34}}, color = {0, 0, 127}));
  connect(multiSwitchQ.y, variableLimiteriq.u) annotation(
    Line(points = {{161, -80}, {189, -80}}, color = {0, 0, 127}));
  connect(addPiV.y, multiSwitchD.u[3]) annotation(
    Line(points = {{61, 80}, {100.5, 80}, {100.5, 130}, {139, 130}}, color = {0, 0, 127}));
  connect(addPiV.y, multiSwitchD.u[2]) annotation(
    Line(points = {{61, 80}, {100.5, 80}, {100.5, 130}, {139, 130}}, color = {0, 0, 127}));
  connect(addPiP.y, multiSwitchD.u[1]) annotation(
    Line(points = {{61, 180}, {100, 180}, {100, 130}, {139, 130}}, color = {0, 0, 127}));
  connect(addPiV.y, multiSwitchD.u[4]) annotation(
    Line(points = {{61, 80}, {100.5, 80}, {100.5, 130}, {139, 130}}, color = {0, 0, 127}));
  connect(gainInvertSign.y, multiSwitchQ.u[1]) annotation(
    Line(points = {{101, -30}, {120, -30}, {120, -80}, {140, -80}}, color = {0, 0, 127}));
  connect(add5.y, multiSwitchQ.u[2]) annotation(
    Line(points = {{61, -130}, {120, -130}, {120, -80}, {140, -80}}, color = {0, 0, 127}));
  connect(add5.y, multiSwitchQ.u[3]) annotation(
    Line(points = {{61, -130}, {120, -130}, {120, -80}, {140, -80}}, color = {0, 0, 127}));
  connect(add5.y, multiSwitchQ.u[4]) annotation(
    Line(points = {{61, -130}, {120, -130}, {120, -80}, {140, -80}}, color = {0, 0, 127}));

  annotation(
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Rectangle(extent = {{-100, 99}, {100, -99}}), Text(origin = {-2, 4}, extent = {{-87, 70}, {87, -70}}, textString = "EPRI
voltage
control")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-275, -250}, {250, 250}}), graphics = {Rectangle(origin = {-21.5, 140}, lineColor = {92, 53, 102}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-145, 100}, {146, -100}}), Rectangle(origin = {-19, -78}, lineColor = {32, 74, 135}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-147, 113}, {148, -113}}), Text(origin = {24, 127}, lineColor = {92, 53, 102}, extent = {{-109, 3}, {109, -3}}, textString = "Active current reference calculation"), Text(origin = {31, -84}, lineColor = {32, 74, 135}, extent = {{-109, 3}, {109, -3}}, textString = "Reactive current reference calculation")}));
end EpriVoltageControl;
