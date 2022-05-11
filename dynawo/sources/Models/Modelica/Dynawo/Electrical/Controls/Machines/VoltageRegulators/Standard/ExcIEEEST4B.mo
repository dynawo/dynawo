within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ExcIEEEST4B "IEEE exciter type ST4B"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;

  //Regulation parameters
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance (>= 0). Typical value = 0,113";
  parameter Types.PerUnit Kg "Feedback gain constant of the inner loop field regulator (>= 0). Typical value = 0";
  parameter Types.PerUnit Ki "Potential circuit gain coefficient applied to Real part of complex stator current (>= 0). Typical value = 0";
  parameter Types.PerUnit Kim "Voltage regulator integral gain output. Typical value = 0";
  parameter Types.PerUnit Kir "Voltage regulator integral gain. Typical value = 10,75";
  parameter Types.PerUnit Kp "Potential circuit gain coefficient. Typical value = 9,3";
  parameter Types.PerUnit Kpm "Voltage regulator proportional gain output. Typical value = 1";
  parameter Types.PerUnit Kpr "Voltage regulator proportional gain. Typical value = 10,75";
  parameter Types.Time tA "Voltage regulator time constant in s (> 0). Typical value = 0,02";
  parameter Types.Angle Thetap "Potential circuit phase angle. Typical value = 0";
  parameter Types.Time tR "Filter time constant in s";
  parameter Types.VoltageModulePu VbMaxPu "Maximum excitation voltage (> 0). Typical value = 11,63";
  parameter Types.VoltageModulePu VmMaxPu "Maximum inner loop output (> VmMinPu). Typical value = 99";
  parameter Types.VoltageModulePu VmMinPu "Minimum inner loop output (< VmMaxPu). Typical value = -99";
  parameter Types.VoltageModulePu VrMaxPu "Maximum voltage regulator output (> 0). Typical value = 1";
  parameter Types.VoltageModulePu VrMinPu "Minimum voltage regulator output (< 0). Typical value = -0,87";
  parameter Types.PerUnit XlPu "Reactance associated with potential source (>= 0) in pu (base SNom, UNom). Typical value = 0,124";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IfdPu(start = Ifd0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-120, -160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput itPuIm(start = it0Pu.im) "Imaginary part of stator current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput itPuRe(start = it0Pu.re) "Real part of stator current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = Us0Pu) "Control voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput utPu(re(start = ut0Pu.re), im(start = ut0Pu.im)) "Complex stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {286, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add3 add3(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = VbMaxPu) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-10, -120}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseBlocks.PotentialCircuit potentialCircuit(Ki = Ki, Kp = Kp, Theta = Thetap, X = XlPu) annotation(
    Placement(visible = true, transformation(origin = {-90, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min1 annotation(
    Placement(visible = true, transformation(origin = {150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {90, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseBlocks.RectifierRegulationCharacteristic rectifierRegulationCharacteristic annotation(
    Placement(visible = true, transformation(origin = {30, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplex annotation(
    Placement(visible = true, transformation(origin = {-230, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimitedPI limPI1(Ki = Kir, Kp = Kpr, Y0 =  Kg * Efd0Pu, YMax = VrMaxPu, YMin = VrMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {150, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = UOel0Pu) annotation(
    Placement(visible = true, transformation(origin = {92, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tA, y_start =  Kg *Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimitedPI limPI2(Ki = Kim, Kp = Kpm, Y0 = Efd0Pu / Ub0Pu, YMax = VmMaxPu, YMin = VmMinPu) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kg) annotation(
    Placement(visible = true, transformation(origin = {150, 100}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-70, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)" annotation(
  Dialog(group="Initialization"));
  parameter Types.CurrentModulePu Ifd0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)" annotation(
  Dialog(group="Initialization"));
  parameter Types.ComplexCurrentPu it0Pu "Initial complex stator current in pu (base SNom, UNom)" annotation(
  Dialog(group="Initialization"));
  parameter Types.VoltageModulePu Ub0Pu "Initial voltage in pu (base UNom)" annotation(
  Dialog(group="Initialization"));
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)" annotation(
  Dialog(group="Initialization"));
  parameter Types.ComplexVoltagePu ut0Pu "Initial complex stator voltage in pu (base UNom)" annotation(
  Dialog(group="Initialization"));
  parameter Types.VoltageModulePu UOel0Pu "Initial overexciter voltage input in pu (base UNom)" annotation(
  Dialog(group="Initialization"));

equation
  connect(const.y, min1.u1) annotation(
    Line(points = {{101, -40}, {120, -40}, {120, -54}, {138, -54}}, color = {0, 0, 127}));
  connect(product1.y, min1.u2) annotation(
    Line(points = {{101, -100}, {120, -100}, {120, -66}, {138, -66}}, color = {0, 0, 127}));
  connect(division.y, rectifierRegulationCharacteristic.u) annotation(
    Line(points = {{1, -120}, {18, -120}}, color = {0, 0, 127}));
  connect(rectifierRegulationCharacteristic.y, product1.u2) annotation(
    Line(points = {{42, -120}, {60, -120}, {60, -106}, {78, -106}}, color = {0, 0, 127}));
  connect(potentialCircuit.vE, division.u2) annotation(
    Line(points = {{-80, -80}, {-40, -80}, {-40, -114}, {-22, -114}}, color = {0, 0, 127}));
  connect(potentialCircuit.vE, product1.u1) annotation(
    Line(points = {{-80, -80}, {60, -80}, {60, -94}, {78, -94}}, color = {0, 0, 127}));
  connect(UPssPu, add3.u3) annotation(
    Line(points = {{-300, -60}, {-180, -60}, {-180, -8}, {-162, -8}}, color = {0, 0, 127}));
  connect(UsRefPu, add3.u1) annotation(
    Line(points = {{-300, 60}, {-180, 60}, {-180, 8}, {-162, 8}}, color = {0, 0, 127}));
  connect(realToComplex.y, potentialCircuit.iT) annotation(
    Line(points = {{-219, -120}, {-120, -120}, {-120, -84}, {-102, -84}}, color = {85, 170, 255}));
  connect(itPuRe, realToComplex.re) annotation(
    Line(points = {{-300, -100}, {-260, -100}, {-260, -114}, {-242, -114}}, color = {0, 0, 127}));
  connect(itPuIm, realToComplex.im) annotation(
    Line(points = {{-300, -140}, {-260, -140}, {-260, -126}, {-242, -126}}, color = {0, 0, 127}));
  connect(utPu, potentialCircuit.uT) annotation(
    Line(points = {{-150, -40}, {-120, -40}, {-120, -76}, {-102, -76}}, color = {85, 170, 255}));
  connect(add3.y, limPI1.u) annotation(
    Line(points = {{-138, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-300, 0}, {-222, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, add3.u2) annotation(
    Line(points = {{-199, 0}, {-163, 0}}, color = {0, 0, 127}));
  connect(constant2.y, min.u1) annotation(
    Line(points = {{103, 60}, {120, 60}, {120, 26}, {138, 26}}, color = {0, 0, 127}));
  connect(limPI1.y, firstOrder1.u) annotation(
    Line(points = {{-78, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(min.y, product.u1) annotation(
    Line(points = {{161, 20}, {180, 20}, {180, 6}, {197, 6}}, color = {0, 0, 127}));
  connect(min1.y, product.u2) annotation(
    Line(points = {{161, -60}, {180, -60}, {180, -6}, {198, -6}}, color = {0, 0, 127}));
  connect(product.y, EfdPu) annotation(
    Line(points = {{221, 0}, {286, 0}}, color = {0, 0, 127}));
  connect(limPI2.y, min.u2) annotation(
    Line(points = {{102, 0}, {120, 0}, {120, 14}, {138, 14}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback.u1) annotation(
    Line(points = {{-19, 0}, {32, 0}}, color = {0, 0, 127}));
  connect(feedback.y, limPI2.u) annotation(
    Line(points = {{49, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(gain.y, feedback.u2) annotation(
    Line(points = {{140, 100}, {40, 100}, {40, 8}}, color = {0, 0, 127}));
  connect(product.y, gain.u) annotation(
    Line(points = {{221, 0}, {240, 0}, {240, 100}, {162, 100}}, color = {0, 0, 127}));
  connect(gain1.y, division.u1) annotation(
    Line(points = {{-59, -160}, {-40, -160}, {-40, -126}, {-22, -126}}, color = {0, 0, 127}));
  connect(IfdPu, gain1.u) annotation(
    Line(points = {{-120, -160}, {-82, -160}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-280, -200}, {280, 200}})));
end ExcIEEEST4B;
