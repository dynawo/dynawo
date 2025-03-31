within Dynawo.Examples.GridForming;

model TP_GFL_SMIB

parameter Dynawo.Types.Time tOmegaEvtStart = 11;
  parameter Dynawo.Types.Time tOmegaEvtEnd = 11.0001;
  parameter Dynawo.Types.Time tMagnitudeEvtstart = 20;
  parameter Dynawo.Types.Time tMagnitudeEvtEnd = 20 + 3;
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 1.04, UPhase = 0, omega0Pu = 1, omegaEvtPu = -1.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(transformation(origin = {82, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.000166667, XPu = 0.005) annotation(
    Placement(transformation(origin = {44, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-110, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(transformation(origin = {-110, -26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step PrefPu(height = 0.1, offset = 0.2, startTime = 8) annotation(
    Placement(transformation(origin = {-110, 38}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Loads.LoadZIP loadZIP(Ip = 0, Iq = 0, Pp = 0, Pq = 0, Zp = 1, Zq = 0, i0Pu = Complex(1, 0), s0Pu = Complex(-1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(transformation(origin = {34, -22}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.TP_GFL tp_gfl(SNom = 1000, Ki = 10, Kp = 2, OmegaMaxPu = 0.9, OmegaMinPu = 1.1, Kpd = 0.12, Kid = 2.25, Kpq = 0.12, Kiq = 2.25, tPFilt = 0.02, tQFilt = 0.02, Kpc = 0.477465, Kic = 15, Kfd = 0.8, Kfq = 0, RFilterPu = 0.015, XFilterPu = 0.15, BFilterPu = 1e-5, RTransformerPu = 0.006, XTransformerPu = 0.06, U0Pu = 0.9984, UPhase0 = 0.0374, P0Pu = -2, Q0Pu = 0) annotation(
    Placement(transformation(origin = {-31, -3}, extent = {{-21, -21}, {21, 21}})));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
//loadZIP connection
  loadZIP.deltaQ = 0;
  loadZIP.deltaP = 0;
  der(loadZIP.QRefPu) = 0;
  der(loadZIP.PRefPu) = 0;
  loadZIP.switchOffSignal1.value = if (time > 7) then true else false;
  loadZIP.switchOffSignal2.value = if (time > 7) then true else false;
  connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{54, -2}, {82, -2}}, color = {0, 0, 255}));
  connect(loadZIP.terminal, line.terminal1) annotation(
    Line(points = {{34, -22}, {34, -2}}, color = {0, 0, 255}));
  connect(tp_gfl.terminal, line.terminal1) annotation(
    Line(points = {{-8, -2}, {34, -2}}, color = {0, 0, 255}));
  connect(tp_gfl.PFilterRefPu, PrefPu.y) annotation(
    Line(points = {{-54, 14}, {-80, 14}, {-80, 38}, {-98, 38}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, tp_gfl.omegaRefPu) annotation(
    Line(points = {{-98, 6}, {-54, 6}}, color = {0, 0, 127}));
  connect(QRefPu.y, tp_gfl.QFilterRefPu) annotation(
    Line(points = {{-98, -26}, {-68, -26}, {-68, -12}, {-54, -12}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 16, Tolerance = 1e-06, Interval = 0.0016),
    Diagram,
    Documentation(info = "<html><head></head><body>Modèle GFL + SMIB&nbsp;<div><br></div><div>Enoncé du TP&nbsp;</div><div>- lancer une simulation et vérifier qu'elle se déroule sans problème</div><div>- naviguer dans les blocs de régulation afin de trouver les boucles de contrôles en courant du contrôle grid following</div><div>- ajouter un échelon à la référence de Idref (de 0.1Pu) à t=2s et Iqref (de 0.1Pu) à t=5s</div><div>- mesurer l'amplitude des perturbations et le temps mis par les grandeurs perturbées pour revenir sous 10% des perturbations</div><div>- expliquer le comportement de l'installation en se basant à la fois sur les simulations et sur les schémas blocs</div><div>- ajouter une charge RLC (Q=0)à t=7s</div><div>- mesurer l'amplitude de la perturbation de puissance active et le temps mis pour revenir sous 10% de la perturbation</div><div>- commenter le comportement de l'installation en puissance active et réactive en se basant sur le comportement attendu des différentes boucles de contrôle</div><div>- faire un échelon de consigne sur la puissance active de l'onduleur de 0.1 pu, illustrer le comportement et calculer les temps de montée à 90% des valeurs régulées</div><div>- ajouter un échelon d'angle de -5° à la source infinie</div><div>- mesurer l'amplitude de la perturbation de puissance active et le temps mis pour revenir sous 10% de la perturbation</div><div>- commenter le comportement de l'installation en puissance active et réactive en se basant sur le comportement attendu des différentes boucles de contrôle.&nbsp;</div><div><br></div><div><br></div><div>Résumé des perturbations :&nbsp;<br><div>A t=2s : ajout d'un échelon sur la référence Idref de 0.1Pu</div></div><div>A t=5s : ajout d'un échelon sur la référence Iqref de 0.1Pu</div><div>A t=7s : connexion d'une charge de 0.5*Pn et Q=0&nbsp;</div><div>A t=8s : ajout d'un échelon sur la consigne de puissance active de l'onduleur de 0.1Pu</div><div>A t=11s : saut de phase de -5° à la source infinie</div></body></html>"),
  uses(Dynawo(version = "1.8.0")));


end TP_GFL_SMIB;
