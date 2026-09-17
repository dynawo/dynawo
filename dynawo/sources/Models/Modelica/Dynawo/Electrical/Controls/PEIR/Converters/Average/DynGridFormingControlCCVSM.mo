within Dynawo.Electrical.Controls.PEIR.Converters.Average;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model DynGridFormingControlCCVSM

  // VSM parameters
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain";
  parameter Types.Time H "Inertia constant in s";
  parameter Types.PerUnit KDampingAngle "DampingAngle constant" ;
  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";

  // QSEM parameter
  parameter Real XVI "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control";

  // Current loop parameters
  parameter Types.PerUnit omegaC "Current Loop bandwidth (in rad/s)";
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis";
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis";

  final parameter Types.PerUnit YMax = 1.01*(Imax  * sqrt(RFilterPu*RFilterPu+(LFilterPu*LFilterPu*Omega0Pu*Omega0Pu))) "Maximum output of AntiWindUp PI controller (base UNom)";
  final parameter Types.PerUnit YMin = - YMax  "Minimum output of AntiWindUp PI controller (base UNom)";

  // Virtual impedance parameters
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.CurrentModulePu IMaxVI "Maximum current before activating the virtual impedance in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu DeltaIConvMaxPu "Maximum extra current module used to compute RVI/XVI, in pu (base UNom, SNom): bounds the virtual impedance correction regardless of how large the measured current becomes";

  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)";

  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)";

  //PLL parameters
  parameter Types.PerUnit omegaNPLL "PLL bandwidth (in rad/s)";
  parameter Types.PerUnit ZetaPLL "PLL damping ratio (dimensionless)";

  //Current Saturation parameters
  parameter Real W_CurrentLimit "Bandwidth of the current limitation";
  parameter Types.CurrentModulePu Imax "Current max threshold to limit a current's module";
  parameter Types.CurrentModulePu Imin "Current min threshold to limit a current's module";

  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 72}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -73}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-108, 40}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, -93}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -34}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-85, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -16}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-65, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {72, -108}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {62, -108}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-17, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilteredPccPu(start = UdPcc0Pu) "Filtered d-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, -78}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilteredPccPu(start = UqPcc0Pu) "Filtered q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, -92}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {17, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -64}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {67, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -52}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {87, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = PFilter0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 84}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 77}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, 96}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 33}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPccPu(re(start = u0Pu.re), im(start = u0Pu.im)) annotation(
    Placement(transformation(origin = {-108, 54}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 55}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage module reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-108, 22}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 3}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = voltageReferenceControlCC.QFilterRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-108, 6}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, -19}, extent = {{-9, -9}, {9, 9}})));

  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {107, 31}, extent = {{-7, -7}, {7, 7}}), iconTransformation(origin = {110, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 17}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(transformation(origin = {106, 86}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {106, 74}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPLL(start = Omega0Pu) "Measured frequency from the grid (base omegaNom)" annotation(
    Placement(transformation(origin = {106, 62}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls.VSM VSM(H = H, PFilter0Pu = PFilter0Pu, kVSM = kVSM, Omega0Pu = Omega0Pu, Theta0 = Theta0) annotation(
    Placement(transformation(origin = {-10, 80}, extent = {{-16, -16}, {16, 16}})));
  Modelica.Blocks.Continuous.FirstOrder PLLFilter(T = 0.01, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = Omega0Pu) annotation(
    Placement(transformation(origin = {-52, 62}, extent = {{-6, -6}, {6, 6}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.VoltageReferenceControlCC voltageReferenceControlCC(DeltaVVId0 = VICC.DeltaVVId0, DeltaVVIq0 = VICC.DeltaVVIq0, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, Kff = Kff, Mq = Mq, QFilter0Pu = QFilter0Pu, URef0Pu = URef0Pu, UdRef0Pu = UdFilter0Pu, UqRef0Pu = UqFilter0Pu, Wf = Wf, Wff = Wff, WVIFreeze = 500) annotation(
    Placement(transformation(origin = {-70, 18}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.DynQSEM QSEM(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, LFilter = LFilterPu, Omega0Pu = Omega0Pu, RFilter = RFilterPu, UdFilter0Pu = UdFilter0Pu, UdPcc0Pu = UdPcc0Pu, UqFilter0Pu = UqFilter0Pu, UqPcc0Pu = UqPcc0Pu, XVI = XVI) annotation(
    Placement(transformation(origin = {-30, 18}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.Converters.InnerControls.CurrentSaturation currentSaturation(Imax = Imax, Imin = Imin, CurrentModule0 = CurrentModule0, CurrentAngle0 = CurrentAngle0, W_CurrentLimit = W_CurrentLimit, idConvRef0Pu = IdConv0Pu, iqConvRef0Pu = IqConv0Pu, idConvSatRef0Pu = IdConvSatRef0Pu, iqConvSatRef0Pu = IqConvSatRef0Pu, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu) annotation(
    Placement(transformation(origin = {30, 18}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.VirtualImpedance2CC VICC(KpVI = KpVI, XRratio = XRratio, IMaxVI = IMaxVI, DeltaIConvMaxPu = DeltaIConvMaxPu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu)  annotation(
    Placement(transformation(origin = {-68, -20}, extent = {{-10, -10}, {10, 10}})));
  BaseControls.CurrentLoops.DynCurrentLoopAntiWindUp currentLoop(OmegaC = omegaC, YMax = YMax, YMin = YMin, RFilter = RFilterPu, LFilter = LFilterPu, Kfd = Kfd, Kfq = Kfq, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, IdConvRef0Pu = IdConv0Pu, IqConvRef0Pu = IqConv0Pu, Omega0Pu = Omega0Pu)  annotation(
    Placement(transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}})));
  PLL.PLL pll(OmegaN = omegaNPLL, Zeta = ZetaPLL, u0Pu = u0Pu, OmegaMaxPu = 10, OmegaMinPu = -10) annotation(
    Placement(transformation(origin = {-81, 55}, extent = {{-7, -7}, {7, 7}})));

  //Operating point
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal/PCC in rad";

  // Initial parameters
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage reference in pu (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage reference in pu (base UNom)";
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UdPcc0Pu "Start value of d-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit UqPcc0Pu "Start value of q-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Types.CurrentModulePu IdConvSatRef0Pu "Start value of the satured value of id";
  parameter Types.CurrentModulePu IqConvSatRef0Pu "Start value of the satured value of iq";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at the PCC in pu (base UNom)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of converter's frequency in pu (base omegaNom)";
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";

  final parameter Types.VoltageModulePu URef0Pu = sqrt(UdFilter0Pu*UdFilter0Pu + UqFilter0Pu*UqFilter0Pu) "Start value of voltage module reference in pu (base UNom)";
  final parameter Types.CurrentModulePu CurrentModule0 = sqrt(IdConv0Pu*IdConv0Pu+IqConv0Pu*IqConv0Pu) "Start value of the module of the current in dq representation IdConv0Pu,IqConv0Pu";
  final parameter Types.CurrentModulePu CurrentAngle0 = atan2(IqConv0Pu,IdConv0Pu) "Start value of the phase angle of the current in dq representation IdConv0Pu,IqConv0Pu";

  PLL.PLL_INIT pll_init(U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(transformation(origin = {-138, 14}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.Converters.InnerControls.CurrentSaturation currentSaturation(Imax = Imax, Imin = Imin, CurrentModule0 = CurrentModule0, CurrentAngle0 = CurrentAngle0, W_CurrentLimit = W_CurrentLimit, idConvRef0Pu = IdConv0Pu, iqConvRef0Pu = IqConv0Pu, idConvSatRef0Pu = IdConvSatRef0Pu, iqConvSatRef0Pu = IqConvSatRef0Pu, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu) annotation(
    Placement(transformation(origin = {28, 24}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.VirtualImpedance2CC VICC(KpVI = KpVI, XRratio = XRratio, IMaxVI = IMaxVI, DeltaIConvMaxPu = DeltaIConvMaxPu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu)  annotation(
    Placement(transformation(origin = {-82, -20}, extent = {{-10, -10}, {10, 10}})));
  PLL.PLL pll(OmegaN = omegaNPLL, Zeta = ZetaPLL, u0Pu = u0Pu, OmegaMaxPu = 10, OmegaMinPu = -10)  annotation(
    Placement(transformation(origin = {-75, 55}, extent = {{-7, -7}, {7, 7}})));
  BaseControls.CurrentLoops.DynCurrentLoop currentLoop(OmegaC = omegaC, RFilter = RFilterPu, LFilter = LFilterPu, Kfd = Kfd, Kfq = Kfq, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, IdConvRef0Pu = IdConvSatRef0Pu, IqConvRef0Pu = IqConvSatRef0Pu, Omega0Pu = Omega0Pu)  annotation(
    Placement(transformation(origin = {74, 24}, extent = {{-10, -10}, {10, 10}})));
  BaseControls.GFM.VoltageControls.VoltageReferenceControl voltageReferenceControl(Mq = Mq, Wf = Wf, Wff = Wff, Kff = Kff, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, UdRef0Pu = UdFilter0Pu, UqRef0Pu = UqFilter0Pu, DeltaVVId0 = VICC.DeltaVVId0, DeltaVVIq0 = VICC.DeltaVVIq0, QFilter0Pu = QFilter0Pu, URef0Pu = URef0Pu)  annotation(
    Placement(transformation(origin = {-71, 23}, extent = {{-9, -9}, {9, 9}})));
  BaseControls.GFM.VoltageControls.DynQSEM QSEM(RFilter = RTransformerPu, LFilter = LTransformerPu, XVI = XVI, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, UdPcc0Pu = UdPcc0Pu, UqPcc0Pu = UqPcc0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, Omega0Pu = Omega0Pu)  annotation(
    Placement(transformation(origin = {-22, 24}, extent = {{-10, -10}, {10, 10}})));
  BaseControls.GFM.PowerAngleControls.CC_VSM VSM(kVSM = kVSM, H = H, KDampingAngle = KDampingAngle, PFilter0Pu = PFilter0Pu, Omega0Pu = Omega0Pu, Theta0 = Theta0)  annotation(
    Placement(transformation(origin = {-9, 79}, extent = {{-13, -13}, {13, 13}})));
equation
  connect(idConvPu, VICC.idConvPu) annotation(
    Line(points = {{-108, -16}, {-108, -15}, {-93, -15}}, color = {0, 0, 127}));
  connect(iqConvPu, VICC.iqConvPu) annotation(
    Line(points = {{-108, -34}, {-108, -25}, {-93, -25}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, PLLFilter.u) annotation(
    Line(points = {{-67, 58.5}, {-67, 64}, {-59, 64}}, color = {0, 0, 127}));
  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-108, 96}, {-108, 51}, {-83, 51}}, color = {0, 0, 127}));
  connect(uPccPu, pll.uPu) annotation(
    Line(points = {{-108, 54}, {-108, 59}, {-83, 59}}, color = {85, 170, 255}));
  connect(pll.omegaPLLPu, omegaPLL) annotation(
    Line(points = {{-67, 58.5}, {-67, 62}, {106, 62}}, color = {0, 0, 127}));
  connect(VICC.DeltaVVId, voltageReferenceControl.DeltaVVId) annotation(
    Line(points = {{-70, -14}, {-80, -14}, {-80, 14}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(VICC.DeltaVVIq, voltageReferenceControl.DeltaVVIq) annotation(
    Line(points = {{-70, -24}, {-76, -24}, {-76, 14}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(idPccPu, voltageReferenceControl.idPccPu) annotation(
    Line(points = {{-108, -52}, {-70, -52}, {-70, 14}}, color = {0, 0, 127}));
  connect(iqPccPu, voltageReferenceControl.iqPccPu) annotation(
    Line(points = {{-108, -64}, {-66, -64}, {-66, 14}}, color = {0, 0, 127}));
  connect(omegaRefPu, VSM.omegaRefPu) annotation(
    Line(points = {{-108, 96}, {-23, 96}, {-23, 89}}, color = {0, 0, 127}));
  connect(PFilterRefPu, VSM.PFilterRefPu) annotation(
    Line(points = {{-108, 84}, {-23, 84}}, color = {0, 0, 127}));
  connect(PFilterPu, VSM.PFilterPu) annotation(
    Line(points = {{-108, 72}, {-24, 72}, {-24, 74}}, color = {0, 0, 127}));
  connect(PLLFilter.y, VSM.omegaSetPu) annotation(
    Line(points = {{-46, 64}, {-24, 64}, {-24, 68}}, color = {0, 0, 127}));
  connect(VSM.theta, theta) annotation(
    Line(points = {{6, 84}, {106, 84}, {106, 86}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, omegaPu) annotation(
    Line(points = {{6, 74}, {106, 74}}, color = {0, 0, 127}));
  connect(QFilterPu, voltageReferenceControl.QFilterPu) annotation(
    Line(points = {{-108, 40}, {-76, 40}, {-76, 32}}, color = {0, 0, 127}));
  connect(URefPu, voltageReferenceControl.URefPu) annotation(
    Line(points = {{-108, 22}, {-95, 22}, {-95, 24}, {-80, 24}}, color = {0, 0, 127}));
  connect(QFilterRefPu, voltageReferenceControl.QFilterRefPu) annotation(
    Line(points = {{-108, 6}, {-80, 6}, {-80, 14}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.udFilterRefPu, QSEM.udFilterRefPu) annotation(
    Line(points = {{-62, 26}, {-32, 26}, {-32, 28}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.uqFilterRefPu, QSEM.uqFilterRefPu) annotation(
    Line(points = {{-62, 20}, {-32, 20}}, color = {0, 0, 127}));
  connect(QSEM.idConvRefPu, currentSaturation.idConvRefPu) annotation(
    Line(points = {{-10, 28}, {18, 28}}, color = {0, 0, 127}));
  connect(QSEM.iqConvRefPu, currentSaturation.iqConvRefPu) annotation(
    Line(points = {{-10, 20}, {18, 20}, {18, 24}}, color = {0, 0, 127}));
  connect(currentSaturation.idConvSatRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{40, 28}, {64, 28}}, color = {0, 0, 127}));
  connect(currentSaturation.iqConvSatRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{40, 22}, {64, 22}, {64, 20}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{6, 74}, {74, 74}, {74, 36}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, QSEM.omegaPu) annotation(
    Line(points = {{6, 74}, {40, 74}, {40, 40}, {-22, 40}, {-22, 36}}, color = {0, 0, 127}));
  connect(currentLoop.udConvRefPu, udConvRefPu) annotation(
    Line(points = {{86, 28}, {108, 28}, {108, 32}}, color = {0, 0, 127}));
  connect(currentLoop.uqConvRefPu, uqConvRefPu) annotation(
    Line(points = {{86, 20}, {108, 20}, {108, 18}}, color = {0, 0, 127}));
  connect(udFilterPu, currentLoop.udFilterPu) annotation(
    Line(points = {{62, -108}, {64, -108}, {64, 14}}, color = {0, 0, 127}));
  connect(uqFilterPu, currentLoop.uqFilterPu) annotation(
    Line(points = {{72, -108}, {70, -108}, {70, 14}}, color = {0, 0, 127}));
  connect(idConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{-108, -16}, {80, -16}, {80, 14}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{-108, -34}, {84, -34}, {84, 14}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(udFilteredPccPu, QSEM.udFilteredPCCPu) annotation(
    Line(points = {{-108, -78}, {-26, -78}, {-26, 14}}, color = {0, 0, 127}));
  connect(uqFilteredPccPu, QSEM.uqFilteredPCCPu) annotation(
    Line(points = {{-108, -92}, {-20, -92}, {-20, 14}}, color = {0, 0, 127}));
  connect(idPccPu, currentSaturation.idPcc) annotation(
    Line(points = {{-108, -52}, {24, -52}, {24, 14}}, color = {0, 0, 127}));
  connect(iqPccPu, currentSaturation.iqPcc) annotation(
    Line(points = {{-108, -64}, {34, -64}, {34, 14}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Diagram,
    Documentation);
end DynGridFormingControlCCVSM;
