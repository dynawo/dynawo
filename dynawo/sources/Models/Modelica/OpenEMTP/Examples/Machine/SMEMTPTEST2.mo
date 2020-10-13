within OpenEMTP.Examples.Machine;


model SMEMTPTEST2
  OpenEMTP.Electrical.Machines.SM_4thOrder sm( It_ss = {0, 0}, Vt_ss = {1.03, -11.8}, dw0 = 0) annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));

  Electrical.Exciters_Governor.Governor_IEEEG1 governor_IEEEG1(K = 20, K1 = 0.2, K2 = 0, K3 = 0.4, K4 = 0, K5 = 0.4, K6 = 0, K7 = 0, K8 = 0, PMAX = 0.9, PMIN = 0, Pref = 0, T1 = 1e-15, T2 = 0, T3 = 0.075, T4 = 0.3, T5 = 10, T6 = 0.6, T7 = 1e-15, U0 = 0.6786, UC = -1) annotation(
    Placement(visible = true, transformation(origin = {-142, 52}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));

  OpenEMTP.Electrical.Lines.WBmodel.WBline L09_39(G = {{{-4.969127617241e-04, 1.021900784612e-05, 1.021900784612e-05}, {1.021900784612e-05, -4.969127617241e-04, 1.021900784612e-05}, {1.021900784612e-05, 1.021900784612e-05, -4.969127617241e-04}}, {{-4.108709486937e-03, 1.251093528361e-03, 1.251093528361e-03}, {1.251093528361e-03, -4.108709486937e-03, 1.251093528361e-03}, {1.251093528361e-03, 1.251093528361e-03, -4.108709486937e-03}}, {{-3.463863605275e-02, 1.645593648773e-02, 1.645593648773e-02}, {1.645593648773e-02, -3.463863605275e-02, 1.645593648773e-02}, {1.645593648773e-02, 1.645593648773e-02, -3.463863605275e-02}}, {{-2.620483413146e-02, -1.989756812031e-02, -1.989756812031e-02}, {-1.989756812031e-02, -2.620483413146e-02, -1.989756812031e-02}, {-1.989756812031e-02, -1.989756812031e-02, -2.620483413146e-02}}, {{-5.476604678576e-01, -3.785143415990e-01, -3.785143415990e-01}, {-3.785143415990e-01, -5.476604678576e-01, -3.785143415990e-01}, {-3.785143415990e-01, -3.785143415990e-01, -5.476604678576e-01}}, {{-9.711322923755e+00, -6.189338072503e+00, -6.189338072503e+00}, {-6.189338072503e+00, -9.711322923755e+00, -6.189338072503e+00}, {-6.189338072503e+00, -6.189338072503e+00, -9.711322923755e+00}}, {{-8.264229399125e+01, -4.529652318913e+01, -4.529652318913e+01}, {-4.529652318913e+01, -8.264229399125e+01, -4.529652318913e+01}, {-4.529652318913e+01, -4.529652318913e+01, -8.264229399125e+01}}}, G0 = {{5.501193537985e-03, -1.284048350618e-03, -1.284048350618e-03}, {-1.284048350618e-03, 5.501193537985e-03, -1.284048350618e-03}, {-1.284048350618e-03, -1.284048350618e-03, 5.501193537985e-03}}, Pm_H = {{Complex(-2.608779723440e+00, 0.000000000000e+00), Complex(-3.324916966694e+01, 0.000000000000e+00), Complex(-1.446914034749e+04, 0.000000000000e+00), Complex(-9.641984012797e+04, 0.000000000000e+00), Complex(-3.876635822188e+05, 0.000000000000e+00), Complex(-1.254541953067e+06, 0.000000000000e+00), Complex(-5.791182678972e+06, 0.000000000000e+00)}, {Complex(-9.080867099293e+01, 0.000000000000e+00), Complex(-5.907467776135e+03, 0.000000000000e+00), Complex(-3.031547134052e+04, 0.000000000000e+00), Complex(-9.787996393191e+04, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00)}}, Rm_H = {{{{Complex(6.319966462022e-03, 0.000000000000e+00), Complex(-3.678307850412e-04, 0.000000000000e+00), Complex(-3.678307850415e-04, 0.000000000000e+00)}, {Complex(-3.678307850410e-04, 0.000000000000e+00), Complex(6.319966462022e-03, 0.000000000000e+00), Complex(-3.678307850415e-04, 0.000000000000e+00)}, {Complex(-3.678307850412e-04, 0.000000000000e+00), Complex(-3.678307850412e-04, 0.000000000000e+00), Complex(6.319966462023e-03, 0.000000000000e+00)}}, {{Complex(1.923324888818e-02, 0.000000000000e+00), Complex(-5.386124128268e-03, 0.000000000000e+00), Complex(-5.386124128265e-03, 0.000000000000e+00)}, {Complex(-5.386124128274e-03, 0.000000000000e+00), Complex(1.923324888820e-02, 0.000000000000e+00), Complex(-5.386124128259e-03, 0.000000000000e+00)}, {Complex(-5.386124128267e-03, 0.000000000000e+00), Complex(-5.386124128251e-03, 0.000000000000e+00), Complex(1.923324888819e-02, 0.000000000000e+00)}}, {{Complex(2.150689264982e+02, 0.000000000000e+00), Complex(2.906516988502e+00, 0.000000000000e+00), Complex(2.906516988488e+00, 0.000000000000e+00)}, {Complex(2.906516988552e+00, 0.000000000000e+00), Complex(2.150689264985e+02, 0.000000000000e+00), Complex(2.906516988225e+00, 0.000000000000e+00)}, {Complex(2.906516988386e+00, 0.000000000000e+00), Complex(2.906516988286e+00, 0.000000000000e+00), Complex(2.150689264985e+02, 0.000000000000e+00)}}, {{Complex(1.047834530614e+04, 0.000000000000e+00), Complex(-4.162932703751e+03, 0.000000000000e+00), Complex(-4.162932703751e+03, 0.000000000000e+00)}, {Complex(-4.162932703751e+03, 0.000000000000e+00), Complex(1.047834530614e+04, 0.000000000000e+00), Complex(-4.162932703747e+03, 0.000000000000e+00)}, {Complex(-4.162932703750e+03, 0.000000000000e+00), Complex(-4.162932703748e+03, 0.000000000000e+00), Complex(1.047834530614e+04, 0.000000000000e+00)}}, {{Complex(1.164954991706e+05, 0.000000000000e+00), Complex(-6.197476051333e+04, 0.000000000000e+00), Complex(-6.197476051333e+04, 0.000000000000e+00)}, {Complex(-6.197476051333e+04, 0.000000000000e+00), Complex(1.164954991706e+05, 0.000000000000e+00), Complex(-6.197476051334e+04, 0.000000000000e+00)}, {Complex(-6.197476051333e+04, 0.000000000000e+00), Complex(-6.197476051334e+04, 0.000000000000e+00), Complex(1.164954991706e+05, 0.000000000000e+00)}}, {{Complex(4.253539416745e+05, 0.000000000000e+00), Complex(-2.074689909615e+05, 0.000000000000e+00), Complex(-2.074689909615e+05, 0.000000000000e+00)}, {Complex(-2.074689909615e+05, 0.000000000000e+00), Complex(4.253539416745e+05, 0.000000000000e+00), Complex(-2.074689909615e+05, 0.000000000000e+00)}, {Complex(-2.074689909615e+05, 0.000000000000e+00), Complex(-2.074689909615e+05, 0.000000000000e+00), Complex(4.253539416745e+05, 0.000000000000e+00)}}, {{Complex(-5.532279398182e+05, 0.000000000000e+00), Complex(2.717529232987e+05, 0.000000000000e+00), Complex(2.717529232987e+05, 0.000000000000e+00)}, {Complex(2.717529232987e+05, 0.000000000000e+00), Complex(-5.532279398182e+05, 0.000000000000e+00), Complex(2.717529232987e+05, 0.000000000000e+00)}, {Complex(2.717529232987e+05, 0.000000000000e+00), Complex(2.717529232986e+05, 0.000000000000e+00), Complex(-5.532279398182e+05, 0.000000000000e+00)}}}, {{{Complex(5.954240230893e-01, 0.000000000000e+00), Complex(5.428843658200e-01, 0.000000000000e+00), Complex(5.428843658200e-01, 0.000000000000e+00)}, {Complex(5.428843658201e-01, 0.000000000000e+00), Complex(5.954240230893e-01, 0.000000000000e+00), Complex(5.428843658200e-01, 0.000000000000e+00)}, {Complex(5.428843658200e-01, 0.000000000000e+00), Complex(5.428843658200e-01, 0.000000000000e+00), Complex(5.954240230893e-01, 0.000000000000e+00)}}, {{Complex(4.759144443675e+02, 0.000000000000e+00), Complex(4.593983376940e+02, 0.000000000000e+00), Complex(4.593983376940e+02, 0.000000000000e+00)}, {Complex(4.593983376940e+02, 0.000000000000e+00), Complex(4.759144443674e+02, 0.000000000000e+00), Complex(4.593983376940e+02, 0.000000000000e+00)}, {Complex(4.593983376940e+02, 0.000000000000e+00), Complex(4.593983376940e+02, 0.000000000000e+00), Complex(4.759144443674e+02, 0.000000000000e+00)}}, {{Complex(1.097539211348e+04, 0.000000000000e+00), Complex(1.080606355007e+04, 0.000000000000e+00), Complex(1.080606355007e+04, 0.000000000000e+00)}, {Complex(1.080606355007e+04, 0.000000000000e+00), Complex(1.097539211348e+04, 0.000000000000e+00), Complex(1.080606355007e+04, 0.000000000000e+00)}, {Complex(1.080606355007e+04, 0.000000000000e+00), Complex(1.080606355007e+04, 0.000000000000e+00), Complex(1.097539211348e+04, 0.000000000000e+00)}}, {{Complex(-1.179071220269e+04, 0.000000000000e+00), Complex(-1.159078257321e+04, 0.000000000000e+00), Complex(-1.159078257321e+04, 0.000000000000e+00)}, {Complex(-1.159078257321e+04, 0.000000000000e+00), Complex(-1.179071220269e+04, 0.000000000000e+00), Complex(-1.159078257322e+04, 0.000000000000e+00)}, {Complex(-1.159078257321e+04, 0.000000000000e+00), Complex(-1.159078257321e+04, 0.000000000000e+00), Complex(-1.179071220269e+04, 0.000000000000e+00)}}, {{Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00)}, {Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00)}, {Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00)}}, {{Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00)}, {Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00)}, {Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00)}}, {{Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00)}, {Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00)}, {Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00), Complex(0.000000000000e+00, 0.000000000000e+00)}}}}, m = 3, q = {-6.470250423922e-01, -3.305519432385e+00, -1.355622737832e+01, -8.007126792738e+01, -6.306415024249e+03, -1.161060029365e+05, -2.028366300992e+06}, tau = {4.638176223881e-04, 4.747110837702e-04}) annotation (
    Placement(visible = true, transformation(origin = {-10, -58}, extent = {{-20, -10}, {20, 10}}, rotation = -90)));
  OpenEMTP.Electrical.Load_Models.PQ_Load Load39(P=(1104/3)*{1,1,1}, Q=(250/3)*{1,1,1}, V = 25.25, f = 60)
    annotation (Placement(visible = true, transformation(extent = {{72, -70}, {92, -50}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.YgD01 LoadTransfo39(
    S=1500,
    f=60,
    v1=345,
    v2=25,
    R=0.002,
    X=0.100,
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    Rmg=500) annotation (Placement(visible = true, transformation(extent = {{44, -46}, {64, -26}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.R r(R = 50 * {1, 1, 1})  annotation(
    Placement(visible = true, transformation(origin = {8, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground g annotation(
    Placement(visible = true, transformation(origin = {32, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.Breaker breaker(Tclosing = {0, 0, 0}, Topening = 100 * {1, 1, 1})  annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Switches.IdealSwitch sw(Tclosing = 0.1, Topening = 0.2)  annotation(
    Placement(visible = true, transformation(origin = {-8, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.Plug_a plug_a annotation(
    Placement(visible = true, transformation(origin = {-30, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Plug_b plug_b annotation(
    Placement(visible = true, transformation(origin = {12, 44}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.NonElectrical.Blocks.VdqToVt vdqToVt1 annotation(
    Placement(visible = true, transformation(origin = {-210, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Vf(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-166, -14}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  OpenEMTP.Electrical.Exciters_Governor.ST1 st11(EFSS = 0.9999853331182158)  annotation(
    Placement(visible = true, transformation(origin = {-132, -44}, extent = {{-35, -20}, {25, 15}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = 0.01, k = 1, y_start = 0.9999999999999998)  annotation(
    Placement(visible = true, transformation(origin = {-176, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(L09_39.Pk, LoadTransfo39.k) annotation(
    Line(points = {{-10, -42}, {-10, -42}, {-10, -36}, {44, -36}, {44, -36}}, color = {0, 0, 255}));
  connect(LoadTransfo39.k, r.plug_p) annotation(
    Line(points = {{44, -36}, {-2, -36}, {-2, 20}, {-2, 20}}, color = {0, 0, 255}));
  connect(breaker.m, r.plug_p) annotation(
    Line(points = {{-30, 20}, {-2, 20}, {-2, 20}, {-2, 20}}, color = {0, 0, 255}));
  connect(plug_b.plug_p, r.plug_p) annotation(
    Line(points = {{14, 44}, {26, 44}, {26, 28}, {-2, 28}, {-2, 20}, {-2, 20}}, color = {0, 0, 255}));
  connect(sm.Pmss, sm.Pm_pu) annotation(
    Line(points = {{-88, 32}, {-90, 32}, {-90, 42}, {-102, 42}, {-102, 26}, {-92, 26}, {-92, 26}}, color = {0, 0, 127}));
  connect(st11.IFD, sm.Ifd_pu) annotation(
    Line(points = {{-124, -56}, {-126, -56}, {-126, -70}, {-74, -70}, {-74, 8}, {-74, 8}}, color = {0, 0, 127}));
  connect(firstOrder1.y, st11.VC) annotation(
    Line(points = {{-164, -76}, {-134, -76}, {-134, -56}, {-134, -56}}, color = {0, 0, 127}));
  connect(st11.VT, vdqToVt1.Ut) annotation(
    Line(points = {{-144, -52}, {-172, -52}, {-172, -38}, {-198, -38}, {-198, -38}, {-198, -38}}, color = {0, 0, 127}));
  connect(st11.VS, st11.VREF) annotation(
    Line(points = {{-144, -44}, {-152, -44}, {-152, -36}, {-144, -36}, {-144, -36}}, color = {0, 0, 127}));
  connect(Vf.y, st11.VREF) annotation(
    Line(points = {{-158, -14}, {-152, -14}, {-152, -36}, {-144, -36}, {-144, -36}}, color = {0, 0, 127}));
  connect(firstOrder1.u, vdqToVt1.Ut) annotation(
    Line(points = {{-188, -76}, {-194, -76}, {-194, -38}, {-198, -38}, {-198, -38}}, color = {0, 0, 127}));
  connect(vdqToVt1.Ud, sm.Vd_pu) annotation(
    Line(points = {{-222, -32}, {-234, -32}, {-234, -4}, {-90, -4}, {-90, 8}, {-88, 8}}, color = {0, 0, 127}));
  connect(vdqToVt1.Uq, sm.Vq_pu) annotation(
    Line(points = {{-222, -44}, {-228, -44}, {-228, -92}, {-76, -92}, {-76, -4}, {-84, -4}, {-84, 8}, {-84, 8}}, color = {0, 0, 127}));
  connect(sm.W_pu, governor_IEEEG1.W) annotation(
    Line(points = {{-79, 7}, {-79, 0}, {-182, 0}, {-182, 39}, {-169, 39}}, color = {0, 0, 127}));
  connect(LoadTransfo39.m, Load39.positivePlug) annotation(
    Line(points = {{64, -36}, {88, -36}, {88, -50}, {89, -50}}, color = {0, 0, 255}));
  connect(r.plug_n, g.positivePlug1) annotation(
    Line(points = {{18, 20}, {32, 20}, {32, 2}}, color = {0, 0, 255}));
  connect(breaker.k, sm.Pk) annotation(
    Line(points = {{-50, 20}, {-68, 20}, {-68, 20}, {-68, 20}}));
  connect(sw.pin_n, plug_b.pin_p) annotation(
    Line(points = {{4, 44}, {10, 44}, {10, 44}, {10, 44}}, color = {0, 0, 255}));
  connect(sw.pin_p, plug_a.pin_p) annotation(
    Line(points = {{-20, 44}, {-28, 44}, {-28, 44}, {-28, 44}}, color = {0, 0, 255}));
  connect(plug_a.plug_p, breaker.m) annotation(
    Line(points = {{-32, 44}, {-30, 44}, {-30, 20}, {-30, 20}}, color = {0, 0, 255}));
  connect(sm.Vfss, sm.Vfd) annotation(
    Line(points = {{-70, 8}, {-70, 8}, {-70, -14}, {-110, -14}, {-110, 16}, {-92, 16}, {-92, 16}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 0.4, Tolerance = 1e-05, Interval = 2.5e-06),
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=initialization ",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "ida"));
end SMEMTPTEST2;
