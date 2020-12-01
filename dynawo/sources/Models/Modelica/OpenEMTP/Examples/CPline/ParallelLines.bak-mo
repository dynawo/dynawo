within OpenEMTP.Examples.CPline;

model ParallelLines
  OpenEMTP.Electrical.Lines.CPmodel.SP_TLM TLM1(Zc = 295.4, d = 200000, r = 3.151e-2, tau = 6.806e-4) annotation(
    Placement(visible = true, transformation(origin = {-2, 20}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.IdealSwitch BRk1(Tclosing = -1, Topening = 300e-3) annotation(
    Placement(visible = true, transformation(origin = {-44, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.IdealSwitch BRm1(Tclosing = -1, Topening = 300e-3) annotation(
    Placement(visible = true, transformation(origin = {42, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R R1(R = 320) annotation(
    Placement(visible = true, transformation(origin = {74, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.L L1(L = 4.2441) annotation(
    Placement(visible = true, transformation(origin = {98, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.L L(L = 7) annotation(
    Placement(visible = true, transformation(origin = {138, -24}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.Ground g annotation(
    Placement(visible = true, transformation(origin = {74, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground G annotation(
    Placement(visible = true, transformation(origin = {98, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground G1 annotation(
    Placement(visible = true, transformation(origin = {138, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL Rls(L = 5.5601 / 377, R = 3.0142) annotation(
    Placement(visible = true, transformation(origin = {-122, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.IdealSwitch SW(Tclosing = 0, Topening = 2) annotation(
    Placement(visible = true, transformation(origin = {-84, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Sources.CosineVoltage ac(StopTime = 2, Vm = 400 / sqrt(3)) annotation(
    Placement(visible = true, transformation(origin = {-140, -38}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.Ground G2 annotation(
    Placement(visible = true, transformation(origin = {-140, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.SP_TLM TLM2(Zc = 295.4, d = 200000, r = 3.151e-2, tau = 6.806e-4) annotation(
    Placement(visible = true, transformation(origin = {-2, -20}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.IdealSwitch SW2(Tclosing = 200e-3, Topening = 350e-3) annotation(
    Placement(visible = true, transformation(origin = {28, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R r(R = 1) annotation(
    Placement(visible = true, transformation(origin = {80, 64}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.Ground ground annotation(
    Placement(visible = true, transformation(origin = {80, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.IdealSwitch SW3(Tclosing = 100e-3, Topening = 2) annotation(
    Placement(visible = true, transformation(origin = {84, -18}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.C Cs(C = 0.5e-6)  annotation(
    Placement(visible = true, transformation(origin = {-98, -38}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.Ground G3 annotation(
    Placement(visible = true, transformation(origin = {-98, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.IdealSwitch idealSwitch(Tclosing = 450e-3, Topening = 2) annotation(
    Placement(visible = true, transformation(origin = {-44, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.IdealSwitch idealSwitch1(Tclosing = 450e-3, Topening = 2) annotation(
    Placement(visible = true, transformation(origin = {40, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(BRm1.pin_p, TLM1.pin_m) annotation(
    Line(points = {{32, 20}, {14, 20}, {14, 20}, {12, 20}}, color = {0, 0, 255}));
  connect(TLM1.pin_k, BRk1.pin_n) annotation(
    Line(points = {{-16, 20}, {-32, 20}, {-32, 20}, {-32, 20}}, color = {0, 0, 255}));
  connect(L1.p, R1.p) annotation(
    Line(points = {{98, -40}, {98, -40}, {98, -34}, {74, -34}, {74, -40}, {74, -40}}, color = {0, 0, 255}));
  connect(R1.n, g.p) annotation(
    Line(points = {{74, -60}, {74, -72}}, color = {0, 0, 255}));
  connect(L1.n, G.p) annotation(
    Line(points = {{98, -60}, {98, -72}}, color = {0, 0, 255}));
  connect(L.n, G1.p) annotation(
    Line(points = {{138, -34}, {138, -48}}, color = {0, 0, 255}));
  connect(Rls.n, SW.pin_p) annotation(
    Line(points = {{-112, 0}, {-94, 0}, {-94, 0}, {-94, 0}}, color = {0, 0, 255}));
  connect(Rls.p, ac.p) annotation(
    Line(points = {{-132, 0}, {-140, 0}, {-140, -28}}, color = {0, 0, 255}));
  connect(ac.n, G2.p) annotation(
    Line(points = {{-140, -48}, {-140, -58}}, color = {0, 0, 255}));
  connect(r.n, ground.p) annotation(
    Line(points = {{80, 54}, {80, 54}, {80, 46}, {80, 46}}, color = {0, 0, 255}));
  connect(r.p, SW2.pin_n) annotation(
    Line(points = {{80, 74}, {39, 74}}, color = {0, 0, 255}));
  connect(SW.pin_n, BRk1.pin_p) annotation(
    Line(points = {{-72, 0}, {-60, 0}, {-60, 20}, {-54, 20}}, color = {0, 0, 255}));
  connect(TLM2.pin_m, BRm1.pin_n) annotation(
    Line(points = {{12, -20}, {60, -20}, {60, 20}, {54, 20}, {54, 20}}, color = {0, 0, 255}));
  connect(TLM2.pin_k, SW.pin_n) annotation(
    Line(points = {{-16, -20}, {-60, -20}, {-60, 0}, {-72, 0}, {-72, 0}}, color = {0, 0, 255}));
  connect(SW3.pin_n, R1.p) annotation(
    Line(points = {{84, -28}, {84, -28}, {84, -34}, {74, -34}, {74, -40}, {74, -40}}, color = {0, 0, 255}));
  connect(Cs.p, Rls.n) annotation(
    Line(points = {{-98, -28}, {-98, -28}, {-98, 0}, {-112, 0}, {-112, 0}}, color = {0, 0, 255}));
  connect(Cs.n, G3.p) annotation(
    Line(points = {{-98, -48}, {-98, -48}, {-98, -58}, {-98, -58}}, color = {0, 0, 255}));
  connect(SW3.pin_p, BRm1.pin_n) annotation(
    Line(points = {{84, -6}, {84, -6}, {84, 20}, {54, 20}, {54, 20}}, color = {0, 0, 255}));
  connect(SW2.pin_p, TLM1.pin_m) annotation(
    Line(points = {{18, 74}, {12, 74}, {12, 20}, {12, 20}}, color = {0, 0, 255}));
  connect(L.p, SW3.pin_p) annotation(
    Line(points = {{138, -14}, {138, -14}, {138, 0}, {84, 0}, {84, -6}, {84, -6}}, color = {0, 0, 255}));
  connect(BRk1.pin_p, idealSwitch.pin_p) annotation(
    Line(points = {{-54, 20}, {-54, 20}, {-54, 48}, {-54, 48}}, color = {0, 0, 255}));
  connect(idealSwitch.pin_n, BRk1.pin_n) annotation(
    Line(points = {{-32, 48}, {-34, 48}, {-34, 20}, {-32, 20}}, color = {0, 0, 255}));
  connect(idealSwitch1.pin_p, TLM1.pin_m) annotation(
    Line(points = {{30, 44}, {22, 44}, {22, 20}, {12, 20}, {12, 20}}, color = {0, 0, 255}));
  connect(idealSwitch1.pin_n, BRm1.pin_n) annotation(
    Line(points = {{52, 44}, {54, 44}, {54, 20}, {54, 20}, {54, 20}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-6, Interval = 5e-06),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", initialStepSize = "5e-06", maxIntegrationOrder = "2", maxStepSize = "5e-06", noEquidistantTimeGrid = "()"));
end ParallelLines;
