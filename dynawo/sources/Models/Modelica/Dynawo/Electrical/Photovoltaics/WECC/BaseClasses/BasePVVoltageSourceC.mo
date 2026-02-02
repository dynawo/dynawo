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
  /*           uSourcePu                                uInjPu                   uConvPu                        uPu
  --------         |                                       |                         |                           |
  | Source |--------+---->>--------RSourcePu+jXSourcePu-----+--->>---RPu+jXPu----->>----+----RPcsPu+jXPcsPu-----<<----+--
  --------           iSourcePu                               iInjPu              iConvPu                      iConvPu
  */
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGCc;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsVSourceRef;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-79, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));
  Dynawo.Electrical.Controls.WECC.REGC.REGCc wecc_regc(
    IMaxPu = IMaxPu,
    Id0Pu = Id0Pu,
    Iq0Pu = Iq0Pu,
    IqrMaxPu = IqrMaxPu,
    IqrMinPu = IqrMinPu,
    Kii = Kii,
    Kip = Kip,
    RSourcePu = RSourcePu,
    RateFlag = RateFlag,
    RrpwrPu = RrpwrPu,
    SNom = SNom,
    UInj0Pu = UInj0Pu,
    UdInj0Pu = UdInj0Pu,
    UqInj0Pu = UqInj0Pu,
    XSourcePu = XSourcePu,
    tE = tE,
    tFilterGC = tFilterGC,
    uInj0Pu = uInj0Pu,
    uSource0Pu = uSource0Pu,
    QConv0Pu = QConv0Pu,
    uConv0Pu = uConv0Pu,
    UConv0Pu = UConv0Pu,
    frtOn(start = false),
    iConv0Pu = iConv0Pu,
    UPhaseConv0 = UPhaseConv0) annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-185, 38}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(
    Ki = KiPLL,
    Kp = KpPLL,
    OmegaMaxPu = OmegaMaxPu,
    OmegaMinPu = OmegaMinPu,
    u0Pu = uConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorURI injector(
    i0Pu = -iSource0Pu*(SNom/SystemBase.SnRef),
    u0Pu = uSource0Pu) annotation(
    Placement(transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.Line source(
    BPu = 0,
    GPu = 0,
    RPu = RSourcePu*SystemBase.SnRef/SNom,
    XPu = XSourcePu*SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Sources.IEC.BaseConverters.ElecSystem LvTfo(
    SNom = SNom,
    i20Pu = iConv0Pu,
    u20Pu = uConv0Pu) annotation(
    Placement(transformation(origin = {45, 0}, extent = {{-5, -5}, {5, 5}})));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements LvMeasurements(SNom = SNom) annotation(
    Placement(transformation(origin = {65, -8.88178e-16}, extent = {{-5, 5}, {5, -5}})));

  // Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit iConv0Pu "Start value of complex current at converter terminal in pu (base UNom, SNom) (generator convention)";
  parameter Types.ComplexPerUnit iSource0Pu "Start value of complex current at source in pu (base UNom, SNom) (generator convention)";
  parameter Types.ActivePowerPu PConv0Pu "Start value of active power at converter terminal in pu (generator convention) (base SNom)";
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.ReactivePowerPu QConv0Pu "Start value of reactive power at converter terminal in pu (generator convention) (base SNom)";
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit uConv0Pu "Start value of complex voltage at converter terminal in pu (base UNom)";
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage at injector in pu (base UNom)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at regulated bus in rad";
parameter  Types.Angle UPhaseConv0 "Value of voltage phase angle at converter terminal in rad";
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage at injector in pu (base UNom)";
  parameter Types.ComplexPerUnit uSource0Pu "Start value of complex voltage at source in pu (base UNom)";
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements SourceMeasurements(SNom = SNom) annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-5, 5}, {5, -5}})));

equation
  source.switchOffSignal1.value = injector.switchOffSignal1.value;
  source.switchOffSignal2.value = injector.switchOffSignal2.value;
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-180, 38}, {-171, 38}}, color = {0, 0, 127}));
  connect(injector.terminal, source.terminal1) annotation(
    Line(points = {{-8.5, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(wecc_regc.urSource, injector.urPu) annotation(
    Line(points = {{-39, 4}, {-31, 4}}, color = {0, 0, 127}));
  connect(wecc_regc.uiSource, injector.uiPu) annotation(
    Line(points = {{-39, -4}, {-31, -4}}, color = {0, 0, 127}));
  connect(LvTfo.terminal2, LvMeasurements.terminal1) annotation(
    Line(points = {{50.5, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(SourceMeasurements.terminal2, LvTfo.terminal1) annotation(
    Line(points = {{35, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(source.terminal2, SourceMeasurements.terminal1) annotation(
    Line(points = {{20, 0}, {25, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(extent = {{-100, -100}, {130, 100}}, grid = {1, 1})),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -100}, {130, 100}})));
end BasePVVoltageSourceC;
