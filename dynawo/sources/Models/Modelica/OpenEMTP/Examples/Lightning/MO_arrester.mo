within OpenEMTP.Examples.Lightning;

model MO_arrester
  OpenEMTP.Electrical.RLC_Branches.Ground g annotation(
    Placement(visible = true, transformation(origin = {-94, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Sources.SurgeCurrent isurge(Im = 2.95, Tstart = 10e-6, Tstop = 10e-3, alpha = -5000, beta = -46500) annotation(
    Placement(visible = true, transformation(origin = {-94, -24}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.L l(L = 0.36e-6) annotation(
    Placement(visible = true, transformation(origin = {-44, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R r(R = 180) annotation(
    Placement(visible = true, transformation(origin = {-44, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.C c(C = 0.0555e-9) annotation(
    Placement(visible = true, transformation(origin = {-22, -28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.Ground G annotation(
    Placement(visible = true, transformation(origin = {-22, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground G1 annotation(
    Placement(visible = true, transformation(origin = {24, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Nonlinear.ZnoArrester Zno2 annotation(
    Placement(visible = true, transformation(origin = {24, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.Nonlinear.ZnoArrester Zno1(T = [0.311018270393423E+04, 0.229924245480258E+02, 0.521929628617745E+00; 0.196949302936342E+04, 0.137340017465056E+02, 0.951847704367301E+00; 0.195499844855362E+04, 0.203340749343859E+02, 0.100111982082867E+01; 0.143825806917811E+04, 0.290526629155985E+02, 0.103583426651736E+01; 0.251605286203752E+04, 0.173180807412340E+02, 0.104881296610149E+01; 0.271193060945704E+04, 0.166428240224341E+02, 0.111742128174933E+01], Vref = 516000) annotation(
    Placement(visible = true, transformation(origin = {90, -26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.Ground G2 annotation(
    Placement(visible = true, transformation(origin = {90, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R r1(R = 117) annotation(
    Placement(visible = true, transformation(origin = {68, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.L l1(L = 42e-6, i(start = 0)) annotation(
    Placement(visible = true, transformation(origin = {68, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(g.p, isurge.n) annotation(
    Line(points = {{-94, -46}, {-94, -34}}, color = {0, 0, 255}));
  connect(l.p, r.p) annotation(
    Line(points = {{-54, 42}, {-66, 42}, {-66, 20}, {-54, 20}}, color = {0, 0, 255}));
  connect(l.n, r.n) annotation(
    Line(points = {{-34, 42}, {-22, 42}, {-22, 20}, {-34, 20}}, color = {0, 0, 255}));
  connect(isurge.p, r.p) annotation(
    Line(points = {{-94, -14}, {-94, 20}, {-54, 20}}, color = {0, 0, 255}));
  connect(r.n, c.p) annotation(
    Line(points = {{-34, 20}, {-22, 20}, {-22, -18}}, color = {0, 0, 255}));
  connect(c.n, G.p) annotation(
    Line(points = {{-22, -38}, {-22, -46}}, color = {0, 0, 255}));
  connect(Zno2.n, G1.p) annotation(
    Line(points = {{24, -32}, {24, -48}}, color = {0, 0, 255}));
  connect(Zno2.p, r.n) annotation(
    Line(points = {{24, -12}, {24, 20}, {-34, 20}}, color = {0, 0, 255}));
  connect(G2.p, Zno1.n) annotation(
    Line(points = {{90, -46}, {90, -36}}, color = {0, 0, 255}));
  connect(r1.p, l1.p) annotation(
    Line(points = {{58, 42}, {48, 42}, {48, 20}, {58, 20}}, color = {0, 0, 255}));
  connect(r.n, l1.p) annotation(
    Line(points = {{-34, 20}, {58, 20}}, color = {0, 0, 255}));
  connect(r1.n, Zno1.p) annotation(
    Line(points = {{78, 42}, {90, 42}, {90, -16}}, color = {0, 0, 255}));
  connect(l1.n, Zno1.p) annotation(
    Line(points = {{78, 20}, {90, 20}, {90, -16}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 0.0003, Tolerance = 1e-04, Interval = 1.00003e-08),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "ida", clock = "CPU", lss = "klu"));
end MO_arrester;
