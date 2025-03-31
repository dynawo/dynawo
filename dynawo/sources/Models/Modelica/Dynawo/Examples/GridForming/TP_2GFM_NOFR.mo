within Dynawo.Examples.GridForming;

model TP_2GFM_NOFR
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMDroop GFMDroop(CFilterPu = 1e-5, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, Kic = 15, KpVI = 0.6, Kpc = 0.477465, LFilterPu = 0.15, LTransformerPu = 0.06, Mp = 0.0064, Mq = 0.2, OmegaSetPu = 1, P0Pu = 3.4663, Q0Pu = 0.4, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, Wf = 31.4159, WfDroop = 26, Wff = 60, XRratio = 10, XVI = 0.25, tVSC = 0.0004) annotation(
    Placement(transformation(origin = {62, 0}, extent = {{20, -20}, {-20, 20}}, rotation = -0)));
  Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.005/10, XPu = 0.05/10) annotation(
    Placement(transformation(origin = {-16, 0}, extent = {{-12, -12}, {12, 12}})));
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(transformation(origin = {18, 0}, extent = {{-12, -12}, {12, 12}})));
  Electrical.Loads.LoadZIP loadZIP(Ip = 0, Iq = 0, Pp = 0, Pq = 0, Zp = 1, Zq = 0, i0Pu = Complex(0.99, 0), s0Pu = Complex(4, 0), u0Pu = Complex(1, 0.056)) annotation(
    Placement(transformation(origin = {-4, -18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(transformation(origin = {-105, -9}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(transformation(origin = {-105, -27}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-105, 7}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Sources.Constant PrefPu11(k = 0.3) annotation(
    Placement(transformation(origin = {-105, 25}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Sources.Constant QRefPu1(k = 0) annotation(
    Placement(transformation(origin = {105, -9}, extent = {{-5, -5}, {5, 5}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant URefPu1(k = 1) annotation(
    Placement(transformation(origin = {105, -25}, extent = {{-5, -5}, {5, 5}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu1(k = 1) annotation(
    Placement(transformation(origin = {105, 9}, extent = {{-5, -5}, {5, 5}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PrefPu1(k = 0.8) annotation(
    Placement(transformation(origin = {105, 25}, extent = {{-5, -5}, {5, 5}}, rotation = 180)));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMDroop_NOFR dynGFMDroop_NOFR(CFilterPu = 1e-5, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, Kic = 15, KpVI = 0.6, Kpc = 0.477465, LFilterPu = 0.15, LTransformerPu = 0.06, Mp = 0.0064, Mq = 0.2, OmegaSetPu = 1, P0Pu = 3.4663, Q0Pu = 0.4, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, Wf = 31.4159, WfDroop = 26, Wff = 60, XRratio = 10, XVI = 0.25, tVSC = 0.0004) annotation(
    Placement(transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -0)));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  loadZIP.switchOffSignal1.value = false;
  loadZIP.switchOffSignal2.value = false;
  GFMDroop.switchOffSignal1.value = false;
  GFMDroop.switchOffSignal2.value = false;
  GFMDroop.switchOffSignal3.value = false;
  loadZIP.deltaQ = 0;
  der(loadZIP.QRefPu) = 0;
  loadZIP.PRefPu = 4;
  when time >= 9 then
    loadZIP.deltaP = 0.4;
  end when;
  connect(line1.terminal2, line.terminal1) annotation(
    Line(points = {{-4, 0}, {6, 0}}, color = {0, 0, 255}));
  connect(loadZIP.terminal, line1.terminal2) annotation(
    Line(points = {{-4, -18}, {-4, 0}}, color = {0, 0, 255}));
  connect(line.terminal1, line1.terminal2) annotation(
    Line(points = {{6, 0}, {-4, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, GFMDroop.terminal) annotation(
    Line(points = {{30, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(GFMDroop.PFilterRefPu, PrefPu1.y) annotation(
    Line(points = {{84, 16}, {90, 16}, {90, 26}, {100, 26}}, color = {0, 0, 127}));
  connect(GFMDroop.omegaRefPu, omegaRefPu1.y) annotation(
    Line(points = {{84, 8}, {94, 8}, {94, 10}, {100, 10}}, color = {0, 0, 127}));
  connect(QRefPu1.y, GFMDroop.QFilterRefPu) annotation(
    Line(points = {{100, -8}, {84, -8}}, color = {0, 0, 127}));
  connect(GFMDroop.UFilterRefPu, URefPu1.y) annotation(
    Line(points = {{84, -16}, {90, -16}, {90, -24}, {100, -24}}, color = {0, 0, 127}));
  connect(dynGFMDroop_NOFR.terminal, line1.terminal1) annotation(
    Line(points = {{-38, 0}, {-28, 0}}, color = {0, 0, 255}));
  connect(dynGFMDroop_NOFR.PFilterRefPu, PrefPu11.y) annotation(
    Line(points = {{-82, 16}, {-90, 16}, {-90, 26}, {-100, 26}}, color = {0, 0, 127}));
  connect(dynGFMDroop_NOFR.omegaRefPu, omegaRefPu.y) annotation(
    Line(points = {{-82, 8}, {-100, 8}}, color = {0, 0, 127}));
  connect(dynGFMDroop_NOFR.QFilterRefPu, QRefPu.y) annotation(
    Line(points = {{-82, -8}, {-100, -8}}, color = {0, 0, 127}));
  connect(dynGFMDroop_NOFR.UFilterRefPu, URefPu.y) annotation(
    Line(points = {{-82, -16}, {-90, -16}, {-90, -26}, {-100, -26}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.002),
  Documentation(info = "<html><head></head><body>Modèle 2 GFM : un sans régulation de fréquence et l'autre avec<div><br></div><div>Enoncé du TP :&nbsp;</div><div>- Supprimer le réglage de fréquence sur l'un des deux onduleurs, et laisser la simulation se dérouler, comparer le comportement par rapport à la simulation précédente.&nbsp;</div><div><br></div><div>La charge varie à t = 9s.&nbsp;</div></body></html>"));


end TP_2GFM_NOFR;
