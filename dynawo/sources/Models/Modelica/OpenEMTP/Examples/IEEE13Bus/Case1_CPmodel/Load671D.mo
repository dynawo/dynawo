within OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel;

model Load671D
  extends OpenEMTP.UserGuide.Icons.Load;

    OpenEMTP.Electrical.Load_Models.SP_PQ_Load PQ_Load3(
      Ground = true,P=385,
      QL=220,
      Series=true,
      V=4.16*1.71484,
      f=60) annotation (Placement(visible=true, transformation(
          origin={52, -14},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    Connectors.Plug_c Plug_c2 annotation (Placement(visible=true, transformation(
          origin={28,40},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Electrical.Load_Models.SP_PQ_Load PQ_Load4(
      Ground = true,P=385,
      QL=220,
      Series=true,
      V=4.16*1.77224,
      f=60) annotation (Placement(visible=true, transformation(
          origin={10, -14},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    Connectors.Plug_b Plug_b2 annotation (Placement(visible=true, transformation(
          origin={0,32},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    OpenEMTP.Electrical.Load_Models.SP_PQ_Load PQ_Load5(
      Ground = true,P=385,
      QL=220,
      Series=true,
      V=4.16*1.73773,
      f=60) annotation (Placement(visible=true, transformation(
          origin={-24, -14},
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
    connect(Plug_c2.plug_p,Plug_b2. plug_p) annotation (
      Line(points={{25.8,40},{-20,40},{-20,32},{-2.2,32},{-2.2,32}},              color = {0, 0, 255}));
    connect(plug_p, Plug_a2.plug_p) annotation (Line(points={{-100,60},{-68,60},{-68,20},
            {-36.2,20}}, color={0,0,255}));
  connect(PQ_Load5.pin_n, PQ_Load4.pin_p) annotation(
    Line(points = {{-24, -22}, {-14, -22}, {-14, 0}, {10, 0}, {10, -4}, {10, -4}}, color = {0, 0, 255}));
  connect(PQ_Load4.pin_n, PQ_Load3.pin_p) annotation(
    Line(points = {{10, -22}, {20, -22}, {20, 0}, {52, 0}, {52, -4}, {52, -4}, {52, -4}}, color = {0, 0, 255}));
  connect(PQ_Load3.pin_n, PQ_Load5.pin_p) annotation(
    Line(points = {{52, -22}, {52, -22}, {52, -34}, {-52, -34}, {-52, 0}, {-24, 0}, {-24, -4}, {-24, -4}}, color = {0, 0, 255}));
  connect(Plug_a2.pin_p, PQ_Load5.pin_p) annotation(
    Line(points = {{-32, 20}, {-24, 20}, {-24, -4}, {-24, -4}}, color = {0, 0, 255}));
  connect(Plug_b2.pin_p, PQ_Load4.pin_p) annotation(
    Line(points = {{2, 32}, {10, 32}, {10, -4}, {10, -4}}, color = {0, 0, 255}));
  connect(Plug_c2.pin_p, PQ_Load3.pin_p) annotation(
    Line(points = {{30, 40}, {52, 40}, {52, -4}, {52, -4}}, color = {0, 0, 255}));
annotation(
    Diagram(graphics = {Text(origin = {86, -1}, extent = {{-20, 7}, {20, -7}}, textString = "[ 1.73773 1.77224 1.71484]*2401.78
[385 385 385 ]*1e3
[220 220 220]*1e3")}));
end Load671D;
