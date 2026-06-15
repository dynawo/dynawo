within Dynawo.Electrical.Photovoltaics.WECC;
model PVVoltageSource1NoPlantControl "WECC PV model with a voltage source as interface with the grid (REEC-A REGC-B)"
  /*           uSourcePu                                uInjPu                   uConvPu
  --------         |                                       |                         |
  | Source |--------+---->>--------RSourcePu+jXSourcePu-----+--->>---RPu+jXPu----->>----+----
  --------           iSourcePu                               iInjPu              iConvPu
  */
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECa(omegaRefWTGQPu0 = 1);
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsLvTfo;
  extends Dynawo.Electrical.Photovoltaics.WECC.BaseClasses.BasePVVoltageSourceB(LvTfo(RPu = RPu, XPu = XPu));

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PConvRefPu(start = PConv0Pu) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QConvRefPu(start = QConv0Pu) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Controls.WECC.REEC.REECa wecc_reec(
    DPMaxPu = DPMaxPu,
    DPMinPu = DPMinPu,
    Dbd1Pu = Dbd1Pu,
    Dbd2Pu = Dbd2Pu,
    IMaxPu = IMaxPu,
    Id0Pu = Id0Pu,
    Iq0Pu = Iq0Pu,
    IqFrzPu = IqFrzPu,
    Iqh1Pu = Iqh1Pu,
    Iql1Pu = Iql1Pu,
    Kqi = Kqi,
    Kqp = Kqp,
    Kqv = Kqv,
    Kvi = Kvi,
    Kvp = Kvp,
    PF0 = PF0,
    PFlag = PFlag,
    PMaxREECPu = PMaxREECPu,
    PMinREECPu = PMinREECPu,
    PQFlag = PQFlag,
    PfFlag = PfFlag,
    QFlag = QFlag,
    QMaxREECPu = QMaxREECPu,
    QMinREECPu = QMinREECPu,
    UInj0Pu = UInj0Pu,
    VDLIp11 = VDLIp11,
    VDLIp12 = VDLIp12,
    VDLIp21 = VDLIp21,
    VDLIp22 = VDLIp22,
    VDLIp31 = VDLIp31,
    VDLIp32 = VDLIp32,
    VDLIp41 = VDLIp41,
    VDLIp42 = VDLIp42,
    VDLIq11 = VDLIq11,
    VDLIq12 = VDLIq12,
    VDLIq21 = VDLIq21,
    VDLIq22 = VDLIq22,
    VDLIq31 = VDLIq31,
    VDLIq32 = VDLIq32,
    VDLIq41 = VDLIq41,
    VDLIq42 = VDLIq42,
    VDipPu = VDipPu,
    VFlag = VFlag,
    VMaxPu = VMaxPu,
    VMinPu = VMinPu,
    VRef0Pu = VRef0Pu,
    VRef1Pu = VRef1Pu,
    VUpPu = VUpPu,
    tHoldIpMax = tHoldIpMax,
    tHoldIq = tHoldIq,
    tIq = tIq,
    tpREEC = tpREEC,
    tPord = tPord,
    tRv = tRv,
    SNom = SNom,
    PConv0Pu = PConv0Pu,
    QConv0Pu = QConv0Pu,
    s0Pu = s0Pu,
    u0Pu = u0Pu,
    uConv0Pu = uConv0Pu,
    UConv0Pu = UConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaGPu(k = 1) annotation(
    Placement(transformation(origin = {-105, -40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

equation
  connect(QConvRefPu, wecc_reec.QConvRefPu) annotation(
    Line(points = {{-130, -20}, {-100, -20}, {-100, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(PConvRefPu, wecc_reec.PConvRefPu) annotation(
    Line(points = {{-130, 20}, {-100, 20}, {-100, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(PFaRef, wecc_reec.PFaRef) annotation(
    Line(points = {{-190, 60}, {-79, 60}, {-79, 11}}, color = {0, 0, 127}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{-69, 6}, {-61, 6}}, color = {0, 0, 127}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-61, -6}}, color = {0, 0, 127}));
  connect(LvMeasurements.UPu, wecc_regc.UPu) annotation(
    Line(points = {{60, -6}, {60, -17}, {-56, -17}, {-56, -11}}, color = {0, 0, 127}));
  connect(LvMeasurements.PPu, wecc_reec.PConvPu) annotation(
    Line(points = {{62, -6}, {62, -20}, {-80, -20}, {-80, -11}}, color = {0, 0, 127}));
  connect(LvMeasurements.QPu, wecc_reec.QConvPu) annotation(
    Line(points = {{64, -6}, {64, -24}, {-89, -24}, {-89, -11}}, color = {0, 0, 127}));
  connect(LvMeasurements.terminal2, terminal) annotation(
    Line(points = {{70, 0}, {130, 0}}, color = {0, 0, 255}));
  connect(pll.phi, wecc_regc.phi) annotation(
    Line(points = {{-149, 45}, {-65, 45}, {-65, 9}, {-61, 9}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{-69, 0}, {-61, 0}}, color = {255, 0, 255}));
  connect(LvMeasurements.UPu, wecc_reec.UPu) annotation(
    Line(points = {{60, -6}, {60, -17}, {-74, -17}, {-74, -11}}, color = {0, 0, 127}));
  connect(SourceMeasurements.uPu, wecc_regc.uInjPu) annotation(
    Line(points = {{26, -5}, {26, -14}, {-46, -14}, {-46, -11}}, color = {85, 170, 255}));
  connect(omegaGPu.y, wecc_reec.omegaGPu) annotation(
    Line(points = {{-100, -40}, {-85, -40}, {-85, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}),
    Diagram(coordinateSystem(extent = {{-180, -60}, {120, 60}})));
end PVVoltageSource1NoPlantControl;
