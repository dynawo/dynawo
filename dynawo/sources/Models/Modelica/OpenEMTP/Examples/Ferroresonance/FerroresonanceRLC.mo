within OpenEMTP.Examples.Ferroresonance;

model FerroresonanceRLC
  OpenEMTP.Electrical.Nonlinear.L_Nonlinear L1(T = [0.0015, 200; 1200, 1.0015])  annotation(
    Placement(visible = true, transformation(origin = {60, 16}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.R R1(R = 1000E6)  annotation(
    Placement(visible = true, transformation(origin = {20, 16}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.C C1(C = 0.4e-9)  annotation(
    Placement(visible = true, transformation(origin = {-6, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Sources.CosineVoltage AC(Phase = 1.5708, Vm = 25, f = 50)  annotation(
    Placement(visible = true, transformation(origin = {-64, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(R1.n, AC.n) annotation(
    Line(points = {{20, 6}, {20, 6}, {20, -20}, {-64, -20}, {-64, 0}, {-64, 0}}, color = {0, 0, 255}));
  connect(AC.n, L1.n) annotation(
    Line(points = {{-64, 0}, {-64, 0}, {-64, -20}, {60, -20}, {60, 6}, {60, 6}}, color = {0, 0, 255}));
  connect(R1.p, C1.n) annotation(
    Line(points = {{20, 26}, {20, 26}, {20, 40}, {4, 40}, {4, 40}}, color = {0, 0, 255}));
  connect(C1.n, L1.p) annotation(
    Line(points = {{4, 40}, {60, 40}, {60, 26}, {60, 26}, {60, 26}}, color = {0, 0, 255}));
  connect(C1.p, AC.p) annotation(
    Line(points = {{-16, 40}, {-64, 40}, {-64, 20}, {-64, 20}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 0.05, Tolerance = 1e-6, Interval = 1e-07),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=initialization ");
end FerroresonanceRLC;
