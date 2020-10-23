within OpenEMTP.Examples.SimpleCircuit;

model CapacitorSwitching
  Electrical.RLC_Branches.R Rds(R = 10e3)  annotation(
    Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.RL RLs(L = 39.8e-3, R = 1)  annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R R1(R = 30)  annotation(
    Placement(visible = true, transformation(origin = {10, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.L L1(L = 75e-6)  annotation(
    Placement(visible = true, transformation(origin = {10, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.L L(L = 75e-6)  annotation(
    Placement(visible = true, transformation(origin = {66, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R R(R = 30)  annotation(
    Placement(visible = true, transformation(origin = {66, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.C C1(C = 5e-6)  annotation(
    Placement(visible = true, transformation(origin = {40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.C C2(C = 5e-6)  annotation(
    Placement(visible = true, transformation(origin = {98, 16}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.Sources.CosineVoltage AC1(Phase = 0, Vm = 230, f = 60)  annotation(
    Placement(visible = true, transformation(origin = {-92, -24}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.Ground g annotation(
    Placement(visible = true, transformation(origin = {-92, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground G annotation(
    Placement(visible = true, transformation(origin = {40, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground G1 annotation(
    Placement(visible = true, transformation(origin = {98, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Switches.IdealSwitch BR1(Tclosing = 0.1, Topening = 1)  annotation(
    Placement(visible = true, transformation(origin = {-22, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.IdealSwitch BR2(Tclosing = 0.2, Topening = 0.4)  annotation(
    Placement(visible = true, transformation(origin = {22, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground G2 annotation(
    Placement(visible = true, transformation(origin = {-34, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.C C(C = 0.5e-6) annotation(
    Placement(visible = true, transformation(origin = {-34, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(Rds.p, RLs.p) annotation(
    Line(points = {{-70, 20}, {-80, 20}, {-80, 0}, {-70, 0}, {-70, 0}}, color = {0, 0, 255}));
  connect(Rds.n, RLs.n) annotation(
    Line(points = {{-50, 20}, {-40, 20}, {-40, 0}, {-50, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(R1.p, L1.p) annotation(
    Line(points = {{0, 10}, {-6, 10}, {-6, -8}, {0, -8}}, color = {0, 0, 255}));
  connect(R1.n, L1.n) annotation(
    Line(points = {{20, 10}, {28, 10}, {28, -8}, {20, -8}}, color = {0, 0, 255}));
  connect(R.p, L.p) annotation(
    Line(points = {{56, 50}, {50, 50}, {50, 32}, {56, 32}}, color = {0, 0, 255}));
  connect(C1.p, L1.n) annotation(
    Line(points = {{40, -20}, {40, -20}, {40, 0}, {28, 0}, {28, -8}, {20, -8}, {20, -8}}, color = {0, 0, 255}));
  connect(AC1.p, RLs.p) annotation(
    Line(points = {{-92, -14}, {-92, 0}, {-70, 0}}, color = {0, 0, 255}));
  connect(AC1.n, g.p) annotation(
    Line(points = {{-92, -34}, {-92, -34}, {-92, -44}, {-92, -44}}, color = {0, 0, 255}));
  connect(G1.p, C2.n) annotation(
    Line(points = {{98, -6}, {98, 6}}, color = {0, 0, 255}));
  connect(BR1.pin_p, RLs.n) annotation(
    Line(points = {{-34, 0}, {-50, 0}, {-50, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(BR1.pin_n, L1.p) annotation(
    Line(points = {{-10, 0}, {-6, 0}, {-6, -8}, {0, -8}, {0, -8}, {0, -8}}, color = {0, 0, 255}));
  connect(R.n, L.n) annotation(
    Line(points = {{76, 50}, {84, 50}, {84, 32}, {76, 32}, {76, 32}, {76, 32}}, color = {0, 0, 255}));
  connect(C2.p, L.n) annotation(
    Line(points = {{98, 26}, {98, 26}, {98, 40}, {84, 40}, {84, 32}, {76, 32}, {76, 32}}, color = {0, 0, 255}));
  connect(BR2.pin_n, L.p) annotation(
    Line(points = {{33, 40}, {50, 40}, {50, 32}, {56, 32}}, color = {0, 0, 255}));
  connect(BR2.pin_p, BR1.pin_n) annotation(
    Line(points = {{12, 40}, {-10, 40}, {-10, 0}, {-10, 0}}, color = {0, 0, 255}));
  connect(C.p, BR1.pin_p) annotation(
    Line(points = {{-34, -20}, {-34, 0}}, color = {0, 0, 255}));
  connect(C.n, G2.p) annotation(
    Line(points = {{-34, -40}, {-34, -40}, {-34, -48}, {-34, -48}}, color = {0, 0, 255}));
  connect(C1.n, G.p) annotation(
    Line(points = {{40, -40}, {40, -40}, {40, -48}, {40, -48}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-6, Interval = 1e-06),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "ida"));
end CapacitorSwitching;
