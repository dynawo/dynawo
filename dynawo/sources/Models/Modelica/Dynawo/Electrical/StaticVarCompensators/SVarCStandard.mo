within Dynawo.Electrical.StaticVarCompensators;

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

model SVarCStandard "Standard static var compensator model"
  import Modelica;
  import Dynawo;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;

  extends AdditionalIcons.SVarC;
  extends BaseControls.Parameters.ParamsBlockingFunction;
  extends BaseControls.Parameters.ParamsCalculationBG;
  extends BaseControls.Parameters.ParamsLimitations;
  extends BaseControls.Parameters.ParamsModeHandling;
  extends BaseControls.Parameters.ParamsRegulation;

  parameter Types.VoltageModule UNom "Static var compensator nominal voltage in kV";

  final parameter Types.VoltageModule UBlockPu = UBlock / UNom;
  final parameter Types.VoltageModule UThresholdDownPu = UThresholdDown / UNom;
  final parameter Types.VoltageModule UThresholdUpPu = UThresholdUp / UNom;
  final parameter Types.VoltageModule UUnblockDownPu = UUnblockDown / UNom;
  final parameter Types.VoltageModule UUnblockUpPu = UUnblockUp / UNom;

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the static var compensator to the grid" annotation(
    Placement(visible = true, transformation(origin = {240, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {115, -1}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  Modelica.Blocks.Interfaces.BooleanInput selectModeAuto(start = SelectModeAuto0) "Whether the static var compensator is in automatic configuration" annotation(
    Placement(visible = true, transformation(origin = {-260, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, 1}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerInput setModeManual(start = SetModeManual0) "Mode selected when in manual configuration" annotation(
    Placement(visible = true, transformation(origin = {-260, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, -79}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URef(start = URef0) "Voltage reference for the regulation in kV" annotation(
    Placement(visible = true, transformation(origin = {-260, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, 85}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  Dynawo.Electrical.Sources.InjectorBG injector(SNom = SNom, U0Pu = U0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, u0Pu = u0Pu, s0Pu = s0Pu, i0Pu = i0Pu) "Controlled injector BG" annotation(
    Placement(visible = true, transformation(origin = {140, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant GPuCst(k = G0Pu) annotation(
    Placement(visible = true, transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.StaticVarCompensators.BaseControls.Regulation regulation(BMaxPu = BMaxPu, BMinPu = BMinPu, BVar0Pu = BVar0Pu, IMaxPu = IMaxPu, IMinPu = IMinPu, KCurrentLimiter = KCurrentLimiter, Kp = Kp, Lambda = Lambda, SNom = SNom, Ti = Ti) annotation(
    Placement(visible = true, transformation(origin = {-20, -4}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {-90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain PuConversion(k = SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.StaticVarCompensators.BaseControls.ModeHandling modeHandling(Mode0 = Mode0, UNom = UNom, URefDown = URefDown, URefUp = URefUp, UThresholdDown = UThresholdDown, UThresholdUp = UThresholdUp, tThresholdDown = tThresholdDown, tThresholdUp = tThresholdUp, URef0 = URef0) annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.StaticVarCompensators.BaseControls.CalculationBG calculationBG(BShuntPu = BShuntPu) annotation(
    Placement(visible = true, transformation(origin = {60, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.StaticVarCompensators.BaseControls.BlockingFunction blockingFunction(UBlock = UBlock, UNom = UNom, UUnblockDown = UUnblockDown, UUnblockUp = UUnblockUp) annotation(
    Placement(visible = true, transformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  parameter Types.PerUnit B0Pu "Start value of the susceptance in pu (base UNom, SNom)";
  parameter Types.PerUnit G0Pu "Start value of the conductance in pu (base UNom, SNom)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter BaseControls.Mode Mode0 "Start value for mode";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of apparent power at injector terminal in pu (base SnRef) (receptor convention)";
  parameter Boolean SelectModeAuto0 = true "If true, the SVarC is initially in automatic configuration";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)";
  parameter Types.VoltageModule URef0 "Start value of voltage reference in kV";

  final parameter Types.PerUnit BVar0Pu = B0Pu - BShuntPu "Start value of variable susceptance in pu (base UNom, SNom)";
  final parameter Integer SetModeManual0 = Integer(Mode0) "Start value of the mode when in manual configuration";

equation
  connect(modeHandling.mode, calculationBG.mode) annotation(
    Line(points = {{-98, 80}, {74, 80}, {74, 2}}, color = {0, 0, 127}));
  connect(calculationBG.GPu, injector.GPu) annotation(
    Line(points = {{81, -32}, {100, -32}, {100, -28}, {117, -28}}, color = {0, 0, 127}));
  connect(injector.terminal, terminal) annotation(
    Line(points = {{163, -32}, {240, -32}}, color = {0, 0, 255}));
  connect(regulation.BVarPu, calculationBG.BVarPu) annotation(
    Line(points = {{2, -4}, {20, -4}, {20, -8}, {38, -8}}, color = {0, 0, 127}));
  connect(GPuCst.y, calculationBG.GCstPu) annotation(
    Line(points = {{1, -60}, {20, -60}, {20, -32}, {38, -32}}, color = {0, 0, 127}));
  connect(calculationBG.BPu, injector.BPu) annotation(
    Line(points = {{81, -8}, {117, -8}}, color = {0, 0, 127}));
  connect(modeHandling.URefPu, regulation.URefPu) annotation(
    Line(points = {{-98, 68}, {-60, 68}, {-60, 9}, {-43, 9}}, color = {0, 0, 127}));
  connect(selectModeAuto, modeHandling.selectModeAuto) annotation(
    Line(points = {{-260, 60}, {-200, 60}, {-200, 86}, {-144, 86}}, color = {255, 0, 255}));
  connect(setModeManual, modeHandling.setModeManual) annotation(
    Line(points = {{-260, 100}, {-200, 100}, {-200, 96}, {-144, 96}}, color = {255, 127, 0}));
  connect(injector.UPu, modeHandling.UPu) annotation(
    Line(points = {{163, -4}, {200, -4}, {200, -100}, {-193, -100}, {-193, 0}, {-160, 0}, {-160, 64}, {-144, 64}}, color = {0, 0, 127}));
  connect(PuConversion.y, division1.u1) annotation(
    Line(points = {{-139, -60}, {-120, -60}, {-120, -24}, {-102, -24}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(PuConversion.y, regulation.QPu) annotation(
    Line(points = {{-139, -60}, {-120, -60}, {-120, -10}, {-43, -10}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(injector.QInjPu, PuConversion.u) annotation(
    Line(points = {{163, -21}, {180, -21}, {180, -80}, {-180, -80}, {-180, -60}, {-162, -60}}, color = {0, 0, 127}));
  connect(division1.y, regulation.IPu) annotation(
    Line(points = {{-79, -30}, {-60, -30}, {-60, -20}, {-43, -20}}, color = {0, 0, 127}));
  connect(injector.UPu, division1.u2) annotation(
    Line(points = {{163, -4}, {200, -4}, {200, -100}, {-193, -100}, {-193, -35.8}, {-103, -35.8}}, color = {0, 0, 127}));
  connect(injector.UPu, regulation.UPu) annotation(
    Line(points = {{163, -4}, {200, -4}, {200, -100}, {-193, -100}, {-193, 0}, {-43, 0}}, color = {0, 0, 127}));
  connect(URef, modeHandling.URef) annotation(
    Line(points = {{-260, 20}, {-180, 20}, {-180, 74}, {-144, 74}}, color = {0, 0, 127}));
  connect(blockingFunction.blocked, regulation.blocked) annotation(
    Line(points = {{-98, 30}, {-4, 30}, {-4, 20}}, color = {255, 0, 255}));
  connect(injector.UPu, blockingFunction.UPu) annotation(
    Line(points = {{163, -4}, {200, -4}, {200, -100}, {-193, -100}, {-193, 0}, {-160, 0}, {-160, 30}, {-144, 30}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-240, -120}, {240, 120}})));
end SVarCStandard;
