within Dynawo.Electrical.PEIR.Converters.General.Average.GridForming;

model DynGFMVSM2 "PEIR model with GFM VSM control and dynamic connections to the grid"
  /*
          * Copyright (c) 2026, RTE (http://www.rte-france.com)
          * See AUTHORS.txt
          * All rights reserved.
          * This Source Code Form is subject to the terms of the Mozilla Public
          * License, v. 2.0. If a copy of the MPL was not distributed with this
          * file, you can obtain one at http://mozilla.org/MPL/2.0/.
          * SPDX-License-Identifier: MPL-2.0
          *
          * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
          */
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
  parameter Types.CurrentModulePu IMaxVI "Maximum current before activating the virtual impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "VI"));
  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Kff "Gain of the active damping" annotation(
    Dialog(tab = "Voltage Reference"));
  // QSEM parameter
  parameter Real XVI "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control" annotation(
    Dialog(tab = "QSEM"));
  // Current loop parameters
  parameter Types.PerUnit Kpc "Proportional gain of the current loop" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kic "Integral gain of the current loop" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfd = 0 "Feedforward gain on the d-axis" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfq = 0 "Feedforward gain on the q-axis" annotation(
    Dialog(tab = "Current loop"));
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
  Modelica.Blocks.Sources.Constant omegaSet(k = OmegaSetPu) annotation(
    Placement(visible = true, transformation(origin = {-106, 66}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = Control.QFilter0Pu) "Reactive power reference at the filter in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Controls.PEIR.Converters.Average.DynGridFormingControlVSM Control(H = H, IMaxVI = IMaxVI, IdConv0Pu = Converter.compRItoDQConv.IdConv0Pu, IdPcc0Pu = Converter.compRItoDQPcc.IdConv0Pu, IqConv0Pu = Converter.compRItoDQConv.IqConv0Pu, IqPcc0Pu = Converter.compRItoDQPcc.IqConv0Pu, Kfd = Kfd, Kff = Kff, Kfq = Kfq, Kic = Kic, KpVI = KpVI, Kpc = Kpc, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, Mq = Mq, Omega0Pu = SystemBase.omegaRef0Pu, PFilter0Pu = Measurements.PFilter0Pu, QFilter0Pu = Measurements.QFilter0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, Theta0 = Converter.Theta0, UdConv0Pu = Converter.compRItoDQConv.UdFilter0Pu, UdFilter0Pu = Converter.compRItoDQFilter.UdFilter0Pu, UdPcc0Pu = Converter.compRItoDQPcc.UdFilter0Pu, UqConv0Pu = Converter.compRItoDQConv.UqFilter0Pu, UqFilter0Pu = Converter.compRItoDQFilter.UqFilter0Pu, UqPcc0Pu = Converter.compRItoDQPcc.UqFilter0Pu, Wf = Wf, Wff = Wff, XRratio = XRratio, XVI = XVI, kVSM = kVSM) annotation(
    Placement(visible = true, transformation(origin = {-46, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Electrical.Controls.PEIR.BaseControls.Auxiliaries.Measurements Measurements(IdPcc0Pu = Converter.compRItoDQPcc.IdConv0Pu, IqPcc0Pu = Converter.compRItoDQPcc.IqConv0Pu, UdFilter0Pu = Converter.compRItoDQFilter.UdFilter0Pu, UdPcc0Pu = Converter.compRItoDQPcc.UdFilter0Pu, UqFilter0Pu = Converter.compRItoDQFilter.UqFilter0Pu, UqPcc0Pu = Converter.compRItoDQPcc.UqFilter0Pu, tUFilt = tUFilt) annotation(
    Placement(visible = true, transformation(origin = {18, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
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
  Sources.PEIR.Converters.Average.DynConverter2 Converter(SNom = SNom, tVSC = tVSC, RFilterPu = RFilterPu, LFilterPu = LFilterPu, CFilterPu = CFilterPu, RTransformerPu = RTransformerPu, LTransformerPu = LTransformerPu, i0Pu = i0Pu, u0Pu = u0Pu, Theta0 = Theta0)  annotation(
    Placement(transformation(origin = {59, 41}, extent = {{-21, -21}, {21, 21}})));
equation
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
  connect(omegaSet.y, Control.omegaSetPu) annotation(
    Line(points = {{-99, 66}, {-80, 66}, {-80, 54}, {-68, 54}}, color = {0, 0, 127}));
  connect(QFilterRefPu, Control.QFilterRefPu) annotation(
    Line(points = {{-110, 16}, {-98, 16}, {-98, 30}, {-72, 30}, {-72, 38}, {-68, 38}}, color = {85, 170, 0}, thickness = 0.5));
  connect(UFilterRefPu, Control.URefPu) annotation(
    Line(points = {{-110, 34}, {-80, 34}, {-80, 42}, {-68, 42}}, color = {85, 170, 0}, thickness = 0.5));
  connect(Control.theta, Converter.theta) annotation(
    Line(points = {{-56, 64}, {-56, 80}, {70, 80}, {70, 64}}, color = {0, 0, 127}));
  connect(Control.udConvRefPu, Converter.udConvRefPu) annotation(
    Line(points = {{-24, 50}, {36, 50}}, color = {0, 0, 127}));
  connect(Control.uqConvRefPu, Converter.uqConvRefPu) annotation(
    Line(points = {{-24, 34}, {36, 34}, {36, 32}}, color = {0, 0, 127}));
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
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents a power-electronics interface resource, with the following elements:<div><br></div><div>- A Grid-Forming Virtual Synchronous Machine control defining voltage source references at the converter interface</div><div>- A converter part with an AVM model, a dynamic RLC filter and a dynamic RL transformer</div><div>- A measurement block to apply measurement treatment to the voltage and current</div><div><br></div><div>As of today, the model doesn't include any current saturation scheme.</div><div><br></div><div><br></div><div><br></div></body></html>"),
    Diagram(graphics = {Text(origin = {11, 11}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "idPccPu"), Text(origin = {11, 3}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "iqPccPu"), Text(origin = {-21, -25}, textColor = {85, 170, 255}, extent = {{-15, 1}, {15, -1}}, textString = "uqFilteredPccPu"), Text(origin = {-21, -17}, textColor = {85, 170, 255}, extent = {{-15, 1}, {15, -1}}, textString = "udFilteredPccPu"), Text(origin = {51, -27}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "udPccPu"), Text(origin = {51, -37}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "uqPccPu"), Text(origin = {19, -61}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udFilterPu"), Text(origin = {19, -71}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqFilterPu"), Text(origin = {-21, -35}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "QFilterPu"), Text(origin = {-21, -41}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "PFilterPu"), Text(origin = {9, 53}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {9, 37}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {19, -77}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvPu"), Text(origin = {19, -83}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvPu"), Text(origin = {9, 83}, textColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "theta")}));
end DynGFMVSM2;
