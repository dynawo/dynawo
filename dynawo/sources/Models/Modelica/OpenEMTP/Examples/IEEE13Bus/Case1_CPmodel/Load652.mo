within OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel;

model Load652
  extends OpenEMTP.UserGuide.Icons.Load;

    Electrical.Load_Models.SP_PQ_Load Load652Z(
      P=128,
      QL=86,
      Series=true,
      V=4.16,
      f=60) annotation (Placement(visible=true, transformation(
          origin={-32, 28},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p
      annotation (Placement(visible = true, transformation(extent = {{45, 25}, {55, 35}}, rotation = 0), iconTransformation(origin = {1, 95}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  equation
    connect(pin_p, Load652Z.pin_p)
      annotation (Line(points={{50,30}, {9, 30}, {9, 28}, {-32, 28}}, color={238,46,47}));
    annotation (Diagram, Icon);

end Load652;
