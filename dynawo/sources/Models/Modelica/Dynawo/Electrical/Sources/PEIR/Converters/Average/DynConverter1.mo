within Dynawo.Electrical.Sources.PEIR.Converters.Average;

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

model DynConverter1 "Converter physical part comprising an AVM voltage source, a dynamic RLC Filter and a dynamic RL Transformer"

  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter in MVA";

  // VSC parameter
  parameter Types.Time tVSC "VSC time response in s";

  // RLC filter parameters
  parameter Types.PerUnit RFilterPu "Resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LFilterPu "Inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit CFilterPu "Capacitance in pu (base UNom, SNom)";

  // RL transformer parameters
  parameter Types.PerUnit RTransformerPu "Resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LTransformerPu "Inductance in pu (base UNom, SNom)";

   Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {105, 3}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Inputs
  Modelica.Blocks.Interfaces.RealInput udConvRefPu(start = RLCFilter.UdConv0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-109, 41}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu(start = RLCFilter.UqConv0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-112, -14}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-112, -40}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-48, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {-112, -64}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {52, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = RLCFilter.IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-52, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = RLCFilter.IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-54, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270), iconTransformation(origin = {92, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
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


  Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters.VSCConverter VSC(tVSC = tVSC, UdConv0Pu = RLCFilter.UdConv0Pu, UqConv0Pu = RLCFilter.UqConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-73, 3}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters.RefFrameRotation refFrameRotation(SNom = SNom, Theta0 = Theta0, i0Pu = i0Pu, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {77, 3}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters.DynRLCFilter RLCFilter(CPu = CFilterPu, LPu = LFilterPu, RPu = RFilterPu, IdPcc0Pu = refFrameRotation.IdPcc0Pu, IqPcc0Pu = refFrameRotation.IqPcc0Pu, Omega0Pu = Omega0Pu, UdFilter0Pu = RLTransformer.UdFilter0Pu, UqFilter0Pu = RLTransformer.UqFilter0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-27, 3}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters.DynRLTransformer RLTransformer(LPu = LTransformerPu, RPu = RTransformerPu, IdPcc0Pu = refFrameRotation.IdPcc0Pu, IqPcc0Pu = refFrameRotation.IqPcc0Pu, Omega0Pu = Omega0Pu, UdPcc0Pu = refFrameRotation.UdPcc0Pu, UqPcc0Pu = refFrameRotation.UqPcc0Pu)  annotation(
    Placement(visible = true, transformation(origin = {25, 3}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));

  // Initial parameters
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in pu (base UNom)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of the converter's frequency in pu (base omegaNom)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";

equation
  connect(theta, refFrameRotation.theta) annotation(
    Line(points = {{-112, -64}, {77, -64}, {77, -13.5}}, color = {0, 0, 127}));
  connect(refFrameRotation.terminal, terminal) annotation(
    Line(points = {{93.5, 3}, {105, 3}}, color = {0, 0, 255}));
  connect(VSC.udConvPu, RLCFilter.udConvPu) annotation(
    Line(points = {{-54, 10}, {-44, 10}}, color = {245, 121, 0}));
  connect(VSC.uqConvPu, RLCFilter.uqConvPu) annotation(
    Line(points = {{-54, -4}, {-44, -4}}, color = {245, 121, 0}));
  connect(RLCFilter.iqPccPu, RLTransformer.iqPccPu) annotation(
    Line(points = {{-10, 8}, {8, 8}}, color = {85, 170, 0}));
  connect(RLCFilter.idPccPu, RLTransformer.idPccPu) annotation(
    Line(points = {{-10, 14}, {8, 14}}, color = {85, 170, 0}));
  connect(RLCFilter.udFilterPu, RLTransformer.udFilterPu) annotation(
    Line(points = {{-10, -2}, {8, -2}}, color = {85, 170, 0}));
  connect(RLCFilter.uqFilterPu, RLTransformer.uqFilterPu) annotation(
    Line(points = {{-10, -8}, {8, -8}}, color = {85, 170, 0}));
  connect(udConvRefPu, VSC.udConvRefPu) annotation(
    Line(points = {{-112, 20}, {-98, 20}, {-98, 10}, {-92, 10}}, color = {245, 121, 0}, thickness = 0.5));
  connect(uqConvRefPu, VSC.uqConvRefPu) annotation(
    Line(points = {{-112, -14}, {-98, -14}, {-98, -4}, {-92, -4}}, color = {245, 121, 0}, thickness = 0.5));
  connect(omegaPu, RLCFilter.omegaPu) annotation(
    Line(points = {{-112, -40}, {-26, -40}, {-26, -14}}, color = {0, 0, 127}));
  connect(omegaPu, RLTransformer.omegaPu) annotation(
    Line(points = {{-112, -40}, {26, -40}, {26, -14}}, color = {0, 0, 127}));
  connect(RLTransformer.udPccPu, refFrameRotation.udPccPu) annotation(
    Line(points = {{42, -2}, {60, -2}}, color = {85, 170, 255}));
  connect(RLTransformer.uqPccPu, refFrameRotation.uqPccPu) annotation(
    Line(points = {{42, -8}, {60, -8}}, color = {85, 170, 255}));
  connect(refFrameRotation.idPccPu, RLCFilter.idPccPu) annotation(
    Line(points = {{60.5, 13.5}, {56, 13.5}, {56, 40}, {-4, 40}, {-4, 14}, {-10, 14}}, color = {85, 170, 255}));
  connect(RLCFilter.idConvPu, idConvPu) annotation(
    Line(points = {{-44, 14}, {-52, 14}, {-52, 110}}, color = {245, 121, 0}));
  connect(RLCFilter.iqConvPu, iqConvPu) annotation(
    Line(points = {{-44, -8}, {-54, -8}, {-54, -110}}, color = {245, 121, 0}));
  connect(refFrameRotation.iqPccPu, RLTransformer.iqPccPu) annotation(
    Line(points = {{60, 8}, {48, 8}, {48, 30}, {2, 30}, {2, 8}, {8, 8}}, color = {85, 170, 255}));
  connect(RLCFilter.udFilterPu, udFilterPu) annotation(
    Line(points = {{-10, -2}, {-4, -2}, {-4, -60}, {-16, -60}, {-16, -110}}, color = {85, 170, 0}));
  connect(RLTransformer.uqFilterPu, uqFilterPu) annotation(
    Line(points = {{8, -8}, {0, -8}, {0, -60}, {10, -60}, {10, -110}}, color = {85, 170, 0}));
  connect(refFrameRotation.uqPccPu, uqPccPu) annotation(
    Line(points = {{60.5, -7.5}, {56, -7.5}, {56, -60}, {62, -60}, {62, -110}}, color = {85, 170, 255}));
  connect(RLTransformer.udPccPu, udPccPu) annotation(
    Line(points = {{42, -2}, {48, -2}, {48, -60}, {42, -60}, {42, -110}}, color = {85, 170, 255}));
  connect(idPccPu, RLCFilter.idPccPu) annotation(
    Line(points = {{10, 110}, {10, 40}, {-4, 40}, {-4, 14}, {-10, 14}}, color = {85, 170, 255}, pattern = LinePattern.Dash));
  connect(iqPccPu, refFrameRotation.iqPccPu) annotation(
    Line(points = {{40, 110}, {40, 30}, {48, 30}, {48, 7.5}, {60.5, 7.5}}, color = {85, 170, 255}, pattern = LinePattern.Dash));
  connect(RLCFilter.udFilterPu, RLTransformer.udFilterPu) annotation(
    Line(points = {{-10, -2}, {8, -2}}, color = {0, 0, 255}));
  connect(RLCFilter.uqFilterPu, RLTransformer.uqFilterPu) annotation(
    Line(points = {{-10, -8}, {8, -8}}, color = {0, 0, 255}));
  connect(RLTransformer.uqFilterPu, uqFilterPu) annotation(
    Line(points = {{8, -8}, {0, -8}, {0, -60}, {10, -60}, {10, -110}}, color = {0, 0, 255}));
  connect(omegaPu, RLTransformer.omegaPu) annotation(
    Line(points = {{-112, -40}, {26, -40}, {26, -14}}, color = {0, 0, 127}));
  connect(RLTransformer.udPccPu, refFrameRotation.udPccPu) annotation(
    Line(points = {{42, -2}, {60, -2}}, color = {0, 0, 255}));
  connect(RLTransformer.uqPccPu, refFrameRotation.uqPccPu) annotation(
    Line(points = {{42, -8}, {60, -8}}, color = {0, 0, 255}));
  connect(RLCFilter.idPccPu, RLTransformer.idPccPu) annotation(
    Line(points = {{-10, 14}, {8, 14}}, color = {0, 0, 255}));
  connect(RLCFilter.iqPccPu, RLTransformer.iqPccPu) annotation(
    Line(points = {{-10, 8}, {8, 8}}, color = {0, 0, 255}));
  connect(refFrameRotation.iqPccPu, RLTransformer.iqPccPu) annotation(
    Line(points = {{60, 8}, {48, 8}, {48, 30}, {2, 30}, {2, 8}, {8, 8}}, color = {0, 0, 255}));

annotation(preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents the physical part of a converter with an ideal voltage source, a dynamic RLC filter, a dynamic RL transformer and a reference frame rotation.<div><br></div><div>The interface variables are the current and voltages from the terminal.</div></body></html>"));
end DynConverter1;
