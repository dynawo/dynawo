within Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters;

model EXAC1
  Modelica.Blocks.Interfaces.RealInput UGenPu annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu annotation(
    Placement(visible = true, transformation(origin = {-170, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UpssPu annotation(
    Placement(visible = true, transformation(origin = {-170, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-98, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput EfdPu annotation(
    Placement(visible = true, transformation(origin = {250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder UGenPuDelay(T = Tr, k = 1, y_start = UStator0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add dUGenPu(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k3 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction EfdPu_fb(a = {Tf, 1}, b = {Kf, 0}, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tr, k = 1, y_start = UStator0Pu) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {Tf, 1}, b = {Kf, 0}, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-20, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kd)  annotation(
    Placement(visible = true, transformation(origin = {68, -142}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Ifd annotation(
    Placement(visible = true, transformation(origin = {260, -142}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {96, -98}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add31 annotation(
    Placement(visible = true, transformation(origin = {30, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Ke)  annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {130, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain2(k = Kc)  annotation(
    Placement(visible = true, transformation(origin = {136, -116}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {176, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain RectifierDummy annotation(
    Placement(visible = true, transformation(origin = {144, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product EfdsatPu annotation(
    Placement(visible = true, transformation(origin = {76, -82}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds SatMod(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = Se, verboseExtrapolation = false) annotation(
    Placement(visible = true, transformation(origin = {118, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(UGenPuDelay.u, UGenPu) annotation(
    Line(points = {{-132, 0}, {-170, 0}}, color = {0, 0, 127}));
  connect(URefPu, dUGenPu.u1) annotation(
    Line(points = {{-170, 40}, {-100, 40}, {-100, 6}, {-92, 6}}, color = {0, 0, 127}));
  connect(UGenPuDelay.y, dUGenPu.u2) annotation(
    Line(points = {{-108, 0}, {-100, 0}, {-100, -6}, {-92, -6}}, color = {0, 0, 127}));
  connect(UpssPu, add3.u1) annotation(
    Line(points = {{-170, 80}, {-60, 80}, {-60, 8}, {-52, 8}}, color = {0, 0, 127}));
  connect(dUGenPu.y, add3.u2) annotation(
    Line(points = {{-68, 0}, {-52, 0}}, color = {0, 0, 127}));
  connect(add3.y, EfdPu_fb.u) annotation(
    Line(points = {{-28, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(firstOrder.u, EfdPu_fb.y) annotation(
    Line(points = {{18, 0}, {12, 0}}, color = {0, 0, 127}));
  connect(limiter.u, firstOrder.y) annotation(
    Line(points = {{48, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(add.u1, limiter.y) annotation(
    Line(points = {{86, 6}, {78, 6}, {78, 0}, {72, 0}}, color = {0, 0, 127}));
  connect(transferFunction.y, add3.u3) annotation(
    Line(points = {{-31, -50}, {-60, -50}, {-60, -8}, {-52, -8}}, color = {0, 0, 127}));
  connect(Ifd, gain.u) annotation(
    Line(points = {{260, -142}, {80, -142}}, color = {0, 0, 127}));
  connect(gain.y, add31.u3) annotation(
    Line(points = {{57, -142}, {57, -58}, {41, -58}}, color = {0, 0, 127}));
  connect(add31.y, transferFunction.u) annotation(
    Line(points = {{19, -50}, {-8, -50}}, color = {0, 0, 127}));
  connect(add.y, division.u1) annotation(
    Line(points = {{110, 0}, {114, 0}, {114, -46}, {124, -46}, {124, -38}}, color = {0, 0, 127}));
  connect(Ifd, gain2.u) annotation(
    Line(points = {{260, -142}, {136, -142}, {136, -128}}, color = {0, 0, 127}));
  connect(gain2.y, division.u2) annotation(
    Line(points = {{136, -105}, {136, -38}}, color = {0, 0, 127}));
  connect(add.y, product.u1) annotation(
    Line(points = {{110, 0}, {126, 0}, {126, 6}, {164, 6}}, color = {0, 0, 127}));
  connect(product.y, EfdPu) annotation(
    Line(points = {{188, 0}, {250, 0}}, color = {0, 0, 127}));
  connect(product.u2, RectifierDummy.y) annotation(
    Line(points = {{164, -6}, {160, -6}, {160, -4}, {156, -4}}, color = {0, 0, 127}));
  connect(RectifierDummy.u, division.y) annotation(
    Line(points = {{132, -4}, {130, -4}, {130, -14}}, color = {0, 0, 127}));
  connect(add.y, gain1.u) annotation(
    Line(points = {{110, 0}, {114, 0}, {114, -40}, {82, -40}}, color = {0, 0, 127}));
  connect(SatMod.y[1], EfdsatPu.u1) annotation(
    Line(points = {{107, -76}, {87, -76}}, color = {0, 0, 127}));
  connect(gain1.y, add31.u1) annotation(
    Line(points = {{60, -40}, {52, -40}, {52, -42}, {42, -42}}, color = {0, 0, 127}));
  connect(add.y, SatMod.u) annotation(
    Line(points = {{110, 0}, {114, 0}, {114, -58}, {148, -58}, {148, -76}, {130, -76}}, color = {0, 0, 127}));
  connect(add.y, EfdsatPu.u2) annotation(
    Line(points = {{110, 0}, {114, 0}, {114, -58}, {148, -58}, {148, -88}, {88, -88}}, color = {0, 0, 127}));
  connect(EfdsatPu.y, add31.u2) annotation(
    Line(points = {{66, -82}, {60, -82}, {60, -50}, {42, -50}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}})),
    Icon(coordinateSystem(extent = {{-150, -100}, {150, 100}})));
end EXAC1;
