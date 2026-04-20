within Dynawo.Electrical.Controls.PEIR.Converters.Average;

model DynGridFormingControlVSM_CSA
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
  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)";
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)";
  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 72}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -73}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 46}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -93}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -34}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-85, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -16}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-65, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {70, -106}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {80, -106}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-17, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilteredPccPu(start = UdPcc0Pu) "Filtered d-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, -78}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilteredPccPu(start = UqPcc0Pu) "Filtered q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-108, -92}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {17, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -64}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {67, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -52}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {87, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = PFilter0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 84}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 77}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, 96}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 33}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage module reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, 24}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 3}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = voltageReferenceControl.QFilterRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 8}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -19}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaSetPu annotation(
    Placement(visible = true, transformation(origin = {-108, 60}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 55}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 31}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 17}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {106, 84}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {106, 72}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.VoltageReferenceControl voltageReferenceControl(DeltaVVId0 = 0, DeltaVVIq0 = 0, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, Kff = Kff, Mq = Mq, QFilter0Pu = QFilter0Pu, URef0Pu = URef0Pu, UdRef0Pu = UdFilter0Pu, UqRef0Pu = UqFilter0Pu, Wf = Wf, Wff = Wff) annotation(
    Placement(transformation(origin = {-52, 24}, extent = {{-16, -16}, {16, 16}})));
  Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.DynQSEM QSEM(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, LFilter = LTransformerPu, Omega0Pu = Omega0Pu, RFilter = RTransformerPu, UdFilter0Pu = UdFilter0Pu, UdPcc0Pu = UdPcc0Pu, UqFilter0Pu = UqFilter0Pu, UqPcc0Pu = UqPcc0Pu, XVI = XVI) annotation(
    Placement(transformation(origin = {-8, 26}, extent = {{-16, -16}, {16, 16}})));
  Electrical.Controls.PEIR.BaseControls.CurrentLoops.DynCurrentLoop currentLoop(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, Kfd = Kfd, Kfq = Kfq, Kic = Kic, Kpc = Kpc, LFilter = LFilterPu, RFilter = RFilterPu, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, UqConv0Pu = UqConv0Pu, UqFilter0Pu = UqFilter0Pu, Omega0Pu = Omega0Pu) annotation(
    Placement(transformation(origin = {75, 23}, extent = {{-17, -17}, {17, 17}})));
  Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls.VSM VSM(H = H, PFilter0Pu = PFilter0Pu, kVSM = kVSM, Omega0Pu = Omega0Pu, Theta0 = Theta0) annotation(
    Placement(transformation(origin = {-14, 78}, extent = {{-16, -16}, {16, 16}})));
  Electrical.Controls.Converters.InnerControls.CurrentSaturation CSA(Imax =Imax, Imin = 0, idConvRef0Pu = idConvRef0Pu, iqConvRef0Pu = iqConvRef0Pu, idConvSatRef0Pu = idConvSatRef0Pu, iqConvSatRef0Pu = iqConvSatRef0Pu, CurrentModule0 = CurrentModule0, CurrentAngle0 = CurrentAngle0, W_CurrentLimit = W_CurrentLimit)  annotation(
    Placement(transformation(origin = {40, 24}, extent = {{-10, -10}, {10, 10}})));
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
  parameter Real  CurrentModule0 "start value of the Module of the current in dq representation idConvPu,iqConvPu";
  parameter Real  CurrentAngle0 "start value of the Phase Angle of the current in dq representation idConvPu,iqConvPu";
  parameter Real W_CurrentLimit "Bandwidth of the current saturation block rad/sec";
  parameter Real Imax "Current max threshold to limit a current's module";
  parameter Real DeltaVVId0 "d-axis delta voltage virtual impedance (base UNom, SNom)";
  parameter Real DeltaVVIq0 "q-axis delta voltage virtual impedance (base UNom, SNom)";
  Modelica.Blocks.Math.Gain gain(k = XVI)  annotation(
    Placement(transformation(origin = {-76, -30}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Math.Gain gain1(k = -XVI) annotation(
    Placement(transformation(origin = {-82, -10}, extent = {{-4, -4}, {4, 4}})));

equation
  connect(udConvRefPu, currentLoop.udConvRefPu) annotation(
    Line(points = {{107, 31}, {94, 31}, {94, 30}}, color = {245, 121, 0}, thickness = 0.5));
  connect(VSM.omegaPu, QSEM.omegaPu) annotation(
    Line(points = {{4, 72}, {16, 72}, {16, 44}, {-8, 44}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, omegaPu) annotation(
    Line(points = {{4, 72}, {106, 72}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{4, 72}, {76, 72}, {76, 42}, {75, 42}}, color = {0, 0, 127}));
  connect(VSM.omegaRefPu, omegaRefPu) annotation(
    Line(points = {{-32, 91}, {-72, 91}, {-72, 96}, {-108, 96}}, color = {0, 0, 127}, thickness = 0.5));
  connect(PFilterRefPu, VSM.PFilterRefPu) annotation(
    Line(points = {{-108, 84}, {-32, 84}}, color = {85, 170, 0}, thickness = 0.5));
  connect(PFilterPu, VSM.PFilterPu) annotation(
    Line(points = {{-108, 72}, {-32, 72}}, color = {85, 170, 0}));
  connect(idConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{-108, -16}, {-108, 4}, {83.5, 4}}, color = {245, 121, 0}, pattern = LinePattern.Dash));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{-108, -34}, {-108, -36}, {92, -36}, {92, 4}}, color = {245, 121, 0}, pattern = LinePattern.Dash));
  connect(udFilterPu, currentLoop.udFilterPu) annotation(
    Line(points = {{80, -106}, {80, -51}, {77, -51}, {77, 4}}, color = {85, 170, 0}));
  connect(voltageReferenceControl.idPccPu, idPccPu) annotation(
    Line(points = {{-52, 6}, {-52, -52}, {-108, -52}}, color = {85, 170, 255}));
  connect(iqPccPu, voltageReferenceControl.iqPccPu) annotation(
    Line(points = {{-108, -64}, {-34, -64}, {-34, 6}, {-44, 6}}, color = {85, 170, 255}));
  connect(currentLoop.uqFilterPu, uqFilterPu) annotation(
    Line(points = {{71, 4}, {71, -77}, {70, -77}, {70, -106}}, color = {85, 170, 0}));
  connect(omegaSetPu, VSM.omegaSetPu) annotation(
    Line(points = {{-108, 60}, {-72, 60}, {-72, 65}, {-32, 65}}, color = {0, 0, 127}));
  connect(currentLoop.uqConvRefPu, uqConvRefPu) annotation(
    Line(points = {{94, 16}, {94, 17}, {107, 17}}, color = {245, 121, 0}, thickness = 0.5));
  connect(VSM.theta, theta) annotation(
    Line(points = {{4, 84}, {106, 84}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.udRefPu, QSEM.udFilterRefPu) annotation(
    Line(points = {{-34, 30}, {-25, 30}, {-25, 33}}, color = {85, 170, 0}, thickness = 0.5));
  connect(voltageReferenceControl.uqRefPu, QSEM.uqFilterRefPu) annotation(
    Line(points = {{-34, 17}, {-26.5, 17}, {-26.5, 21}, {-31, 21}, {-31, 20}, {-26, 20}}, color = {85, 170, 0}, thickness = 0.5));
  connect(QFilterPu, voltageReferenceControl.QPu) annotation(
    Line(points = {{-108, 46}, {-60, 46}, {-60, 42}}, color = {85, 170, 0}));
  connect(URefPu, voltageReferenceControl.URefPu) annotation(
    Line(points = {{-108, 24}, {-70, 24}}, color = {85, 170, 0}, thickness = 0.5));
  connect(QFilterRefPu, voltageReferenceControl.QFilterRefPu) annotation(
    Line(points = {{-108, 8}, {-70, 8}}, color = {85, 170, 0}, thickness = 0.5));
  connect(QSEM.idConvRefPu, CSA.idConvRefPu) annotation(
    Line(points = {{10, 32}, {25.5, 32}, {25.5, 28}, {29, 28}}, color = {0, 0, 127}));
  connect(QSEM.iqConvRefPu, CSA.iqConvRefPu) annotation(
    Line(points = {{10, 20}, {27.5, 20}, {27.5, 24}, {29, 24}}, color = {0, 0, 127}));
  connect(CSA.idConvSatRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{52, 28}, {56, 28}, {56, 30}}, color = {0, 0, 127}));
  connect(CSA.iqConvSatRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{52, 22}, {56, 22}, {56, 16}}, color = {0, 0, 127}));
  connect(idPccPu, CSA.idPcc) annotation(
    Line(points = {{-108, -52}, {36, -52}, {36, 14}}, color = {85, 170, 255}));
  connect(iqPccPu, CSA.iqPcc) annotation(
    Line(points = {{-108, -64}, {46, -64}, {46, 14}}, color = {85, 170, 255}));
  connect(iqConvPu, gain.u) annotation(
    Line(points = {{-108, -34}, {-81, -34}, {-81, -30}}, color = {0, 0, 127}));
  connect(gain.y, voltageReferenceControl.DeltaVVId) annotation(
    Line(points = {{-72, -30}, {-68, -30}, {-68, 6}}, color = {0, 0, 127}));
  connect(idConvPu, gain1.u) annotation(
    Line(points = {{-108, -16}, {-92, -16}, {-92, -10}, {-86, -10}}, color = {0, 0, 127}));
  connect(gain1.y, voltageReferenceControl.DeltaVVIq) annotation(
    Line(points = {{-78, -10}, {-60, -10}, {-60, 6}}, color = {0, 0, 127}));
  connect(udFilteredPccPu, QSEM.udFilteredPCCPu) annotation(
    Line(points = {{-108, -78}, {-12, -78}, {-12, 8}}, color = {0, 0, 127}));
  connect(QSEM.uqFilteredPCCPu, uqFilteredPccPu) annotation(
    Line(points = {{-4, 8}, {-4, -92}, {-108, -92}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Diagram(graphics = {Text(origin = {33, 35}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvRefPu", fontSize = 5, textStyle = {TextStyle.Bold}), Text(origin = {33, 23}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvRefPu", fontSize = 5, textStyle = {TextStyle.Bold}), Text(origin = {-23, 35}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udFilterRefPu", fontSize = 5, textStyle = {TextStyle.Bold}), Text(origin = {-23, 23}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqFilterRefPu", fontSize = 5, textStyle = {TextStyle.Bold})}, coordinateSystem(extent = {{-120, 100}, {120, -120}})));


end DynGridFormingControlVSM_CSA;
