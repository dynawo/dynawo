within Dynawo.Electrical.Photovoltaics.WECC.BaseClasses;

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

partial model BasePVVoltageSourceC "Base model for WECC PV with a voltage source as interface with the grid (REGC-C)"

  /*                uSourcePu                                uInjPu                      uPu
       --------         |                                       |                         |
      | Source |--------+---->>--------RSourcePu+jXSourcePu-----+------RPu+jXPu-----<<----+---- terminal
       --------           iSourcePu                                                 iPu
  */
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGCc;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsVSourceRef;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-79, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REGC.REGCc wecc_regc(DerIqrMaxPu = 20, DerIqrMinPu = -20, IMaxPu = IMaxPu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, Kii = Kii, Kip = Kip, QInj0Pu = QInj0Pu, RSourcePu = RSourcePu, RateFlag = RateFlag, RrpwrPu = RrpwrPu, SNom = SNom, UInj0Pu = UInj0Pu, UdInj0Pu = UdInj0Pu, UqInj0Pu = UqInj0Pu, XSourcePu = XSourcePu, iInj0Pu = -i0Pu, tE = tE, tFilterGC = tFilterGC, uInj0Pu = uInj0Pu, uSource0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-185, 38}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorURI injector(i0Pu = i0Pu, u0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements1(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line source(BPu = 0, GPu = 0, RPu = RSourcePu * SystemBase.SnRef / SNom, XPu = XSourcePu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters given by the user
  parameter Types.PerUnit P0Pu "Start value of active power at terminal in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at terminal in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at terminal in pu (base UNom)";

  // Initial parameters calculated by the initialization model
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage at injector in pu (base UNom)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage at injector in pu (base UNom)";
  parameter Types.ComplexPerUnit uSource0Pu "Start value of complex voltage at source in pu (base UNom)";

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
    Line(points = {{51.5, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(source.terminal2, measurements1.terminal1) annotation(
    Line(points = {{80, 0}, {90, 0}}, color = {0, 0, 255}));
  connect(wecc_regc.urSource, injector.urPu) annotation(
    Line(points = {{-29, 4}, {29, 4}}, color = {0, 0, 127}));
  connect(wecc_regc.uiSource, injector.uiPu) annotation(
    Line(points = {{-29, -4}, {29, -4}}, color = {0, 0, 127}));
  connect(measurements1.iPu, wecc_regc.iInjPu) annotation(
    Line(points = {{106, -11}, {106, -24}, {-40, -24}, {-40, -11}}, color = {85, 170, 255}));
  connect(measurements1.uPu, wecc_regc.uInjPu) annotation(
    Line(points = {{102, -11}, {102, -20}, {-32, -20}, {-32, -11}}, color = {85, 170, 255}));
  connect(measurements1.uPu, pll.uPu) annotation(
    Line(points = {{102, -11}, {101, -11}, {101, 60}, {-180, 60}, {-180, 50}, {-171, 50}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {180, 60}})));
end BasePVVoltageSourceC;
