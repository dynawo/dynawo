within Dynawo.Electrical.Sources;

model WT4AIECelecPC "Converter Model and grid interface according to IEC 61400-27-1 standard for a wind turbine of type 4A"
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
    */
  import Modelica;
  import Modelica.Math;
  import Modelica.ComplexMath;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  extends SwitchOff.SwitchOffGenerator;
  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.PerUnit Res "Electrical system serial resistance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Xes "Electrical system serial reactance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Ges "Electrical system shunt conductance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Bes "Electrical system shunt susceptance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Rpc "Electrical system serial resistance in pu (base UNom, SNom)" annotation(
  Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Xpc "Electrical system serial reactance in pu (base UNom, SNom)" annotation(
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
  //  final parameter Types.ComplexPerUnit u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)";
  //  final parameter Types.ComplexPerUnit i0Pu = ComplexMath.conj(Complex(P0Pu, Q0Pu) / u0Pu) "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit IGsRe0Pu "Start value of the real component of the current at the converter's terminals (generator system) in pu (Ubase, SNom) (generator convention)";
  parameter Types.PerUnit IGsIm0Pu "Start value of the imaginary component of the current at the converter's terminals (generator system) in pu (Ubase, SNom) (generator convention)";
  parameter Types.PerUnit UGsRe0Pu "Start value of the real component of the voltage at the converter's terminals (generator system) in pu (base UNom)";
  parameter Types.PerUnit UGsIm0Pu "Start value of the imaginary component of the voltage at the converter's terminals (generator system) in pu (base UNom)";
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 15}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -5}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximal d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 75}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMaxPu(start = IqMax0Pu) "Maximal q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 55}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMinPu(start = IqMin0Pu) "Minimal q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 35}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput theta(start = UPhase0) "Phase shift of the converter's rotating frame with respect to the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {110, 95}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput uWtRePu(start = u0Pu.re) "Real component of the voltage at the wind turbine (electrical system) terminals in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 79}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {40, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uWtImPu(start = u0Pu.im) "Imaginary component of the voltage at the wind turbine (electrical system) terminals in pu (base UNom) " annotation(
    Placement(visible = true, transformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {80, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iWtRePu(start = -i0Pu.re * SystemBase.SnRef / SNom) "Real component of the current at the wind turbine terminals in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-80, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iWtImPu(start = -i0Pu.im * SystemBase.SnRef / SNom) "Imaginary component of the current at the wind turbine terminals n pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -51}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-40, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  /*Blocks*/
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = 0), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-96, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Sources.BaseConverters.IECElecSystemPC iECElecSystemPC(Bes = Bes, Ges = Ges, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, Res = Res, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, Xes = Xes, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {4, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Dynawo.Electrical.Sources.BaseConverters.IECGenSystem iECGenSystem(Bes = Bes, DipMax = DipMax, DiqMax = DiqMax, DiqMin = DiqMin, Ges = Ges, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, Tg = Tg, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Sources.IECPowerCollector iECPowerCollector(IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, Rpc = Rpc, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, Xpc = Xpc, i0Pu = i0Pu, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-60, -7.10543e-15}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
equation
  running.value = iECElecSystemPC.running;
/*Connectors*/
  connect(iECElecSystemPC.iGsRePu, iECGenSystem.iGsRePu) annotation(
    Line(points = {{26, 10}, {38, 10}}, color = {0, 0, 127}));
  connect(iECElecSystemPC.iGsImPu, iECGenSystem.iGsImPu) annotation(
    Line(points = {{26, -10}, {38, -10}}, color = {0, 0, 127}));
  connect(iECGenSystem.iqCmdPu, iqCmdPu) annotation(
    Line(points = {{82, -6}, {102, -6}, {102, -4}, {110, -4}}, color = {0, 0, 127}));
  connect(iECGenSystem.ipCmdPu, ipCmdPu) annotation(
    Line(points = {{82, 0}, {100, 0}, {100, 14}, {110, 14}, {110, 16}}, color = {0, 0, 127}));
  connect(iECGenSystem.iqMinPu, iqMinPu) annotation(
    Line(points = {{82, 6}, {94, 6}, {94, 34}, {110, 34}, {110, 36}}, color = {0, 0, 127}));
  connect(iECGenSystem.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{82, 12}, {88, 12}, {88, 56}, {110, 56}}, color = {0, 0, 127}));
  connect(iECGenSystem.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{82, 18}, {82, 74}, {110, 74}, {110, 76}}, color = {0, 0, 127}));
  connect(theta, iECGenSystem.theta) annotation(
    Line(points = {{110, 96}, {60, 96}, {60, 22}}, color = {0, 0, 127}));
  connect(iECElecSystemPC.uWtRePu, iECPowerCollector.uWtRePu) annotation(
    Line(points = {{-18, 16}, {-38, 16}}, color = {0, 0, 127}));
  connect(iECElecSystemPC.uWtImPu, iECPowerCollector.uWtImPu) annotation(
    Line(points = {{-18, 6}, {-38, 6}}, color = {0, 0, 127}));
  connect(iECPowerCollector.iWtRePu, iECElecSystemPC.iWtRePu) annotation(
    Line(points = {{-38, -6}, {-18, -6}}, color = {0, 0, 127}));
  connect(iECPowerCollector.iWtImPu, iECElecSystemPC.iWtImPu) annotation(
    Line(points = {{-38, -16}, {-18, -16}}, color = {0, 0, 127}));
  connect(iECElecSystemPC.uWtRePu, uWtRePu) annotation(
    Line(points = {{-18, 16}, {-18, 80}, {-110, 80}}, color = {0, 0, 127}));
  connect(iECElecSystemPC.uWtImPu, uWtImPu) annotation(
    Line(points = {{-18, 6}, {-32, 6}, {-32, 50}, {-110, 50}}, color = {0, 0, 127}));
  connect(iECPowerCollector.iWtRePu, iWtRePu) annotation(
    Line(points = {{-38, -6}, {-26, -6}, {-26, -80}, {-110, -80}}, color = {0, 0, 127}));
  connect(iECPowerCollector.iWtImPu, iWtImPu) annotation(
    Line(points = {{-38, -16}, {-36, -16}, {-36, -52}, {-110, -52}, {-110, -51}}, color = {0, 0, 127}));
  connect(iECPowerCollector.terminal, terminal) annotation(
    Line(points = {{-82, 0}, {-96, 0}, {-96, 0}, {-96, 0}}, color = {0, 0, 255}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 60}, extent = {{-90, -30}, {90, 30}}, textString = "IEC WT4A"), Text(origin = {0, 2}, extent = {{-90, -30}, {90, 30}}, textString = "Converter"), Text(origin = {2, -58}, extent = {{-90, -30}, {86, 22}}, textString = "PC")}, coordinateSystem(initialScale = 0.1)));
end WT4AIECelecPC;
