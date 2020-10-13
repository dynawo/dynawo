within OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel;

  model Load646Z
  extends OpenEMTP.UserGuide.Icons.Load;
    OpenEMTP.Electrical.Load_Models.SP_PQ_Load Load646(
      Ground=true,
      P=230,
      QL=132,
      Series=true,
      V=4.16,
      f=60) annotation (Placement(visible=true, transformation(
          origin={-28, 8},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Pha_b(k=1, m=2) annotation (
        Placement(visible=true, transformation(
          origin={2, 28},
          extent={{-10,-10},{10,10}},
          rotation=180)));
    Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Pha_c(k=2, m=2) annotation (
        Placement(visible=true, transformation(
          origin={2, -12},
          extent={{-10,-10},{10,10}},
          rotation=180)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug plug_p(m = 2)
      annotation (Placement(visible = true, transformation(extent = {{78, -2}, {138, 58}}, rotation = 0), iconTransformation(origin = {-1, 97}, extent = {{-15, -13}, {15, 13}}, rotation = 0)));
  equation
    connect(Pha_b.pin_p, Load646.pin_p) annotation(
      Line(points = {{0, 28}, {-28, 28}, {-28, 18}, {-28, 18}}, color = {0, 0, 255}));
  connect(Load646.pin_n, Pha_c.pin_p) annotation(
      Line(points = {{-28, 0}, {-28, 0}, {-28, -12}, {0, -12}, {0, -12}}, color = {0, 0, 255}));
  connect(Pha_b.plug_p, plug_p) annotation(
      Line(points = {{4, 28}, {102, 28}, {102, 28}, {108, 28}}, color = {0, 0, 255}));
  connect(Pha_c.plug_p, plug_p) annotation(
      Line(points = {{4, -12}, {40, -12}, {40, 28}, {108, 28}, {108, 28}}, color = {0, 0, 255}));
   annotation (Diagram, Icon);
  end Load646Z;
