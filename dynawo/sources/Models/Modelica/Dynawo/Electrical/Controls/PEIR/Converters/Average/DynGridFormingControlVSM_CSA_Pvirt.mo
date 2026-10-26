within Dynawo.Electrical.Controls.PEIR.Converters.Average;

model DynGridFormingControlVSM_CSA_Pvirt "Grid Forming Control for VSM with Current Saturation and Virtual Power"
  /*
  * Copyright (c) 2026, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
  */
  // VSM parameters
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain";
  parameter Types.Time H "Inertia constant in s";
  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.AngularVelocity Omegaf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.AngularVelocity Omegaff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";
  // QSEM parameter
  parameter Types.PerUnit XVIPu "Virtual impedance in pu (base UNom, SNom)";
  // Current loop parameters
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis";
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis";
  parameter Types.Time Ts "Sampling period of the current controller, used as delay of the integral terms for the inverse current loop (in s)";
  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)";
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)";
  // PLL parameters
  parameter Types.PerUnit Ki "PLL integrator gain";
  parameter Types.PerUnit Kp "PLL proportional gain";
  parameter Types.Time tPLL "Time constants of the first-order filter for the PLL frequency measurement (in s)";
  //Current Saturation parameters
  parameter Types.CurrentModulePu ImaxPu "Current max threshold to limit a current's module";
  parameter Types.CurrentModulePu IminPu "Current min threshold to limit a current's module";
  parameter Types.CurrentModulePu EpsUpPu "Upper half-width of the dead band around Imax/Imin, to avoid chattering at the activation threshold";
  parameter Types.CurrentModulePu EpsDownPu "Lower half-width of the dead band around Imax/Imin, to avoid chattering at the activation threshold";
  parameter Types.Time tSat "Time constant of the first-order filter on the dq reference currents (in s)";
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
  parameter Types.AngularVelocityPu Omega0Pu "Start value of converter's frequency in pu (base omegaNom)";
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.PerUnit DeltaVVId0 = 0 "d-axis delta voltage virtual impedance (base UNom, SNom)";
  parameter Types.PerUnit DeltaVVIq0 = 0 "q-axis delta voltage virtual impedance (base UNom, SNom)";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at the PCC in pu (base UNom)";
  parameter Types.AngularVelocityPu OmegaRef0Pu = SystemBase.omegaRef0Pu "Start value of the rotation speed of the RI reference frame in pu (base omegaNom)";
  final parameter Types.PerUnit UdEmf0Pu = UdFilter0Pu + RFilterPu*IdConv0Pu - (LFilterPu*Omega0Pu + XVIPu)*IqConv0Pu "Start value of d-axis internal EMF (QSEM-consistent) in pu (base UNom)";
  final parameter Types.PerUnit UqEmf0Pu = UqFilter0Pu + RFilterPu*IqConv0Pu + (LFilterPu*Omega0Pu + XVIPu)*IdConv0Pu "Start value of q-axis internal EMF (QSEM-consistent) in pu (base UNom)";
  final parameter Types.VoltageModulePu URef0Pu = sqrt(UdEmf0Pu^2 + UqEmf0Pu^2) "Start value of voltage module reference in pu (base UNom): module of the internal EMF";
  final parameter Types.CurrentModulePu IConv0Pu = sqrt(IdConv0Pu^2 + IqConv0Pu^2) "Start value of the converter current module in pu (base UNom, SNom)";
  final parameter Types.Angle CurrentAngle0 = atan2(IqConv0Pu, IdConv0Pu) "Start value of the converter current phase angle in rad";
  // Inputs
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPccPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-108, 59}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 55}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-128, 44}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, -93}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -34}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-85, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -16}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-65, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {88, -108}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, -108}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-17, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idFilteredPccPu(start = IdPcc0Pu) "Filtered d-axis current at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -78}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqFilteredPccPu(start = IqPcc0Pu) "Filtered q-axis current at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -92}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {17, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -64}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {67, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -52}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {87, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = PFilter0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-108, 84}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 77}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = OmegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-108, 96}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 33}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage module reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-130, 32}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 3}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = voltageReferenceControl.QFilterRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-128, 18}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, -19}, extent = {{-9, -9}, {9, 9}})));
  // Outputs
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {107, 31}, extent = {{-7, -7}, {7, 7}}), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {107, 17}, extent = {{-7, -7}, {7, 7}}), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {106, 84}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {106, 72}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPLL(start = Omega0Pu) "Measured frequency from the grid in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {106, 60}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  // Models
  Dynawo.Electrical.Controls.PLL.PLL pll(Kp = Kp, Ki = Ki, u0Pu = u0Pu, OmegaMaxPu = 10, OmegaMinPu = -10, omegaPLLPu(start = Omega0Pu), limIntegrator(y_start = Omega0Pu - OmegaRef0Pu)) annotation(
    Placement(transformation(origin = {-81, 55}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Blocks.Continuous.FirstOrder PLLFilter(T = tPLL, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = Omega0Pu) annotation(
    Placement(transformation(origin = {-68, 55}, extent = {{-4, -4}, {4, 4}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls.VSM VSM(H = H, PFilter0Pu = PFilter0Pu, kVSM = kVSM, Omega0Pu = Omega0Pu, Theta0 = Theta0) annotation(
    Placement(visible = true, transformation(origin = {-46, 78}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls.VirtualPower virtualPower annotation(
    Placement(transformation(origin = {-111, 73}, extent = {{-5, -5}, {5, 5}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.VoltageReferenceControl voltageReferenceControl(Mq = Mq, Omegaf = Omegaf, Omegaff = Omegaff, Kff = Kff, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, DeltaVVId0 = DeltaVVId0, DeltaVVIq0 = DeltaVVIq0, QFilter0Pu = QFilter0Pu, QFilterRef0Pu = QFilter0Pu, URef0Pu = URef0Pu) annotation(
    Placement(transformation(origin = {-85, 27}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {-113, 3}, extent = {{-5, -5}, {5, 5}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.DynQSEM dynQSEM(RFilterPu = RFilterPu, LFilterPu = LFilterPu, XVIPu = XVIPu, UdFilter0Pu = UdEmf0Pu, UqFilter0Pu = UqEmf0Pu, UdPcc0Pu = UdFilter0Pu, UqPcc0Pu = UqFilter0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, Omega0Pu = Omega0Pu) annotation(
    Placement(transformation(origin = {-46, 20}, extent = {{-16, -16}, {16, 16}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.CurrentLoops.InverseCurrentLoop inverseCurrentLoop(Kpc = Kpc, Kic = Kic, RFilterPu = RFilterPu, LFilterPu = LFilterPu, Kfd = Kfd, Kfq = Kfq, Ts = Ts, XVIPu = XVIPu, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, Omega0Pu = Omega0Pu) annotation(
    Placement(transformation(origin = {3, 23}, extent = {{-17, -17}, {17, 17}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.InnerControls.CurrentSaturation currentSaturation(ImaxPu = ImaxPu, IminPu = IminPu, EpsUpPu = EpsUpPu, EpsDownPu = EpsDownPu, tSat = tSat, IdConvRef0Pu = IdConv0Pu, IqConvRef0Pu = IqConv0Pu, IdConvSatRef0Pu = IdConv0Pu, IqConvSatRef0Pu = IqConv0Pu, IPcc0Pu = IConv0Pu, CurrentAngle0 = CurrentAngle0, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu) annotation(
    Placement(transformation(origin = {40, 24}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.CurrentLoops.DynCurrentLoop_delay currentLoop(Kpc = Kpc, Kic = Kic, RFilterPu = RFilterPu, LFilterPu = LFilterPu, Kfd = Kfd, Kfq = Kfq, Ts = Ts, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, Omega0Pu = Omega0Pu) annotation(
    Placement(transformation(origin = {75, 23}, extent = {{-17, -17}, {17, 17}})));
equation
  connect(udConvRefPu, currentLoop.udConvRefPu) annotation(
    Line(points = {{107, 31}, {94, 31}, {94, 30}}, color = {245, 121, 0}, thickness = 0.5));
  connect(VSM.omegaPu, omegaPu) annotation(
    Line(points = {{-28, 72}, {106, 72}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{-28, 72}, {76, 72}, {76, 42}, {75, 42}}, color = {0, 0, 127}));
  connect(VSM.omegaRefPu, omegaRefPu) annotation(
    Line(points = {{-64, 91}, {-72, 91}, {-72, 96}, {-108, 96}}, color = {0, 0, 127}, thickness = 0.5));
  connect(PFilterRefPu, VSM.PFilterRefPu) annotation(
    Line(points = {{-108, 84}, {-64, 84}}, color = {85, 170, 0}, thickness = 0.5));
  connect(idConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{-108, -16}, {-108, -13}, {-106, -13}, {-106, -16}, {35.625, -16}, {35.625, 4}, {83.5, 4}}, color = {245, 121, 0}, pattern = LinePattern.Dash));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{-108, -34}, {-108, -36}, {92, -36}, {92, 4}}, color = {245, 121, 0}, pattern = LinePattern.Dash));
  connect(udFilterPu, currentLoop.udFilterPu) annotation(
    Line(points = {{40, -108}, {40, -51}, {77, -51}, {77, 4}}, color = {85, 170, 0}));
  connect(currentLoop.uqFilterPu, uqFilterPu) annotation(
    Line(points = {{71, 4}, {71, -77}, {88, -77}, {88, -108}}, color = {85, 170, 0}));
  connect(PLLFilter.y, VSM.omegaSetPu) annotation(
    Line(points = {{-64, 55}, {-64, 65}}, color = {0, 0, 127}));
  connect(currentLoop.uqConvRefPu, uqConvRefPu) annotation(
    Line(points = {{94, 16}, {94, 17}, {107, 17}}, color = {245, 121, 0}, thickness = 0.5));
  connect(VSM.theta, theta) annotation(
    Line(points = {{-28, 84}, {106, 84}}, color = {0, 0, 127}));
  connect(currentSaturation.idConvSatRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{52, 28}, {56, 28}, {56, 30}}, color = {0, 0, 127}));
  connect(currentSaturation.iqConvSatRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{52, 22}, {56, 22}, {56, 16}}, color = {0, 0, 127}));
  connect(idFilteredPccPu, currentSaturation.idFilteredPccPu) annotation(
    Line(points = {{-108, -78}, {36, -78}, {36, 13}}, color = {85, 170, 255}));
  connect(iqFilteredPccPu, currentSaturation.iqFilteredPccPu) annotation(
    Line(points = {{-108, -92}, {47, -92}, {47, 13}}, color = {85, 170, 255}));
  connect(inverseCurrentLoop.iqConvRefPu, currentSaturation.iqConvRefPu) annotation(
    Line(points = {{22, 16}, {22, 24}, {30, 24}}, color = {0, 0, 127}));
  connect(inverseCurrentLoop.omegaPu, VSM.omegaPu) annotation(
    Line(points = {{13, 42}, {13, 72}, {-28, 72}}, color = {0, 0, 127}));
  connect(inverseCurrentLoop.idConvPu, idConvPu) annotation(
    Line(points = {{-9, 4}, {-14, 4}, {-14, -16}, {-108, -16}}, color = {245, 121, 0}, pattern = LinePattern.Dash));
  connect(inverseCurrentLoop.iqConvPu, iqConvPu) annotation(
    Line(points = {{-5, 4}, {-5, -36}, {-109, -36}, {-109, -34}, {-108, -34}}, color = {245, 121, 0}, pattern = LinePattern.Dash));
  connect(udFilterPu, inverseCurrentLoop.udFilterPu) annotation(
    Line(points = {{40, -108}, {40, -26}, {11.5, -26}, {11.5, 4}}, color = {85, 170, 0}));
  connect(uqFilterPu, inverseCurrentLoop.uqFilterPu) annotation(
    Line(points = {{88, -108}, {88, -10}, {16, -10}, {16, 4}}, color = {85, 170, 0}));
  connect(currentLoop.DeltaUidConvRefPu, inverseCurrentLoop.DeltaUidConvRefPu) annotation(
    Line(points = {{62, 42}, {62, 54}, {4, 54}, {4, 42}}, color = {0, 0, 127}));
  connect(currentLoop.DeltaUiqConvRefPu, inverseCurrentLoop.DeltaUiqConvRefPu) annotation(
    Line(points = {{60, 4}, {62, 4}, {62, -4}, {4, -4}, {4, 4}}, color = {0, 0, 127}));
  connect(dynQSEM.idConvRefPu, inverseCurrentLoop.idQSEMPu) annotation(
    Line(points = {{-28, 26}, {-28, 30}, {-16, 30}}, color = {0, 0, 127}));
  connect(dynQSEM.iqConvRefPu, inverseCurrentLoop.iqQSEMPu) annotation(
    Line(points = {{-28, 14}, {-24, 14}, {-24, 20}, {-16, 20}}, color = {0, 0, 127}));
  connect(udFilterPu, virtualPower.udFilterPu) annotation(
    Line(points = {{40, -108}, {-148, -108}, {-148, 67.5}, {-108.5, 67.5}}, color = {85, 170, 0}));
  connect(uqFilterPu, virtualPower.uqFilterPu) annotation(
    Line(points = {{88, -108}, {88, -96}, {-140, -96}, {-140, 64}, {-107, 64}, {-107, 67.5}}, color = {85, 170, 0}));
  connect(inverseCurrentLoop.idConvRefPu, virtualPower.idConvRefPu) annotation(
    Line(points = {{22, 34}, {22, 118}, {-138, 118}, {-138, 75}, {-116.5, 75}}, color = {0, 0, 127}));
  connect(inverseCurrentLoop.iqConvRefPu, virtualPower.iqConvRefPu) annotation(
    Line(points = {{22, 16}, {20, 16}, {20, -120}, {-156, -120}, {-156, 73}, {-116.5, 73}}, color = {0, 0, 127}));
  connect(udFilterPu, dynQSEM.udFilteredPCCPu) annotation(
    Line(points = {{40, -108}, {-50, -108}, {-50, 2}}, color = {85, 170, 0}));
  connect(uqFilterPu, dynQSEM.uqFilteredPCCPu) annotation(
    Line(points = {{88, -108}, {88, -96}, {-42, -96}, {-42, 2}}, color = {85, 170, 0}));
  connect(URefPu, voltageReferenceControl.URefPu) annotation(
    Line(points = {{-130, 32}, {-100, 32}, {-100, 28}, {-98, 28}}, color = {0, 0, 127}));
  connect(QFilterPu, voltageReferenceControl.QFilterPu) annotation(
    Line(points = {{-128, 44}, {-90, 44}, {-90, 40}}, color = {0, 0, 127}));
  connect(QFilterRefPu, voltageReferenceControl.QFilterRefPu) annotation(
    Line(points = {{-128, 18}, {-102, 18}, {-102, 16}, {-98, 16}}, color = {0, 0, 127}));
  connect(idPccPu, voltageReferenceControl.idPccPu) annotation(
    Line(points = {{-108, -52}, {-84, -52}, {-84, 14}}, color = {85, 170, 255}));
  connect(iqPccPu, voltageReferenceControl.iqPccPu) annotation(
    Line(points = {{-108, -64}, {-80, -64}, {-80, 14}}, color = {85, 170, 255}));
  connect(voltageReferenceControl.udFilterRefPu, dynQSEM.udFilterRefPu) annotation(
    Line(points = {{-72, 32}, {-68, 32}, {-68, 26}, {-64, 26}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.uqFilterRefPu, dynQSEM.uqFilterRefPu) annotation(
    Line(points = {{-72, 22}, {-68, 22}, {-68, 14}, {-64, 14}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.udFilterRefPu, inverseCurrentLoop.udConvRefPu) annotation(
    Line(points = {{-72, 32}, {-70, 32}, {-70, 48}, {-10, 48}, {-10, 42}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.uqFilterRefPu, inverseCurrentLoop.uqConvRefPu) annotation(
    Line(points = {{-72, 22}, {-72, 52}, {-6, 52}, {-6, 42}}, color = {0, 0, 127}));
  connect(inverseCurrentLoop.idConvRefPu, currentSaturation.idConvRefPu) annotation(
    Line(points = {{22, 34}, {26, 34}, {26, 28}, {30, 28}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, dynQSEM.omegaPu) annotation(
    Line(points = {{-28, 72}, {-28, 50}, {-46, 50}, {-46, 38}}, color = {0, 0, 127}));
  connect(uPccPu, pll.uPu) annotation(
    Line(points = {{-108, 59}, {-89, 59}}, color = {85, 170, 255}));
  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-108, 96}, {-92, 96}, {-92, 51}, {-89, 51}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, PLLFilter.u) annotation(
    Line(points = {{-73, 58}, {-72, 58}, {-72, 55}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, omegaPLL) annotation(
    Line(points = {{-73, 58}, {-70, 58}, {-70, 60}, {106, 60}}, color = {0, 0, 127}));
  connect(virtualPower.PvirtPu, VSM.PFilterPu) annotation(
    Line(points = {{-105.5, 77}, {-98, 77}, {-98, 72}, {-64, 72}}, color = {0, 0, 127}));
  connect(const.y, voltageReferenceControl.DeltaVVId) annotation(
    Line(points = {{-108, 4}, {-96, 4}, {-96, 14}}, color = {0, 0, 127}));
  connect(const.y, voltageReferenceControl.DeltaVVIq) annotation(
    Line(points = {{-108, 4}, {-90, 4}, {-90, 14}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Diagram(graphics = {Text(origin = {33, 35}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvRefPu", fontSize = 5, textStyle = {TextStyle.Bold}), Text(origin = {33, 23}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvRefPu", fontSize = 5, textStyle = {TextStyle.Bold})}, coordinateSystem(extent = {{-120, 100}, {120, -120}})));
end DynGridFormingControlVSM_CSA_Pvirt;
