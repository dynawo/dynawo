within OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel;

model Load634
  extends OpenEMTP.UserGuide.Icons.Load;

    Electrical.Load_Models.SP_PQ_Load PQ_Load3(
      P= 120,
      QL= 90,
      Series=true,
      V=0.995862 * 0.48,
      f=60) annotation (Placement(visible=true, transformation(
          origin={42,0},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Connectors.Plug_c Plug_c2 annotation (Placement(visible=true, transformation(
          origin={28, 48},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    Electrical.Load_Models.SP_PQ_Load PQ_Load4(
      P= 120,
      QL= 90,
      Series=true,
      V=1.0218 * 0.48,
      f=60) annotation (Placement(visible=true, transformation(
          origin={8,0},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    Connectors.Plug_b Plug_b2 annotation (Placement(visible=true, transformation(
          origin={0,32},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    Electrical.Load_Models.SP_PQ_Load PQ_Load5(
      P= 160,
      QL= 110,
      Series=true,
      V=0.993805 * 0.48,
      f=60) annotation (Placement(visible=true, transformation(
          origin={-24,0},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    Connectors.Plug_a Plug_a2 annotation (Placement(visible=true, transformation(
          origin={-34,20},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Interfaces.MultiPhase.PositivePlug plug_p
      annotation (Placement(visible = true, transformation(extent = {{-110, 50}, {-90, 70}}, rotation = 0), iconTransformation(extent = {{-10, 86}, {10, 106}}, rotation = 0)));
  equation
    connect(Plug_b2.plug_p,Plug_a2. plug_p) annotation (
      Line(points={{-2.2,32},{-52,32},{-52,20},{-36.2,20},{-36.2,20}},            color = {0, 0, 255}));
  connect(Plug_c2.plug_p, Plug_b2.plug_p) annotation(
    Line(points = {{26, 48}, {-20, 48}, {-20, 32}, {-2.2, 32}}, color = {0, 0, 255}));
    connect(Plug_a2.pin_p,PQ_Load5. pin_p) annotation (
      Line(points={{-32,20.2},{-24,20.2},{-24,9},{-24,9}},            color = {0, 0, 255}));
    connect(Plug_b2.pin_p,PQ_Load4. pin_p) annotation (
      Line(points={{2,32.2},{8,32.2},{8,9},{8,9}},                    color = {0, 0, 255}));
  connect(Plug_c2.pin_p, PQ_Load3.pin_p) annotation(
    Line(points = {{30, 48}, {42, 48}, {42, 9}}, color = {0, 0, 255}));
    connect(plug_p, Plug_a2.plug_p) annotation (Line(points={{-100,60},{-68,60},{-68,20},
            {-36.2,20}}, color={0,0,255}));

end Load634;
