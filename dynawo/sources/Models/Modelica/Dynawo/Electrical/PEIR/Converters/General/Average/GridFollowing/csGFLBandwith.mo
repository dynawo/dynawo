within Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing;

model csGFLBandwith "PEIR model with GFL control and dynamic connections to the grid"
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

  // Measurement parameters
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "Measurements"));
  parameter Types.Time tUqPLL "Filter time constant for voltage q measurement specially designed for the PLL in s" annotation(
    Dialog(tab = "Measurements"));
  parameter Types.Time tPQFilt "Filter time constant for voltage/current measurement that goes to the PQ calculation in s" annotation(
    Dialog(tab = "Measurements"));

  // PLL parameters
  parameter Types.AngularVelocity OmegaPLL "PLL natural frequency (rad/s)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit KsiPLL "PLL damping" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit OmegaMaxPu "Upper frequency limit in pu (base OmegaNom)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit OmegaMinPu "Lower frequency limit in pu (base OmegaNom)" annotation(
    Dialog(tab = "PLL"));

  // Outer loop parameters
  parameter Types.PerUnit Kqv "Reactive current gain for fault-ride through mode in pu"annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.AngularVelocity OmegaP "Bandwith for active power outer loop" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.AngularVelocity OmegaQ "Bandwith for reactive power outer loop" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.AngularVelocity OmegaLPF "Bandwith for low pass filter for the outer loop" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.PerUnit UFrt "Voltage value to activate the frt mode in pu" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.PerUnit IMaxPu "Maximum inverter current amplitude in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Outer loop"));
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag" annotation(
    Dialog(tab = "Outer loop"));

  // Generator parameters
  parameter Types.PerUnit dIdMaxPu = 9999 "Maximum rate-of-change of active current in pu (base UNom, SNom)";
  parameter Types.PerUnit dIdMinPu = -9999 "Minimum rate-of-change of active current in pu (base UNom, SNom)";
  parameter Types.PerUnit dIqMaxPu = 9999 "Maximum rate-of-change of reactive current in pu (base UNom, SNom)";
  parameter Types.PerUnit dIqMinPu = -9999 "Minimum rate-of-change of reactive current in pu (base UNom, SNom)";
  parameter Types.Time tG = 0.003 "Emulated delay in converter controls in s";

  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));
  parameter Types.PerUnit XTransformerPu "Transformer inductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {106, 42}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = Control.outerLoop.PFilter0Pu) "Active power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "System frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = Control.outerLoop.QFilter0Pu) "Reactive power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Dynawo.Electrical.Controls.PEIR.Converters.Average.csGridFollowingControl Control(IMaxPu = IMaxPu,IdFilter0Pu = Converter.refFrameRotation.IdPcc0Pu, IqFilter0Pu = Converter.refFrameRotation.IqPcc0Pu,Ki = Ki, Kid = Kid, Kiq = Kiq, Kp = Kp, Kpd = Kpd, Kpq = Kpq, Kqv = Kqv, Omega0Pu = SystemBase.omegaRef0Pu, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, PFilter0Pu = Measurements.PFilter0Pu, PQFlag = PQFlag, QFilter0Pu = Measurements.QFilter0Pu, RTransformerPu = RTransformerPu, Theta0 = Theta0, UFrt = UFrt, UPcc0Pu = Measurements.UPcc0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, XTransformerPu = XTransformerPu)  annotation(
    Placement(visible = true, transformation(origin = {-48, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Dynawo.Electrical.Sources.PEIR.Converters.Average.Converter2 Converter(RTransformerPu = RTransformerPu, SNom = SNom, Theta0 = Theta0, XTransformerPu = XTransformerPu, dIdMaxPu = dIdMaxPu, dIdMinPu = dIdMinPu, dIqMaxPu = dIqMaxPu, dIqMinPu = dIqMinPu, i0Pu = i0Pu, tG = tG, u0Pu = u0Pu)  annotation(
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

  final parameter Types.PerUnit Ki = OmegaPLL * OmegaPLL / SystemBase.omegaNom "PLL integrator gain";
  final parameter Types.PerUnit Kp = 2 * KsiPLL * OmegaPLL / SystemBase.omegaNom "PLL proportional gain";
  final parameter Types.PerUnit Kpd = OmegaP / OmegaLPF "Active power PI controller proportional gain in pu/s (base UNom, SNom)";
  final parameter Types.PerUnit Kid = OmegaP "Active power PI controller integral gain in pu/s (base UNom, SNom)";
  final parameter Types.PerUnit Kpq = OmegaQ / OmegaLPF "Reactive power PI controller proportional gain in pu/s (base UNom, SNom)";
  final parameter Types.PerUnit Kiq = OmegaQ "Reactive power PI controller integral gain in pu/s (base UNom, SNom)";


  Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries.MeasurementsFiltered2 Measurements(IdPcc0Pu = Converter.refFrameRotation.IdPcc0Pu, IqPcc0Pu = Converter.refFrameRotation.IqPcc0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UdPcc0Pu = Converter.refFrameRotation.UdPcc0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, UqPcc0Pu = Converter.refFrameRotation.UqPcc0Pu, tPQFilt = tPQFilt, tUFilt = tUFilt, tUqPLL = tUqPLL)  annotation(
    Placement(visible = true, transformation(origin = {3, -49}, extent = {{-19, -19}, {19, 19}}, rotation = 180)));
equation
  connect(Converter.terminal, terminal) annotation(
    Line(points = {{84, 42}, {106, 42}}, color = {0, 0, 255}));
 connect(Control.iqFilterRefPu, Converter.iqFilterRefPu) annotation(
    Line(points = {{-26, 32}, {7, 32}, {7, 34}, {40, 34}}, color = {85, 170, 0}, thickness = 0.5));
 connect(Control.idFilterRefPu, Converter.idFilterRefPu) annotation(
    Line(points = {{-26, 48}, {7, 48}, {7, 50}, {40, 50}}, color = {85, 170, 0}, thickness = 0.5));
 connect(Control.theta, Converter.theta) annotation(
    Line(points = {{-58, 62}, {-58, 80}, {62, 80}, {62, 64}}, color = {0, 0, 127}));
 connect(Control.PFilterRefPu, PFilterRefPu) annotation(
    Line(points = {{-70, 55}, {-80, 55}, {-80, 74}, {-110, 74}}, color = {85, 170, 0}, thickness = 0.5));
 connect(QFilterRefPu, Control.QFilterRefPu) annotation(
    Line(points = {{-110, 24}, {-80, 24}, {-80, 36}, {-70, 36}}, color = {85, 170, 0}, thickness = 0.5));
 connect(Converter.idPccPu, Measurements.idPccPu) annotation(
    Line(points = {{44, 20}, {44, -32}, {24, -32}}, color = {85, 170, 255}));
 connect(Measurements.iqPccPu, Converter.iqPccPu) annotation(
    Line(points = {{24, -36}, {48, -36}, {48, 20}}, color = {85, 170, 255}));
 connect(Converter.udPccPu, Measurements.udPccPu) annotation(
    Line(points = {{56, 20}, {54, 20}, {54, -50}, {24, -50}}, color = {85, 170, 255}));
 connect(Measurements.uqPccPu, Converter.uqPccPu) annotation(
    Line(points = {{24, -54}, {60, -54}, {60, 20}}, color = {85, 170, 255}));
 connect(Measurements.udFilterPu, Converter.udFilterPu) annotation(
    Line(points = {{24, -62}, {66, -62}, {66, 20}}, color = {85, 170, 0}));
 connect(Measurements.uqFilterPu, Converter.uqFilterPu) annotation(
    Line(points = {{24, -66}, {70, -66}, {70, 20}}, color = {85, 170, 0}));
 connect(omegaRefPu, Control.omegaRefPu) annotation(
    Line(points = {{-110, 52}, {-89, 52}, {-89, 49}, {-70, 49}}, color = {0, 0, 127}, thickness = 0.5));
 connect(Measurements.uqFilteredFilterPLLPu, Control.uqFilteredPLLPu) annotation(
    Line(points = {{-4, -70}, {-4, -86}, {-90, -86}, {-90, 44}, {-70, 44}}, color = {0, 0, 127}, thickness = 0.5));
 connect(Measurements.PFilteredFilterPu, Control.PFilteredFilterPu) annotation(
    Line(points = {{-18, -66}, {-76, -66}, {-76, 25}, {-70, 25}}, color = {85, 170, 0}));
 connect(Measurements.QFilteredFilterPu, Control.QFilteredFilterPu) annotation(
    Line(points = {{-18, -62}, {-74, -62}, {-74, 21}, {-70, 21}}, color = {85, 170, 0}));
 connect(Control.UFilteredPccPu, Measurements.UFilteredPccPu) annotation(
    Line(points = {{-57, 18}, {-57, -80}, {18, -80}, {18, -70}}, color = {85, 170, 255}));
protected
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents a power-electronics interface resource, with the following elements:<div><br></div><div>- A Grid-Forming Virtual Synchronous Machine control defining voltage source references at the converter interface</div><div>- A converter part with an AVM model, a dynamic RLC filter and a dynamic RL transformer</div><div>- A measurement block to apply measurement treatment to the voltage and current</div><div><br></div><div>As of today, the model doesn't include any current saturation scheme.</div><div><br></div><div><br></div><div><br></div></body></html>"),
    Diagram(graphics = {Text(origin = {9, 53}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idFilterRefPu", textStyle = {TextStyle.Bold}), Text(origin = {9, 37}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqFilterRefPu", textStyle = {TextStyle.Bold}), Text(origin = {9, 83}, lineColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "theta")}));
end csGFLBandwith;
