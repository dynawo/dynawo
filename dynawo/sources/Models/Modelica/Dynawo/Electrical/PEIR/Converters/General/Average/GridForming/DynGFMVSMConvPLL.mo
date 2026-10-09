within Dynawo.Electrical.PEIR.Converters.General.Average.GridForming;

model DynGFMVSMConvPLL "PEIR model with GFM VSM control and dynamic connections to the grid"
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
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;
  // Installation parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter";
  parameter Types.Time tUFilt = 0.01 "Filter time constant for voltage measurement in s";
  // VSM parameters
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain" annotation(
    Dialog(tab = "VSM"));
  parameter Types.Time H "Inertia constant in s" annotation(
    Dialog(tab = "VSM"));
  // Virtual impedance parameters
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance" annotation(
    Dialog(tab = "VI"));
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance" annotation(
    Dialog(tab = "VI"));
  parameter Types.CurrentModulePu IMaxVIPu "Maximum current before activating the virtual impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "VI"));
  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.AngularVelocity Omegaf "Cutoff pulsation of the active and reactive filters (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.AngularVelocity Omegaff "Cutoff pulsation of the active damping (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Kff "Gain of the active damping" annotation(
    Dialog(tab = "Voltage Reference"));
  // PLL parameters
  parameter Types.PerUnit OmegaPLL "PLL bandwidth (in rad/s)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit KsiPLL "PLL damping ratio (dimensionless)" annotation(
    Dialog(tab = "PLL"));
  final parameter Types.PerUnit Ki = OmegaPLL*OmegaPLL/SystemBase.omegaNom "PLL integrator gain";
  final parameter Types.PerUnit Kp = 2*KsiPLL*OmegaPLL/SystemBase.omegaNom "PLL proportional gain";
  // QSEM parameter
  parameter Real XVIPu "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control" annotation(
    Dialog(tab = "QSEM"));
  // Current loop parameters
  parameter Types.PerUnit Omegac "Current Loop bandwidth (in rad/s)" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis" annotation(
    Dialog(tab = "Current loop"));
  final parameter Types.PerUnit Kic = RFilterPu*Omegac "Integrator Gain of the current loop, derived from the bandwidth";
  final parameter Types.PerUnit Kpc = LFilterPu*Omegac/SystemBase.omegaNom "Integrator gain of the current loop, to cancel one pole of the transfer function";
  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  parameter Types.PerUnit CFilterPu "Filter capacitance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));
  // VSC parameter
  parameter Types.Time tVSC "VSC time response in s" annotation(
    Dialog(tab = "VSC"));
  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(transformation(origin = {106, 42}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = Control.PFilter0Pu) "Active power reference at the filter in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "System frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = Control.URef0Pu) "Voltage reference at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = Control.voltageReferenceControl.QFilterRef0Pu) "Reactive power reference at the filter in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Controls.PEIR.Converters.Average.DynGridFormingControlVSM Control(H = H, IMaxVIPu = IMaxVIPu, IdConv0Pu = Converter.transformRItoDQConv.ud0, IdPcc0Pu = Converter.transformRItoDQIPcc.ud0, IqConv0Pu = Converter.transformRItoDQConv.uq0, IqPcc0Pu = Converter.transformRItoDQIPcc.uq0, Kfd = Kfd, Kff = Kff, Kfq = Kfq, KpVI = KpVI, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, Mq = Mq, Omega0Pu = SystemBase.omegaRef0Pu, PFilter0Pu = Measurements.PFilter0Pu, QFilter0Pu = Measurements.QFilter0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, Theta0 = Converter.Theta0, UdConv0Pu = Converter.transformRItoDQUConv.ud0, UdFilter0Pu = Converter.transformRItoDQFilter.ud0, UdPcc0Pu = Converter.transformRItoDQUPcc.ud0, UqConv0Pu = Converter.transformRItoDQUConv.uq0, UqFilter0Pu = Converter.transformRItoDQFilter.uq0, UqPcc0Pu = Converter.transformRItoDQUPcc.uq0, Omegaf = Omegaf, Omegaff = Omegaff, XRratio = XRratio, XVIPu = XVIPu, kVSM = kVSM, u0Pu = u0Pu, U0Pu = U0Pu, UPhase0 = UPhase0, URef0Pu = Modelica.ComplexMath.'abs'(uEmf0Pu), Kic = Kic, Kpc = Kpc, Kp = Kp, Ki = Ki) annotation(
    Placement(visible = true, transformation(origin = {-46, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Electrical.Controls.PEIR.BaseControls.Auxiliaries.Measurements Measurements(IdPcc0Pu = Converter.transformRItoDQIPcc.ud0, IqPcc0Pu = Converter.transformRItoDQIPcc.uq0, UdFilter0Pu = Converter.transformRItoDQFilter.ud0, UdPcc0Pu = Converter.transformRItoDQUPcc.ud0, UqFilter0Pu = Converter.transformRItoDQFilter.uq0, UqPcc0Pu = Converter.transformRItoDQUPcc.uq0, tUFilt = tUFilt) annotation(
    Placement(visible = true, transformation(origin = {18, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Sources.PEIR.Converters.Average.DynConverter Converter(SNom = SNom, tVSC = tVSC, RFilterPu = RFilterPu, LFilterPu = LFilterPu, CFilterPu = CFilterPu, RTransformerPu = RTransformerPu, LTransformerPu = LTransformerPu, i0Pu = i0Pu, u0Pu = u0Pu, Theta0 = Theta0, Omega0Pu = SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {59, 41}, extent = {{-21, -21}, {21, 21}})));
  // Operating point
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal/PCC in rad";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.AngularVelocityPu OmegaSetPu "Defaut angular velocity reference for the converter in pu (base omegaNom)";
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexCurrentPu iPcc0GenPu = -i0Pu*SystemBase.SnRef/SNom "Start value of the complex current at terminal/PCC in pu (base UNom, SNom) (generator convention)";
  final parameter Types.ComplexVoltagePu uFilterPhys0Pu = u0Pu + Complex(RTransformerPu, LTransformerPu*SystemBase.omegaRef0Pu)*iPcc0GenPu "Start value of the physical complex voltage at the filter capacitor in pu (base UNom)";
  final parameter Types.ComplexCurrentPu iConv0Pu = iPcc0GenPu + Complex(0, SystemBase.omegaRef0Pu*CFilterPu)*uFilterPhys0Pu "Start value of the complex converter current in pu (base UNom, SNom) (generator convention)";
  final parameter Types.CurrentModulePu IConv0Pu = Modelica.ComplexMath.'abs'(iConv0Pu) "Start value of the converter current module in pu (base UNom, SNom)";
  final parameter Types.PerUnit RVirt0Pu = KpVI*max(IConv0Pu - IMaxVIPu, 0) "Start value of the current-limiting virtual resistance in pu (base UNom, SNom)";
  final parameter Types.PerUnit XVirt0Pu = RVirt0Pu*XRratio "Start value of the current-limiting virtual reactance in pu (base UNom, SNom)";
  final parameter Types.ComplexVoltagePu uEmf0Pu = u0Pu + Complex(RTransformerPu, LTransformerPu*SystemBase.omegaRef0Pu + XVIPu)*iConv0Pu + Complex(Kff, 0)*iPcc0GenPu + Complex(RVirt0Pu, XVirt0Pu)*iConv0Pu "Start value of the internal EMF seen by the control (QSEM drop with IConv, plus the Kff term and the virtual impedance drop of the voltage reference control) in pu (base UNom)";
  final parameter Types.Angle Theta0 = atan2(uEmf0Pu.im, uEmf0Pu.re) "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad (d-axis aligned with the internal EMF)";
equation
  Control.uPccPu = terminal.V;
  connect(Measurements.QFilterPu, Control.QFilterPu) annotation(
    Line(points = {{-4, -37}, {-84, -37}, {-84, 23}, {-68, 23}}, color = {85, 170, 0}));
  connect(Measurements.PFilterPu, Control.PFilterPu) annotation(
    Line(points = {{-4, -44}, {-88, -44}, {-88, 27}, {-68, 27}}, color = {85, 170, 0}));
  connect(Measurements.udFilteredPccPu, Control.udFilteredPccPu) annotation(
    Line(points = {{-4, -20}, {-38, -20}, {-38, 20}}, color = {85, 170, 255}));
  connect(Measurements.uqFilteredPccPu, Control.uqFilteredPccPu) annotation(
    Line(points = {{-4, -28}, {-42, -28}, {-42, 20}}, color = {85, 170, 255}));
  connect(Control.PFilterRefPu, PFilterRefPu) annotation(
    Line(points = {{-68, 58}, {-74, 58}, {-74, 80}, {-110, 80}}, color = {85, 170, 0}, thickness = 0.5));
  connect(omegaRefPu, Control.omegaRefPu) annotation(
    Line(points = {{-110, 48}, {-68, 48}}, color = {0, 0, 127}, thickness = 0.5));
  connect(QFilterRefPu, Control.QFilterRefPu) annotation(
    Line(points = {{-110, 16}, {-98, 16}, {-98, 30}, {-72, 30}, {-72, 38}, {-68, 38}}, color = {85, 170, 0}, thickness = 0.5));
  connect(UFilterRefPu, Control.URefPu) annotation(
    Line(points = {{-110, 34}, {-80, 34}, {-80, 42}, {-68, 42}}, color = {85, 170, 0}, thickness = 0.5));
  connect(Control.theta, Converter.theta) annotation(
    Line(points = {{-56, 64}, {-56, 80}, {70, 80}, {70, 64}}, color = {0, 0, 127}));
  connect(Converter.terminal, terminal) annotation(
    Line(points = {{82, 42}, {106, 42}}, color = {0, 0, 255}));
  connect(Converter.idPccPu, Control.idPccPu) annotation(
    Line(points = {{40, 18}, {40, 8}, {-28, 8}, {-28, 20}}, color = {0, 0, 127}));
  connect(Control.iqPccPu, Converter.iqPccPu) annotation(
    Line(points = {{-32, 20}, {-32, 0}, {44, 0}, {44, 18}}, color = {0, 0, 127}));
  connect(Converter.uqPccPu, Measurements.uqPccPu) annotation(
    Line(points = {{56, 18}, {58, 18}, {58, -34}, {40, -34}}, color = {0, 0, 127}));
  connect(Converter.udPccPu, Measurements.udPccPu) annotation(
    Line(points = {{52, 18}, {52, -30}, {40, -30}}, color = {0, 0, 127}));
  connect(Converter.udFilterPu, Measurements.udFilterPu) annotation(
    Line(points = {{62, 18}, {64, 18}, {64, -44}, {40, -44}}, color = {0, 0, 127}));
  connect(Converter.uqFilterPu, Measurements.uqFilterPu) annotation(
    Line(points = {{66, 18}, {66, -46}, {40, -46}}, color = {0, 0, 127}));
  connect(Converter.idPccPu, Measurements.idPccPu) annotation(
    Line(points = {{40, 18}, {40, -16}}, color = {0, 0, 127}));
  connect(Converter.iqPccPu, Measurements.iqPccPu) annotation(
    Line(points = {{44, 18}, {44, -20}, {40, -20}}, color = {0, 0, 127}));
  connect(Converter.udFilterPu, Control.udFilterPu) annotation(
    Line(points = {{62, 18}, {64, 18}, {64, -64}, {-50, -64}, {-50, 20}}, color = {0, 0, 127}));
  connect(Converter.uqFilterPu, Control.uqFilterPu) annotation(
    Line(points = {{66, 18}, {66, -72}, {-54, -72}, {-54, 20}}, color = {0, 0, 127}));
  connect(Control.iqConvPu, Converter.iqConvPu) annotation(
    Line(points = {{-62, 20}, {-62, -88}, {78, -88}, {78, 18}}, color = {0, 0, 127}));
  connect(Converter.idConvPu, Control.idConvPu) annotation(
    Line(points = {{74, 18}, {72, 18}, {72, -80}, {-58, -80}, {-58, 20}}, color = {0, 0, 127}));
  connect(Control.udConvRefPu, Converter.udConvRefPu) annotation(
    Line(points = {{-24, 50}, {36, 50}}, color = {0, 0, 127}));
  connect(Control.uqConvRefPu, Converter.uqConvRefPu) annotation(
    Line(points = {{-24, 34}, {36, 34}, {36, 32}}, color = {0, 0, 127}));
  connect(Control.omegaPLL, Converter.omegaPu) annotation(
    Line(points = {{-30, 64}, {-30, 70}, {48, 70}, {48, 64}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents a power-electronics interface resource, with the following elements:<div><br></div><div>- A Grid-Forming Virtual Synchronous Machine control defining voltage source references at the converter interface</div><div>- A converter part with an AVM model, a dynamic RLC filter and a dynamic RL transformer</div><div>- A measurement block to apply measurement treatment to the voltage and current</div><div><br></div><div>As of today, the model doesn't include any current saturation scheme.</div><div>The small difference with the classic DynGFMVSM model is that angular velocity fed to the converter block is the one measured by the PLL (<i>omegaPLL</i>) instead of the true <i>omegaVSM </i>produced by the VSM block.</div><h4>Initialization</h4>
<p>The initial state of the converter and of its control is computed from the load flow values at the terminal/PCC (U0Pu, UPhase0, P0Pu, Q0Pu), in the following steps:</p>
<ol>
<li><b>PCC current:</b> the complex current at the PCC is deduced from the power flow, i<sub>0</sub> = conj((P<sub>0</sub> + jQ<sub>0</sub>) / u<sub>0</sub>), and converted to the generator convention and to the converter base: i<sub>Pcc0</sub> = − i<sub>0</sub> · SnRef / SNom.</li>
<li><b>Physical filter voltage and converter current:</b> going back from the PCC through the transformer, the voltage at the filter capacitor is u<sub>Filter0</sub> = u<sub>0</sub> + (R<sub>T</sub> + jL<sub>T</sub>ω<sub>0</sub>) · i<sub>Pcc0</sub>, and the converter current is the PCC current plus the capacitor current, i<sub>Conv0</sub> = i<sub>Pcc0</sub> + jC<sub>F</sub>ω<sub>0</sub> · u<sub>Filter0</sub> (steady-state phasor relations at ω<sub>0</sub> = SystemBase.omegaRef0Pu).</li>
<li><b>Initial virtual impedance:</b> the current-limiting virtual impedance is computed from the initial converter current module I<sub>Conv0</sub> = |i<sub>Conv0</sub>|, with the same law as in the virtual impedance block: R<sub>Virt0</sub> = K<sub>pVI</sub> · max(I<sub>Conv0</sub> − I<sub>MaxVI</sub>, 0) and X<sub>Virt0</sub> = σ<sub>X/R</sub> · R<sub>Virt0</sub>. It is normally equal to zero, as the converter is not in overcurrent at initialization.</li>
<li><b>Internal voltage of the control:</b> the internal voltage u<sub>Emf0</sub> is obtained by adding to the PCC voltage all the voltage drops that are subtracted from it in the control:
<ul>
<li>the drop of the QSEM impedance (transformer impedance and permanent virtual reactance X<sub>VI</sub>), computed with the converter current since the QSEM imposes i<sub>Conv</sub> = (E − u<sub>Pcc</sub>) / Z in steady state: (R<sub>T</sub> + j(L<sub>T</sub>ω<sub>0</sub> + X<sub>VI</sub>)) · i<sub>Conv0</sub>;</li>
<li>the drop of the active damping of the voltage reference control: K<sub>ff</sub> · i<sub>Pcc0</sub>;</li>
<li>the drop of the current-limiting virtual impedance: (R<sub>Virt0</sub> + jX<sub>Virt0</sub>) · i<sub>Conv0</sub>.</li>
</ul>
u<sub>Emf0</sub> = u<sub>0</sub> + (R<sub>T</sub> + j(L<sub>T</sub>ω<sub>0</sub> + X<sub>VI</sub>)) · i<sub>Conv0</sub> + K<sub>ff</sub> · i<sub>Pcc0</sub> + (R<sub>Virt0</sub> + jX<sub>Virt0</sub>) · i<sub>Conv0</sub></li>
<li><b>Initial angle:</b> the d-axis of the converter rotating frame is aligned with this internal voltage, Θ<sub>0</sub> = arg(u<sub>Emf0</sub>), and its module is used as the initial voltage magnitude reference (URef0Pu = |u<sub>Emf0</sub>|). Since the reactive power reference is initialized at its measured value (no initial contribution of the Q–V droop), the voltage reference control then has a purely d-axis set point U<sub>Ref0</sub>, from which the active damping and virtual impedance drops are subtracted to give the QSEM voltage reference.</li>
</ol>
<p>Note that u<sub>Emf0</sub> is not the physical voltage at the filter capacitor u<sub>Filter0</sub>: it includes the virtual terms of the control (X<sub>VI</sub>, K<sub>ff</sub>, virtual impedance) and the QSEM drop is computed with the converter current instead of the PCC current. This consistent initialization ensures that all the control blocks start in steady state, without initial transient.</p>
</body></html>"),
    Diagram(graphics = {Text(origin = {11, 11}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "idPccPu"), Text(origin = {11, 3}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "iqPccPu"), Text(origin = {-21, -25}, textColor = {85, 170, 255}, extent = {{-15, 1}, {15, -1}}, textString = "uqFilteredPccPu"), Text(origin = {-21, -17}, textColor = {85, 170, 255}, extent = {{-15, 1}, {15, -1}}, textString = "udFilteredPccPu"), Text(origin = {51, -27}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "udPccPu"), Text(origin = {51, -37}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "uqPccPu"), Text(origin = {19, -61}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udFilterPu"), Text(origin = {19, -71}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqFilterPu"), Text(origin = {-21, -35}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "QFilterPu"), Text(origin = {-21, -41}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "PFilterPu"), Text(origin = {9, 53}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {9, 37}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {19, -77}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvPu"), Text(origin = {19, -83}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvPu"), Text(origin = {9, 83}, textColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "theta")}));
end DynGFMVSMConvPLL;
