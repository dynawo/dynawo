within Dynawo.Electrical.BESS.WECC.BaseClasses;

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

partial model BaseBESSCurrentSource "Partial base model for WECC BESS with electrical control model type C, generator/converter model type A"
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGCa;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary input in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {9.99201e-16, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

 
  Dynawo.Electrical.Controls.WECC.REGC.REGCa regcA(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, Lvplsw = Lvplsw, QInj0Pu = QInj0Pu, RrpwrPu = RrpwrPu, UInj0Pu = UInj0Pu, brkpt = brkpt, lvpl1 = lvpl1, tFilterGC = tFilterGC, tG = tG, zerox = zerox) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = -PInj0Pu * (SNom / SystemBase.SnRef), Q0Pu = -QInj0Pu * (SNom / SystemBase.SnRef), SNom = SNom, U0Pu = UInj0Pu, UPhase0 = UPhaseInj0, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-185, 38}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Lines.Line line(BPu = 0, GPu = 0, RPu = RPu, XPu = XPu) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters given by the user
  parameter Types.PerUnit P0Pu "Start value of active power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit SOC0Pu "Initial state of charge in pu (base SNom)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";

  // Initial parameters calculated by the initialization model
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.Angle UPhaseInj0 "Start value of voltage angle at injector";

equation
  line.switchOffSignal1.value = injector.switchOffSignal1.value;
  line.switchOffSignal2.value = injector.switchOffSignal2.value;

  connect(regcA.idRefPu, injector.idPu) annotation(
    Line(points = {{-29, -6}, {-11, -6}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-179, 38}, {-171, 38}}, color = {0, 0, 127}));
  connect(injector.uPu, pll.uPu) annotation(
    Line(points = {{12, 3}, {20, 3}, {20, 60}, {-180, 60}, {-180, 50}, {-171, 50}}, color = {85, 170, 255}));
  connect(injector.terminal, line.terminal2) annotation(
    Line(points = {{12, 8}, {30, 8}, {30, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{60, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{100, 0}, {130, 0}}, color = {0, 0, 255}));
  connect(pll.phi, injector.UPhase) annotation(
    Line(points = {{-149, 45}, {-146, 45}, {-146, -50}, {0, -50}, {0, -11}}, color = {0, 0, 127}));
  connect(regcA.UPu, injector.UPu) annotation(
    Line(points = {{-46, -11}, {-46, -20}, {20, -20}, {20, -8}, {12, -8}}, color = {0, 0, 127}));
  connect(regcA.iqRefPu, injector.iqPu) annotation(
    Line(points = {{-29, 4}, {-11, 4}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC BESS")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end BaseBESSCurrentSource;
