within Dynawo.Examples.GridForming;

model VoltagePOI

  parameter Types.PerUnit Mq  "0.2 Reactive power droop control coefficient";
  parameter Types.PerUnit Wf  "Cutoff pulsation of the active and reactive filters (in rad/s)";

  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Rv "Gain of the active damping";
   parameter Types.PerUnit IdPcc0Pu=0 "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu=0 "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  

  Modelica.Blocks.Interfaces.RealInput idPccPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 46}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {20, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = 1 / Wf, k = 1, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-100, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {50, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Rv) annotation(
    Placement(visible = true, transformation(origin = {-50, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterRefPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {130, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilterRefPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {130, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = -Rv) annotation(
    Placement(visible = true, transformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback5 annotation(
    Placement(visible = true, transformation(origin = {80, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {-80, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = 1 / Wff, k = 1, y_start = Rv * IdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-18, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = Mq) annotation(
    Placement(visible = true, transformation(origin = {-50, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback7 annotation(
    Placement(visible = true, transformation(origin = {80, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = 1 / Wff, k = 1, y_start = -Rv * IqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-16, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVId(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVIq(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -168}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {26, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {22, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(DeltaVVId, feedback5.u2) annotation(
    Line(points = {{-130, -90}, {80, -90}, {80, -4}}, color = {0, 0, 127}));
  connect(add2.y, feedback4.u1) annotation(
    Line(points = {{31, 4}, {42, 4}}, color = {0, 0, 127}));
  connect(gain3.y, add2.u1) annotation(
    Line(points = {{-39, 10}, {8, 10}}, color = {0, 0, 127}));
  connect(gain1.y, firstOrder2.u) annotation(
    Line(points = {{-39, -70}, {-30, -70}}, color = {0, 0, 127}));
  connect(gain2.y, firstOrder3.u) annotation(
    Line(points = {{-39, -110}, {-28, -110}}, color = {0, 0, 127}));
  connect(gain1.u, idPccPu) annotation(
    Line(points = {{-62, -70}, {-130, -70}}, color = {0, 0, 127}));
  connect(gain2.u, iqPccPu) annotation(
    Line(points = {{-62, -110}, {-130, -110}}, color = {0, 0, 127}));
  connect(feedback5.y, udFilterRefPu) annotation(
    Line(points = {{89, 4}, {130, 4}}, color = {0, 0, 127}));
  connect(feedback3.u1, QRefPu) annotation(
    Line(points = {{-88, 10}, {-130, 10}}, color = {0, 0, 127}));
  connect(feedback3.y, gain3.u) annotation(
    Line(points = {{-71, 10}, {-62, 10}}, color = {0, 0, 127}));
  connect(DeltaVVIq, feedback7.u2) annotation(
    Line(points = {{-130, -130}, {80, -130}, {80, -118}}, color = {0, 0, 127}));
  connect(feedback7.y, uqFilterRefPu) annotation(
    Line(points = {{89, -110}, {130, -110}}, color = {0, 0, 127}));
  connect(feedback4.y, feedback5.u1) annotation(
    Line(points = {{59, 4}, {72, 4}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback3.u2) annotation(
    Line(points = {{-89, -20}, {-80, -20}, {-80, 2}}, color = {0, 0, 127}));
  connect(QFilterPu, firstOrder1.u) annotation(
    Line(points = {{-130, -20}, {-112, -20}}, color = {0, 0, 127}));
  connect(UFilterRefPu, add2.u2) annotation(
    Line(points = {{-130, -50}, {0, -50}, {0, -2}, {8, -2}}, color = {0, 0, 127}));
  connect(feedback.u2, gain1.y) annotation(
    Line(points = {{26, -78}, {26, -86}, {-38, -86}, {-38, -70}}, color = {0, 0, 127}));
  connect(feedback.y, feedback4.u2) annotation(
    Line(points = {{36, -70}, {50, -70}, {50, -4}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback.u1) annotation(
    Line(points = {{-6, -70}, {18, -70}}, color = {0, 0, 127}));
  connect(firstOrder3.y, feedback1.u1) annotation(
    Line(points = {{-5, -110}, {14, -110}}, color = {0, 0, 127}));
  connect(feedback1.y, feedback7.u1) annotation(
    Line(points = {{32, -110}, {72, -110}}, color = {0, 0, 127}));
  connect(gain2.y, feedback1.u2) annotation(
    Line(points = {{-38, -110}, {-36, -110}, {-36, -126}, {22, -126}, {22, -118}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, 20}, {140, -140}})),
    Icon(graphics = {Text(origin = {-168, 62}, extent = {{-46, 12}, {46, -12}}, textString = "QFilterPu"), Text(origin = {-160, 114}, extent = {{-42, 10}, {42, -10}}, textString = "QRefPu"), Text(origin = {-170, 163}, extent = {{-56, 15}, {56, -15}}, textString = "UFilterRefPu"), Text(origin = {-168, -6}, lineColor = {28, 113, 216}, extent = {{-46, 10}, {46, -10}}, textString = "idPccPu"), Text(origin = {-167, -45}, lineColor = {28, 113, 216}, extent = {{-45, 11}, {45, -11}}, textString = "iqPccPu"), Text(origin = {-161, -116}, extent = {{-41, 10}, {41, -10}}, textString = "DeltaVVId"), Text(origin = {-161, -156}, extent = {{-43, 10}, {43, -10}}, textString = "DeltaVVIq"), Text(origin = {183, 50}, lineColor = {129, 61, 156}, extent = {{-65, 26}, {65, -26}}, textString = "udFilterRefPu"), Text(origin = {185, -6}, lineColor = {97, 53, 131}, extent = {{-67, 26}, {67, -26}}, textString = "uqFilterRefPu"), Rectangle(extent = {{-100, 180}, {100, -180}}), Text(origin = {-1, 4}, extent = {{-73, 32}, {73, -32}}, textString = "VoltagePOI")}, coordinateSystem(extent = {{-100, -180}, {100, 180}})));
end VoltagePOI;