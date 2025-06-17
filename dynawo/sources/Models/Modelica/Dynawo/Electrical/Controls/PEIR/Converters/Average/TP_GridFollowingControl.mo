within Dynawo.Electrical.Controls.PEIR.Converters.Average;

model TP_GridFollowingControl
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
  // PLL parameters
  parameter Types.PerUnit Ki "PLL integrator gain";
  parameter Types.PerUnit Kp "PLL proportional gain";
  parameter Types.PerUnit OmegaMaxPu "Upper frequency limit in pu (base OmegaNom)";
  parameter Types.PerUnit OmegaMinPu "Lower frequency limit in pu (base OmegaNom)";
  // Outer loop parameters
  parameter Types.PerUnit Kpd "Active power PI controller proportional gain in pu/s (base UNom, SNom)";
  parameter Types.PerUnit Kid "Active power PI controller integral gain in pu/s (base UNom, SNom)";
  parameter Types.PerUnit Kpq "Reactive power PI controller proportional gain in pu/s (base UNom, SNom)";
  parameter Types.PerUnit Kiq "Reactive power PI controller integral gain in pu/s (base UNom, SNom)";
  parameter Types.Time tPFilt "Filter time constant for active power measurement in s";
  parameter Types.Time tQFilt "Filter time constant for reactive power measurement in s";
  // Current loop parameters
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis";
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis";
  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XFilterPu "Filter impedance in pu (base UNom, SNom)";
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XTransformerPu "Transformer impedance in pu (base UNom, SNom)";
  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -2}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -73}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -16}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -93}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {80, -108}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-85, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {64, -108}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-65, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {48, -108}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {32, -108}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-17, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = PFilter0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 77}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, 66}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 33}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = QFilter0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 22}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -19}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 11}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {107, -3}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {106, 66}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {106, 54}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Controls.PEIR.BaseControls.Auxiliaries.PLL PLL(Ki = Ki, Kp = Kp, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, Theta0 = Theta0) annotation(
    Placement(visible = true, transformation(origin = {-34, 60}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Electrical.Controls.PEIR.BaseControls.GFL.OuterLoop outerLoop(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, Kid = Kid, Kiq = Kiq, Kpd = Kpd, Kpq = Kpq, PFilter0Pu = PFilter0Pu, QFilter0Pu = QFilter0Pu, tPFilt = tPFilt, tQFilt = tQFilt) annotation(
    Placement(transformation(origin = {-60, 4}, extent = {{-16, -16}, {16, 16}})));
  Electrical.Controls.PEIR.BaseControls.CurrentLoops.CurrentLoop currentLoop(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, Kfd = Kfd, Kfq = Kfq, Kic = Kic, Kpc = Kpc, RFilter = RFilterPu, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, UqConv0Pu = UqConv0Pu, UqFilter0Pu = UqFilter0Pu, XFilter = XFilterPu) annotation(
    Placement(visible = true, transformation(origin = {56, 4}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  // Initial parameters
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage reference in pu (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage reference in pu (base UNom)";
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of converter's frequency in pu (base omegaNom)";
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  Modelica.Blocks.Math.Add addid annotation(
    Placement(transformation(origin = {-8, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addiq annotation(
    Placement(transformation(origin = {-8, -8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step stepid(height = 0.1, startTime = 2, offset = 0)  annotation(
    Placement(transformation(origin = {-32, 22}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Sources.Step stepiq(offset = 0, startTime = 5, height = 0.1)  annotation(
    Placement(transformation(origin = {-32, -14}, extent = {{-6, -6}, {6, 6}})));
equation
  connect(PLL.theta, theta) annotation(
    Line(points = {{-16.4, 66.4}, {105.6, 66.4}}, color = {0, 0, 127}));
  connect(PLL.omegaPLLPu, omegaPu) annotation(
    Line(points = {{-16.4, 53.6}, {105.6, 53.6}}, color = {0, 0, 127}));
  connect(omegaRefPu, PLL.omegaRefPu) annotation(
    Line(points = {{-108, 66}, {-52, 66}}, color = {0, 0, 127}, thickness = 0.5));
  connect(PLL.uqFilterPu, uqFilterPu) annotation(
    Line(points = {{-52, 54}, {-84, 54}, {-84, -40}, {48, -40}, {48, -108}}, color = {85, 170, 0}, pattern = LinePattern.Dash));
  connect(udConvRefPu, currentLoop.udConvRefPu) annotation(
    Line(points = {{107, 11}, {74, 11}, {74, 10}}, color = {245, 121, 0}, thickness = 0.5));
  connect(uqConvRefPu, currentLoop.uqConvRefPu) annotation(
    Line(points = {{107, -3}, {91, -3}, {91, -2}, {74, -2}}, color = {245, 121, 0}, thickness = 0.5));
  connect(uqFilterPu, currentLoop.uqFilterPu) annotation(
    Line(points = {{48, -108}, {48, -14}}, color = {85, 170, 0}));
  connect(udFilterPu, currentLoop.udFilterPu) annotation(
    Line(points = {{32, -108}, {32, -60}, {40, -60}, {40, -14}}, color = {85, 170, 0}));
  connect(currentLoop.idConvPu, idConvPu) annotation(
    Line(points = {{64, -14}, {64, -108}}, color = {245, 121, 0}));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{80, -108}, {80, -60}, {72, -60}, {72, -14}}, color = {245, 121, 0}));
  connect(outerLoop.PFilterRefPu, PFilterRefPu) annotation(
    Line(points = {{-78, 16}, {-90, 16}, {-90, 38}, {-108, 38}}, color = {0, 0, 127}));
  connect(outerLoop.QFilterRefPu, QFilterRefPu) annotation(
    Line(points = {{-78, 12}, {-92, 12}, {-92, 22}, {-108, 22}}, color = {0, 0, 127}));
  connect(outerLoop.PFilterPu, PFilterPu) annotation(
    Line(points = {{-78, 0}, {-94, 0}, {-94, -2}, {-108, -2}}, color = {0, 0, 127}));
  connect(outerLoop.QFilterPu, QFilterPu) annotation(
    Line(points = {{-78, -4}, {-92, -4}, {-92, -16}, {-108, -16}}, color = {0, 0, 127}));
  connect(addid.u2, outerLoop.idConvRefPu) annotation(
    Line(points = {{-20, 10}, {-42, 10}}, color = {0, 0, 127}));
  connect(addiq.u1, outerLoop.iqConvRefPu) annotation(
    Line(points = {{-20, -2}, {-42, -2}}, color = {0, 0, 127}));
  connect(addid.y, currentLoop.idConvRefPu) annotation(
    Line(points = {{4, 16}, {34, 16}, {34, 10}, {38, 10}}, color = {245, 121, 0}, thickness = 0.5));
  connect(addiq.y, currentLoop.iqConvRefPu) annotation(
    Line(points = {{4, -8}, {34, -8}, {34, -2}, {38, -2}}, color = {255, 120, 0}, thickness = 0.5));
  connect(stepiq.y, addiq.u2) annotation(
    Line(points = {{-25, -14}, {-20, -14}}, color = {0, 0, 127}));
  connect(stepid.y, addid.u1) annotation(
    Line(points = {{-26, 22}, {-20, 22}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Diagram(graphics = {Text(origin = {21, 7}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {21, -13}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvRefPu", textStyle = {TextStyle.Bold})}),
  Icon(graphics = {Rectangle(fillColor = {246, 245, 244}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 1}, extent = {{-88, 43}, {88, -43}}, textString = "Control")}));
end TP_GridFollowingControl;