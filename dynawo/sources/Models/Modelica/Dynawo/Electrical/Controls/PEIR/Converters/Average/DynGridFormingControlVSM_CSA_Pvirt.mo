within Dynawo.Electrical.Controls.PEIR.Converters.Average;

model DynGridFormingControlVSM_CSA_Pvirt
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
  parameter Real Ts "Delay for the backward loop";
  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)";
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)";
  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-160, 92}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, -73}, extent = {{-9, -9}, {9, 9}})));
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
    Placement(transformation(origin = {-130, 32}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 3}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = voltageReferenceControl.QFilterRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-128, 18}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, -19}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput omegaSetPu annotation(
    Placement(transformation(origin = {-108, 58}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 55}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 31}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 17}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {106, 84}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {106, 72}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Controls.PEIR.BaseControls.CurrentLoops.DynCurrentLoop_delay currentLoop(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, Kfd = Kfd, Kfq = Kfq, Kic = Kic, Kpc = Kpc, LFilter = LFilterPu, RFilter = RFilterPu, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, UqConv0Pu = UqConv0Pu, UqFilter0Pu = UqFilter0Pu, Omega0Pu = Omega0Pu, Ts = Ts, XVI = XVI) annotation(
    Placement(transformation(origin = {75, 23}, extent = {{-17, -17}, {17, 17}})));
  Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls.VSM VSM(H = H, PFilter0Pu = PFilter0Pu, kVSM = kVSM, Omega0Pu = Omega0Pu, Theta0 = Theta0, omegaRes0Pu = omegaRes0Pu) annotation(
    Placement(visible = true, transformation(origin = {-46, 78}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Electrical.Controls.Converters.InnerControls.CurrentSaturation CSA(Imax = Imax, Imin = 0, idConvRef0Pu = idConvRef0Pu, iqConvRef0Pu = iqConvRef0Pu, idConvSatRef0Pu = idConvSatRef0Pu, iqConvSatRef0Pu = iqConvSatRef0Pu, CurrentModule0 = CurrentModule0, CurrentAngle0 = CurrentAngle0, W_CurrentLimit = W_CurrentLimit) annotation(
    Placement(transformation(origin = {40, 24}, extent = {{-10, -10}, {10, 10}})));
  BaseControls.CurrentLoops.InverseCurrentLoop inverseCurrentLoop(Kpc = Kpc, Kic = Kic, RFilter = RFilterPu, LFilter = LFilterPu, Kfd = Kfd, Kfq = Kfq, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, Ts = Ts, XVI = XVI) annotation(
    Placement(transformation(origin = {3, 23}, extent = {{-17, -17}, {17, 17}})));
  Modelica.Blocks.Math.Gain gain(k = -XVI) annotation(
    Placement(transformation(origin = {-94, -8}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Math.Gain gain1(k = XVI)  annotation(
    Placement(transformation(origin = {-116, 4}, extent = {{-4, -4}, {4, 4}})));
  BaseControls.GFM.VoltageControls.DynQSEM dynQSEM(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, LFilter = LFilterPu, RFilter = RFilterPu, UdFilter0Pu = UdFilter0Pu, UdPcc0Pu = UdPcc0Pu, UqFilter0Pu = UqFilter0Pu, UqPcc0Pu = UqPcc0Pu, XVI = XVI, Omega0Pu = Omega0Pu) annotation(
    Placement(transformation(origin = {-46, 20}, extent = {{-16, -16}, {16, 16}})));
  BaseControls.GFM.PowerAngleControls.VirtualPower virtualPower annotation(
    Placement(transformation(origin = {-89, 75}, extent = {{-5, -5}, {5, 5}})));
  BaseControls.GFM.VoltageControls.VoltageReferenceControl voltageReferenceControl(DeltaVVId0 = 0, DeltaVVIq0 = 0, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, Kff = Kff, Mq = Mq, QFilter0Pu = QFilter0Pu, URef0Pu = URef0Pu, UdRef0Pu = UdFilter0Pu, UqRef0Pu = UqFilter0Pu, Wf = Wf, Wff = Wff) annotation(
    Placement(transformation(origin = {-85, 27}, extent = {{-11, -11}, {11, 11}})));

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
  final parameter Types.VoltageModulePu URef0Pu = sqrt(UdFilter0Pu*UdFilter0Pu + UqFilter0Pu*UqFilter0Pu) "Start value of voltage module reference in pu (base UNom)";
  parameter Real idConvRef0Pu "Start value of the d-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)";
  parameter Real iqConvRef0Pu "Start value of the q-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)";
  parameter Real idConvSatRef0Pu "start value of the satured-value of id";
  parameter Real iqConvSatRef0Pu "start value of the satured-value of iq";
  parameter Real CurrentModule0 "start value of the Module of the current in dq representation idConvPu,iqConvPu";
  parameter Real CurrentAngle0 "start value of the Phase Angle of the current in dq representation idConvPu,iqConvPu";
  parameter Real W_CurrentLimit "Bandwidth of the current saturation block rad/sec";
  parameter Real Imax "Current max threshold to limit a current's module";
  parameter Real DeltaVVId0 "d-axis delta voltage virtual impedance (base UNom, SNom)";
  parameter Real DeltaVVIq0 "q-axis delta voltage virtual impedance (base UNom, SNom)";
  parameter Types.PerUnit omegaRes0Pu "Start-value of the grid Frequency";
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
  connect(omegaSetPu, VSM.omegaSetPu) annotation(
    Line(points = {{-108, 58}, {-72, 58}, {-72, 66}, {-64, 66}}, color = {0, 0, 127}));
  connect(currentLoop.uqConvRefPu, uqConvRefPu) annotation(
    Line(points = {{94, 16}, {94, 17}, {107, 17}}, color = {245, 121, 0}, thickness = 0.5));
  connect(VSM.theta, theta) annotation(
    Line(points = {{-28, 84}, {106, 84}}, color = {0, 0, 127}));
  connect(CSA.idConvSatRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{52, 28}, {56, 28}, {56, 30}}, color = {0, 0, 127}));
  connect(CSA.iqConvSatRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{52, 22}, {56, 22}, {56, 16}}, color = {0, 0, 127}));
  connect(idPccPu, CSA.idPcc) annotation(
    Line(points = {{-108, -52}, {36, -52}, {36, 14}}, color = {85, 170, 255}));
  connect(iqPccPu, CSA.iqPcc) annotation(
    Line(points = {{-108, -64}, {46, -64}, {46, 14}}, color = {85, 170, 255}));
  connect(inverseCurrentLoop.iqConvRefPu, CSA.iqConvRefPu) annotation(
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
  connect(iqConvPu, gain1.u) annotation(
    Line(points = {{-108, -34}, {-126, -34}, {-126, 4}, {-121, 4}}, color = {0, 0, 127}));
  connect(currentLoop.DeltaUidConvRefPu, inverseCurrentLoop.DeltaUidConvRefPu) annotation(
    Line(points = {{62, 42}, {62, 54}, {4, 54}, {4, 42}}, color = {0, 0, 127}));
  connect(currentLoop.DeltaUiqConvRefPu, inverseCurrentLoop.DeltaUiqConvRefPu) annotation(
    Line(points = {{60, 4}, {62, 4}, {62, -4}, {4, -4}, {4, 4}}, color = {0, 0, 127}));
  connect(idConvPu, gain.u) annotation(
    Line(points = {{-108, -16}, {-118, -16}, {-118, -8}, {-99, -8}}, color = {0, 0, 127}));
  connect(dynQSEM.idConvRefPu, inverseCurrentLoop.idQSEM) annotation(
    Line(points = {{-28, 26}, {-28, 30}, {-16, 30}}, color = {0, 0, 127}));
  connect(dynQSEM.iqConvRefPu, inverseCurrentLoop.iqQSEM) annotation(
    Line(points = {{-28, 14}, {-24, 14}, {-24, 20}, {-16, 20}}, color = {0, 0, 127}));
  connect(udFilterPu, virtualPower.udFilterPu) annotation(
    Line(points = {{40, -108}, {-148, -108}, {-148, 69.5}, {-86.5, 69.5}}, color = {85, 170, 0}));
  connect(uqFilterPu, virtualPower.uqFilterPu) annotation(
    Line(points = {{88, -108}, {88, -96}, {-140, -96}, {-140, 64}, {-127, 64}, {-127, 66.75}, {-85, 66.75}, {-85, 69.5}}, color = {85, 170, 0}));
  connect(inverseCurrentLoop.idConvRefPu, virtualPower.idConvRefPu) annotation(
    Line(points = {{22, 34}, {22, 118}, {-138, 118}, {-138, 77}, {-94.5, 77}}, color = {0, 0, 127}));
  connect(inverseCurrentLoop.iqConvRefPu, virtualPower.iqConvRefPu) annotation(
    Line(points = {{22, 16}, {20, 16}, {20, -120}, {-156, -120}, {-156, 75}, {-94.5, 75}}, color = {0, 0, 127}));
  connect(udFilterPu, dynQSEM.udFilteredPCCPu) annotation(
    Line(points = {{40, -108}, {-50, -108}, {-50, 2}}, color = {85, 170, 0}));
  connect(uqFilterPu, dynQSEM.uqFilteredPCCPu) annotation(
    Line(points = {{88, -108}, {88, -96}, {-42, -96}, {-42, 2}}, color = {85, 170, 0}));
  connect(virtualPower.PvirtPu, VSM.PFilterPu) annotation(
    Line(points = {{-83.5, 79}, {-84, 79}, {-84, 72}, {-64, 72}}, color = {0, 0, 127}));
  connect(URefPu, voltageReferenceControl.URefPu) annotation(
    Line(points = {{-130, 32}, {-100, 32}, {-100, 28}, {-98, 28}}, color = {0, 0, 127}));
  connect(QFilterPu, voltageReferenceControl.QPu) annotation(
    Line(points = {{-128, 44}, {-90, 44}, {-90, 40}}, color = {0, 0, 127}));
  connect(QFilterRefPu, voltageReferenceControl.QFilterRefPu) annotation(
    Line(points = {{-128, 18}, {-102, 18}, {-102, 16}, {-98, 16}}, color = {0, 0, 127}));
  connect(gain1.y, voltageReferenceControl.DeltaVVId) annotation(
    Line(points = {{-112, 4}, {-96, 4}, {-96, 14}}, color = {0, 0, 127}));
  connect(gain.y, voltageReferenceControl.DeltaVVIq) annotation(
    Line(points = {{-90, -8}, {-90, 14}}, color = {0, 0, 127}));
  connect(idPccPu, voltageReferenceControl.idPccPu) annotation(
    Line(points = {{-108, -52}, {-84, -52}, {-84, 14}}, color = {85, 170, 255}));
  connect(iqPccPu, voltageReferenceControl.iqPccPu) annotation(
    Line(points = {{-108, -64}, {-80, -64}, {-80, 14}}, color = {85, 170, 255}));
  connect(voltageReferenceControl.udRefPu, dynQSEM.udFilterRefPu) annotation(
    Line(points = {{-72, 32}, {-68, 32}, {-68, 26}, {-64, 26}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.uqRefPu, dynQSEM.uqFilterRefPu) annotation(
    Line(points = {{-72, 22}, {-68, 22}, {-68, 14}, {-64, 14}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.udRefPu, inverseCurrentLoop.udConvRefPu) annotation(
    Line(points = {{-72, 32}, {-70, 32}, {-70, 48}, {-10, 48}, {-10, 42}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.uqRefPu, inverseCurrentLoop.uqConvRefPu) annotation(
    Line(points = {{-72, 22}, {-72, 52}, {-6, 52}, {-6, 42}}, color = {0, 0, 127}));
  connect(inverseCurrentLoop.idConvRefPu, CSA.idConvRefPu) annotation(
    Line(points = {{22, 34}, {26, 34}, {26, 28}, {30, 28}}, color = {0, 0, 127}));
  connect(omegaSetPu, dynQSEM.omegaPu) annotation(
    Line(points = {{-108, 58}, {-46, 58}, {-46, 38}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Diagram(graphics = {Text(origin = {33, 35}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvRefPu", fontSize = 5, textStyle = {TextStyle.Bold}), Text(origin = {33, 23}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvRefPu", fontSize = 5, textStyle = {TextStyle.Bold})}, coordinateSystem(extent = {{-120, 100}, {120, -120}})),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end DynGridFormingControlVSM_CSA_Pvirt;