within Dynawo.Examples.SMIB;

model SMIBGovHydro4Dc1c
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {232, 94}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant const1(k = dc1c.UOel0Pu) annotation(
    Placement(transformation(origin = {146, 80}, extent = {{-4, -4}, {4, 4}})));
  Electrical.Controls.Machines.Governors.Standard.Hydraulic.GovHydro4 governor(ATurb = 1, DTurb = 1.1, DeltaOmegaDbPu = 0, DeltaOmegaEpsPu = 0, DeltaPDbPu = 0, GMax = 5, GMin = 0, HDam = 1, ModelInt = 1, Pm0Pu = 2.85*100/generatorSynchronous.PNomTurb, QNl = 0, RPerm = 0.05, RTemp = 0.3, UC = -0.2, UO = 0.2, tG = 0.5, tP = 0.1, tR = 5, tW = 1) annotation(
    Placement(transformation(origin = {162, -26}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Constant omegaRef0(k = Electrical.SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {117, -26}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Sources.Constant UPssPu(k = 0) annotation(
    Placement(transformation(origin = {138, 14}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant UsRefPu(k = generatorSynchronous.U0Pu) annotation(
    Placement(transformation(origin = {110, 62}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.Machines.VoltageRegulators.Standard.Dc1c dc1c(AEx = 0.0001, BEx = 1.5, Ka = 100, Ke = 0.05, Kf = 0.05, PositionUel = 0, tA = 0.05, tB = 0.5, tC = 0.1, tE = 0.5, tF = 1, tR = 0.02, VrMaxPu = 5, VrMinPu = -5, EfdMinPu = 0, PositionOel = 0, PositionScl = 0, Efd0Pu = generatorSynchronous.Efd0Pu, Us0Pu = generatorSynchronous.U0Pu, UOel0Pu = 0, UUel0Pu = 0, USclOel0Pu = 0, USclUel0Pu = 0) annotation(
    Placement(transformation(origin = {184, 62}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.00072, XPu = 0.04) annotation(
    Placement(transformation(origin = {-34, 20}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Step PRefPu(offset = 0, startTime = 50, height = 0) annotation(
    Placement(transformation(origin = {94, -14}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant Omega0Pu(k = 1) annotation(
    Placement(transformation(origin = {-16, 70}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.InfiniteBus infiniteBus(UPu = 1, UPhase = 0) annotation(
    Placement(transformation(origin = {-84, 20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Examples.BaseClasses.InitializedGeneratorSynchronous generatorSynchronous(DPu = 0, ExcitationPu = Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad, H = 4, LDPPu = 0.19063, LQ1PPu = 0.165, LQ2PPu = 0.1, LdPPu = 0.15, LfPPu = 0.237322, LqPPu = 0.15, MdPPu = 1.85, MdPPuEfd = 1, MqPPu = 1.65, MrcPPu = 0, MsalPu = 0.2, P0Pu = 0, PNomAlt = 475, PNomTurb = 475, Q0Pu = 0, RDPPu = 0.0293282, RQ1PPu = 0.0696063, RQ2PPu = 0, RTfPu = 0, RaPPu = 0, RfPPu = 0.0013386, SNom = 500, SnTfo = 500, U0Pu = 0, UBaseHV = 21, UBaseLV = 21, UNom = 21, UNomHV = 21, UNomLV = 21, UPhase0 = 0, XTfPu = 0, md = 0, mq = 0, nd = 0, nq = 0) annotation(
    Placement(transformation(origin = {32, 20}, extent = {{-20, -20}, {20, 20}})));
  //initial algorithm
  Modelica.Blocks.Sources.Step PmPu(height = 0.1, offset = 0.6, startTime = 50) annotation(
    Placement(transformation(origin = {-20, -52}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant EfdPu(k = 3) annotation(
    Placement(transformation(origin = {-20, -22}, extent = {{-10, -10}, {10, 10}})));
initial equation
  der(generatorSynchronous.lambdafPu) = 0;
  der(generatorSynchronous.lambdaDPu) = 0;
  der(generatorSynchronous.lambdaQ1Pu) = 0;
  der(generatorSynchronous.lambdaQ2Pu) = 0;
  der(generatorSynchronous.theta) = 0;
  der(generatorSynchronous.omegaPu) = 0;
equation
  generatorSynchronous.switchOffSignal1 = false;
  generatorSynchronous.switchOffSignal2 = false;
  generatorSynchronous.switchOffSignal3 = false;
  line1.switchOffSignal1 = false;
  line1.switchOffSignal2 = false;
//transformer.switchOffSignal1 = false;
//transformer.switchOffSignal2 = false;
//connect(dc1c.running, generatorSynchronous.running);
//connect(generatorSynchronous.omegaPu, generatorSynchronous.omegaRefPu);
//connect(Omega0Pu.y, generatorSynchronous.omegaRefPu);
//connect(omegaRef0.y, generatorSynchronous.omegaRefPu);
  connect(omegaRef0.y, governor.omegaRefPu) annotation(
    Line(points = {{122.5, -26}, {138.5, -26}}, color = {0, 0, 127}));
  connect(const1.y, dc1c.UOelPu) annotation(
    Line(points = {{150, 80}, {160.4, 80}, {160.4, 70}, {172.4, 70}}, color = {0, 0, 127}));
  connect(const.y, dc1c.UUelPu) annotation(
    Line(points = {{227.6, 94}, {163.6, 94}, {163.6, 66}, {171.6, 66}}, color = {0, 0, 127}));
  connect(UsRefPu.y, dc1c.UsRefPu) annotation(
    Line(points = {{121, 62}, {171, 62}}, color = {0, 0, 127}));
  connect(UPssPu.y, dc1c.UPssPu) annotation(
    Line(points = {{149, 14}, {161, 14}, {161, 54}, {171, 54}}, color = {0, 0, 127}));
  connect(dc1c.USclOelPu, const.y) annotation(
    Line(points = {{196, 70}, {214, 70}, {214, 94}, {228, 94}}, color = {0, 0, 127}));
  connect(dc1c.USclUelPu, const.y) annotation(
    Line(points = {{196, 66}, {214, 66}, {214, 94}, {228, 94}}, color = {0, 0, 127}));
  connect(PRefPu.y, governor.PRefPu) annotation(
    Line(points = {{105, -14}, {137, -14}}, color = {0, 0, 127}));
  connect(line1.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-54, 20}, {-84, 20}}, color = {0, 0, 255}));
  connect(generatorSynchronous.terminal, line1.terminal2) annotation(
    Line(points = {{32, 20}, {-14, 20}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaPu, governor.omegaPu) annotation(
    Line(points = {{50, 14}, {70, 14}, {70, -38}, {138, -38}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UStatorPu, dc1c.UsPu) annotation(
    Line(points = {{50, 38}, {136, 38}, {136, 58}, {172, 58}}, color = {0, 0, 127}));
  connect(Omega0Pu.y, generatorSynchronous.omegaRefPu) annotation(
    Line(points = {{-4, 70}, {0, 70}, {0, 28}, {10, 28}}, color = {0, 0, 127}));
  connect(governor.PmPu, generatorSynchronous.PmPu) annotation(
    Line(points = {{186, -26}, {202, -26}, {202, -54}, {44, -54}, {44, -2}}, color = {0, 0, 127}));
  connect(dc1c.EfdPu, generatorSynchronous.efdPu) annotation(
    Line(points = {{196, 62}, {212, 62}, {212, -62}, {20, -62}, {20, -2}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-300, -200}, {300, 200}})),
    Icon(coordinateSystem(extent = {{-300, -200}, {300, 200}})),
    version = "",
    uses(Dynawo(version = "2.0.0"), Modelica(version = "3.2.3")),
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.005),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --allowNonStandardModelica=implicitParameterStartAttribute,illegalConditionalContext --allowNonStandardModelica=implicitParameterStartAttribute,illegalConditionalContext --allowNonStandardModelica=implicitParameterStartAttribute,illegalConditionalContext --allowNonStandardModelica=implicitParameterStartAttribute,illegalConditionalContext --allowNonStandardModelica=implicitParameterStartAttribute,illegalConditionalContext --allowNonStandardModelica=implicitParameterStartAttribute,illegalConditionalContext --allowNonStandardModelica=implicitParameterStartAttribute,illegalConditionalContext --allowNonStandardModelica=implicitParameterStartAttribute,illegalConditionalContext --allowNonStandardModelica=implicitParameterStartAttribute,illegalConditionalContext --allowNonStandardModelica=implicitParameterStartAttribute,illegalConditionalContext,--daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"));
end SMIBGovHydro4Dc1c;
