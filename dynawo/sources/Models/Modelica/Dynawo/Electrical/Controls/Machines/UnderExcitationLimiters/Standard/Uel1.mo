within Dynawo.Electrical.Controls.Machines.UnderExcitationLimiters.Standard;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model Uel1 "IEEE (2016) underexcitation limiter type UEL1 model"

  //Regulation parameters
  parameter Types.PerUnit Kuc "UEL center setting";
  parameter Types.PerUnit Kuf "UEL excitation system stabilizer gain";
  parameter Types.PerUnit Kui "UEL integral gain";
  parameter Types.PerUnit Kul "UEL proportional gain";
  parameter Types.PerUnit Kur "UEL radius setting";
  parameter Types.Time tU1 "UEL first lead time constant in s";
  parameter Types.Time tU2 "UEL first lag time constant in s";
  parameter Types.Time tU3 "UEL second lead time constant in s";
  parameter Types.Time tU4 "UEL second lag time constant in s";
  parameter Types.VoltageModulePu VUcMaxPu "UEL maximum voltage magnitude in pu (base UNom)";
  parameter Types.VoltageModulePu VUiMaxPu "UEL maximum output in pu (base UNom)";
  parameter Types.VoltageModulePu VUiMinPu "UEL minimum output in pu (base UNom)";
  parameter Types.VoltageModulePu VUrMaxPu "UEL maximum radius in pu (base UNom)";

  //Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput itPu(re(start = it0Pu.re), im(start = it0Pu.im)) "Complex stator current in pu (base SnRef, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput utPu(re(start = ut0Pu.re), im(start = ut0Pu.im)) "Complex stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput VfPu(start = Vf0Pu) "Excitation system stabilizer signal" annotation(
    Placement(visible = true, transformation(origin = {-220, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput UUelPu(start = 0) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = VUiMaxPu, uMin = VUiMinPu) annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.Add add1(k1 = Complex(Kuc, 0), k2 = Complex(0, -1)) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Complex.ComplexToPolar complexToPolar annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Complex.ComplexToPolar complexToPolar1 annotation(
    Placement(visible = true, transformation(origin = {-150, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = VUrMaxPu, uMin = -999) annotation(
    Placement(visible = true, transformation(origin = {-50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(uMax = VUcMaxPu, uMin = -999) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kur) annotation(
    Placement(visible = true, transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = -1, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kuf) annotation(
    Placement(visible = true, transformation(origin = {-50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimitedPI limitedPI(Ki = Kui, Kp = Kul, YMax = VUiMaxPu, YMin = VUiMinPu) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction(a = {tU2, 1}, b = {tU1, 1}) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction1(a = {tU4, 1}, b = {tU3, 1}) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameter
  parameter Types.ComplexCurrentPu it0Pu "Initial complex stator current in pu (base SnRef, UNom)";
  parameter Types.ComplexVoltagePu ut0Pu "Initial complex stator voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu Vf0Pu = (Modelica.ComplexMath.'abs'(Kuc * ut0Pu - Complex(0, 1) * it0Pu) - Kur * Modelica.ComplexMath.'abs'(ut0Pu)) / Kuf "Initial input stabilizer signal";

equation
  connect(limiter.y, UUelPu) annotation(
    Line(points = {{181, 0}, {209, 0}}, color = {0, 0, 127}));
  connect(utPu, add1.u1) annotation(
    Line(points = {{-220, 40}, {-180, 40}, {-180, 6}, {-162, 6}}, color = {85, 170, 255}));
  connect(itPu, add1.u2) annotation(
    Line(points = {{-220, -40}, {-180, -40}, {-180, -6}, {-162, -6}}, color = {85, 170, 255}));
  connect(add1.y, complexToPolar.u) annotation(
    Line(points = {{-139, 0}, {-123, 0}}, color = {85, 170, 255}));
  connect(utPu, complexToPolar1.u) annotation(
    Line(points = {{-220, 40}, {-180, 40}, {-180, 60}, {-162, 60}}, color = {85, 170, 255}));
  connect(complexToPolar1.len, gain.u) annotation(
    Line(points = {{-138, 66}, {-120, 66}, {-120, 60}, {-102, 60}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{-79, 60}, {-63, 60}}, color = {0, 0, 127}));
  connect(complexToPolar.len, limiter2.u) annotation(
    Line(points = {{-98, 6}, {-80, 6}, {-80, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(limiter1.y, add3.u1) annotation(
    Line(points = {{-39, 60}, {-20, 60}, {-20, 8}, {-3, 8}}, color = {0, 0, 127}));
  connect(VfPu, gain1.u) annotation(
    Line(points = {{-220, -80}, {-62, -80}}, color = {0, 0, 127}));
  connect(gain1.y, add3.u3) annotation(
    Line(points = {{-39, -80}, {-20, -80}, {-20, -8}, {-3, -8}}, color = {0, 0, 127}));
  connect(limiter2.y, add3.u2) annotation(
    Line(points = {{-39, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(add3.y, limitedPI.u) annotation(
    Line(points = {{21, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(limitedPI.y, transferFunction.u) annotation(
    Line(points = {{61, 0}, {77, 0}}, color = {0, 0, 127}));
  connect(transferFunction.y, transferFunction1.u) annotation(
    Line(points = {{101, 0}, {117, 0}}, color = {0, 0, 127}));
  connect(transferFunction1.y, limiter.u) annotation(
    Line(points = {{141, 0}, {157, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end Uel1;
