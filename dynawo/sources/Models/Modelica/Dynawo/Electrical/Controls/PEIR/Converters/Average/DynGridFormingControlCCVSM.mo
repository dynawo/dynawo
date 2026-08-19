within Dynawo.Electrical.Controls.PEIR.Converters.Average;

model DynGridFormingControlCCVSM
  /*
                              * Copyright (c) 2025, RTE (http://www.rte-france.com)
                              * See AUTHORS.txt
                              * All rights reserved.
                              * This Source Code Form is subject to the terms of the Mozilla Public
                              * License, v. 2.0. If a copy of the MPL was not distributed with this
                              * file, you can obtain one at http://mozilla.org/MPL/2.0/.
                              * SPDX-License-Identifier: MPL-2.0
                              *
                              * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
                              */
  // VSM parameters
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain";
  parameter Types.Time H "Inertia constant in s";
  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";
  // QSEM parameter
  parameter Real XVI "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control";
  // Current loop parameters
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
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
  parameter Types.PerUnit KpPLL "PLL Proportional gain";
  parameter Types.PerUnit KiPLL "PLL Integrator gain";
  //Current Saturation parameters
  parameter Real W_CurrentLimit "Bandwidth of the current limitation";
  parameter Types.CurrentModulePu Imax "Current max threshold to limit a current's module";
  parameter Types.CurrentModulePu Imin "Current min threshold to limit a current's module";
  //Operating Point
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal/PCC in rad";
  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 72}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -73}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-108, 40}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, -93}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -34}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-85, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -16}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-65, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {88, -108}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, -108}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-17, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
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
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage module reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-108, 22}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 3}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = voltageReferenceControlCC.QFilterRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(Placement(transformation(origin = {-108, 6}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, -19}, extent = {{-9, -9}, {9, 9}})));
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
  parameter Types.CurrentModulePu IdConvSatRef0Pu "start value of the satured-value of id";
  parameter Types.CurrentModulePu IqConvSatRef0Pu "start value of the satured-value of iq";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at the PCC in pu (base UNom)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of converter's frequency in pu (base omegaNom)";
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  final parameter Types.VoltageModulePu URef0Pu = sqrt(UdFilter0Pu*UdFilter0Pu + UqFilter0Pu*UqFilter0Pu) "Start value of voltage module reference in pu (base UNom)";
  final parameter Types.CurrentModulePu CurrentModule0 = sqrt(IdConv0Pu*IdConv0Pu+IqConv0Pu*IqConv0Pu) "start value of the Module of the current in dq representation IdConv0Pu,IqConv0Pu";
  final parameter Types.CurrentModulePu CurrentAngle0 = atan2(IqConv0Pu,IdConv0Pu) "start value of the Phase Angle of the current in dq representation IdConv0Pu,IqConv0Pu";
  PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = 2.0, OmegaMinPu = 0, u0Pu = u0Pu) annotation(
    Placement(transformation(origin = {-74, 50}, extent = {{-6, -6}, {6, 6}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPccPu(re(start = u0Pu.re), im(start = u0Pu.im)) annotation(
    Placement(transformation(origin = {-108, 54}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 55}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Continuous.FirstOrder PLLFilter(T = 0.01, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = Omega0Pu) annotation(
    Placement(transformation(origin = {-52, 62}, extent = {{-6, -6}, {6, 6}})));
  PLL.PLL_INIT pll_init(U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(transformation(origin = {-138, 14}, extent = {{-10, -10}, {10, 10}})));


  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.VoltageReferenceControlCC voltageReferenceControlCC(DeltaVVId0 = VICC.DeltaVVId0, DeltaVVIq0 = VICC.DeltaVVIq0, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, Kff = Kff, Mq = Mq, QFilter0Pu = QFilter0Pu, URef0Pu = URef0Pu, UdRef0Pu = UdFilter0Pu, UqRef0Pu = UqFilter0Pu, Wf = Wf, Wff = Wff, WVIFreeze = 500) annotation(
    Placement(transformation(origin = {-70, 18}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.DynQSEM QSEM(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, LFilter = LFilterPu, Omega0Pu = Omega0Pu, RFilter = RFilterPu, UdFilter0Pu = UdFilter0Pu, UdPcc0Pu = UdPcc0Pu, UqFilter0Pu = UqFilter0Pu, UqPcc0Pu = UqPcc0Pu, XVI = XVI) annotation(
    Placement(transformation(origin = {-30, 18}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.Converters.InnerControls.CurrentSaturation currentSaturation(Imax = Imax, Imin = Imin, CurrentModule0 = CurrentModule0, CurrentAngle0 = CurrentAngle0, W_CurrentLimit = W_CurrentLimit, idConvRef0Pu = IdConv0Pu, iqConvRef0Pu = IqConv0Pu, idConvSatRef0Pu = IdConvSatRef0Pu, iqConvSatRef0Pu = IqConvSatRef0Pu, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu) annotation(
    Placement(transformation(origin = {30, 18}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.CurrentLoops.DynCurrentLoopAntiWindUp currentLoop(RFilter = RFilterPu, LFilter = LFilterPu, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, IdConvRef0Pu = IdConv0Pu, IqConvRef0Pu = IqConv0Pu, Omega0Pu = Omega0Pu, Kpc = Kpc, Kic = Kic, Kfd = Kfd, Kfq = Kfq, YMax = YMax, YMin = YMin) annotation(
    Placement(transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.VirtualImpedance2CC VICC(KpVI = KpVI, XRratio = XRratio, IMaxVI = IMaxVI, DeltaIConvMaxPu = DeltaIConvMaxPu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu)  annotation(
    Placement(transformation(origin = {-68, -20}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(uPccPu, pll.uPu) annotation(
    Line(points = {{-108, 54}, {-81, 54}}, color = {85, 170, 255}));
  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-108, 96}, {-90, 96}, {-90, 46}, {-81, 46}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, omegaPLL) annotation(
    Line(points = {{-67, 53}, {106, 53}, {106, 62}}, color = {0, 0, 127}));
  connect(omegaRefPu, VSM.omegaRefPu) annotation(
    Line(points = {{-108, 96}, {-28, 96}, {-28, 92}}, color = {0, 0, 127}));
  connect(PFilterRefPu, VSM.PFilterRefPu) annotation(
    Line(points = {{-108, 84}, {-28, 84}, {-28, 86}}, color = {0, 0, 127}));
  connect(PFilterPu, VSM.PFilterPu) annotation(
    Line(points = {{-108, 72}, {-28, 72}, {-28, 74}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, PLLFilter.u) annotation(
    Line(points = {{-68, 54}, {-60, 54}, {-60, 62}}, color = {0, 0, 127}));
  connect(PLLFilter.y, VSM.omegaSetPu) annotation(
    Line(points = {{-46, 62}, {-28, 62}, {-28, 68}}, color = {0, 0, 127}));
  connect(VSM.theta, theta) annotation(
    Line(points = {{8, 86}, {106, 86}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, omegaPu) annotation(
    Line(points = {{8, 74}, {106, 74}}, color = {0, 0, 127}));
  connect(QFilterPu, voltageReferenceControlCC.QFilterPu) annotation(
    Line(points = {{-108, 40}, {-74, 40}, {-74, 30}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, QSEM.omegaPu) annotation(
    Line(points = {{8, 74}, {28, 74}, {28, 40}, {-30, 40}, {-30, 30}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{8, 74}, {28, 74}, {28, 40}, {70, 40}, {70, 32}}, color = {0, 0, 127}));
  connect(voltageReferenceControlCC.udFilterRefPu, QSEM.udFilterRefPu) annotation(
    Line(points = {{-58, 22}, {-40, 22}}, color = {0, 0, 127}));
  connect(voltageReferenceControlCC.uqFilterRefPu, QSEM.uqFilterRefPu) annotation(
    Line(points = {{-58, 14}, {-40, 14}}, color = {0, 0, 127}));
  connect(QSEM.idConvRefPu, currentSaturation.idConvRefPu) annotation(
    Line(points = {{-18, 22}, {20, 22}}, color = {0, 0, 127}));
  connect(QSEM.iqConvRefPu, currentSaturation.iqConvRefPu) annotation(
    Line(points = {{-18, 14}, {20, 14}, {20, 18}}, color = {0, 0, 127}));
  connect(currentSaturation.idConvSatRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{42, 22}, {60, 22}, {60, 24}}, color = {0, 0, 127}));
  connect(currentSaturation.iqConvSatRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{42, 16}, {60, 16}}, color = {0, 0, 127}));
  connect(currentLoop.udConvRefPu, udConvRefPu) annotation(
    Line(points = {{82, 24}, {94, 24}, {94, 32}, {108, 32}}, color = {0, 0, 127}));
  connect(currentLoop.uqConvRefPu, uqConvRefPu) annotation(
    Line(points = {{82, 16}, {92, 16}, {92, 18}, {108, 18}}, color = {0, 0, 127}));
  connect(currentSaturation.BlocCurrentSaturation_Enable, voltageReferenceControlCC.BlocCurrentSaturation_Enable) annotation(
    Line(points = {{30, 30}, {-70, 30}}, color = {255, 0, 255}));
  connect(URefPu, voltageReferenceControlCC.URefPu) annotation(
    Line(points = {{-108, 22}, {-80, 22}, {-80, 18}}, color = {0, 0, 127}));
  connect(VICC.DeltaVVId, voltageReferenceControlCC.DeltaVVId) annotation(
    Line(points = {{-57, -15}, {-80, -15}, {-80, 8}}, color = {0, 0, 127}));
  connect(QFilterRefPu, voltageReferenceControlCC.QFilterRefPu) annotation(
    Line(points = {{-108, 6}, {-92, 6}, {-92, 8}, {-80, 8}}, color = {0, 0, 127}));
  connect(VICC.DeltaVVIq, voltageReferenceControlCC.DeltaVVIq) annotation(
    Line(points = {{-57, -25}, {-74, -25}, {-74, 8}}, color = {0, 0, 127}));
  connect(idConvPu, VICC.idConvPu) annotation(
    Line(points = {{-108, -16}, {-108, -15}, {-79, -15}}, color = {0, 0, 127}));
  connect(iqConvPu, VICC.iqConvPu) annotation(
    Line(points = {{-108, -34}, {-108, -25}, {-79, -25}}, color = {0, 0, 127}));
  connect(udFilteredPccPu, QSEM.udFilteredPCCPu) annotation(
    Line(points = {{-108, -78}, {-34, -78}, {-34, 8}}, color = {0, 0, 127}));
  connect(uqFilteredPccPu, QSEM.uqFilteredPCCPu) annotation(
    Line(points = {{-108, -92}, {-28, -92}, {-28, 8}}, color = {0, 0, 127}));
  connect(idPccPu, currentSaturation.idPcc) annotation(
    Line(points = {{-108, -52}, {26, -52}, {26, 8}}, color = {0, 0, 127}));
  connect(iqPccPu, currentSaturation.iqPcc) annotation(
    Line(points = {{-108, -64}, {36, -64}, {36, 8}}, color = {0, 0, 127}));
  connect(idPccPu, voltageReferenceControlCC.idPccPu) annotation(
    Line(points = {{-108, -52}, {-70, -52}, {-70, 8}}, color = {0, 0, 127}));
  connect(iqPccPu, voltageReferenceControlCC.iqPccPu) annotation(
    Line(points = {{-108, -64}, {-64, -64}, {-64, 8}}, color = {0, 0, 127}));
  connect(idConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{-108, -16}, {76, -16}, {76, 10}}, color = {0, 0, 127}));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{-108, -34}, {80, -34}, {80, 10}}, color = {0, 0, 127}));
  connect(udFilteredPccPu, currentLoop.udFilterPu) annotation(
    Line(points = {{-108, -78}, {60, -78}, {60, 10}}, color = {0, 0, 127}));
  connect(uqFilteredPccPu, currentLoop.uqFilterPu) annotation(
    Line(points = {{-108, -92}, {66, -92}, {66, 10}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Diagram,
    Documentation);
end DynGridFormingControlCCVSM;
