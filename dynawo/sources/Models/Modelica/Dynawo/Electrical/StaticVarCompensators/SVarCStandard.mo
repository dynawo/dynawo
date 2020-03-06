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

  extends BaseControls.Parameters.Params_Regulation;
  extends BaseControls.Parameters.Params_Limitations;
  extends BaseControls.Parameters.Params_CalculBG;
  extends BaseControls.Parameters.Params_ModeHandling;

  Modelica.Blocks.Interfaces.RealInput URef(start = URef0) "Voltage reference for the regulation in kV" annotation(
    Placement(visible = true, transformation(origin = {-200, 28}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, 85}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  Modelica.Blocks.Interfaces.BooleanInput selectModeAuto(start = selectModeAuto0) "Wheter the static var compensator is in automatic configuration" annotation(
    Placement(visible = true, transformation(origin = {-200, 56}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, 1}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerInput setModeManual(start = setModeManual0) "Mode selected when in manual configuration" annotation(
    Placement(visible = true, transformation(origin = {-200, 86}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, -79}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the static var compensator to the grid" annotation(
    Placement(visible = true, transformation(origin = {228, -18}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {115, -1}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

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
  BaseControls.ModeHandling modeHandling(Mode0 = Mode0, UBlock = UBlock, UUnblockDown = UUnblockDown, UUnblockUp = UUnblockUp, UNom = UNom, URefDown = URefDown, URefUp = URefUp, UThresholdDown = UThresholdDown, UThresholdUp = UThresholdUp, tThresholdDown = tThresholdDown, tThresholdUp = tThresholdUp, URef0 = URef0)  annotation(
    Placement(visible = true, transformation(origin = {-91, 39}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  BaseControls.CalculBG calculBG(BShuntPu = BShuntPu)  annotation(
    Placement(visible = true, transformation(origin = {66, -16}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));

protected

  parameter Types.PerUnit G0Pu "Start value of the conductance in p.u (base SNom)";
  parameter Types.PerUnit B0Pu "Start value of the susceptance in p.u (base SNom)";
  parameter Types.VoltageModulePu U0Pu  "Start value of voltage amplitude at injector terminal in p.u (base UNom)";
  parameter Types.ActivePowerPu P0Pu  "Start value of active power in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu  "Start value of reactive power in p.u (base SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u0Pu  "Start value of complex voltage at injector terminal in p.u (base UNom)";
  parameter Types.ComplexApparentPowerPu s0Pu  "Start value of apparent power at injector terminal in p.u (base SnRef) (receptor convention)";
  parameter Types.ComplexCurrentPu i0Pu  "Start value of complex current at injector terminal in p.u (base UNom, SnRef) (receptor convention)";
  parameter Types.VoltageModule URef0  "Start value of voltage reference in kV";
  final parameter Types.PerUnit BVar0Pu = B0Pu - BShuntPu "Start value of variable susceptance in p.u";
  parameter BaseControls.Mode Mode0 "Start value for mode";
  parameter Boolean selectModeAuto0 = true "Start value of the boolean indicating whether the SVarC is initially in automatic configuration";
  parameter Integer setModeManual0 = 2 "Start value of the mode when in manual configuration";
equation
  connect(modeHandling.mode, calculBG.mode) annotation(
    Line(points = {{-70.1, 39}, {77.9, 39}, {77.9, 3}}, color = {0, 0, 127}));
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
  connect(modeHandling.blocked, regulation.blocked) annotation(
    Line(points = {{-70.1, 50.4}, {-29.05, 50.4}, {-29.05, 50.4}, {12, 50.4}, {12, 34.2}, {12, 34.2}, {12, 18}}, color = {255, 0, 255}));
  connect(modeHandling.URefPu, regulation.URefPu) annotation(
    Line(points = {{-70.1, 27.6}, {-58.6, 27.6}, {-58.6, 27.6}, {-47.1, 27.6}, {-47.1, 8}, {-23, 8}}, color = {0, 0, 127}));
  connect(URef, modeHandling.URef) annotation(
    Line(points = {{-200, 28}, {-158, 28}, {-158, 34}, {-114, 34}, {-114, 32}}, color = {0, 0, 127}));
  connect(selectModeAuto, modeHandling.selectModeAuto) annotation(
    Line(points = {{-200, 56}, {-179.5, 56}, {-179.5, 56}, {-157, 56}, {-157, 44}, {-135.5, 44}, {-135.5, 44}, {-114, 44}}, color = {255, 0, 255}));
  connect(setModeManual, modeHandling.setModeManual) annotation(
    Line(points = {{-200, 86}, {-142, 86}, {-142, 54}, {-128, 54}, {-128, 54}, {-114, 54}}, color = {255, 127, 0}));
  connect(injector.UPu, modeHandling.UPu) annotation(
    Line(points = {{159, -1.8}, {170, -1.8}, {170, -1.8}, {181, -1.8}, {181, -97.8}, {-193, -97.8}, {-193, 0.2}, {-143, 0.2}, {-143, 24.2}, {-129, 24.2}, {-129, 24.2}, {-115, 24.2}}, color = {0, 0, 127}));
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
  annotation(preferredView = "diagram",
    Diagram,
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-33, 34}, extent = {{-59, 22}, {129, -88}}, textString = "SVarC Control")}));

end SVarCStandard;
