within Dynawo.Electrical.Controls.Voltage.StaticVarCompensator;

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

model SVarCControl "Control for standard static var compensator model"
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.Voltage.StaticVarCompensator.Parameters;

  extends Parameters.Params_Regulation;
  extends Parameters.Params_Limitations;
  extends Parameters.Params_CalculBG;
  extends Parameters.Params_ModeHandling;

  Modelica.Blocks.Interfaces.RealInput URef(start = URef0) "Voltage reference for the regulation in kV" annotation(
    Placement(visible = true, transformation(origin = {-168, 26}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, 85}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage at the static var compensator terminal in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-168, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, -41}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QInjPu(start = -Q0Pu) "Reactive power injected by the static var compensator in p.u (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-168, -68}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, -83}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  Modelica.Blocks.Interfaces.BooleanInput selectModeAuto(start = true) "Mode selected when in manual configuration" annotation(
    Placement(visible = true, transformation(origin = {-168, 54}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, 49}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerInput setMode(start = 2) "Wheter the static var compensator is in automatic configuration" annotation(
    Placement(visible = true, transformation(origin = {-168, 84}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, 9}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput BPu(start = B0Pu) "Susceptance of the static var compensator in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {146, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput GPu(start = G0Pu) "Conductance of the static var compensator in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {146, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant GPu_cst(k = G0Pu)  annotation(
    Placement(visible = true, transformation(origin = {32, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Regulation regulation(BMaxPu = BMaxPu, BMinPu = BMinPu,BVar0Pu = BVar0Pu, IMaxPu = IMaxPu, IMinPu = IMinPu, KCurrentLimiter = KCurrentLimiter, KG = KG, Kp = Kp, Lambda = Lambda, SNom = SNom, Ti = Ti)  annotation(
    Placement(visible = true, transformation(origin = {30, -6}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {-58, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain PuConversion(k = SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {-128, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ModeHandling modeHandling(Mode0 = Mode0, UBlock = UBlock, UDeblockDown = UDeblockDown, UDeblockUp = UDeblockUp, UNom = UNom, URefDown = URefDown, URefUp = URefUp, UThresholdDown = UThresholdDown, UThresholdUp = UThresholdUp, tThresholdDown = tThresholdDown, tThresholdUp = tThresholdUp, URef0 = URef0)  annotation(
    Placement(visible = true, transformation(origin = {-59, 37}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  CalculBG calculBG(BShuntPu = BShuntPu)  annotation(
    Placement(visible = true, transformation(origin = {98, -18}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));

protected

  parameter Types.PerUnit G0Pu "Start value of the conductance in p.u (base SNom)";
  parameter Types.PerUnit B0Pu "Start value of the susceptance in p.u (base SNom)";
  parameter Types.VoltageModulePu U0Pu  "Start value of voltage amplitude in p.u (base UNom)";
  parameter Types.ReactivePowerPu Q0Pu  "Start value of reactive power in p.u (base SnRef) (receptor convention)";
  parameter Types.VoltageModule URef0  "Start value of voltage reference in kV";
  final parameter Types.PerUnit BVar0Pu = B0Pu + BShuntPu "Start value of variable susceptance in p.u";
  parameter Mode Mode0 "Start value for mode";

equation
  connect(calculBG.GPu, GPu) annotation(
    Line(points = {{118, -28}, {138, -28}, {138, -28}, {146, -28}}, color = {0, 0, 127}));
  connect(calculBG.BPu, BPu) annotation(
    Line(points = {{118, -8}, {138, -8}, {138, -8}, {146, -8}}, color = {0, 0, 127}));
  connect(GPu_cst.y, calculBG.GCstPu) annotation(
    Line(points = {{44, -42}, {60, -42}, {60, -28}, {78, -28}}, color = {0, 0, 127}));
  connect(regulation.BVarPu, calculBG.BVarPu) annotation(
    Line(points = {{50, -6}, {76, -6}, {76, -8}, {78, -8}}, color = {0, 0, 127}));
  connect(modeHandling.mode, calculBG.mode) annotation(
    Line(points = {{-38, 38}, {110, 38}, {110, 2}, {110, 2}}, color = {0, 0, 127}));
  connect(setMode, modeHandling.setMode) annotation(
    Line(points = {{-168, 84}, {-110, 84}, {-110, 52}, {-82, 52}}, color = {255, 127, 0}));
  connect(selectModeAuto, modeHandling.selectModeAuto) annotation(
    Line(points = {{-168, 54}, {-125, 54}, {-125, 42}, {-82, 42}}, color = {255, 0, 255}));
  connect(URef, modeHandling.URef) annotation(
    Line(points = {{-168, 26}, {-126, 26}, {-126, 32}, {-82, 32}, {-82, 30}}, color = {0, 0, 127}));
  connect(modeHandling.URefPu, regulation.URefPu) annotation(
    Line(points = {{-38.1, 25.6}, {-15.1, 25.6}, {-15.1, 6}, {9, 6}}, color = {0, 0, 127}));
  connect(modeHandling.blocked, regulation.blocked) annotation(
    Line(points = {{-38.1, 48.4}, {44, 48.4}, {44, 16}}, color = {255, 0, 255}));
  connect(UPu, modeHandling.UPu) annotation(
    Line(points = {{-168, -2}, {-110, -2}, {-110, 22}, {-82, 22}}, color = {0, 0, 127}));
  connect(UPu, division1.u2) annotation(
    Line(points = {{-168, -2}, {-110, -2}, {-110, -38}, {-70, -38}}, color = {0, 0, 127}));
  connect(UPu, regulation.UPu) annotation(
    Line(points = {{-168, -2}, {8, -2}, {8, -1}}, color = {0, 0, 127}));
  connect(QInjPu, PuConversion.u) annotation(
    Line(points = {{-168, -68}, {-140, -68}}, color = {0, 0, 127}));
  connect(PuConversion.y, regulation.QPu) annotation(
    Line(points = {{-117, -68}, {-99, -68}, {-99, -12}, {8, -12}}, color = {0, 0, 127}));
  connect(division1.y, regulation.IPu) annotation(
    Line(points = {{-47, -32}, {-15.5, -32}, {-15.5, -20}, {8, -20}}, color = {0, 0, 127}));
  connect(PuConversion.y, division1.u1) annotation(
    Line(points = {{-117, -68}, {-99, -68}, {-99, -26}, {-70, -26}}, color = {0, 0, 127}));
  annotation(
    Diagram,
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-33, 34}, extent = {{-59, 22}, {129, -88}}, textString = "SVarC Control"), Text(origin = {144, 60}, extent = {{-32, 12}, {4, -4}}, textString = "BPu"), Text(origin = {146, -38}, extent = {{-32, 12}, {4, -4}}, textString = "GPu")}));

end SVarCControl;
