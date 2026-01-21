within Dynawo.Electrical.Sources.PEIR.Converters.Average;

model Converter2 "Converter physical part comprising an ideal voltage source, a RLC Filter and a RL Transformer"
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
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter in MVA";

  // RL transformer parameters
  parameter Types.PerUnit RTransformerPu "Resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XTransformerPu "Impedance in pu (base UNom, SNom)";

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {105, 3}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Inputs
  Modelica.Blocks.Interfaces.RealInput idFilterRefPu(start = refFrameRotation.IdPcc0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-112, 28}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-109, 41}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqFilterRefPu(start = refFrameRotation.IqPcc0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-112, 8}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {-112, -64}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput udFilterPu(start = RLTransformer.UdFilter0Pu) "d-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-16, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270), iconTransformation(origin = {16, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu(start = RLTransformer.UqFilter0Pu) "q-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {10, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270), iconTransformation(origin = {38, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput udPccPu(start = refFrameRotation.UdPcc0Pu) "d-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {42, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270), iconTransformation(origin = {-34, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput uqPccPu(start = refFrameRotation.UqPcc0Pu) "q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {62, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270), iconTransformation(origin = {-12, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput idPccPu(start = refFrameRotation.IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {10, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput iqPccPu(start = refFrameRotation.IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));

  Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters.RefFrameRotation refFrameRotation(SNom = SNom, Theta0 = Theta0, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {77, 3}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters.RLTransformer RLTransformer(IdPcc0Pu = refFrameRotation.IdPcc0Pu, IqPcc0Pu = refFrameRotation.IqPcc0Pu, RPu = RTransformerPu, UdPcc0Pu = refFrameRotation.UdPcc0Pu, UqPcc0Pu = refFrameRotation.UqPcc0Pu, XPu = XTransformerPu) annotation(
    Placement(visible = true, transformation(origin = {25, 3}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));

  // Initial parameters
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in pu (base UNom)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";

equation
  connect(theta, refFrameRotation.theta) annotation(
    Line(points = {{-112, -64}, {77, -64}, {77, -13.5}}, color = {0, 0, 127}));
  connect(refFrameRotation.terminal, terminal) annotation(
    Line(points = {{93.5, 3}, {105, 3}}, color = {0, 0, 255}));
  connect(RLTransformer.udPccPu, refFrameRotation.udPccPu) annotation(
    Line(points = {{42, -2}, {60, -2}}, color = {85, 170, 255}));
  connect(RLTransformer.uqPccPu, refFrameRotation.uqPccPu) annotation(
    Line(points = {{42, -8}, {60, -8}}, color = {85, 170, 255}));
  connect(refFrameRotation.iqPccPu, RLTransformer.iqPccPu) annotation(
    Line(points = {{60, 8}, {48, 8}, {48, 30}, {2, 30}, {2, 8}, {8, 8}}, color = {85, 170, 255}));
  connect(RLTransformer.uqFilterPu, uqFilterPu) annotation(
    Line(points = {{8, -8}, {0, -8}, {0, -60}, {10, -60}, {10, -110}}, color = {85, 170, 0}));
  connect(refFrameRotation.uqPccPu, uqPccPu) annotation(
    Line(points = {{60.5, -7.5}, {56, -7.5}, {56, -60}, {62, -60}, {62, -110}}, color = {85, 170, 255}));
  connect(RLTransformer.udPccPu, udPccPu) annotation(
    Line(points = {{42, -2}, {48, -2}, {48, -60}, {42, -60}, {42, -110}}, color = {85, 170, 255}));
  connect(iqPccPu, refFrameRotation.iqPccPu) annotation(
    Line(points = {{40, 110}, {40, 30}, {48, 30}, {48, 7.5}, {60.5, 7.5}}, color = {85, 170, 255}, pattern = LinePattern.Dash));
  connect(RLTransformer.uqFilterPu, uqFilterPu) annotation(
    Line(points = {{8, -8}, {0, -8}, {0, -60}, {10, -60}, {10, -110}}, color = {0, 0, 255}));
  connect(RLTransformer.udPccPu, refFrameRotation.udPccPu) annotation(
    Line(points = {{42, -2}, {60, -2}}, color = {0, 0, 255}));
  connect(RLTransformer.uqPccPu, refFrameRotation.uqPccPu) annotation(
    Line(points = {{42, -8}, {60, -8}}, color = {0, 0, 255}));
  connect(refFrameRotation.iqPccPu, RLTransformer.iqPccPu) annotation(
    Line(points = {{60, 8}, {48, 8}, {48, 30}, {2, 30}, {2, 8}, {8, 8}}, color = {0, 0, 255}));
  connect(iqFilterRefPu, RLTransformer.iqPccPu) annotation(
    Line(points = {{-112, 8}, {8, 8}}, color = {85, 170, 0}, thickness = 0.5));
  connect(idFilterRefPu, RLTransformer.idPccPu) annotation(
    Line(points = {{-112, 28}, {-80, 28}, {-80, 14}, {8, 14}}, color = {85, 170, 0}, thickness = 0.5));
  connect(RLTransformer.idPccPu, refFrameRotation.idPccPu) annotation(
    Line(points = {{8, 14}, {-4, 14}, {-4, 40}, {54, 40}, {54, 14}, {60, 14}}, color = {85, 170, 255}));
  connect(RLTransformer.idPccPu, idPccPu) annotation(
    Line(points = {{8, 14}, {-4, 14}, {-4, 40}, {10, 40}, {10, 110}}, color = {85, 170, 255}, pattern = LinePattern.Dash));
  connect(udFilterPu, RLTransformer.udFilterPu) annotation(
    Line(points = {{-16, -110}, {-16, -2}, {8, -2}}, color = {85, 170, 0}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents the physical part of a converter with an ideal voltage source, a dynamic RLC filter, a dynamic RL transformer and a reference frame rotation.<div><br></div><div>The interface variables are the current and voltages from the terminal.</div></body></html>"));
end Converter2;
