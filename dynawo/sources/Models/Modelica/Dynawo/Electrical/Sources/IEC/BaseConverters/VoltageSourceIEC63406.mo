within Dynawo.Electrical.Sources.IEC.BaseConverters;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model VoltageSourceIEC63406 "Converter system module with current source interface (IEC TS 63406 ED1)"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Control parameters
  parameter Types.Time Tg "Time constant to represent the control delay effect of the inner current control loop (larger than twice of the time step of 1/20 cycle [3]. Alternatively set it to zero to bypass this delay." annotation(
    Dialog(tab = "CurrentSource"));
  parameter Types.PerUnit XesPu "Coupling inductance in the filter or the transformer at the grid side" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit ResPu "Coupling resistance in the filter or the transformer at the grid side" annotation(
    Dialog(tab = "Electrical"));

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = UGsRe0Pu), im(start = UGsIm0Pu)), i(re(start = -IGsRe0Pu * SNom / SystemBase.SnRef), im(start = -IGsIm0Pu * SNom / SystemBase.SnRef))) "Converter terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {210, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipRefPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqRefPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  input Boolean running(start = true) "True if the converter is running";
  Modelica.Blocks.Interfaces.RealInput thetaPLL(start = UPhase0) "Phase shift between the converter and the grid rotating frames in rad" annotation(
    Placement(visible = true, transformation(origin = {-210, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));

  //Output variable
  Dynawo.Electrical.Sources.IEC.BaseConverters.RefFrameRotation iECFrameRotation(IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {40, 20}, extent = {{-20, -60}, {20, 60}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplex annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tg, y_start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu))  annotation(
    Placement(visible = true, transformation(origin = {-170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = Tg, y_start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu))  annotation(
    Placement(visible = true, transformation(origin = {-170, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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

  Dynawo.Electrical.Sources.IEC.BaseConverters.UgridToUconverter ugridToUconverter(ResPu = ResPu, XesPu = XesPu)  annotation(
    Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = Tg, y_start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-30, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = Tg, y_start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-30, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression uGs(y = terminal.V) annotation(
    Placement(visible = true, transformation(origin = {160, -60}, extent = {{20, -14}, {-20, 14}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(visible = true, transformation(origin = {-40, -72}, extent = {{20, 20}, {-20, -20}}, rotation = 0)));

equation
  Complex(iECFrameRotation.iGsRePu, iECFrameRotation.iGsImPu) = terminal.V * (SystemBase.SnRef / SNom); //iGs is actually a voltage in this equation

  connect(iECFrameRotation.iGsImPu, realToComplex.im) annotation(
    Line(points = {{66.6667, -10}, {80.6667, -10}, {80.6667, 14}, {98.6667, 14}}, color = {0, 0, 127}));
  connect(iECFrameRotation.iGsRePu, realToComplex.re) annotation(
    Line(points = {{66.6667, 50}, {80.6667, 50}, {80.6667, 26}, {98.6667, 26}}, color = {0, 0, 127}));
  connect(ipRefPu, firstOrder.u) annotation(
    Line(points = {{-210, 60}, {-182, 60}}, color = {0, 0, 127}));
  connect(iqRefPu, firstOrder1.u) annotation(
    Line(points = {{-210, 20}, {-182, 20}}, color = {0, 0, 127}));
  connect(firstOrder1.y, ugridToUconverter.iqPu) annotation(
    Line(points = {{-159, 20}, {-141, 20}, {-141, 32}, {-125, 32}}, color = {0, 0, 127}));
  connect(firstOrder.y, ugridToUconverter.idPu) annotation(
    Line(points = {{-159, 60}, {-140, 60}, {-140, 48}, {-124, 48}}, color = {0, 0, 127}));
  connect(ugridToUconverter.uedPu, firstOrder2.u) annotation(
    Line(points = {{-78, 48}, {-60, 48}, {-60, 60}, {-42, 60}}, color = {0, 0, 127}));
  connect(ugridToUconverter.ueqPu, firstOrder3.u) annotation(
    Line(points = {{-78, 32}, {-60, 32}, {-60, 20}, {-42, 20}}, color = {0, 0, 127}));
  connect(firstOrder3.y, iECFrameRotation.iqCmdPu) annotation(
    Line(points = {{-19, 20}, {13, 20}}, color = {0, 0, 127}));
  connect(firstOrder2.y, iECFrameRotation.ipCmdPu) annotation(
    Line(points = {{-18, 60}, {0, 60}, {0, 74}, {14, 74}}, color = {0, 0, 127}));
  connect(uGs.y, transformRItoDQ.uPu) annotation(
    Line(points = {{138, -60}, {40, -60}, {40, -84}, {-18, -84}}, color = {85, 170, 255}));
  connect(transformRItoDQ.uqPu, ugridToUconverter.ugqPu) annotation(
    Line(points = {{-62, -60}, {-108, -60}, {-108, 16}}, color = {0, 0, 127}));
  connect(transformRItoDQ.udPu, ugridToUconverter.ugdPu) annotation(
    Line(points = {{-62, -84}, {-92, -84}, {-92, 16}}, color = {0, 0, 127}));
  connect(thetaPLL, transformRItoDQ.phi) annotation(
    Line(points = {{-210, -40}, {0, -40}, {0, -60}, {-18, -60}}, color = {0, 0, 127}));
  connect(thetaPLL, iECFrameRotation.theta) annotation(
    Line(points = {{-210, -40}, {0, -40}, {0, -34}, {14, -34}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Diagram(graphics = {Line(origin = {130.991, 20.068}, points = {{-9, 0}, {9, 0}, {69, 0}}, color = {114, 159, 207})}, coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    Icon(coordinateSystem(extent = {{-200, -100}, {200, 100}}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-100, -20}, {100, 20}}, textString = "Generator"), Text(origin = {0, -30}, extent = {{-100, -20}, {100, 20}}, textString = "System")}));
end VoltageSourceIEC63406;
