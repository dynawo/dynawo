within Dynawo.Electrical.Sources.BaseConverters;

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

model IECGenSystemAux
  /*
  Equivalent circuit and conventions:
  */

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.PerUnit Ges "Electrical system shunt conductance in pu (base UNom, SNom)" annotation(
  Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Bes "Electrical system shunt susceptance in pu (base UNom, SNom)" annotation(
  Dialog(group = "group", tab = "Electrical"));

  /*Control parameters*/
  parameter Types.Time Tg "Current generation time constant in seconds" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit DipMax "Maximun active current ramp rate in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit DiqMax "Maximun reactive current ramp rate in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit DiqMin "Minimum reactive current ramp rate in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));

  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0 "Start value of voltage angle at plan terminal (PCC) in radians" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));

  /*Parameters for internal initialization*/
  parameter Types.PerUnit IpMax0Pu "Start value of the maximum active current in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqMax0Pu "Start value of the maximum reactive current in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqMin0Pu "Start value of the minimum reactive current in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));

  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit IGsRe0Pu "Start value of the real component of the current at the converter's terminals (generator system) in pu (Ubase, SNom) (generator convention)";
  parameter Types.PerUnit IGsIm0Pu "Start value of the imaginary component of the current at the converter's terminals (generator system) in pu (Ubase, SNom) (generator convention)";

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = 0) "d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = 0) "Maximal d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-70, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMaxPu(start = IqMax0Pu) "Maximal q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-70, 15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMinPu(start = IqMin0Pu) "Minimal q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-70, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput theta(start = UPhase0) "Phase shift of the converter's rotating frame with respect to the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {-70, -41}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
    /*Ouputs*/
  Modelica.Blocks.Interfaces.RealOutput iGsRePu(start = 0) "Real component of the current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {70, 16.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iGsImPu(start = IGsIm0Pu) "Imaginary component of the current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {70, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  /*Blocks*/
  Dynawo.Electrical.Sources.BaseConverters.IECFrameRotation iECFrameRotation(P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {30.65, -0.1667}, extent = {{-9.65, -32.1667}, {9.65, 32.1667}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRampLimit firstOrderRampLimitIp(DuMax = DipMax, DuMin = -999, GainAW = 100, T = Tg, k = 1, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-13, 40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRampLimit firstOrderRampLimitIq(DuMax = DiqMax, DuMin = DiqMin, GainAW = 100, T = Tg, k = 1, y_start = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-36, 0}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = -999) annotation(
    Placement(visible = true, transformation(origin = {-43.5, 28.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1)  annotation(
    Placement(visible = true, transformation(origin = {-5, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  //
equation

  /*Connectors*/
  connect(ipMaxPu, firstOrderRampLimitIp.uMax) annotation(
    Line(points = {{-70, 55}, {-28, 55}, {-28, 47}, {-24, 47}}, color = {0, 0, 127}));
  connect(ipCmdPu, firstOrderRampLimitIp.u) annotation(
    Line(points = {{-70, 40}, {-24, 40}}, color = {0, 0, 127}));
  connect(firstOrderRampLimitIp.y, iECFrameRotation.ipCmdPu) annotation(
    Line(points = {{-2, 40}, {10, 40}, {10, 29}, {18, 29}}, color = {0, 0, 127}));
  connect(iqCmdPu, firstOrderRampLimitIq.u) annotation(
    Line(points = {{-70, 0}, {-47, 0}}, color = {0, 0, 127}));
  connect(iqMaxPu, firstOrderRampLimitIq.uMax) annotation(
    Line(points = {{-70, 15}, {-54.5, 15}, {-54.5, 7}, {-47, 7}}, color = {0, 0, 127}));
  connect(firstOrderRampLimitIp.y, iECFrameRotation.ipCmdPu) annotation(
    Line(points = {{-2, 40}, {10, 40}, {10, 29}, {18, 29}}, color = {0, 0, 127}));
  connect(const.y, firstOrderRampLimitIp.uMin) annotation(
    Line(points = {{-37, 29}, {-31, 29}, {-31, 33}, {-24, 33}, {-24, 33}}, color = {0, 0, 127}));
  connect(iqMinPu, firstOrderRampLimitIq.uMin) annotation(
    Line(points = {{-70, -15}, {-56, -15}, {-56, -7}, {-47, -7}}, color = {0, 0, 127}));
  connect(theta, iECFrameRotation.theta) annotation(
    Line(points = {{-70, -41}, {-2, -41}, {-2, -29}, {18, -29}}, color = {0, 0, 127}));
  connect(iECFrameRotation.iGsImPu, iGsImPu) annotation(
    Line(points = {{44, -16}, {70, -16}}, color = {0, 0, 127}));
  connect(iECFrameRotation.iGsRePu, iGsRePu) annotation(
    Line(points = {{44, 16}, {64, 16}, {64, 16.5}, {70, 16.5}}, color = {0, 0, 127}));
  connect(firstOrderRampLimitIq.y, gain.u) annotation(
    Line(points = {{-25, 0}, {-11, 0}}, color = {0, 0, 127}));
  connect(gain.y, iECFrameRotation.iqCmdPu) annotation(
    Line(points = {{0.5, 0}, {18, 0}}, color = {0, 0, 127}));
  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-60, -60}, {60, 60}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-100, -20}, {100, 20}}, textString = "Generator"), Text(origin = {0, -30}, extent = {{-100, -20}, {100, 20}}, textString = "System")}));

end IECGenSystemAux;
