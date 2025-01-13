within Dynawo.Electrical.Controls.Converters.EpriGFM;

model EpriGFM
  extends Parameters.InitialTerminalUi;
  extends Parameters.SNom;
  extends Parameters.Circuit;
  extends Parameters.Gfm;
  extends Parameters.InitialGfm;
  extends Parameters.CurrentCtrl;
  extends Parameters.InitialCurrentCtrl;
  extends Parameters.VoltageCtrl;
  extends Parameters.InitialVoltageCtrl;
  extends Parameters.Pll;
  extends Parameters.Pref0Pu_;

  Dynawo.Electrical.Sources.InjectorURI injectorURI(i0Pu = i0Pu, u0Pu = u0Pu, uiPu(start = 0), urPu(start = 1)) annotation(
    Placement(visible = true, transformation(origin = {190, 30}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {340, 30}, extent = {{-19, 19}, {19, -19}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QAux(height = 0.2, offset = 0, startTime = 300) annotation(
    Placement(visible = true, transformation(origin = {-368, -122}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Sources.Step deltaOmega(height = 0, offset = 0) annotation(
    Placement(visible = true, transformation(origin = {-370, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step VRef(height = 0.001, offset = 1, startTime = 20) annotation(
    Placement(visible = true, transformation(origin = {-370, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRef(height = 0.1, offset = 0.5, startTime = 100) annotation(
    Placement(visible = true, transformation(origin = {-370, 170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {410, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Comptodq comptodq(Ki = Ki, Kp = Kp, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu, wflag = wflag) annotation(
    Placement(visible = true, transformation(origin = {120, -60}, extent = {{-23, -23}, {23, 23}}, rotation = 180)));
  Modelica.Blocks.Sources.Step QRef(height = 0.1, offset = 0, startTime = 50) annotation(
    Placement(visible = true, transformation(origin = {-370, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = BPu, GPu = GPu, RPu = RPu, XPu = XPu, state(start = Dynawo.Electrical.Constants.state.Closed)) annotation(
    Placement(visible = true, transformation(origin = {260, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.DQTrafo dQTrafo(wflag = wflag) annotation(
    Placement(visible = true, transformation(origin = {130, 30}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  EpriCurrentCtrl epriCurrentCtrl(IdConv0Pu = 0, IqConv0Pu = 0, Kii = Kii, Kpi = Kpi, LFilter = LFilter, Pref0Pu = Pref0Pu, RFilter = RFilter, tE = tE, UdConv0Pu = UdConv0Pu, UdFilter0Pu = 1, UqConv0Pu = UqConv0Pu, UqFilter0Pu = 0, idConvPu(start = 0), idConvRefPu(start = 0), udConvRefPu(start = 1), uqConvRefPu(start = 0.5 * 0.1)) annotation(
    Placement(visible = true, transformation(origin = {44, 28}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  EpriVoltageCtrl epriVoltageCtrl(CFilter = CFilter, IMaxPu = IMaxPu, IdConv0Pu = IdConv0Pu, IdPcc0Pu = IdPcc0Pu, IqConv0Pu = IqConv0Pu, IqPcc0Pu = IqPcc0Pu, Kip = Kip, Kiv = Kiv, Kpp = Kpp, Kpv = Kpv, PQflag = PQflag, QDroop = QDroop, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, VDipPu = VDipPu, wDroop = wDroop, wflag = wflag) annotation(
    Placement(visible = true, transformation(origin = {-99, 35}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  // EpriVoltageCtrl test annotation(
  // Placement(visible = true, transformation(origin = {58, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  GFM gfm(DeltaVVId0 = DeltaVVId0, DeltaVVIq0 = DeltaVVIq0, IdPcc0Pu = 0, IqPcc0Pu = 0, PFilter0Pu = PFilter0Pu, PFilterPu(start = 0), PRef0Pu = PRef0Pu, PRefPu(start = 0), PauxPu(start = 0), QFilter0Pu = QFilter0Pu, QFilterPu(start = 0), QRef0Pu = QRef0Pu, QRefPu(start = 0), QauxPu(start = 0), Theta0 = Theta0, UFilterRef0Pu = UFilterRef0Pu, UdFilter0Pu = 1, UqFilter0Pu = 0, VrefPu(start = 1), dd = dd, deltawmax = deltawmax, deltawmin = deltawmin, k1 = k1, k2 = k2, k2dvoc = k2dvoc, kd = kd, mf = mf, omegaPu(start = 1), tf = tf, theta(start = 0), tr = tr, tv = tv, udFilterRefPu(start = 1), wPLLPu(start = 1), wflag = wflag) annotation(
    Placement(visible = true, transformation(origin = {-250, 30}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PAux(height = 0.001, startTime = 70) annotation(
    Placement(visible = true, transformation(origin = {-368, -82}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));

equation
  injectorURI.switchOffSignal1.value = false;
  injectorURI.switchOffSignal2.value = false;
  injectorURI.switchOffSignal3.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  connect(injectorURI.terminal, line.terminal1) annotation(
    Line(points = {{207.25, 29.55}, {223.25, 29.55}, {223.25, 30}, {240, 30}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{359, 30}, {387, 30}, {387, 29}, {415, 29}}, color = {0, 0, 255}));
  connect(line.terminal2, measurements.terminal1) annotation(
    Line(points = {{280, 30}, {322, 30}, {322, 29}}, color = {0, 0, 255}));
  connect(dQTrafo.urSourcePu, injectorURI.urPu) annotation(
    Line(points = {{147.6, 36.4}, {158.6, 36.4}, {158.6, 35.4}, {170.1, 35.4}}, color = {0, 0, 127}));
  connect(dQTrafo.uiSourcePu, injectorURI.uiPu) annotation(
    Line(points = {{147.6, 23.76}, {158.6, 23.76}, {158.6, 22.76}, {169.6, 22.76}}, color = {0, 0, 127}));
  connect(deltaOmega.y, epriVoltageCtrl.deltaOmega) annotation(
    Line(points = {{-359, 110}, {-175.5, 110}, {-175.5, 12.5}, {-126.5, 12.5}}, color = {166, 187, 200}));
  connect(epriVoltageCtrl.iqConvRefPu, epriCurrentCtrl.iqConvRefPu) annotation(
    Line(points = {{-71.5, 20}, {-65, 20}, {-65, 44}, {15, 44}}, color = {0, 0, 127}));
  connect(comptodq.id, epriCurrentCtrl.idConvPu) annotation(
    Line(points = {{94.7, -46.2}, {-7.3, -46.2}, {-7.3, 36}, {15, 36}}, color = {23, 156, 125}, thickness = 0));
  connect(comptodq.iq, epriCurrentCtrl.iqConvPu) annotation(
    Line(points = {{94.7, -50.8}, {-9.3, -50.8}, {-9.3, 31}, {15, 31}}, color = {23, 156, 125}));
  connect(comptodq.ud, epriCurrentCtrl.udFilterPu) annotation(
    Line(points = {{94.7, -64.6}, {-23.3, -64.6}, {-23.3, 23}, {15, 23}}, color = {23, 156, 125}));
  connect(comptodq.ud, epriVoltageCtrl.vd) annotation(
    Line(points = {{94.7, -64.6}, {-143.3, -64.6}, {-143.3, 27.5}, {-126.5, 27.5}}, color = {23, 156, 125}));
  connect(comptodq.uq, epriCurrentCtrl.uqFilterPu) annotation(
    Line(points = {{94.7, -69.2}, {-21.3, -69.2}, {-21.3, 18}, {15, 18}}, color = {23, 156, 125}));
  connect(comptodq.uq, epriVoltageCtrl.vQConvPu) annotation(
    Line(points = {{94.7, -69.2}, {-149.3, -69.2}, {-149.3, 32.5}, {-126.5, 32.5}}, color = {23, 156, 125}));
  connect(epriVoltageCtrl.PRef, PRef.y) annotation(
    Line(points = {{-126.5, 57.5}, {-161.75, 57.5}, {-161.75, 170}, {-359, 170}}, color = {166, 187, 200}));
  connect(QRef.y, epriVoltageCtrl.QRef) annotation(
    Line(points = {{-359, 140}, {-168, 140}, {-168, 52.5}, {-126.5, 52.5}}, color = {166, 187, 200}));
  connect(VRef.y, gfm.VrefPu) annotation(
    Line(points = {{-359, 20}, {-325.5, 20}, {-325.5, 21}, {-275, 21}}, color = {166, 187, 200}));
  connect(gfm.udFilterRefPu, epriVoltageCtrl.VRef) annotation(
    Line(points = {{-224.7, 43.8}, {-190.45, 43.8}, {-190.45, 20}, {-126.5, 20}}, color = {0, 0, 127}));
  connect(gfm.omegaPu, epriCurrentCtrl.omegaPu) annotation(
    Line(points = {{-224.7, 16.2}, {-217.7, 16.2}, {-217.7, -3.8}, {12.3, -3.8}, {12.3, 10}, {15, 10}}, color = {0, 0, 127}));
  connect(epriVoltageCtrl.idConvRefPu, epriCurrentCtrl.idConvRefPu) annotation(
    Line(points = {{-71.5, 50}, {-25.25, 50}, {-25.25, 49}, {15, 49}}, color = {0, 0, 127}));
  connect(comptodq.omega, gfm.wPLLPu) annotation(
    Line(points = {{94.7, -41.6}, {-287.3, -41.6}, {-287.3, 15.4}, {-268.3, 15.4}}, color = {23, 156, 125}));
  connect(PAux.y, gfm.PauxPu) annotation(
    Line(points = {{-356, -82}, {-263.9, -82}, {-263.9, 1}}, color = {166, 187, 200}));
  connect(PAux.y, epriVoltageCtrl.PAux) annotation(
    Line(points = {{-356, -82}, {-116.5, -82}, {-116.5, 7.5}}, color = {166, 187, 200}));
  connect(QAux.y, gfm.QauxPu) annotation(
    Line(points = {{-356, -122}, {-258.9, -122}, {-258.9, 1}}, color = {166, 187, 200}));
  connect(QAux.y, epriVoltageCtrl.QAux) annotation(
    Line(points = {{-356, -122}, {-111.5, -122}, {-111.5, 7.5}}, color = {166, 187, 200}));
  connect(epriCurrentCtrl.uqConvRefPu, dQTrafo.uqPu) annotation(
    Line(points = {{73, 12}, {84.6, 12}, {84.6, 36.4}, {108.6, 36.4}}, color = {0, 0, 127}));
  connect(epriCurrentCtrl.udConvRefPu, dQTrafo.udPu) annotation(
    Line(points = {{73, 44}, {84.6, 44}, {84.6, 42.6}, {108.6, 42.6}}, color = {0, 0, 127}));
  connect(measurements.iPu, comptodq.iINjPu) annotation(
    Line(points = {{355.2, 9.1}, {355.2, -61.9}, {146.2, -61.9}}, color = {85, 170, 255}));
  connect(measurements.uPu, comptodq.uINjPu) annotation(
    Line(points = {{347.6, 9.1}, {347.6, -71.9}, {145.6, -71.9}}, color = {85, 170, 255}));
  connect(measurements.uPu, dQTrafo.uInjPu) annotation(
    Line(points = {{348, 10}, {348, -72}, {184, -72}, {184, 4}, {108, 4}, {108, 18}, {112, 18}}, color = {85, 170, 255}));
  connect(measurements.PPu, epriVoltageCtrl.p) annotation(
    Line(points = {{332, 10}, {332, -10}, {370, -10}, {370, 90}, {-150, 90}, {-150, 45}, {-126.5, 45}}, color = {23, 156, 125}));
  connect(measurements.QPu, epriVoltageCtrl.q) annotation(
    Line(points = {{340, 10}, {338, 10}, {338, -6}, {366, -6}, {366, 86}, {-146, 86}, {-146, 40}, {-126.5, 40}}, color = {23, 156, 125}));
  connect(measurements.QPu, gfm.QFilterPu) annotation(
    Line(points = {{340, 10}, {338, 10}, {338, -6}, {366, -6}, {366, 86}, {-284, 86}, {-284, 30}, {-276, 30}}, color = {23, 156, 125}));
  connect(PRef.y, gfm.PRefPu) annotation(
    Line(points = {{-358, 170}, {-330, 170}, {-330, 46}, {-276, 46}}, color = {166, 187, 200}));
  connect(QRef.y, gfm.QRefPu) annotation(
    Line(points = {{-358, 140}, {-336, 140}, {-336, 42}, {-276, 42}}, color = {166, 187, 200}));
  connect(measurements.PPu, gfm.PFilterPu) annotation(
    Line(points = {{332, 10}, {332, -10}, {370, -10}, {370, 90}, {-288, 90}, {-288, 34}, {-276, 34}}, color = {23, 156, 125}));
  connect(gfm.theta, comptodq.thetaGFM) annotation(
    Line(points = {{-224, 30}, {-210, 30}, {-210, -12}, {172, -12}, {172, -46}, {148, -46}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gfm.theta, dQTrafo.theta) annotation(
    Line(points = {{-224, 30}, {-210, 30}, {-210, -12}, {100, -12}, {100, 24}, {112, 24}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(comptodq.FrzReal, epriVoltageCtrl.FrzReal) annotation(
    Line(points = {{130, -88}, {130, -108}, {-80, -108}, {-80, 8}}, color = {0, 0, 127}));
protected
  annotation(
    Diagram(coordinateSystem(extent = {{-400, -200}, {400, 200}})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 3}, extent = {{-88, 59}, {88, -59}}, textString = "EPRI
GFM")}));
end EpriGFM;
