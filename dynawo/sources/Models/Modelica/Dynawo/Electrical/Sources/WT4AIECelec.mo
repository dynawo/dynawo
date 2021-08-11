within Dynawo.Electrical.Sources;

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

model WT4AIECelec "Converter Model and grid interface according to IEC 61400-27-1 standard for a wind turbine of type 4A"
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
  parameter Types.PerUnit Res "Electrical system resistance in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Les "Electrical system inductance in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Ges "Electrical system shunt conductance in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Bes "Electrical system shunt susceptance in p.u (base UNom, SNom)"annotation(Dialog(group = "group", tab = "Electrical"));
  /*Control parameters*/
  parameter Types.Time Tpll "Time constant for PLL first order filter model in seconds" annotation(Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Upll1 "Voltage below which the angle of the voltage is filtered/frozen in p.u (base UNom)" annotation(Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Upll2 "Voltage below which the angle of the voltage is frozen in p.u (base UNom)" annotation(Dialog(group = "group", tab = "Generator"));
  parameter Types.Time Tg "Current generation time constant in seconds" annotation(Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Dipmax "Maximun active current ramp rate in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Diqmax "Maximun reactive current ramp rate in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Diqmin "Minimum reactive current ramp rate in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Generator"));
  /*Parameters for initialization from load flow*/
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)" annotation(Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in p.u (base UNom, SnRef) (receptor convention)" annotation(Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in p.u (base SnRef) (receptor convention)" annotation(Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in p.u (base SnRef) (receptor convention)" annotation(Dialog(group = "group", tab = "Operating point"));
  /*Parameters for internal initialization*/
  parameter Types.PerUnit IpMax0Pu "Start value of the maximum active current in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqMax0Pu "Start value of the maximum reactive current in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqMin0Pu "Start value of the minimum reactive current in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Operating point"));
  final parameter Types.PerUnit ipCmd0Pu = -P0Pu*SystemBase.SnRef / (SNom*sqrt(u0Pu.re*u0Pu.re + u0Pu.im*u0Pu.im)) "Initial value of the d-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention";
  final parameter Types.PerUnit iqCmd0Pu = -Q0Pu*SystemBase.SnRef / (SNom*sqrt(u0Pu.re*u0Pu.re + u0Pu.im*u0Pu.im)) "Initial value of the q-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention";

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = ipCmd0Pu) "d-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {110, 15}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = iqCmd0Pu) "q-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {110, -5}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximal d-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {110, 75}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMaxPu(start = IqMax0Pu) "Maximal q-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {110, 55}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMinPu(start = IqMin0Pu) "Minimal q-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {110, 35}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {110, 95}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput uWtRePu(start = u0Pu.re) "Real component of the voltage at the wind turbine (electrical system) terminals in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {40, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uWtImPu(start = u0Pu.im) "Imaginary component of the voltage at the wind turbine (electrical system) terminals in p.u (base UNom) " annotation(
    Placement(visible = true, transformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {80, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iWtRePu(start = -i0Pu.re * SystemBase.SnRef / SNom) "Real component of the current at the wind turbine terminals in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-80, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iWtImPu(start = -i0Pu.im * SystemBase.SnRef / SNom) "Imaginary component of the current at the wind turbine terminals n p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-110, -45}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-40, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  /*Other calculated variables*/
  Types.PerUnit PGenPu(start = -P0Pu) "Active power generated by the converter at the PCC in p.u (base UNom, SnRef) (generator convention)";
  Types.PerUnit QGenPu(start = -Q0Pu) "Reactive power generated by the converter at the PCC in p.u (base UNom, SnRef) (generator convention)";
  /*Blocks*/
  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.BaseConverters.IECElecSystem iECElecSystem(Bes = Bes, Ges = Ges, Les = Les, P0Pu = P0Pu, Q0Pu = Q0Pu, Res = Res, SNom = SNom, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Sources.BaseConverters.IECGenSystem iECGenSystem(Bes = Bes,Dipmax = Dipmax, Diqmax = Diqmax, Diqmin = Diqmin, Ges = Ges, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Les = Les, P0Pu = P0Pu, Q0Pu = Q0Pu, Res = Res, SNom = SNom, Tg = Tg, Theta0 = Theta0, Tpll = Tpll, Upll1 = Upll1, Upll2 = Upll2, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  //
equation
  PGenPu = iECElecSystem.PGenPu;
  QGenPu = iECElecSystem.QGenPu;
  running.value = iECElecSystem.running;
//  running.value = iECGenSystem.running;
/*Connectors*/
  connect(terminal, iECElecSystem.terminal) annotation(
    Line(points = {{-90, 0}, {-60, 0}, {-60, 0}, {-60, 0}}));
  connect(iECElecSystem.iGsRePu, iECGenSystem.iGsRePu) annotation(
    Line(points = {{-18, 10}, {18, 10}, {18, 10}, {18, 10}}, color = {0, 0, 127}));
  connect(iECElecSystem.iGsImPu, iECGenSystem.iGsImPu) annotation(
    Line(points = {{-18, -10}, {18, -10}, {18, -10}, {18, -10}}, color = {0, 0, 127}));
  connect(iECGenSystem.iqCmdPu, iqCmdPu) annotation(
    Line(points = {{62, -6}, {102, -6}, {102, -4}, {110, -4}}, color = {0, 0, 127}));
  connect(uWtImPu, iECElecSystem.uWtImPu) annotation(
    Line(points = {{-110, -90}, {-24, -90}, {-24, -22}, {-24, -22}}, color = {0, 0, 127}));
  connect(uWtRePu, iECElecSystem.uWtRePu) annotation(
    Line(points = {{-110, -74}, {-32, -74}, {-32, -22}, {-32, -22}}, color = {0, 0, 127}));
  connect(iWtRePu, iECElecSystem.iWtRePu) annotation(
    Line(points = {{-110, -30}, {-56, -30}, {-56, -22}, {-56, -22}}, color = {0, 0, 127}));
  connect(iECGenSystem.ipCmdPu, ipCmdPu) annotation(
    Line(points = {{62, 0}, {92, 0}, {92, 14}, {110, 14}, {110, 16}}, color = {0, 0, 127}));
  connect(iECGenSystem.iqMinPu, iqMinPu) annotation(
    Line(points = {{62, 6}, {86, 6}, {86, 34}, {110, 34}, {110, 36}}, color = {0, 0, 127}));
  connect(iECGenSystem.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{62, 12}, {78, 12}, {78, 56}, {110, 56}, {110, 56}}, color = {0, 0, 127}));
  connect(iECGenSystem.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{62, 18}, {70, 18}, {70, 74}, {110, 74}, {110, 76}}, color = {0, 0, 127}));
  connect(iWtImPu, iECElecSystem.iWtImPu) annotation(
    Line(points = {{-110, -44}, {-50, -44}, {-50, -44}, {-48, -44}, {-48, -22}, {-48, -22}}, color = {0, 0, 127}));
  connect(iECElecSystem.uWtPu, iECGenSystem.uWtPu) annotation(
    Line(points = {{-40, -22}, {-40, -22}, {-40, -40}, {74, -40}, {74, -14}, {62, -14}, {62, -14}}, color = {0, 0, 127}));
  connect(theta, iECGenSystem.theta) annotation(
    Line(points = {{110, 96}, {40, 96}, {40, 24}, {40, 24}, {40, 22}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-90, -30}, {90, 30}}, textString = "IEC WT4A"), Text(origin = {0, -30}, extent = {{-90, -30}, {90, 30}}, textString = "Converter")}, coordinateSystem(initialScale = 0.1)));
end WT4AIECelec;
