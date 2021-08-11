within Dynawo.Electrical.Controls.Converters.BaseControls;

model IECWT4AMeasures

  import Modelica;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  /*Nominal Parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  /*Grid Measurement Parameters*/
  parameter Types.PerUnit Tpfilt "Time constant in active power measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.PerUnit Tqfilt "Time constant in reactive power measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  //parameter Types.PerUnit Tifilt "Time constant in current measurement filter" annotation(Dialog(group = "group", tab = "GridMeasurement"));
  //parameter Types.PerUnit dphimax "Maximum rate of change of frequency" annotation(Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.PerUnit Tufilt "Time constant in voltage measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.PerUnit Tffilt "Time constant in frequency measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  /*Operational Parameters*/
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in p.u (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput iWtRePu(start = -i0Pu.re * SystemBase.SnRef / SNom) "WTT active current phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10,-10}, {10,10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iWtImPu(start = -i0Pu.im * SystemBase.SnRef / SNom)"WTT reactive current phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10,-10}, {10,10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation =0)));
  Modelica.Blocks.Interfaces.RealInput uWtRePu(start = u0Pu.re) "WTT active voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10,-10}, {10,10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWtImPu(start = u0Pu.im) "WTT reactive voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10,-10}, {10,10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput fsysPu(start = 1) "Global power system grid frequency applied for frequency measurements because angles are calculated in the corresponding stationary reference frame" annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10,-10}, {10,10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput pWTCfiltPu(start = -(u0Pu.re*i0Pu.re + u0Pu.im*i0Pu.im) * SystemBase.SnRef / SNom) "Filtered WTT active power (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {110, 82.5}, extent = {{-10,-10}, {10,10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput qWTCfiltPu(start = -(u0Pu.im*i0Pu.re - u0Pu.re*i0Pu.im) * SystemBase.SnRef / SNom) "Filtered WTT reactive power (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {110, 50}, extent = {{-10,-10}, {10,10}}, rotation = 0), iconTransformation(origin = {110, -82.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uWTCPu(start = sqrt(u0Pu.re*u0Pu.re + u0Pu.im*u0Pu.im)) "WTT voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {110, 17.5}, extent = {{-10,-10}, {10,10}}, rotation = 0), iconTransformation(origin = {110, 82.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uWTCfiltPu(start = sqrt(u0Pu.re*u0Pu.re + u0Pu.im*u0Pu.im)) "Filtered WTT voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {110, -17.5}, extent = {{-10,-10}, {10,10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {110, -50}, extent = {{-10,-10}, {10,10}}, rotation = 0), iconTransformation(origin = {110, -17.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ffiltPu(start = 1) "Filtered global power system grid frequency applied for frequency measurements because angles are calculated in the corresponding stationary reference frame" annotation(
    Placement(visible = true, transformation(origin = {110, -82.5}, extent = {{-10,-10}, {10,10}}, rotation = 0), iconTransformation(origin = {110, 17.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Blocks*/
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = Tpfilt, y_start = -(u0Pu.re * i0Pu.re + u0Pu.im * i0Pu.im) * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {60, 82.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = Tqfilt, y_start = -(u0Pu.im * i0Pu.re - u0Pu.re * i0Pu.im) * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = Tufilt, y_start = sqrt(u0Pu.re * u0Pu.re + u0Pu.im * u0Pu.im)) annotation(
    Placement(visible = true, transformation(origin = {60, -17.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {10, 82.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {60, -82.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-40, 85}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-40, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {-40, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product3 annotation(
    Placement(visible = true, transformation(origin = {-40, -5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.RectangularToPolar rectangularToPolar1 annotation(
    Placement(visible = true, transformation(origin = {-40, -44}, extent = {{-10,-10}, {10,10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = Tffilt, k = 1 / SystemBase.omegaNom, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {10, -67.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(firstOrder1.y, qWTCfiltPu) annotation(
    Line(points = {{71, 50}, {110, 50}}, color = {0, 0, 127}));
  connect(add1.y, firstOrder2.u) annotation(
    Line(points = {{21, 82.5}, {48, 82.5}}, color = {0, 0, 127}));
  connect(add2.y, firstOrder1.u) annotation(
    Line(points = {{21, 50}, {48, 50}}, color = {0, 0, 127}));
  connect(add.y, ffiltPu) annotation(
    Line(points = {{72, -82}, {102, -82}, {102, -82}, {110, -82}}, color = {0, 0, 127}));
  connect(firstOrder2.y, pWTCfiltPu) annotation(
    Line(points = {{72, 82}, {102, 82}, {102, 82}, {110, 82}}, color = {0, 0, 127}));
  connect(product.y, add1.u1) annotation(
    Line(points = {{-28, 86}, {-22, 86}, {-22, 88}, {-2, 88}, {-2, 88}}, color = {0, 0, 127}));
  connect(product2.y, add2.u1) annotation(
    Line(points = {{-28, 26}, {-16, 26}, {-16, 56}, {-2, 56}, {-2, 56}}, color = {0, 0, 127}));
  connect(product3.y, add2.u2) annotation(
    Line(points = {{-28, -4}, {-10, -4}, {-10, 44}, {-2, 44}, {-2, 44}}, color = {0, 0, 127}));
  connect(iWtRePu, product.u1) annotation(
    Line(points = {{-110, 80}, {-88, 80}, {-88, 92}, {-52, 92}, {-52, 92}}, color = {0, 0, 127}));
  connect(uWtRePu, product.u2) annotation(
    Line(points = {{-110, 0}, {-84, 0}, {-84, 78}, {-52, 78}, {-52, 80}}, color = {0, 0, 127}));
  connect(iWtImPu, product1.u1) annotation(
    Line(points = {{-110, 40}, {-74, 40}, {-74, 62}, {-52, 62}, {-52, 62}}, color = {0, 0, 127}));
  connect(uWtImPu, product1.u2) annotation(
    Line(points = {{-110, -40}, {-68, -40}, {-68, 50}, {-52, 50}, {-52, 50}}, color = {0, 0, 127}));
  connect(uWtRePu, rectangularToPolar1.u_re) annotation(
    Line(points = {{-110, 0}, {-84, 0}, {-84, -38}, {-52, -38}}, color = {0, 0, 127}));
  connect(rectangularToPolar1.y_abs, firstOrder3.u) annotation(
    Line(points = {{-29, -38}, {14, -38}, {14, -18}, {48, -18}}, color = {0, 0, 127}));
  connect(firstOrder3.y, uWTCfiltPu) annotation(
    Line(points = {{72, -18}, {106, -18}, {106, -18}, {110, -18}}, color = {0, 0, 127}));
  connect(rectangularToPolar1.y_arg, theta) annotation(
    Line(points = {{-29, -50}, {110, -50}}, color = {0, 0, 127}));
  connect(uWtImPu, rectangularToPolar1.u_im) annotation(
    Line(points = {{-110, -40}, {-68, -40}, {-68, -50}, {-52, -50}, {-52, -50}}, color = {0, 0, 127}));
  connect(rectangularToPolar1.y_arg, derivative.u) annotation(
    Line(points = {{-28, -50}, {-16, -50}, {-16, -68}, {-2, -68}, {-2, -68}}, color = {0, 0, 127}));
  connect(derivative.y, add.u1) annotation(
    Line(points = {{22, -68}, {30, -68}, {30, -76}, {48, -76}, {48, -76}}, color = {0, 0, 127}));
  connect(fsysPu, add.u2) annotation(
    Line(points = {{-110, -80}, {-74, -80}, {-74, -90}, {48, -90}, {48, -88}}, color = {0, 0, 127}));
  connect(iWtRePu, product2.u1) annotation(
    Line(points = {{-110, 80}, {-88, 80}, {-88, 30}, {-52, 30}, {-52, 32}, {-52, 32}}, color = {0, 0, 127}));
  connect(uWtImPu, product2.u2) annotation(
    Line(points = {{-110, -40}, {-68, -40}, {-68, 18}, {-52, 18}, {-52, 20}}, color = {0, 0, 127}));
  connect(iWtImPu, product3.u1) annotation(
    Line(points = {{-110, 40}, {-74, 40}, {-74, 0}, {-54, 0}, {-54, 2}, {-52, 2}}, color = {0, 0, 127}));
  connect(uWtRePu, product3.u2) annotation(
    Line(points = {{-110, 0}, {-80, 0}, {-80, -12}, {-52, -12}, {-52, -10}}, color = {0, 0, 127}));
  connect(rectangularToPolar1.y_abs, uWTCPu) annotation(
    Line(points = {{-28, -38}, {14, -38}, {14, 18}, {110, 18}, {110, 18}}, color = {0, 0, 127}));
  connect(product1.y, add1.u2) annotation(
    Line(points = {{-28, 56}, {-20, 56}, {-20, 76}, {-2, 76}, {-2, 76}}, color = {0, 0, 127}));

annotation(
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, initialScale = 0.1)),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {0, -25}, extent = {{-100, -20}, {100,20}}, textString = "Module"), Text(origin = {0,25}, extent = {{-100, -30}, {100, 30}}, textString = "Measurement")}));

end IECWT4AMeasures;
