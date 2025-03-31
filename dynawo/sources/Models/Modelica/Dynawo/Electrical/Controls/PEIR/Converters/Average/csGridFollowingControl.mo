within Dynawo.Electrical.Controls.PEIR.Converters.Average;

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

model csGridFollowingControl

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

  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XTransformerPu "Transformer impedance in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -2}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -73}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -16}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -93}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, 54}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = PFilter0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 77}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, 66}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 33}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = QFilter0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 22}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -19}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput idFilterRefPu(start = IdFilter0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 11}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqFilterRefPu(start = IqFilter0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {107, -3}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {106, 66}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {106, 54}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries.PLL PLL(Ki = Ki, Kp = Kp, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, Theta0 = Theta0)  annotation(
    Placement(visible = true, transformation(origin = {-34, 60}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFL.OuterLoop outerLoop(IdConv0Pu = IdFilter0Pu, IqConv0Pu = IqFilter0Pu,Kid = Kid, Kiq = Kiq, Kpd = Kpd, Kpq = Kpq, PFilter0Pu = PFilter0Pu, QFilter0Pu = QFilter0Pu, tPFilt = tPFilt, tQFilt = tQFilt)  annotation(
    Placement(visible = true, transformation(origin = {-32, 4}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit IdFilter0Pu "Start value of d-axis current in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqFilter0Pu "Start value of q-axis current in pu (base UNom, SNom) (generator convention)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of converter's frequency in pu (base omegaNom)";
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
equation
  connect(PLL.theta, theta) annotation(
    Line(points = {{-16.4, 66.4}, {105.6, 66.4}}, color = {0, 0, 127}));
  connect(PLL.omegaPLLPu, omegaPu) annotation(
    Line(points = {{-16.4, 53.6}, {105.6, 53.6}}, color = {0, 0, 127}));
  connect(omegaRefPu, PLL.omegaRefPu) annotation(
    Line(points = {{-108, 66}, {-52, 66}}, color = {0, 0, 127}, thickness = 0.5));
  connect(PFilterRefPu, outerLoop.PFilterRefPu) annotation(
    Line(points = {{-108, 38}, {-60, 38}, {-60, 16}, {-50, 16}}, color = {85, 170, 0}, thickness = 0.5));
  connect(QFilterRefPu, outerLoop.QFilterRefPu) annotation(
    Line(points = {{-108, 22}, {-68, 22}, {-68, 12}, {-50, 12}}, color = {85, 170, 0}, thickness = 0.5));
  connect(PFilterPu, outerLoop.PFilterPu) annotation(
    Line(points = {{-108, -2}, {-80, -2}, {-80, 0}, {-50, 0}}, color = {85, 170, 0}));
  connect(QFilterPu, outerLoop.QFilterPu) annotation(
    Line(points = {{-108, -16}, {-68, -16}, {-68, -4}, {-50, -4}}, color = {85, 170, 0}));
  connect(PLL.uqFilterPu, uqFilterPu) annotation(
    Line(points = {{-52, 54}, {-108, 54}}, color = {85, 170, 0}));
  connect(outerLoop.idConvRefPu, idFilterRefPu) annotation(
    Line(points = {{-14, 10}, {43, 10}, {43, 11}, {107, 11}}, color = {85, 170, 0}, thickness = 0.5));
  connect(outerLoop.iqConvRefPu, iqFilterRefPu) annotation(
    Line(points = {{-14, -2}, {47, -2}, {47, -3}, {107, -3}}, color = {85, 170, 0}, thickness = 0.5));
  annotation(preferredView = "diagram",
    Diagram(graphics = {Text(origin = {13, 15}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idFilterRefPu", textStyle = {TextStyle.Bold}), Text(origin = {13, 1}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqFilterRefPu", textStyle = {TextStyle.Bold})}));
end csGridFollowingControl;
