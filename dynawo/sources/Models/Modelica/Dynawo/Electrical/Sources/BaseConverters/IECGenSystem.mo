within Dynawo.Electrical.Sources.BaseConverters;

model IECGenSystem
  /*
      * Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
      * See AUTHORS.txt
      * All rights reserved.
      * This Source Code Form is subject to the terms of the Mozilla Public
      * License, v. 2.0. If a copy of the MPL was not distributed with this
      * file, you can obtain one at http://mozilla.org/MPL/2.0/.
      * SPDX-License-Identifier: MPL-2.0
      *
      * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
      */
  /*
        Equivalent circuit and conventions:

            iPccPu
      ------->--(Res,Les)---(terminal)
          |
      uFilterPu                         uPccPu
      (Cfilter)
          |
      --------------------------------------------------

      */
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.PerUnit Res "Electrical system resistance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Les "Electrical system inductance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Ges "Electrical system shunt conductance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Bes "Electrical system shunt susceptance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  /*Control parameters*/
  parameter Types.Time Tpll "Time constant for PLL first order filter model in seconds" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Upll1 "Voltage below which the angle of the voltage is filtered/frozen in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Upll2 "Voltage below which the angle of the voltage is frozen in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.Time Tg "Current generation time constant in seconds" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Dipmax "Maximun active current ramp rate in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Diqmax "Maximun reactive current ramp rate in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Diqmin "Minimum reactive current ramp rate in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  /*Parameters for initialization from load flow*/
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in p.u (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in p.u (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in p.u (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  /*Parameters for internal initialization*/
  parameter Types.PerUnit IpMax0Pu "Start value of the maximum active current in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqMax0Pu "Start value of the maximum reactive current in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqMin0Pu "Start value of the minimum reactive current in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  final parameter Types.PerUnit IGsRe0Pu = (-i0Pu.re * SystemBase.SnRef / SNom) + u0Pu.re * Ges - u0Pu.im * Bes "Start value of the real component of the current at the converter's terminals (generator system) in p.u (Ubase, SNom) in generator convention";
  final parameter Types.PerUnit IGsIm0Pu = (-i0Pu.im * SystemBase.SnRef / SNom) + u0Pu.re * Bes + u0Pu.im * Ges "Start value of the imaginary component of the current at the converter's terminals (generator system) in p.u (Ubase, SNom) in generator convention";
  /*Inputs*/
  /*
        Modelica.Blocks.Interfaces.BooleanInput running(start = true) "FOCB in the IEC standart which is the breaker position" annotation(
              Placement(visible = true, transformation(origin = {-70, 22.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
        */
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * sqrt(u0Pu.re * u0Pu.re + u0Pu.im * u0Pu.im))) "d-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = -Q0Pu * SystemBase.SnRef / (SNom * sqrt(u0Pu.re * u0Pu.re + u0Pu.im * u0Pu.im))) "q-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-70, 5}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximal d-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-70, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMaxPu(start = IqMax0Pu) "Maximal q-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMinPu(start = IqMin0Pu) "Mainimal q-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput uWtPu(start = sqrt(u0Pu.re * u0Pu.re + u0Pu.im * u0Pu.im)) "WTT voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -75}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {-70, -55}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
    /*Ouputs*/
  Modelica.Blocks.Interfaces.RealOutput iGsRePu(start = IGsRe0Pu) "Real component of the current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iGsImPu(start = IGsIm0Pu) "Imaginary component of the current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {70, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  /*Blocks*/
  Dynawo.Electrical.Sources.BaseConverters.IECFrameRotation iECFrameRotation(SNom = SNom, Theta0 = Theta0, Tpll = Tpll, Upll1 = Upll1, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {34.65, 10.8333}, extent = {{-9.65, -32.1667}, {9.65, 32.1667}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRampLimit firstOrderRampLimitIp(DuMax = Dipmax, DuMin = -1000, T = Tg, k = 1, y_start = -P0Pu * SystemBase.SnRef / (SNom * sqrt(u0Pu.re * u0Pu.re + u0Pu.im * u0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-13, 40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRampLimit firstOrderRampLimitIq(DuMax = Diqmax, DuMin = Diqmin, T = Tg, k = 1, y_start = -Q0Pu * SystemBase.SnRef / (SNom * sqrt(u0Pu.re * u0Pu.re + u0Pu.im * u0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-36, 5}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-43.5, 28.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = 0)));
  //
equation
/*Connectors*/
  connect(ipMaxPu, firstOrderRampLimitIp.uMax) annotation(
    Line(points = {{-70, 55}, {-28, 55}, {-28, 47}, {-24, 47}}, color = {0, 0, 127}));
  connect(ipCmdPu, firstOrderRampLimitIp.u) annotation(
    Line(points = {{-70, 40}, {-24, 40}}, color = {0, 0, 127}));
  connect(firstOrderRampLimitIp.y, iECFrameRotation.ipCmdPu) annotation(
    Line(points = {{-2, 40}, {22, 40}}, color = {0, 0, 127}));
  connect(iqCmdPu, firstOrderRampLimitIq.u) annotation(
    Line(points = {{-70, 5}, {-47, 5}}, color = {0, 0, 127}));
  connect(iqMaxPu, firstOrderRampLimitIq.uMax) annotation(
    Line(points = {{-70, 20}, {-54.5, 20}, {-54.5, 12}, {-47, 12}}, color = {0, 0, 127}));
  connect(firstOrderRampLimitIq.y, iECFrameRotation.iqCmdPu) annotation(
    Line(points = {{-25, 5}, {-20, 5}, {-20, 20}, {22, 20}}, color = {0, 0, 127}));
  connect(iECFrameRotation.iGsRePu, iGsRePu) annotation(
    Line(points = {{48, 30}, {70, 30}}, color = {0, 0, 127}));
  connect(iECFrameRotation.iGsImPu, iGsImPu) annotation(
    Line(points = {{48, 11}, {63, 11}, {63, 10}, {70, 10}}, color = {0, 0, 127}));
  connect(firstOrderRampLimitIp.y, iECFrameRotation.ipCmdPu) annotation(
    Line(points = {{-2, 40}, {20, 40}, {20, 40}, {22, 40}}, color = {0, 0, 127}));
  connect(const.y, firstOrderRampLimitIp.uMin) annotation(
    Line(points = {{-37, 29}, {-31, 29}, {-31, 33}, {-24, 33}, {-24, 33}}, color = {0, 0, 127}));
  connect(iqMinPu, firstOrderRampLimitIq.uMin) annotation(
    Line(points = {{-70, -10}, {-56, -10}, {-56, -2}, {-47, -2}, {-47, -2}}, color = {0, 0, 127}));
  connect(theta, iECFrameRotation.theta) annotation(
    Line(points = {{-70, -55}, {-2, -55}, {-2, -18}, {22, -18}, {22, -18}}, color = {0, 0, 127}));
  connect(uWtPu, iECFrameRotation.uWTPu) annotation(
    Line(points = {{-70, -40}, {-9, -40}, {-9, 1}, {22, 1}, {22, 1}}, color = {0, 0, 127}));
  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-60, -60}, {60, 60}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-100, -20}, {100, 20}}, textString = "Generator"), Text(origin = {0, -30}, extent = {{-100, -20}, {100, 20}}, textString = "System")}));
end IECGenSystem;
