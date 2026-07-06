within Dynawo.Electrical.Sources.PEIR.Converters.Average;

model DynConverter2 "Converter physical part comprising an AVM voltage source, a dynamic RLC Filter and a dynamic RL Transformer"
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

  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter in MVA";
  // VSC parameter
  parameter Types.Time tVSC=0.01 "VSC time response in s";
  // RLC filter parameters
  parameter Types.PerUnit RFilterPu "Resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LFilterPu "Inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit CFilterPu "Capacitance in pu (base UNom, SNom)";
  // RL transformer parameters
  parameter Types.PerUnit RTransformerPu"Resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LTransformerPu"Inductance in pu (base UNom, SNom)";

  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(transformation(origin = {105, -71}, extent = {{-5, -5}, {5, 5}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  // Inputs
  Modelica.Blocks.Interfaces.RealInput udConvRefPu(start = compRItoDQConv.UdFilter0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-112, 80}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {-109, 41}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu(start = compRItoDQConv.UqFilter0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-112, 60}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(transformation(origin = {-112, 40}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {52, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = compRItoDQConv.IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-12, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = compRItoDQConv.IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {10, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {92, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput udFilterPu(start = compRItoDQFilter.UdFilter0Pu) "d-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {113, 31}, extent = {{-7, -7}, {7, 7}}), iconTransformation(origin = {16, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu(start = compRItoDQFilter.UqFilter0Pu) "q-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {113, 41}, extent = {{-7, -7}, {7, 7}}), iconTransformation(origin = {38, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput udPccPu(start = compRItoDQPcc.UdFilter0Pu) "d-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {120, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-34, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput uqPccPu(start = compRItoDQPcc.UqFilter0Pu) "q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {120, -4}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-12, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput idPccPu(start = compRItoDQPcc.IdConv0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {120, -48}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput iqPccPu(start = compRItoDQPcc.IqConv0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {120, -34}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));

  // Initial parameters
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in pu (base UNom)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";

  //Final parameters
  final parameter Types.PerUnit UdConv0Pu = ComplexMath.real(injectorURI.u0Pu)*cos(Theta0) + ComplexMath.imag(injectorURI.u0Pu)*sin(Theta0);
  final parameter Types.PerUnit UqConv0Pu = -(ComplexMath.real(injectorURI.u0Pu))*sin(Theta0) + ComplexMath.imag(injectorURI.u0Pu)*cos(Theta0);
  final parameter Types.PerUnit IdConv0Pu = (SystemBase.SnRef / SNom) * (ComplexMath.real(injectorURI.i0Pu)*cos(Theta0) + ComplexMath.imag(injectorURI.i0Pu)*sin(Theta0));
  final parameter Types.PerUnit IqConv0Pu =(SystemBase.SnRef / SNom) *
  (-ComplexMath.real(injectorURI.i0Pu)*sin(Theta0) + ComplexMath.imag(injectorURI.i0Pu)*cos(Theta0));
  final parameter Types.PerUnit UdFilter0Pu =
  ComplexMath.real(dynRLCFilterRI.UFilter0Pu)*cos(Theta0) + ComplexMath.imag(dynRLCFilterRI.UFilter0Pu)*sin(Theta0);

  final parameter Types.PerUnit UqFilter0Pu =
  -ComplexMath.real(dynRLCFilterRI.UFilter0Pu)*sin(Theta0) + ComplexMath.imag(dynRLCFilterRI.UFilter0Pu)*cos(Theta0);

  // Components
  Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters.VSCConverter VSC(tVSC = tVSC, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu) annotation(
    Placement(transformation(origin = {-81, 71}, extent = {{-9, -9}, {9, 9}})));
  Dynawo.Electrical.Sources.InjectorURI injectorURI(SwitchOffSignal20 = false, SwitchOffSignal30 = false, u0Pu = dynRLCFilterRI.UConv0Pu, i0Pu = dynRLCFilterRI.IConv0Pu) annotation(
    Placement(transformation(origin = {-14, 66}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(transformation(origin = {-44, 66}, extent = {{-10, -10}, {10, 10}})));
  Controls.Utilities.Measurements measurementsConv annotation(
    Placement(transformation(origin = {16, 66}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters.DynRLCFilterRI dynRLCFilterRI(RPu = RFilterPu, LPu = LFilterPu, CPu = CFilterPu, UFilter0Pu = dynRLTransformerRI.UFilter0Pu, IPcc0Pu = dynRLTransformerRI.IPcc0Pu)  annotation(
    Placement(transformation(origin = {46, 66}, extent = {{11, 11}, {-11, -11}}, rotation = -180)));
  Dynawo.Electrical.Controls.Utilities.Measurements measurementsFilter annotation(
    Placement(transformation(origin = {72, 34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters.DynRLTransformerRI dynRLTransformerRI(IPcc0Pu = i0Pu, UPcc0Pu = u0Pu, RPu = RTransformerPu, LPu = LTransformerPu)  annotation(
    Placement(transformation(origin = {73, 3}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Controls.Utilities.Measurements measurementsPcc annotation(
    Placement(transformation(origin = {72, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Controls.Converters.EpriGFM.BaseControls.CompRItoDQ compRItoDQConv(SNom = SNom, iInj0Pu=i0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, u0Pu = u0Pu, Theta0=Theta0)  annotation(
    Placement(transformation(origin = {27, 91}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Controls.Converters.EpriGFM.BaseControls.CompRItoDQ compRItoDQFilter(SNom = SNom, iInj0Pu=i0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, u0Pu = u0Pu, Theta0=Theta0)  annotation(
    Placement(transformation(origin = {95, 23}, extent = {{-5, -5}, {5, 5}})));
  Controls.Converters.EpriGFM.BaseControls.CompRItoDQ compRItoDQPcc(SNom = SNom, iInj0Pu=i0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, u0Pu = u0Pu, Theta0=Theta0)  annotation(
    Placement(transformation(origin = {95, -41}, extent = {{-5, -5}, {5, 5}})));
equation
  connect(udConvRefPu, VSC.udConvRefPu) annotation(
    Line(points = {{-112, 80}, {-98, 80}, {-98, 75}, {-91, 75}}, color = {245, 121, 0}, thickness = 0.5));
  connect(uqConvRefPu, VSC.uqConvRefPu) annotation(
    Line(points = {{-112, 60}, {-98, 60}, {-98, 67}, {-91, 67}}, color = {245, 121, 0}, thickness = 0.5));
  connect(VSC.udConvPu, transformDQtoRI.ud) annotation(
    Line(points = {{-71, 75}, {-63, 75}, {-63, 73}, {-55, 73}}, color = {0, 0, 127}));
  connect(VSC.uqConvPu, transformDQtoRI.uq) annotation(
    Line(points = {{-71, 67}, {-63, 67}, {-63, 69}, {-55, 69}}, color = {0, 0, 127}));
  connect(theta, transformDQtoRI.phi) annotation(
    Line(points = {{-112, 40}, {-64.5, 40}, {-64.5, 60}, {-55, 60}}, color = {0, 0, 127}));
  connect(transformDQtoRI.ur, injectorURI.urPu) annotation(
    Line(points = {{-33, 72}, {-29, 72}, {-29, 70}, {-25, 70}}, color = {0, 0, 127}));
  connect(transformDQtoRI.ui, injectorURI.uiPu) annotation(
    Line(points = {{-33, 60}, {-29, 60}, {-29, 62}, {-25, 62}}, color = {0, 0, 127}));
  connect(injectorURI.terminal, measurementsConv.terminal1) annotation(
    Line(points = {{-2, 66}, {6, 66}}, color = {0, 0, 255}));
  connect(measurementsConv.terminal2, dynRLCFilterRI.terminal1) annotation(
    Line(points = {{26, 66}, {34, 66}}, color = {0, 0, 255}));
  connect(dynRLCFilterRI.terminal2, measurementsFilter.terminal1) annotation(
    Line(points = {{58, 66}, {72, 66}, {72, 44}}, color = {0, 0, 255}));
  connect(measurementsFilter.terminal2, dynRLTransformerRI.terminal1) annotation(
    Line(points = {{72, 24}, {72, 14}}, color = {0, 0, 255}));
  connect(dynRLTransformerRI.terminal2, measurementsPcc.terminal1) annotation(
    Line(points = {{72, -8}, {72, -20}}, color = {0, 0, 255}));
  connect(measurementsPcc.terminal2, terminal) annotation(
    Line(points = {{72, -40}, {72, -71}, {105, -71}}, color = {0, 0, 255}));
  connect(measurementsConv.uPu, compRItoDQConv.uInjPu) annotation(
    Line(points = {{24, 78}, {24, 85}}, color = {85, 170, 255}));
  connect(measurementsConv.iPu, compRItoDQConv.iInjPu) annotation(
    Line(points = {{26, 78}, {26, 85}}, color = {85, 170, 255}));
  connect(theta, compRItoDQConv.thetaGFM) annotation(
    Line(points = {{-112, 40}, {32, 40}, {32, 86}}, color = {0, 0, 127}));
  connect(compRItoDQConv.iqConvPu, iqConvPu) annotation(
    Line(points = {{30, 96}, {10, 96}, {10, 110}}, color = {0, 0, 127}));
  connect(compRItoDQConv.idConvPu, idConvPu) annotation(
    Line(points = {{30, 96}, {-12, 96}, {-12, 110}}, color = {0, 0, 127}));
  connect(measurementsFilter.uPu, compRItoDQFilter.uInjPu) annotation(
    Line(points = {{83, 26}, {89, 26}}, color = {85, 170, 255}));
  connect(measurementsFilter.iPu, compRItoDQFilter.iInjPu) annotation(
    Line(points = {{84, 24}, {89, 24}}, color = {85, 170, 255}));
  connect(theta, compRItoDQFilter.thetaGFM) annotation(
    Line(points = {{-112, 40}, {32, 40}, {32, 19}, {89, 19}}, color = {0, 0, 127}));
  connect(compRItoDQFilter.uqFilterPu, uqFilterPu) annotation(
    Line(points = {{100, 26}, {100, 41}, {113, 41}}, color = {0, 0, 127}));
  connect(compRItoDQFilter.udFilterPu, udFilterPu) annotation(
    Line(points = {{100, 24}, {104, 24}, {104, 31}, {113, 31}}, color = {0, 0, 127}));
  connect(measurementsPcc.uPu, compRItoDQPcc.uInjPu) annotation(
    Line(points = {{84, -38}, {90, -38}}, color = {85, 170, 255}));
  connect(theta, compRItoDQPcc.thetaGFM) annotation(
    Line(points = {{-112, 40}, {32, 40}, {32, -44}, {90, -44}}, color = {0, 0, 127}));
  connect(compRItoDQPcc.uqFilterPu, uqPccPu) annotation(
    Line(points = {{100, -38}, {100, -4}, {120, -4}}, color = {0, 0, 127}));
  connect(compRItoDQPcc.udFilterPu, udPccPu) annotation(
    Line(points = {{100, -40}, {104, -40}, {104, -20}, {120, -20}}, color = {0, 0, 127}));
  connect(compRItoDQPcc.iqConvPu, iqPccPu) annotation(
    Line(points = {{100, -42}, {108, -42}, {108, -34}, {120, -34}}, color = {0, 0, 127}));
  connect(compRItoDQPcc.idConvPu, idPccPu) annotation(
    Line(points = {{100, -44}, {104, -44}, {104, -48}, {120, -48}}, color = {0, 0, 127}));
  injectorURI.switchOffSignal1 = false ;
  injectorURI.switchOffSignal2 = false ;
  injectorURI.switchOffSignal3 = false ;
  dynRLCFilterRI.switchOffSignal1 = false;
  dynRLCFilterRI.switchOffSignal2 = false;
  dynRLTransformerRI.switchOffSignal1 = false;
  dynRLTransformerRI.switchOffSignal2 = false;
  connect(measurementsPcc.iPu, compRItoDQPcc.iInjPu) annotation(
    Line(points = {{84, -40}, {90, -40}}, color = {85, 170, 255}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents the physical part of a converter with an ideal voltage source, a dynamic RLC filter, a dynamic RL transformer and a reference frame rotation.<div><br></div><div>The interface variables are the current and voltages from the terminal.</div></body></html>"),
    Diagram);
end DynConverter2;
