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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model EpriGFM "EPRI Grid Forming model"
  extends Parameters.CurrentControl;
  extends Parameters.VoltageControl;
  extends Parameters.Gfm;
  extends Parameters.OmegaFlag;
  extends Parameters.PLL;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA" annotation(
  Dialog(tab = "General"));

  // Line parameters
  parameter Types.PerUnit RSourcePu "Resistance in pu (base SNom, UNom), example value = 0.0015" annotation(
  Dialog(tab = "Circuit"));
  parameter Types.PerUnit XSourcePu "Reactance in pu (base SNom, UNom), example value = 0.15" annotation(
  Dialog(tab = "Circuit"));

  // Input variables
  Modelica.Blocks.Interfaces.RealInput deltaOmegaPu(start = 0) "Frequency deviation in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-460, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {20, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary input in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-460, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = - P0Pu * SystemBase.SnRef / SNom) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-460, 220}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QAuxPu(start = 0) "Auxiliary reactive power (optional input) in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-460, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = - Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-460, 180}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = U0Pu) "Voltage reference at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-460, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {502, 110}, extent = {{22, -22}, {-22, 22}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.Comptodq comptodq(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu,KIPll = KIPll, KPPll = KPPll, OmegaFlag = OmegaFlag, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, SNom = SNom, Theta0 = Theta0, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, iInj0Pu = -i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, -10}, extent = {{-29, -29}, {29, 29}}, rotation = 180)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.DQTrafo dQTrafo(OmegaFlag = OmegaFlag, Theta0 = Theta0, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {170, 110}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.EpriCurrentControl epriCurrentControl(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, KIi = KIi, KPi = KPi, LFilterPu = XSourcePu, OmegaFlag = OmegaFlag, RFilterPu = RSourcePu, Theta0 = Theta0, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, UqConv0Pu = UqConv0Pu, UqFilter0Pu = UqFilter0Pu, tE = tE) annotation(
    Placement(visible = true, transformation(origin = {70, 110}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.EpriVoltageControl epriVoltageControl(IMaxPu = IMaxPu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, KIp = KIp, KIv = KIv, KPp = KPp, KPv = KPv, OmegaDroopPu = OmegaDroopPu, OmegaFlag = OmegaFlag, PGen0Pu = -P0Pu * SystemBase.SnRef / SNom, PQFlag = PQFlag, QDroopPu = QDroopPu, QGen0Pu = -Q0Pu * SystemBase.SnRef / SNom, Theta0 = Theta0, UDipPu = UDipPu, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-106, 110}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls.GFM gfm(DD = DD, DeltaOmegaMaxPu = DeltaOmegaMaxPu, DeltaOmegaMinPu = DeltaOmegaMinPu, K1 = K1, K2 = K2, K2Dvoc = K2Dvoc, KD = KD, MF = MF, OmegaFlag = OmegaFlag, PGen0Pu = -P0Pu * SystemBase.SnRef / SNom, QGen0Pu = -Q0Pu * SystemBase.SnRef / SNom, Theta0 = Theta0, URef0Pu = U0Pu, UdFilter0Pu = UdFilter0Pu, tF = tF, tR = tR, tV = tV) annotation(
    Placement(visible = true, transformation(origin = {-273, 109}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorURI injectorURI(i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {268, 110}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = RSourcePu / SNom * SystemBase.SnRef, XPu = XSourcePu / SNom * SystemBase.SnRef) annotation(
    Placement(visible = true, transformation(origin = {352, 110}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {428, 110}, extent = {{-31, 31}, {31, -31}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.PolarToComplex polarToComplex annotation(
    Placement(visible = true, transformation(origin = {180, -260}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KIPll, Kp = KPPll, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {240, -162}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {60, -280}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.Product product annotation(
    Placement(visible = true, transformation(origin = {340, -200}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant OmegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {380, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant constant2(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-118, -180}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-2, -220}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant one(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-120, -260}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Initial parameters given by the user
  parameter Types.ActivePowerPu P0Pu "Start value of the active power at the converter's terminal in pu (base SnRef) (receptor convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of the reactive power at the converter's terminal in pu (base SnRef) (receptor convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
  Dialog(tab = "Initial"));
  parameter Types.VoltageModulePu U0Pu "Start value of voltage at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));

  // Initial parameters calculated by the initialization algorithm
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at converter's terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));

equation
  line.switchOffSignal1.value = injectorURI.switchOffSignal1.value;
  line.switchOffSignal2.value = injectorURI.switchOffSignal2.value;

  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{459, 110}, {502, 110}}, color = {0, 0, 255}));
  connect(line.terminal2, measurements.terminal1) annotation(
    Line(points = {{372, 110}, {397, 110}}, color = {0, 0, 255}));
  connect(dQTrafo.urSourcePu, injectorURI.urPu) annotation(
    Line(points = {{203, 122}, {234, 122}}, color = {0, 0, 127}));
  connect(dQTrafo.uiSourcePu, injectorURI.uiPu) annotation(
    Line(points = {{203, 97.7}, {234, 97.7}}, color = {0, 0, 127}));
  connect(comptodq.udFilterPu, epriCurrentControl.udFilterPu) annotation(
    Line(points = {{58.1, -15.8}, {-23.3, -15.8}, {-23.3, 104.2}, {37.1, 104.2}}, color = {23, 156, 125}));
  connect(comptodq.udFilterPu, epriVoltageControl.UdFilterPu) annotation(
    Line(points = {{58.1, -15.8}, {-151.3, -15.8}, {-151.3, 101.2}, {-138.9, 101.2}}, color = {23, 156, 125}));
  connect(gfm.udFilterRefPu, epriVoltageControl.UdFilterRefPu) annotation(
    Line(points = {{-240, 127}, {-190.45, 127}, {-190.45, 92}, {-139, 92}}, color = {0, 0, 127}));
  connect(measurements.PPu, epriVoltageControl.PPu) annotation(
    Line(points = {{409.4, 75.9}, {408.4, 75.9}, {408.4, 177.9}, {-147.6, 177.9}, {-147.6, 121.9}, {-138.6, 121.9}}, color = {23, 156, 125}));
  connect(measurements.QPu, epriVoltageControl.QPu) annotation(
    Line(points = {{421.8, 75.9}, {421.8, 119.9}, {417.8, 119.9}, {417.8, 199.9}, {-154.2, 199.9}, {-154.2, 115.9}, {-139.2, 115.9}}, color = {23, 156, 125}));
  connect(gfm.theta, comptodq.thetaGFM) annotation(
    Line(points = {{-240, 109}, {-240, 107.5}, {-208, 107.5}, {-208, 66}, {155, 66}, {155, 13.5}, {125, 13.5}, {125, 7}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gfm.theta, dQTrafo.theta) annotation(
    Line(points = {{-240, 109}, {-240, 107.5}, {-208, 107.5}, {-208, 66}, {156, 66}, {156, 77}, {155, 77}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(epriVoltageControl.iqConvRefPu, epriCurrentControl.iqConvRefPu) annotation(
    Line(points = {{-73, 92}, {-32, 92}, {-32, 128}, {37, 128}}, color = {0, 0, 127}));
  connect(epriVoltageControl.idConvRefPu, epriCurrentControl.idConvRefPu) annotation(
    Line(points = {{-73, 128}, {-29, 128}, {-29, 134}, {37, 134}}, color = {0, 0, 127}));
  connect(gfm.QPu, measurements.QPu) annotation(
    Line(points = {{-306, 109}, {-306, 106.5}, {-380, 106.5}, {-380, -100}, {422, -100}, {422, 76}}, color = {0, 170, 127}));
  connect(measurements.PPu, gfm.PPu) annotation(
    Line(points = {{409.4, 75.9}, {410.4, 75.9}, {410.4, -64.1}, {-359.6, -64.1}, {-359.6, 114.4}, {-305.6, 114.4}, {-305.6, 114.9}}, color = {0, 170, 127}));
  connect(comptodq.uqFilterPu, epriCurrentControl.uqFilterPu) annotation(
    Line(points = {{58.1, -21.6}, {4, -21.6}, {4, 98.4}, {37.1, 98.4}}, color = {0, 170, 127}));
  connect(comptodq.uqFilterPu, epriVoltageControl.UqFilterPu) annotation(
    Line(points = {{58.1, -21.6}, {-160, -21.6}, {-160, 107.4}, {-138.9, 107.4}}, color = {0, 170, 127}));
  connect(comptodq.idConvPu, epriCurrentControl.idConvPu) annotation(
    Line(points = {{58.1, 7.4}, {-14, 7.4}, {-14, 119.4}, {37.1, 119.4}}, color = {0, 0, 127}));
  connect(comptodq.iqConvPu, epriCurrentControl.iqConvPu) annotation(
    Line(points = {{58.1, 1.6}, {-2, 1.6}, {-2, 112}, {37.1, 112}, {37.1, 112.6}}, color = {0, 0, 127}));
  connect(epriCurrentControl.udConvRefPu, dQTrafo.udConvRefPu) annotation(
    Line(points = {{103, 122}, {137, 122}}, color = {0, 0, 127}));
  connect(epriCurrentControl.uqConvRefPu, dQTrafo.uqConvRefPu) annotation(
    Line(points = {{103, 98}, {137, 98}}, color = {0, 0, 127}));
  connect(PAuxPu, gfm.PAuxPu) annotation(
    Line(points = {{-460, -40}, {-291, -40}, {-291, 76}}, color = {166, 187, 200}));
  connect(PAuxPu, epriVoltageControl.PAuxPu) annotation(
    Line(points = {{-460, -40}, {-127, -40}, {-127, 77}}, color = {166, 187, 200}));
  connect(QAuxPu, gfm.QAuxPu) annotation(
    Line(points = {{-460, -80}, {-285, -80}, {-285, 76}}, color = {166, 187, 200}));
  connect(QAuxPu, epriVoltageControl.QAuxPu) annotation(
    Line(points = {{-460, -80}, {-121, -80}, {-121, 77}}, color = {166, 187, 200}));
  connect(URefPu, gfm.URefPu) annotation(
    Line(points = {{-460, 100}, {-306, 100}}, color = {166, 187, 200}));
  connect(PRefPu, epriVoltageControl.PRefPu) annotation(
    Line(points = {{-460, 220}, {-160, 220}, {-160, 137}, {-139, 137}}, color = {166, 187, 200}));
  connect(PRefPu, gfm.PRefPu) annotation(
    Line(points = {{-460, 220}, {-381, 220}, {-381, 128}, {-306, 128}, {-306, 130}}, color = {166, 187, 200}));
  connect(QRefPu, epriVoltageControl.QRefPu) annotation(
    Line(points = {{-460, 180}, {-168, 180}, {-168, 131}, {-139, 131}}, color = {166, 187, 200}));
  connect(QRefPu, gfm.QRefPu) annotation(
    Line(points = {{-460, 180}, {-340.5, 180}, {-340.5, 124}, {-306, 124}}, color = {166, 187, 200}));
  connect(deltaOmegaPu, epriVoltageControl.deltaOmegaPu) annotation(
    Line(points = {{-460, 140}, {-174, 140}, {-174, 83}, {-139, 83}}, color = {166, 187, 200}));
  connect(measurements.iPu, comptodq.iInjPu) annotation(
    Line(points = {{446.6, 75.9}, {446.6, -15.1}, {124.6, -15.1}}, color = {85, 170, 255}));
  connect(injectorURI.terminal, line.terminal1) annotation(
    Line(points = {{303.65, 109.07}, {331.65, 109.07}}, color = {0, 0, 255}));
  connect(polarToComplex.len, switch1.y) annotation(
    Line(points = {{156, -248}, {156, -248.5}, {120, -248.5}, {120, -220}, {22, -220}}, color = {0, 0, 127}));
  connect(one.y, switch1.u3) annotation(
    Line(points = {{-98, -260}, {-60.5, -260}, {-60.5, -238}, {-28, -238}}, color = {0, 0, 127}));
  connect(zero.y, polarToComplex.phi) annotation(
    Line(points = {{82, -280}, {120, -280}, {120, -272}, {156, -272}}, color = {0, 0, 127}));
  connect(OmegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{358, -140}, {332, -140}, {332, -150}, {262, -150}}, color = {0, 0, 127}));
  connect(constant2.y, switch1.u1) annotation(
    Line(points = {{-96, -180}, {-59, -180}, {-59, -202}, {-28, -202}}, color = {0, 0, 127}));
  connect(epriVoltageControl.Frz, switch1.u2) annotation(
    Line(points = {{-83.8, 77}, {-83.8, -220}, {-28, -220}}, color = {255, 0, 255}));
  connect(gfm.omegaPLLPu, pll.omegaPLLPu) annotation(
    Line(points = {{-306, 91}, {-338, 91}, {-338, -83}, {140, -83}, {140, -172}, {218, -172}}, color = {0, 0, 127}));
  connect(pll.phi, dQTrafo.phi) annotation(
    Line(points = {{218, -164}, {180, -164}, {180, 78}}, color = {0, 0, 127}));
  connect(measurements.uPu, product.u2) annotation(
    Line(points = {{434, 76}, {436, 76}, {436, -188}, {364, -188}}, color = {85, 170, 255}));
  connect(polarToComplex.y, product.u1) annotation(
    Line(points = {{202, -260}, {400, -260}, {400, -212}, {364, -212}}, color = {85, 170, 255}));
  connect(measurements.uPu, comptodq.uInjPu) annotation(
    Line(points = {{434, 76}, {436, 76}, {436, -28}, {124, -28}}, color = {85, 170, 255}));
  connect(product.y, pll.uPu) annotation(
    Line(points = {{318, -200}, {280, -200}, {280, -174}, {262, -174}}, color = {85, 170, 255}));
  connect(pll.phi, comptodq.phi) annotation(
    Line(points = {{218, -164}, {180, -164}, {180, 2}, {124, 2}}, color = {0, 0, 127}));
  connect(gfm.omegaPu, epriCurrentControl.omegaPu) annotation(
    Line(points = {{-240, 92}, {-224, 92}, {-224, 56}, {20, 56}, {20, 86}, {38, 86}}, color = {0, 0, 127}));
  connect(OmegaRefPu.y, gfm.omegaRefPu) annotation(
    Line(points = {{358, -140}, {-322, -140}, {-322, 82}, {-306, 82}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-440, -300}, {480, 300}})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 3}, extent = {{-88, 59}, {88, -59}}, textString = "EPRI
GFM")}),
  Documentation(info = "<html><head></head><body><div>The Generic EPRI GFM model is implemented following the documentation on&nbsp;<span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">EPRI</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">&nbsp;website:&nbsp;https://www.epri.com/research/products/000000003002021403.</span></div><div>It offers four control modes:</div><div>1 - Droop based, OmegaFlag = 1</div><div>2 - Virtual Synchronous Machine (VSM), OmegaFlag = 2</div><div>3 - Dispatchable Virtual Oscillator (dVOC) based GFM, OmegaFlag = 3</div><div>4- Phase Locked Loop (Grid following mode), OmegaFlag = 0</div><div><br></div><div>For more detail about the implementation see&nbsp;</div><div>https://colib.net/pages/models/generations/Sources/epri_gfm/</div></body></html>"));
end EpriGFM;
