within OpenEMTP.Examples.Machine;

model SMEMTPTest
  extends Modelica.Icons.Example;
  OpenEMTP.Electrical.Machines.SM_3rdOrder sm(Phi0 = zeros(4), d_theta0(displayUnit = "deg") = 0, dw0 = 0) annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Vf(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-252, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.R Ra(R = 1e6) annotation(
    Placement(visible = true, transformation(origin = {38, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.Plug_a plug_a annotation(
    Placement(visible = true, transformation(origin = {-24, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.R Rb(R = 1e6) annotation(
    Placement(visible = true, transformation(origin = {38, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.Plug_c plug_c annotation(
    Placement(visible = true, transformation(origin = {-24, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.Ground g annotation(
    Placement(visible = true, transformation(origin = {72, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.Plug_b plug_b annotation(
    Placement(visible = true, transformation(origin = {-24, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.R Rc(R = 1e6) annotation(
    Placement(visible = true, transformation(origin = {38, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Exciters_Governor.Governor_IEEEG1 governor_IEEEG1(K = 20, K1 = 0.2, K2 = 0, K3 = 0.4, K4 = 0, K5 = 0.4, K6 = 0, K7 = 0, K8 = 0, PMAX = 0.9, PMIN = 0, Pref = 1.1902151329941298E-5, T1 = 1e-15, T2 = 0, T3 = 0.075, T4 = 0.3, T5 = 10, T6 = 0.6, T7 = 1e-15, U0 = 0.6786, UC = -1)  annotation(
    Placement(visible = true, transformation(origin = {-142, 52}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  OpenEMTP.Electrical.Exciters_Governor.ST1 st1(EFSS = 1)  annotation(
    Placement(visible = true, transformation(origin = {-171, -43}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  OpenEMTP.NonElectrical.Blocks.VdqToVt vdqToVt annotation(
    Placement(visible = true, transformation(origin = {-124, -134}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 0.01, k = 1, y_start = 1)  annotation(
    Placement(visible = true, transformation(origin = {-190, -134}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-204, -190}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-310, -196}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant3(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-300, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-132, -184}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanStep booleanStep(startTime = Modelica.Constants.eps)  annotation(
    Placement(visible = true, transformation(origin = {-396, -162}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Switches.Breaker breaker(Tclosing = 0.1 * {1, 1, 1}, Topening = 0.16 * {1, 1, 1})  annotation(
    Placement(visible = true, transformation(origin = {-36, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground g1 annotation(
    Placement(visible = true, transformation(origin = {6, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Ra.p, plug_a.pin_p) annotation(
    Line(points = {{28, 80}, {-22, 80}, {-22, 80}, {-22, 80}}, color = {0, 0, 255}));
  connect(Ra.n, g.p) annotation(
    Line(points = {{48, 80}, {72, 80}, {72, 6}}, color = {0, 0, 255}));
  connect(Rb.p, plug_b.pin_p) annotation(
    Line(points = {{28, 20}, {-22, 20}, {-22, 20}, {-22, 20}}, color = {0, 0, 255}));
  connect(Rc.p, plug_c.pin_p) annotation(
    Line(points = {{28, -40}, {-22, -40}, {-22, -40}, {-22, -40}}, color = {0, 0, 255}));
  connect(Rb.n, g.p) annotation(
    Line(points = {{48, 20}, {72, 20}, {72, 6}}, color = {0, 0, 255}));
  connect(Rc.n, g.p) annotation(
    Line(points = {{48, -40}, {72, -40}, {72, 6}}, color = {0, 0, 255}));
  connect(plug_a.plug_p, sm.Pk) annotation(
    Line(points = {{-26, 80}, {-60, 80}, {-60, 20}, {-70, 20}, {-70, 20}}, color = {0, 0, 255}));
  connect(plug_b.plug_p, sm.Pk) annotation(
    Line(points = {{-26, 20}, {-70, 20}, {-70, 20}, {-70, 20}}, color = {0, 0, 255}));
  connect(plug_c.plug_p, sm.Pk) annotation(
    Line(points = {{-26, -40}, {-60, -40}, {-60, 20}, {-70, 20}, {-70, 20}}, color = {0, 0, 255}));
  connect(sm.W_pu, governor_IEEEG1.W) annotation(
    Line(points = {{-76, 10}, {-78, 10}, {-78, 0}, {-182, 0}, {-182, 39}, {-169, 39}}, color = {0, 0, 127}));
  connect(sm.Vd_pu, vdqToVt.Ud) annotation(
    Line(points = {{-84, 10}, {-84, -128}, {-112, -128}}, color = {0, 0, 127}));
  connect(sm.Vq_pu, vdqToVt.Uq) annotation(
    Line(points = {{-80, 10}, {-80, -140}, {-112, -140}}, color = {0, 0, 127}));
  connect(sm.Ifd_pu, st1.IFD) annotation(
    Line(points = {{-72, 10}, {-74, 10}, {-74, -92}, {-230, -92}, {-230, -44}, {-198, -44}, {-198, -44}}, color = {0, 0, 127}));
  connect(st1.VT, firstOrder.u) annotation(
    Line(points = {{-198, -60}, {-218, -60}, {-218, -108}, {-154, -108}, {-154, -134}, {-178, -134}, {-178, -134}}, color = {0, 0, 127}));
  connect(firstOrder.y, st1.VC) annotation(
    Line(points = {{-202, -134}, {-210, -134}, {-210, -82}, {-176, -82}, {-176, -70}, {-176, -70}}, color = {0, 0, 127}));
  connect(st1.VREF, Vf.y) annotation(
    Line(points = {{-200, -24}, {-242, -24}, {-242, -24}, {-240, -24}}, color = {0, 0, 127}));
  connect(constant3.y, switch1.u1) annotation(
    Line(points = {{-288, -150}, {-244, -150}, {-244, -182}, {-216, -182}, {-216, -182}}, color = {0, 0, 127}));
  connect(switch1.u3, constant2.y) annotation(
    Line(points = {{-216, -198}, {-298, -198}, {-298, -196}, {-298, -196}}, color = {0, 0, 127}));
  connect(switch1.y, add.u2) annotation(
    Line(points = {{-192, -190}, {-144, -190}}, color = {0, 0, 127}));
  connect(vdqToVt.Ut, add.u1) annotation(
    Line(points = {{-136, -134}, {-146, -134}, {-146, -176}, {-144, -176}, {-144, -178}}, color = {0, 0, 127}));
  connect(add.y, firstOrder.u) annotation(
    Line(points = {{-120, -184}, {-96, -184}, {-96, -158}, {-160, -158}, {-160, -134}, {-178, -134}, {-178, -134}}, color = {0, 0, 127}));
  connect(booleanStep.y, switch1.u2) annotation(
    Line(points = {{-384, -162}, {-342, -162}, {-342, -190}, {-216, -190}, {-216, -190}}, color = {255, 0, 255}));
  connect(sm.Vfd, st1.EFD) annotation(
    Line(points = {{-94, 14}, {-108, 14}, {-108, -26}, {-146, -26}, {-146, -26}}, color = {0, 0, 127}));
  connect(sm.Pm_pu, governor_IEEEG1.Pm) annotation(
    Line(points = {{-94, 28}, {-102, 28}, {-102, 60}, {-118, 60}, {-118, 58}}, color = {0, 0, 127}));
  connect(breaker.k, sm.Pk) annotation(
    Line(points = {{-46, 110}, {-70, 110}, {-70, 20}, {-70, 20}}, color = {0, 0, 255}));
  connect(breaker.m, g1.positivePlug1) annotation(
    Line(points = {{-26, 110}, {6, 110}, {6, 108}, {6, 108}}, color = {0, 0, 255}));
  connect(st1.VS, st1.VREF) annotation(
    Line(points = {{-152, -70}, {-122, -70}, {-122, -4}, {-196, -4}, {-196, -24}, {-200, -24}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-06, Interval = 5e-05),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=initialization ",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end SMEMTPTest;
