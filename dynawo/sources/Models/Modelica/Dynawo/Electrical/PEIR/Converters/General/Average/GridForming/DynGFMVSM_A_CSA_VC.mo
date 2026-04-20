within Dynawo.Electrical.PEIR.Converters.General.Average.GridForming;

model DynGFMVSM_A_CSA_VC "PEIR model with GFM VSM control and dynamic connections to the grid"
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
  //extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;
  // Installation parameter
  import Modelica.Constants.pi;
  final parameter Types.Frequency fNom = 50 "System AC frequency Hz";
  final parameter Types.AngularVelocity Wn = 2*pi*fNom "nominal angular frequency rad/s";
  parameter Types.PerUnit SCR "SCR of the grid connection";
  parameter Types.ApparentPowerModule SNom = 1 "Nominal apparent power module for the converter";
  parameter Types.Time tUFilt = 0.01 "Filter time constant for voltage measurement in s";
  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Wf = Wn/10 "Cutoff pulsation of the active and reactive filters (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Kff "Gain of the active damping" annotation(
    Dialog(tab = "Voltage Reference"));
  // QSEM parameter
  parameter Real XVI "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control" annotation(
    Dialog(tab = "QSEM"));
  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  parameter Types.PerUnit CFilterPu "Filter capacitance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  // Current loop parameters
  parameter Real Wnc "Bandwidth of the current control loop in rad/s, = Wvsc/10";
  parameter Types.PerUnit Kpc = (LFilterPu)*Wnc/Wn "Proportional gain of the current loop" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kic = (RFilterPu)*Wnc "Integral gain of the current loop" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfd = 1 "Feedforward gain on the d-axis" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfq = 1 "Feedforward gain on the q-axis" annotation(
    Dialog(tab = "Current loop"));
  parameter Real Ts = 0.001 "Delay for the backward loop";
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));
  //VSM Parameters
  parameter Types.Time H "Inertia constant in s" annotation(
    Dialog(tab = "VSM"));
  final parameter Real Leq = LTransformerPu + LFilterPu + 1/10 + XVI "impedance equivalente estimated , considering SCR=10";
  parameter Real AmortisementVSM = 0.7 "amortisement pour la bocle de synchronisation";
  final parameter Real Kp_GFo = AmortisementVSM*sqrt(2/(H*Wn*1/Leq)) "parameter in between Kd";
  final parameter Real kVSM = 2*H*Kp_GFo*Wn/Leq "";
  // VSC parameter
  parameter Types.Time tVSC "VSC time response in s" annotation(
    Dialog(tab = "VSC"));
  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {106, 42}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = Control.PFilter0Pu) "Active power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = Control.QFilter0Pu) "Reactive power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "System frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = Control.URef0Pu) "Voltage reference at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaSet(k = OmegaSetPu) annotation(
    Placement(visible = true, transformation(origin = {-106, 66}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Electrical.Sources.PEIR.Converters.Average.DynConverter1 Converter(CFilterPu = CFilterPu, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, Omega0Pu = SystemBase.omegaRef0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, SNom = SNom, Theta0 = Theta0, i0Pu = i0Pu, tVSC = tVSC, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {66, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Electrical.Controls.PEIR.BaseControls.Auxiliaries.Measurements Measurements(IdPcc0Pu = Converter.refFrameRotation.IdPcc0Pu, IqPcc0Pu = Converter.refFrameRotation.IqPcc0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UdPcc0Pu = Converter.refFrameRotation.UdPcc0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, UqPcc0Pu = Converter.refFrameRotation.UqPcc0Pu, tUFilt = tUFilt) annotation(
    Placement(visible = true, transformation(origin = {18, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Electrical.Controls.PEIR.Converters.Average.DynGridFormingControlVSM_CSA_VC Control(kVSM = kVSM, H = H, Mq = Mq, Wf = Wf, Wff = Wff, Kff = Kff, XVI = XVI, Kpc = Kpc, Kic = Kic, Kfd = Kfd, Kfq = Kfq, RFilterPu = RFilterPu, LFilterPu = LFilterPu, RTransformerPu = RTransformerPu, LTransformerPu = LTransformerPu, idConvRef0Pu = idConvRef0Pu, iqConvRef0Pu = iqConvRef0Pu, idConvSatRef0Pu = idConvSatRef0Pu, iqConvSatRef0Pu = iqConvSatRef0Pu, CurrentModule0 = CurrentModule0, CurrentAngle0 = CurrentAngle0, W_CurrentLimit = W_CurrentLimit, Imax = Imax,DeltaVVId0 = DeltaVVId0, DeltaVVIq0 = DeltaVVIq0, UdConv0Pu = Converter.RLCFilter.UdConv0Pu, UqConv0Pu = Converter.RLCFilter.UqConv0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, UdPcc0Pu = Converter.refFrameRotation.UdPcc0Pu, UqPcc0Pu = Converter.refFrameRotation.UqPcc0Pu, IdConv0Pu = Converter.RLCFilter.IdConv0Pu, IdPcc0Pu = Converter.refFrameRotation.IdPcc0Pu, IqConv0Pu = Converter.RLCFilter.IqConv0Pu, IqPcc0Pu = Converter.refFrameRotation.IqPcc0Pu, Theta0 = Converter.Theta0, Omega0Pu = SystemBase.omegaRef0Pu, PFilter0Pu = Measurements.PFilter0Pu, QFilter0Pu = Measurements.QFilter0Pu, Ts = Ts) annotation(
    Placement(transformation(origin = {-48, 48}, extent = {{-20, -20}, {20, 20}})));
  // Operating point
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal/PCC in rad";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.AngularVelocityPu OmegaSetPu "Defaut angular velocity reference for the converter in pu (base omegaNom)";
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uFilter0Pu = u0Pu - Complex(RTransformerPu, LTransformerPu*SystemBase.omegaRef0Pu)*i0Pu*SystemBase.SnRef/SNom "Start value of the complex voltage at the filter in pu (base UNom)";
  final parameter Types.Angle Theta0 = atan2(uFilter0Pu.im, uFilter0Pu.re) "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
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
equation
  connect(Measurements.idPccPu, Converter.idPccPu) annotation(
    Line(points = {{40, -16}, {48, -16}, {48, 20}}, color = {85, 170, 255}, pattern = LinePattern.Dash));
  connect(Measurements.iqPccPu, Converter.iqPccPu) annotation(
    Line(points = {{40, -20}, {52, -20}, {52, 20}}, color = {85, 170, 255}, pattern = LinePattern.Dash));
  connect(Measurements.udPccPu, Converter.udPccPu) annotation(
    Line(points = {{40, -30}, {60, -30}, {60, 20}}, color = {85, 170, 255}));
  connect(Measurements.uqPccPu, Converter.uqPccPu) annotation(
    Line(points = {{40, -34}, {64, -34}, {64, 20}}, color = {85, 170, 255}));
  connect(Converter.udFilterPu, Measurements.udFilterPu) annotation(
    Line(points = {{70, 20}, {70, -44}, {40, -44}}, color = {85, 170, 0}, pattern = LinePattern.Dash));
  connect(Converter.uqFilterPu, Measurements.uqFilterPu) annotation(
    Line(points = {{74, 20}, {74, -46}, {40, -46}}, color = {85, 170, 0}, pattern = LinePattern.Dash));
  connect(Converter.terminal, terminal) annotation(
    Line(points = {{88, 42}, {106, 42}}, color = {0, 0, 255}));
  connect(PFilterRefPu, Control.PFilterRefPu) annotation(
    Line(points = {{-110, 80}, {-86, 80}, {-86, 63}, {-70, 63}}, color = {0, 0, 127}));
  connect(omegaSet.y, Control.omegaSetPu) annotation(
    Line(points = {{-100, 66}, {-90, 66}, {-90, 59}, {-70, 59}}, color = {0, 0, 127}));
  connect(omegaRefPu, Control.omegaRefPu) annotation(
    Line(points = {{-110, 48}, {-88, 48}, {-88, 55}, {-70, 55}}, color = {0, 0, 127}));
  connect(UFilterRefPu, Control.URefPu) annotation(
    Line(points = {{-110, 34}, {-82, 34}, {-82, 49}, {-70, 49}}, color = {0, 0, 127}));
  connect(Measurements.PFilterPu, Control.PFilterPu) annotation(
    Line(points = {{-4, -48}, {-74, -48}, {-74, 33}, {-70, 33}}, color = {85, 170, 0}));
  connect(Converter.iqConvPu, Control.iqConvPu) annotation(
    Line(points = {{84, 20}, {84, -86}, {-65, -86}, {-65, 26}}, color = {245, 121, 0}));
  connect(Converter.idConvPu, Control.idConvPu) annotation(
    Line(points = {{80, 20}, {80, -80}, {-61, -80}, {-61, 26}}, color = {245, 121, 0}));
  connect(Converter.uqFilterPu, Control.uqFilterPu) annotation(
    Line(points = {{74, 20}, {74, -68}, {-55, -68}, {-55, 26}}, color = {85, 170, 0}));
  connect(Converter.udFilterPu, Control.udFilterPu) annotation(
    Line(points = {{70, 20}, {70, -64}, {-51, -64}, {-51, 26}}, color = {85, 170, 0}));
  connect(Measurements.uqFilteredPccPu, Control.uqFilteredPccPu) annotation(
    Line(points = {{-4, -26}, {-4, 26}, {-45, 26}}, color = {85, 170, 255}));
  connect(Measurements.udFilteredPccPu, Control.udFilteredPccPu) annotation(
    Line(points = {{-4, -20}, {-4, 26}, {-41, 26}}, color = {85, 170, 255}));
  connect(Control.iqPccPu, Converter.iqPccPu) annotation(
    Line(points = {{-35, 26}, {-35, 0}, {52, 0}, {52, 20}}, color = {85, 170, 255}));
  connect(Control.idPccPu, Converter.idPccPu) annotation(
    Line(points = {{-31, 26}, {-31, 8}, {48, 8}, {48, 20}}, color = {85, 170, 255}));
  connect(Control.theta, Converter.theta) annotation(
    Line(points = {{-58, 70}, {-58, 86}, {76, 86}, {76, 64}}, color = {0, 0, 127}));
  connect(Control.omegaPu, Converter.omegaPu) annotation(
    Line(points = {{-38, 70}, {-38, 80}, {56, 80}, {56, 64}}, color = {0, 0, 127}));
  connect(Control.udConvRefPu, Converter.udConvRefPu) annotation(
    Line(points = {{-26, 56}, {-26, 58}, {44, 58}, {44, 50}}, color = {245, 121, 0}));
  connect(Control.uqConvRefPu, Converter.uqConvRefPu) annotation(
    Line(points = {{-26, 40}, {32, 40}, {32, 34}, {44, 34}}, color = {245, 121, 0}));
  connect(Measurements.QFilterPu, Control.QFilterPu) annotation(
    Line(points = {{-4, -44}, {-70, -44}, {-70, 30}}, color = {85, 170, 0}));
  connect(QFilterRefPu, Control.QFilterRefPu) annotation(
    Line(points = {{-110, 16}, {-80, 16}, {-80, 44}, {-70, 44}}, color = {0, 0, 127}));
equation

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents a power-electronics interface resource, with the following elements:<div><br></div><div>- A Grid-Forming Virtual Synchronous Machine control defining voltage source references at the converter interface with a current saturation block</div><div>- A converter part with an AVM model, a dynamic RLC filter and a dynamic RL transformer</div><div>- A measurement block to apply measurement treatment to the voltage and current</div><div><br></div><div><br></div><div><br></div><div>Sources for equations:</div><div>- kVSM: Fundamental considerations about grid forming control, Xavier Guillaud, L2EP summer shcool July 2024</div><div>- Kpc, Kic: thèse de Yahya Lamrani, Appendix A.4.2, Equation A.20</div><div><br></div><div><br></div><div><br></div></body></html>"),
    Diagram(graphics = {Text(origin = {11, 11}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "idPccPu"), Text(origin = {11, 3}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "iqPccPu"), Text(origin = {-21, -23}, textColor = {85, 170, 255}, extent = {{-15, 1}, {15, -1}}, textString = "uqFilteredPccPu"), Text(origin = {-21, -17}, textColor = {85, 170, 255}, extent = {{-15, 1}, {15, -1}}, textString = "udFilteredPccPu"), Text(origin = {51, -27}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "udPccPu"), Text(origin = {51, -37}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "uqPccPu"), Text(origin = {19, -61}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udFilterPu"), Text(origin = {19, -71}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqFilterPu"), Text(origin = {-27, -41}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "QFilterPu"), Text(origin = {-23, -51}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "PFilterPu"), Text(origin = {9, 53}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {9, 37}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {19, -77}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvPu"), Text(origin = {19, -83}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvPu"), Text(origin = {9, 83}, textColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "theta"), Text(origin = {9, 75}, textColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "omegaPu")}));
end DynGFMVSM_A_CSA_VC;