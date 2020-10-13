within OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel;

model Load692D
  extends OpenEMTP.UserGuide.Icons.Load;

  Interfaces.MultiPhase.PositivePlug plug_p annotation(
    Placement(visible = true, transformation(extent = {{-72, 22}, {-52, 42}}, rotation = 0), iconTransformation(extent = {{-12, 90}, {8, 110}}, rotation = 0)));
  Connectors.Plug_b Plug_b1 annotation(
    Placement(visible = true, transformation(origin = {14, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.Plug_a Plug_a1 annotation(
    Placement(visible = true, transformation(origin = {-32, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Load_Models.SP_PQ_Load PQ_Load2(Ground = true,P = 170, QL = 151, Series = true, V = 4.16 * 0.9777, f = 60) annotation(
    Placement(visible = true, transformation(origin = {-30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Plug_a1.pin_p, PQ_Load2.pin_p) annotation(
    Line(points = {{-30, -16}, {-30, -31}}, color = {0, 0, 255}));
  connect(plug_p, Plug_a1.plug_p) annotation(
    Line(points = {{-62, 32}, {-42, 32}, {-42, -16}, {-34, -16}}, color = {0, 0, 255}));
  connect(plug_p, Plug_b1.plug_p) annotation(
    Line(points = {{-62, 32}, {-6, 32}, {-6, 4}, {12, 4}}, color = {0, 0, 255}));
  connect(Plug_b1.pin_p, PQ_Load2.pin_n) annotation(
    Line(points = {{16, 4}, {24, 4}, {24, -60}, {-30, -60}, {-30, -48}, {-30, -48}}, color = {0, 0, 255}));
end Load692D;
