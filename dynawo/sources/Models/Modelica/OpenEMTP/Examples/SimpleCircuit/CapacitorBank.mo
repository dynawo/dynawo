within OpenEMTP.Examples.SimpleCircuit;

model CapacitorBank
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G annotation(
    Placement(visible = true, transformation(origin = {40, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.L L1(L = {1, 1, 1} * 75e-6) annotation(
    Placement(visible = true, transformation(origin = {-2, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.L L2(L = {1, 1, 1} * 75e-6) annotation(
    Placement(visible = true, transformation(origin = {60, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.R R1(R = {1, 1, 1} * 30) annotation(
    Placement(visible = true, transformation(origin = {0, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.R R2(R = {1, 1, 1} * 30) annotation(
    Placement(visible = true, transformation(origin = {60, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.C C1(C = {1, 1, 1} * 5e-6) annotation(
    Placement(visible = true, transformation(origin = {40, -36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.C C2(C = {1, 1, 1} * 5e-6) annotation(
    Placement(visible = true, transformation(origin = {92, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G1 annotation(
    Placement(visible = true, transformation(origin = {92, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.C Cs(C = {1, 1, 1} * 0.5e-6) annotation(
    Placement(visible = true, transformation(origin = {-80, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G2 annotation(
    Placement(visible = true, transformation(origin = {-80, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.R Rds(R = {1, 1, 1} * 5e3) annotation(
    Placement(visible = true, transformation(origin = {-108, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.RL_Coupled RLs(L = [0.0459780946709920, 0.00618935889801815, 0.00618935889801815; 0.00618935889801815, 0.0459780946709920, 0.00618935889801815; 0.00618935889801815, 0.00618935889801815, 0.0459780946709920], R = [1.33333333333333, 0.333333333333333, 0.333333333333333; 0.333333333333333, 1.33333333333333, 0.333333333333333; 0.333333333333333, 0.333333333333333, 1.33333333333333]) annotation(
    Placement(visible = true, transformation(origin = {-108, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Sources.YCosineVoltage AC annotation(
    Placement(visible = true, transformation(origin = {-154, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.Breaker BR1(Tclosing = {1, 1, 1} * 20e-3, Topening = {1, 1, 1} * 125e-3) annotation(
    Placement(visible = true, transformation(origin = {-48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Switches.Breaker BR2(Tclosing = {1, 1, 1} * 225e-3, Topening = {1, 1, 1}) annotation(
    Placement(visible = true, transformation(origin = {8, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.Breaker BR11(Tclosing = {1, 1, 1} * 175e-3, Topening = {1, 1, 1}) annotation(
    Placement(visible = true, transformation(origin = {-48, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(L2.plug_p, R2.plug_p) annotation(
    Line(points = {{50, 60}, {40, 60}, {40, 40}, {50, 40}}, color = {0, 0, 255}));
  connect(L2.plug_n, R2.plug_n) annotation(
    Line(points = {{70, 60}, {80, 60}, {80, 40}, {70, 40}}, color = {0, 0, 255}));
  connect(L1.plug_p, R1.plug_p) annotation(
    Line(points = {{-12, 16}, {-24, 16}, {-24, -10}, {-10, -10}}, color = {0, 0, 255}));
  connect(L1.plug_n, R1.plug_n) annotation(
    Line(points = {{8, 16}, {24, 16}, {24, -10}, {10, -10}}, color = {0, 0, 255}));
  connect(C2.plug_n, G1.positivePlug1) annotation(
    Line(points = {{92, 0}, {92, 0}, {92, -12}, {92, -12}}, color = {0, 0, 255}));
  connect(C1.plug_p, R1.plug_n) annotation(
    Line(points = {{40, -26}, {40, 0}, {24, 0}, {24, -10}, {10, -10}}, color = {0, 0, 255}));
  connect(C2.plug_p, R2.plug_n) annotation(
    Line(points = {{92, 20}, {92, 20}, {92, 50}, {80, 50}, {80, 40}, {70, 40}, {70, 40}}, color = {0, 0, 255}));
  connect(Cs.plug_n, G2.positivePlug1) annotation(
    Line(points = {{-80, -44}, {-80, -60}}, color = {0, 0, 255}));
  connect(BR1.k, Cs.plug_p) annotation(
    Line(points = {{-58, 0}, {-80, 0}, {-80, -24}}, color = {0, 0, 255}));
  connect(BR1.m, R1.plug_p) annotation(
    Line(points = {{-38, 0}, {-24, 0}, {-24, -10}, {-10, -10}, {-10, -10}}, color = {0, 0, 255}));
  connect(BR2.m, R2.plug_p) annotation(
    Line(points = {{18, 48}, {40, 48}, {40, 40}, {50, 40}, {50, 40}}, color = {0, 0, 255}));
  connect(C1.plug_n, G.positivePlug1) annotation(
    Line(points = {{40, -46}, {40, -46}, {40, -62}, {40, -62}}, color = {0, 0, 255}));
  connect(BR1.m, BR11.m) annotation(
    Line(points = {{-38, 0}, {-34, 0}, {-34, -22}, {-38, -22}}, color = {0, 0, 255}));
  connect(Rds.plug_p, RLs.plug_p) annotation(
    Line(points = {{-118, 16}, {-126, 16}, {-126, -10}, {-118, -10}, {-118, -10}}, color = {0, 0, 255}));
  connect(AC.Pk, RLs.plug_p) annotation(
    Line(points = {{-144, 0}, {-126, 0}, {-126, -10}, {-118, -10}, {-118, -10}}, color = {0, 0, 255}));
  connect(Rds.plug_n, RLs.plug_n) annotation(
    Line(points = {{-98, 16}, {-90, 16}, {-90, -10}, {-98, -10}, {-98, -10}}, color = {0, 0, 255}));
  connect(Cs.plug_p, RLs.plug_n) annotation(
    Line(points = {{-80, -24}, {-80, -24}, {-80, 0}, {-90, 0}, {-90, -10}, {-98, -10}, {-98, -10}}, color = {0, 0, 255}));
  connect(BR11.k, BR1.k) annotation(
    Line(points = {{-58, -22}, {-64, -22}, {-64, 0}, {-58, 0}, {-58, 0}}, color = {0, 0, 255}));
  connect(BR2.k, BR1.m) annotation(
    Line(points = {{-2, 48}, {-34, 48}, {-34, 0}, {-38, 0}, {-38, 0}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-6, Interval = 1e-06),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "ida"));
end CapacitorBank;
