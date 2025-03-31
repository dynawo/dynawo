within Dynawo.Examples.GridForming;

model TP_GFM_Droop_SMIB

  parameter Types.Time tOmegaEvtStart = 3;
  parameter Types.Time tOmegaEvtEnd = 3.0001;
  parameter Types.Time tMagnitudeEvtstart = 20;
  parameter Types.Time tMagnitudeEvtEnd = 20 + 3 annotation(
    Placement(visible = false, transformation(extent = {{0, 0}, {0, 0}})));

  Dynawo.Electrical.PEIR.Converters.General.Average.GridForming.DynGFMDroop GFMDroop(CFilterPu = 1e-5, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, Kic = 15, KpVI = 0.6, Kpc = 0.477465, LFilterPu = 0.15, LTransformerPu = 0.06, Mp = 0.0064, Mq = 0.2, OmegaSetPu = 1, P0Pu = -2, Q0Pu = 0, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.9984, UPhase0 = 0.0374, Wf = 31.4159, WfDroop = 26, Wff = 60, XRratio = 10, XVI = 0, tVSC = 0.0004) annotation(
    Placement(transformation(origin = {-6, 0}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 1.04, UPhase = 0, omega0Pu = 1, omegaEvtPu = -1.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(transformation(origin = {84, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.000166667, XPu = 0.005) annotation(
    Placement(transformation(origin = {46, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step PRefPu(height = 0.65, offset = 0.2, startTime = 1) annotation(
    Placement(transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Loads.LoadZIP loadZIP(u0Pu = Complex(0.9984, 0.374), s0Pu = Complex(-2, 0), i0Pu = Complex(0.99, 0), Zp = 1, Ip = 0, Pp = 0, Zq = 0, Iq = 0, Pq = 0)  annotation(
    Placement(transformation(origin = {36, -28}, extent = {{-10, -10}, {10, 10}})));

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  GFMDroop.switchOffSignal1.value = false;
  GFMDroop.switchOffSignal2.value = false;
  GFMDroop.switchOffSignal3.value = false;

 // Load appearance at t=2s
  loadZIP.deltaQ = 0;
  loadZIP.deltaP = 0;
  der(loadZIP.PRefPu) = 0;
  der(loadZIP.QRefPu) = 0;
  loadZIP.switchOffSignal1.value = if (time > 2) then true else false;
  loadZIP.switchOffSignal2.value = if (time > 2) then true else false;


  connect(GFMDroop.terminal, line.terminal1) annotation(
    Line(points = {{16, 0}, {36, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{56, 0}, {84, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, GFMDroop.omegaRefPu) annotation(
    Line(points = {{-99, 20}, {-63.5, 20}, {-63.5, 8}, {-28, 8}}, color = {0, 0, 127}));
  connect(PRefPu.y, GFMDroop.PFilterRefPu) annotation(
    Line(points = {{-99, 60}, {-38, 60}, {-38, 16}, {-28, 16}}, color = {0, 0, 127}));
  connect(QRefPu.y, GFMDroop.QFilterRefPu) annotation(
    Line(points = {{-99, -20}, {-65, -20}, {-65, -8}, {-28, -8}}, color = {0, 0, 127}));
  connect(URefPu.y, GFMDroop.UFilterRefPu) annotation(
    Line(points = {{-99, -60}, {-39, -60}, {-39, -16}, {-28, -16}}, color = {0, 0, 127}));
  connect(loadZIP.terminal, line.terminal1) annotation(
    Line(points = {{36, -28}, {36, 0}}, color = {0, 0, 255}));
annotation(
    experiment(StartTime = 0, StopTime = 4, Tolerance = 1e-06, Interval = 0.002),
  Documentation(info = "<html><head></head><body>Modèle GFM + SMIB<div><br></div><div>Enoncé du TP :&nbsp;</div><div><br></div><div>- Vérifier que la puissance active de l'onduleur est modifiée à t=1s</div><div>- illustrer le comportement et calculer le temps de montée à 90% des valeurs régulées</div><div>- modifier la charge RLC qui se connecte à t=2s pour qu'elle ait une puissance égale à 0.5*Pn</div><div>- mesurer l'amplitude de la perturbation de puissance active et le temps mis pour revenir sous 10% de la perturbation</div><div>- ajouter un échelon d'angle de -5° à la source infinie</div><div>- mesurer l'amplitude de la perturbation de puissance active et le temps mis pour revenir sous 10% de la perturbation</div><div>- commenter le comportement de l'installation en puissance active</div><div><br></div><div><br></div><div>Résumé des perturbations :&nbsp;</div><div><br></div><div>A t = 1s, step de puissance active de référence qui passe de 0.2pu à 0.85pu</div><div>A t = 2s, apparition d'une charge égale à Pn/2</div><div>A t = 3s, saut de phase du bus infini</div></body></html>"));
end TP_GFM_Droop_SMIB;
