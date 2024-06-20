within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

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

model QControl2020 "Reactive power control module for wind turbines (IEC N°61400-27-1:2020)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseQControl(deadZone.deadZoneAtInit = true, deadZone.uMax = DUdb2Pu, deadZone.uMin = DUdb1Pu);

  //QControl parameters
  parameter Types.VoltageModulePu DUdb1Pu "Voltage change dead band lower limit (typically negative) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu DUdb2Pu "Voltage change dead band upper limit (typically positive) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpufrt "Voltage PI controller proportional gain during FRT in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Integer Mqfrt "FRT Q control modes (0-3) (see Table 29, section 7.7.5, page 60 of the IEC norm N°61400-27-1:2020)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tUss "Steady-state voltage filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UqRisePu "Voltage threshold for OVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput idfHookPu(start = 0) "User-defined fault current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-320, -220}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 110.5}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput ipfHookPu(start = 0) "User-defined post-fault current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-320, -280}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {50, 110.5}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PWTCFiltPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered active power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-320, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QWTCFiltPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Filtered reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-320, 280}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 74.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCFiltPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.IntegerOutput fFrt(start = 0) "Fault status (0: Normal operation, 1: During fault, 2: Post-fault)" annotation(
    Placement(visible = true, transformation(origin = {310, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqBaseHookPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current commmand in normal operation at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {310, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqvHookPu(start = 0) "Output of the fault current injection function in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {310, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.BooleanToInteger booleanToInteger annotation(
    Placement(visible = true, transformation(origin = {-70, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = tUss, k = tUss, x_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-210, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {50, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {50, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Kpufrt) annotation(
    Placement(visible = true, transformation(origin = {110, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = UqRisePu) annotation(
    Placement(visible = true, transformation(origin = {-210, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant2(k = Mqfrt) annotation(
    Placement(visible = true, transformation(origin = {150, -160}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {190, 180}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.SwitchInteger switch5 annotation(
    Placement(visible = true, transformation(origin = {-10, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch switch6(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {90, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch switch8(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {130, -260}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {150, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(switch8.y, limiter3.u) annotation(
    Line(points = {{142, -260}, {160, -260}, {160, -240}, {178, -240}}, color = {0, 0, 127}));
  connect(switch6.y, switch8.u[1]) annotation(
    Line(points = {{102, -200}, {110, -200}, {110, -256}, {120, -256}}, color = {0, 0, 127}));
  connect(switch6.y, switch8.u[2]) annotation(
    Line(points = {{102, -200}, {110, -200}, {110, -258}, {120, -258}}, color = {0, 0, 127}));
  connect(add4.y, switch8.u[3]) annotation(
    Line(points = {{61, -260}, {120, -260}}, color = {0, 0, 127}));
  connect(integerConstant2.y, switch8.f) annotation(
    Line(points = {{140, -160}, {130, -160}, {130, -248}}, color = {255, 127, 0}));
  connect(integerConstant2.y, switch6.f) annotation(
    Line(points = {{140, -160}, {90, -160}, {90, -188}}, color = {255, 127, 0}));
  connect(gain7.y, switch6.u[1]) annotation(
    Line(points = {{-59, -180}, {70, -180}, {70, -196}, {80, -196}}, color = {0, 0, 127}));
  connect(add3.y, switch6.u[2]) annotation(
    Line(points = {{62, -200}, {70, -200}, {70, -198}, {80, -198}}, color = {0, 0, 127}));
  connect(add3.y, switch6.u[3]) annotation(
    Line(points = {{62, -200}, {80, -200}}, color = {0, 0, 127}));
  connect(switch6.y, limiter2.u) annotation(
    Line(points = {{102, -200}, {178, -200}}, color = {0, 0, 127}));
  connect(derivative.y, deadZone.u) annotation(
    Line(points = {{-199, -180}, {-162, -180}}, color = {0, 0, 127}));
  connect(switch5.y, switch7.f) annotation(
    Line(points = {{2, -100}, {250, -100}, {250, -188}}, color = {255, 127, 0}));
  connect(switch5.y, fFrt) annotation(
    Line(points = {{1, -100}, {310, -100}}, color = {255, 127, 0}));
  connect(switch5.y, integerToReal.u) annotation(
    Line(points = {{2, -100}, {120, -100}, {120, -42}}, color = {255, 127, 0}));
  connect(delayFlag.fO, switch5.u3) annotation(
    Line(points = {{-138, -100}, {-120, -100}, {-120, -92}, {-22, -92}}, color = {255, 127, 0}));
  connect(booleanToInteger.y, switch5.u1) annotation(
    Line(points = {{-59, -140}, {-40, -140}, {-40, -108}, {-22, -108}}, color = {255, 127, 0}));
  connect(greaterThreshold.y, booleanToInteger.u) annotation(
    Line(points = {{-198, -140}, {-82, -140}}, color = {255, 0, 255}));
  connect(greaterThreshold.y, switch5.u2) annotation(
    Line(points = {{-198, -140}, {-100, -140}, {-100, -100}, {-22, -100}}, color = {255, 0, 255}));
  connect(switch4.y, iqBaseHookPu) annotation(
    Line(points = {{282, 100}, {310, 100}}, color = {0, 0, 127}));
  connect(gain7.y, iqvHookPu) annotation(
    Line(points = {{-59, -180}, {70, -180}, {70, -140}, {310, -140}}, color = {0, 0, 127}));
  connect(max.y, division.u2) annotation(
    Line(points = {{2, -40}, {20, -40}, {20, 174}, {38, 174}}, color = {0, 0, 127}));
  connect(max.y, division1.u2) annotation(
    Line(points = {{2, -40}, {20, -40}, {20, 134}, {38, 134}}, color = {0, 0, 127}));
  connect(QWTMaxPu, division.u1) annotation(
    Line(points = {{-320, 240}, {-280, 240}, {-280, 200}, {20, 200}, {20, 186}, {38, 186}}, color = {0, 0, 127}));
  connect(QWTMinPu, division1.u1) annotation(
    Line(points = {{-320, 140}, {-20, 140}, {-20, 146}, {38, 146}}, color = {0, 0, 127}));
  connect(division.y, variableLimiter1.limit1) annotation(
    Line(points = {{62, 180}, {70, 180}, {70, 220}, {130, 220}, {130, 208}, {138, 208}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter1.limit2) annotation(
    Line(points = {{62, 140}, {130, 140}, {130, 192}, {138, 192}}, color = {0, 0, 127}));
  connect(gain1.y, variableLimiter1.u) annotation(
    Line(points = {{122, 200}, {138, 200}}, color = {0, 0, 127}));
  connect(switch1.y, add1.u2) annotation(
    Line(points = {{202, 180}, {210, 180}, {210, 234}, {218, 234}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, switch1.u3) annotation(
    Line(points = {{162, 200}, {170, 200}, {170, 188}, {178, 188}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold.y, switch1.u2) annotation(
    Line(points = {{120, 22}, {120, 130}, {150, 130}, {150, 180}, {178, 180}}, color = {255, 0, 255}));
  connect(feedback1.y, gain2.u) annotation(
    Line(points = {{70, 240}, {80, 240}, {80, 160}, {98, 160}}, color = {0, 0, 127}));
  connect(gain2.y, switch1.u1) annotation(
    Line(points = {{122, 160}, {170, 160}, {170, 172}, {178, 172}}, color = {0, 0, 127}));
  connect(idfHookPu, switch6.u[4]) annotation(
    Line(points = {{-320, -220}, {70, -220}, {70, -204}, {80, -204}}, color = {0, 0, 127}));
  connect(ipfHookPu, switch8.u[4]) annotation(
    Line(points = {{-320, -280}, {110, -280}, {110, -264}, {120, -264}}, color = {0, 0, 127}));
  connect(QWTCFiltPu, feedback.u2) annotation(
    Line(points = {{-320, 280}, {-180, 280}, {-180, 248}}, color = {0, 0, 127}));
  connect(QWTCFiltPu, gain6.u) annotation(
    Line(points = {{-320, 280}, {-294, 280}, {-294, -20}, {-242, -20}}, color = {0, 0, 127}));
  connect(PWTCFiltPu, abs.u) annotation(
    Line(points = {{-320, 0}, {-286, 0}, {-286, 6}}, color = {0, 0, 127}));
  connect(PWTCFiltPu, gain5.u) annotation(
    Line(points = {{-320, 0}, {-262, 0}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, greaterThreshold.u) annotation(
    Line(points = {{-320, -60}, {-280, -60}, {-280, -140}, {-222, -140}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, lessThreshold.u) annotation(
    Line(points = {{-320, -60}, {-280, -60}, {-280, -100}, {-222, -100}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, vDrop.UPu) annotation(
    Line(points = {{-320, -60}, {-200, -60}, {-200, -32}, {-182, -32}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, max.u1) annotation(
    Line(points = {{-320, -60}, {-100, -60}, {-100, -34}, {-22, -34}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, derivative.u) annotation(
    Line(points = {{-320, -60}, {-280, -60}, {-280, -180}, {-222, -180}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -300}, {300, 300}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-7, 35}, extent = {{-88, -25}, {100, 30}}, textString = "IEC WT"), Text(origin = {-3, -17}, extent = {{-85, -24}, {100, 30}}, textString = "QControl"), Text(origin = {-8, -66}, extent = {{-85, -24}, {100, 30}}, textString = "2020")}));
end QControl2020;
