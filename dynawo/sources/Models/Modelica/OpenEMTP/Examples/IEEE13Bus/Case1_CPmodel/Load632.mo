within OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel;

  model Load632
  extends OpenEMTP.UserGuide.Icons.Load;
  OpenEMTP.Electrical.Load_Models.SP_PQ_Load Load632_c(P = 117 * 0.5, QL = 68 * 0.5, Series = true, V = 4.16 * 1.0174) annotation(
      Placement(visible = true, transformation(origin = {64, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Plug_c plug_c1 annotation(
      Placement(visible = true, transformation(origin = {50, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Load_Models.SP_PQ_Load Load632_a(P = 17 * 0.5, QL = 10 * 0.5, Series = true, V = 4.16 * 1.021, f = 60) annotation(
      Placement(visible = true, transformation(origin = {-6, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Load_Models.SP_PQ_Load Load632_b(P = 66 * 0.5, QL = 38 * 0.5, Series = true, V = 4.16 * 1.042, f = 60) annotation(
      Placement(visible = true, transformation(origin = {30, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Plug_a plug_a annotation(
      Placement(visible = true, transformation(origin = {-12, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Plug_b plug_b annotation(
      Placement(visible = true, transformation(origin = {20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Interfaces.MultiPhase.PositivePlug positivePlug annotation(
      Placement(visible = true, transformation(origin = {-96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { 0, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(plug_c1.pin_p, Load632_c.pin_p) annotation(
      Line(points = {{52, 4}, {64, 4}, {64, -22}, {64, -22}}, color = {0, 0, 255}));
  connect(plug_b.pin_p, Load632_b.pin_p) annotation(
      Line(points = {{22, 0}, {30, 0}, {30, -22}, {30, -22}}, color = {0, 0, 255}));
  connect(plug_a.pin_p, Load632_a.pin_p) annotation(
      Line(points = {{-10, -12}, {-6, -12}, {-6, -22}, {-6, -22}}, color = {0, 0, 255}));
  connect(plug_a.plug_p, positivePlug) annotation(
      Line(points = {{-14, -12}, {-94, -12}, {-94, 0}, {-96, 0}}, color = {0, 0, 255}));
  connect(plug_b.plug_p, positivePlug) annotation(
      Line(points = {{18, 0}, {-94, 0}, {-94, 0}, {-96, 0}}, color = {0, 0, 255}));
  connect(plug_c1.plug_p, positivePlug) annotation(
      Line(points = {{48, 4}, {-94, 4}, {-94, 0}, {-96, 0}}, color = {0, 0, 255}));
  end Load632;
