within Dynawo.Electrical.Wind.WECC.BaseClasses;
partial model BaseWT4A "Partial base model for WECC Wind Turbine 4A"
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGT;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGTb;
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BaseWT4;

  Dynawo.Electrical.Controls.WECC.Mechanical.WTGTb wecc_wtgt(
    Dshaft = Dshaft,
    Hg = Hg,
    Ht = Ht,
    tpWTGTb = tpWTGTb,
    Kshaft = Kshaft,
    PConv0Pu = PConv0Pu,
    PePu(start = PConv0Pu),
    omegaRefWTGQPu0 = omegaRefWTGQPu0) annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, -5}, {10, 5}}, rotation = 0)));

equation
  connect(wecc_wtgt.omegaGPu, wecc_reec.omegaGPu) annotation(
    Line(points = {{-86, -35}, {-85, -35}, {-85, -11}}, color = {0, 0, 127}));
  connect(LvMeasurements.PPu, wecc_wtgt.PePu) annotation(
    Line(points = {{62, -6}, {62, -40}, {-80, -40}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end BaseWT4A;
