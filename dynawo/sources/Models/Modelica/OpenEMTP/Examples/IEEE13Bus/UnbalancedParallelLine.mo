within OpenEMTP.Examples.IEEE13Bus;

model UnbalancedParallelLine
  IEEE13Bus.multiPhaseCP TLM1(Rn = [375.563666666667, 78.5881666666666, 78.5881666666666; 78.5881666666666, 375.563666666667, 78.5881666666666; 78.5881666666667, 78.5881666666667, 375.563666666667], Ti = [0.577350269189626, 0.707106781186548, 0.408248290463863; 0.577350269189626, -0.707106781186548, 0.408248290463863; 0.577350269189626, 0, -0.816496580927726], Zmod = {532.740000000000, 296.975500000000, 296.975500000000}, h = {0.976198520854451, 0.989389697129898, 0.989389697129898},m = 3, tau = {7.9037e-4, 6.806e-4, 6.806e-4})  annotation(
    Placement(visible = true, transformation(origin = {-6, 24}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  IEEE13Bus.multiPhaseCP TLM2(Rn = [375.563666666667, 78.5881666666666, 78.5881666666666; 78.5881666666666, 375.563666666667, 78.5881666666666; 78.5881666666667, 78.5881666666667, 375.563666666667], Ti = [0.577350269189626, 0.707106781186548, 0.408248290463863; 0.577350269189626, -0.707106781186548, 0.408248290463863; 0.577350269189626, 0, -0.816496580927726], Zmod = {532.740000000000, 296.975500000000, 296.975500000000}, h = {0.976198520854451, 0.989389697129898, 0.989389697129898}, m = 3, tau = {7.9037e-4, 6.806e-4, 6.806e-4}) annotation(
    Placement(visible = true, transformation(origin = {-4, -4}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  IEEE13Bus.MultiphaseBreaker BRk1(Tclosing = {0, 0, 0}, Topening = {1, 1, 1} * 300e-3)  annotation(
    Placement(visible = true, transformation(origin = {-38, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  IEEE13Bus.MultiphaseBreaker BRm1(Tclosing = {0, 0, 0}, Topening = {1, 1, 1} * 300e-3)  annotation(
    Placement(visible = true, transformation(origin = {32, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  IEEE13Bus.MultiphaseBreaker BRm1p(Tclosing = {1, 1, 1} * 400e-3, Topening = {2, 2, 2})  annotation(
    Placement(visible = true, transformation(origin = {32, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  IEEE13Bus.MultiphaseBreaker BRk1p(Tclosing = {1, 1, 1} * 400e-3, Topening = {2, 2, 2})  annotation(
    Placement(visible = true, transformation(origin = {-38, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  IEEE13Bus.MultiphaseBreaker BR1(Tclosing = {0, 0, 0}, Topening = {2, 2, 2})  annotation(
    Placement(visible = true, transformation(origin = {-74, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.RL_Coupled RLs(L = [0.0220509173653821, 0.00724950765783583, 0.00724950765783583; 0.00724950765783583, 0.0220509173653821, 0.00724950765783583; 0.00724950765783583, 0.00724950765783583, 0.0220509173653821], R = [4.49946666666667, 1.48526666666667, 1.48526666666667; 1.48526666666667, 4.49946666666667, 1.48526666666667; 1.48526666666667, 1.48526666666667, 4.49946666666667])  annotation(
    Placement(visible = true, transformation(origin = {-104, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.C Cs(C = {1, 1, 1} * 0.5e-6)  annotation(
    Placement(visible = true, transformation(origin = {-90, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.Sources.YCosineVoltage ac(Vm = 400 * {1, 1, 1}, m = 3)  annotation(
    Placement(visible = true, transformation(origin = {-130, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground g annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  IEEE13Bus.IdealBreaker idealBreaker(Tclosing = 200e-3, Topening = 350e-3)  annotation(
    Placement(visible = true, transformation(origin = {50, 60}, extent = {{-15, -15}, {15, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Plug_a plug_a annotation(
    Placement(visible = true, transformation(origin = {26, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R r(R = 1)  annotation(
    Placement(visible = true, transformation(origin = {78, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground g1 annotation(
    Placement(visible = true, transformation(origin = {96, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  IEEE13Bus.MultiphaseBreaker multiphaseBreaker(Tclosing = {0, 0, 0}, Topening = {1, 1, 1} * 60e-3)  annotation(
    Placement(visible = true, transformation(origin = {100, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.L L(L = {1, 1, 1} * 7)  annotation(
    Placement(visible = true, transformation(origin = {118, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground g2 annotation(
    Placement(visible = true, transformation(origin = {118, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Load_Models.PQ_Load pQ_Load(P = {1, 1, 1} * 500 / 3, Q = {1, 1, 1} * 100 / 3, V = 400, f = 60)  annotation(
    Placement(visible = true, transformation(origin = {74, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  IEEE13Bus.MultiphaseBreaker multiphaseBreaker1(Tclosing = {1, 1, 1} * 100e-3, Topening = {2, 2, 2})  annotation(
    Placement(visible = true, transformation(origin = {80, -6}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(BRk1.negativePlug1, TLM1.sP) annotation(
    Line(points = {{-29, 24}, {-16, 24}}, color = {0, 0, 255}));
  connect(BRm1.positivePlug1, TLM1.rP) annotation(
    Line(points = {{22, 24}, {2, 24}}, color = {0, 0, 255}));
  connect(BRm1p.positivePlug1, BRm1.positivePlug1) annotation(
    Line(points = {{22, 40}, {16, 40}, {16, 24}, {22, 24}, {22, 24}}, color = {0, 0, 255}));
  connect(BRm1p.negativePlug1, BRm1.negativePlug1) annotation(
    Line(points = {{42, 40}, {52, 40}, {52, 24}, {42, 24}, {42, 24}}, color = {0, 0, 255}));
  connect(BRk1p.negativePlug1, BRk1.negativePlug1) annotation(
    Line(points = {{-28, 40}, {-22, 40}, {-22, 24}, {-28, 24}, {-28, 24}}, color = {0, 0, 255}));
  connect(BRk1p.positivePlug1, BRk1.positivePlug1) annotation(
    Line(points = {{-48, 40}, {-58, 40}, {-58, 24}, {-48, 24}, {-48, 24}}, color = {0, 0, 255}));
  connect(RLs.plug_n, BR1.positivePlug1) annotation(
    Line(points = {{-94, 10}, {-84, 10}, {-84, 10}, {-84, 10}}, color = {0, 0, 255}));
  connect(Cs.plug_p, RLs.plug_n) annotation(
    Line(points = {{-90, 0}, {-90, 0}, {-90, 10}, {-94, 10}, {-94, 10}}, color = {0, 0, 255}));
  connect(ac.Pk, RLs.plug_p) annotation(
    Line(points = {{-120, 10}, {-114, 10}, {-114, 10}, {-114, 10}}, color = {0, 0, 255}));
  connect(g.positivePlug1, Cs.plug_n) annotation(
    Line(points = {{-90, -30}, {-90, -30}, {-90, -20}, {-90, -20}}, color = {0, 0, 255}));
  connect(plug_a.pin_p, idealBreaker.pin_p) annotation(
    Line(points = {{28, 60.2}, {31, 60.2}, {31, 60}, {36, 60}}, color = {0, 0, 255}));
  connect(plug_a.plug_p, BRm1.positivePlug1) annotation(
    Line(points = {{24, 60}, {16, 60}, {16, 24}, {22, 24}, {22, 24}}, color = {0, 0, 255}));
  connect(idealBreaker.pin_n, r.p) annotation(
    Line(points = {{63, 60}, {68, 60}}, color = {0, 0, 255}));
  connect(r.n, g1.p) annotation(
    Line(points = {{88, 60}, {96, 60}, {96, 58}, {96, 58}}, color = {0, 0, 255}));
  connect(multiphaseBreaker.negativePlug1, L.plug_p) annotation(
    Line(points = {{110, 10}, {118, 10}, {118, 0}, {118, 0}}, color = {0, 0, 255}));
  connect(g2.positivePlug1, L.plug_n) annotation(
    Line(points = {{118, -30}, {118, -30}, {118, -20}, {118, -20}}, color = {0, 0, 255}));
  connect(multiphaseBreaker1.positivePlug1, multiphaseBreaker.positivePlug1) annotation(
    Line(points = {{80, 4}, {80, 4}, {80, 10}, {90, 10}, {90, 10}}, color = {0, 0, 255}));
  connect(multiphaseBreaker1.negativePlug1, pQ_Load.positivePlug) annotation(
    Line(points = {{80, -16}, {80, -22}, {81, -22}}, color = {0, 0, 255}));
  connect(TLM2.sP, BR1.negativePlug1) annotation(
    Line(points = {{-14, -4}, {-64, -4}, {-64, 10}, {-64, 10}}, color = {0, 0, 255}));
  connect(BRk1.positivePlug1, BR1.negativePlug1) annotation(
    Line(points = {{-48, 24}, {-64, 24}, {-64, 10}, {-64, 10}}, color = {0, 0, 255}));
  connect(TLM2.rP, BRm1.negativePlug1) annotation(
    Line(points = {{4, -4}, {52, -4}, {52, 24}, {42, 24}, {42, 24}}, color = {0, 0, 255}));
  connect(multiphaseBreaker1.positivePlug1, BRm1.negativePlug1) annotation(
    Line(points = {{80, 4}, {80, 4}, {80, 10}, {52, 10}, {52, 24}, {42, 24}, {42, 24}}, color = {0, 0, 255}));
annotation(
    experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-6, Interval = 5e-06),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", initialStepSize = "5e-06", maxIntegrationOrder = "2", maxStepSize = "5e-06"));
end UnbalancedParallelLine;
