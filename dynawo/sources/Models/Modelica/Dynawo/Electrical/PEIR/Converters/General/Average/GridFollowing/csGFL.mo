within Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing;

model csGFL "PEIR model with GFL control and dynamic connections to the grid"
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

  // Installation parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter";
  parameter Types.Time tUFilt = 0.01 "Filter time constant for voltage measurement in s";

  // PLL parameters
  parameter Types.PerUnit Ki "PLL integrator gain" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit Kp "PLL proportional gain" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit OmegaMaxPu "Upper frequency limit in pu (base OmegaNom)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit OmegaMinPu "Lower frequency limit in pu (base OmegaNom)" annotation(
    Dialog(tab = "PLL"));
  // Outer loop parameters
  parameter Types.PerUnit Kpd "Active power PI controller proportional gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.PerUnit Kid "Active power PI controller integral gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.PerUnit Kpq "Reactive power PI controller proportional gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.PerUnit Kiq "Reactive power PI controller integral gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.Time tPFilt "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.Time tQFilt "Filter time constant for reactive power measurement in s" annotation(
    Dialog(tab = "Outer loop"));
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));
  parameter Types.PerUnit XTransformerPu "Transformer inductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {106, 42}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = Control.outerLoop.PFilter0Pu) "Active power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "System frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = Control.outerLoop.QFilter0Pu) "Reactive power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries.Measurements Measurements(IdPcc0Pu = Converter.refFrameRotation.IdPcc0Pu, IqPcc0Pu = Converter.refFrameRotation.IqPcc0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UdPcc0Pu = Converter.refFrameRotation.UdPcc0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, UqPcc0Pu = Converter.refFrameRotation.UqPcc0Pu, tUFilt = tUFilt) annotation(
    Placement(visible = true, transformation(origin = {14, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
 Dynawo.Electrical.Controls.PEIR.Converters.Average.csGridFollowingControl Control(IdFilter0Pu = Converter.refFrameRotation.IdPcc0Pu, IqFilter0Pu = Converter.refFrameRotation.IqPcc0Pu,Ki = Ki, Kid = Kid, Kiq = Kiq, Kp = Kp, Kpd = Kpd, Kpq = Kpq, Omega0Pu = SystemBase.omegaRef0Pu, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, PFilter0Pu = Measurements.PFilter0Pu, QFilter0Pu = Measurements.QFilter0Pu, RTransformerPu = RTransformerPu, Theta0 = Theta0, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, XTransformerPu = XTransformerPu, tPFilt = tPFilt, tQFilt = tQFilt)  annotation(
    Placement(visible = true, transformation(origin = {-46, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Dynawo.Electrical.Sources.PEIR.Converters.Average.Converter2 Converter(RTransformerPu = RTransformerPu, SNom = SNom, Theta0 = Theta0, XTransformerPu = XTransformerPu, i0Pu = i0Pu, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {62, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));


  // Operating point
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal/PCC in rad";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal/PCC in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = ComplexMath.conj(Complex(P0Pu, Q0Pu) / u0Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uFilter0Pu = u0Pu - Complex(RTransformerPu, XTransformerPu) * i0Pu * SystemBase.SnRef / SNom "Start value of the complex voltage at the filter in pu (base UNom)";
  final parameter Types.Angle Theta0 = atan2(uFilter0Pu.im, uFilter0Pu.re) "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";

equation
 connect(omegaRefPu, Control.omegaRefPu) annotation(
    Line(points = {{-110, 48}, {-68, 48}}, color = {0, 0, 127}, thickness = 0.5));
 connect(Converter.terminal, terminal) annotation(
    Line(points = {{84, 42}, {106, 42}}, color = {0, 0, 255}));
 connect(Control.iqFilterRefPu, Converter.iqFilterRefPu) annotation(
    Line(points = {{-24, 34}, {40, 34}}, color = {85, 170, 0}, thickness = 0.5));
 connect(Control.idFilterRefPu, Converter.idFilterRefPu) annotation(
    Line(points = {{-24, 50}, {40, 50}}, color = {85, 170, 0}, thickness = 0.5));
 connect(Control.theta, Converter.theta) annotation(
    Line(points = {{-56, 64}, {-56, 80}, {62, 80}, {62, 64}}, color = {0, 0, 127}));
 connect(Control.PFilterRefPu, PFilterRefPu) annotation(
    Line(points = {{-68, 58}, {-80, 58}, {-80, 64}, {-110, 64}}, color = {85, 170, 0}, thickness = 0.5));
 connect(QFilterRefPu, Control.QFilterRefPu) annotation(
    Line(points = {{-110, 32}, {-80, 32}, {-80, 38}, {-68, 38}}, color = {85, 170, 0}, thickness = 0.5));
 connect(Control.QFilterPu, Measurements.QFilterPu) annotation(
    Line(points = {{-68, 24}, {-72, 24}, {-72, -37}, {-8, -37}}, color = {85, 170, 0}));
 connect(Measurements.PFilterPu, Control.PFilterPu) annotation(
    Line(points = {{-8, -44}, {-76, -44}, {-76, 28}, {-68, 28}}, color = {85, 170, 0}));
 connect(Converter.idPccPu, Measurements.idPccPu) annotation(
    Line(points = {{44, 20}, {44, -16}, {36, -16}}, color = {85, 170, 255}));
 connect(Converter.iqPccPu, Measurements.iqPccPu) annotation(
    Line(points = {{48, 20}, {48, -20}, {36, -20}}, color = {85, 170, 255}));
 connect(Measurements.udPccPu, Converter.udPccPu) annotation(
    Line(points = {{36, -30}, {56, -30}, {56, 20}}, color = {85, 170, 255}));
 connect(Measurements.uqPccPu, Converter.uqPccPu) annotation(
    Line(points = {{36, -34}, {60, -34}, {60, 20}}, color = {85, 170, 255}));
 connect(Measurements.udFilterPu, Converter.udFilterPu) annotation(
    Line(points = {{36, -44}, {66, -44}, {66, 20}}, color = {85, 170, 0}, pattern = LinePattern.Dash));
 connect(Measurements.uqFilterPu, Converter.uqFilterPu) annotation(
    Line(points = {{36, -46}, {70, -46}, {70, 20}}, color = {85, 170, 0}, pattern = LinePattern.Dash));
 connect(Converter.uqFilterPu, Control.uqFilterPu) annotation(
    Line(points = {{70, 20}, {70, -74}, {-54, -74}, {-54, 20}}, color = {85, 170, 0}));
protected
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents a power-electronics interface resource, with the following elements:<div><br></div><div>- A Grid-Forming Virtual Synchronous Machine control defining voltage source references at the converter interface</div><div>- A converter part with an AVM model, a dynamic RLC filter and a dynamic RL transformer</div><div>- A measurement block to apply measurement treatment to the voltage and current</div><div><br></div><div>As of today, the model doesn't include any current saturation scheme.</div><div><br></div><div><br></div><div><br></div></body></html>"),
    Diagram(graphics = {Text(origin = {47, -27}, lineColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "udPccPu"), Text(origin = {51, -37}, lineColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "uqPccPu"), Text(origin = {19, -71}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqFilterPu"), Text(origin = {-21, -33}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "QFilterPu"), Text(origin = {-21, -41}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "PFilterPu"), Text(origin = {9, 53}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idFilterRefPu", textStyle = {TextStyle.Bold}), Text(origin = {9, 37}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqFilterRefPu", textStyle = {TextStyle.Bold}), Text(origin = {9, 83}, lineColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "theta")}));
end csGFL;
