within OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel;

  model Load675Y
  extends OpenEMTP.UserGuide.Icons.Load;

    OpenEMTP.Connectors.Plug_c Plug_c3 annotation (Placement(visible=true, transformation(
          origin={32, 0},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Electrical.Load_Models.SP_PQ_Load PQ_Load6(
      P=290,
      QL=212,
      Series=true,
      V=4.16*0.975983,
      f=60) annotation (Placement(visible=true, transformation(
          origin={46, -36},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Connectors.Plug_b Plug_b3 annotation (Placement(visible=true, transformation(
          origin={10, -12},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Electrical.Load_Models.SP_PQ_Load PQ_Load7(
      P=68,
      QL=60,
      Series=true,
      V=4.16*1.05431,
      f=60) annotation (Placement(visible=true, transformation(
          origin={12, -36},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Electrical.Load_Models.SP_PQ_Load PQ_Load8(
      P=485,
      QL=190,
      Series=true,
      V=4.16*0.98063,
      f=60) annotation (Placement(visible=true, transformation(
          origin={-20, -36},
          extent={{-10, -10}, {10, 10}},
          rotation=0)));
    OpenEMTP.Connectors.Plug_a Plug_a3 annotation (Placement(visible=true, transformation(
          origin={-30, -16},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Interfaces.MultiPhase.PositivePlug plug_p
      annotation (Placement(visible = true, transformation(origin = {-68, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {1, 97}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  OpenEMTP.Electrical.Load_Models.Qc_Load qc_Load(Qc = 200 * {1, 1, 1} * 1e-3, V = 4.16, f = 60)  annotation(
    Placement(visible = true, transformation(origin = {-72, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));  equation
  connect(Plug_c3.plug_p, Plug_b3.plug_p) annotation(
    Line(points = {{30, 0}, {-10, 0}, {-10, -12}, {8, -12}}, color = {0, 0, 255}));
    connect(Plug_a3.plug_p, Plug_c3.plug_p) annotation(
    Line(points = {{-32, -16}, {-42, -16}, {-42, 0}, {30, 0}}, color = {0, 0, 255}));
    connect(Plug_a3.pin_p, PQ_Load8.pin_p) annotation(
    Line(points = {{-28, -16}, {-28, -14.5}, {-20, -14.5}, {-20, -27}}, color = {0, 0, 255}));
  connect(Plug_b3.pin_p, PQ_Load7.pin_p) annotation(
    Line(points = {{12, -12}, {12, -27}}, color = {0, 0, 255}));
    connect(Plug_c3.pin_p, PQ_Load6.pin_p) annotation(
    Line(points = {{34, 0}, {46, 0}, {46, -27}}, color = {0, 0, 255}));
    connect(plug_p, Plug_c3.plug_p) annotation(
    Line(points = {{-68, 100}, {-68, 0}, {30, 0}}, color = {0, 0, 255}));
  connect(qc_Load.positivePlug, Plug_a3.plug_p) annotation(
    Line(points = {{-66, -28}, {-66, -28}, {-66, -16}, {-32, -16}, {-32, -16}}, color = {0, 0, 255}));
    annotation (Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {44, 39}, extent = {{-54, 17}, {26, -5}}, textString = "[ 0.98063 1.05431 0.975983]*2401.78
[485  68  290]*1e3
[190  60  212]*1e3")}), Icon);
  end Load675Y;
