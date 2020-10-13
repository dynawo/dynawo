within OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel;

  model Load645
  extends OpenEMTP.UserGuide.Icons.Load;

    OpenEMTP.Electrical.Load_Models.SP_PQ_Load PQ645(
      P=170,
      QL=125,
      Series=true,
      V=1.03289*4.16,
      f=60) annotation (Placement(visible=true, transformation(
          origin={-2, 6},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_b(k=1, m=2) annotation (Placement(
          visible=true, transformation(
          origin={-2, 48},
          extent={{-10,-10},{10,10}},
          rotation=-90)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug plug_p(m = 2)
      annotation (Placement(visible = true, transformation(extent = {{-12, 90}, {8, 110}}, rotation = 0), iconTransformation(extent = {{-10, 84}, {10, 104}}, rotation = 0)));
  equation
    connect(Ph_b.pin_p, PQ645.pin_p) annotation(
    Line(points = {{-2, 46}, {-2, 15}}, color = {0, 0, 255}));
    connect(plug_p, Ph_b.plug_p) annotation(
    Line(points = {{-2, 100}, {-2, 50}}, color = {0, 0, 255}));
    annotation (Diagram, Icon);
  end Load645;
