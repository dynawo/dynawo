within Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing;

model DynGFLMeasurementFiltered "PEIR model with GFL control and dynamic connections to the grid"
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
extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;
  // Installation parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter";

  // Measurements parameters
  parameter Types.Time tUFilt  "Filter time constant for voltage measurement in s" annotation(
  Dialog(tab="Measurements"));
  parameter Types.Time tUqPLL "Filter time constant for voltage q measurement specially designed for the PLL in s" annotation(  Dialog(tab="Measurements"));
  parameter Types.Time tPQFilt "Filter time constant for voltage/current measurement that goes to the PQ calculation in s" annotation(  Dialog(tab="Measurements"));
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
  // Current loop parameters
  parameter Types.PerUnit Kpc "Proportional gain of the current loop" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kic "Integral gain of the current loop" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfd  "Feedforward gain on the d-axis" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfq  "Feedforward gain on the q-axis" annotation(
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

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {106, 42}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = Control.outerLoop.PFilter0Pu) "Active power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "System frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = Control.outerLoop.QFilter0Pu) "Reactive power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries.MeasurementsFiltered Measurements(IdPcc0Pu = Converter.refFrameRotation.IdPcc0Pu, IqPcc0Pu = Converter.refFrameRotation.IqPcc0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UdPcc0Pu = Converter.refFrameRotation.UdPcc0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, UqPcc0Pu = Converter.refFrameRotation.UqPcc0Pu, tPQFilt = tPQFilt, tUFilt = tUFilt, tUqPLL = tUqPLL) annotation(
    Placement(visible = true, transformation(origin = {18, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Dynawo.Electrical.Sources.PEIR.Converters.Average.DynConverter1 Converter(CFilterPu = CFilterPu, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, Omega0Pu = SystemBase.omegaRef0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, SNom = SNom, Theta0 = Theta0, i0Pu = i0Pu, tVSC = tVSC, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {70, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Operating point
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal/PCC in rad";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal/PCC in pu (base SnRef) (receptor convention)";

  final parameter Types.ComplexVoltagePu u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = ComplexMath.conj(Complex(P0Pu, Q0Pu) / u0Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uFilter0Pu = u0Pu - Complex(RTransformerPu, LTransformerPu*SystemBase.omegaRef0Pu) * i0Pu * SystemBase.SnRef / SNom "Start value of the complex voltage at the filter in pu (base UNom)";
  final parameter Types.Angle Theta0 = atan2(uFilter0Pu.im, uFilter0Pu.re) "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  Controls.PEIR.Converters.Average.DynGridFollowingControlV2 Control(IdConv0Pu = Converter.RLCFilter.IdConv0Pu, IqConv0Pu = Converter.RLCFilter.IqConv0Pu, Kfd = Kfd, Kfq = Kfq, Ki = Ki, Kic = Kic, Kid = Kid, Kiq = Kiq, Kp = Kp, Kpc = Kpc, Kpd = Kpd, Kpq = Kpq, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, Omega0Pu = SystemBase.omegaRef0Pu, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, PFilter0Pu = Measurements.PFilter0Pu, QFilter0Pu = Measurements.QFilter0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, Theta0 = Converter.Theta0, UdConv0Pu = Converter.RLCFilter.UdConv0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UdFilteredPcc0Pu = Measurements.udFilteredPcc0Pu, UqConv0Pu = Converter.RLCFilter.UqConv0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, UqFilteredPcc0Pu = Measurements.uqFilteredPcc0Pu, tPFilt = tPFilt, tQFilt = tQFilt) annotation(
    Placement(visible = true, transformation(origin = {-46, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(Converter.terminal, terminal) annotation(
    Line(points = {{92, 42}, {106, 42}}, color = {0, 0, 255}));
  connect(Measurements.idPccPu, Converter.idPccPu) annotation(
    Line(points = {{40, -16}, {52, -16}, {52, 20}}, color = {85, 170, 255}));
  connect(Converter.iqPccPu, Measurements.iqPccPu) annotation(
    Line(points = {{56, 20}, {56, -20}, {40, -20}}, color = {85, 170, 255}));
  connect(Measurements.udFilterPu, Converter.udFilterPu) annotation(
    Line(points = {{40, -44}, {74, -44}, {74, 20}}, color = {85, 170, 0}, pattern = LinePattern.Dash));
  connect(Converter.uqFilterPu, Measurements.uqFilterPu) annotation(
    Line(points = {{78, 20}, {78, -46}, {40, -46}}, color = {85, 170, 0}, pattern = LinePattern.Dash));
  connect(Measurements.PFilterPu, Control.PFilterPu) annotation(
    Line(points = {{-4, -48}, {-92, -48}, {-92, 28}, {-68, 28}}, color = {0, 0, 127}));
  connect(QFilterRefPu, Control.QFilterRefPu) annotation(
    Line(points = {{-110, 32}, {-80, 32}, {-80, 38}, {-68, 38}}, color = {85, 170, 0}, thickness = 0.5));
  connect(PFilterRefPu, Control.PFilterRefPu) annotation(
    Line(points = {{-110, 64}, {-80, 64}, {-80, 58}, {-68, 58}}, color = {85, 170, 0}, thickness = 0.5));
  connect(omegaRefPu, Control.omegaRefPu) annotation(
    Line(points = {{-110, 48}, {-68, 48}}, color = {0, 0, 127}, thickness = 0.5));
  connect(Converter.udPccPu, Measurements.udPccPu) annotation(
    Line(points = {{64, 20}, {64, -34}, {40, -34}}, color = {0, 0, 127}));
  connect(Converter.uqPccPu, Measurements.uqPccPu) annotation(
    Line(points = {{68, 20}, {68, -36}, {40, -36}}, color = {0, 0, 127}));
  connect(Converter.idConvPu, Measurements.idConvPu) annotation(
    Line(points = {{84, 20}, {84, -24}, {40, -24}}, color = {230, 97, 0}));
  connect(Converter.iqConvPu, Measurements.iqConvPu) annotation(
    Line(points = {{88, 20}, {86, 20}, {86, -28}, {40, -28}}, color = {255, 120, 0}));
  connect(Measurements.idFilteredConvPu, Control.idConvPu) annotation(
    Line(points = {{22, -54}, {22, -58}, {-62, -58}, {-62, 20}}, color = {230, 97, 0}));
  connect(Measurements.iqFilteredConvPu, Control.iqConvPu) annotation(
    Line(points = {{28, -54}, {28, -60}, {-58, -60}, {-58, 20}}, color = {230, 97, 0}, pattern = LinePattern.Dash));
  connect(Measurements.QFilterPu, Control.QFilterPu) annotation(
    Line(points = {{-4, -44}, {-86, -44}, {-86, 24}, {-68, 24}}, color = {0, 0, 127}));
  connect(Measurements.uq_PLLPu, Control.uq_PLLPu) annotation(
    Line(points = {{8, -54}, {8, -66}, {-50, -66}, {-50, 20}}, color = {152, 106, 68}));
  connect(Control.omegaPu, Converter.omegaPu) annotation(
    Line(points = {{-36, 64}, {-36, 76}, {60, 76}, {60, 64}}, color = {0, 0, 127}));
  connect(Control.theta, Converter.theta) annotation(
    Line(points = {{-56, 64}, {-56, 90}, {80, 90}, {80, 64}}, color = {0, 0, 127}));
  connect(Control.udConvRefPu, Converter.udConvRefPu) annotation(
    Line(points = {{-24, 50}, {48, 50}}, color = {0, 0, 127}));
  connect(Control.uqConvRefPu, Converter.uqConvRefPu) annotation(
    Line(points = {{-24, 34}, {48, 34}}, color = {0, 0, 127}));
  connect(Measurements.udFilteredFilterPu, Control.udFilterPu) annotation(
    Line(points = {{-4, -28}, {-40, -28}, {-40, 20}}, color = {192, 97, 203}));
  connect(Measurements.uqFilteredFilterPu, Control.uqFilterPu) annotation(
    Line(points = {{-4, -32}, {-34, -32}, {-34, 16}, {-30, 16}, {-30, 20}}, color = {192, 97, 203}, pattern = LinePattern.Dash));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents a power-electronics interface resource, with the following elements:<div><br></div><div>- A Grid-Forming Virtual Synchronous Machine control defining voltage source references at the converter interface</div><div>- A converter part with an AVM model, a dynamic RLC filter and a dynamic RL transformer</div><div>- A measurement block to apply measurement treatment to the voltage and current</div><div><br></div><div>As of today, the model doesn't include any current saturation scheme.</div><div><br></div><div><br></div><div><br></div></body></html>"),
    Diagram(graphics = {Text(origin = {57, -35}, lineColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "uqPccPu"), Text(origin = {51, -43}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udFilterPu"), Text(origin = {61, -45}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqFilterPu"), Text(origin = {-17, -43}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "QFilterPu"), Text(origin = {-17, -47}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "PFilterPu"), Text(origin = {9, 53}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {9, 37}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {49, -23}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvPu"), Text(origin = {49, -27}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvPu"), Text(origin = {9, 83}, lineColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "theta"), Text(origin = {9, 75}, lineColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "omegaPu"), Text(origin = {-18, -27}, lineColor = {192, 97, 203}, extent = {{-20, 1}, {20, -1}}, textString = "udFilteredFilterPu"), Text(origin = {-18, -31}, lineColor = {192, 97, 203}, extent = {{-20, 1}, {20, -1}}, textString = "uqFilteredFilterPu"), Text(origin = {-2, -9}, lineColor = {255, 120, 0}, extent = {{-20, 1}, {20, -1}}, textString = "idFilteredPccPu"), Text(origin = {6, -5}, lineColor = {255, 120, 0}, extent = {{-20, 1}, {20, -1}}, textString = "iqFilteredPccPu"), Text(origin = {-17, -37}, lineColor = {26, 95, 180}, extent = {{-13, 1}, {13, -1}}, textString = "QPccPu"), Text(origin = {48, -15}, lineColor = {28, 113, 216}, fillColor = {28, 113, 216}, extent = {{-8, 1}, {8, -1}}, textString = "idPccPu"), Text(origin = {48, -19}, lineColor = {28, 113, 216}, fillColor = {28, 113, 216}, extent = {{-8, 1}, {8, -1}}, textString = "iqPccPu"), Text(origin = {49, -33}, lineColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "udPccPu"), Text(origin = {-32, -57}, lineColor = {255, 120, 0}, extent = {{-20, 1}, {20, -1}}, textString = "idFilteredConvPu"), Text(origin = {-32, -59}, lineColor = {255, 120, 0}, extent = {{-20, 1}, {20, -1}}, textString = "iqFilteredConvPu")}, coordinateSystem(extent = {{-120, 100}, {120, -80}})));
end DynGFLMeasurementFiltered;
