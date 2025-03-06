within Dynawo.Electrical.Sources.IEC.BaseConverters;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model CurrentSourceIEC63406 "Converter system module with current source interface (IEC 63406)"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Control parameters
  parameter Types.Time Tg "Time constant to represent the control delay effect of the inner current control loop. Alternatively set it to zero to bypass this delay." annotation(
    Dialog(tab = "CurrentSource"));

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = UGsRe0Pu), im(start = UGsIm0Pu)), i(re(start = -IGsRe0Pu * SNom / SystemBase.SnRef), im(start = -IGsIm0Pu * SNom / SystemBase.SnRef))) "Converter terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipRefPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqRefPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  input Boolean running(start = true) "True if the converter is running";
  Modelica.Blocks.Interfaces.RealInput thetaPLL(start = UPhase0) "Phase shift between the converter and the grid rotating frames in rad" annotation(
    Placement(visible = true, transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));

  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplex annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.BaseConverters.RefFrameRotation iECFrameRotation(IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {1.58946e-07, -4.76837e-07}, extent = {{-20, -60}, {20, 60}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tg, y_start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu))  annotation(
    Placement(visible = true, transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = Tg, y_start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu))  annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit IGsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IGsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit UGsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit UGsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));

equation
  Complex(iECFrameRotation.iGsRePu, iECFrameRotation.iGsImPu) = -terminal.i * (SystemBase.SnRef / SNom);

  connect(iECFrameRotation.iGsImPu, realToComplex.im) annotation(
    Line(points = {{26, -30}, {40, -30}, {40, -6}, {58, -6}}, color = {0, 0, 127}));
  connect(iECFrameRotation.iGsRePu, realToComplex.re) annotation(
    Line(points = {{26, 30}, {40, 30}, {40, 6}, {58, 6}}, color = {0, 0, 127}));
  connect(firstOrder.y, iECFrameRotation.ipCmdPu) annotation(
    Line(points = {{-78, 60}, {-60, 60}, {-60, 54}, {-26, 54}}, color = {0, 0, 127}));
  connect(firstOrder1.y, iECFrameRotation.iqCmdPu) annotation(
    Line(points = {{-78, 0}, {-26, 0}}, color = {0, 0, 127}));
  connect(ipRefPu, firstOrder.u) annotation(
    Line(points = {{-150, 60}, {-102, 60}}, color = {0, 0, 127}));
 connect(iqRefPu, firstOrder1.u) annotation(
    Line(points = {{-150, 0}, {-102, 0}}, color = {0, 0, 127}));
 connect(thetaPLL, iECFrameRotation.theta) annotation(
    Line(points = {{-150, -60}, {-60, -60}, {-60, -54}, {-26, -54}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(graphics = {Line(origin = {90.7207, -0.279255}, points = {{-9, 0}, {9, 0}, {51, 0}}, color = {114, 159, 207})}, coordinateSystem(extent = {{-140, -100}, {140, 100}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-100, -20}, {100, 20}}, textString = "Generator"), Text(origin = {0, -30}, extent = {{-100, -20}, {100, 20}}, textString = "System")}));
end CurrentSourceIEC63406;
