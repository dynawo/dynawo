within Dynawo.Examples.SMIB.Standard;

model GovHydro4Dc1c
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {150, 80}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant const1(k = dc1c.UOel0Pu) annotation(
    Placement(transformation(origin = {52, 68}, extent = {{-4, -4}, {4, 4}})));
  Electrical.Controls.Machines.Governors.Standard.Hydraulic.GovHydro4 governor(ATurb = 1.2, DTurb = 1.1, DeltaOmegaDbPu = 0, DeltaOmegaEpsPu = 0, DeltaPDbPu = 0, GMax = 1, GMin = 0, HDam = 1, ModelInt = 1, Pm0Pu = 2.85*100/generatorSynchronous.PNomTurb, QNl = 0, RPerm = 0.05, RTemp = 0.3, UC = -0.2, UO = 0.2, tG = 0.5, tP = 0.1, tR = 5, tW = 1) annotation(
    Placement(transformation(origin = {80, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Constant omegaRef0(k = Electrical.SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {35, -40}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Sources.Constant PRef0(k = governor.PRef0Pu) annotation(
    Placement(transformation(origin = {35, -20}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Sources.Constant UPssPu(k = 0) annotation(
    Placement(transformation(origin = {56, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant UsRefPu(k = generatorSynchronous.U0Pu) annotation(
    Placement(transformation(origin = {30, 48}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Loads.LoadAlphaBeta load(alpha = 2, beta = 2, i0Pu(im(fixed = false), re(fixed = false)), s0Pu(im(fixed = false), re(fixed = false)), u0Pu(im(fixed = false), re(fixed = false))) annotation(
    Placement(transformation(origin = {-60, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step PRefPu(height = 0.1*generatorSynchronous.PNomAlt/100, offset = 2.85, startTime = 10) annotation(
    Placement(transformation(origin = {-138, -44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(transformation(origin = {-30, -50}, extent = {{10, -10}, {-10, 10}})));
  Electrical.Loads.Load_INIT load_INIT(P0Pu = PRefPu.offset, Q0Pu = QRefPu.k, U0Pu = generatorSynchronous.U0Pu, UPhase0 = generatorSynchronous.UPhase0) annotation(
    Placement(transformation(origin = {-190, 70}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.Machines.VoltageRegulators.Standard.Dc1c dc1c(AEx = 0.0001, BEx = 1.5, Ka = 1000, Ke = 0.05, Kf = 0.05, PositionUel = 0, tA = 0.05, tB = 0.5, tC = 0.1, tE = 0.5, tF = 1, tR = 0.02, VrMaxPu = 5, VrMinPu = -5, EfdMinPu = 0, PositionOel = 0, PositionScl = 0, Efd0Pu = generatorSynchronous.Efd0Pu, Us0Pu = generatorSynchronous.U0Pu, UOel0Pu = 0) annotation(
    Placement(transformation(origin = {102, 48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add(k1 = +1, k2 = +1) annotation(
    Placement(transformation(origin = {-82, -68}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step PRefPu1(offset = 0, startTime = 60, height = 0.1*generatorSynchronous.PNomAlt/100) annotation(
    Placement(transformation(origin = {-138, -78}, extent = {{-10, -10}, {10, 10}})));
  Examples.BaseClasses.InitializedGeneratorSynchronous generatorSynchronous(DPu = 0, ExcitationPu = Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad, H = 4, LDPPu = 0.19063, LQ1PPu = 0.165, LQ2PPu = 1e5, LdPPu = 0.15, LfPPu = 0.237322, LqPPu = 0.15, MdPPu = 1.85, MdPPuEfd = 1, MqPPu = 1.65, MrcPPu = 0, MsalPu = 0.2, P0Pu = -2.85, PNomAlt = 475, PNomTurb = 475, Q0Pu = 0, RDPPu = 0.0293282, RQ1PPu = 0.0696063, RQ2PPu = 0, RTfPu = 0, RaPPu = 0, RfPPu = 0.0013386, SNom = 500, SnTfo = 500, U0Pu = 1, UBaseHV = 400, UBaseLV = 21, UNom = 21, UNomHV = 400, UNomLV = 21, UPhase0 = 0, XTfPu = 0, md = 0, mq = 0, nd = 0, nq = 0) annotation(
    Placement(transformation(origin = {-8, 4}, extent = {{-20, -20}, {20, 20}})));
initial algorithm
  load.i0Pu.re := load_INIT.i0Pu.re;
  load.i0Pu.im := load_INIT.i0Pu.im;
  load.s0Pu.re := load_INIT.s0Pu.re;
  load.s0Pu.im := load_INIT.s0Pu.im;
  load.u0Pu.re := load_INIT.u0Pu.re;
  load.u0Pu.im := load_INIT.u0Pu.im;
equation
  generatorSynchronous.switchOffSignal1 = false;
  generatorSynchronous.switchOffSignal2 = false;
  generatorSynchronous.switchOffSignal3 = false;
  load.switchOffSignal1 = false;
  load.switchOffSignal2 = false;
  load.deltaP = 0;
  load.deltaQ = 0;
//connect(dc1c.running, generatorSynchronous.running);
  connect(generatorSynchronous.omegaPu, generatorSynchronous.omegaRefPu);
  connect(PRef0.y, governor.PRefPu) annotation(
    Line(points = {{40.5, -20}, {49.5, -20}, {49.5, -28}, {56.5, -28}}, color = {0, 0, 127}));
  connect(omegaRef0.y, governor.omegaRefPu) annotation(
    Line(points = {{40.5, -40}, {56.5, -40}}, color = {0, 0, 127}));
  connect(const1.y, dc1c.UOelPu) annotation(
    Line(points = {{56, 68}, {74, 68}, {74, 56}, {90, 56}}, color = {0, 0, 127}));
  connect(const.y, dc1c.UUelPu) annotation(
    Line(points = {{146, 80}, {82, 80}, {82, 52}, {90, 52}}, color = {0, 0, 127}));
  connect(UsRefPu.y, dc1c.UsRefPu) annotation(
    Line(points = {{41, 48}, {90, 48}}, color = {0, 0, 127}));
  connect(UPssPu.y, dc1c.UPssPu) annotation(
    Line(points = {{68, 0}, {80, 0}, {80, 40}, {90, 40}}, color = {0, 0, 127}));
  connect(dc1c.USclOelPu, const.y) annotation(
    Line(points = {{114, 56}, {132, 56}, {132, 80}, {146, 80}}, color = {0, 0, 127}));
  connect(dc1c.USclUelPu, const.y) annotation(
    Line(points = {{114, 52}, {132, 52}, {132, 80}, {146, 80}}, color = {0, 0, 127}));
  connect(PRefPu.y, add.u1) annotation(
    Line(points = {{-127, -44}, {-110, -44}, {-110, -62}, {-94, -62}}, color = {0, 0, 127}));
  connect(add.u2, PRefPu1.y) annotation(
    Line(points = {{-94, -74}, {-120, -74}, {-120, -78}, {-127, -78}}, color = {0, 0, 127}));
  connect(add.y, load.PRefPu) annotation(
    Line(points = {{-70, -68}, {-64, -68}, {-64, -28}}, color = {0, 0, 127}));
  connect(QRefPu.y, load.QRefPu) annotation(
    Line(points = {{-40, -50}, {-56, -50}, {-56, -28}}, color = {0, 0, 127}));
  connect(load.terminal, generatorSynchronous.terminal) annotation(
    Line(points = {{-60, -20}, {-60, 4}, {-8, 4}}, color = {0, 0, 255}));
  connect(governor.PmPu, generatorSynchronous.PmPu) annotation(
    Line(points = {{104, -40}, {128, -40}, {128, -76}, {4, -76}, {4, -18}}, color = {0, 0, 127}));
  connect(generatorSynchronous.efdPu, dc1c.EfdPu) annotation(
    Line(points = {{-20, -18}, {-20, -32}, {-2, -32}, {-2, -82}, {152, -82}, {152, 48}, {114, 48}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UStatorPu, dc1c.UsPu) annotation(
    Line(points = {{10, 22}, {54, 22}, {54, 44}, {90, 44}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu, governor.omegaPu) annotation(
    Line(points = {{10, -2}, {22, -2}, {22, -52}, {56, -52}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    version = "",
    uses(Dynawo(version = "2.0.0"), Modelica(version = "3.2.3")),
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.01));
end GovHydro4Dc1c;
