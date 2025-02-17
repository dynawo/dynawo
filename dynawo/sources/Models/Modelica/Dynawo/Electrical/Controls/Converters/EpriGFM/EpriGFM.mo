within Dynawo.Electrical.Controls.Converters.EpriGFM;

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

model EpriGFM "EPRI Grid Forming model"
  extends Parameters.InitialTerminalUi;
  extends Parameters.SNom;
  extends Parameters.Circuit;
  extends Parameters.Gfm;
  extends Parameters.InitialGfm;
  extends Parameters.CurrentCtrl;
  extends Parameters.InitialCurrentCtrl;
  extends Parameters.VoltageCtrl;
  extends Parameters.InitialVoltageCtrl;
  extends Parameters.Pll;
  extends Parameters.Pref0Pu_;
  
  //inputs
  Modelica.Blocks.Interfaces.RealInput deltaOmegaPu(start = 0) "Frequency deviation in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-420, 104}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {20, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary input in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-420, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-420, 180}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QAuxPu(start = 0) "Auxiliary reactive power (optional input) in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-420, -160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-420, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UdFilterRefPu(start = UdFilter0Pu) " D-axis voltage reference at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-420, 24}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.Comptodq comptodq(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu,KIPll = KIPll, KPPll = KPPll, OmegaFlag = OmegaFlag, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, SNom = SNom, Theta0 = Theta0, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {120, -60}, extent = {{-23, -23}, {23, 23}}, rotation = 180)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.DQTrafo dQTrafo(OmegaFlag = OmegaFlag, Theta0 = Theta0, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 30}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.EpriCurrentCtrl epriCurrentCtrl(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, KIi = KIi, KPi = KPi, LFilterPu = LFilterPu, RFilterPu = RFilterPu, Theta0 = Theta0, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, UqConv0Pu = UqConv0Pu, UqFilter0Pu = UqFilter0Pu, tE = tE) annotation(
    Placement(visible = true, transformation(origin = {50, 26}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.EpriVoltageCtrl epriVoltageCtrl(IMaxPu = IMaxPu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, KIp = KIp, KIv = KIv, KPp = KPp, KPv = KPv, OmegaDroopPu = OmegaDroopPu, OmegaFlag = OmegaFlag, PQflag = PQflag, PRef0Pu = PRef0Pu, QDroopPu = QDroopPu, QRef0Pu = QRef0Pu, Theta0 = Theta0, UDipPu = UDipPu, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-99, 35}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.GFM gfm(DD = DD, DeltaOmegaMaxPu = DeltaOmegaMaxPu, DeltaOmegaMinPu = DeltaOmegaMinPu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, K1 = K1, K2 = K2, K2Dvoc = K2Dvoc, KD = KD, MF = MF, OmegaFlag = OmegaFlag, PFilter0Pu = PFilter0Pu, PRef0Pu = PRef0Pu, QFilter0Pu = QFilter0Pu, QRef0Pu = QRef0Pu, Theta0 = Theta0, UFilterRef0Pu = UFilterRef0Pu, tF = tF, tR = tR, tV = tV) annotation(
    Placement(visible = true, transformation(origin = {-250, 30}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorURI injectorURI(i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {190, 30}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = BPu / SNom * SystemBase.SnRef, GPu = GPu / SNom * SystemBase.SnRef, RPu = RPu / SNom * SystemBase.SnRef, XPu = XPu / SNom * SystemBase.SnRef, state(start = Dynawo.Electrical.Constants.state.Closed)) annotation(
    Placement(visible = true, transformation(origin = {260, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {344, 30}, extent = {{-19, 19}, {19, -19}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {410, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(injectorURI.terminal, line.terminal1) annotation(
    Line(points = {{207.25, 29.55}, {223.25, 29.55}, {223.25, 30}, {240, 30}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{363, 30}, {387, 30}, {387, 29}, {415, 29}}, color = {0, 0, 255}));
  connect(line.terminal2, measurements.terminal1) annotation(
    Line(points = {{280, 30}, {325, 30}}, color = {0, 0, 255}));
  connect(dQTrafo.urSourcePu, injectorURI.urPu) annotation(
    Line(points = {{147.6, 36.4}, {158.6, 36.4}, {158.6, 35.4}, {170.1, 35.4}}, color = {0, 0, 127}));
  connect(dQTrafo.uiSourcePu, injectorURI.uiPu) annotation(
    Line(points = {{147.6, 23.76}, {158.6, 23.76}, {158.6, 22.76}, {169.6, 22.76}}, color = {0, 0, 127}));
  connect(comptodq.udFilterPu, epriCurrentCtrl.udFilterPu) annotation(
    Line(points = {{95, -65}, {-23.3, -65}, {-23.3, 21}, {21, 21}}, color = {23, 156, 125}));
  connect(comptodq.udFilterPu, epriVoltageCtrl.UdFilterPu) annotation(
    Line(points = {{95, -65}, {-143.3, -65}, {-143.3, 27.5}, {-126.5, 27.5}}, color = {23, 156, 125}));
  connect(gfm.udFilterRefPu, epriVoltageCtrl.UdFilterRefPu) annotation(
    Line(points = {{-225, 44}, {-190.45, 44}, {-190.45, 20}, {-126.5, 20}}, color = {0, 0, 127}));
  connect(comptodq.omegaPLLPu, gfm.omegaPLLPu) annotation(
    Line(points = {{95, -42}, {-287.3, -42}, {-287.3, 16}, {-275, 16}}, color = {23, 156, 125}));
  connect(measurements.uPu, comptodq.uInjPu) annotation(
    Line(points = {{348, 9}, {348, -74}, {148, -74}}, color = {85, 170, 255}));
  connect(measurements.uPu, dQTrafo.uInjPu) annotation(
    Line(points = {{348, 9}, {348, -72}, {184, -72}, {184, 4}, {108, 4}, {108, 18}, {112, 18}}, color = {85, 170, 255}));
  connect(measurements.PPu, epriVoltageCtrl.PPu) annotation(
    Line(points = {{333, 9}, {333, -10}, {370, -10}, {370, 90}, {-150, 90}, {-150, 45}, {-126.5, 45}}, color = {23, 156, 125}));
  connect(measurements.QPu, epriVoltageCtrl.QPu) annotation(
    Line(points = {{340, 9}, {340, -6}, {366, -6}, {366, 86}, {-146, 86}, {-146, 40}, {-126.5, 40}}, color = {23, 156, 125}));
  connect(gfm.theta, comptodq.thetaGFM) annotation(
    Line(points = {{-225, 30}, {-210, 30}, {-210, -12}, {172, -12}, {172, -46}, {148, -46}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gfm.theta, dQTrafo.theta) annotation(
    Line(points = {{-225, 30}, {-210, 30}, {-210, -12}, {100, -12}, {100, 24}, {112, 24}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gfm.omegaPu, epriCurrentCtrl.omegaPu) annotation(
    Line(points = {{-225, 16}, {-217.7, 16}, {-217.7, -3.8}, {12.3, -3.8}, {12.3, 8}, {21, 8}}, color = {0, 0, 127}));
  connect(epriVoltageCtrl.iqConvRefPu, epriCurrentCtrl.iqConvRefPu) annotation(
    Line(points = {{-71.5, 20}, {-65, 20}, {-65, 42}, {21, 42}}, color = {0, 0, 127}));
  connect(epriVoltageCtrl.idConvRefPu, epriCurrentCtrl.idConvRefPu) annotation(
    Line(points = {{-71.5, 50}, {-25.25, 50}, {-25.25, 47}, {21, 47}}, color = {0, 0, 127}));
  connect(gfm.QPu, measurements.QPu) annotation(
    Line(points = {{-275, 30}, {-286, 30}, {-286, 86}, {366, 86}, {366, -6}, {340, -6}, {340, 9}}, color = {0, 170, 127}));
  connect(measurements.PPu, gfm.PPu) annotation(
    Line(points = {{333, 9}, {332, 9}, {332, -10}, {370, -10}, {370, 90}, {-292, 90}, {-292, 35}, {-275, 35}}, color = {0, 170, 127}));
  connect(comptodq.uqFilterPu, epriCurrentCtrl.uqFilterPu) annotation(
    Line(points = {{95, -69}, {4, -69}, {4, 16}, {22, 16}}, color = {0, 170, 127}));
  connect(comptodq.uqFilterPu, epriVoltageCtrl.UqFilterPu) annotation(
    Line(points = {{95, -69}, {-154, -69}, {-154, 32}, {-126, 32}}, color = {0, 170, 127}));
  connect(comptodq.idConvPu, epriCurrentCtrl.idConvPu) annotation(
    Line(points = {{95, -46}, {-14, -46}, {-14, 34}, {22, 34}}, color = {0, 0, 127}));
  connect(comptodq.iqConvPu, epriCurrentCtrl.iqConvPu) annotation(
    Line(points = {{95, -51}, {-2, -51}, {-2, 26}, {22, 26}, {22, 28}}, color = {0, 0, 127}));
  connect(epriCurrentCtrl.udConvRefPu, dQTrafo.udConvRefPu) annotation(
    Line(points = {{78, 42}, {112, 42}}, color = {0, 0, 127}));
  connect(epriCurrentCtrl.uqConvRefPu, dQTrafo.uqConvRefPu) annotation(
    Line(points = {{78, 10}, {90, 10}, {90, 36}, {112, 36}}, color = {0, 0, 127}));
  connect(PAuxPu, gfm.PAuxPu) annotation(
    Line(points = {{-420, -120}, {-264, -120}, {-264, 5}}, color = {166, 187, 200}));
  connect(PAuxPu, epriVoltageCtrl.PAuxPu) annotation(
    Line(points = {{-420, -120}, {-116, -120}, {-116, 8}}, color = {166, 187, 200}));
  connect(QAuxPu, gfm.QAuxPu) annotation(
    Line(points = {{-420, -160}, {-259, -160}, {-259, 5}}, color = {166, 187, 200}));
  connect(QAuxPu, epriVoltageCtrl.QAuxPu) annotation(
    Line(points = {{-420, -160}, {-112, -160}, {-112, 8}}, color = {166, 187, 200}));
  connect(UdFilterRefPu, gfm.URefPu) annotation(
    Line(points = {{-420, 24}, {-348, 24}, {-348, 23}, {-275, 23}}, color = {166, 187, 200}));
  connect(PRefPu, epriVoltageCtrl.PRefPu) annotation(
    Line(points = {{-420, 180}, {-160, 180}, {-160, 58}, {-126, 58}}, color = {166, 187, 200}));
  connect(PRefPu, gfm.PRefPu) annotation(
    Line(points = {{-420, 180}, {-332, 180}, {-332, 46}, {-275, 46}}, color = {166, 187, 200}));
  connect(QRefPu, epriVoltageCtrl.QRefPu) annotation(
    Line(points = {{-420, 140}, {-168, 140}, {-168, 52}, {-126, 52}}, color = {166, 187, 200}));
  connect(QRefPu, gfm.QRefPu) annotation(
    Line(points = {{-420, 140}, {-338, 140}, {-338, 41.5}, {-275, 41.5}}, color = {166, 187, 200}));
  connect(deltaOmegaPu, epriVoltageCtrl.deltaOmegaPu) annotation(
    Line(points = {{-420, 104}, {-174, 104}, {-174, 12}, {-126, 12}}, color = {166, 187, 200}));
  connect(epriVoltageCtrl.Frz, comptodq.Frz) annotation(
    Line(points = {{-80, 8}, {-80, -20}, {133, -20}, {133, -32}}, color = {255, 0, 255}));
  connect(measurements.iPu, comptodq.iInjPu) annotation(
    Line(points = {{356, 10}, {356, -64}, {148, -64}}, color = {85, 170, 255}));
  
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-400, -200}, {400, 200}})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 3}, extent = {{-88, 59}, {88, -59}}, textString = "EPRI
GFM")}));
end EpriGFM;
