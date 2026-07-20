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
  * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
  */


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
    Placement(transformation(origin = {105, -81}, extent = {{-5, -5}, {5, 5}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in pu (base UNom)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of the converter's frequency in pu (base omegaNom)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput udConvRefPu(start = transformRItoDQUConv.ud0) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-112, 58}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {-109, 41}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu(start = transformRItoDQUConv.uq0) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-112, 40}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-112, 12}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {-48, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(transformation(origin = {-112, -12}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {52, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = -transformRItoDQConv.ud0) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {114, 76}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = -transformRItoDQConv.uq0) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {114, 62}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {92, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput udFilterPu(start = transformRItoDQFilter.ud0) "d-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, 6}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {16, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu(start = transformRItoDQFilter.uq0) "q-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, -14}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {38, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput udPccPu(start = transformRItoDQUPcc.ud0) "d-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, -32}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {-34, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput uqPccPu(start = transformRItoDQUPcc.uq0) "q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {111, -43}, extent = {{-7, -7}, {7, 7}}), iconTransformation(origin = {-12, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput idPccPu(start = transformRItoDQIPcc.ud0) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {136, -52}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {-90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput iqPccPu(start = transformRItoDQIPcc.uq0) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {136, -64}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));

  // Initialization
  BaseConverters.VSCConverter VSC(tVSC = tVSC, UdConv0Pu = transformRItoDQUConv.ud0, UqConv0Pu = transformRItoDQUConv.uq0) annotation(
    Placement(transformation(origin = {-70, 50}, extent = {{-10, -10}, {10, 10}})));
  InjectorURI injectorURI(u0Pu = RLCFilter.UConv0Pu, i0Pu = RLCFilter.IConv0Pu*SNom/SystemBase.SnRef) annotation(
    Placement(transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}})));
  Controls.WECC.Utilities.TransformRItoDQ transformRItoDQConv(phi0 = Theta0, u0Pu = RLCFilter.IConv0Pu) annotation(
    Placement(transformation(origin = {70, 70}, extent = {{-10, -10}, {10, 10}})));
  Controls.WECC.Utilities.TransformRItoDQ transformRItoDQFilter(phi0 = Theta0, u0Pu = RLTransformer.UFilter0Pu) annotation(
    Placement(transformation(origin = {80, -6}, extent = {{-10, -10}, {10, 10}})));
  Controls.WECC.Utilities.TransformRItoDQ transformRItoDQUPcc(phi0 = Theta0, u0Pu = changeofBaseSNom.UPcc0Pu) annotation(
    Placement(transformation(origin = {80, -36}, extent = {{-10, -10}, {10, 10}})));
  Controls.WECC.Utilities.TransformRItoDQ transformRItoDQIPcc(phi0 = Theta0, u0Pu = -changeofBaseSNom.IPcc0Pu) annotation(
    Placement(transformation(origin = {80, -58}, extent = {{-10, -10}, {10, 10}})));
  BaseConverters.DynRLCFilterRI RLCFilter(RPu = RFilterPu, LPu = LFilterPu, CPu = CFilterPu, UFilter0Pu = RLTransformer.UFilter0Pu, IPcc0Pu = RLTransformer.IPcc0Pu, Omega0Pu = Omega0Pu) annotation(
    Placement(transformation(origin = {50, 28}, extent = {{-9, -9}, {9, 9}}, rotation = -90)));
  BaseConverters.DynRLTransformerRI RLTransformer(RPu = RTransformerPu, LPu = LTransformerPu, Omega0Pu = Omega0Pu, IPcc0Pu = changeofBaseSNom.IPcc0Pu, UPcc0Pu = changeofBaseSNom.UPcc0Pu) annotation(
    Placement(transformation(origin = {49, -31}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Controls.WECC.Utilities.Measurements measurementsPcc(SNom = SNom) annotation(
    Placement(transformation(origin = {50, -58}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Controls.WECC.Utilities.Measurements measurementsFilter(SNom = SNom) annotation(
    Placement(transformation(origin = {50, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(transformation(origin = {-32, 50}, extent = {{-10, -10}, {10, 10}})));
  Controls.WECC.Utilities.Measurements measurementsConv(SNom = SNom) annotation(
    Placement(transformation(origin = {38, 50}, extent = {{-10, -10}, {10, 10}})));
  Controls.WECC.Utilities.TransformRItoDQ transformRItoDQUConv(phi0 = Theta0, u0Pu = RLCFilter.UConv0Pu) annotation(
    Placement(transformation(origin = {-19, 77}, extent = {{9, -9}, {-9, 9}})));
  Modelica.Blocks.Math.Product productidConv annotation(
    Placement(transformation(origin = {93, 75}, extent = {{-3, -3}, {3, 3}})));
  Modelica.Blocks.Math.Product productiqConv annotation(
    Placement(transformation(origin = {93, 65}, extent = {{-3, -3}, {3, 3}})));
  Modelica.Blocks.Math.Product productiqPcc annotation(
    Placement(transformation(origin = {120, -62}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Math.Product productidPcc annotation(
    Placement(transformation(origin = {120, -52}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Sources.Constant constPcc(k = 1) annotation(
    Placement(transformation(origin = {106, -58}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Sources.Constant constConv(k = -1) annotation(
    Placement(transformation(origin = {84, 70}, extent = {{-4, -4}, {4, 4}})));
  Controls.Utilities.ChangeofBaseSNom changeofBaseSNom(SNom = SNom, i0Pu = i0Pu, u0Pu = u0Pu)  annotation(
    Placement(transformation(origin = {72, -86}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(measurementsPcc.terminal1, RLTransformer.terminal2) annotation(
    Line(points = {{50, -48}, {48, -48}, {48, -42}}, color = {0, 0, 255}));
  connect(measurementsPcc.uPu, transformRItoDQUPcc.u) annotation(
    Line(points = {{62, -60}, {64, -60}, {64, -30}, {69, -30}}, color = {85, 170, 255}));
  connect(measurementsPcc.iPu, transformRItoDQIPcc.u) annotation(
    Line(points = {{62, -64}, {66, -64}, {66, -52}, {70, -52}}, color = {85, 170, 255}));
  connect(RLTransformer.terminal1, measurementsFilter.terminal2) annotation(
    Line(points = {{48, -20}, {50, -20}, {50, -12}}, color = {0, 0, 255}));
  connect(measurementsFilter.terminal1, RLCFilter.terminal2) annotation(
    Line(points = {{50, 8}, {50, 18}}, color = {0, 0, 255}));
  connect(measurementsFilter.uPu, transformRItoDQFilter.u) annotation(
    Line(points = {{62, -4}, {64, -4}, {64, 0}, {70, 0}}, color = {85, 170, 255}));
  connect(udConvRefPu, VSC.udConvRefPu) annotation(
    Line(points = {{-112, 58}, {-80, 58}, {-80, 54}}, color = {0, 0, 127}));
  connect(uqConvRefPu, VSC.uqConvRefPu) annotation(
    Line(points = {{-112, 40}, {-80, 40}, {-80, 46}}, color = {0, 0, 127}));
  connect(VSC.udConvPu, transformDQtoRI.ud) annotation(
    Line(points = {{-58, 54}, {-50, 54}, {-50, 57}, {-43, 57}}, color = {0, 0, 127}));
  connect(VSC.uqConvPu, transformDQtoRI.uq) annotation(
    Line(points = {{-58, 46}, {-43, 46}, {-43, 53}}, color = {0, 0, 127}));
  connect(transformDQtoRI.ur, injectorURI.urPu) annotation(
    Line(points = {{-20, 56}, {0, 56}, {0, 54}}, color = {0, 0, 127}));
  connect(transformDQtoRI.ui, injectorURI.uiPu) annotation(
    Line(points = {{-20, 44}, {-2, 44}, {-2, 46}}, color = {0, 0, 127}));
  connect(injectorURI.terminal, measurementsConv.terminal1) annotation(
    Line(points = {{22, 50}, {28, 50}}, color = {0, 0, 255}));
  connect(measurementsConv.terminal2, RLCFilter.terminal1) annotation(
    Line(points = {{48, 50}, {50, 50}, {50, 38}}, color = {0, 0, 255}));
  connect(measurementsConv.iPu, transformRItoDQConv.u) annotation(
    Line(points = {{44, 62}, {44, 76}, {60, 76}}, color = {85, 170, 255}));
  connect(transformRItoDQFilter.ud, udFilterPu) annotation(
    Line(points = {{92, 0}, {110, 0}, {110, 6}}, color = {0, 0, 127}));
  connect(transformRItoDQFilter.uq, uqFilterPu) annotation(
    Line(points = {{92, -12}, {110, -12}, {110, -14}}, color = {0, 0, 127}));
  connect(transformRItoDQUPcc.ud, udPccPu) annotation(
    Line(points = {{92, -30}, {110, -30}, {110, -32}}, color = {0, 0, 127}));
  connect(transformRItoDQUPcc.uq, uqPccPu) annotation(
    Line(points = {{92, -42}, {112, -42}}, color = {0, 0, 127}));
  connect(theta, transformRItoDQConv.phi) annotation(
    Line(points = {{-112, -12}, {24, -12}, {24, 64}, {60, 64}}, color = {0, 0, 127}));
  connect(theta, transformRItoDQIPcc.phi) annotation(
    Line(points = {{-112, -12}, {24, -12}, {24, -70}, {70, -70}, {70, -64}}, color = {0, 0, 127}));
  connect(theta, transformRItoDQFilter.phi) annotation(
    Line(points = {{-112, -12}, {34, -12}, {34, -14}, {66, -14}, {66, -12}, {70, -12}}, color = {0, 0, 127}));
  connect(theta, transformRItoDQUPcc.phi) annotation(
    Line(points = {{-112, -12}, {24, -12}, {24, -42}, {70, -42}}, color = {0, 0, 127}));
  connect(theta, transformDQtoRI.phi) annotation(
    Line(points = {{-112, -12}, {-48, -12}, {-48, 44}, {-42, 44}}, color = {0, 0, 127}));
  connect(measurementsConv.uPu, transformRItoDQUConv.u) annotation(
    Line(points = {{40, 62}, {40, 82}, {-10, 82}}, color = {85, 170, 255}));
  connect(theta, transformRItoDQUConv.phi) annotation(
    Line(points = {{-112, -12}, {-10, -12}, {-10, 72}}, color = {0, 0, 127}));
  RLCFilter.switchOffSignal1 = false;
  RLCFilter.switchOffSignal2 = false;
  RLTransformer.switchOffSignal1 = false;
  RLTransformer.switchOffSignal2 = false;
  injectorURI.switchOffSignal1 = false;
  injectorURI.switchOffSignal2 = false;
  injectorURI.switchOffSignal3 = false;
  connect(omegaPu, RLCFilter.omegaPu) annotation(
    Line(points = {{-112, 12}, {30, 12}, {30, 28}, {40, 28}}, color = {0, 0, 127}));
  connect(omegaPu, RLTransformer.omegaPu) annotation(
    Line(points = {{-112, 12}, {18, 12}, {18, -30}, {38, -30}}, color = {0, 0, 127}));
  connect(productidConv.y, idConvPu) annotation(
    Line(points = {{96, 75}, {105, 75}, {105, 76}, {114, 76}}, color = {0, 0, 127}));
  connect(productiqConv.y, iqConvPu) annotation(
    Line(points = {{96, 65}, {106, 65}, {106, 62}, {114, 62}}, color = {0, 0, 127}));
  connect(productiqPcc.y, iqPccPu) annotation(
    Line(points = {{124, -62}, {130, -62}, {130, -64}, {136, -64}}, color = {0, 0, 127}));
  connect(productidPcc.y, idPccPu) annotation(
    Line(points = {{124, -52}, {136, -52}}, color = {0, 0, 127}));
  connect(transformRItoDQIPcc.uq, productiqPcc.u2) annotation(
    Line(points = {{92, -64}, {116, -64}}, color = {0, 0, 127}));
  connect(transformRItoDQIPcc.ud, productidPcc.u1) annotation(
    Line(points = {{92, -52}, {112, -52}, {112, -50}, {116, -50}}, color = {0, 0, 127}));
  connect(constPcc.y, productidPcc.u2) annotation(
    Line(points = {{110, -58}, {112, -58}, {112, -54}, {116, -54}}, color = {0, 0, 127}));
  connect(constPcc.y, productiqPcc.u1) annotation(
    Line(points = {{110, -58}, {116, -58}, {116, -60}}, color = {0, 0, 127}));
  connect(transformRItoDQConv.ud, productidConv.u1) annotation(
    Line(points = {{82, 76}, {90, 76}}, color = {0, 0, 127}));
  connect(transformRItoDQConv.uq, productiqConv.u2) annotation(
    Line(points = {{82, 64}, {90, 64}}, color = {0, 0, 127}));
  connect(constConv.y, productidConv.u2) annotation(
    Line(points = {{88, 70}, {88, 72}, {90, 72}, {90, 74}}, color = {0, 0, 127}));
  connect(constConv.y, productiqConv.u1) annotation(
    Line(points = {{88, 70}, {90, 70}, {90, 66}}, color = {0, 0, 127}));
  connect(changeofBaseSNom.terminalSNom, measurementsPcc.terminal2) annotation(
    Line(points = {{62, -86}, {50, -86}, {50, -68}}, color = {0, 0, 255}));
  connect(changeofBaseSNom.terminalSNref, terminal) annotation(
    Line(points = {{82, -86}, {106, -86}, {106, -80}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents the physical part of a converter with an ideal voltage source, a dynamic RLC filter, a dynamic RL transformer and a reference frame rotation.<div><br></div><div>The interface variables are the current and voltages from the terminal.</div></body></html>"),
    Diagram);
end DynConverter2;
