within Dynawo.Electrical.Photovoltaics.WECC.BaseClasses;

partial model BasePVVoltageSourceA "Base model for WECC PV with a voltage source as interface with the grid (REGC-B)"
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
  /*                uSourcePu                                uInjPu                      uPu
         --------         |                                       |                         |
        | Source |--------+---->>--------RSourcePu+jXSourcePu-----+------RPu+jXPu-----<<----+---- terminal
         --------           iSourcePu                                                 iPu
  */
  extends Electrical.Controls.PLL.ParamsPLL;
  extends Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;
  extends Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;
  extends Electrical.Controls.WECC.Parameters.REGC.ParamsREGCa;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsVSourceRef;
  
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef)";
  // Input variables
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-79, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));
  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Electrical.Controls.WECC.REGC.REGCa wecc_regc(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, QInj0Pu = QInj0Pu, RrpwrPu = RrpwrPu, UInj0Pu = UInj0Pu, tFilterGC = tFilterGC, tG = tG, brkpt = brkpt, lvpl1 = lvpl1, Lvplsw = Lvplsw, zerox = zerox) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-185, 38}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Sources.InjectorIDQ injector(i0Pu = i0Pu, SNom = SNom, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, s0Pu = s0Pu, U0Pu = UInj0Pu, UPhase0 = UPhaseInj0, u0Pu = uInj0Pu) annotation(
    Placement(transformation(origin = {40, 0}, extent = {{-10, 10}, {10, -10}}, rotation = -0)));
  Electrical.Controls.WECC.Utilities.Measurements measurements1(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Electrical.Lines.Line source(BPu = 0, GPu = 0, RPu = RSourcePu*SystemBase.SnRef/SNom, XPu = XSourcePu*SystemBase.SnRef/SNom) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  // Initial parameters given by the user
  parameter Types.PerUnit P0Pu "Start value of active power at terminal in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at terminal in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at terminal in pu (base UNom)";
  // Initial parameters calculated by the initialization model
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit iInj0Pu "Start value of complex current at injector in pu (base UNom, SNom) (generator convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  // Initial parameters
  parameter Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at regulated bus in rad";
  parameter Types.Angle UPhaseInj0 "Start value of voltage angle at injector in rad";

equation
  line.switchOffSignal1.value = injector.switchOffSignal1.value;
  source.switchOffSignal1.value = injector.switchOffSignal1.value;
  line.switchOffSignal2.value = injector.switchOffSignal2.value;
  source.switchOffSignal2.value = injector.switchOffSignal2.value;
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-180, 38}, {-171, 38}}, color = {0, 0, 127}));
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{140, 0}, {150, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{170, 0}, {190, 0}}, color = {0, 0, 255}));
  connect(measurements1.terminal2, line.terminal2) annotation(
    Line(points = {{110, 0}, {120, 0}}, color = {0, 0, 255}));
  connect(measurements1.UPu, wecc_regc.UPu) annotation(
    Line(points = {{90, -11}, {90, -30}, {-46, -30}, {-46, -11}}, color = {0, 0, 127}));
  connect(injector.terminal, source.terminal1) annotation(
    Line(points = {{51.5, 8}, {55.75, 8}, {55.75, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(source.terminal2, measurements1.terminal1) annotation(
    Line(points = {{80, 0}, {90, 0}}, color = {0, 0, 255}));
  connect(wecc_regc.iqRefPu, injector.iqPu) annotation(
    Line(points = {{-29, 4}, {28.5, 4}}, color = {0, 0, 127}));
  connect(wecc_regc.idRefPu, injector.idPu) annotation(
    Line(points = {{-29, -4}, {-28.75, -4}, {-28.75, -6}, {28.5, -6}}, color = {0, 0, 127}));
  connect(measurements1.uPu, pll.uPu) annotation(
    Line(points = {{102, -11}, {103, -11}, {103, 60}, {-180, 60}, {-180, 50}, {-171, 50}}, color = {85, 170, 255}));
  connect(pll.phi, injector.UPhase) annotation(
    Line(points = {{-149, 45}, {-141, 45}, {-141, -46}, {40, -46}, {40, -11}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {180, 60}})));
end BasePVVoltageSourceA;
