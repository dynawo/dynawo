within Dynawo.Electrical.Controls.PEIR.Converters.Average;

model DynGridFormingControlCCVSM
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
  // VSM parameters
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain";
  parameter Types.Time H "Inertia constant in s";
  parameter Types.PerUnit KDampingAngle "Proportional gain of the PI action on theta (angle-damping term) in s";
  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.PerUnit Omegaf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Omegaff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";
  // QSEM parameter
  parameter Real XVIPu "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control";
  // Current loop parameters
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis";
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis";
  // Virtual impedance parameters
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.CurrentModulePu IMaxVIPu "Maximum current before activating the virtual impedance in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu DeltaIConvMaxPu "Maximum extra current module used to compute RVI/XVI, in pu (base UNom, SNom): bounds the virtual impedance correction regardless of how large the measured current becomes";
  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)";
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)";
  //PLL parameters
  parameter Types.PerUnit Ki "PLL integrator gain";
  parameter Types.PerUnit Kp "PLL proportional gain";
  //Current Saturation parameters
  parameter Types.CurrentModulePu ImaxPu "Current max threshold to limit a current's module";
  parameter Types.CurrentModulePu IminPu "Current min threshold to limit a current's module";
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
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = voltageReferenceControl.QFilterRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
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
  Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls.CCVSM VSM(H = H, PFilter0Pu = PFilter0Pu, kVSM = kVSM, Omega0Pu = Omega0Pu, Theta0 = Theta0, KDampingAngle = KDampingAngle) annotation(
    Placement(transformation(origin = {-6, 78}, extent = {{-16, -16}, {16, 16}})));
  Modelica.Blocks.Continuous.FirstOrder PLLFilter(T = 0.01, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = Omega0Pu) annotation(
    Placement(transformation(origin = {-52, 62}, extent = {{-6, -6}, {6, 6}})));

  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.VoltageReferenceControl voltageReferenceControl(Mq = Mq, Omegaf = Omegaf, Omegaff = Omegaff, Kff = Kff, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, DeltaVVId0 = VICC.DeltaVVId0, DeltaVVIq0 = VICC.DeltaVVIq0, QFilter0Pu = QFilter0Pu, QFilterRef0Pu = QFilter0Pu, URef0Pu = URef0Pu) annotation(
    Placement(transformation(origin = {-72, 18}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.DynQSEM QSEM(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, LFilterPu = LTransformerPu, Omega0Pu = Omega0Pu, RFilterPu = RTransformerPu, UdFilter0Pu = UdFilterRef0Pu, UdPcc0Pu = UdPcc0Pu, UqFilter0Pu = UqFilterRef0Pu, UqPcc0Pu = UqPcc0Pu, XVIPu = XVIPu) annotation(
    Placement(transformation(origin = {-20, 16}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Controls.PEIR.BaseControls.InnerControls.CurrentSaturation currentSaturation(ImaxPu = ImaxPu, IminPu = IminPu, CurrentAngle0 = CurrentAngle0, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, IdConvRef0Pu = IdConv0Pu, IqConvRef0Pu = IqConv0Pu, IdConvSatRef0Pu = IdConv0Pu, IqConvSatRef0Pu = IqConv0Pu, IPcc0Pu = IPcc0Pu) annotation(
    Placement(transformation(origin = {26, 14}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Controls.PEIR.BaseControls.VirtualImpedance2CC VICC(KpVI = KpVI, XRratio = XRratio, IMaxVIPu = IMaxVIPu, DeltaIConvMaxPu = DeltaIConvMaxPu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu) annotation(
    Placement(transformation(origin = {-86, -22}, extent = {{-10, -10}, {10, 10}})));

  BaseControls.CurrentLoops.DynCurrentLoop currentLoop(Kpc = Kpc, Kic = Kic, RFilterPu = RFilterPu, LFilterPu = LFilterPu, Kfd = Kfd, Kfq = Kfq, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, IdConvRef0Pu = IdConvSatRef0Pu, IqConvRef0Pu = IqConvSatRef0Pu, Omega0Pu = Omega0Pu) annotation(
    Placement(transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}})));
  PLL.PLL pll(Kp = Kp, Ki = Ki, u0Pu = u0Pu, OmegaMaxPu = 10, OmegaMinPu = -10) annotation(
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
  parameter Types.VoltageModulePu URef0Pu "Start value of voltage module reference in pu (base UNom): module of the internal EMF, consistent with QFilterRefPu = QFilter0Pu";
  final parameter Types.CurrentModulePu IPcc0Pu = sqrt(IdConv0Pu*IdConv0Pu + IqConv0Pu*IqConv0Pu) "Start value of the module of the current in dq representation IdConv0Pu,IqConv0Pu";
  final parameter Types.CurrentModulePu CurrentAngle0 = atan2(IqConv0Pu, IdConv0Pu) "Start value of the phase angle of the current in dq representation IdConv0Pu,IqConv0Pu";
  final parameter Types.PerUnit UdFilterRef0Pu = UdPcc0Pu + RTransformerPu*IdConv0Pu - (LTransformerPu*Omega0Pu + XVIPu)*IqConv0Pu "Start value of d-axis voltage reference at the filter (QSEM-consistent) in pu (base UNom)";
  final parameter Types.PerUnit UqFilterRef0Pu = UqPcc0Pu + RTransformerPu*IqConv0Pu + (LTransformerPu*Omega0Pu + XVIPu)*IdConv0Pu "Start value of q-axis voltage reference at the filter (QSEM-consistent) in pu (base UNom)";
  PLL.PLL_INIT pll_init(U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(transformation(origin = {-138, 14}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(idConvPu, VICC.idConvPu) annotation(
    Line(points = {{-108, -16}, {-108, -17}, {-97, -17}}, color = {0, 0, 127}));
  connect(iqConvPu, VICC.iqConvPu) annotation(
    Line(points = {{-108, -34}, {-108, -27}, {-97, -27}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, PLLFilter.u) annotation(
    Line(points = {{-67, 58.5}, {-67, 64}, {-59, 64}}, color = {0, 0, 127}));
  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-108, 96}, {-108, 51}, {-83, 51}}, color = {0, 0, 127}));
  connect(uPccPu, pll.uPu) annotation(
    Line(points = {{-108, 54}, {-108, 59}, {-83, 59}}, color = {85, 170, 255}));
  connect(pll.omegaPLLPu, omegaPLL) annotation(
    Line(points = {{-67, 58.5}, {-67, 62}, {106, 62}}, color = {0, 0, 127}));
  connect(VICC.DeltaVVId, voltageReferenceControl.DeltaVVId) annotation(
    Line(points = {{-75, -17}, {-75, 7}, {-82, 7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(VICC.DeltaVVIq, voltageReferenceControl.DeltaVVIq) annotation(
    Line(points = {{-75, -27}, {-75, -10}, {-77, -10}, {-77, 7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(idPccPu, voltageReferenceControl.idPccPu) annotation(
    Line(points = {{-108, -52}, {-108, 7}, {-72, 7}}, color = {0, 0, 127}));
  connect(iqPccPu, voltageReferenceControl.iqPccPu) annotation(
    Line(points = {{-108, -64}, {-108, 7}, {-67, 7}}, color = {0, 0, 127}));
  connect(omegaRefPu, VSM.omegaRefPu) annotation(
    Line(points = {{-108, 96}, {-108, 91}, {-24, 91}}, color = {0, 0, 127}));
  connect(PFilterRefPu, VSM.PFilterRefPu) annotation(
    Line(points = {{-108, 84}, {-24, 84}}, color = {0, 0, 127}));
  connect(PFilterPu, VSM.PFilterPu) annotation(
    Line(points = {{-108, 72}, {-24, 72}}, color = {0, 0, 127}));
  connect(PLLFilter.y, VSM.omegaSetPu) annotation(
    Line(points = {{-46, 64}, {-46, 65}, {-24, 65}}, color = {0, 0, 127}));
  connect(VSM.theta, theta) annotation(
    Line(points = {{12, 84}, {60, 84}, {60, 86}, {106, 86}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, omegaPu) annotation(
    Line(points = {{12, 72}, {60, 72}, {60, 74}, {106, 74}}, color = {0, 0, 127}));
  connect(QFilterPu, voltageReferenceControl.QFilterPu) annotation(
    Line(points = {{-108, 40}, {-108, 29}, {-77, 29}}, color = {0, 0, 127}));
  connect(URefPu, voltageReferenceControl.URefPu) annotation(
    Line(points = {{-108, 22}, {-96.5, 22}, {-96.5, 18}, {-83, 18}}, color = {0, 0, 127}));
  connect(QFilterRefPu, voltageReferenceControl.QFilterRefPu) annotation(
    Line(points = {{-108, 6}, {-95.5, 6}, {-95.5, 8}, {-83, 8}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.udFilterRefPu, QSEM.udFilterRefPu) annotation(
    Line(points = {{-61, 22}, {-46, 22}, {-46, 20}, {-31, 20}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.uqFilterRefPu, QSEM.uqFilterRefPu) annotation(
    Line(points = {{-61, 14}, {-46, 14}, {-46, 12}, {-31, 12}}, color = {0, 0, 127}));
  connect(QSEM.idConvRefPu, currentSaturation.idConvRefPu) annotation(
    Line(points = {{-9, 20}, {3, 20}, {3, 18}, {15, 18}}, color = {0, 0, 127}));
  connect(QSEM.iqConvRefPu, currentSaturation.iqConvRefPu) annotation(
    Line(points = {{-9, 12}, {3, 12}, {3, 14}, {15, 14}}, color = {0, 0, 127}));
  connect(currentSaturation.idConvSatRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{37, 18}, {51, 18}, {51, 24}, {59, 24}}, color = {0, 0, 127}));
  connect(currentSaturation.iqConvSatRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{37, 12}, {50, 12}, {50, 16}, {59, 16}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{12, 72}, {12, 31}, {70, 31}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, QSEM.omegaPu) annotation(
    Line(points = {{12, 72}, {40, 72}, {40, 27}, {-20, 27}}, color = {0, 0, 127}));
  connect(currentLoop.udConvRefPu, udConvRefPu) annotation(
    Line(points = {{81, 24}, {81, 32}, {108, 32}}, color = {0, 0, 127}));
  connect(currentLoop.uqConvRefPu, uqConvRefPu) annotation(
    Line(points = {{81, 16}, {95.5, 16}, {95.5, 18}, {108, 18}}, color = {0, 0, 127}));
  connect(udFilterPu, currentLoop.udFilterPu) annotation(
    Line(points = {{62, -108}, {62, -50.5}, {60, -50.5}, {60, 9}}, color = {0, 0, 127}));
  connect(uqFilterPu, currentLoop.uqFilterPu) annotation(
    Line(points = {{72, -108}, {72, 9}, {65, 9}}, color = {0, 0, 127}));
  connect(idConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{-108, -16}, {-108, 9}, {75, 9}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{-108, -34}, {-108, 9}, {80, 9}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(udFilteredPccPu, QSEM.udFilteredPCCPu) annotation(
    Line(points = {{-108, -78}, {-108, 5}, {-23, 5}}, color = {0, 0, 127}));
  connect(uqFilteredPccPu, QSEM.uqFilteredPCCPu) annotation(
    Line(points = {{-108, -92}, {-108, 5}, {-17, 5}}, color = {0, 0, 127}));
  connect(idPccPu, currentSaturation.idPccPu) annotation(
    Line(points = {{-108, -52}, {-108, 3}, {23, 3}}, color = {0, 0, 127}));
  connect(iqPccPu, currentSaturation.iqPccPu) annotation(
    Line(points = {{-108, -64}, {-108, 3}, {32, 3}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Diagram,
    Documentation);
end DynGridFormingControlCCVSM;
