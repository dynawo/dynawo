within OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel;

  model Load671Y
  extends OpenEMTP.UserGuide.Icons.Load;

    OpenEMTP.Electrical.Load_Models.SP_PQ_Load PQ_Load(
      P=117*0.5,
      QL=68*0.5,
      Series=true,
      V=4.16*0.978043,
      f=60) annotation (Placement(visible=true, transformation(
          origin={70, -40},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Connectors.Plug_c Plug_c1 annotation (Placement(visible=true, transformation(
          origin={44, 32},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Electrical.Load_Models.SP_PQ_Load PQ_Load1(
      P=66*0.5,
      QL=38*0.5,
      Series=true,
      V=4.16*1.0519,
      f=60) annotation (Placement(visible=true, transformation(
          origin={22, -40},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Connectors.Plug_b Plug_b1 annotation (Placement(visible=true, transformation(
          origin={14, 4},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Electrical.Load_Models.SP_PQ_Load PQ_Load2(
      P=17*0.5,
      QL=10*0.5,
      Series=true,
      V=4.16*0.987076,
      f=60) annotation (Placement(visible=true, transformation(
          origin={-30, -40},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Connectors.Plug_a Plug_a1 annotation (Placement(visible=true, transformation(
          origin={-32, -16},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Interfaces.MultiPhase.PositivePlug plug_p
      annotation (Placement(visible = true, transformation(extent = {{-72, 22}, {-52, 42}}, rotation = 0), iconTransformation(extent = {{-12, 90}, {8, 110}}, rotation = 0)));
  equation
  connect(Plug_c1.pin_p, PQ_Load.pin_p) annotation(
    Line(points = {{46, 32}, {70, 32}, {70, -31}}, color = {0, 0, 255}));
  connect(Plug_b1.pin_p, PQ_Load1.pin_p) annotation(
    Line(points = {{16, 4}, {22, 4}, {22, -31}}, color = {0, 0, 255}));
  connect(Plug_a1.pin_p, PQ_Load2.pin_p) annotation(
    Line(points = {{-30, -16}, {-30, -31}}, color = {0, 0, 255}));
  connect(plug_p, Plug_a1.plug_p) annotation(
    Line(points = {{-62, 32}, {-42, 32}, {-42, -16}, {-34, -16}}, color = {0, 0, 255}));
  connect(plug_p, Plug_b1.plug_p) annotation(
    Line(points = {{-62, 32}, {-6, 32}, {-6, 4}, {12, 4}}, color = {0, 0, 255}));
  connect(plug_p, Plug_c1.plug_p) annotation(
    Line(points = {{-62, 32}, {42, 32}}, color = {0, 0, 255}));
    annotation (Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-18, 85}, extent = {{-12, 7}, {66, -9}}, textString = "[ 0.987076 1.0519 0.978043]*2401.78
[17 66  117]*1e3/2
[10 38  68]*1e3/2")}), Icon);
  end Load671Y;
