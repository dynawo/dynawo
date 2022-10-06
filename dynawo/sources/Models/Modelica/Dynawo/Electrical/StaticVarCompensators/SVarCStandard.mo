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
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.Sources.InjectorBG;
  import Dynawo.Electrical.SystemBase;

  extends AdditionalIcons.SVarC;
  extends BaseControls.Parameters.Params_Regulation;
  extends BaseControls.Parameters.Params_Limitations;
  extends BaseControls.Parameters.Params_CalculBG;
  extends BaseControls.Parameters.Params_ModeHandling;
  extends BaseControls.Parameters.Params_BlockingFunction;
  parameter Types.VoltageModule UNom "Static var compensator nominal voltage in kV";
  final parameter Types.VoltageModule UThresholdUpPu =  UThresholdUp / UNom;
  final parameter Types.VoltageModule UThresholdDownPu =  UThresholdDown / UNom;
  final parameter Types.VoltageModule UBlockPu  = UBlock / UNom;
  final parameter Types.VoltageModule UUnblockUpPu  = UUnblockUp / UNom;
  final parameter Types.VoltageModule UUnblockDownPu = UUnblockDown / UNom;

  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the static var compensator to the grid" annotation(
    Placement(visible = true, transformation(origin = {228, -18}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {115, -1}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput URef(start = URef0) "Voltage reference for the regulation in kV" annotation(
    Placement(visible = true, transformation(origin = {-200, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, 85}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput selectModeAuto(start = selectModeAuto0) "Whether the static var compensator is in automatic configuration" annotation(
    Placement(visible = true, transformation(origin = {-200, 82}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, 1}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerInput setModeManual(start = setModeManual0) "Mode selected when in manual configuration" annotation(
    Placement(visible = true, transformation(origin = {-200, 110}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, -79}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  InjectorBG injector(SNom = SNom, U0Pu = U0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, u0Pu = u0Pu, s0Pu = s0Pu, i0Pu = i0Pu) "Controlled injector BG"  annotation(
    Placement(visible = true, transformation(origin = {136, -18}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant GPuCst(k = G0Pu)  annotation(
    Placement(visible = true, transformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  BaseControls.Regulation regulation(BMaxPu = BMaxPu, BMinPu = BMinPu, BVar0Pu = BVar0Pu, IMaxPu = IMaxPu, IMinPu = IMinPu, KCurrentLimiter = KCurrentLimiter, Kp = Kp, Lambda = Lambda, SNom = SNom, Ti = Ti)  annotation(
    Placement(visible = true, transformation(origin = {-2, -4}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {-90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain PuConversion(k = SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {-160, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  BaseControls.ModeHandling modeHandling(Mode0 = Mode0, UNom = UNom, URefDown = URefDown, URefUp = URefUp, UThresholdDown = UThresholdDown, UThresholdUp = UThresholdUp, tThresholdDown = tThresholdDown, tThresholdUp = tThresholdUp, URef0 = URef0)  annotation(
    Placement(visible = true, transformation(origin = {-91, 77}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  BaseControls.CalculBG calculBG(BShuntPu = BShuntPu)  annotation(
    Placement(visible = true, transformation(origin = {66, -16}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  BaseControls.BlockingFunction blockingFunction(UBlock = UBlock, UNom = UNom, UUnblockDown = UUnblockDown, UUnblockUp = UUnblockUp)  annotation(
    Placement(visible = true, transformation(origin = {-91, 27}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));

  parameter Types.PerUnit G0Pu "Start value of the conductance in pu (base SNom)";
  parameter Types.PerUnit B0Pu "Start value of the susceptance in pu (base SNom)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of apparent power at injector terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.VoltageModule URef0 "Start value of voltage reference in kV";
  final parameter Types.PerUnit BVar0Pu = B0Pu - BShuntPu "Start value of variable susceptance in pu";
  parameter BaseControls.Mode Mode0 "Start value for mode";
  parameter Boolean selectModeAuto0 = true "Start value of the boolean indicating whether the SVarC is initially in automatic configuration";
  final parameter Integer setModeManual0 = Integer(Mode0) "Start value of the mode when in manual configuration";

equation
  connect(modeHandling.mode, calculBG.mode) annotation(
    Line(points = {{-70, 77}, {77.9, 77}, {77.9, 3}}, color = {0, 0, 127}));
  connect(calculBG.GPu, injector.GPu) annotation(
    Line(points = {{85.26, -26.62}, {96.26, -26.62}, {96.26, -24.62}, {109.26, -24.62}, {109.26, -26.62}, {113.26, -26.62}}, color = {0, 0, 127}));
  connect(injector.terminal, terminal) annotation(
    Line(points = {{159, -30.2}, {192, -30.2}, {192, -18}, {228, -18}}, color = {0, 0, 255}));
  connect(regulation.BVarPu, calculBG.BVarPu) annotation(
    Line(points = {{17.8, -4}, {43.8, -4}, {43.8, -6}, {45.8, -6}}, color = {0, 0, 127}));
  connect(GPuCst.y, calculBG.GCstPu) annotation(
    Line(points = {{11, -40}, {19, -40}, {19, -40}, {27, -40}, {27, -26}, {36, -26}, {36, -26}, {45, -26}}, color = {0, 0, 127}));
  connect(calculBG.BPu, injector.BPu) annotation(
    Line(points = {{85.26, -5.38}, {99.26, -5.38}, {99.26, -5.38}, {111.26, -5.38}, {111.26, -5.38}, {112.26, -5.38}, {112.26, -5.38}, {113.26, -5.38}}, color = {0, 0, 127}));
  connect(modeHandling.URefPu, regulation.URefPu) annotation(
    Line(points = {{-70, 66}, {-47.1, 66}, {-47.1, 8}, {-23, 8}}, color = {0, 0, 127}));
  connect(selectModeAuto, modeHandling.selectModeAuto) annotation(
    Line(points = {{-200, 82}, {-114, 82}}, color = {255, 0, 255}));
  connect(setModeManual, modeHandling.setModeManual) annotation(
    Line(points = {{-200, 110}, {-157, 110}, {-157, 92}, {-114, 92}}, color = {255, 127, 0}));
  connect(injector.UPu, modeHandling.UPu) annotation(
    Line(points = {{159, -1.8}, {181, -1.8}, {181, -97.8}, {-193, -97.8}, {-193, 0.2}, {-143, 0.2}, {-143, 62}, {-114, 62}}, color = {0, 0, 127}));
  connect(PuConversion.y, division1.u1) annotation(
    Line(points = {{-149, -66}, {-131, -66}, {-131, -24}, {-102, -24}}, color = {0, 0, 127}));
  connect(PuConversion.y, regulation.QPu) annotation(
    Line(points = {{-149, -66}, {-131, -66}, {-131, -10}, {-24, -10}}, color = {0, 0, 127}));
  connect(injector.QInjPu, PuConversion.u) annotation(
    Line(points = {{159, -19}, {166, -19}, {166, -17}, {173, -17}, {173, -89}, {-183, -89}, {-183, -65}, {-173, -65}, {-173, -67}, {-173, -67}, {-173, -67}}, color = {0, 0, 127}));
  connect(division1.y, regulation.IPu) annotation(
    Line(points = {{-79, -30}, {-47.5, -30}, {-47.5, -18}, {-24, -18}}, color = {0, 0, 127}));
  connect(injector.UPu, division1.u2) annotation(
    Line(points = {{159, -1.8}, {170, -1.8}, {170, -1.8}, {181, -1.8}, {181, -97.8}, {-193, -97.8}, {-193, -35.8}, {-103, -35.8}, {-103, -35.8}, {-103, -35.8}, {-103, -35.8}}, color = {0, 0, 127}));
  connect(injector.UPu, regulation.UPu) annotation(
    Line(points = {{159, -1.8}, {170, -1.8}, {170, -1.8}, {181, -1.8}, {181, -97.8}, {-193, -97.8}, {-193, 0.2}, {-25, 0.2}, {-25, 0.2}, {-25, 0.2}, {-25, 0.2}}, color = {0, 0, 127}));
  connect(URef, modeHandling.URef) annotation(
    Line(points = {{-200, 48}, {-156, 48}, {-156, 70}, {-114, 70}, {-114, 70}}, color = {0, 0, 127}));
  connect(blockingFunction.blocked, regulation.blocked) annotation(
    Line(points = {{-70, 27}, {12, 27}, {12, 18}}, color = {255, 0, 255}));
  connect(injector.UPu, blockingFunction.UPu) annotation(
    Line(points = {{159, -1.8}, {181, -1.8}, {181, -97.8}, {-193, -97.8}, {-193, 0.2}, {-143, 0.2}, {-143, 28}, {-114, 28}, {-114, 28}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-120, -70}, {120, 70}})),
    Icon(coordinateSystem(grid = {1, 1})));
end SVarCStandard;
