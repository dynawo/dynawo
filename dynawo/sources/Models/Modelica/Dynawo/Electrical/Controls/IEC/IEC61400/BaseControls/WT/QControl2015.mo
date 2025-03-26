within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

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

model QControl2015 "Reactive power control module for wind turbines (IEC N°61400-27-1:2020)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseQControl(deadZone.uMax = Udb2Pu, deadZone.uMin = Udb1Pu);

  //Q control parameters
  parameter Integer MqUvrt "UVRT Q control modes (0-2) (see Table 23, section 5.6.5.7, page 51 of the IEC norm N°61400-27-1:2015)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tPFiltQ "Active power filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tUFiltQ "Voltage filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu Udb1Pu "Voltage dead band lower limit in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu Udb2Pu "Voltage dead band upper limit in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PWTPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-320, -52}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -45}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QWTPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-320, 280}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, -82}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.IntegerOutput fUvrt(start = 0) "Fault status (0: Normal operation, 1: During fault, 2: Post-fault)" annotation(
    Placement(visible = true, transformation(origin = {310, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tUFiltQ, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-270, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tPFiltQ, y_start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-286, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant2(k = MqUvrt) annotation(
    Placement(visible = true, transformation(origin = {150, -160}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch2(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {90, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {126, -260}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(gain1.y, add1.u2) annotation(
    Line(points = {{122, 200}, {200, 200}, {200, 234}, {218, 234}}, color = {0, 0, 127}));
  connect(delayFlag.fO, integerToReal.u) annotation(
    Line(points = {{-138, -100}, {120, -100}, {120, -42}}, color = {255, 127, 0}));
  connect(delayFlag.fO, fUvrt) annotation(
    Line(points = {{-138, -100}, {310, -100}}, color = {255, 127, 0}));
  connect(delayFlag.fO, switch7.f) annotation(
    Line(points = {{-138, -100}, {250, -100}, {250, -188}}, color = {255, 127, 0}));
  connect(UWTPu, firstOrder.u) annotation(
    Line(points = {{-320, -82}, {-282, -82}}, color = {0, 0, 127}));
  connect(firstOrder.y, vDrop.UPu) annotation(
    Line(points = {{-259, -82}, {-200, -82}, {-200, -32}, {-182, -32}}, color = {0, 0, 127}));
  connect(firstOrder.y, lessThreshold.u) annotation(
    Line(points = {{-259, -82}, {-240, -82}, {-240, -100}, {-222, -100}}, color = {0, 0, 127}));
  connect(firstOrder.y, deadZone.u) annotation(
    Line(points = {{-259, -82}, {-240, -82}, {-240, -180}, {-162, -180}}, color = {0, 0, 127}));
  connect(QWTPu, feedback.u2) annotation(
    Line(points = {{-320, 280}, {-180, 280}, {-180, 248}}, color = {0, 0, 127}));
  connect(QWTPu, gain6.u) annotation(
    Line(points = {{-320, 280}, {-296, 280}, {-296, -20}, {-242, -20}}, color = {0, 0, 127}));
  connect(firstOrder.y, max1.u1) annotation(
    Line(points = {{-259, -82}, {-100, -82}, {-100, -34}, {-22, -34}}, color = {0, 0, 127}));
  connect(PWTPu, firstOrder1.u) annotation(
    Line(points = {{-320, -52}, {-286, -52}, {-286, -46}}, color = {0, 0, 127}));
  connect(firstOrder1.y, abs.u) annotation(
    Line(points = {{-286, -23}, {-286, 6}}, color = {0, 0, 127}));
  connect(gain7.y, multiSwitch2.u[1]) annotation(
    Line(points = {{-58, -180}, {80, -180}}, color = {0, 0, 127}));
  connect(add3.y, multiSwitch2.u[2]) annotation(
    Line(points = {{62, -200}, {64, -200}, {64, -180}, {80, -180}}, color = {0, 0, 127}));
  connect(add3.y, multiSwitch2.u[3]) annotation(
    Line(points = {{62, -200}, {64, -200}, {64, -180}, {80, -180}}, color = {0, 0, 127}));
  connect(integerConstant2.y, multiSwitch2.f) annotation(
    Line(points = {{140, -160}, {90, -160}, {90, -168}}, color = {255, 127, 0}));
  connect(multiSwitch2.y, multiSwitch1.u[1]) annotation(
    Line(points = {{102, -180}, {106, -180}, {106, -260}, {116, -260}}, color = {0, 0, 127}));
  connect(multiSwitch2.y, multiSwitch1.u[2]) annotation(
    Line(points = {{102, -180}, {106, -180}, {106, -260}, {116, -260}}, color = {0, 0, 127}));
  connect(add4.y, multiSwitch1.u[3]) annotation(
    Line(points = {{62, -260}, {116, -260}}, color = {0, 0, 127}));
  connect(integerConstant2.y, multiSwitch1.f) annotation(
    Line(points = {{140, -160}, {126, -160}, {126, -248}}, color = {255, 127, 0}));
  connect(multiSwitch2.y, limiter2.u) annotation(
    Line(points = {{102, -180}, {106, -180}, {106, -200}, {178, -200}}, color = {0, 0, 127}));
  connect(multiSwitch1.y, limiter3.u) annotation(
    Line(points = {{138, -260}, {160, -260}, {160, -240}, {178, -240}}, color = {0, 0, 127}));
  connect(PWTPu, gain5.u) annotation(
    Line(points = {{-320, -52}, {-270, -52}, {-270, 0}, {-262, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {-11, -59}, extent = {{-85, -24}, {100, 30}}, textString = "2015")}));
end QControl2015;
