within Dynawo.Electrical.PEIR.Converters.General.Average.GridForming;

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

model DynVcGFMVSM "PEIR model with GFM VSM control and dynamic connections to the grid"

  // Installation parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter";
  parameter Types.Time tUFilt = 0.01 "Filter time constant for voltage measurement in s";

  // VSM parameters
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain" annotation(Dialog(tab = "VSM"));
  parameter Types.Time H "Inertia constant in s" annotation(Dialog(tab = "VSM"));

  // Virtual impedance parameters
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance" annotation(Dialog(tab = "VI"));
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance" annotation(Dialog(tab = "VI"));
  parameter Types.CurrentModulePu IMaxVI "Maximum current before activating the virtual impedance in pu (base UNom, SNom)" annotation(Dialog(tab = "VI"));

  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient" annotation(Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)" annotation(Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)" annotation(Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Kff "Gain of the active damping" annotation(Dialog(tab = "Voltage Reference"));

  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)" annotation(Dialog(tab = "Filter"));
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)" annotation(Dialog(tab = "Filter"));
  parameter Types.PerUnit CFilterPu "Filter capacitance in pu (base UNom, SNom)" annotation(Dialog(tab = "Filter"));

  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)" annotation(Dialog(tab = "Transformer"));
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)" annotation(Dialog(tab = "Transformer"));

  // VSC parameter
  parameter Types.Time tVSC "VSC time response in s" annotation(Dialog(tab = "VSC"));

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {106, 42}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = Control.PFilter0Pu) "Active power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "System frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UConvRefPu(start = Control.URef0Pu) "Voltage reference in pu (base UNom)"  annotation(
    Placement(visible = true, transformation(origin = {-110, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaSet(k = OmegaSetPu)  annotation(
    Placement(visible = true, transformation(origin = {-106, 66}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = Control.QFilter0Pu) "Reactive power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Sources.PEIR.Converters.Average.DynConverter1 Converter(CFilterPu = CFilterPu, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, Omega0Pu = SystemBase.omegaRef0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, SNom = SNom, Theta0 = Theta0, i0Pu = i0Pu, tVSC = tVSC, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {66, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries.Measurements Measurements(IdPcc0Pu = Converter.refFrameRotation.IdPcc0Pu, IqPcc0Pu = Converter.refFrameRotation.IqPcc0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UdPcc0Pu = Converter.refFrameRotation.UdPcc0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, UqPcc0Pu = Converter.refFrameRotation.UqPcc0Pu, tUFilt = tUFilt)  annotation(
    Placement(visible = true, transformation(origin = {18, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  // Operating point
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal/PCC in rad";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.AngularVelocityPu OmegaSetPu "Defaut angular velocity reference for the converter in pu (base omegaNom)";

  final parameter Types.ComplexVoltagePu u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = ComplexMath.conj(Complex(P0Pu, Q0Pu) / u0Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uFilter0Pu = u0Pu - Complex(RTransformerPu, LTransformerPu*SystemBase.omegaRef0Pu) * i0Pu * SystemBase.SnRef / SNom "Start value of the complex voltage at the filter in pu (base UNom)";
  final parameter Types.ComplexCurrentPu iConv0Pu = i0Pu * SystemBase.SnRef / SNom + Complex(0, CFilterPu*SystemBase.omegaRef0Pu) * uFilter0Pu;
  final parameter Types.ComplexVoltagePu uConv0Pu = uFilter0Pu - Complex(RFilterPu, LFilterPu*SystemBase.omegaRef0Pu) * iConv0Pu;
  final parameter Types.Angle Theta0 = atan2(uConv0Pu.im, uConv0Pu.re) "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";

  Dynawo.Electrical.Controls.PEIR.Converters.Average.DynVcGridFormingControlVSM Control(H = H, IMaxVI = IMaxVI, IdConv0Pu = Converter.RLCFilter.IdConv0Pu, IdPcc0Pu = Converter.RLTransformer.IdPcc0Pu, IqConv0Pu = Converter.RLCFilter.IqConv0Pu, IqPcc0Pu = Converter.RLTransformer.IqPcc0Pu, Kff = Kff, KpVI = KpVI, Mq = Mq, Omega0Pu = SystemBase.omegaRef0Pu, PFilter0Pu = Measurements.PFilter0Pu, QFilter0Pu = Measurements.QFilter0Pu, Theta0 = Converter.Theta0, UdConv0Pu = Converter.RLCFilter.UdConv0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UdPcc0Pu = Converter.RLTransformer.UdPcc0Pu, UqConv0Pu = Converter.RLCFilter.UqConv0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, UqPcc0Pu = Converter.RLTransformer.UqPcc0Pu, Wf = Wf, Wff = Wff, XRratio = XRratio, kVSM = kVSM)  annotation(
    Placement(visible = true, transformation(origin = {-46, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

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
    Line(points = {{70, 20}, {70, -44}, {40, -44}}, color = {85, 170, 0}));
  connect(Converter.uqFilterPu, Measurements.uqFilterPu) annotation(
    Line(points = {{74, 20}, {74, -46}, {40, -46}}, color = {85, 170, 0}));
  connect(Converter.terminal, terminal) annotation(
    Line(points = {{88, 42}, {106, 42}}, color = {0, 0, 255}));
  connect(Control.uqConvRefPu, Converter.uqConvRefPu) annotation(
    Line(points = {{-24, 34}, {44, 34}}, color = {245, 121, 0}, thickness = 0.5));
  connect(Control.udConvRefPu, Converter.udConvRefPu) annotation(
    Line(points = {{-24, 50}, {44, 50}}, color = {245, 121, 0}, thickness = 0.5));
  connect(Control.omegaPu, Converter.omegaPu) annotation(
    Line(points = {{-36, 64}, {-36, 72}, {56, 72}, {56, 64}}, color = {0, 0, 127}));
  connect(Control.theta, Converter.theta) annotation(
    Line(points = {{-56, 64}, {-56, 80}, {76, 80}, {76, 64}}, color = {0, 0, 127}));
  connect(Control.PFilterRefPu, PFilterRefPu) annotation(
    Line(points = {{-68, 58}, {-72, 58}, {-72, 80}, {-110, 80}}, color = {85, 170, 0}, thickness = 0.5));
  connect(Control.omegaSetPu, omegaSet.y) annotation(
    Line(points = {{-68, 54}, {-80, 54}, {-80, 66}, {-100, 66}}, color = {0, 0, 127}));
  connect(omegaRefPu, Control.omegaRefPu) annotation(
    Line(points = {{-110, 48}, {-68, 48}}, color = {0, 0, 127}, thickness = 0.5));
  connect(Control.PFilterPu, Measurements.PFilterPu) annotation(
    Line(points = {{-68, 28}, {-76, 28}, {-76, -44}, {-4, -44}}, color = {85, 170, 0}));
  connect(Control.idPccPu, Converter.idPccPu) annotation(
    Line(points = {{-28, 20}, {-28, 8}, {48, 8}, {48, 20}}, color = {85, 170, 255}));
  connect(Converter.iqPccPu, Control.iqPccPu) annotation(
    Line(points = {{52, 20}, {52, 0}, {-32, 0}, {-32, 20}}, color = {85, 170, 255}));
  connect(Converter.idConvPu, Control.idConvPu) annotation(
    Line(points = {{80, 20}, {80, -80}, {-58, -80}, {-58, 20}}, color = {245, 121, 0}));
  connect(Converter.iqConvPu, Control.iqConvPu) annotation(
    Line(points = {{84, 20}, {84, -86}, {-62, -86}, {-62, 20}}, color = {245, 121, 0}));
  connect(QFilterRefPu, Control.QFilterRefPu) annotation(
    Line(points = {{-110, 16}, {-78, 16}, {-78, 38}, {-68, 38}}, color = {85, 170, 0}, thickness = 0.5));
  connect(Control.QFilterPu, Measurements.QFilterPu) annotation(
    Line(points = {{-68, 24}, {-72, 24}, {-72, -36}, {-4, -36}}, color = {85, 170, 0}));
  connect(UConvRefPu, Control.URefPu) annotation(
    Line(points = {{-110, 34}, {-80, 34}, {-80, 42}, {-68, 42}}, color = {245, 121, 0}, thickness = 0.5));
  annotation(preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents a power-electronics interface resource, with the following elements:<div><br></div><div>- A Grid-Forming Virtual Synchronous Machine control defining voltage source references at the converter interface</div><div>- A converter part with an AVM model, a dynamic RLC filter and a dynamic RL transformer</div><div>- A measurement block to apply measurement treatment to the voltage and current</div><div><br></div><div>As of today, the model doesn't include any current saturation scheme.</div><div><br></div><div><br></div><div><br></div></body></html>"),
  Diagram(graphics = {Text(origin = {11, 11}, lineColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "idPccPu"), Text(origin = {11, 3}, lineColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "iqPccPu"), Text(origin = {51, -27}, lineColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "udPccPu"), Text(origin = {51, -37}, lineColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "uqPccPu"), Text(origin = {-21, -33}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "QFilterPu"), Text(origin = {-21, -41}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "PFilterPu"), Text(origin = {9, 53}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {9, 37}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {19, -77}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvPu"), Text(origin = {19, -83}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvPu"), Text(origin = {9, 83}, lineColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "theta"), Text(origin = {9, 75}, lineColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "omegaPu")}));
end DynVcGFMVSM;
