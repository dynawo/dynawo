within OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel;

model Load611
  extends OpenEMTP.UserGuide.Icons.Load;
    OpenEMTP.Electrical.Load_Models.SP_Qc_Load Cap611(
      Qc=100,
      V=4.16,
      f=60) annotation (Placement(visible=true, transformation(
          origin={-30, 58},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p
      annotation (Placement(visible = true, transformation(origin = {-2.5, 95}, extent = {{-8.5, -17}, {8.5, 17}}, rotation = 0), iconTransformation(origin = {0.5, 97}, extent = {{-6.5, -13}, {6.5, 13}}, rotation = 0)));
  Electrical.Load_Models.SP_PQ_Load pQ_Load(P = 170, QL = 80, Series = true, V = 0.986941 * 4.16, f = 60)  annotation(
      Placement(visible = true, transformation(origin = {22, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(pin_p, Cap611.pin_p) annotation(
    Line(points = {{-3, 95}, {-3, 67}, {-30, 67}}, color = {0, 140, 72}));
  connect(pQ_Load.pin_p, pin_p) annotation(
    Line(points = {{22, 58}, {20, 58}, {20, 95}, {-3, 95}}, color = {0, 0, 255}));
    annotation (Diagram, Icon);

end Load611;
